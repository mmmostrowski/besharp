#!/usr/bin/env bash

export besharp_compiler_args=()
export besharp_compiler_args_source=()
export besharp_compiler_args_distribution_dir=''
export besharp_compiler_args_distribution_script=''
export besharp_compiler_args_distribution_script_entrypoint=''
export besharp_compiler_args_skip_unchanged=false

function besharp.compiler.initialize() {
    besharp.args.start besharp_compiler_args "${@}"

    besharp.args.processArray "--source"
    besharp.args.processString "--distribution-dir"
    besharp.args.processString "--distribution-script"
    besharp.args.processString "--distribution-script-entrypoint"

    besharp.args.processFlag "--skip-unchanged"

    besharp.args.finish
}

function besharp.compiler.compile() {
    besharp.compiler.logLookingForChangesToCompile

    besharp.compiler.initRegistry
    besharp.compiler.scanSource
    besharp.compiler.prepareTarget
    besharp.compiler.scanTarget
    besharp.compiler.processCompilation
}

function besharp.compiler.syntaxError() {
    besharp.error "$( besharp.compiler.logSyntaxError "${@}" 2>&1 )"
}