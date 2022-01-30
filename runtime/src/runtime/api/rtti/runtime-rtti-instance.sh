#!/usr/bin/env bash

function besharp.rtti.objectType() {
    local code="${1}"

    if ! besharp.rtti.isObjectExist "${code}"; then
        return 1
    fi

    echo "${besharp_oopRuntime_object_types["${code}"]}"
}

function besharp.rtti.ensureValidObjectCode() {
    local type="${1}"
    local code="${2}"

    if [[ ! "${code}" =~ ^[abcdefghijklmnopqrstuvwxyz][abcdefghijklmnopqrstuvwxyz0-9_]*$ ]]; then
        besharp.compiler.syntaxError "Invalid object code of type ${type}: '${code}'!"
    fi

    if [[ "${besharp_oopRuntime_objects[${code}]+isset}" == "isset" ]]; then
        besharp.compiler.syntaxError "Instance '${code}' of type '${type}' already exists!"
    fi
}

function besharp.rtti.ensureValidStaticObjectCode() {
    local type="${1}"
    local code="${2}"

    if [[ ! "${code}" =~ ^@[abcdefghijklmnopqrstuvwxyz][abcdefghijklmnopqrstuvwxyz0-9_]*$ ]]; then
        besharp.compiler.syntaxError "Invalid static object code of type ${type}: '${code}'!"
    fi

    if [[ "${besharp_oopRuntime_objects[${code}]+isset}" == "isset" ]]; then
        besharp.compiler.syntaxError "Instance '${code}' of type '${type}' already exists!"
    fi
}

function besharp.rtti.isObjectExist() {
    local code="${1}"

    if ! besharp.rtti.isValidObjectCode "${code}"; then
        return 1
    fi

    [[ "${besharp_oopRuntime_objects[${code}]+isset}" == "isset" ]]
}

function besharp.rtti.isValidObjectCode() {
    local code="${1}"

    [[ "${code}" =~ ^[abcdefghijklmnopqrstuvwxyz][abcdefghijklmnopqrstuvwxyz0-9_]*$ ]]
}

function besharp.rtti.isValidTypeOrObjectCode() {
    local code="${1}"

    [[ "${code}" =~ ^[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz][ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0-9_]*$ ]]
}

