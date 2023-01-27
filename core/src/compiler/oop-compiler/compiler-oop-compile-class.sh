#!/usr/bin/env bash

export besharp_compile_current_functions_list=''
declare -Ag besharp_compiler_detected_type_is_abstract

function besharp.compiler.oop.compileInternalType() {
    local type="${1}"

    besharp.compiler.writeToMetaOutput "besharp_oop_type_internal[\"${type}\"]='true'"
}

function besharp.compiler.oop.compileStaticClass() {
    local type="${1}"
    local accessor="${2}"

    besharp.compiler.writeToMetaOutput "besharp_oop_type_static[\"${type}\"]='${type}'"
    besharp.compiler.writeToMetaOutput "besharp_oop_type_static_accessor[\"${type}\"]='${accessor}'"
}

function besharp.compiler.oop.compileAbstractType() {
    local type="${1}"

    besharp.compiler.writeToMetaOutput "besharp_oop_type_abstract[\"${type}\"]='true'"
    besharp_compiler_detected_type_is_abstract["${type}"]=true
}

function besharp.compiler.oop.compileClassBegin() {
    local type="${1}"
    local parentType="${2:-}"
    shift 1
    shift 1 || true

    besharp.compiler.oop.compileType "${type}" "class"
    besharp.compiler.oop.compileTypeInterfaces "${type}" "${@}"


    if [[ "${type}" == "${parentType}" ]]; then
        besharp.compiler.syntaxError "You cannot extend '${type}' @class from itself!"
    fi

    if [[ -z "${parentType}" ]] && [[ "${type}" != 'Object' ]]; then
        parentType="Object"
    fi

    besharp.compiler.writeToMetaOutput "besharp_oop_classes[\"${type}\"]=\"${type}\""
    besharp.compiler.writeToMetaOutput "besharp_oop_type_parent[\"${type}\"]=\"${parentType}\""

    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_fields"
    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_injectable_fields"
    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_field_type"
    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_field_default"
    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_methods"

    # todo: consider using ${besharp_oopRuntime_methodDetailsAssocFields[@]}
    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_method_body"
    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_method_locals"
    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_method_is_returning"
    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_method_is_abstract"
    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_method_is_using_iterators"
    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_method_is_calling_parent"
    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_method_is_calling_this"

    besharp_compile_current_functions_list="$( declare -F )"
}

function besharp.compiler.oop.compileClassDone() {
    local type="${1}"

    if ! declare -f "${type}" > /dev/null 2> /dev/null; then
        eval "function ${type}() { @parent \"\${@}\"; }"
    fi

    besharp.compiler.oop.compileMethods "${type}"
}

function besharp.compiler.oop.compileMethods() {
    local type="${1}"

    local line
    local firstLine=true
    while read line; do
        local item="${line#declare -f }"
        if [[ "${item}" == "${line}" ]]; then
            continue
        fi

        local method="${item#${type}}"
        if [[ "${method}" == "${item}" ]]; then
            besharp.compiler.syntaxError "All methods in ${type} class must have '${type}.' prefix! Got: ${item}"
        fi
        besharp.compiler.oop.compileMethod "${type}" "${method:-${type}}"
    done<<<"$( comm -13 \
        <( echo "${besharp_compile_current_functions_list}" ) \
        <( declare -F ) || true
    )"
}

