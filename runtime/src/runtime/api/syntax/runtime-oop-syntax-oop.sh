#!/usr/bin/env bash

function @parent() {
    if [[ -n "${besharp_pm:-}" ]]; then
        "besharpstub.${besharp_pm}" "${@}"
    fi
}

function @is-setter() {
    [[ "${1:-}" == '=' ]] && [[ "${#}" -lt 3 ]]
}

function @is-getter() {
    [[ "${#}" == '0' ]]
}

function @clone() {
    local mode="shallow"
    local object
    local target=""

    if [[ "${1}" == "@to" ]]; then
        target="${2}"
        shift 2
    fi

    if [[ "${1}" == "@of" ]]; then
        shift 1
        @let object = "${@}"
    elif [[ "${2:-}" == "@of" ]]; then
        mode="${1}"
        shift 2
        @let object = "${@}"
    elif [[ "${2:-}" != "" ]]; then
        mode="${1}"
        object="${2}"
    else
        object="${1}"
    fi

    if ! besharp.rtti.isObjectExist "${object}"; then
        besharp.runtime.error "Cannot @clone! It is not an object: '${object}'."
    fi

    if [[ "${mode}" == "@in-place" ]]; then
        $object.__cloneFrom "${object}" "@in-place"
        return
    fi

    local cloned
    if [[ -n "${target}" ]]; then
        cloned="${target}"
    else
        local objectType
        objectType="${besharp_oopRuntime_object_types["${object}"]}"

        export besharp_oopRuntime_disable_constructor=true
        @let cloned = @new "${objectType}"
        export besharp_oopRuntime_disable_constructor=false
        besharp.runtime.storeReturnValueOnStackAtDepth1 "${cloned}"
    fi

    $cloned.__cloneFrom "${object}" "${mode}"
}