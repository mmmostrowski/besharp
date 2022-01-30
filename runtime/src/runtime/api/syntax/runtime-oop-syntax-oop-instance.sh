#!/usr/bin/env bash

function @new() {
    besharp.oopRuntime.createNewInstance "${@}"
}

function @new-into() {
    local targetVar="${1}"
    shift 1

    @let ${targetVar} = besharp.oopRuntime.createNewInstance "${@}"
}

function @new-named() {
    besharp.oopRuntime.createNewInstanceNamed "${@}"
}

function @unset() {
    local object
    if [[ "${1}" == "@of" ]]; then
        shift 1
        @let object = "${@}"
    else
        object="${1}"
    fi

    besharp.oopRuntime.unsetObjectInstance "${object}"
}

function @object-id() {
    local objectOrValue="${1}"

    local objectId

    if besharp.rtti.isObjectExist "${objectOrValue}"; then
        @let objectId = $objectOrValue.__objectId
        besharp.runtime.storeReturnValueOnStackAtDepth1 "${objectId}"
        return
    fi

    besharp.runtime.storeReturnValueOnStackAtDepth1 "${objectOrValue}"
}

function @is() {
    local objectOrType="${1:-}"

    if [[ "${2:-}" == "@exact" ]]; then
        local type="${3:-}"
        local exact=true
    elif [[ "${2:-}" == "@an" ]]; then
        local type="${3:-}"
        local exact=false
    elif [[ "${2:-}" == "@a" ]]; then
        local type="${3:-}"
        local exact=false
    else
        local type="${2:-}"
        local exact=false
    fi

    besharp.rtti.isA "${objectOrType}" "${type}" "${exact}"
}

function @exists() {
    local object
    if [[ "${1}" == "@of" ]]; then
        shift 1
        @let object = "${@}"
    else
        object="${1}"
    fi

    besharp.rtti.isObjectExist "${object}"
}

function @same() {
    local left="${1}"
    local right="${2}"

    if besharp.rtti.isValidObjectCode "${left}"; then
        if besharp.rtti.isObjectExist "${left}"; then
            @let left = $left.__objectId
        fi
    fi

    if besharp.rtti.isValidObjectCode "${right}"; then
        if besharp.rtti.isObjectExist "${right}"; then
            @let right = $right.__objectId
        fi
    fi

    [[ "${left}" == "${right}" ]]
}

