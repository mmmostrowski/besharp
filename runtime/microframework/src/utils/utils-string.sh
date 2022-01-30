#!/usr/bin/env bash

function besharp.string.glue() {
    local separator="${1}"
    shift 1

    local item
    local firstOne=true
    for item in "${@}"; do
        if $firstOne; then
            firstOne=false
        else
            echo -n "${separator}"
        fi
        echo -n "${item}"
    done
}
