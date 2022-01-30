#!/usr/bin/env bash
set -eu

export besharp_runtime_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/" &> /dev/null && pwd )"

function main() {
    source "${besharp_runtime_dir}/microframework/include.sh"

    besharp.files.sourceDir "${besharp_runtime_dir}/src/"
}
main "${@}"
