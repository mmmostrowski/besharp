#!/usr/bin/env bash

function besharp.builder.run() {
    besharp.compiler.logBuilder "$(
        echo "${*}" | sed "s|${besharp_root_dir%/}/||g"
    )"
    "${@}"
}