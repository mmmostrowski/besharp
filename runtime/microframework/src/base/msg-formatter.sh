#!/usr/bin/env bash

function @fmt() {
    besharp.format "${@}"
}

export besharp_colors_available=false
if tty -s && [[ -t 1 ]]; then
    export besharp_colors_available=true
fi

export besharp_formatter_reset="\e[0m"
export besharp_formatter_bold="\e[1m"
export besharp_formatter_dim="\e[2m"
export besharp_formatter_underline="\e[4m"
export besharp_formatter_color_default="\e[39m"
export besharp_formatter_color_white="\e[97m"
export besharp_formatter_color_lightGray="\e[37m"
export besharp_formatter_color_darkGray="\e[90m"
export besharp_formatter_color_black="\e[30m"
export besharp_formatter_color_red="\e[31m"
export besharp_formatter_color_green="\e[32m"
export besharp_formatter_color_yellow="\e[33m"
export besharp_formatter_color_blue="\e[34m"
export besharp_formatter_color_magenta="\e[35m"
export besharp_formatter_color_cyan="\e[36m"
export besharp_formatter_color_lightRed="\e[91m"
export besharp_formatter_color_lightGreen="\e[92m"
export besharp_formatter_color_lightYellow="\e[93m"
export besharp_formatter_color_lightBlue="\e[94m"
export besharp_formatter_color_lightMagenta="\e[95m"
export besharp_formatter_color_lightCyan="\e[96m"
export besharp_formatter_color_bgDefault="\e[49m"
export besharp_formatter_color_bgWhite="\e[107m"
export besharp_formatter_color_bgLightGray="\e[47m"
export besharp_formatter_color_bgDarkGray="\e[100m"
export besharp_formatter_color_bgBlack="\e[40m"
export besharp_formatter_color_bgRed="\e[41m"
export besharp_formatter_color_bgGreen="\e[42m"
export besharp_formatter_color_bgYellow="\e[43m"
export besharp_formatter_color_bgBlue="\e[44m"
export besharp_formatter_color_bgMagenta="\e[45m"
export besharp_formatter_color_bgCyan="\e[46m"
export besharp_formatter_color_bgLightRed="\e[101m"
export besharp_formatter_color_bgLightGreen="\e[102m"
export besharp_formatter_color_bgLightYellow="\e[103m"
export besharp_formatter_color_bgLightBlue="\e[104m"
export besharp_formatter_color_bgLightMagenta="\e[105m"
export besharp_formatter_color_bgLightCyan="\e[106m"

function besharp.formatMessage() {
    local label="${1}"
    local labelStyles="${2}"
    local textStyles="${3}"
    shift 3

    echo ''
    echo -e "$( @fmt ${labelStyles} )${label}:$( @fmt reset ) $( @fmt ${textStyles} )${*}$( @fmt reset )"
    besharp.format reset
    echo ''
}

function besharp.format() {
    if ! $besharp_colors_available; then
        return
    fi

    local style
    for style in "${@}"; do
        local varName="besharp_formatter_${style}"

        if [[ -z "${!varName:-}" ]]; then
            varName="besharp_formatter_color_${style}"
        fi

        if [[ -z "${!varName:-}" ]]; then
            besharp.error "Invalid formatter style: ${style}"
        fi

        echo -e -n "${!varName:-}"
    done
}