function besharp.compiler.oop.compileMethod() {
    local type="${1}"
    local method="${2}"

    besharp.compiler.oop.compileMethodBasics "${type}" "${method}"

    method="${method#.}"

    local originalMethodBody
    local methodBody
    local fullMethodName
    if [[ "${type}" == "${method}" ]]; then
        fullMethodName="${type}" # constructor
        originalMethodBody="$( declare -f "${type}" 2> /dev/null || true )"
    else
        fullMethodName="${type}.${method}"
        originalMethodBody="$( declare -f "${fullMethodName}")"
    fi

    methodBody="${originalMethodBody}"
    besharp.compiler.oop.compileMethodBody "${type}" "${method}"

    local rawMethodBody
    rawMethodBody="$(  echo "${methodBody}" | tail -n +3 | head -n -1 )"

    if [[ -n "${methodBody}" ]]; then
        local letRegex="@let\s+\K([a-zA-Z_][a-zA-Z0-9_]*)\s+\="
        local whileRegex="while\s+@iterate.+@in\s+\K([a-zA-Z_][a-zA-Z0-9_]*)"

        local localVariables
        localVariables="$(
            echo "${originalMethodBody}" \
                | besharp.grepList -oP "(${letRegex})|(${whileRegex})" \
                | cut -d' ' -f1 \
                | sort \
                | uniq \
                | sed 's/^/local /g' \
            ;
        )"

        local isReturning=false
        if [[ "${originalMethodBody}" =~ 'return' ]]; then # either 'return' or '@returning'
            isReturning=true
        fi

        besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_method_is_returning[\"${method}\"]=${isReturning}"
        besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_method_body[\"${method}\"]='${rawMethodBody//\'/\'\"\'\"\'}'"
        besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_method_locals[\"${method}\"]='${localVariables}'"

        local usingIterators=false
        if echo "${originalMethodBody}" | besharp.grepMatch -E "while\s*@iterate"; then
            usingIterators=true
        fi
        besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_method_is_using_iterators[\"${method}\"]=${usingIterators}"

        local callingParent=false
        if echo "${originalMethodBody}" | besharp.grepMatch -E "@parent"; then
            callingParent=true
        fi
        besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_method_is_calling_parent[\"${method}\"]=${callingParent}"

        local usingThis=false
        if echo "${originalMethodBody}" | besharp.grepMatch -E '\$'"(this|{this})"; then
            usingThis=true
        fi
        besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_method_is_calling_this[\"${method}\"]=${usingThis}"
    fi

}

function besharp.compiler.oop.compileMethodBody() {
    local type="${1}"
    local method="${2}"

    # local methodBody
    # local originalMethodBody

    # optimize '@returning @of'
    methodBody="${methodBody//@returning @of /besharp.returningOf }"

    # optimize '@returning'
    methodBody="${methodBody//@returning /besharp_rcrvs[besharp_rcsl]=}"

    # optimize '@let local = $some.call'
    local foundAssignments=()
    readarray -t foundAssignments <<< "$(
        echo "${methodBody}" | grep -Eo '@let\s+([a-zA-Z_][a-zA-Z_0-9]*)\s+=' | sort | uniq
    )";

    local allLocalVars=""
    local localAssignment
    local localVarName
    for localAssignment in "${foundAssignments[@]}"; do
        if [[ -z "${localAssignment}" ]]; then
            continue
        fi

        localVarName="${localAssignment#@let }"
        localVarName="${localVarName% =}"

        besharp.compiler.writeToCodeOutput "$(
            echo "function __be__${localVarName}() {"
            echo "  \"\${@}\""
            echo "  ${localVarName}=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
            echo "}"
        )"

        allLocalVars="${allLocalVars}${localVarName} "
        methodBody="${methodBody//${localAssignment}/__be__${localVarName}}"
    done

    if [[ -n "${allLocalVars}" ]]; then
        methodBody="$(
            echo "${methodBody}" | head -n 2
            echo "    local ${allLocalVars};"
            echo "${methodBody}" | tail -n +3
        )"
    fi

    # optimize '@let $object.field = $some.call'
    local foundFieldAssignments=()
    readarray -t foundFieldAssignments <<< "$(
        echo "${methodBody}" | grep -Eo '@let\s+.*\$[a-zA-Z_]+\.[a-zA-Z_][a-zA-Z_0-9]*\s+=' | sort | uniq
    )";

    local localAssignment
    local localFieldName
    local localFunctionName
    for localAssignment in "${foundFieldAssignments[@]}"; do
        if [[ -z "${localAssignment}" ]]; then
            continue
        fi

        localFieldName="${localAssignment#@let }"
        localFieldName="${localFieldName% =}"

        localFunctionName="${localFieldName//./_}"
        localFunctionName="${localFunctionName//\$/_}"

        localFieldName="${localFieldName//./\"_}"

        besharp.compiler.writeToCodeOutput "$(
            echo "function __be__${localFunctionName}() {"
            echo "  \"\${@}\""
            echo "  eval ${localFieldName}=\\\"\\\${besharp_rcrvs[besharp_rcsl + 1]}\\\"\""
            echo "}"
        )"

       methodBody="${methodBody//${localAssignment}/__be__${localFunctionName}}"
    done

    # redefine method in current scope
    eval "${methodBody}"
}

function besharp.compiler.oop.compileAbstractMethod() {
    local type="${1}"
    local method="${2}"

    besharp.compiler.oop.compileMethodBasics "${type}" "${method#${type}}"

    if ! ${besharp_compiler_detected_type_is_abstract[${type}]:-false}; then
        besharp.compiler.syntaxError "Cannot define @abstract method ${method} for non-abstract '${type}' class! Consider making ${type} @abstract !"
    fi

    besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_method_is_abstract[\"${method#${type}.}\"]='true'"
}

function besharp.compiler.oop.compileMethodBasics() {
    local type="${1}"
    local method="${2}"

    if [[ "${type}" == "${method}" ]]; then # constructor
        besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_methods['${type}']='${type}'"
    elif [[ "${method#.}" != "${method}" ]]; then
        method="${method#.}"
        besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_methods['${method}']='${method}'"
    else
        besharp.compiler.syntaxError "All methods in ${type} class must be in form: ${type}.methodName ! Got: ${type}${method}"
    fi
}

function besharp.compiler.oop.compileField() {
    local type="${1}"
    local field="${2}"
    local strongType="${3}"
    local defaultValue="${4}"
    shift 4

    if [[ "${field}" == "object_code" ]]; then
        besharp.compiler.syntaxError "Field name '${field}' is reserved! Please use other field name."
    fi

    besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_fields['${field}']='${field}'"

    if [[ -n "${strongType}" ]]; then
        besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_field_type['${field}']=\"${strongType}\""
    fi

    local meta=''
    for meta in "${@}"; do
        if [[ "${meta}" == "@inject" ]]; then
            if [[ -z "${strongType}" ]]; then
                besharp.compiler.syntaxError "You can only @inject typed fields! Please define type for ${type}.${field}!"
            fi

            besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_injectable_fields['${field}']='${field}'"
        fi
    done

    besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_field_default['${field}']=\"${defaultValue}\""
}

