#!/usr/bin/env bash

function besharp.entrypoint.run() {
    besharp.entrypoint.parseArguments "${@}"

    besharp.executor.runForPreset "$(
        besharp.executor.pickSinglePresetToExecute
    )" "${besharp_entrypoint_args[@]}"
}

