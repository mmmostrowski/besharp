#!/usr/bin/env bash

function besharp.runtime.logbesharp.runtime.error() {
    besharp.runtime.log "$( @fmt lightRed bold )${*}$( @fmt reset )"
}

function besharp.runtime.log() {
    echo "$( @fmt dim )RUNTIME:$( @fmt reset ) ${*}" >&2
}

