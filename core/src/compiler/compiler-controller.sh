#!/usr/bin/env bash

export besharp_compiler_output_code=()
export besharp_compiler_output_meta=()

function besharp.compiler.compileItem() {
    local item="${1}"

    besharp.compiler.logCompilationForFile "${item}"

    local targetPath
    targetPath="${besharp_compiler_registry_target_absolute_path["${item}"]}"

    besharp.compiler.prepareOutput
    besharp.compiler.compileByItemType "${item}"

    besharp.compiler.prepareCompilationTargetFile "${targetPath}"
    besharp.compiler.generateBeshfileMeta "${item}" > "${targetPath}"
    besharp.compiler.flushMetaOutput >> "${targetPath}"
    besharp.compiler.flushCodeOutput >> "${targetPath}"
}

function besharp.compiler.prepareCompilationTargetFile() {
    local targetPath="${1}"

    mkdir -p "$( dirname "${targetPath}" )"
}

function besharp.compiler.compileByItemType() {
    local item="${1}"

    local type="${besharp_compiler_registry_type["${item}"]}"
    besharp.compiler.compileItem.${type} "${item}"
}

function besharp.compiler.prepareOutput() {
    unset besharp_compiler_output_code
    export besharp_compiler_output_code=()
    unset besharp_compiler_output_meta
    export besharp_compiler_output_meta=()
}

function besharp.compiler.writeToCodeOutput() {
    local line
    for line in "${@}"; do
        besharp_compiler_output_code+=( "${line}" )
    done
}

function besharp.compiler.writeToMetaOutput() {
    local line
    for line in "${@}"; do
        besharp_compiler_output_meta+=( "${line}" )
    done
}

function besharp.compiler.flushCodeOutput() {
    local line
    for line in "${besharp_compiler_output_code[@]}"; do
        echo "${line}"
    done | besharp.compiler.generateBeshfileSection "code"
}

function besharp.compiler.flushMetaOutput() {
    local line
    for line in "${besharp_compiler_output_meta[@]}"; do
        echo "${line}"
    done | besharp.compiler.generateBeshfileSection "oop_meta"
}
