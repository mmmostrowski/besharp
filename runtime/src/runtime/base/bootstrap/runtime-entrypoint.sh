#!/usr/bin/env bash

export besharp_runtime_entrypoint=""

export besharp_runtime_args=()
export besharp_runtime_args_besharp_include=()
export besharp_runtime_args_besharp_entrypoint=''

function besharp.runtime.entrypoint() {
    set -eu

    besharp.runtime.entrypoint_external_dynamic "${@}"
}
