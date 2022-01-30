#!/usr/bin/env bash

core/bin/compile \
    --source runtime/src/runtime-micro/ \
    --source app/src/ \
    --distribution-dir app/dist/.compiled/ \
    --distribution-script ${CURRENT_PRESET_DIST}/app \
    --distribution-script-entrypoint besharp.runtime.entrypoint_micro \
    $( ! $besharp_entrypoint_args_compile_all && echo '--skip-unchanged' ) \
;

