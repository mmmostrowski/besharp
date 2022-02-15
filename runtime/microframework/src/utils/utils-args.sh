#!/usr/bin/env bash

export besharp_args_current_var=''

function besharp.args.start() {
    local targetArrayVar="${1}"
    shift 1

    local arg
    for arg in "${@}"; do
        eval "${targetArrayVar}+=( \"\${arg}\" )"
    done

    besharp_args_current_var="${targetArrayVar}"
}

function besharp.args.finish() {
    local errorOnUnknownFlags="${1:-true}"

    if $errorOnUnknownFlags; then
        local arg
        local arrVar="${besharp_args_current_var}[@]"
        for arg in "${!arrVar}"; do
            if [[ "${arg#--}" != "${arg}" ]]; then
                besharp.error "Unknown flag: ${arg} !"
            fi
        done
    fi

    besharp_args_current_var=''
}

function besharp.args.processFlag() {
    local flagName="${1}"
    local inverted="${2:-false}"

    if besharp.args.isCurrentEmpty; then
        return
    fi

    flagName="${flagName#--}"

    local arg
    local targetVar="${besharp_args_current_var}_${flagName//-/_}"
    local besharp_args_current_arr="${besharp_args_current_var}[@]"

    local filteredArgs=()

    if $inverted; then
        export "${targetVar}=true"
    else
        export "${targetVar}=false"
    fi
    for arg in "${!besharp_args_current_arr:-}"; do
        if [[ "${arg}" == "--${flagName}" ]]; then
            if $inverted; then
                export "${targetVar}=false"
            else
                export "${targetVar}=true"
            fi
            continue
        fi

        filteredArgs+=( "${arg}" )
    done

    besharp.array.clone filteredArgs ${besharp_args_current_var}
}

function besharp.args.processString() {
    local flagName="${1}"
    local default="${2:-}"

    if besharp.args.isCurrentEmpty; then
        return
    fi

    flagName="${flagName#--}"

    local valueInNextArg=false
    local arg
    local arrayVar="${besharp_args_current_var}[@]"
    local targetVar="${besharp_args_current_var}_${flagName//-/_}"
    local besharp_args_current_arr="${besharp_args_current_var}[@]"

    local filteredArgs=()

    export "${targetVar}=${default}"
    for arg in "${!besharp_args_current_arr}"; do
        if $valueInNextArg; then
            valueInNextArg=false
            export "${targetVar}=${arg}"
        elif [[ "${arg}" =~ "--${flagName}=" ]]; then
            export "${targetVar}=${arg#--${flagName}=}"
        elif [[ "${arg}" == "--${flagName}" ]]; then
            valueInNextArg=true
        else
            filteredArgs+=( "${arg}" )
        fi
    done

    besharp.array.clone filteredArgs ${besharp_args_current_var}
}

function besharp.args.isCurrentEmpty() {
    eval "local size=\${#${besharp_args_current_var}[@]}"
    (( size == 0 ))
}

function besharp.args.processArray() {
    local flagName="${1}"
    shift 1
    local defaults=( "${@}" )

    if besharp.args.isCurrentEmpty; then
        return
    fi

    flagName="${flagName#--}"

    local valueInNextArg=false
    local arg
    local arrayVar="${besharp_args_current_var}[@]"
    local targetVar="${besharp_args_current_var}_${flagName//-/_}"
    local besharp_args_current_arr="${besharp_args_current_var}[@]"

    local filteredArgs=()

    declare -ag "${targetVar}=()"
    for arg in "${!besharp_args_current_arr:-}"; do
        if $valueInNextArg; then
            valueInNextArg=false
            eval "${targetVar}+=( \"\${arg}\" )"
        elif [[ "${arg}" =~ "--${flagName}=" ]]; then
            local noFlagArg="${arg#--${flagName}=}"
            eval "${targetVar}+=( \"\${noFlagArg}\" )"
        elif [[ "${arg}" == "--${flagName}" ]]; then
            valueInNextArg=true
        else
            filteredArgs+=( "${arg}" )
        fi
    done

    eval "local size=\${#${targetVar}[@]}"
    if (( size == 0 )); then
        besharp.array.clone defaults ${targetVar}
    fi

    besharp.array.clone filteredArgs ${besharp_args_current_var}
}
