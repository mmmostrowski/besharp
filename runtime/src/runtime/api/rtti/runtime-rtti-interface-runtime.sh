#!/usr/bin/env bash

function besharp.rtti.allTypeInterfaces() {
    local type="${1}"

    besharp.oopRuntime.ensurePrepareType "${type}"

    eval "echo \"\${besharp_oopRuntime_type_${type}_all_interfaces[@]:-}\""
}

function besharp.rtti.allInterfaceMethodsForType() {
    local type="${1}"

    besharp.oopRuntime.ensurePrepareType "${type}"

    eval "echo \"\${besharp_oopRuntime_type_${type}_all_interface_methods[@]:-}\""
}

