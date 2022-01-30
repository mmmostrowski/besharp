#!/usr/bin/env bash

function besharp.compiler.oop.compileInterface() {
    local type="${1}"
    shift 1

    besharp.compiler.oop.compileType "${type}" "interface"
    besharp.compiler.writeToMetaOutput "besharp_oop_interfaces[\"${type}\"]=\"${type}\""

    besharp.compiler.oop.compileTypeInterfaces "${type}" "${@}"

    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_methods"
    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_method_is_abstract"
}

function besharp.compiler.oop.compileInterfaceMethod() {
    local type="${1}"
    local method="${2}"

    besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_methods['${method}']='${method}'"

    besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_method_is_abstract[\"${method}\"]='true'"
}

