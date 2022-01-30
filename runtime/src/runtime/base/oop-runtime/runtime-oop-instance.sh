#!/usr/bin/env bash

export besharp_oopRuntime_object_count=0
export besharp_oopRuntime_disable_constructor=false
declare -Ag besharp_oopRuntime_objects
declare -Ag besharp_oopRuntime_object_types

function besharp.oopRuntime.createNewInstance() {
    local type="${1}"
    shift 1

    local code="besh_$(( ++besharp_oopRuntime_object_count ))"

    besharp.oopRuntime.createNewInstanceNamed "${type}" "${code}" "${@}"

    besharp.runtime.storeReturnValueOnStackAtDepth1 "${code}"
}

function besharp.oopRuntime.createNewInstanceNamed() {
    local type="${1}"
    local code="${2}"
    shift 2

    besharp.rtti.ensureValidObjectCode "${type}" "${code}"

    besharp.oopRuntime.ensureClassExists "${type}"
    besharp.oopRuntime.ensurePrepareType "${type}"
    besharp.oopRuntime.trackObject "${type}" "${code}"
    besharp.oopRuntime.executeStubsTemplate "${type}" "${code}"

    ${code}.__besharp_initialize_object

    besharp.oopRuntime.prepareDI "${type}" "${code}"

    besharp.oopRuntime.callConstructor "${code}" "${type}" "${@}"
}

function besharp.oopRuntime.prepareNewInstanceStatic() {
    local type="${1}"
    local staticCode="${2}"

    besharp.rtti.ensureValidStaticObjectCode "${type}" "${staticCode}"

    local code="besh_static_${staticCode#@}"

    besharp.oopRuntime.ensureClassExists "${type}"
    besharp.oopRuntime.ensurePrepareType "${type}"
    besharp.oopRuntime.trackObject "${type}" "${code}"
    besharp.oopRuntime.executeStubsTemplate "${type}" "${code}"
    besharp.oopRuntime.executeStaticStubsTemplate "${type}" "${code}" "${staticCode}"
}

function besharp.oopRuntime.createNewInstanceStatic() {
    local type="${1}"
    local staticCode="${2}"
    shift 2

    local code="besh_static_${staticCode#@}"

    ${staticCode}.__besharp_initialize_object

    besharp.oopRuntime.prepareDI "${type}" "${code}"

    besharp.oopRuntime.callConstructor "${staticCode}" "${type}" "${@}"
}

function besharp.oopRuntime.trackObject() {
    local type="${1}"
    local code="${2}"

    besharp_oopRuntime_objects["${code}"]="${code}"
    besharp_oopRuntime_object_types["${code}"]="${type}"
}

function besharp.oopRuntime.callConstructor() {
    local code="${1}"

    if $besharp_oopRuntime_disable_constructor; then
        return
    fi

    local type="${2}"
    shift 2

    ${code}.${type} "${@}"
}

function besharp.oopRuntime.unsetObjectInstance() {
    local code="${1}"

    $code.__destroy

    ${code}.__besharp_deinitialize_object

    unset "besharp_oopRuntime_objects[${code}]"
    unset "besharp_oopRuntime_object_types[${code}]"
}

