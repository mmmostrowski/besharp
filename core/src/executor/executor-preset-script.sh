#!/usr/bin/env bash

function besharp.executor.presetScript.prepare() {
    local preset="${1}"

    local dir="${besharp_root_dir}/app/dist/${preset}"
    rm -rf "${dir}"
    mkdir -p "${dir}"
}

function besharp.executor.presetScript.load() {
    local preset="${1}"
    local script="${2}"
    shift 2

    ROOT_DIR="${besharp_root_dir}"
    CURRENT_PRESET_DIST="${besharp_root_dir}/app/dist/${preset}"
    CURRENT_PRESET_SRC="${besharp_root_dir}/build/presets/${preset}"

    if [[ -e "${CURRENT_PRESET_SRC}/${script}" ]]; then
        source "${CURRENT_PRESET_SRC}/${script}" "${@}"
    elif [[ -e "${besharp_root_dir}/build/${script}" ]]; then
        source "${besharp_root_dir}/build/${script}"
    else
        besharp.error "Cannot load '${script}' script for '${preset}' preset!"
    fi
}
