#!/usr/bin/env bash

(
    cd "${CURRENT_PRESET_DIST}"
    ./app "${@}" || return ${?}
)
