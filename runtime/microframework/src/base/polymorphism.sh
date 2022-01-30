#!/usr/bin/env bash

function besharp.polymorphism.initialize() {
    declare -ag besharp_polymorphism_layers=()
}

function besharp.polymorphism.currentTag() {
    echo "${besharp_polymorphism_tags[@]}"
}

function besharp.polymorphism.run() {
    local tags="${1}"
    shift 1

    if [[ -z "${tags}" ]]; then
        "${@}"
        return
    fi

    besharp.polymorphism.activateLayer "${tags}"

    "${@}"

    besharp.polymorphism.deactivateLayer
}

function besharp.polymorphism.activateLayer() {
    local tags="${1}"

    local allFunctions=
    allFunctions=$( declare -F )

    local tag
    local func
    local funcBase
    local rejected

    local orgFunctions=":"

    while read func; do
        func="${func#declare -f }"
        funcBase="${func}"
        rejected=false

        for tag in ${tags}; do
            if [[ "${func//__${tag}/}" != "${func}" ]]; then
                funcBase="${funcBase//__${tag}/}"
                continue
            fi
            rejected=true
        done

        if ! $rejected && [[ "${funcBase//__/}" == "${funcBase}" ]]; then
            local orgFunc="$( declare -f "${funcBase}" )"
            local newFunc="$( declare -f "${func}" )"

            eval "${funcBase}${newFunc#${func}}"

            orgFunctions="${orgFunctions}; ${orgFunc}"
        fi

    done<<<"${allFunctions}"

    besharp_polymorphism_layers+=( "${orgFunctions}" )
}

function besharp.polymorphism.deactivateLayer() {
    eval "${besharp_polymorphism_layers[-1]}"
    unset "besharp_polymorphism_layers[-1]"
}

