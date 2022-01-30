#!/usr/bin/env bash

function besharp.runtime.entrypoint_external_dynamic() {
    set -eu

    besharp.runtime.parseEntrypointArgs "${@}"

    besharp.runtime.includeSourcecode "${PWD:-$(pwd)}"

    besharp.runtime.run "${besharp_runtime_args[@]}"
}

function besharp.runtime.entrypoint_external_static() {
    set -eu

    besharp.runtime.includeSourcecode "${PWD:-$(pwd)}"

    besharp.runtime.run "${@}"
}

function besharp.runtime.entrypoint_embedded_dynamic() {
    set -eu

    besharp.runtime.parseEntrypointArgs "${@}"

    besharp.runtime.includeSourcecode "$( dirname "${0}" )"

    besharp.runtime.run "${besharp_runtime_args[@]}"
}

function besharp.runtime.entrypoint_embedded_static() {
    set -eu

    besharp.runtime.run "${@}"
}
