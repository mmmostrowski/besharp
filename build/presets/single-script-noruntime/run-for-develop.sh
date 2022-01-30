#!/usr/bin/env bash

function main() (
    export beshfile_section__oop_meta=true
    export beshfile_section__code=false
    export beshfile_section__launcher=false

    source "${ROOT_DIR}/runtime/dist/besharp-runtime"*
    besharp.files.sourceDir "${ROOT_DIR}/runtime/microframework/src/"
    besharp.files.sourceDir "${ROOT_DIR}/runtime/src/runtime/base/oop-runtime/"
    besharp.files.sourceDir "${ROOT_DIR}/runtime/src/runtime/oop/"
    besharp.files.sourceDir "${ROOT_DIR}/runtime/src/runtime/api/"

    besharp.files.sourceDir "${CURRENT_PRESET_DIST}"
    besharp.files.sourceDir "${ROOT_DIR}/app/dist/.compiled/"

    besharp.oopRuntime.turnOnDevelopMode

    besharp.files.sourceDir "${ROOT_DIR}/app/src/"

    besharp.oopRuntime.bootstrap "${besharp_runtime_entrypoint}" "${@}"
)
main "${@}"
