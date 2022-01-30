#!/usr/bin/env bash

function besharp.oopRuntime.createStaticInstances() {

    local type
    for type in "${besharp_oop_type_static[@]}"; do
        besharp.oopRuntime.prepareNewInstanceStatic "${type}" "${besharp_oop_type_static_accessor[${type}]}"
    done

    local type
    for type in "${besharp_oop_type_static[@]}"; do
        besharp.oopRuntime.createNewInstanceStatic "${type}" "${besharp_oop_type_static_accessor[${type}]}"
    done
}
