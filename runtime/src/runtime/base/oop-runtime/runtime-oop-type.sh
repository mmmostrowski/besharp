#!/usr/bin/env bash

declare -Ag besharp_oopRuntime_types

function besharp.oopRuntime.ensurePrepareType() {
    local type="${1}"

    if ! besharp.rtti.classExists "${type}" && ! besharp.rtti.interfaceExists "${type}"; then
        if ! besharp.rtti.classExists "${type%Factory}"; then
            besharp.runtime.error "Unknown type: ${type}!"
        fi
        besharp.oopRuntime.createDynamicFactoryClass "${type%Factory}" "${type}"
    fi

    besharp.oopRuntime.prepareType "${type}"
}

function besharp.oopRuntime.prepareType() {
    local type="${1}"

    if besharp.rtti.classExists "${type}"; then
        besharp.oopRuntime.prepareClass "${type}"
    elif besharp.rtti.interfaceExists "${type}"; then
        besharp.oopRuntime.prepareInterface "${type}"
    fi
}

function besharp.oopRuntime.ensureClassExists() {
    local type="${1}"

    if besharp.rtti.classExists "${type}"; then
        return
    fi

    type="${type%Factory}"

    if besharp.rtti.classExists "${type}"; then
        return
    fi

    if besharp.rtti.interfaceExists "${type}"; then
        besharp.runtime.error "'${type}' is an interface! Cannot be used as a class."
    fi

    besharp.runtime.error "Unknown class: ${type}!"
}

function besharp.oopRuntime.generateLinkerLine() {
#    d; d "${*}" # debug
    eval "${@}"
}

