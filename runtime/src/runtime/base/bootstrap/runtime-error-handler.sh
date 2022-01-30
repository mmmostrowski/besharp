#!/usr/bin/env bash

function besharp.runtime.error() {
    besharp.error "$( besharp.runtime.logbesharp.runtime.error "${@}" 2>&1 )"
}

