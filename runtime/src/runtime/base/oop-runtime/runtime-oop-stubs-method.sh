#!/usr/bin/env bash

declare -ag besharp_oopRuntime_methodDetailsAssocFields=(
    _method_body
    _method_locals
    _method_is_returning
    _method_is_abstract
    _method_is_using_iterators
    _method_is_calling_parent
    _method_is_calling_this
)

function besharp.oopRuntime.debugType() {
    local type="${1}"

    local args=()
    args+=(
        "besharp_oopRuntime_type_${type}_all_methods"
        "besharp_oopRuntime_type_${type}_all_abstract_methods"
        "besharp_oopRuntime_type_${type}_all_abstract_method_origins"
        "besharp_oopRuntime_type_${type}_all_methods_parent_callback"
        "besharp_oopRuntime_type_${type}_all_method_callbacks"
        "besharp_oopRuntime_type_${type}_all_method_deinitializers"
        "besharp_oopRuntime_type_${type}_all_method_stubs"
        "besharp_oopRuntime_type_${type}_all_method_instance_stubs"
    )

    local field
    for field in "${besharp_oopRuntime_methodDetailsAssocFields[@]}"; do
        args+=( "besharp_oopRuntime_type_${type}${field}" )
    done

    d "${args[@]}"
}

function besharp.oopRuntime.generateMethodStubs() {
    local type="${1}"

    local parentType="${besharp_oop_type_parent[${type}]}"

    # todo: consider moving to compilation time
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_methods"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_abstract_methods"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_abstract_method_origins"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_methods_parent_callback"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_method_callbacks"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_method_deinitializers"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_method_stubs"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_method_instance_stubs"
    local field
    for field in "${besharp_oopRuntime_methodDetailsAssocFields[@]}"; do
        besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}${field}"
    done

    besharp.oopRuntime.generateConstructorCallbacks "${type}" "${parentType}"

    if [[ -n "${parentType}" ]]; then
        local parentMethod
        local parentCallback

        eval "for parentMethod in \"\${besharp_oopRuntime_type_${parentType}_all_methods[@]}\"; do besharp.oopRuntime.generateMethodList \"\${type}\" \"\${parentType}\" \"\${parentMethod}\"; done"

        eval "for parentMethod in \"\${besharp_oopRuntime_type_${parentType}_all_methods[@]}\"; do besharp.oopRuntime.cloneMethodDetails \"\${type}\" \"\${parentType}\" \"\${parentMethod}\"; done"

        eval "for parentMethod in \"\${besharp_oopRuntime_type_${parentType}_all_methods[@]}\"; do besharp.oopRuntime.generateMethodCallbacks \"\${type}\" \"\${parentMethod}\" \"\${besharp_oopRuntime_type_${parentType}_all_method_callbacks[\${parentMethod}]}\"; done"

        eval "for parentMethod in \"\${besharp_oopRuntime_type_${parentType}_all_abstract_methods[@]}\"; do besharp.oopRuntime.overrideAbstractMethodList \"\${type}\" \"\${parentMethod}\" \"\${besharp_oopRuntime_type_${parentType}_all_abstract_method_origins[\${parentMethod}]}\"; done"
    fi

    local method
    eval "for method in \"\${besharp_oop_type_${type}_methods[@]}\"; do besharp.oopRuntime.generateMethodList \"\${type}\" \"\${parentType}\" \"\${method}\"; done"

    eval "for method in \"\${besharp_oop_type_${type}_methods[@]}\"; do besharp.oopRuntime.cloneMethodDetails \"\${type}\" \"\${type}\" \"\${method}\"; done"

    eval "for method in \"\${besharp_oop_type_${type}_methods[@]}\"; do besharp.oopRuntime.generateAbstractMethodList \"\${type}\" \"\${method}\"; done"

    eval "for method in \"\${besharp_oop_type_${type}_methods[@]}\"; do besharp.oopRuntime.generateMethodCallbacks \"\${type}\" \"\${method}\" \"${type}.\${method}\"; done"

    eval "for method in \"\${besharp_oop_type_${type}_methods[@]}\"; do besharp.oopRuntime.generateMethodStub \"\${type}\" \"\${method}\"; done"

    eval "for method in \"\${besharp_oopRuntime_type_${type}_all_methods[@]}\"; do besharp.oopRuntime.generateMethodInstanceStub \"\${type}\" \"\${method}\" \"\${besharp_oopRuntime_type_${type}_all_method_callbacks[\"\${method}\"]}\"; done"

    eval "for method in \"\${besharp_oopRuntime_type_${type}_all_methods[@]}\"; do besharp.oopRuntime.generateMethodDeinitializers \"\${type}\" \"\${method}\" \"\${besharp_oopRuntime_type_${type}_all_method_callbacks[\"\${method}\"]}\"; done"


