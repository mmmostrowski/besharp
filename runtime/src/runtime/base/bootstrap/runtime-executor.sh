#!/usr/bin/env bash

export besharp_oopRuntime_entrypoint_args_provided=false

function besharp.runtime.run() {
    local entrypointClass="${besharp_runtime_args_besharp_entrypoint}"
    if [[ -z "${entrypointClass}" ]]; then
        entrypointClass="${besharp_runtime_entrypoint}"
    fi
    besharp.oopRuntime.bootstrap "${entrypointClass}" "${@}"
}

function besharp.runtime.welcomeEntrypoint() {
    echo "BeSharp by Maciej Ostrowski (c) 2021"
    echo "--"

    besharp.error "$(
        echo "Need a class implementing an 'Entrypoint' interface!"
        echo ""
        echo "Are you sure you have a '@bind Entrypoint @with YourAppClass' entry in your di.sh file?"
        echo ""
        if $besharp_oopRuntime_entrypoint_args_provided; then
            echo "You can attach such file by:"
            echo "   --besharp-include <path1> [--besharp-include <path2>] [ ... ]"
            echo ""
            echo "Consider overriding entrypoint by:"
            echo "   --besharp-entrypoint <arg> ( or \$besharp_runtime_entrypoint env variable )"
        fi
    )"
}

function besharp.runtime.parseEntrypointArgs() {
    besharp_oopRuntime_entrypoint_args_provided=true

    besharp.args.start besharp_runtime_args "${@}"
    besharp.args.processArray '--besharp-include'
    besharp.args.processString '--besharp-entrypoint' ""
    besharp.args.finish false
}

function besharp.runtime.includeSourcecode() {
    local defaultDir="${1}"

    if [[ -z "${besharp_runtime_args_besharp_include[*]:-}" ]]; then
        besharp_runtime_args_besharp_include=( "${defaultDir}" )
    fi

    local path
    for path in "${besharp_runtime_args_besharp_include[@]}"; do
        if [[ -z "${path}" ]]; then
            continue
        fi

        if [[ -d "${path}" ]]; then
            export beshfile_section__oop_meta=true
            export beshfile_section__code=true
            export beshfile_section__launcher=false
            besharp.files.sourceDir "${path}" "be.sh"
        elif [[ -f "${path}" ]]; then
            export beshfile_section__oop_meta=true
            export beshfile_section__code=true
            export beshfile_section__launcher=false
            source "${path}"
        else
            besharp.error "What is '${path}'?"
        fi
    done
}