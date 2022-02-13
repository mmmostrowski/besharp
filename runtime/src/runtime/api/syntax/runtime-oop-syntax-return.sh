#!/usr/bin/env bash

function @returning() {
    if [[ "${1}" == "@of" ]] && [[ "${2+isset}" == 'isset' ]]; then
        shift
        # field or method
        "${@}"
        besharp_rcrvs[ besharp_rcsl ]="${besharp_rcrvs[ besharp_rcsl + 1 ]}"
    else
        besharp_rcrvs[ besharp_rcsl ]="${1}"
    fi
}

function @returning__develop() {
    if [[ "${1}" == "@of" ]] && [[ "${2+isset}" == 'isset' ]]; then
        shift
        # field or method
        "${@}"

        if [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]+isset}" != 'isset' ]]; then
            besharp.runtime.error "@returning @of cannot pass down the value! Are you @returning any value?"
        fi

        besharp_rcrvs[ besharp_rcsl ]="${besharp_rcrvs[ besharp_rcsl + 1 ]}"
    else
        besharp_rcrvs[ besharp_rcsl ]="${1}"
    fi
}

function @returned() {
    local args=( "${@}" )

    if [[ "${args[0]:-}" != '@of' ]]; then
        besharp.compiler.syntaxError "Expected syntax: @returned @of {operation} {operator} {value}. E.x. @returned @of \$this.field == 'value'"
    fi

    unset "args[0]"

    local operator="${args[-2]}"
    case ${operator} in
        '@eq'):;;
        '@ne'):;;
        '@lt'):;;
        '@le'):;;
        '@gt'):;;
        '@ge'):;;
         '=='):;;
          '='):;;
         '!='):;;
          '<'):;;
          '>'):;;
         '=~'):;;
          *) besharp.compiler.syntaxError "@returned unsupported operator: '${operator}'. Available operators: ==, !=, <, >, =, =~, @eq, @ne, @lt, @le, @gt, @ge";;
    esac

    local value="${args[-1]}"
    unset "args[${#args[@]}]"
    unset "args[${#args[@]}]"

    "${args[@]}"

    if [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]+isset}" != "isset" ]]; then
        besharp.compiler.syntaxError "@let couldn't find any results. Did you @return any value?"
    fi

    case ${operator} in
        '@eq') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" -eq "${value}" ]];;
        '@ne') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" -ne "${value}" ]];;
        '@lt') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" -lt "${value}" ]];;
        '@le') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" -le "${value}" ]];;
        '@gt') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" -gt "${value}" ]];;
        '@ge') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" -ge "${value}" ]];;
         '==') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" == "${value}" ]];;
          '=') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" = "${value}" ]];;
         '!=') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" != "${value}" ]];;
          '<') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" < "${value}" ]];;
          '>') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" > "${value}" ]];;
         '=~') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" =~ ${value} ]];;
          *) besharp.compiler.syntaxError "@returned unsupported operator: ${operator}. Available operators: ==, !=, <, >, =, =~, -eq, -ne, -lt, -le, -gt, -ge";;
    esac

}
