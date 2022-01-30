#!/usr/bin/env bash

function besharp.event.fire() {
    besharp.event.fireAuto "${@}"
    besharp.event.fireRegistered "${@}"
}

function besharp.event.fireAuto() {
    local event="${1}"
    shift 1

    besharp.event.validateEvent "${event}"

    local func
    for func in $( declare -F ); do
        if [[ "${func%__${event}}" != "${func}" ]]; then
            eval "${func}" "${@}"
        fi
    done
}

function besharp.event.fireRegistered() {
    local event="${1}"
    shift 1

    besharp.event.validateEvent "${event}"

    local eventsArr="besharp_events_listeners_${event}[@]"
    if [[ -z "${!eventsArr:-}" ]]; then
        return
    fi

    local callback
    for callback in "${!eventsArr}"; do
        "${callback}" "${@}"
    done
}

function besharp.event.register() {
    local event="${1}"
    local callback="${2}"

    besharp.event.validateEvent "${event}"

    declare -ag "besharp_events_listeners_${event}"
    eval "besharp_events_listeners_${event}+=( \"${callback}\" )"
}

function besharp.event.unregister() {
    local event="${1}"
    local callback="${2}"

    besharp.event.validateEvent "${event}"

    local eventsArr="besharp_events_listeners_${event}[@]"
    if [[ -z "${!eventsArr:-}" ]]; then
        return
    fi

    local listener
    local idx=0
    for listener in "${!eventsArr}"; do
        if [[ "${listener}" == "${callback}" ]]; then
            unset "besharp_events_listeners_${event}[${idx}]"
        fi
        (( ++idx ))
    done
}

function besharp.event.unregisterAll() {
    local event="${1}"

    besharp.event.validateEvent "${event}"

    unset "besharp_events_listeners_${event}"
}

function besharp.event.validateEvent() {
    local event="${1}"

    if [[ "${event}" =~ [a-zA-Z0-9_]+ ]]; then
        return
    fi

    besharp.error "Invalid event: ${event}"
}