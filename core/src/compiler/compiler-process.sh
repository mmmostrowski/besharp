#!/usr/bin/env bash

function besharp.compiler.processCompilation() {
    besharp.compiler.processCompilationDistributionDir
    besharp.compiler.processCompilationDistributionScript
}

function besharp.compiler.processCompilationDistributionDir() {
    local changes
    changes="$( besharp.compiler.findChangedSourceItems )"

    if [[ -z "${changes}" ]]; then
        besharp.compiler.logNoChangesNothingToCompile
        return
    fi

    local item
    for item in ${changes}; do
        besharp.compiler.compileItem "${item}"
    done
}

function besharp.compiler.processCompilationDistributionScript() {
    if [[ -z "${besharp_compiler_args_distribution_script}" ]]; then
        return
    fi

    local weight=1
    local weightVar
    local sourceBeshfiles=()
    while weightVar="besharp_compiler_src_by_weight_${weight}[@]"; [[ -n "${!weightVar:-}" ]]; do
        local item
        for item in "${!weightVar}"; do
            sourceBeshfiles+=( "${item}" )
        done
        (( ++weight ))
    done

    besharp.compiler.mergeBeshfiles "${besharp_compiler_args_distribution_script_entrypoint}" \
        "${sourceBeshfiles[@]}" \
      > "${besharp_compiler_args_distribution_script}"

    chmod a+x "${besharp_compiler_args_distribution_script}"

    besharp.compiler.logDistributionScriptCompiled "${besharp_compiler_args_distribution_script}"
}

