#!/usr/bin/env bash

"${CURRENT_PRESET_DIST}/app" "${@}" || return ${?}