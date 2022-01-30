#!/usr/bin/env bash
set -eu

export besharp_microframework_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

function main() {
    source "${besharp_microframework_dir}/src/utils/utils-files.sh"
    besharp.files.sourceDir "${besharp_microframework_dir}/src/"

    besharp.microframework.boostrap "besharp microframework"
}
main "${@}"
