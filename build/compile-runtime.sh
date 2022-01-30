#!/usr/bin/env bash

runtime/build.sh

core/bin/compile \
    --source runtime/microframework/src/ \
    --source runtime/src/ \
    --distribution-dir runtime/dist/objects/ \
    --distribution-script runtime/dist/besharp-runtime-${besharp_runtime_version}.be.sh \
    --distribution-script-entrypoint besharp.runtime.entrypoint \
    $( ! $besharp_entrypoint_args_compile_all && echo '--skip-unchanged' ) \
;

