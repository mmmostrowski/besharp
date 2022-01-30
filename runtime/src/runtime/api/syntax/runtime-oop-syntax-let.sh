#!/usr/bin/env bash

function @let() {
    # NOTE: this method should be careful on collisions with caller's local variables
    local target_uniqsequence_34509837572364="${1}"

    if [[ -z "${1:-}" ]]; then
       besharp.compiler.syntaxError "@let expects target: @let TARGET OPERATION [ARGS ... ], where TARGET might be either local variable or object field"
    fi

    if [[ "${2:-}" != '=' ]]; then
       besharp.compiler.syntaxError "Expected syntax @let requires ' = ' phrase before value. Got: ${*}"
    fi

    shift 2

    "${@}"

    if [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]+isset}" != "isset" ]]; then
        besharp.compiler.syntaxError "@let couldn't find any results. Did you @return any value?"
    fi

    if [[ "${target_uniqsequence_34509837572364//./}" == "${target_uniqsequence_34509837572364}" ]]; then
        # variable
       eval "${target_uniqsequence_34509837572364}=\"\${besharp_rcrvs[ besharp_rcsl + 1 ]}\""
    else
        # field
       "${target_uniqsequence_34509837572364}" = "${besharp_rcrvs[ besharp_rcsl + 1 ]}"
    fi

    unset "besharp_rcrvs[ besharp_rcsl + 1 ]"
}
