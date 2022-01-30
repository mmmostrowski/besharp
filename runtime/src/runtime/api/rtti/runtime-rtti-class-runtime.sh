#!/usr/bin/env bash

function besharp.rtti.isTypeA() {
    local type="${1}"
    local typeToCheck="${2}"
    local exact="${3:-false}"

    besharp.oopRuntime.prepareType "${type}"
    besharp.oopRuntime.prepareType "${typeToCheck}"

    if [[ "${type}" == "${typeToCheck}" ]]; then
        return 0
    fi

    if $exact; then
        return 1
    fi

    if eval "[[ \${besharp_oopRuntime_type_${type}_all_interfaces[@]+isset} == 'isset' ]] && [[ \"\${besharp_oopRuntime_type_${type}_all_interfaces[${typeToCheck}]+isset}\" == 'isset' ]]"; then
        return 0
    fi

    eval "[[ \${besharp_oopRuntime_type_${type}_all_parents[@]+isset} == 'isset' ]] && [[ \"\${besharp_oopRuntime_type_${type}_all_parents[${typeToCheck}]+isset}\" == 'isset' ]]"
}

function besharp.rtti.isA() {
    local objectOrType="${1}"
    local type="${2}"
    local exact="${3:-false}"

    if [[ "${objectOrType}" == "${type}" ]]; then
        return 0
    fi

    if ! besharp.rtti.isValidTypeOrObjectCode "${objectOrType}"; then
        return 1
    fi

    if besharp.rtti.isObjectExist "${objectOrType}"; then
        besharp.rtti.isTypeA "${besharp_oopRuntime_object_types["${objectOrType}"]}" "${type}" "${exact}"
    else
        besharp.rtti.isTypeA "${objectOrType}" "${type}" "${exact}"
    fi
}
