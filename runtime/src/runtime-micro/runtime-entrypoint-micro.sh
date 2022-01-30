#!/usr/bin/env bash

function besharp.runtime.entrypoint_micro() {
    set -eu

    if ! command -v "${BESHARP_RUNTIME_PATH:-besharp}" > /dev/null 2> /dev/null; then
        echo "" >&2
        echo "Cannot find ${BESHARP_RUNTIME_PATH:-besharp} !" >&2
        echo "" >&2
        echo "Please either make it accessible by your \$PATH variable, " >&2
        echo "or provide \${BESHARP_RUNTIME_PATH} environment variable pointing to the 'besharp' executable file. " >&2
        return 1
    fi

    "${BESHARP_RUNTIME_PATH:-besharp}" --besharp-include "${0}" \
        "${@}" \
    ;

}
