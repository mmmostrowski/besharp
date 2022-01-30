#!/usr/bin/env bash

function besharp.rtti.allFieldsOf() {
    local type="${1}"

    eval "echo \"\${besharp_oopRuntime_type_${type}_all_fields[@]:-}\""
}

function besharp.rtti.allInjectableFieldsOf() {
    local type="${1}"

    eval "echo \"\${besharp_oopRuntime_type_${type}_all_injectable_fields[@]:-}\""
}

function besharp.rtti.typeHasField() {
    local type="${1}"
    local field="${2}"

    eval "[[ \"\${besharp_oopRuntime_type_${type}_all_fields[${field}]+isset}\" == 'isset' ]]"
}

