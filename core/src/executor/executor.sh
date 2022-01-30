#!/usr/bin/env bash

function besharp.executor.beginExecutePreset() {
    local preset="${1}"

    besharp.executor.startSection "Preset: ${preset}"
    besharp.executor.presetScript.prepare "${preset}"
}

function besharp.executor.endExecutePreset() {
    local preset="${1}"

    besharp.executor.stopSection
    besharp.executor.sectionsSeparator
}

function besharp.executor.executeRuntimeCompilation() {
    local preset="${1}"

    besharp.executor.startSection "Runtime compilation"
    besharp.executor.presetScript.load "${preset}" compile-runtime.sh
    besharp.executor.stopSection
}

function besharp.executor.executeAppCompilation() {
    local preset="${1}"

    besharp.executor.startSection "App compilation"
    besharp.executor.presetScript.load "${preset}" compile.sh
    besharp.executor.stopSection
}


function besharp.executor.executeBuild() {
    local preset="${1}"

    besharp.executor.startSection "Building"
    besharp.executor.presetScript.load "${preset}" build.sh
    besharp.executor.stopSection
}

function besharp.executor.presetScriptRun() {
    local preset="${1}"
    local callback="${2}"
    shift 2

    besharp.executor.presetScript.load "${preset}" "${callback}" "${@}"
}

function besharp.executor.pickMultiplePresetsToExecute() {
    if [[ "${besharp_entrypoint_args_preset[*]}" != '' ]]; then
        for preset in "${besharp_entrypoint_args_preset[@]}"; do
            besharp.executor.preset.ensureIsValid "${preset}"
        done
        echo "${besharp_entrypoint_args_preset[*]}"
    else
        besharp.executor.preset.listAll | sort
    fi
}

function besharp.executor.pickSinglePresetToExecute() {

    if [[ "${besharp_entrypoint_args_preset[*]}" != '' ]]; then
        local first=true
        for preset in "${besharp_entrypoint_args_preset[@]}"; do
            if ! $first; then
                besharp.error "Unexpected second preset: ${preset}"
            fi
            first=false

            besharp.executor.preset.ensureIsValid "${preset}"
            echo "${preset}"
        done
    else
        besharp.executor.preset.default
    fi
}