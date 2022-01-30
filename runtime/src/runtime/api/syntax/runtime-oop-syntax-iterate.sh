#!/usr/bin/env bash

function @iterate() {
    local args=( "${@}" )

    if [[ "${args[@]+isset}" != "isset" ]]; then
        besharp.compiler.syntaxError "@iterate must be in form: @iterate <Iterable>|[array arguments] @in <variable>! Got: ${*}"
    fi

    if [[ "${args[1]+isset}" != "isset" ]]; then
        besharp.compiler.syntaxError "@iterate must be in form: @iterate <Iterable>|[array arguments] @in <variable>! Got: ${*}"
    fi

    local targetLocalVar="${args[-1]}"
    local word2="${args[-2]}"

    if [[ "${word2}" != "@in" ]]; then
        besharp.compiler.syntaxError "@iterate must be in form: @iterate <Iterable>|[array arguments] @in <variable>! Got: ${*}"
    fi

    unset "args[${#args[@]}-1]"
    unset "args[${#args[@]}-1]"

    if [[ "${args[@]+isset}" != "isset" ]]; then
        return 1
    fi

    if [[ "${args[0]}" == '@of' ]]; then
        unset "args[0]"
        if besharp.oopRuntime.invokeIterationOf "${targetLocalVar}" "${args[@]}"; then
            return 0
        else
            return 1
        fi
    elif [[ "${args[0]}" == '@array' ]]; then
        unset "args[0]"
        if besharp.oopRuntime.invokeArrayIteration "${targetLocalVar}" "${args[@]}"; then
            return 0
        else
            return 1
        fi
    elif [[ "${args[0]}" == '@iterable' ]]; then
        unset "args[0]"
        if besharp.oopRuntime.invokeIteration "${targetLocalVar}" "${args[1]}"; then
            return 0
        else
            return 1
        fi
    elif besharp.rtti.isA "${args[0]}" Iterable; then
        if besharp.rtti.isA "${args[1]:-}" Iterable; then
            besharp.runtime.error "You cannot @iterate array of Iterable objects! It's dangerous! Instead of array, please use another Iterable object. You can also use array dedicated syntax: @iterate @array [ array, goes, here] @in <variable>"
        fi

        if besharp.oopRuntime.invokeIteration "${targetLocalVar}" "${args[0]}"; then
            return 0
        else
            return 1
        fi
    fi

    besharp.oopRuntime.invokeArrayIteration "${targetLocalVar}" "${args[@]}"
}
