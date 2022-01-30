#!/usr/bin/env bash

export besharp_syntax_current_class=''
export besharp_syntax_current_static=''

function @class() {
    local type="${1}"
    local word1="${2:-}"
    local word2="${3:-}"
    local word3="${4:-}"
    shift 1
    shift 1 || true
    shift 1 || true
    shift 1 || true

    if [[ -n "${besharp_syntax_current_class}" ]]; then
        besharp.compiler.syntaxError "Class ${type} cannot be opened before ${besharp_syntax_current_class} is closed by: @classdone"
    fi

    if [[ -n "${besharp_syntax_current_interface}" ]]; then
        besharp.compiler.syntaxError "Interface ${besharp_syntax_current_interface} must be closed by '@intdone' keyword before ${type} @class is opened"
    fi

    export besharp_syntax_current_class="${type}"

    if [[ "${word1}" == "" ]]; then
        besharp.compiler.oop.compileClassBegin "${type}"
    elif [[ "${word1}" == "@extends" ]] && [[ "${word3}" == "" ]]; then
        besharp.compiler.oop.compileClassBegin "${type}" "${word2}"
    elif [[ "${word1}" == "@extends" ]] && [[ "${word3}" == "@implements" ]]; then
        besharp.compiler.oop.compileClassBegin "${type}" "${word2}" "${@}"
    elif [[ "${word1}" == "@implements" ]]; then
        besharp.compiler.oop.compileClassBegin "${type}" "" "${word2}" "${word3}" "${@}"
    else
        besharp.compiler.syntaxError "keyword '@class' must meet pattern: @class ${type} [@extends <BaseType>] [@implements <Interface1> <Interface2> ...]"
    fi

    if [[ -n "${besharp_syntax_current_static}" ]]; then
        besharp.compiler.oop.compileStaticClass "${type}" "${besharp_syntax_current_static}"
        besharp_syntax_current_static=
    fi
}

function @classdone() {
    if [[ -z "${besharp_syntax_current_class}" ]]; then
        besharp.compiler.syntaxError "It seems that @class structure is broken. Expected '@class' keyword before '@classdone'!"
    fi

    besharp.compiler.oop.compileClassDone "${besharp_syntax_current_class}"

    export besharp_syntax_current_class=""
}

function @abstract() {
    local word1="${1:-}"

    if [[ "${word1}" == "@internal" ]]; then
        local word2="${2:-}"
        local type="${3:-}"

        if [[ "${word2}" != "@class" ]]; then
            besharp.compiler.syntaxError "Valid syntax: @abstract @internal @class ClassName. Got: ${*}"
        fi

        shift 2
        besharp.compiler.oop.compileInternalType "${type}"
        besharp.compiler.oop.compileAbstractType "${type}"
        @class "${@}"
    elif [[ "${word1}" == "@class" ]]; then
        local type="${2}"
        shift 1
        besharp.compiler.oop.compileAbstractType "${type}"
        @class "${@}"
    elif [[ "${word1}" == "function" ]]; then
        local method="${2}"
        besharp.compiler.oop.compileAbstractMethod "${besharp_syntax_current_class}" "${method}"
    else
        besharp.compiler.syntaxError "'@abstract' keyword must be followed by '@class', '@internal @class', or 'function'! (Got: ${*})"
    fi
}

function @var() {
    local word1="${1}"

    local metatags=()
    while [[ "${word1#@}" != "${word1}" ]]; do
        metatags+=( "${word1}" )
        shift 1
        word1="${1}"
    done

    local word2="${2:-}"
    local word3="${3:-}"
    local word4="${4:-}"

    local fieldName=''
    local type=''
    local defaultValue=''

    if [[ "${word2}" == '=' ]]; then
        fieldName="${word1}"
        defaultValue="${word3}"
    elif [[ "${word3}" == '=' ]]; then
        type="${word1}"
        fieldName="${word2}"
        defaultValue="${word4}"
    elif [[ -z "${word3}" ]] && [[ -z "${word4}" ]]; then
        if [[ -z "${word2}" ]]; then
            if [[ "${word1/=/}" != "${word1}" ]]; then
                local word1Arr=( ${word1/=/ } )
                fieldName="${word1Arr[0]}"
                defaultValue="${word1#${fieldName}=}"
            else
                fieldName="${word1}"
            fi
        elif [[ -z "${word3}" ]] && [[ "${word2/=/}" != "${word2}" ]]; then
            local word2Arr=( ${word2/=/ } )
            fieldName="${word2Arr[0]}"
            defaultValue="${word2#${fieldName}=}"
            type="${word1}"
        else
            type="${word1}"
            fieldName="${word2}"
        fi
    else
        besharp.compiler.syntaxError "In ${besharp_syntax_current_class} class: @var must be in form: @var [Type] name [= value ]. Got: \"${*}\""
    fi

    if [[ -n "${type}" ]] && [[ -n "${defaultValue}" ]]; then
        besharp.compiler.syntaxError "Field '@var ${type} ${fieldName}' in @class '${besharp_syntax_current_class}' cannot have default values!"
    fi

    besharp.compiler.oop.compileField "${besharp_syntax_current_class}" "${fieldName}" "${type}" "${defaultValue}" "${metatags[@]}"
}

function @static() {
  local args=( "${@}" )

  if [[ -n "${besharp_syntax_current_class}" ]]; then
      besharp.compiler.syntaxError "You cannot use @static inside class ${besharp_syntax_current_class}! Got: @static \"${*}\""
  fi

  if [[ -n "${besharp_syntax_current_static}" ]]; then
      besharp.compiler.syntaxError "@static { ${besharp_syntax_current_static} } overlay with: @static \"${*}\""
  fi

  if [[ "${args[0]}" != '{' ]] || [[ "${args[-1]}" != '}' ]] || [[ ${#args[@]} -lt 3 ]]; then
      besharp.compiler.syntaxError "Invalid @static definition. To make class static and available under @mything, directive must be in a form of: @static { @mything }. Got: @static \"${*}\""
  fi

  local accessor="${2}"
  if [[ "${accessor#@}" == "${accessor}" ]]; then
      besharp.compiler.syntaxError "@static must be in form of: @static { @mything }. Got: @static \"${*}\""
  fi

  besharp_syntax_current_static="${accessor}"
}