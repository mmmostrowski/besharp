#!/usr/bin/env bash

# besharp_runtime_current_stack_level
export besharp_rcsl=1

# besharp_runtime_current_return_value_stack
declare -ag besharp_rcrvs


function besharp.runtime.storeReturnValueOnStack() {
    local value="${1}"

    besharp_rcrvs[ besharp_rcsl ]="${value}"
}

function besharp.runtime.storeReturnValueOnStackAtDepth() {
    local value="${1}"
    local depth="${2}"

    besharp_rcrvs[ besharp_rcsl + depth ]="${value}"
}

function besharp.runtime.storeReturnValueOnStackAtDepth1() {
    local value="${1}"

    besharp_rcrvs[ besharp_rcsl + 1 ]="${value}"
}

function besharp.returningOf() {
    "${@}"

    besharp_rcrvs[besharp_rcsl]="${besharp_rcrvs[ besharp_rcsl + 1 ]}"
}
