#!/usr/bin/env bash

function @bind() {
    if $besharp_oopRuntime_binds_collecting_enabled; then
        eval "besharp_oopRuntime_collected_binds_$(( besharp_oopRuntime_binds_collector_counter++ ))+=( \"\${@}\" )"
        return
    fi

    if ! $besharp_oopRuntime_binds_enabled; then
        return
    fi


    local source="${1:-}"
    local word1="${2:-}"
    local target="${3:-}"

    local orgBinding="${*}"

    function @bind.printError() {
        besharp.compiler.syntaxError "$(
          echo "Invalid binding. ${*}. "
          echo ""
          echo "Expected binding format for class:"
          echo "   @bind \"Type\" @with \"Subtype\" "
          echo "      [ @having constructor args "
          echo "            \"arg1\""
          echo "            \"arg2\""
          echo "             ....                  ]"
          echo ""
          echo "Expected binding format for field:"
          echo "   @bind \"Type.Field\" @with \"Subtype\" "
          echo "      [ @having constructor args "
          echo "            \"arg1\""
          echo "            \"arg2\""
          echo "             ....                  ]"
          echo ""
          echo "Got: "
          echo "    @bind ${orgBinding}"
        )"
    }

    if [[ -z "${source}" ]]; then
        @bind.printError "No \"Type\" provided"
    fi

    if [[ "${word1}" != "@with" ]]; then
        @bind.printError "Missing '@with' keyword"
    fi

    if [[ -z "${target}" ]]; then
        @bind.printError "No \"Subtype\" provided"
    fi

    shift 3

    if [[ "${source#@}" != "${source}" ]]; then
        besharp.compiler.oop.compileAccessor "${source}" "${target}"
        return 0
    fi


    if [[ -n "${1:-}" ]]; then
        if [[ "${1:-} ${2:-} ${3:-}" != "@having constructor args" ]]; then
            @bind.printError "Missing '@having constructor args' phrase"
        fi

        shift 3
    fi

    besharp.oopRuntime.setupDiBinding "${source}" "${target}" "${@}"
}
