#!/usr/bin/env bash

core/bin/compile \
    --source runtime/dist/besharp-runtime-${besharp_runtime_version}.be.sh \
    --source app/src/ \
    --distribution-dir app/dist/.compiled/ \
    --distribution-script ${CURRENT_PRESET_DIST}/app \
    --distribution-script-entrypoint besharp.runtime.entrypoint_embedded_static \
    $( ! $besharp_entrypoint_args_compile_all && echo '--skip-unchanged' ) \
;

