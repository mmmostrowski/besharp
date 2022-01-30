#!/usr/bin/env bash

function besharp.executor.buildForPreset() {
    local preset="${1}"

    if ! $besharp_entrypoint_args_skip_compilation; then
        besharp.executor.beginExecutePreset "${preset}"
        besharp.executor.executeRuntimeCompilation "${preset}"
        besharp.executor.executeAppCompilation "${preset}"
    fi

    besharp.executor.executeBuild "${preset}"

    if ! $besharp_entrypoint_args_skip_compilation; then
        besharp.executor.endExecutePreset "${preset}"
    fi
}

