#!/usr/bin/env bash

function t() {
    besharp.debugTrace 2

    local varName="${1:-}"
    if [[ -n "${varName}" ]] && [[ "$(type -t "${varName}" 2> /dev/null || true)" == "function" ]]; then
         "${@}"
    else
        besharp.initDebugger
        echo -n "${besharp_debugger_fmt_headerBStyle}${*}${besharp_debugger_fmt_resetStyle}"
    fi
}

function besharp.debugTrace() {
    local numOfTopEntriesToSkip="${1:-}"

    local stack=""
    local i
    local stackSize="${#FUNCNAME[@]}"

    echo -e "" >&2
    echo -e "  Bash stacktrace:" >&2

    for (( i=numOfTopEntriesToSkip; i < "${stackSize}"; i++ )); do
        local func="${FUNCNAME[${i}]}"
        local linen="${BASH_LINENO[$(( i - 1 ))]}"
        local src="${BASH_SOURCE[${i}]}"

        if [[ "${func}" == "" ]]; then
            func="START"
        fi

        if [[ "${src}" == "" ]]; then
            src="non_file_source"
        fi

        src="${src//\/\//\/}"

        if (( i == 1 )); then
            echo -e "      at: ${func}(${*})   $( @fmt dim )${src}:${linen}$( @fmt reset )" >&2
        else
            echo -e "      at: ${func}()   $( @fmt dim )${src}:${linen}$( @fmt reset )" >&2
        fi
    done

    echo -e "" >&2
    echo -e "" >&2
}

function besharp.generateDebugTrace() {
    local numOfTopEntriesToSkip="${1:-}"

    local stack=""
    local i
    local stackSize="${#FUNCNAME[@]}"

    for (( i=numOfTopEntriesToSkip; i < "${stackSize}"; i++ )); do
        local func="${FUNCNAME[${i}]}"
        local linen="${BASH_LINENO[$(( i - 1 ))]}"
        local src="${BASH_SOURCE[${i}]}"

        if [[ "${func}" == "" ]]; then
            func="START"
        fi

        if [[ "${src}" == "" ]]; then
            src="non_file_source"
        fi

        src="${src//\/\//\/}"

        if (( i == 1 )); then
            echo -e "at: ${func}(${*})   $( @fmt dim )${src}:${linen}$( @fmt reset )"
        else
            echo -e "at: ${func}()   $( @fmt dim )${src}:${linen}$( @fmt reset )"
        fi
    done
}

