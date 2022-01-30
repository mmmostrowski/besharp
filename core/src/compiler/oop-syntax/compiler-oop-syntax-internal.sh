#!/usr/bin/env bash

function @internal() {
    local word1="${1:-}"
    local type="${2}"
    shift 1

    if [[ "${word1}" == "@class" ]]; then
        besharp.compiler.oop.compileInternalType "${type}"
        @class "${@}"
    elif [[ "${word1}" == "@interface" ]]; then
        besharp.compiler.oop.compileInternalType "${type}"
        @interface "${@}"
    else
        besharp.compiler.syntaxError "'@internal' keyword must be followed by '@class' keyword! (Got: ${*})"
    fi

}