#    # debug section
#    local debugTypes=()
#    debugTypes=( ArrayVector )
#    local debugType
#    for debugType in "${debugTypes[@]}"; do
#        if [[ "${type}" == "${debugType}" ]]; then
#            besharp.oopRuntime.debugType "${type}"
#        fi
#    done
}

function besharp.oopRuntime.generateMethodList() {
    local type="${1}"
    local parentType="${2}"
    local method="${3}"

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_methods[${method}]='${method}'"
}

function besharp.oopRuntime.cloneMethodDetails() {
    local toType="${1}"
    local fromType="${2}"
    local fromMethod="${3}"
    local toMethod="${3:-}"

    if [[ "${fromType}" == "${fromMethod}" ]]; then
        toMethod="${toType}"
    fi

    local field
    for field in "${besharp_oopRuntime_methodDetailsAssocFields[@]}"; do
        if [[ -z "${field}" ]]; then
            continue
        fi

        besharp.oopRuntime.generateLinkerLine "
            if [[ 'isset' == \"\${besharp_oop_type_${fromType}${field}[${fromMethod}]+isset}\" ]]; then
                  besharp_oopRuntime_type_${toType}${field}[${toMethod}]=\"\${besharp_oop_type_${fromType}${field}[${fromMethod}]}\";
            elif [[ 'isset' == \"\${besharp_oopRuntime_type_${fromType}${field}[${fromMethod}]+isset}\" ]]; then
                  besharp_oopRuntime_type_${toType}${field}[${toMethod}]=\"\${besharp_oopRuntime_type_${fromType}${field}[${fromMethod}]}\";
            fi
        "
    done
}

function besharp.oopRuntime.generateAbstractMethodList() {
    local type="${1}"
    local method="${2}"

    if eval "[[ \"\${besharp_oop_type_${type}_method_is_abstract[@]+isset}\" == 'isset' ]] \\
          &&  [[ \"\${besharp_oop_type_${type}_method_is_abstract[${method}]+isset}\" == 'isset' ]]";
    then
        besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_abstract_methods[${method}]='${method}'"
        besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_abstract_method_origins[${method}]='${type}'"
    fi
}

function besharp.oopRuntime.overrideAbstractMethodList() {
    local type="${1}"
    local method="${2}"
    local originType="${3}"

    if ! eval "[[ \"\${besharp_oop_type_${type}_methods[@]+isset}\" == 'isset' ]] \\
          &&  [[ \"\${besharp_oop_type_${type}_methods[${method}]+isset}\" == 'isset' ]]";
    then
        besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_abstract_methods[${method}]='${method}'"
        besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_abstract_method_origins[${method}]='${originType}'"
    fi
}

function besharp.oopRuntime.generateConstructorCallbacks() {
    local type="${1}"
    local parentType="${2}"

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_methods_parent_callback['${type}']='${parentType}'"
    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_method_callbacks['${type}']='${type}'"
}

function besharp.oopRuntime.generateMethodCallbacks() {
    local type="${1}"
    local method="${2}"
    local callback="${3}"

    if [[ "${type}" == "${method}" ]]; then
        return
    fi

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_methods_parent_callback[${method}]=\"\${besharp_oopRuntime_type_${type}_all_method_callbacks[${method}]:-}\""
    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_method_callbacks[${method}]='${callback}'"
}

function besharp.oopRuntime.generateMethodStub() {
    local type="${1}"
    local method="${2}"

    if [[ "${type}" == "${method}" ]]; then
        local callback="${type}"
    else
        local callback="${type}.${method}"
    fi

    local callingParent=false
    if besharp.oopRuntime.isMethodCallingParent "${type}" "${method}"; then
        callingParent=true
    fi


    local body
    besharp.oopRuntime.generateMethodStubBody \
        "${type}" \
        "${method}" \
        "${callback}" \
        "" \
        "${callingParent}" \
    ;

    local funcDefinition=\
"function besharpstub.${callback}() {
    ${body}
}
"
     besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_method_stubs[${method}]=\"\${funcDefinition}\""
}

function besharp.oopRuntime.generateMethodInstanceStub() {
    local type="${1}"
    local method="${2}"
    local callback="${3}"

    if besharp.oopRuntime.isMethodCallingParent "${type}" "${method}"; then
        local funcDefinition=\
"function object_code.${method} {
    local this=\"object_code\"
    besharpstub.${callback} \"\${@}\"
}
"
    else
        local body
        if besharp.oopRuntime.isMethodCallingThis "${type}" "${method}"; then
            besharp.oopRuntime.generateMethodStubBody \
                "${type}" \
                "${method}" \
                "${callback}" \
                "this=\"object_code\"" \
                "false" \
            ;
        else
            besharp.oopRuntime.generateMethodStubBody \
                "${type}" \
                "${method}" \
                "${callback}" \
                "" \
                "false" \
            ;
        fi

        local funcDefinition=\
"function object_code.${method} {
    ${body}
}
"
    fi

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_method_instance_stubs[${method}]=\"\${funcDefinition}\""
}

function besharp.oopRuntime.generateMethodStubBody() {
    local type="${1}"
    local method="${2}"
    local callback="${3}"
    local customLocalDef="${4:-}"
    local usingParentCall="${5:-true}"

    local iteratorsBodyBefore=
    local iteratorsBodyAfter=
    if eval "\${besharp_oopRuntime_type_${type}_method_is_using_iterators[\"${method}\"]:-false}"; then
        iteratorsBodyBefore=\
"
    unset \"besharp_runtime_current_iterator_keys__stack_\${besharp_rcsl}\"
    declare -a \"besharp_runtime_current_iterator_keys__stack_\${besharp_rcsl}\"
    unset \"besharp_runtime_current_iterator_of__stack_\${besharp_rcsl}\"
    declare -a \"besharp_runtime_current_iterator_of__stack_\${besharp_rcsl}\"
"

        iteratorsBodyAfter=\
"
    local iterators=\"besharp_runtime_current_iterator__stack_\${besharp_rcsl}\"[@]
    local iterator
    for iterator in \${!iterators:-}; do
        unset \"\${iterator}\"
    done

    unset \"besharp_runtime_current_iterator__stack_\${besharp_rcsl}\"
    unset \"besharp_runtime_current_iterator_keys__stack_\${besharp_rcsl}\"
    unset \"besharp_runtime_current_iterator_of__stack_\${besharp_rcsl}\"
    unset \"besharp_rcrvs[ besharp_rcsl + 1 ]\"
"
    fi

    local localParentCallback=
    if $usingParentCall; then
        local parentCallback
        eval "parentCallback=\${besharp_oopRuntime_type_${type}_all_methods_parent_callback[${method}]}"
        localParentCallback="besharp_pm='${parentCallback}'"
    fi

    local locals
    eval "locals=\"\${besharp_oopRuntime_type_${type}_method_locals[${method}]:-}\""


    if besharp.oopRuntime.isMethodEmbedded "${type}" "${method}"; then
        eval "local methodBody=\"\${besharp_oopRuntime_type_${type}_method_body[${method}]:-}\""
    else
        local methodBody="${callback} \"\${@}\""
    fi

    local localPrefix=
    if [[ -n "${customLocalDef}" ]] || [[ -n "${localParentCallback}" ]]; then
        localPrefix='local'
    fi

    body=\
"
    ${localPrefix} ${customLocalDef} ${localParentCallback}
    ${locals}

    (( ++besharp_rcsl ))

    ${iteratorsBodyBefore}

    ${methodBody}

    ${iteratorsBodyAfter}

    (( --besharp_rcsl ))
"
}

function besharp.oopRuntime.isMethodEmbedded() {
    ! eval "\${besharp_oopRuntime_type_${type}_method_is_returning[\"${method}\"]:-true}"
}

function besharp.oopRuntime.isMethodEmbedded__develop() {
    false
}

function besharp.oopRuntime.generateMethodDeinitializers() {
    local type="${1}"
    local method="${2}"
    local callback="${3}"

    local deinitializerBody=\
"unset -f object_code.${method}
"
    eval "besharp_oopRuntime_type_${type}_all_method_deinitializers[${method}]=\"\${deinitializerBody}\""
}

function besharp.oopRuntime.isMethodCallingParent() {
    local type="${1}"
    local method="${2}"

    eval "\${besharp_oopRuntime_type_${type}_method_is_calling_parent[${method}]:-false}"
}

function besharp.oopRuntime.isMethodCallingThis() {
    local type="${1}"
    local method="${2}"

    eval "\${besharp_oopRuntime_type_${type}_method_is_calling_this[${method}]:-false}"
}
