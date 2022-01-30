#!/usr/bin/env bash

declare -Ag besharp_oopRuntime_interface_ready

function besharp.oopRuntime.prepareInterface() {
    local type="${1}"

    if ! besharp.oopRuntime.registerInterface "${type}"; then
        return 0
    fi

    besharp.oopRuntime.prepareParentInterfaces "${type}"
    besharp.oopRuntime.collectInterfacesForType "${type}"
}

function besharp.oopRuntime.registerInterface() {
    local type="${1}"

    if [[ "${besharp_oopRuntime_interface_ready[${type}]+isset}" == 'isset' ]]; then
        return 1
    fi
    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_interface_ready[\"${type}\"]='${type}'"
    return 0
}

function besharp.oopRuntime.prepareParentInterfaces() {
    local type="${1}"

    local interface
    eval "for interface in \"\${besharp_oop_type_${type}_interfaces[@]}\"; do
        besharp.oopRuntime.prepareInterface \"\${interface}\";
    done"
}

function besharp.oopRuntime.collectInterfacesForType() {
    local type="${1}"
    local parentType="${2:-}"

    local interface

    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_interfaces"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_interface_methods"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_interface_methods_origin"

    besharp.oopRuntime.addToInterfaceParentsFromArray "${type}" "besharp_oop_type_${type}_interfaces"

    if [[ -n "${parentType}" ]]; then
        eval "besharp.oopRuntime.addToInterfaceParentsFromArray '${type}' \"besharp_oopRuntime_type_${parentType}_all_interfaces\""
        eval "besharp.oopRuntime.addToInterfaceMethodsFromArray '${type}' \"${parentType}\" \"besharp_oopRuntime_type_${parentType}_all_interface_methods\""
    fi

    eval "for interface in \"\${besharp_oop_type_${type}_interfaces[@]}\"; do
        besharp.oopRuntime.verifyInterfaceExists \"\${interface}\" \"\${type}\"
        besharp.oopRuntime.addToInterfaceParentsFromArray '${type}' \"besharp_oopRuntime_type_\${interface}_all_interfaces\"
    done"

    if besharp.rtti.interfaceExists "${type}"; then
        besharp.oopRuntime.addToInterfaceMethodsFromArray "${type}" "${type}" "besharp_oop_type_${type}_methods"
    fi

    eval "for interface in \"\${besharp_oop_type_${type}_interfaces[@]}\"; do
        besharp.oopRuntime.addToInterfaceMethodsFromArray '${type}' \"\${interface}\" \"besharp_oopRuntime_type_\${interface}_all_interface_methods\"
    done"
}

function besharp.oopRuntime.addToInterfaceParentsFromArray() {
    local type="${1}"
    local arrayName="${2}"
    shift 2

    eval "for item in \"\${${arrayName}[@]}\"; do besharp.oopRuntime.addToInterfaceParents '${type}' \"\${item}\"  ; done"
}

function besharp.oopRuntime.addToInterfaceParents() {
    local type="${1}"
    shift 1

    local item
    for item in "${@}"; do
        besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_interfaces[\"${item}\"]=\"${item}\";"
    done
}

function besharp.oopRuntime.addToInterfaceMethodsFromArray() {
    local type="${1}"
    local originInterface="${2}"
    local arrayName="${3}"
    shift 3

    local method
    eval "for method in \"\${${arrayName}[@]}\"; do
        besharp.oopRuntime.addToInterfaceMethods '${type}' '${originInterface}' \"\${method}\"
    done"
}

function besharp.oopRuntime.addToInterfaceMethods() {
    local type="${1}"
    local originInterface="${2}"
    local method="${3}"

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_interface_methods[\"${method}\"]=\"${method}\";"
    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_interface_methods_origin[\"${method}\"]=\"${originInterface}\";"
}

