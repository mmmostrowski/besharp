#!/usr/bin/env bash

export besharp_io_file_listing_protector_counter=3333

if [[ -w /dev/shm/ ]] && mkdir -p /dev/shm/besharp/; then
    export besharp_io_buffer_file="/dev/shm/besharp/${BASHPID}"
elif [[ -w /tmp/ ]] && mkdir -p /tmp/besharp/; then
    export besharp_io_buffer_file="/tmp/besharp/${BASHPID}"
else
    export besharp_io_buffer_file
    besharp_io_buffer_file="$(mktemp)"
fi
if [[ -z "${besharp_io_buffer_file}" ]]; then
    echo "Cannot bootstrap due to lack of access to temporary files!" >&2
    exit 1
fi

function besharp.files.lsToVar() {
    local varName="${1}"
    shift 1

    echo "IFS='' read -r -d '' ${varName} <<\"EOFEOF867756yhythdfg\"" > "${besharp_io_buffer_file}"
    ls "${@}" >> "${besharp_io_buffer_file}"
    echo "EOFEOF867756yhythdfg" >> "${besharp_io_buffer_file}"
    source "${besharp_io_buffer_file}" || true
}

function besharp.files.sourceDir() {
    local dir="${1}"
    local fileExt="${2:-sh}"
    local orgDir="${3:-${dir}}"

    local dirItems
    besharp.files.lsToVar dirItems "${dir}"

    local file
    local counter=0
    for file in ${dirItems}; do
        if (( ! --besharp_io_file_listing_protector_counter )); then
            besharp.error "I cannot load '${orgDir}' folder! Too many files!"
        fi

        file="${dir%/}/${file}"
        if [[ -d "${file}" ]]; then
            besharp.files.sourceDir "${file}" "${fileExt}" "${orgDir}"
            continue
        fi

        if [[ "${file%.${fileExt}}" != "${file}" ]]; then
            source "${file}"
        fi
    done
}

function besharp.files.listDirs() {
    local dir="${1}"

    local file
    for file in $( ls "${dir}" ); do
        file="${dir%/}/${file}"
        if [[ -d "${file}" ]]; then
            basename "${file}"
        fi
    done
}

function besharp.files.listAllDirs() {
    local dir="${1}"

    local file
    for file in $( ls "${dir}" ); do
        file="${dir%/}/${file}"
        if [[ -d "${file}" ]]; then
            echo "${file}"
            besharp.files.listAllDirs "${file}"
        fi
    done
}

function besharp.files.listDirs() {
    local dir="${1}"

    local file
    for file in $( ls "${dir}" ); do
        file="${dir%/}/${file}"
        if [[ -d "${file}" ]]; then
            basename "${file}"
        fi
    done
}

function besharp.files.listAllFiles() {
    local dir="${1}"

    local file
    for file in $( ls "${dir}" ); do
        file="${dir%/}/${file}"
        if [[ -d "${file}" ]]; then
            besharp.files.listAllFiles "${file}"
            continue
        fi

        if [[ -f "${file}" ]]; then
            echo "${file}"
        fi
    done
}

function besharp.files.listFiles() {
    local dir="${1}"

    local file
    for file in $( ls "${dir}" ); do
        file="${dir%/}/${file}"
        if [[ -f "${file}" ]]; then
            basename "${file}"
        fi
    done
}

