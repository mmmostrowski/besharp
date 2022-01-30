#!/usr/bin/env bash

declare -Ag besharp_compiler_detected_types
declare -Ag besharp_compiler_detected_type_is

function besharp.compiler.oop.compileType() {
    local type="${1}"
    local is="${2}"

    if [[ ! "${type}" =~ ^[A-Z][A-Za-z0-9]*$ ]]; then
        besharp.compiler.syntaxError "Type '${type}' must be CamelCase machine name!"
    fi

    besharp.compiler.writeToMetaOutput "besharp_oop_type_is[\"${type}\"]='${is}'"
    besharp.compiler.writeToMetaOutput "besharp_oop_types[\"${type}\"]=\"${type}\""

    besharp_compiler_detected_types["${type}"]="${type}"
    besharp_compiler_detected_type_is["${type}"]="${is}"
}

function besharp.compiler.oop.compileTypeInterfaces() {
    local type="${1}"
    shift 1

    besharp.compiler.writeToMetaOutput "declare -Ag besharp_oop_type_${type}_interfaces"

    local interface
    for interface in "${@}"; do
        if [[ -z "${interface}" ]]; then
            continue
        fi

        besharp.compiler.writeToMetaOutput "besharp_oop_type_${type}_interfaces['${interface}']='${interface}'"
    done
}


function besharp.compiler.oop.enableCompiledTypesDetection() {
    unset besharp_compiler_detected_types
    declare -Ag besharp_compiler_detected_types
}

function besharp.compiler.oop.flushDetectedTypes() {
    echo "${besharp_compiler_detected_types[@]}"
    besharp.compiler.oop.enableCompiledTypesDetection
}

function besharp.compiler.oop.isDetectedTypeAClass() {
    local detectedItem="${1}"

    [[ "${besharp_compiler_detected_type_is["${detectedItem}"]}" == "class" ]]
}

function besharp.compiler.oop.isDetectedTypeAnInterface() {
    local detectedItem="${1}"

    [[ "${besharp_compiler_detected_type_is["${detectedItem}"]}" == "interface" ]]
}
