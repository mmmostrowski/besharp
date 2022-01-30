#!/usr/bin/env bash

core/bin/compile \
    --source app/src/ \
    --distribution-dir app/dist/.compiled/ \
    $( ! $besharp_entrypoint_args_compile_all && echo '--skip-unchanged' ) \
;

