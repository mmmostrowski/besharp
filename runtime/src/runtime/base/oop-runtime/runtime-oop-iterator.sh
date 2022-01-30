#!/usr/bin/env bash

export besharp_runtime_reset_iteration=0
declare -axg besharp_runtime_current_iterator_keys__stack_x=()
declare -axg besharp_runtime_current_iterator__stack_x=()
declare -axg besharp_runtime_current_iterator_of__stack_x=()

function besharp.oopRuntime.invokeIteration() {
    local targetLocalVar="${1}"
    local iterable="${2}"

    local __besharp_iterator_position_in_a_method
    besharp.fastCall.toArrayOfTokens __besharp_iterator_position_in_a_method caller 2

    besharp.oopRuntime.invokeIterationLoop
}

function besharp.oopRuntime.invokeIterationOf() {
    local targetLocalVar="${1}"
    local iterable="${2}"
    shift 2

    local __besharp_iterator_position_in_a_method
    besharp.fastCall.toArrayOfTokens __besharp_iterator_position_in_a_method caller 2

    local iterationOf
    eval "iterationOf=\${besharp_runtime_current_iterator_of__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]:-}"

    if [[ -z "${iterationOf}" ]]; then
        @let iterable = "${args[@]}"
        eval "besharp_runtime_current_iterator_of__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]=${iterable}"
    else
        iterable="${iterationOf}"
    fi

    besharp.oopRuntime.invokeIterationLoop
}

function besharp.oopRuntime.invokeIterationLoop()
{
    #local targetLocalVar="${1}"
    #local iterable="${2}"

    if ! besharp.rtti.isA "${iterable}" Iterable; then
        if besharp.rtti.isObjectExist "${iterable}"; then
            besharp.compiler.syntaxError "@iterate @of expects Iterable: @iterate @of <Iterable> @in <variable>! Got: object ${iterable} of type $( besharp.rtti.objectType "${iterable}" )"
        else
            besharp.compiler.syntaxError "@iterate @of expects Iterable: @iterate @of <Iterable> @in <variable>! Got: ${iterable}"
        fi
    fi

    local iterationKey
    eval "iterationKey=\${besharp_runtime_current_iterator_keys__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]:-}"

    if [[ -z "${iterationKey}" ]] || [[ ${besharp_runtime_reset_iteration:-} == 1 ]]; then
        export besharp_runtime_reset_iteration=0

        @let iterationKey = $iterable.iterationNew
    else
        @let iterationKey = $iterable.iterationNext "${iterationKey}"
    fi

    if [[ -z "${iterationKey}" ]]; then
        eval "besharp_runtime_current_iterator_keys__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]="

        local iterator
        eval "iterator=\${besharp_runtime_current_iterator__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]:-}"
        if [[ -n "${iterator}" ]]; then
            unset "${iterator}"
        fi

        return 1
    fi

    local iterationValue
    @let iterationValue = $iterable.iterationValue "${iterationKey}"
    eval "${targetLocalVar}=\${iterationValue}"

    eval "besharp_runtime_current_iterator_keys__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]=${iterationKey}"
}


function besharp.oopRuntime.invokeArrayIteration() {
    local targetLocalVar="${1}"
    shift 1
    local args=( "${@}" )

    if [[ "${args[@]+isset}" != 'isset' ]]; then
        return 1
    fi

    local __besharp_iterator_position_in_a_method
    besharp.fastCall.toArrayOfTokens __besharp_iterator_position_in_a_method caller 2

    local iterationKey
    eval "iterationKey=\${besharp_runtime_current_iterator_keys__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]:-}"

    if [[ -z "${iterationKey}" ]]; then
        iterationKey=0
    else
        if (( ++iterationKey >= ${#args[@]} )); then
            iterationKey=""
        fi
    fi

    if [[ -z "${iterationKey}" ]]; then
        eval "besharp_runtime_current_iterator_keys__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]="
        return 1
    fi

    eval "${targetLocalVar}=\${args[${iterationKey}]}"

    eval "besharp_runtime_current_iterator_keys__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]=${iterationKey}"
}
