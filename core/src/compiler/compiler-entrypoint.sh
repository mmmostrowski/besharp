#!/usr/bin/env bash

function besharp.entrypoint.compiler() {
    besharp.compiler.initialize "${@}"
    besharp.compiler.compile
}

