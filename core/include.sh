#!/usr/bin/env bash

export besharp_root_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/../" &> /dev/null && pwd )"

function main() {
    source "${besharp_root_dir}/runtime/microframework/include.sh"
    besharp.files.sourceDir "${besharp_root_dir}/core/src/"
    besharp.files.sourceDir "${besharp_root_dir}/runtime/src/runtime/base/"

    besharp.microframework.boostrap "besharp core"
}
main "${@}"
