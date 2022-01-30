#!/usr/bin/env bash

declare -Ag besharp_shutdown_callbacks
declare -Ag besharp_shutdown_callback_functions
#declare -ag besharp_shutdown_callback_x_args

function besharp.shutdown()
{
    besharp.runShutdownCallbacks
}

function besharp.addShutdownCallback()
{
    local name="${1}"
    local callback="${2}"
    shift 2

    besharp_shutdown_callbacks["${name}"]="${name}"
    besharp_shutdown_callback_functions["${name}"]="${callback}"
    eval "declare -ag besharp_shutdown_callback_${name}_args=( \"\${@}\" )"
}

function besharp.removeShutdownCallback()
{
    local name="${1}"

    unset "besharp_shutdown_callbacks[\"${name}\"]"
    unset "besharp_shutdown_callback_functions[\"${name}\"]"
    unset "besharp_shutdown_callback_${name}_args"
}

function besharp.runShutdownCallbacks()
{
    local name
    for name in "${besharp_shutdown_callbacks[@]}"; do
        local callback="${besharp_shutdown_callback_functions[${name}]}"

        eval "${callback} \${besharp_shutdown_callback_${name}_args[@]}"
    done
}

