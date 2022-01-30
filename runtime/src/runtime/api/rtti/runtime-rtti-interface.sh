#!/usr/bin/env bash

function besharp.rtti.interfaces() {
    echo "${besharp_oop_interfaces[@]}"
}

function besharp.rtti.interfaceExists() {
    local type="${1}"

    [[ "${besharp_oop_interfaces[${type}]+isset}" == 'isset' ]]
}

function besharp.rtti.typeInterfaces() {
    local type="${1}"

    eval "echo \"\${besharp_oop_type_${type}_interfaces[@]:-}\""
}

function besharp.rtti.isImplementingDirectly() {
    local type="${1}"
    local interface="${2}"

    eval "[[ \"\${besharp_oop_type_${type}_interfaces[${interface}]+isset}\" == 'isset' ]]"
}

function besharp.rtti.interfaceMethods() {
    besharp.rtti.methodsOf "${@}"
}

function besharp.rtti.allUserInterfaces() {
    local type=''
    for type in ${besharp_oop_interfaces[@]}; do
        if ! besharp.rtti.isInternal "${type}"; then
            echo "${type}"
        fi
    done
}

