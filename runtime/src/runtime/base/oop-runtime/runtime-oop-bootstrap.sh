#!/usr/bin/env bash

export besharp_oopRuntime_bootstrapTags=''

function besharp.oopRuntime.bootstrap() {
    besharp.microframework.boostrap "besharp oop"

    besharp.polymorphism.run "${besharp_oopRuntime_bootstrapTags}" \
        besharp.oopRuntime.doBootstrap \
        "${@}" \
    ;
}

function besharp.oopRuntime.addBootstrapTag() {
    export besharp_oopRuntime_bootstrapTags="${besharp_oopRuntime_bootstrapTags} ${*}"
}

function besharp.oopRuntime.doBootstrap() {
    local entrypointClass="${1:-Entrypoint}"
    shift 1

    if [[ -z "${entrypointClass}" ]]; then
          besharp.runtime.welcomeEntrypoint
          return 1
    fi

    besharp.oopRuntime.flushDiBindings
    besharp.oopRuntime.createStaticInstances

    if ! besharp.oopRuntime.diIsImplementing "${entrypointClass}" Entrypoint; then
          besharp.runtime.welcomeEntrypoint
          return 1
    fi

    if ! @is "${entrypointClass}" Entrypoint; then
        besharp.runtime.error "Entrypoint class '${entrypointClass}' must @implement an Entrypoint interface!"
    fi

    local entrypoint
    @let entrypoint = besharp.oopRuntime.diCreateInstance "${entrypointClass}"
    $entrypoint.main "${@}"
}

