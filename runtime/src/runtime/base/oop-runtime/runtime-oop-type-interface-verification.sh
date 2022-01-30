#!/usr/bin/env bash

function besharp.oopRuntime.verifyInterfacesForType() {
    local type="${1}"

    if besharp.rtti.isAbstractClass "${type}"; then
        return
    fi

    local method
    eval "for method in \"\${besharp_oopRuntime_type_${type}_all_interface_methods[@]:-}\"; do
          if [[ -z \"\${method}\" ]]; then continue; fi
          besharp.oopRuntime.verifyInterfaceMethod '${type}' \"\${method}\"
    done"

}

function besharp.oopRuntime.verifyInterfaceMethod() {
    local type="${1}"
    local method="${2}"

    if ! besharp.rtti.hasMethod "${type}" "${method}" || besharp.rtti.isMethodAbstract  "${type}" "${method}"; then
         eval "interface=\${besharp_oopRuntime_type_${type}_interface_methods_origin['${method}']}"
         besharp.runtime.error "Class '${type}' must implement '${type}.${method}' method. Duty origin: '${interface}'!"
    fi
}

function besharp.oopRuntime.verifyInterfaceExists() {
    local interface="${1}"
    local type="${2}"

    if [[ "${besharp_oop_interfaces[${interface}]+isset}" != 'isset' ]]; then
         besharp.runtime.error "Type '${type}' cannot implement unknown interface: ${interface} !"
    fi
}
