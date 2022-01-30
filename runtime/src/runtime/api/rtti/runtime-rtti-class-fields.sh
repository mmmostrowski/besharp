#!/usr/bin/env bash

function besharp.rtti.fieldsOf() {
    local type="${1}"

    eval "echo \"\${besharp_oop_type_${type}_fields[@]:-}\""
}

function besharp.rtti.typeHasDirectField() {
    local type="${1}"
    local field="${2}"

    eval "[[ \"\${besharp_oop_type_${type}_fields[${field}]+isset}\" == 'isset' ]]"
}

function besharp.rtti.typedFieldsOf() {
    local type="${1}"

    eval "echo \"\${!besharp_oop_type_${type}_field_type[@]}\""
}

function besharp.rtti.typeOfField() {
    local type="${1}"
    local field="${2}"

    eval "echo \"\${besharp_oop_type_${type}_field_type['${field}']:-}\""
}

function besharp.rtti.typeHasInjectableField() {
    local type="${1}"
    local field="${2}"

    eval "[[ \"\${besharp_oop_type_${type}_injectable_fields[${field}]+isset}\" == 'isset' ]]"
}

function besharp.rtti.injectableFieldsOf() {
    local type="${1}"

    eval "echo \"\${besharp_oop_type_${type}_injectable_fields[@]:-}\""
}

