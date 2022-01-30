#!/usr/bin/env bash

function besharp.executor.preset.listAll() {
    besharp.files.listDirs "${besharp_root_dir}/build/presets/"
}

function besharp.executor.preset.printAll() {
    besharp.string.glue ", " $( besharp.executor.preset.listAll )
}

function besharp.executor.preset.default() {
    local preset
    preset="$( cat "${besharp_root_dir}/build/default.preset" )"

    besharp.executor.preset.ensureIsValid "${preset}"

    echo "${preset}"
}

function besharp.executor.preset.ensureIsValid() {
    local preset="${1}"

    if ! [[ -d "${besharp_root_dir}/build/presets/${preset}" ]]; then
        besharp.error "Invalid preset: ${preset}! Available presets: $( besharp.executor.preset.printAll )."
    fi
}
