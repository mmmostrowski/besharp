#!/usr/bin/env bash

export besharp_entrypoint_args=()
export besharp_entrypoint_args_preset=()
export besharp_entrypoint_args_compile_all=false
export besharp_entrypoint_args_skip_compilation=false

function besharp.entrypoint.parseArguments() {
    besharp.args.start besharp_entrypoint_args "${@}"

    besharp.args.processArray "--preset"
    besharp.args.processFlag "--compile-all"
    besharp.args.processFlag "--skip-compilation"

    besharp.args.finish false
}

