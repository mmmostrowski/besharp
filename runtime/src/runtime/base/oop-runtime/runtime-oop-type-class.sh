#!/usr/bin/env bash

declare -Ag besharp_oopRuntime_class_ready

function besharp.oopRuntime.prepareClass() {
    local type="${1}"

    if ! besharp.oopRuntime.registerClass "${type}"; then
        return 0
    fi

    local parentType
    parentType="${besharp_oop_type_parent[${type}]:-Object}"

    besharp.oopRuntime.prepareClass "${parentType}"

    besharp.oopRuntime.prepareClassParents "${type}" "${parentType}"
    besharp.oopRuntime.prepareParentInterfaces "${type}"
    besharp.oopRuntime.collectInterfacesForType "${type}" "${parentType}"
    besharp.oopRuntime.generateStubsTemplate "${type}"
    besharp.oopRuntime.verifyFieldsAndMethods "${type}"

    besharp.oopRuntime.verifyInterfacesForType "${type}"
    besharp.oopRuntime.verifyAbstractMethodsImplementedForType "${type}"
}

function besharp.oopRuntime.registerClass() {
    local type="${1}"

    if [[ "${besharp_oopRuntime_class_ready[${type}]+isset}" == 'isset' ]]; then
        return 1
    fi
    besharp_oopRuntime_class_ready["${type}"]="${type}"
    return 0
}

function besharp.oopRuntime.prepareClassParents() {
    local type="${1}"
    local parentType="${2}"

    if [[ "${type}" == 'Object' ]]; then
        return
    fi

    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_parents"
    besharp.oopRuntime.generateLinkerLine "declare -ag besharp_oopRuntime_type_${type}_all_parents_list"

    local inheritParentTypes
    eval "inheritParentTypes=\"\${besharp_oopRuntime_type_${parentType}_all_parents_list[@]}\""

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_parents_list=( ${parentType} ${inheritParentTypes} )"
    eval "for parent in \${besharp_oopRuntime_type_${type}_all_parents_list[@]}; do
        besharp.oopRuntime.generateLinkerLine \"besharp_oopRuntime_type_${type}_all_parents[\\\"\${parent}\\\"]=\\\"\${parent}\\\"\"
    done
    "
}

