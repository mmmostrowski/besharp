#!/usr/bin/env bash

function besharp.compiler.compileItem.class() {
    local item="${1}"

    besharp.compiler.oop.enableCompiledTypesDetection

    source "${besharp_compiler_registry_source_absolute_path[${item}]}"

    local matchingMethodsRegex
    matchingMethodsRegex="$(
        local type
        for type in $( besharp.compiler.oop.flushDetectedTypes ); do
            echo -n "|${type}|${type}\..*"
        done
     )"

   matchingMethodsRegex="^declare -f (impossible-to-be-defined${matchingMethodsRegex})$"

    local method
    for method in $( declare -F  | besharp.grepList -E "${matchingMethodsRegex}" | cut -d' ' -f3 ); do
        if [[ -z "${method}" ]]; then
            continue
        fi

        besharp.compiler.writeToCodeOutput "$( declare -f "${method}" )"
    done
}

