#!/usr/bin/env bash

function besharp.executor.runForPreset() {
    local preset="${1}"
    shift 1

    if ! $besharp_entrypoint_args_skip_compilation; then
        besharp.executor.beginExecutePreset "${preset}"

        besharp.executor.executeRuntimeCompilation "${preset}"
        besharp.executor.executeAppCompilation "${preset}"
        besharp.executor.executeBuild "${preset}"
        besharp.executor.finalizeSections
    fi

    besharp.executor.presetScriptRun "${preset}" run.sh "${@}"

    if ! $besharp_entrypoint_args_skip_compilation; then
        besharp.executor.endExecutePreset "${preset}"
    fi
}

