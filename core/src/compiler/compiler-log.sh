#!/usr/bin/env bash

function besharp.compiler.logTargetRemoval() {
    local file="${1}"

    besharp.compiler.log "Removed $( @fmt bold )${file}$( @fmt reset ) because it has no matching source file."
}

function besharp.compiler.logDistributionScriptCompiled() {
    local file="${1}"

    besharp.compiler.log "Compiled into $( @fmt bold )${file}$( @fmt reset )."
}

function besharp.compiler.logSyntaxError() {
    besharp.compiler.log "$( @fmt lightRed bold )Syntax error!$( @fmt reset ) $( @fmt red )${*}$( @fmt reset )"
}

function besharp.compiler.logBesharpCorruptedFile() {
    local file="${1}"

    besharp.compiler.log "Corrupted file $( @fmt bold )${file}$( @fmt reset )!"
}

function besharp.compiler.logNoChangesNothingToCompile() {
    besharp.compiler.log "No changes found. Skip."
}

function besharp.compiler.logLookingForChangesToCompile() {
    besharp.compiler.log "Looking for changes ... "
}

function besharp.compiler.logNoFileChangesNothingToCompile() {
    local file="${1}"

    besharp.compiler.debug "No changes for $( @fmt bold )${file}$( @fmt reset ) file. Skip."
}

function besharp.compiler.logChangesDetectedCompilationNeeded() {
    local file="${1}"

    besharp.compiler.log "Changes found for $( @fmt bold )${file}$( @fmt reset ) file. Compiling ... "
}

function besharp.compiler.logFoundForCompilation() {
    local file="${1}"

    besharp.compiler.debug "Collected for compilation $( @fmt bold )${file}$( @fmt reset ) ... "
}

function besharp.compiler.logCompilationForFile() {
    local file="${1}"

    besharp.compiler.log "Compiling $( @fmt bold )${file}$( @fmt reset ) ... "
}

function besharp.compiler.debug() {
    if besharp.isLoggingDebug; then
        echo "$( @fmt dim )COMPILER DEBUG:$( @fmt reset ) ${*}" >&2
    fi
}

function besharp.compiler.log() {
    echo "$( @fmt dim )COMPILER:$( @fmt reset ) ${*}" >&2
}

function besharp.compiler.logBuilder() {
    echo "$( @fmt dim )BUILDER:$( @fmt reset ) ${*}" >&2
}

function besharp.compiler.logBuilderSection() {
    echo "" >&2
    echo "$( @fmt dim )BUILDER:$( @fmt reset ) $( @fmt bold )${*}$( @fmt reset )" >&2
}
