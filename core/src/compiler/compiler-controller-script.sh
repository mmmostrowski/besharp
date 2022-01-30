#!/usr/bin/env bash

function besharp.compiler.compileItem.script() {
    local item="${1}"

    besharp.compiler.writeToCodeOutput "$(
        cat "${besharp_compiler_registry_source_absolute_path[${item}]}"
    )"
}