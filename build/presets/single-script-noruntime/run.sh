#!/usr/bin/env bash

(
    export BESHARP_RUNTIME_PATH="$( ls "${besharp_root_dir}/runtime/dist/besharp-runtime"* )"

    cd "${CURRENT_PRESET_DIST}"
    ./app "${@}" || return ${?}
)
