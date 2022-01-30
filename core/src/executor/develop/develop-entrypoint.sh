#!/usr/bin/env bash

function besharp.entrypoint.develop() {
    besharp.entrypoint.parseArguments "${@}"

    besharp.executor.developForPreset "$(
        besharp.executor.pickSinglePresetToExecute
    )" "${besharp_entrypoint_args[@]}"
}

