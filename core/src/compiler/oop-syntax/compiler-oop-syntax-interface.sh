#!/usr/bin/env bash

export besharp_syntax_current_interface=''

function @interface() {
    local word1="${1}"
    local word2="${2:-}"
    shift 1
    shift 1 || true

    if [[ "${word1}" == "function" ]]; then
        if [[ "${word2//./}" == "${word2}" ]]; then
            besharp.compiler.syntaxError "Invalid method '${word2}' in '${type}'! Should be in form: @interface function ${type}.${word2}!"
        fi
        local methodArr=( ${word2//./ } )
        local method="${methodArr[1]}"

        besharp.compiler.oop.compileInterfaceMethod "${besharp_syntax_current_interface}" "${method}" "${@}"
        return 0
    fi

    if [[ -n "${besharp_syntax_current_interface}" ]]; then
        besharp.compiler.syntaxError "Interface ${word1} cannot be opened before ${besharp_syntax_current_interface} is closed by '@intdone' keyword"
    fi

    if [[ -n "${besharp_syntax_current_class}" ]]; then
        besharp.compiler.syntaxError "Class ${besharp_syntax_current_class} must be closed by '@classdone' keyword before ${word1} @interface is opened"
    fi

    export besharp_syntax_current_interface="${word1}"

    if [[ "${word2}" == "" ]]; then
        besharp.compiler.oop.compileInterface "${word1}"
    elif [[ "${word2}" == "@implements" ]]; then
        besharp.compiler.oop.compileInterface "${word1}" "${@}"
    else
          besharp.compiler.syntaxError "keyword '@interface' must be followed by interface name, and optionally by '@implements' keyword followed by list of interfaces it derives from (given: @interface ${word1} ${word2} ${*})"
    fi
}

function @intdone() {
    if [[ -z "${besharp_syntax_current_interface}" ]]; then
        besharp.compiler.syntaxError "It seems that @interface structure is broken. Expected '@interface' before '@intdone'!"
    fi

    export besharp_syntax_current_interface=""
}

