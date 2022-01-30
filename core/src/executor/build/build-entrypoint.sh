#!/usr/bin/env bash

function besharp.entrypoint.build() {
    besharp.entrypoint.parseArguments "${@}"

    local preset
    for preset in $( besharp.executor.pickMultiplePresetsToExecute ); do
        besharp.executor.buildForPreset "${preset}"
    done
}

