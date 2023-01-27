#!/usr/bin/env bash
# <<< BeShMeTa
# unknown-source 0.1.0 composed-beshfile
# 
# >>> BeShMeTa
beshfile_section__code=true;beshfile_section__oop_meta=true
declare -Ag besharp_oop_types #besharp-initializer-marker
declare -Ag besharp_oop_classes #besharp-initializer-marker
declare -Ag besharp_oop_interfaces #besharp-initializer-marker
declare -Ag besharp_oop_type_parent #besharp-initializer-marker
declare -Ag besharp_oop_type_abstract #besharp-initializer-marker
declare -Ag besharp_oop_type_internal #besharp-initializer-marker
declare -Ag besharp_oop_type_static #besharp-initializer-marker
declare -Ag besharp_oop_type_static_accessor #besharp-initializer-marker
declare -Ag besharp_oop_type_is #besharp-initializer-marker
if ${beshfile_section__code:-false}; then :; 

export besharp_error_default_message=

function besharp.error() {
    set +x
    besharp.formatMessage ERROR "bold red" "lightRed" "${@}" >&2
    besharp.debugTrace 2

    if (( BASHPID != besharp_main_pid )); then
        kill  ${besharp_main_pid} 2> /dev/null || true
        kill  ${BASHPID} 2> /dev/null || true
    fi

    besharp.error.disableHandling

    exit 1
    return 1
}

function besharp.error.enableHandling() {
      local customMessage="${1}"

      besharp_error_default_message="${1}"

      trap "responseCode=\$?; besharp.shutdown; if (( \$responseCode != 0 )); then besharp.error \${besharp_error_default_message:-Unexpected command failure}; fi" EXIT
      trap "besharp.shutdown; exit 1" INT
}

function besharp.error.disableHandling() {
      trap "" EXIT
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.info() {
    besharp.formatMessage INFO "bold green" "lightGreen" "${@}"
}

function besharp.warning() {
    besharp.formatMessage WARNING "bold yellow" "lightYellow" "${@}" >&2
}

fi
if ${beshfile_section__code:-false}; then :;

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

fi
if ${beshfile_section__code:-false}; then :;

function besharp.polymorphism.initialize() {
    declare -ag besharp_polymorphism_layers=()
}

function besharp.polymorphism.currentTag() {
    echo "${besharp_polymorphism_tags[@]}"
}

function besharp.polymorphism.run() {
    local tags="${1}"
    shift 1

    if [[ -z "${tags}" ]]; then
        "${@}"
        return
    fi

    besharp.polymorphism.activateLayer "${tags}"

    "${@}"

    besharp.polymorphism.deactivateLayer
}

function besharp.polymorphism.activateLayer() {
    local tags="${1}"

    local allFunctions=
    allFunctions=$( declare -F )

    local tag
    local func
    local funcBase
    local rejected

    local orgFunctions=":"

    while read func; do
        func="${func#declare -f }"
        funcBase="${func}"
        rejected=false

        for tag in ${tags}; do
            if [[ "${func//__${tag}/}" != "${func}" ]]; then
                funcBase="${funcBase//__${tag}/}"
                continue
            fi
            rejected=true
        done

        if ! $rejected && [[ "${funcBase//__/}" == "${funcBase}" ]]; then
            local orgFunc="$( declare -f "${funcBase}" )"
            local newFunc="$( declare -f "${func}" )"

            eval "${funcBase}${newFunc#${func}}"

            orgFunctions="${orgFunctions}; ${orgFunc}"
        fi

    done<<<"${allFunctions}"

    besharp_polymorphism_layers+=( "${orgFunctions}" )
}

function besharp.polymorphism.deactivateLayer() {
    eval "${besharp_polymorphism_layers[-1]}"
    unset "besharp_polymorphism_layers[-1]"
}

fi
if ${beshfile_section__code:-false}; then :;

declare -Ag besharp_shutdown_callbacks
declare -Ag besharp_shutdown_callback_functions
#declare -ag besharp_shutdown_callback_x_args

function besharp.shutdown()
{
    besharp.runShutdownCallbacks
}

function besharp.addShutdownCallback()
{
    local name="${1}"
    local callback="${2}"
    shift 2

    besharp_shutdown_callbacks["${name}"]="${name}"
    besharp_shutdown_callback_functions["${name}"]="${callback}"
    eval "declare -ag besharp_shutdown_callback_${name}_args=( \"\${@}\" )"
}

function besharp.removeShutdownCallback()
{
    local name="${1}"

    unset "besharp_shutdown_callbacks[\"${name}\"]"
    unset "besharp_shutdown_callback_functions[\"${name}\"]"
    unset "besharp_shutdown_callback_${name}_args"
}

function besharp.runShutdownCallbacks()
{
    local name
    for name in "${besharp_shutdown_callbacks[@]}"; do
        local callback="${besharp_shutdown_callback_functions[${name}]}"

        eval "${callback} \${besharp_shutdown_callback_${name}_args[@]}"
    done
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.terminal.clear() {
    clear 2> /dev/null || true
}

fi
if ${beshfile_section__code:-false}; then :;

export besharp_main_pid=${BASHPID}
export besharp_loglevel=info # debug error

function besharp.microframework.boostrap() {
    local scopeName="${1:-besharp microframework}"

    if besharp.isDebugModeRequested; then
        besharp.turnDebuggingOn
    fi

    besharp.polymorphism.initialize
    besharp.error.enableHandling "Unexpected command failure at the ${scopeName} scope"
}

function besharp.isLoggingError() {
    [[ "${besharp_loglevel}" == 'info' ]] || [[ "${besharp_loglevel}" == 'debug' ]] || [[ "${besharp_loglevel}" == 'error' ]]
}

function besharp.isLoggingInfo() {
    [[ "${besharp_loglevel}" == 'info' ]] || [[ "${besharp_loglevel}" == 'debug' ]]
}

function besharp.isLoggingDebug() {
    [[ "${besharp_loglevel}" == 'debug' ]]
}

fi
if ${beshfile_section__code:-false}; then :;

export besharp_debugger_fmt_currently_in_group=false

function besharp.initializeStyles() {
    export besharp_debugger_fmt_resetStyle="$( @fmt reset )"
    export besharp_debugger_fmt_headerAStyle="$( @fmt reset )$( @fmt bold black bgDarkGray )"
    export besharp_debugger_fmt_headerBStyle="$( @fmt reset )$( @fmt bold lightYellow bgDarkGray )"
    export besharp_debugger_fmt_headerCStyle="$( @fmt reset )$( @fmt darkGray )"
    export besharp_debugger_fmt_headerDStyle="$( @fmt reset )$( @fmt darkGray bgDarkGray )"
    export besharp_debugger_fmt_blockStyle="$( @fmt reset )$( @fmt white bgDarkGray )"
}

function besharp.debugLines() {
    local input="${1}"

    local line
    local lineNum=0
    while besharp.readLine line; do
        local lineNumStr=$(( ++lineNum ))
        if (( lineNum < 10 )); then
            lineNumStr="0${lineNumStr}"
        fi
        besharp.debugTaggedLine "${lineNumStr}" "${line}"
    done<<<"${input}"
}

function besharp.debugHeader() {
    local headerA="${1}"
    local headerB="${2:-}"

    local linen="${BASH_LINENO[1]}"
    local src="${BASH_SOURCE[2]}"

    local source=" @ ${src//\/\//\/}:${linen}"

    if ! $besharp_debugger_fmt_currently_in_group; then
        echo '' >&2
    fi

    if [[ -z "${headerB}" ]]; then
        echo "${besharp_debugger_fmt_blockStyle}$(besharp.debugIndent)/ ${besharp_debugger_fmt_headerAStyle}${headerA}   ${besharp_debugger_fmt_headerCStyle}${source} ${besharp_debugger_fmt_resetStyle}" >&2
    else
        echo "${besharp_debugger_fmt_blockStyle}$(besharp.debugIndent)/ ${besharp_debugger_fmt_headerAStyle}${headerA} ${besharp_debugger_fmt_headerBStyle}${headerB}${besharp_debugger_fmt_headerAStyle}  ${besharp_debugger_fmt_headerCStyle}${source} ${besharp_debugger_fmt_resetStyle}" >&2
    fi
}

function besharp.debugFooter() {
    echo -n "${besharp_debugger_fmt_blockStyle}$(besharp.debugIndent)\\${besharp_debugger_fmt_resetStyle}" >&2
    while (( besharp_debug_keys_column_length > 0 )) && (( --besharp_debug_keys_column_length )); do
        echo -n "${besharp_debugger_fmt_blockStyle}_${besharp_debugger_fmt_resetStyle}" >&2
    done
    echo "${besharp_debugger_fmt_blockStyle}/${besharp_debugger_fmt_resetStyle}" >&2

    if ! $besharp_debugger_fmt_currently_in_group; then
        echo '' >&2
    fi
}

function besharp.debugLine() {
    echo "${besharp_debugger_fmt_blockStyle}$(besharp.debugIndent)|${besharp_debugger_fmt_resetStyle} ${*}" >&2
}

function besharp.debugSeparator() {
    local size="${1:-2}"

    if (( size <= 0 )); then
        return
    fi

    echo -n "${besharp_debugger_fmt_blockStyle}$(besharp.debugIndent)"
    while (( size-- )); do
        echo -n "-" >&2
    done
    echo "${besharp_debugger_fmt_resetStyle}" >&2
}

function besharp.debugGroupStart() {
    echo "" >&2
    echo "${besharp_debugger_fmt_blockStyle}/==\\${besharp_debugger_fmt_resetStyle}" >&2

    besharp_debugger_fmt_currently_in_group=true
}

function besharp.debugGroupStop() {
    echo "${besharp_debugger_fmt_blockStyle}\==/${besharp_debugger_fmt_resetStyle}" >&2
    echo "" >&2
    echo "" >&2

    besharp_debugger_fmt_currently_in_group=false
}

function besharp.debugTaggedLine() {
    local tag="${1}"
    shift 1

    if (( ${#tag} + 3 > besharp_debug_keys_column_length )); then
        besharp_debug_keys_column_length=$(( ${#tag} + 3 ))
    fi

    echo "${besharp_debugger_fmt_blockStyle}$(besharp.debugIndent)| ${tag} |${besharp_debugger_fmt_resetStyle} ${*}" >&2
}

function besharp.debugIndent() {
    local level="${besharp_debug_nesting_level}"
    if (( level == 0 )); then
        return
    fi

    if $besharp_debugger_fmt_currently_in_group; then
        echo -n '| '
    fi

    while (( --level )); do
        echo -n "# "
    done
}

fi
if ${beshfile_section__code:-false}; then :;

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

fi
if ${beshfile_section__code:-false}; then :;

function besharp.debugString() {
    local string="${1}"

    besharp.debugLines "${string}"
}

function besharp.debugVariable() {
    local varName="${1}"

    besharp.debugLines "${!varName:-}"
}

function besharp.debugFile() {
    local varName="${1}"

    besharp.debugLines "$( cat "${varName}" )"
}

function besharp.debugFunctionCall() {
    local returnCode
    set -x
    "${@}"
    returnCode=${?}
    set +x
    return ${returnCode}
}

function besharp.debugFunction() {
    local func="${1}"

    local token
    local toVerify=false
    for token in $( declare -f "${func}" ); do
        if [[ "${token}" == "local" ]]; then
            toVerify=true
            continue
        fi

        if $toVerify; then
            toVerify=false
            local potentialVariableNameArr=( ${token//=/ } )
            local varName="${potentialVariableNameArr[0]}"
            if besharp.is.Array "${varName}"; then
                eval "local value=\${${varName}[*]}"
                besharp.debugKeyedValue "local \$${varName}" "( ${value} )"
            elif besharp.is.variable "${varName}"; then
                besharp.debugKeyedValue "local \$${varName}" "${!varName}"
            fi
        fi
    done

    besharp_debug_keys_column_length=0

    besharp.debugLines "$( besharp.generateDebugTrace 4 )"
}

function besharp.debugArray() {
    local varName="${1}"

    local keys=()
    eval "for key in \${!${varName}[@]}; do keys+=( \$key ); done"
    local key
    local value
    for key in "${keys[@]}"; do
        key="${key}"
        eval "value=\"\${${varName}[\${key}]}\""
        besharp.debugKeyedValue "${key}" "${value}"
    done
}

function besharp.debugKeyedValue() {
    local key="${1}"
    local value="${2}"

    local line
    local firstLine=true
    while read line; do
        if $firstLine; then
            firstLine=false
            besharp.debugTaggedLine "${key}" "${line}"
        else
            besharp.debugLine "${line}"
        fi
    done<<<"${value}"
}

function besharp.debugDir() {
    local dir="${1}"

    local file
    for file in $( ls "${dir}" ); do
        file="${dir%/}/${file}"

        local linkFlag=""
        if [[ -L "${file}" ]]; then
            linkFlag="L"
        fi

        if [[ -d "${file}" ]]; then
            besharp.debugTaggedLine "${linkFlag}d" "${file}"
            besharp.debugDir "${file}"
        elif [[ -f "${file}" ]]; then
            besharp.debugTaggedLine "${linkFlag}f" "${file}"
        else
            besharp.debugTaggedLine "?" "${file}"
        fi
    done
}

fi
if ${beshfile_section__code:-false}; then :;

export besharp_debug_nesting_level=0
export besharp_debug_keys_column_length=0
export besharp_debugger_initialized=false

function besharp.initDebugger() {
    if ${besharp_debugger_initialized}; then
        return 0
    fi

    besharp.initializeStyles

    besharp_debugger_initialized=true
}

function besharp.debug() {
    d "${@}"
}

function d() {
    set +x

    local returnCode=0

    besharp.initDebugger

    (( ++besharp_debug_nesting_level ))

    besharp_debug_keys_column_length=0

    if [[ -z "${@}" ]]; then
        besharp.debugHeader "FUNCTION" "${FUNCNAME[1]}()"
        besharp.debugFunction "${FUNCNAME[1]}"
        besharp.debugFooter
    elif besharp.is.callback "${1}"&& ! besharp.is.variable "${1}"; then
          besharp.debugHeader "FUNCTION CALL" "${1}()"
          besharp.debugFunctionCall "${@}"
          returnCode=${?}
          besharp.debugFooter
    else
        local varName
        if (( ${#} > 1 )); then
            besharp.debugGroupStart
        fi
        for varName in "${@}"; do
            if besharp.is.indexArray "${varName}"; then
                besharp.debugHeader "INDEX ARRAY" "\${${varName}[@]}"
                besharp.debugArray "${varName}"
                besharp.debugFooter
            elif besharp.is.assocArray "${varName}"; then
                besharp.debugHeader "ASSOC ARRAY" "\${${varName}[@]}"
                besharp.debugArray "${varName}"
                besharp.debugFooter
            elif besharp.is.variable "${varName}"; then
                besharp.debugHeader "VARIABLE" "\${${varName}}"
                besharp.debugVariable "${varName}"
                besharp.debugFooter
            elif [[ -f "${varName}" ]]; then
                besharp.debugHeader "FILE" "${varName}"
                besharp.debugFile "${varName}"
                besharp.debugFooter
            elif [[ -d "${varName}" ]]; then
                besharp.debugHeader "DIRECTORY" "${varName%/}/"
                besharp.debugDir "${varName}"
                besharp.debugFooter
            else
                besharp.debugHeader "STRING"
                besharp.debugString "${varName}"
                besharp.debugFooter
            fi
        done
        if (( ${#} > 1 )); then
            besharp.debugGroupStop
        fi
    fi

    if (( --besharp_debug_nesting_level )); then
        set -x
    fi

    return ${returnCode}
}

function besharp.isDebugging() {
    [[ -n "${-//[^x]/}" ]]
}

function besharp.turnDebuggingOn() {
    set -x
}

function besharp.turnDebuggingOff() {
    set +x
}

function besharp.isDebugModeRequested() {
    [[ "${BESHARP_DEBUG:-}" == "1" ]] || [[ "${BESHARP_DEBUG:-}" == "yes" ]] || [[ "${BESHARP_DEBUG:-}" == "true" ]]
}

fi
if ${beshfile_section__code:-false}; then :;

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

fi
if ${beshfile_section__code:-false}; then :;

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

fi
if ${beshfile_section__code:-false}; then :;


function besharp.array.clone() {
    local source="${1}"
    local target="${2}"

    unset "${target}" || true
    unset "${target}[@]" || true

    local source="${source}[@]"

    eval "${target}=( )"
    local arg
    for arg in "${!source:-}"; do
        eval "${target}+=( \"\${arg}\" )"
    done
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.fastCall.toArrayOfTokens() {
    local arrName="${1}"
    shift 1

    echo -n "${arrName}=( " > "${besharp_io_buffer_file}"
    "${@}" >> "${besharp_io_buffer_file}"
    echo " )" >> "${besharp_io_buffer_file}"
    source "${besharp_io_buffer_file}"
}

function besharp.fastCall.toVar() {
    local varName="${1}"
    shift 1

    echo "IFS='' read -r -d '' ${varName} <<\"EOFEOFF123f43tdsxx\"" > "${besharp_io_buffer_file}"
    "${@}" >> "${besharp_io_buffer_file}"
    echo "EOFEOFF123f43tdsxx" >> "${besharp_io_buffer_file}"
    source "${besharp_io_buffer_file}" || true
}

function besharp.fastCall.toVarSingleToken() {
    local varName="${1}"
    shift 1

    echo -n export "${varName}=" > "${besharp_io_buffer_file}"
    "${@}" >> "${besharp_io_buffer_file}"
    source "${besharp_io_buffer_file}"
}

fi
if ${beshfile_section__code:-false}; then :;

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

fi
if ${beshfile_section__code:-false}; then :;

function besharp.readLine() {
    local oldIfs="${IFS}"

    IFS=$'\n'
    read "${@}"
    local returnCode=${?}

    IFS="${oldIfs}"

    return ${returnCode}
}

function besharp.grepList() {
    grep "${@}" || true
}

function besharp.grepMatch() {
    grep -q "${@}"
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.string.glue() {
    local separator="${1}"
    shift 1

    local item
    local firstOne=true
    for item in "${@}"; do
        if $firstOne; then
            firstOne=false
        else
            echo -n "${separator}"
        fi
        echo -n "${item}"
    done
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.is.Array() {
    besharp.is.indexArray "${@}" || besharp.is.assocArray "${@}"
}

function besharp.is.indexArray() {
    local varName="${1}"

    [[ "$( declare -p "${varName}" 2> /dev/null )" =~ "declare -a" ]]
}

function besharp.is.assocArray() {
    local varName="${1}"

    [[ "$( declare -p "${varName}" 2> /dev/null )" =~ "declare -A" ]]
}

function besharp.is.variable() {
    local varName="${1}"

    declare -p "${varName}" 2> /dev/null > /dev/null
}

function besharp.is.callback() {
    local varName="${1}"

    if [[ "$(type -t "${1}" 2> /dev/null || true)" == "function" ]]; then
        return 0
    fi

    # note: we skip 'eval' internationally to work properly with debugger
    local bashKeywords="alias awk basename bash bc bind builtin caller cat cd chgrp chmod chown command cut date declare df diff dirname du echo enable export expr find grep head help kill less let ln local logout ls mapfile mkdir more mv nohup printf pwd read readarray rm rmdir sed set sh sleep sort source tail tar tee touch tr type typeset ulimit unalias uniq unset wc xargs"
    local keyword
    for keyword in ${bashKeywords}; do
        if [[ "${varName}" == "${keyword}" ]]; then
            return 0
        fi
    done

    return 1
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.rtti.types() {
    echo "${besharp_oop_types[@]}"
}

function besharp.rtti.typeExists() {
    local type="${1}"

    [[ "${besharp_oop_types[${type}]+isset}" == 'isset' ]]
}

function besharp.rtti.isInternal() {
    local type="${1}"

    [[ "${besharp_oop_type_internal[${type}]+isset}" == 'isset' ]]
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.rtti.allFieldsOf() {
    local type="${1}"

    eval "echo \"\${besharp_oopRuntime_type_${type}_all_fields[@]:-}\""
}

function besharp.rtti.allInjectableFieldsOf() {
    local type="${1}"

    eval "echo \"\${besharp_oopRuntime_type_${type}_all_injectable_fields[@]:-}\""
}

function besharp.rtti.typeHasField() {
    local type="${1}"
    local field="${2}"

    eval "[[ \"\${besharp_oopRuntime_type_${type}_all_fields[${field}]+isset}\" == 'isset' ]]"
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.rtti.fieldsOf() {
    local type="${1}"

    eval "echo \"\${besharp_oop_type_${type}_fields[@]:-}\""
}

function besharp.rtti.typeHasDirectField() {
    local type="${1}"
    local field="${2}"

    eval "[[ \"\${besharp_oop_type_${type}_fields[${field}]+isset}\" == 'isset' ]]"
}

function besharp.rtti.typedFieldsOf() {
    local type="${1}"

    eval "echo \"\${!besharp_oop_type_${type}_field_type[@]}\""
}

function besharp.rtti.typeOfField() {
    local type="${1}"
    local field="${2}"

    eval "echo \"\${besharp_oop_type_${type}_field_type['${field}']:-}\""
}

function besharp.rtti.typeHasInjectableField() {
    local type="${1}"
    local field="${2}"

    eval "[[ \"\${besharp_oop_type_${type}_injectable_fields[${field}]+isset}\" == 'isset' ]]"
}

function besharp.rtti.injectableFieldsOf() {
    local type="${1}"

    eval "echo \"\${besharp_oop_type_${type}_injectable_fields[@]:-}\""
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.rtti.allMethodsOf() {
    local type="${1}"

    eval "echo \"\${besharp_oopRuntime_type_${type}_all_methods[@]:-}\""
}

function besharp.rtti.hasMethod() {
    local type="${1}"
    local method="${2}"

    eval "[[ \"\${besharp_oopRuntime_type_${type}_all_methods[${method}]+isset}\" == 'isset' ]]"
}

function besharp.rtti.isMethodAbstract() {
    local type="${1}"
    local method="${2}"

    eval "[[ \"\${besharp_oopRuntime_type_${type}_all_abstract_methods[${method}]+isset}\" == 'isset' ]]"
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.rtti.methodsOf() {
    local type="${1}"

    eval "echo \"\${besharp_oop_type_${type}_methods[@]:-}\""
}

function besharp.rtti.hasDirectMethod() {
    local type="${1}"
    local method="${2}"

    eval "[[ \"\${besharp_oop_type_${type}_methods['${method}']+isset}\" == 'isset' ]]"
}

function besharp.rtti.constructorOf() {
    local type="${1}"

    echo "${type}"
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.rtti.isTypeA() {
    local type="${1}"
    local typeToCheck="${2}"
    local exact="${3:-false}"

    besharp.oopRuntime.prepareType "${type}"
    besharp.oopRuntime.prepareType "${typeToCheck}"

    if [[ "${type}" == "${typeToCheck}" ]]; then
        return 0
    fi

    if $exact; then
        return 1
    fi

    if eval "[[ \${besharp_oopRuntime_type_${type}_all_interfaces[@]+isset} == 'isset' ]] && [[ \"\${besharp_oopRuntime_type_${type}_all_interfaces[${typeToCheck}]+isset}\" == 'isset' ]]"; then
        return 0
    fi

    eval "[[ \${besharp_oopRuntime_type_${type}_all_parents[@]+isset} == 'isset' ]] && [[ \"\${besharp_oopRuntime_type_${type}_all_parents[${typeToCheck}]+isset}\" == 'isset' ]]"
}

function besharp.rtti.isA() {
    local objectOrType="${1}"
    local type="${2}"
    local exact="${3:-false}"

    if [[ "${objectOrType}" == "${type}" ]]; then
        return 0
    fi

    if ! besharp.rtti.isValidTypeOrObjectCode "${objectOrType}"; then
        return 1
    fi

    if besharp.rtti.isObjectExist "${objectOrType}"; then
        besharp.rtti.isTypeA "${besharp_oopRuntime_object_types["${objectOrType}"]}" "${type}" "${exact}"
    else
        besharp.rtti.isTypeA "${objectOrType}" "${type}" "${exact}"
    fi
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.rtti.classes() {
    echo "${besharp_oop_classes[@]}"
}

function besharp.rtti.classExists() {
    local type="${1}"

    [[ "${besharp_oop_classes[${type}]+isset}" == 'isset' ]]
}

function besharp.rtti.isAbstractClass() {
    local type="${1}"

    [[ "${besharp_oop_type_abstract[${type}]+isset}" == 'isset' ]]
}

function besharp.rtti.allUserClasses() {
    local type=''
    for type in ${besharp_oop_classes[@]}; do
        if ! besharp.rtti.isInternal "${type}"; then
            echo "${type}"
        fi
    done
}

function besharp.rtti.parentOf() {
    local type="${1}"

    echo "${besharp_oop_type_parent[${type}]:-}"
}

function besharp.rtti.parentsOf() {
    local type="${1}"

    while [[ -n "${type}" ]]; do
        type="${besharp_oop_type_parent[${type}]:-}"
        echo "${type}"
    done
}

function besharp.rtti.isParentOf() {
    local type="${1}"
    local potentialParent="${2}"

    [[ "${besharp_oop_type_parent[${type}]:-}" == "${potentialParent}" ]]
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.rtti.objectType() {
    local code="${1}"

    if ! besharp.rtti.isObjectExist "${code}"; then
        return 1
    fi

    echo "${besharp_oopRuntime_object_types["${code}"]}"
}

function besharp.rtti.ensureValidObjectCode() {
    local type="${1}"
    local code="${2}"

    if [[ ! "${code}" =~ ^[abcdefghijklmnopqrstuvwxyz][abcdefghijklmnopqrstuvwxyz0-9_]*$ ]]; then
        besharp.compiler.syntaxError "Invalid object code of type ${type}: '${code}'!"
    fi

    if [[ "${besharp_oopRuntime_objects[${code}]+isset}" == "isset" ]]; then
        besharp.compiler.syntaxError "Instance '${code}' of type '${type}' already exists!"
    fi
}

function besharp.rtti.ensureValidStaticObjectCode() {
    local type="${1}"
    local code="${2}"

    if [[ ! "${code}" =~ ^@[abcdefghijklmnopqrstuvwxyz][abcdefghijklmnopqrstuvwxyz0-9_]*$ ]]; then
        besharp.compiler.syntaxError "Invalid static object code of type ${type}: '${code}'!"
    fi

    if [[ "${besharp_oopRuntime_objects[${code}]+isset}" == "isset" ]]; then
        besharp.compiler.syntaxError "Instance '${code}' of type '${type}' already exists!"
    fi
}

function besharp.rtti.isObjectExist() {
    local code="${1}"

    if ! besharp.rtti.isValidObjectCode "${code}"; then
        return 1
    fi

    [[ "${besharp_oopRuntime_objects[${code}]+isset}" == "isset" ]]
}

function besharp.rtti.isValidObjectCode() {
    local code="${1}"

    [[ "${code}" =~ ^[abcdefghijklmnopqrstuvwxyz][abcdefghijklmnopqrstuvwxyz0-9_]*$ ]]
}

function besharp.rtti.isValidTypeOrObjectCode() {
    local code="${1}"

    [[ "${code}" =~ ^[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz][ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0-9_]*$ ]]
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.rtti.allTypeInterfaces() {
    local type="${1}"

    besharp.oopRuntime.ensurePrepareType "${type}"

    eval "echo \"\${besharp_oopRuntime_type_${type}_all_interfaces[@]:-}\""
}

function besharp.rtti.allInterfaceMethodsForType() {
    local type="${1}"

    besharp.oopRuntime.ensurePrepareType "${type}"

    eval "echo \"\${besharp_oopRuntime_type_${type}_all_interface_methods[@]:-}\""
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.rtti.interfaces() {
    echo "${besharp_oop_interfaces[@]}"
}

function besharp.rtti.interfaceExists() {
    local type="${1}"

    [[ "${besharp_oop_interfaces[${type}]+isset}" == 'isset' ]]
}

function besharp.rtti.typeInterfaces() {
    local type="${1}"

    eval "echo \"\${besharp_oop_type_${type}_interfaces[@]:-}\""
}

function besharp.rtti.isImplementingDirectly() {
    local type="${1}"
    local interface="${2}"

    eval "[[ \"\${besharp_oop_type_${type}_interfaces[${interface}]+isset}\" == 'isset' ]]"
}

function besharp.rtti.interfaceMethods() {
    besharp.rtti.methodsOf "${@}"
}

function besharp.rtti.allUserInterfaces() {
    local type=''
    for type in ${besharp_oop_interfaces[@]}; do
        if ! besharp.rtti.isInternal "${type}"; then
            echo "${type}"
        fi
    done
}

fi
if ${beshfile_section__code:-false}; then :;

function @bind() {
    if $besharp_oopRuntime_binds_collecting_enabled; then
        eval "besharp_oopRuntime_collected_binds_$(( besharp_oopRuntime_binds_collector_counter++ ))+=( \"\${@}\" )"
        return
    fi

    if ! $besharp_oopRuntime_binds_enabled; then
        return
    fi


    local source="${1:-}"
    local word1="${2:-}"
    local target="${3:-}"

    local orgBinding="${*}"

    function @bind.printError() {
        besharp.compiler.syntaxError "$(
          echo "Invalid binding. ${*}. "
          echo ""
          echo "Expected binding format for class:"
          echo "   @bind \"Type\" @with \"Subtype\" "
          echo "      [ @having constructor args "
          echo "            \"arg1\""
          echo "            \"arg2\""
          echo "             ....                  ]"
          echo ""
          echo "Expected binding format for field:"
          echo "   @bind \"Type.Field\" @with \"Subtype\" "
          echo "      [ @having constructor args "
          echo "            \"arg1\""
          echo "            \"arg2\""
          echo "             ....                  ]"
          echo ""
          echo "Got: "
          echo "    @bind ${orgBinding}"
        )"
    }

    if [[ -z "${source}" ]]; then
        @bind.printError "No \"Type\" provided"
    fi

    if [[ "${word1}" != "@with" ]]; then
        @bind.printError "Missing '@with' keyword"
    fi

    if [[ -z "${target}" ]]; then
        @bind.printError "No \"Subtype\" provided"
    fi

    shift 3

    if [[ "${source#@}" != "${source}" ]]; then
        besharp.compiler.oop.compileAccessor "${source}" "${target}"
        return 0
    fi


    if [[ -n "${1:-}" ]]; then
        if [[ "${1:-} ${2:-} ${3:-}" != "@having constructor args" ]]; then
            @bind.printError "Missing '@having constructor args' phrase"
        fi

        shift 3
    fi

    besharp.oopRuntime.setupDiBinding "${source}" "${target}" "${@}"
}

fi
if ${beshfile_section__code:-false}; then :;

function @iterate() {
    local args=( "${@}" )

    if [[ "${args[@]+isset}" != "isset" ]]; then
        besharp.compiler.syntaxError "@iterate must be in form: @iterate <Iterable>|[array arguments] @in <variable>! Got: ${*}"
    fi

    if [[ "${args[1]+isset}" != "isset" ]]; then
        besharp.compiler.syntaxError "@iterate must be in form: @iterate <Iterable>|[array arguments] @in <variable>! Got: ${*}"
    fi

    local targetLocalVar="${args[-1]}"
    local word2="${args[-2]}"

    if [[ "${word2}" != "@in" ]]; then
        besharp.compiler.syntaxError "@iterate must be in form: @iterate <Iterable>|[array arguments] @in <variable>! Got: ${*}"
    fi

    unset "args[${#args[@]}-1]"
    unset "args[${#args[@]}-1]"

    if [[ "${args[@]+isset}" != "isset" ]]; then
        return 1
    fi

    if [[ "${args[0]}" == '@of' ]]; then
        unset "args[0]"
        if besharp.oopRuntime.invokeIterationOf "${targetLocalVar}" "${args[@]}"; then
            return 0
        else
            return 1
        fi
    elif [[ "${args[0]}" == '@array' ]]; then
        unset "args[0]"
        if besharp.oopRuntime.invokeArrayIteration "${targetLocalVar}" "${args[@]}"; then
            return 0
        else
            return 1
        fi
    elif [[ "${args[0]}" == '@iterable' ]]; then
        unset "args[0]"
        if besharp.oopRuntime.invokeIteration "${targetLocalVar}" "${args[1]}"; then
            return 0
        else
            return 1
        fi
    elif besharp.rtti.isA "${args[0]}" Iterable; then
        if besharp.rtti.isA "${args[1]:-}" Iterable; then
            besharp.runtime.error "You cannot @iterate array of Iterable objects! It's dangerous! Instead of array, please use another Iterable object. You can also use array dedicated syntax: @iterate @array [ array, goes, here] @in <variable>"
        fi

        if besharp.oopRuntime.invokeIteration "${targetLocalVar}" "${args[0]}"; then
            return 0
        else
            return 1
        fi
    fi

    besharp.oopRuntime.invokeArrayIteration "${targetLocalVar}" "${args[@]}"
}

fi
if ${beshfile_section__code:-false}; then :;

function @let() {
    # NOTE: this method should be careful on collisions with caller's local variables
    local target_uniqsequence_34509837572364="${1}"

    if [[ -z "${1:-}" ]]; then
       besharp.compiler.syntaxError "@let expects target: @let TARGET OPERATION [ARGS ... ], where TARGET might be either local variable or object field"
    fi

    if [[ "${2:-}" != '=' ]]; then
       besharp.compiler.syntaxError "Expected syntax @let requires ' = ' phrase before value. Got: ${*}"
    fi

    shift 2

    "${@}"

    if [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]+isset}" != "isset" ]]; then
        besharp.compiler.syntaxError "@let couldn't find any results. Did you @return any value?"
    fi

    if [[ "${target_uniqsequence_34509837572364//./}" == "${target_uniqsequence_34509837572364}" ]]; then
        # variable
       eval "${target_uniqsequence_34509837572364}=\"\${besharp_rcrvs[ besharp_rcsl + 1 ]}\""
    else
        # field
       "${target_uniqsequence_34509837572364}" = "${besharp_rcrvs[ besharp_rcsl + 1 ]}"
    fi

    unset "besharp_rcrvs[ besharp_rcsl + 1 ]"
}

fi
if ${beshfile_section__code:-false}; then :;

function @() {
    if (( ${#@} == 0 )); then
        export besharp_runtime_reset_iteration=1
    else
        @echo "${@}"
    fi
}

function @true() {
    "${@}"

    [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" == 'true' ]]
}

function @true__develop() {
    local value
    @let value = "${@}"
    [[ "${value}" == "true" ]]
}

function @false() {
    "${@}"

    [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" == 'false' ]]
}

function @false__develop() {
    local value
    @let value = "${@}"
    [[ "${value}" != "true" ]]
}

function @not() {
    "${@}"

    if [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" == 'true' ]]; then
        besharp_rcrvs[ besharp_rcsl + 1 ]="false"
    else
        besharp_rcrvs[ besharp_rcsl + 1 ]="true"
    fi
}

function @not__develop() {
    local value
    @let value = "${@}"
    if $value; then
        besharp.runtime.storeReturnValueOnStackAtDepth1 false
    else
        besharp.runtime.storeReturnValueOnStackAtDepth1 true
    fi
}

function @echo() {

    local flags=""
    while [[ "${1#\-}" != "${1}" ]]; do
      if [[ "${1}" == "-n" ]]; then
          flags="${flags} -n"
          shift 1
          continue
      elif [[ "${1}" == "-e" ]]; then
          flags="${flags} -e"
          shift 1
          continue
      elif [[ "${1}" == "-E" ]]; then
          flags="${flags} -E"
          shift 1
          continue
      fi
      break
    done

    local result=""
    if [[ "${1}" == "@of" ]] && [[ "${2+isset}" == 'isset' ]]; then
        shift 1
        # field
        @let result = "${@}"
    else
        @let result = "${@}"
    fi

    echo ${flags} "${result}"
}

fi
if ${beshfile_section__code:-false}; then :;

function @new() {
    besharp.oopRuntime.createNewInstance "${@}"
}

function @new-into() {
    local targetVar="${1}"
    shift 1

    @let ${targetVar} = besharp.oopRuntime.createNewInstance "${@}"
}

function @new-named() {
    besharp.oopRuntime.createNewInstanceNamed "${@}"
}

function @unset() {
    local object
    if [[ "${1}" == "@of" ]]; then
        shift 1
        @let object = "${@}"
    else
        object="${1}"
    fi

    besharp.oopRuntime.unsetObjectInstance "${object}"
}

function @object-id() {
    local objectOrValue="${1}"

    local objectId

    if besharp.rtti.isObjectExist "${objectOrValue}"; then
        @let objectId = $objectOrValue.__objectId
        besharp.runtime.storeReturnValueOnStackAtDepth1 "${objectId}"
        return
    fi

    besharp.runtime.storeReturnValueOnStackAtDepth1 "${objectOrValue}"
}

function @is() {
    local objectOrType="${1:-}"

    if [[ "${2:-}" == "@exact" ]]; then
        local type="${3:-}"
        local exact=true
    elif [[ "${2:-}" == "@an" ]]; then
        local type="${3:-}"
        local exact=false
    elif [[ "${2:-}" == "@a" ]]; then
        local type="${3:-}"
        local exact=false
    else
        local type="${2:-}"
        local exact=false
    fi

    besharp.rtti.isA "${objectOrType}" "${type}" "${exact}"
}

function @exists() {
    local object
    if [[ "${1}" == "@of" ]]; then
        shift 1
        @let object = "${@}"
    else
        object="${1}"
    fi

    besharp.rtti.isObjectExist "${object}"
}

function @same() {
    local left="${1}"
    local right="${2}"

    if besharp.rtti.isValidObjectCode "${left}"; then
        if besharp.rtti.isObjectExist "${left}"; then
            @let left = $left.__objectId
        fi
    fi

    if besharp.rtti.isValidObjectCode "${right}"; then
        if besharp.rtti.isObjectExist "${right}"; then
            @let right = $right.__objectId
        fi
    fi

    [[ "${left}" == "${right}" ]]
}

fi
if ${beshfile_section__code:-false}; then :;

function @parent() {
    if [[ -n "${besharp_pm:-}" ]]; then
        "besharpstub.${besharp_pm}" "${@}"
    fi
}

function @is-setter() {
    [[ "${1:-}" == '=' ]] && [[ "${#}" -lt 3 ]]
}

function @is-getter() {
    [[ "${#}" == '0' ]]
}

function @clone() {
    local mode="shallow"
    local object
    local target=""

    if [[ "${1}" == "@to" ]]; then
        target="${2}"
        shift 2
    fi

    if [[ "${1}" == "@of" ]]; then
        shift 1
        @let object = "${@}"
    elif [[ "${2:-}" == "@of" ]]; then
        mode="${1}"
        shift 2
        @let object = "${@}"
    elif [[ "${2:-}" != "" ]]; then
        mode="${1}"
        object="${2}"
    else
        object="${1}"
    fi

    if ! besharp.rtti.isObjectExist "${object}"; then
        besharp.runtime.error "Cannot @clone! It is not an object: '${object}'."
    fi

    if [[ "${mode}" == "@in-place" ]]; then
        $object.__cloneFrom "${object}" "@in-place"
        return
    fi

    local cloned
    if [[ -n "${target}" ]]; then
        cloned="${target}"
    else
        local objectType
        objectType="${besharp_oopRuntime_object_types["${object}"]}"

        export besharp_oopRuntime_disable_constructor=true
        @let cloned = @new "${objectType}"
        export besharp_oopRuntime_disable_constructor=false
        besharp.runtime.storeReturnValueOnStackAtDepth1 "${cloned}"
    fi

    $cloned.__cloneFrom "${object}" "${mode}"
}

fi
if ${beshfile_section__code:-false}; then :;

function @returning() {
    if [[ "${1}" == "@of" ]] && [[ "${2+isset}" == 'isset' ]]; then
        shift
        # field or method
        "${@}"
        besharp_rcrvs[ besharp_rcsl ]="${besharp_rcrvs[ besharp_rcsl + 1 ]}"
    else
        besharp_rcrvs[ besharp_rcsl ]="${1}"
    fi
}

function @returning__develop() {
    if [[ "${1}" == "@of" ]] && [[ "${2+isset}" == 'isset' ]]; then
        shift
        # field or method
        "${@}"

        if [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]+isset}" != 'isset' ]]; then
            besharp.runtime.error "@returning @of cannot pass down the value! Are you @returning any value?"
        fi

        besharp_rcrvs[ besharp_rcsl ]="${besharp_rcrvs[ besharp_rcsl + 1 ]}"
    else
        besharp_rcrvs[ besharp_rcsl ]="${1}"
    fi
}

function @returned() {
    local args=( "${@}" )

    if [[ "${args[0]:-}" != '@of' ]]; then
        besharp.compiler.syntaxError "Expected syntax: @returned @of {operation} {operator} {value}. E.x. @returned @of \$this.field == 'value'"
    fi

    unset "args[0]"

    local operator="${args[-2]}"
    case ${operator} in
        '@eq'):;;
        '@ne'):;;
        '@lt'):;;
        '@le'):;;
        '@gt'):;;
        '@ge'):;;
         '=='):;;
          '='):;;
         '!='):;;
          '<'):;;
          '>'):;;
         '=~'):;;
          *) besharp.compiler.syntaxError "@returned unsupported operator: '${operator}'. Available operators: ==, !=, <, >, =, =~, @eq, @ne, @lt, @le, @gt, @ge";;
    esac

    local value="${args[-1]}"
    unset "args[${#args[@]}]"
    unset "args[${#args[@]}]"

    "${args[@]}"

    if [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]+isset}" != "isset" ]]; then
        besharp.compiler.syntaxError "@let couldn't find any results. Did you @return any value?"
    fi

    case ${operator} in
        '@eq') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" -eq "${value}" ]];;
        '@ne') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" -ne "${value}" ]];;
        '@lt') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" -lt "${value}" ]];;
        '@le') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" -le "${value}" ]];;
        '@gt') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" -gt "${value}" ]];;
        '@ge') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" -ge "${value}" ]];;
         '==') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" == "${value}" ]];;
          '=') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" = "${value}" ]];;
         '!=') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" != "${value}" ]];;
          '<') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" < "${value}" ]];;
          '>') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" > "${value}" ]];;
         '=~') [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" =~ ${value} ]];;
          *) besharp.compiler.syntaxError "@returned unsupported operator: ${operator}. Available operators: ==, !=, <, >, =, =~, -eq, -ne, -lt, -le, -gt, -ge";;
    esac

}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.runtime.entrypoint_external_dynamic() {
    set -eu

    besharp.runtime.parseEntrypointArgs "${@}"

    besharp.runtime.includeSourcecode "${PWD:-$(pwd)}"

    besharp.runtime.run "${besharp_runtime_args[@]}"
}

function besharp.runtime.entrypoint_external_static() {
    set -eu

    besharp.runtime.includeSourcecode "${PWD:-$(pwd)}"

    besharp.runtime.run "${@}"
}

function besharp.runtime.entrypoint_embedded_dynamic() {
    set -eu

    besharp.runtime.parseEntrypointArgs "${@}"

    besharp.runtime.includeSourcecode "$( dirname "${0}" )"

    besharp.runtime.run "${besharp_runtime_args[@]}"
}

function besharp.runtime.entrypoint_embedded_static() {
    set -eu

    besharp.runtime.run "${@}"
}

fi
if ${beshfile_section__code:-false}; then :;

export besharp_runtime_entrypoint=""

export besharp_runtime_args=()
export besharp_runtime_args_besharp_include=()
export besharp_runtime_args_besharp_entrypoint=''

function besharp.runtime.entrypoint() {
    set -eu

    besharp.runtime.entrypoint_external_dynamic "${@}"
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.runtime.error() {
    besharp.error "$( besharp.runtime.logbesharp.runtime.error "${@}" 2>&1 )"
}

fi
if ${beshfile_section__code:-false}; then :;

export besharp_oopRuntime_entrypoint_args_provided=false

function besharp.runtime.run() {
    local entrypointClass="${besharp_runtime_args_besharp_entrypoint}"
    if [[ -z "${entrypointClass}" ]]; then
        entrypointClass="${besharp_runtime_entrypoint}"
    fi
    besharp.oopRuntime.bootstrap "${entrypointClass}" "${@}"
}

function besharp.runtime.welcomeEntrypoint() {
    echo "BeSharp by Maciej Ostrowski (c) 2021"
    echo "--"

    besharp.error "$(
        echo "Need a class implementing an 'Entrypoint' interface!"
        echo ""
        echo "Are you sure you have a '@bind Entrypoint @with YourAppClass' entry in your di.sh file?"
        echo ""
        if $besharp_oopRuntime_entrypoint_args_provided; then
            echo "You can attach such file by:"
            echo "   --besharp-include <path1> [--besharp-include <path2>] [ ... ]"
            echo ""
            echo "Consider overriding entrypoint by:"
            echo "   --besharp-entrypoint <arg> ( or \$besharp_runtime_entrypoint env variable )"
        fi
    )"
}

function besharp.runtime.parseEntrypointArgs() {
    besharp_oopRuntime_entrypoint_args_provided=true

    besharp.args.start besharp_runtime_args "${@}"
    besharp.args.processArray '--besharp-include'
    besharp.args.processString '--besharp-entrypoint' ""
    besharp.args.finish false
}

function besharp.runtime.includeSourcecode() {
    local defaultDir="${1}"

    if [[ -z "${besharp_runtime_args_besharp_include[*]:-}" ]]; then
        besharp_runtime_args_besharp_include=( "${defaultDir}" )
    fi

    local path
    for path in "${besharp_runtime_args_besharp_include[@]}"; do
        if [[ -z "${path}" ]]; then
            continue
        fi

        if [[ -d "${path}" ]]; then
            export beshfile_section__launcher=false
            besharp.files.sourceDir "${path}" "be.sh"
        elif [[ -f "${path}" ]]; then
            export beshfile_section__launcher=false
            source "${path}"
        else
            besharp.error "What is '${path}'?"
        fi
    done
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.runtime.generateInitializer() {
    echo 'declare -Ag besharp_oop_types'
    echo 'declare -Ag besharp_oop_classes'
    echo 'declare -Ag besharp_oop_interfaces'

    echo 'declare -Ag besharp_oop_type_parent'
    echo 'declare -Ag besharp_oop_type_abstract'
    echo 'declare -Ag besharp_oop_type_internal'
    echo 'declare -Ag besharp_oop_type_static'
    echo 'declare -Ag besharp_oop_type_static_accessor'
    echo 'declare -Ag besharp_oop_type_is'

    # see: besharp.compiler.oop.compileClassBegin()
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.runtime.logbesharp.runtime.error() {
    besharp.runtime.log "$( @fmt lightRed bold )${*}$( @fmt reset )"
}

function besharp.runtime.log() {
    echo "$( @fmt dim )RUNTIME:$( @fmt reset ) ${*}" >&2
}

fi
if ${beshfile_section__code:-false}; then :;

export besharp_oopRuntime_bootstrapTags=''

function besharp.oopRuntime.bootstrap() {
    besharp.microframework.boostrap "besharp oop"

    besharp.polymorphism.run "${besharp_oopRuntime_bootstrapTags}" \
        besharp.oopRuntime.doBootstrap \
        "${@}" \
    ;
}

function besharp.oopRuntime.addBootstrapTag() {
    export besharp_oopRuntime_bootstrapTags="${besharp_oopRuntime_bootstrapTags} ${*}"
}

function besharp.oopRuntime.doBootstrap() {
    local entrypointClass="${1:-Entrypoint}"
    shift 1

    if [[ -z "${entrypointClass}" ]]; then
          besharp.runtime.welcomeEntrypoint
          return 1
    fi

    besharp.oopRuntime.flushDiBindings
    besharp.oopRuntime.createStaticInstances

    if ! besharp.oopRuntime.diIsImplementing "${entrypointClass}" Entrypoint; then
          besharp.runtime.welcomeEntrypoint
          return 1
    fi

    if ! @is "${entrypointClass}" Entrypoint; then
        besharp.runtime.error "Entrypoint class '${entrypointClass}' must @implement an Entrypoint interface!"
    fi

    local entrypoint
    @let entrypoint = besharp.oopRuntime.diCreateInstance "${entrypointClass}"
    $entrypoint.main "${@}"
}

fi
if ${beshfile_section__code:-false}; then :;

export besharp_oopRuntime_binds_collecting_enabled=true
export besharp_oopRuntime_binds_enabled=false

export besharp_oopRuntime_binds_collector_counter=0
#declare -ag besharp_oopRuntime_collected_binds_x


declare -Ag besharp_oopRuntime_di_objects
declare -Ag besharp_oopRuntime_di_bind
# declare -ag besharp_oopRuntime_di_bind_TYPE_FIELD_args
# declare -ag besharp_oopRuntime_di_bind_TYPE_TYPE_args
# declare -ag besharp_oopRuntime_di_bind_TYPE_args


function besharp.oopRuntime.prepareDI() {
    local type="${1}"
    local code="${2}"

    besharp_oopRuntime_di_objects["${type}"]="${code}"

    eval "local injectableFields=\"\${besharp_oopRuntime_type_${type}_all_injectable_fields[@]:-}\""
    if [[ -z "${injectableFields}" ]]; then
        return
    fi

    local fieldType
    local fieldObject
    local field
    for field in ${injectableFields}; do
        eval "local oopFieldType=\"\${besharp_oopRuntime_type_${type}_all_injectable_field_types[${field}]:-}\""

        # for @bind Type.Field
        fieldType="${besharp_oopRuntime_di_bind["${type}.${field}"]:-}"

        if [[ -n "${fieldType}" ]]; then
            eval "local constructorArgs=( \"\${besharp_oopRuntime_di_bind_${type}_${field}_args[@]}\" )"
        else
            # for @bind Type.FieldType
            fieldType="${besharp_oopRuntime_di_bind["${type}.${oopFieldType}"]:-}"

            if [[ -n "${fieldType}" ]]; then
                eval "local constructorArgs=( \"\${besharp_oopRuntime_di_bind_${type}_${fieldType}_args[@]}\" )"
            else
                # for @bind Type
                fieldType="${besharp_oopRuntime_di_bind["${oopFieldType}"]:-}"

                if [[ -n "${fieldType}" ]]; then
                    eval "local constructorArgs=( \"\${besharp_oopRuntime_di_bind_${oopFieldType}_args[@]}\" )"
                else
                    # fallback to original
                    local constructorArgs=()
                    fieldType="${oopFieldType}"
                fi
            fi
        fi

        fieldObject=${besharp_oopRuntime_di_objects["${fieldType}"]:-}
        if [[ -z "${fieldObject}" ]]; then
            @new-into fieldObject "${fieldType}" "${constructorArgs[@]}"
            besharp_oopRuntime_di_objects["${fieldType}"]="${fieldObject}"
        fi

        ${code}.${field} = "${fieldObject}"
    done
}

function besharp.oopRuntime.diCreateInstance() {
    local type="${1}"

    local finalType
    finalType="${besharp_oopRuntime_di_bind["${type}"]:-}"
    if [[ -n "${finalType}" ]]; then
        eval "local constructorArgs=( \"\${besharp_oopRuntime_di_bind_${type}_args[@]}\" )"
    else
        finalType="${type}"
        local constructorArgs=()
    fi

    local object
    object=${besharp_oopRuntime_di_objects["${finalType}"]:-}
    if [[ -z "${object}" ]]; then
        @new-into object "${finalType}" "${constructorArgs[@]}"
        besharp_oopRuntime_di_objects["${finalType}"]="${object}"
    fi

    besharp.runtime.storeReturnValueOnStackAtDepth1 "${object}"
}

function besharp.oopRuntime.diIsImplementing() {
    local type="${1}"
    local potentialType="${2}"

    local finalType
    finalType="${besharp_oopRuntime_di_bind["${type}"]:-}"
    if [[ -z "${finalType}" ]]; then
        finalType="${type}"
    fi

    besharp.rtti.classExists "${finalType}" \
        && @is "${finalType}" "${potentialType}"
}

function besharp.oopRuntime.flushDiBindings() {
    besharp_oopRuntime_binds_enabled=true
    besharp_oopRuntime_binds_collecting_enabled=false

    local i=-1
    while (( ++i < besharp_oopRuntime_binds_collector_counter )); do
        eval "@bind \"\${besharp_oopRuntime_collected_binds_${i}[@]}\""
    done
}

function besharp.oopRuntime.setupDiBinding() {
    local source="${1}"
    local target="${2}"
    shift 2

    besharp_oopRuntime_di_bind["${source}"]="${target}"
    eval "besharp_oopRuntime_di_bind_${source/./_}_args=( \"\${@}\" )"
}

function besharp.oopRuntime.disableCollectingDiBindings() {
    besharp_oopRuntime_binds_collecting_enabled=false
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.oopRuntime.createDynamicFactoryClass() {
    local type="${1}"
    local factoryType="${2}"

    besharp_oop_types["${factoryType}"]="${factoryType}"
    besharp_oop_classes["${factoryType}"]="${factoryType}"
    besharp_oop_type_is["${factoryType}"]='class'
    besharp_oop_type_parent["${factoryType}"]="SimpleFactory"

    # TODO: use ${besharp_oopRuntime_methodDetailsAssocFields[@]}
    declare -Ag "besharp_oop_type_${factoryType}_methods"
    declare -Ag "besharp_oop_type_${factoryType}_method_body"
    declare -Ag "besharp_oop_type_${factoryType}_method_locals"
    declare -Ag "besharp_oop_type_${factoryType}_method_is_abstract"
    declare -Ag "besharp_oop_type_${factoryType}_method_is_returning"
    declare -Ag "besharp_oop_type_${factoryType}_method_is_using_iterators"
    declare -Ag "besharp_oop_type_${factoryType}_method_is_calling_parent"
    declare -Ag "besharp_oop_type_${factoryType}_method_is_calling_this"
    declare -Ag "besharp_oop_type_${factoryType}_fields"
    declare -Ag "besharp_oop_type_${factoryType}_injectable_fields"
    declare -Ag "besharp_oop_type_${factoryType}_field_type"
    declare -Ag "besharp_oop_type_${factoryType}_field_default"


    local constructorBody="@parent ${type};"

    eval "besharp_oop_type_${factoryType}_methods['${factoryType}']='${factoryType}'"
    eval "besharp_oop_type_${factoryType}_method_locals['${factoryType}']="
    eval "besharp_oop_type_${factoryType}_method_is_calling_parent['${factoryType}']=true"
    eval "besharp_oop_type_${factoryType}_method_is_calling_this['${factoryType}']=false"
    eval "besharp_oop_type_${factoryType}_method_is_using_iterators['${factoryType}']=false"
    eval "besharp_oop_type_${factoryType}_method_is_returning['${factoryType}']=false"
    eval "besharp_oop_type_${factoryType}_method_body['${factoryType}']=\"${constructorBody}\""


    eval "function ${factoryType} () { ${constructorBody} }"

    besharp.oopRuntime.prepareClass "${factoryType}"
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.oopRuntime.createStaticInstances() {

    local type
    for type in "${besharp_oop_type_static[@]}"; do
        besharp.oopRuntime.prepareNewInstanceStatic "${type}" "${besharp_oop_type_static_accessor[${type}]}"
    done

    local type
    for type in "${besharp_oop_type_static[@]}"; do
        besharp.oopRuntime.createNewInstanceStatic "${type}" "${besharp_oop_type_static_accessor[${type}]}"
    done
}

fi
if ${beshfile_section__code:-false}; then :;

export besharp_oopRuntime_object_count=0
export besharp_oopRuntime_disable_constructor=false
declare -Ag besharp_oopRuntime_objects
declare -Ag besharp_oopRuntime_object_types

function besharp.oopRuntime.createNewInstance() {
    local type="${1}"
    shift 1

    local code="besh_$(( ++besharp_oopRuntime_object_count ))"

    besharp.oopRuntime.createNewInstanceNamed "${type}" "${code}" "${@}"

    besharp.runtime.storeReturnValueOnStackAtDepth1 "${code}"
}

function besharp.oopRuntime.createNewInstanceNamed() {
    local type="${1}"
    local code="${2}"
    shift 2

    besharp.rtti.ensureValidObjectCode "${type}" "${code}"

    besharp.oopRuntime.ensureClassExists "${type}"
    besharp.oopRuntime.ensurePrepareType "${type}"
    besharp.oopRuntime.trackObject "${type}" "${code}"
    besharp.oopRuntime.executeStubsTemplate "${type}" "${code}"

    ${code}.__besharp_initialize_object

    besharp.oopRuntime.prepareDI "${type}" "${code}"

    besharp.oopRuntime.callConstructor "${code}" "${type}" "${@}"
}

function besharp.oopRuntime.prepareNewInstanceStatic() {
    local type="${1}"
    local staticCode="${2}"

    besharp.rtti.ensureValidStaticObjectCode "${type}" "${staticCode}"

    local code="besh_static_${staticCode#@}"

    besharp.oopRuntime.ensureClassExists "${type}"
    besharp.oopRuntime.ensurePrepareType "${type}"
    besharp.oopRuntime.trackObject "${type}" "${code}"
    besharp.oopRuntime.executeStubsTemplate "${type}" "${code}"
    besharp.oopRuntime.executeStaticStubsTemplate "${type}" "${code}" "${staticCode}"
}

function besharp.oopRuntime.createNewInstanceStatic() {
    local type="${1}"
    local staticCode="${2}"
    shift 2

    local code="besh_static_${staticCode#@}"

    ${staticCode}.__besharp_initialize_object

    besharp.oopRuntime.prepareDI "${type}" "${code}"

    besharp.oopRuntime.callConstructor "${staticCode}" "${type}" "${@}"
}

function besharp.oopRuntime.trackObject() {
    local type="${1}"
    local code="${2}"

    besharp_oopRuntime_objects["${code}"]="${code}"
    besharp_oopRuntime_object_types["${code}"]="${type}"
}

function besharp.oopRuntime.callConstructor() {
    local code="${1}"

    if $besharp_oopRuntime_disable_constructor; then
        return
    fi

    local type="${2}"
    shift 2

    ${code}.${type} "${@}"
}

function besharp.oopRuntime.unsetObjectInstance() {
    local code="${1}"

    $code.__destroy

    ${code}.__besharp_deinitialize_object

    unset "besharp_oopRuntime_objects[${code}]"
    unset "besharp_oopRuntime_object_types[${code}]"
}

fi
if ${beshfile_section__code:-false}; then :;

export besharp_runtime_reset_iteration=0
declare -axg besharp_runtime_current_iterator_keys__stack_x=()
declare -axg besharp_runtime_current_iterator__stack_x=()
declare -axg besharp_runtime_current_iterator_of__stack_x=()

function besharp.oopRuntime.invokeIteration() {
    local targetLocalVar="${1}"
    local iterable="${2}"

    local __besharp_iterator_position_in_a_method
    besharp.fastCall.toArrayOfTokens __besharp_iterator_position_in_a_method caller 2

    besharp.oopRuntime.invokeIterationLoop
}

function besharp.oopRuntime.invokeIterationOf() {
    local targetLocalVar="${1}"
    local iterable="${2}"
    shift 2

    local __besharp_iterator_position_in_a_method
    besharp.fastCall.toArrayOfTokens __besharp_iterator_position_in_a_method caller 2

    local iterationOf
    eval "iterationOf=\${besharp_runtime_current_iterator_of__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]:-}"

    if [[ -z "${iterationOf}" ]]; then
        @let iterable = "${args[@]}"
        eval "besharp_runtime_current_iterator_of__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]=${iterable}"
    else
        iterable="${iterationOf}"
    fi

    besharp.oopRuntime.invokeIterationLoop
}

function besharp.oopRuntime.invokeIterationLoop()
{
    #local targetLocalVar="${1}"
    #local iterable="${2}"

    if ! besharp.rtti.isA "${iterable}" Iterable; then
        if besharp.rtti.isObjectExist "${iterable}"; then
            besharp.compiler.syntaxError "@iterate @of expects Iterable: @iterate @of <Iterable> @in <variable>! Got: object ${iterable} of type $( besharp.rtti.objectType "${iterable}" )"
        else
            besharp.compiler.syntaxError "@iterate @of expects Iterable: @iterate @of <Iterable> @in <variable>! Got: ${iterable}"
        fi
    fi

    local iterationKey
    eval "iterationKey=\${besharp_runtime_current_iterator_keys__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]:-}"

    if [[ -z "${iterationKey}" ]] || [[ ${besharp_runtime_reset_iteration:-} == 1 ]]; then
        export besharp_runtime_reset_iteration=0

        @let iterationKey = $iterable.iterationNew
    else
        @let iterationKey = $iterable.iterationNext "${iterationKey}"
    fi

    if [[ -z "${iterationKey}" ]]; then
        eval "besharp_runtime_current_iterator_keys__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]="

        local iterator
        eval "iterator=\${besharp_runtime_current_iterator__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]:-}"
        if [[ -n "${iterator}" ]]; then
            unset "${iterator}"
        fi

        return 1
    fi

    local iterationValue
    @let iterationValue = $iterable.iterationValue "${iterationKey}"
    eval "${targetLocalVar}=\${iterationValue}"

    eval "besharp_runtime_current_iterator_keys__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]=${iterationKey}"
}


function besharp.oopRuntime.invokeArrayIteration() {
    local targetLocalVar="${1}"
    shift 1
    local args=( "${@}" )

    if [[ "${args[@]+isset}" != 'isset' ]]; then
        return 1
    fi

    local __besharp_iterator_position_in_a_method
    besharp.fastCall.toArrayOfTokens __besharp_iterator_position_in_a_method caller 2

    local iterationKey
    eval "iterationKey=\${besharp_runtime_current_iterator_keys__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]:-}"

    if [[ -z "${iterationKey}" ]]; then
        iterationKey=0
    else
        if (( ++iterationKey >= ${#args[@]} )); then
            iterationKey=""
        fi
    fi

    if [[ -z "${iterationKey}" ]]; then
        eval "besharp_runtime_current_iterator_keys__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]="
        return 1
    fi

    eval "${targetLocalVar}=\${args[${iterationKey}]}"

    eval "besharp_runtime_current_iterator_keys__stack_${besharp_rcsl}[${__besharp_iterator_position_in_a_method}]=${iterationKey}"
}

fi
if ${beshfile_section__code:-false}; then :;

# besharp_runtime_current_stack_level
export besharp_rcsl=1

# besharp_runtime_current_return_value_stack
declare -ag besharp_rcrvs


function besharp.runtime.storeReturnValueOnStack() {
    local value="${1}"

    besharp_rcrvs[ besharp_rcsl ]="${value}"
}

function besharp.runtime.storeReturnValueOnStackAtDepth() {
    local value="${1}"
    local depth="${2}"

    besharp_rcrvs[ besharp_rcsl + depth ]="${value}"
}

function besharp.runtime.storeReturnValueOnStackAtDepth1() {
    local value="${1}"

    besharp_rcrvs[ besharp_rcsl + 1 ]="${value}"
}

function besharp.returningOf() {
    "${@}"

    besharp_rcrvs[besharp_rcsl]="${besharp_rcrvs[ besharp_rcsl + 1 ]}"
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.oopRuntime.generateFieldStubs() {
    local type="${1}"

    local parentType="${besharp_oop_type_parent[${type}]}"

    # todo: consider moving to compilation time
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_fields"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_field_defaults"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_field_default_initializers"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_field_deinitializers"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_field_instance_stubs"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_field_initialize_stubs"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_injectable_fields"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_injectable_field_types"

    if [[ -n "${parentType}" ]]; then
        local parentField
#        local parentCallback

        eval "for parentField in \"\${besharp_oopRuntime_type_${parentType}_all_fields[@]}\"; do besharp.oopRuntime.generateFieldList \"\${type}\" \"\${parentField}\"; done"

        eval "for parentField in \"\${besharp_oopRuntime_type_${parentType}_all_fields[@]}\"; do besharp.oopRuntime.generateFieldDefaults \"\${type}\" \"\${parentType}\" \"\${parentField}\"; done"

        eval "for parentField in \"\${besharp_oopRuntime_type_${parentType}_all_fields[@]}\"; do besharp.oopRuntime.generateInjectableField \"\${type}\" \"\${parentType}\" \"\${parentField}\"; done"
    fi

    local field
    eval "for field in \"\${besharp_oop_type_${type}_fields[@]}\"; do besharp.oopRuntime.generateFieldList \"\${type}\" \"\${field}\"; done"

    eval "for field in \"\${besharp_oop_type_${type}_fields[@]}\"; do besharp.oopRuntime.generateFieldDefaults \"\${type}\" \"\${type}\" \"\${field}\"; done"


    eval "for field in \"\${besharp_oop_type_${type}_fields[@]}\"; do besharp.oopRuntime.generateInjectableField \"\${type}\" \"\${type}\" \"\${field}\"; done"

    eval "for field in \"\${besharp_oopRuntime_type_${type}_all_fields[@]}\"; do besharp.oopRuntime.generateFieldInstanceStub \"\${type}\" \"\${field}\"; done"


#    d "besharp_oopRuntime_type_${type}_all_fields"
#    d "besharp_oopRuntime_type_${type}_all_field_defaults"
#    d "besharp_oopRuntime_type_${type}_all_field_instance_stubs"
#    d "besharp_oopRuntime_type_${type}_all_field_default_initializers"
#    d "besharp_oopRuntime_type_${type}_all_field_deinitializers"
#    d "besharp_oopRuntime_type_${type}_all_field_initialize_stubs"
#    d "besharp_oopRuntime_type_${type}_all_fields" "besharp_oopRuntime_type_${type}_all_injectable_fields" "besharp_oopRuntime_type_${type}_all_injectable_field_types"
}

function besharp.oopRuntime.generateFieldList() {
    local type="${1}"
    local field="${2}"

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_fields['${field}']='${field}'"
}

function besharp.oopRuntime.generateFieldDefaults() {
    local targetType="${1}"
    local sourceType="${2}"
    local field="${3}"

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${targetType}_all_field_defaults['${field}']=\"\${besharp_oop_type_${sourceType}_field_default[${field}]:-}\""
}

function besharp.oopRuntime.generateInjectableField() {
    local targetType="${1}"
    local sourceType="${2}"
    local field="${3}"

    local isInjectable
    eval "isInjectable=\"\${besharp_oop_type_${sourceType}_injectable_fields[${field}]:-}\""
    if [[ -n "${isInjectable}" ]]; then
        besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${targetType}_all_injectable_fields['${field}']='${field}'"
        besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${targetType}_all_injectable_field_types['${field}']=\"\${besharp_oop_type_${sourceType}_field_type[${field}]:-}\""
    fi
}

function besharp.oopRuntime.generateFieldInstanceStub() {
    local type="${1}"
    local field="${2}"

    local initializersBody="object_code_${field}=\\\"\\\${besharp_oopRuntime_type_${type}_all_field_defaults['${field}']}\\\"
"
    local deinitializersBody="unset \"object_code_${field}\"; unset -f \"object_code.${field}\"
"
    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_field_default_initializers['${field}']=\"\${initializersBody}\""

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_field_deinitializers['${field}']=\"\${deinitializersBody}\""

    local fieldStubBody
    besharp.oopRuntime.fieldStubAccessorBody

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_field_instance_stubs['${field}']=\"\${fieldStubBody}\""
}

function besharp.oopRuntime.fieldStubAccessorBody() {
    fieldStubBody=\
"function object_code.${field} {
   if [[ \"\${1:-}\" == '=' ]]; then
       # setter
      object_code_${field}=\"\${2}\"
   else
       # getter
       besharp_rcrvs[ besharp_rcsl + 1 ]="\${object_code_${field}}"
   fi
}
"
}

function besharp.oopRuntime.fieldStubAccessorBody__develop() {
    fieldStubBody=\
"function object_code.${field} {
    besharp.oopRuntime.fieldStubAccessor \"${type}\" \"object_code\" \"${field}\"  \"\${@}\"
}
"
}


function besharp.oopRuntime.fieldStubAccessor() {
   if [[ -z "${4:-}" ]]; then
       # getter
       local varName="${2}_${3}"
       besharp.runtime.storeReturnValueOnStackAtDepth1 "${!varName:-}"
   elif [[ "${4:-}" == '=' ]]; then
       # setter

      eval "${2}_${3}=\"\${5}\""
   else
      besharp.compiler.syntaxError "Missing '=' char: @var ${2}_${3} = ... "
   fi
}

fi
if ${beshfile_section__code:-false}; then :;

declare -ag besharp_oopRuntime_methodDetailsAssocFields=(
    _method_body
    _method_locals
    _method_is_returning
    _method_is_abstract
    _method_is_using_iterators
    _method_is_calling_parent
    _method_is_calling_this
)

function besharp.oopRuntime.debugType() {
    local type="${1}"

    local args=()
    args+=(
        "besharp_oopRuntime_type_${type}_all_methods"
        "besharp_oopRuntime_type_${type}_all_abstract_methods"
        "besharp_oopRuntime_type_${type}_all_abstract_method_origins"
        "besharp_oopRuntime_type_${type}_all_methods_parent_callback"
        "besharp_oopRuntime_type_${type}_all_method_callbacks"
        "besharp_oopRuntime_type_${type}_all_method_deinitializers"
        "besharp_oopRuntime_type_${type}_all_method_stubs"
        "besharp_oopRuntime_type_${type}_all_method_instance_stubs"
    )

    local field
    for field in "${besharp_oopRuntime_methodDetailsAssocFields[@]}"; do
        args+=( "besharp_oopRuntime_type_${type}${field}" )
    done

    d "${args[@]}"
}

function besharp.oopRuntime.generateMethodStubs() {
    local type="${1}"

    local parentType="${besharp_oop_type_parent[${type}]}"

    # todo: consider moving to compilation time
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_methods"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_abstract_methods"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_abstract_method_origins"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_methods_parent_callback"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_method_callbacks"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_method_deinitializers"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_method_stubs"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_method_instance_stubs"
    local field
    for field in "${besharp_oopRuntime_methodDetailsAssocFields[@]}"; do
        besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}${field}"
    done

    besharp.oopRuntime.generateConstructorCallbacks "${type}" "${parentType}"

    if [[ -n "${parentType}" ]]; then
        local parentMethod
        local parentCallback

        eval "for parentMethod in \"\${besharp_oopRuntime_type_${parentType}_all_methods[@]}\"; do besharp.oopRuntime.generateMethodList \"\${type}\" \"\${parentType}\" \"\${parentMethod}\"; done"

        eval "for parentMethod in \"\${besharp_oopRuntime_type_${parentType}_all_methods[@]}\"; do besharp.oopRuntime.cloneMethodDetails \"\${type}\" \"\${parentType}\" \"\${parentMethod}\"; done"

        eval "for parentMethod in \"\${besharp_oopRuntime_type_${parentType}_all_methods[@]}\"; do besharp.oopRuntime.generateMethodCallbacks \"\${type}\" \"\${parentMethod}\" \"\${besharp_oopRuntime_type_${parentType}_all_method_callbacks[\${parentMethod}]}\"; done"

        eval "for parentMethod in \"\${besharp_oopRuntime_type_${parentType}_all_abstract_methods[@]}\"; do besharp.oopRuntime.overrideAbstractMethodList \"\${type}\" \"\${parentMethod}\" \"\${besharp_oopRuntime_type_${parentType}_all_abstract_method_origins[\${parentMethod}]}\"; done"
    fi

    local method
    eval "for method in \"\${besharp_oop_type_${type}_methods[@]}\"; do besharp.oopRuntime.generateMethodList \"\${type}\" \"\${parentType}\" \"\${method}\"; done"

    eval "for method in \"\${besharp_oop_type_${type}_methods[@]}\"; do besharp.oopRuntime.cloneMethodDetails \"\${type}\" \"\${type}\" \"\${method}\"; done"

    eval "for method in \"\${besharp_oop_type_${type}_methods[@]}\"; do besharp.oopRuntime.generateAbstractMethodList \"\${type}\" \"\${method}\"; done"

    eval "for method in \"\${besharp_oop_type_${type}_methods[@]}\"; do besharp.oopRuntime.generateMethodCallbacks \"\${type}\" \"\${method}\" \"${type}.\${method}\"; done"

    eval "for method in \"\${besharp_oop_type_${type}_methods[@]}\"; do besharp.oopRuntime.generateMethodStub \"\${type}\" \"\${method}\"; done"

    eval "for method in \"\${besharp_oopRuntime_type_${type}_all_methods[@]}\"; do besharp.oopRuntime.generateMethodInstanceStub \"\${type}\" \"\${method}\" \"\${besharp_oopRuntime_type_${type}_all_method_callbacks[\"\${method}\"]}\"; done"

    eval "for method in \"\${besharp_oopRuntime_type_${type}_all_methods[@]}\"; do besharp.oopRuntime.generateMethodDeinitializers \"\${type}\" \"\${method}\" \"\${besharp_oopRuntime_type_${type}_all_method_callbacks[\"\${method}\"]}\"; done"


#    # debug section
#    local debugTypes=()
#    debugTypes=( ArrayVector )
#    local debugType
#    for debugType in "${debugTypes[@]}"; do
#        if [[ "${type}" == "${debugType}" ]]; then
#            besharp.oopRuntime.debugType "${type}"
#        fi
#    done
}

function besharp.oopRuntime.generateMethodList() {
    local type="${1}"
    local parentType="${2}"
    local method="${3}"

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_methods[${method}]='${method}'"
}

function besharp.oopRuntime.cloneMethodDetails() {
    local toType="${1}"
    local fromType="${2}"
    local fromMethod="${3}"
    local toMethod="${3:-}"

    if [[ "${fromType}" == "${fromMethod}" ]]; then
        toMethod="${toType}"
    fi

    local field
    for field in "${besharp_oopRuntime_methodDetailsAssocFields[@]}"; do
        if [[ -z "${field}" ]]; then
            continue
        fi

        besharp.oopRuntime.generateLinkerLine "
            if [[ 'isset' == \"\${besharp_oop_type_${fromType}${field}[${fromMethod}]+isset}\" ]]; then
                  besharp_oopRuntime_type_${toType}${field}[${toMethod}]=\"\${besharp_oop_type_${fromType}${field}[${fromMethod}]}\";
            elif [[ 'isset' == \"\${besharp_oopRuntime_type_${fromType}${field}[${fromMethod}]+isset}\" ]]; then
                  besharp_oopRuntime_type_${toType}${field}[${toMethod}]=\"\${besharp_oopRuntime_type_${fromType}${field}[${fromMethod}]}\";
            fi
        "
    done
}

function besharp.oopRuntime.generateAbstractMethodList() {
    local type="${1}"
    local method="${2}"

    if eval "[[ \"\${besharp_oop_type_${type}_method_is_abstract[@]+isset}\" == 'isset' ]] \\
          &&  [[ \"\${besharp_oop_type_${type}_method_is_abstract[${method}]+isset}\" == 'isset' ]]";
    then
        besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_abstract_methods[${method}]='${method}'"
        besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_abstract_method_origins[${method}]='${type}'"
    fi
}

function besharp.oopRuntime.overrideAbstractMethodList() {
    local type="${1}"
    local method="${2}"
    local originType="${3}"

    if ! eval "[[ \"\${besharp_oop_type_${type}_methods[@]+isset}\" == 'isset' ]] \\
          &&  [[ \"\${besharp_oop_type_${type}_methods[${method}]+isset}\" == 'isset' ]]";
    then
        besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_abstract_methods[${method}]='${method}'"
        besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_abstract_method_origins[${method}]='${originType}'"
    fi
}

function besharp.oopRuntime.generateConstructorCallbacks() {
    local type="${1}"
    local parentType="${2}"

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_methods_parent_callback['${type}']='${parentType}'"
    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_method_callbacks['${type}']='${type}'"
}

function besharp.oopRuntime.generateMethodCallbacks() {
    local type="${1}"
    local method="${2}"
    local callback="${3}"

    if [[ "${type}" == "${method}" ]]; then
        return
    fi

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_methods_parent_callback[${method}]=\"\${besharp_oopRuntime_type_${type}_all_method_callbacks[${method}]:-}\""
    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_method_callbacks[${method}]='${callback}'"
}

function besharp.oopRuntime.generateMethodStub() {
    local type="${1}"
    local method="${2}"

    if [[ "${type}" == "${method}" ]]; then
        local callback="${type}"
    else
        local callback="${type}.${method}"
    fi

    local callingParent=false
    if besharp.oopRuntime.isMethodCallingParent "${type}" "${method}"; then
        callingParent=true
    fi


    local body
    besharp.oopRuntime.generateMethodStubBody \
        "${type}" \
        "${method}" \
        "${callback}" \
        "" \
        "${callingParent}" \
    ;

    local funcDefinition=\
"function besharpstub.${callback}() {
    ${body}
}
"
     besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_method_stubs[${method}]=\"\${funcDefinition}\""
}

function besharp.oopRuntime.generateMethodInstanceStub() {
    local type="${1}"
    local method="${2}"
    local callback="${3}"

    if besharp.oopRuntime.isMethodCallingParent "${type}" "${method}"; then
        local funcDefinition=\
"function object_code.${method} {
    local this=\"object_code\"
    besharpstub.${callback} \"\${@}\"
}
"
    else
        local body
        if besharp.oopRuntime.isMethodCallingThis "${type}" "${method}"; then
            besharp.oopRuntime.generateMethodStubBody \
                "${type}" \
                "${method}" \
                "${callback}" \
                "this=\"object_code\"" \
                "false" \
            ;
        else
            besharp.oopRuntime.generateMethodStubBody \
                "${type}" \
                "${method}" \
                "${callback}" \
                "" \
                "false" \
            ;
        fi

        local funcDefinition=\
"function object_code.${method} {
    ${body}
}
"
    fi

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_method_instance_stubs[${method}]=\"\${funcDefinition}\""
}

function besharp.oopRuntime.generateMethodStubBody() {
    local type="${1}"
    local method="${2}"
    local callback="${3}"
    local customLocalDef="${4:-}"
    local usingParentCall="${5:-true}"

    local iteratorsBodyBefore=
    local iteratorsBodyAfter=
    if eval "\${besharp_oopRuntime_type_${type}_method_is_using_iterators[\"${method}\"]:-false}"; then
        iteratorsBodyBefore=\
"
    unset \"besharp_runtime_current_iterator_keys__stack_\${besharp_rcsl}\"
    declare -a \"besharp_runtime_current_iterator_keys__stack_\${besharp_rcsl}\"
    unset \"besharp_runtime_current_iterator_of__stack_\${besharp_rcsl}\"
    declare -a \"besharp_runtime_current_iterator_of__stack_\${besharp_rcsl}\"
"

        iteratorsBodyAfter=\
"
    local iterators=\"besharp_runtime_current_iterator__stack_\${besharp_rcsl}\"[@]
    local iterator
    for iterator in \${!iterators:-}; do
        unset \"\${iterator}\"
    done

    unset \"besharp_runtime_current_iterator__stack_\${besharp_rcsl}\"
    unset \"besharp_runtime_current_iterator_keys__stack_\${besharp_rcsl}\"
    unset \"besharp_runtime_current_iterator_of__stack_\${besharp_rcsl}\"
    unset \"besharp_rcrvs[ besharp_rcsl + 1 ]\"
"
    fi

    local localParentCallback=
    if $usingParentCall; then
        local parentCallback
        eval "parentCallback=\${besharp_oopRuntime_type_${type}_all_methods_parent_callback[${method}]}"
        localParentCallback="besharp_pm='${parentCallback}'"
    fi

    local locals
    eval "locals=\"\${besharp_oopRuntime_type_${type}_method_locals[${method}]:-}\""


    if besharp.oopRuntime.isMethodEmbedded "${type}" "${method}"; then
        eval "local methodBody=\"\${besharp_oopRuntime_type_${type}_method_body[${method}]:-}\""
    else
        local methodBody="${callback} \"\${@}\""
    fi

    local localPrefix=
    if [[ -n "${customLocalDef}" ]] || [[ -n "${localParentCallback}" ]]; then
        localPrefix='local'
    fi

    body=\
"
    ${localPrefix} ${customLocalDef} ${localParentCallback}
    ${locals}

    (( ++besharp_rcsl ))

    ${iteratorsBodyBefore}

    ${methodBody}

    ${iteratorsBodyAfter}

    (( --besharp_rcsl ))
"
}

function besharp.oopRuntime.isMethodEmbedded() {
    ! eval "\${besharp_oopRuntime_type_${type}_method_is_returning[\"${method}\"]:-true}"
}

function besharp.oopRuntime.isMethodEmbedded__develop() {
    false
}

function besharp.oopRuntime.generateMethodDeinitializers() {
    local type="${1}"
    local method="${2}"
    local callback="${3}"

    local deinitializerBody=\
"unset -f object_code.${method}
"
    eval "besharp_oopRuntime_type_${type}_all_method_deinitializers[${method}]=\"\${deinitializerBody}\""
}

function besharp.oopRuntime.isMethodCallingParent() {
    local type="${1}"
    local method="${2}"

    eval "\${besharp_oopRuntime_type_${type}_method_is_calling_parent[${method}]:-false}"
}

function besharp.oopRuntime.isMethodCallingThis() {
    local type="${1}"
    local method="${2}"

    eval "\${besharp_oopRuntime_type_${type}_method_is_calling_this[${method}]:-false}"
}

fi
if ${beshfile_section__code:-false}; then :;

declare -Ag besharp_oopRuntime_stubs

function besharp.oopRuntime.generateStubsTemplate() {
    local type="${1}"

    besharp.oopRuntime.generateMethodStubs "${type}"
    besharp.oopRuntime.generateFieldStubs "${type}"


    local initializers
    eval "initializers=\"\${besharp_oopRuntime_type_${type}_all_field_default_initializers[@]}\""

    local deinitializers
    eval "deinitializers=\"\${besharp_oopRuntime_type_${type}_all_field_deinitializers[@]} \${besharp_oopRuntime_type_${type}_all_method_deinitializers[@]}\""

    local technicalCallbacks
    technicalCallbacks=\
"
function object_code.__besharp_initialize_object() {
   ${initializers:-:}
}
function object_code.__besharp_deinitialize_object() {
   ${deinitializers:-:}
   unset -f 'object_code.__besharp_initialize_object'
   unset -f 'object_code.__besharp_deinitialize_object'
}
"

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_stubs[\"${type}\"]=\"\${besharp_oopRuntime_type_${type}_all_field_instance_stubs[@]}\${besharp_oopRuntime_type_${type}_all_method_instance_stubs[@]}${technicalCallbacks}\""

    eval "besharp.oopRuntime.generateLinkerLine \"\${besharp_oopRuntime_type_${type}_all_method_stubs[@]}\""
}

function besharp.oopRuntime.executeStubsTemplate() {
    local type="${1}"
    local code="${2}"

    local value="${besharp_oopRuntime_stubs[${type}]}"
    eval "${value//object_code/${code}}"
}

function besharp.oopRuntime.executeStaticStubsTemplate() {
    local type="${1}"
    local code="${2}"
    local staticCode="${3}"

    local value="${besharp_oopRuntime_stubs[${type}]}"
    value="${value//function object_code./function ${staticCode}.}"
    eval "${value//object_code/${code}}"
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.oopRuntime.verifyAbstractMethodsImplementedForType() {
    local type="${1}"

    if besharp.rtti.isAbstractClass "${type}"; then
        return
    fi

    local method
    eval "for method in \"\${besharp_oopRuntime_type_${type}_all_abstract_methods[@]:-}\"; do
          if [[ -z \"\${method}\" ]]; then continue; fi
          besharp.oopRuntime.verifyAbstractMethodImplemented '${type}' \"\${method}\"
    done"

}

function besharp.oopRuntime.verifyAbstractMethodImplemented() {
    local type="${1}"
    local method="${2}"


    if ! besharp.rtti.hasDirectMethod "${type}" "${method}"; then
         eval "originType=\"\${besharp_oopRuntime_type_${type}_all_abstract_method_origins['${method}']}\""
         besharp.runtime.error "Class '${type}' must implement '${type}.${method}' method because it is @abstract in the '${originType}' class!"
    fi
}

function besharp.oopRuntime.verifyFieldsAndMethods()
{
    local type="${1}"

    local field
    eval "
      for field in \"\${besharp_oopRuntime_type_${type}_all_fields[@]:-}\"; do
          if [[ -n \"\${field}\" ]] && besharp.rtti.hasMethod \"${type}\" \"\${field}\"; then
              besharp.runtime.error \"${type}.\${field} field collides with ${type}.\${field} method! Field names and method names must be unique each other! \"
          fi
      done
    "
}

fi
if ${beshfile_section__code:-false}; then :;

declare -Ag besharp_oopRuntime_class_ready

function besharp.oopRuntime.prepareClass() {
    local type="${1}"

    if ! besharp.oopRuntime.registerClass "${type}"; then
        return 0
    fi

    local parentType
    parentType="${besharp_oop_type_parent[${type}]:-Object}"

    besharp.oopRuntime.prepareClass "${parentType}"

    besharp.oopRuntime.prepareClassParents "${type}" "${parentType}"
    besharp.oopRuntime.prepareParentInterfaces "${type}"
    besharp.oopRuntime.collectInterfacesForType "${type}" "${parentType}"
    besharp.oopRuntime.generateStubsTemplate "${type}"
    besharp.oopRuntime.verifyFieldsAndMethods "${type}"

    besharp.oopRuntime.verifyInterfacesForType "${type}"
    besharp.oopRuntime.verifyAbstractMethodsImplementedForType "${type}"
}

function besharp.oopRuntime.registerClass() {
    local type="${1}"

    if [[ "${besharp_oopRuntime_class_ready[${type}]+isset}" == 'isset' ]]; then
        return 1
    fi
    besharp_oopRuntime_class_ready["${type}"]="${type}"
    return 0
}

function besharp.oopRuntime.prepareClassParents() {
    local type="${1}"
    local parentType="${2}"

    if [[ "${type}" == 'Object' ]]; then
        return
    fi

    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_parents"
    besharp.oopRuntime.generateLinkerLine "declare -ag besharp_oopRuntime_type_${type}_all_parents_list"

    local inheritParentTypes
    eval "inheritParentTypes=\"\${besharp_oopRuntime_type_${parentType}_all_parents_list[@]}\""

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_parents_list=( ${parentType} ${inheritParentTypes} )"
    eval "for parent in \${besharp_oopRuntime_type_${type}_all_parents_list[@]}; do
        besharp.oopRuntime.generateLinkerLine \"besharp_oopRuntime_type_${type}_all_parents[\\\"\${parent}\\\"]=\\\"\${parent}\\\"\"
    done
    "
}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.oopRuntime.verifyInterfacesForType() {
    local type="${1}"

    if besharp.rtti.isAbstractClass "${type}"; then
        return
    fi

    local method
    eval "for method in \"\${besharp_oopRuntime_type_${type}_all_interface_methods[@]:-}\"; do
          if [[ -z \"\${method}\" ]]; then continue; fi
          besharp.oopRuntime.verifyInterfaceMethod '${type}' \"\${method}\"
    done"

}

function besharp.oopRuntime.verifyInterfaceMethod() {
    local type="${1}"
    local method="${2}"

    if ! besharp.rtti.hasMethod "${type}" "${method}" || besharp.rtti.isMethodAbstract  "${type}" "${method}"; then
         eval "interface=\${besharp_oopRuntime_type_${type}_interface_methods_origin['${method}']}"
         besharp.runtime.error "Class '${type}' must implement '${type}.${method}' method. Duty origin: '${interface}'!"
    fi
}

function besharp.oopRuntime.verifyInterfaceExists() {
    local interface="${1}"
    local type="${2}"

    if [[ "${besharp_oop_interfaces[${interface}]+isset}" != 'isset' ]]; then
         besharp.runtime.error "Type '${type}' cannot implement unknown interface: ${interface} !"
    fi
}

fi
if ${beshfile_section__code:-false}; then :;

declare -Ag besharp_oopRuntime_interface_ready

function besharp.oopRuntime.prepareInterface() {
    local type="${1}"

    if ! besharp.oopRuntime.registerInterface "${type}"; then
        return 0
    fi

    besharp.oopRuntime.prepareParentInterfaces "${type}"
    besharp.oopRuntime.collectInterfacesForType "${type}"
}

function besharp.oopRuntime.registerInterface() {
    local type="${1}"

    if [[ "${besharp_oopRuntime_interface_ready[${type}]+isset}" == 'isset' ]]; then
        return 1
    fi
    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_interface_ready[\"${type}\"]='${type}'"
    return 0
}

function besharp.oopRuntime.prepareParentInterfaces() {
    local type="${1}"

    local interface
    eval "for interface in \"\${besharp_oop_type_${type}_interfaces[@]}\"; do
        besharp.oopRuntime.prepareInterface \"\${interface}\";
    done"
}

function besharp.oopRuntime.collectInterfacesForType() {
    local type="${1}"
    local parentType="${2:-}"

    local interface

    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_interfaces"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_all_interface_methods"
    besharp.oopRuntime.generateLinkerLine "declare -Ag besharp_oopRuntime_type_${type}_interface_methods_origin"

    besharp.oopRuntime.addToInterfaceParentsFromArray "${type}" "besharp_oop_type_${type}_interfaces"

    if [[ -n "${parentType}" ]]; then
        eval "besharp.oopRuntime.addToInterfaceParentsFromArray '${type}' \"besharp_oopRuntime_type_${parentType}_all_interfaces\""
        eval "besharp.oopRuntime.addToInterfaceMethodsFromArray '${type}' \"${parentType}\" \"besharp_oopRuntime_type_${parentType}_all_interface_methods\""
    fi

    eval "for interface in \"\${besharp_oop_type_${type}_interfaces[@]}\"; do
        besharp.oopRuntime.verifyInterfaceExists \"\${interface}\" \"\${type}\"
        besharp.oopRuntime.addToInterfaceParentsFromArray '${type}' \"besharp_oopRuntime_type_\${interface}_all_interfaces\"
    done"

    if besharp.rtti.interfaceExists "${type}"; then
        besharp.oopRuntime.addToInterfaceMethodsFromArray "${type}" "${type}" "besharp_oop_type_${type}_methods"
    fi

    eval "for interface in \"\${besharp_oop_type_${type}_interfaces[@]}\"; do
        besharp.oopRuntime.addToInterfaceMethodsFromArray '${type}' \"\${interface}\" \"besharp_oopRuntime_type_\${interface}_all_interface_methods\"
    done"
}

function besharp.oopRuntime.addToInterfaceParentsFromArray() {
    local type="${1}"
    local arrayName="${2}"
    shift 2

    eval "for item in \"\${${arrayName}[@]}\"; do besharp.oopRuntime.addToInterfaceParents '${type}' \"\${item}\"  ; done"
}

function besharp.oopRuntime.addToInterfaceParents() {
    local type="${1}"
    shift 1

    local item
    for item in "${@}"; do
        besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_interfaces[\"${item}\"]=\"${item}\";"
    done
}

function besharp.oopRuntime.addToInterfaceMethodsFromArray() {
    local type="${1}"
    local originInterface="${2}"
    local arrayName="${3}"
    shift 3

    local method
    eval "for method in \"\${${arrayName}[@]}\"; do
        besharp.oopRuntime.addToInterfaceMethods '${type}' '${originInterface}' \"\${method}\"
    done"
}

function besharp.oopRuntime.addToInterfaceMethods() {
    local type="${1}"
    local originInterface="${2}"
    local method="${3}"

    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_all_interface_methods[\"${method}\"]=\"${method}\";"
    besharp.oopRuntime.generateLinkerLine "besharp_oopRuntime_type_${type}_interface_methods_origin[\"${method}\"]=\"${originInterface}\";"
}

fi
if ${beshfile_section__code:-false}; then :;

declare -Ag besharp_oopRuntime_types

function besharp.oopRuntime.ensurePrepareType() {
    local type="${1}"

    if ! besharp.rtti.classExists "${type}" && ! besharp.rtti.interfaceExists "${type}"; then
        if ! besharp.rtti.classExists "${type%Factory}"; then
            besharp.runtime.error "Unknown type: ${type}!"
        fi
        besharp.oopRuntime.createDynamicFactoryClass "${type%Factory}" "${type}"
    fi

    besharp.oopRuntime.prepareType "${type}"
}

function besharp.oopRuntime.prepareType() {
    local type="${1}"

    if besharp.rtti.classExists "${type}"; then
        besharp.oopRuntime.prepareClass "${type}"
    elif besharp.rtti.interfaceExists "${type}"; then
        besharp.oopRuntime.prepareInterface "${type}"
    fi
}

function besharp.oopRuntime.ensureClassExists() {
    local type="${1}"

    if besharp.rtti.classExists "${type}"; then
        return
    fi

    type="${type%Factory}"

    if besharp.rtti.classExists "${type}"; then
        return
    fi

    if besharp.rtti.interfaceExists "${type}"; then
        besharp.runtime.error "'${type}' is an interface! Cannot be used as a class."
    fi

    besharp.runtime.error "Unknown class: ${type}!"
}

function besharp.oopRuntime.generateLinkerLine() {
#    d; d "${*}" # debug
    eval "${@}"
}

fi
if ${beshfile_section__code:-false}; then :;

export besharp_runtime_version="0.1.0"

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Object"]='true'
besharp_oop_type_abstract["Object"]='true'
besharp_oop_type_is["Object"]='class'
besharp_oop_types["Object"]="Object"
declare -Ag besharp_oop_type_Object_interfaces
besharp_oop_classes["Object"]="Object"
besharp_oop_type_parent["Object"]=""
declare -Ag besharp_oop_type_Object_fields
declare -Ag besharp_oop_type_Object_injectable_fields
declare -Ag besharp_oop_type_Object_field_type
declare -Ag besharp_oop_type_Object_field_default
declare -Ag besharp_oop_type_Object_methods
declare -Ag besharp_oop_type_Object_method_body
declare -Ag besharp_oop_type_Object_method_locals
declare -Ag besharp_oop_type_Object_method_is_returning
declare -Ag besharp_oop_type_Object_method_is_abstract
declare -Ag besharp_oop_type_Object_method_is_using_iterators
declare -Ag besharp_oop_type_Object_method_is_calling_parent
declare -Ag besharp_oop_type_Object_method_is_calling_this
besharp_oop_type_Object_methods['Object']='Object'
besharp_oop_type_Object_method_is_returning["Object"]=false
besharp_oop_type_Object_method_body["Object"]='    :'
besharp_oop_type_Object_method_locals["Object"]=''
besharp_oop_type_Object_method_is_using_iterators["Object"]=false
besharp_oop_type_Object_method_is_calling_parent["Object"]=false
besharp_oop_type_Object_method_is_calling_this["Object"]=false
besharp_oop_type_Object_methods['__cloneFrom']='__cloneFrom'
besharp_oop_type_Object_method_is_returning["__cloneFrom"]=false
besharp_oop_type_Object_method_body["__cloneFrom"]='    local value ;
    local source="${1}";
    local mode="${2}";
    if [[ "${mode}" == "" ]] || [[ "${mode}" == "shallow" ]]; then
        local field;
        for field in $(besharp.rtti.allFieldsOf "$( besharp.rtti.objectType "${this}" )" );
        do
            @let $this.$field = $source.$field;
        done;
    else
        if [[ "${mode}" == "deep" ]]; then
            local field;
            for field in $(besharp.rtti.allFieldsOf "$( besharp.rtti.objectType "${this}" )" );
            do
                __be__value $source.$field;
                if besharp.rtti.isObjectExist "${value}"; then
                    @let $this.$field = @clone $value;
                else
                    $this.$field = "${value}";
                fi;
            done;
        else
            if [[ "${mode}" == "@in-place" ]]; then
                local field;
                for field in $(besharp.rtti.allFieldsOf "$( besharp.rtti.objectType "${this}" )" );
                do
                    __be__value $this.$field;
                    if besharp.rtti.isObjectExist "${value}"; then
                        @let $this.$field = @clone $value;
                    fi;
                done;
            else
                besharp.runtime.error "Unknown @clone mode: '"'"'$mode'"'"'. Expected one of: '"'"'shallow'"'"', '"'"'deep'"'"', '"'"'@in-place'"'"'.";
            fi;
        fi;
    fi'
besharp_oop_type_Object_method_locals["__cloneFrom"]='local value'
besharp_oop_type_Object_method_is_using_iterators["__cloneFrom"]=false
besharp_oop_type_Object_method_is_calling_parent["__cloneFrom"]=false
besharp_oop_type_Object_method_is_calling_this["__cloneFrom"]=true
besharp_oop_type_Object_methods['__destroy']='__destroy'
besharp_oop_type_Object_method_is_returning["__destroy"]=false
besharp_oop_type_Object_method_body["__destroy"]='    :'
besharp_oop_type_Object_method_locals["__destroy"]=''
besharp_oop_type_Object_method_is_using_iterators["__destroy"]=false
besharp_oop_type_Object_method_is_calling_parent["__destroy"]=false
besharp_oop_type_Object_method_is_calling_this["__destroy"]=false
besharp_oop_type_Object_methods['__objectId']='__objectId'
besharp_oop_type_Object_method_is_returning["__objectId"]=true
besharp_oop_type_Object_method_body["__objectId"]='    besharp_rcrvs[besharp_rcsl]="${this}"'
besharp_oop_type_Object_method_locals["__objectId"]=''
besharp_oop_type_Object_method_is_using_iterators["__objectId"]=false
besharp_oop_type_Object_method_is_calling_parent["__objectId"]=false
besharp_oop_type_Object_method_is_calling_this["__objectId"]=true

fi
if ${beshfile_section__code:-false}; then :;
function __be__value() {
  "${@}"
  value="${besharp_rcrvs[besharp_rcsl + 1]}"
}
Object ()
{
    :
}
Object.__cloneFrom ()
{
    local value;
    local source="${1}";
    local mode="${2}";
    if [[ "${mode}" == "" ]] || [[ "${mode}" == "shallow" ]]; then
        local field;
        for field in $(besharp.rtti.allFieldsOf "$( besharp.rtti.objectType "${this}" )" );
        do
            @let $this.$field = $source.$field;
        done;
    else
        if [[ "${mode}" == "deep" ]]; then
            local field;
            for field in $(besharp.rtti.allFieldsOf "$( besharp.rtti.objectType "${this}" )" );
            do
                __be__value $source.$field;
                if besharp.rtti.isObjectExist "${value}"; then
                    @let $this.$field = @clone $value;
                else
                    $this.$field = "${value}";
                fi;
            done;
        else
            if [[ "${mode}" == "@in-place" ]]; then
                local field;
                for field in $(besharp.rtti.allFieldsOf "$( besharp.rtti.objectType "${this}" )" );
                do
                    __be__value $this.$field;
                    if besharp.rtti.isObjectExist "${value}"; then
                        @let $this.$field = @clone $value;
                    fi;
                done;
            else
                besharp.runtime.error "Unknown @clone mode: '$mode'. Expected one of: 'shallow', 'deep', '@in-place'.";
            fi;
        fi;
    fi
}
Object.__destroy ()
{
    :
}
Object.__objectId ()
{
    besharp_rcrvs[besharp_rcsl]="${this}"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["PrimitiveObject"]='true'
besharp_oop_type_abstract["PrimitiveObject"]='true'
besharp_oop_type_is["PrimitiveObject"]='class'
besharp_oop_types["PrimitiveObject"]="PrimitiveObject"
declare -Ag besharp_oop_type_PrimitiveObject_interfaces
besharp_oop_classes["PrimitiveObject"]="PrimitiveObject"
besharp_oop_type_parent["PrimitiveObject"]="Object"
declare -Ag besharp_oop_type_PrimitiveObject_fields
declare -Ag besharp_oop_type_PrimitiveObject_injectable_fields
declare -Ag besharp_oop_type_PrimitiveObject_field_type
declare -Ag besharp_oop_type_PrimitiveObject_field_default
declare -Ag besharp_oop_type_PrimitiveObject_methods
declare -Ag besharp_oop_type_PrimitiveObject_method_body
declare -Ag besharp_oop_type_PrimitiveObject_method_locals
declare -Ag besharp_oop_type_PrimitiveObject_method_is_returning
declare -Ag besharp_oop_type_PrimitiveObject_method_is_abstract
declare -Ag besharp_oop_type_PrimitiveObject_method_is_using_iterators
declare -Ag besharp_oop_type_PrimitiveObject_method_is_calling_parent
declare -Ag besharp_oop_type_PrimitiveObject_method_is_calling_this
besharp_oop_type_PrimitiveObject_methods['declarePrimitiveVariable']='declarePrimitiveVariable'
besharp_oop_type_PrimitiveObject_method_is_abstract["declarePrimitiveVariable"]='true'
besharp_oop_type_PrimitiveObject_methods['destroyPrimitiveVariable']='destroyPrimitiveVariable'
besharp_oop_type_PrimitiveObject_method_is_abstract["destroyPrimitiveVariable"]='true'
besharp_oop_type_PrimitiveObject_methods['PrimitiveObject']='PrimitiveObject'
besharp_oop_type_PrimitiveObject_method_is_returning["PrimitiveObject"]=false
besharp_oop_type_PrimitiveObject_method_body["PrimitiveObject"]='    $this.declarePrimitiveVariable'
besharp_oop_type_PrimitiveObject_method_locals["PrimitiveObject"]=''
besharp_oop_type_PrimitiveObject_method_is_using_iterators["PrimitiveObject"]=false
besharp_oop_type_PrimitiveObject_method_is_calling_parent["PrimitiveObject"]=false
besharp_oop_type_PrimitiveObject_method_is_calling_this["PrimitiveObject"]=true
besharp_oop_type_PrimitiveObject_methods['__cloneFrom']='__cloneFrom'
besharp_oop_type_PrimitiveObject_method_is_returning["__cloneFrom"]=false
besharp_oop_type_PrimitiveObject_method_body["__cloneFrom"]='    @parent "${@}";
    $this.declarePrimitiveVariable'
besharp_oop_type_PrimitiveObject_method_locals["__cloneFrom"]=''
besharp_oop_type_PrimitiveObject_method_is_using_iterators["__cloneFrom"]=false
besharp_oop_type_PrimitiveObject_method_is_calling_parent["__cloneFrom"]=true
besharp_oop_type_PrimitiveObject_method_is_calling_this["__cloneFrom"]=true
besharp_oop_type_PrimitiveObject_methods['__destroy']='__destroy'
besharp_oop_type_PrimitiveObject_method_is_returning["__destroy"]=false
besharp_oop_type_PrimitiveObject_method_body["__destroy"]='    $this.destroyPrimitiveVariable'
besharp_oop_type_PrimitiveObject_method_locals["__destroy"]=''
besharp_oop_type_PrimitiveObject_method_is_using_iterators["__destroy"]=false
besharp_oop_type_PrimitiveObject_method_is_calling_parent["__destroy"]=false
besharp_oop_type_PrimitiveObject_method_is_calling_this["__destroy"]=true

fi
if ${beshfile_section__code:-false}; then :;
PrimitiveObject ()
{
    $this.declarePrimitiveVariable
}
PrimitiveObject.__cloneFrom ()
{
    @parent "${@}";
    $this.declarePrimitiveVariable
}
PrimitiveObject.__destroy ()
{
    $this.destroyPrimitiveVariable
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["NaturalOrderComparator"]='true'
besharp_oop_type_is["NaturalOrderComparator"]='class'
besharp_oop_types["NaturalOrderComparator"]="NaturalOrderComparator"
declare -Ag besharp_oop_type_NaturalOrderComparator_interfaces
besharp_oop_type_NaturalOrderComparator_interfaces['Comparator']='Comparator'
besharp_oop_type_NaturalOrderComparator_interfaces['FastComparator']='FastComparator'
besharp_oop_classes["NaturalOrderComparator"]="NaturalOrderComparator"
besharp_oop_type_parent["NaturalOrderComparator"]="Object"
declare -Ag besharp_oop_type_NaturalOrderComparator_fields
declare -Ag besharp_oop_type_NaturalOrderComparator_injectable_fields
declare -Ag besharp_oop_type_NaturalOrderComparator_field_type
declare -Ag besharp_oop_type_NaturalOrderComparator_field_default
declare -Ag besharp_oop_type_NaturalOrderComparator_methods
declare -Ag besharp_oop_type_NaturalOrderComparator_method_body
declare -Ag besharp_oop_type_NaturalOrderComparator_method_locals
declare -Ag besharp_oop_type_NaturalOrderComparator_method_is_returning
declare -Ag besharp_oop_type_NaturalOrderComparator_method_is_abstract
declare -Ag besharp_oop_type_NaturalOrderComparator_method_is_using_iterators
declare -Ag besharp_oop_type_NaturalOrderComparator_method_is_calling_parent
declare -Ag besharp_oop_type_NaturalOrderComparator_method_is_calling_this
besharp_oop_type_NaturalOrderComparator_methods['NaturalOrderComparator']='NaturalOrderComparator'
besharp_oop_type_NaturalOrderComparator_method_is_returning["NaturalOrderComparator"]=false
besharp_oop_type_NaturalOrderComparator_method_body["NaturalOrderComparator"]='    :'
besharp_oop_type_NaturalOrderComparator_method_locals["NaturalOrderComparator"]=''
besharp_oop_type_NaturalOrderComparator_method_is_using_iterators["NaturalOrderComparator"]=false
besharp_oop_type_NaturalOrderComparator_method_is_calling_parent["NaturalOrderComparator"]=false
besharp_oop_type_NaturalOrderComparator_method_is_calling_this["NaturalOrderComparator"]=false
besharp_oop_type_NaturalOrderComparator_methods['compare']='compare'
besharp_oop_type_NaturalOrderComparator_method_is_returning["compare"]=false
besharp_oop_type_NaturalOrderComparator_method_body["compare"]='    local objectA="${1}";
    local objectB="${2}";
    $objectB.compareWith $objectA'
besharp_oop_type_NaturalOrderComparator_method_locals["compare"]=''
besharp_oop_type_NaturalOrderComparator_method_is_using_iterators["compare"]=false
besharp_oop_type_NaturalOrderComparator_method_is_calling_parent["compare"]=false
besharp_oop_type_NaturalOrderComparator_method_is_calling_this["compare"]=false
besharp_oop_type_NaturalOrderComparator_methods['fastCompareFunction']='fastCompareFunction'
besharp_oop_type_NaturalOrderComparator_method_is_returning["fastCompareFunction"]=true
besharp_oop_type_NaturalOrderComparator_method_body["fastCompareFunction"]='    local varAName="${1:-\$valueA}";
    local varBName="${2:-\$valueB}";
    besharp_rcrvs[besharp_rcsl]="${varAName}.compareWith ${varBName} # "'
besharp_oop_type_NaturalOrderComparator_method_locals["fastCompareFunction"]=''
besharp_oop_type_NaturalOrderComparator_method_is_using_iterators["fastCompareFunction"]=false
besharp_oop_type_NaturalOrderComparator_method_is_calling_parent["fastCompareFunction"]=false
besharp_oop_type_NaturalOrderComparator_method_is_calling_this["fastCompareFunction"]=false

fi
if ${beshfile_section__code:-false}; then :;
NaturalOrderComparator ()
{
    :
}
NaturalOrderComparator.compare ()
{
    local objectA="${1}";
    local objectB="${2}";
    $objectB.compareWith $objectA
}
NaturalOrderComparator.fastCompareFunction ()
{
    local varAName="${1:-\$valueA}";
    local varBName="${2:-\$valueB}";
    besharp_rcrvs[besharp_rcsl]="${varAName}.compareWith ${varBName} # "
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["NaturalOrderIntegersComparator"]='true'
besharp_oop_type_is["NaturalOrderIntegersComparator"]='class'
besharp_oop_types["NaturalOrderIntegersComparator"]="NaturalOrderIntegersComparator"
declare -Ag besharp_oop_type_NaturalOrderIntegersComparator_interfaces
besharp_oop_type_NaturalOrderIntegersComparator_interfaces['Comparator']='Comparator'
besharp_oop_type_NaturalOrderIntegersComparator_interfaces['FastComparator']='FastComparator'
besharp_oop_classes["NaturalOrderIntegersComparator"]="NaturalOrderIntegersComparator"
besharp_oop_type_parent["NaturalOrderIntegersComparator"]="Object"
declare -Ag besharp_oop_type_NaturalOrderIntegersComparator_fields
declare -Ag besharp_oop_type_NaturalOrderIntegersComparator_injectable_fields
declare -Ag besharp_oop_type_NaturalOrderIntegersComparator_field_type
declare -Ag besharp_oop_type_NaturalOrderIntegersComparator_field_default
declare -Ag besharp_oop_type_NaturalOrderIntegersComparator_methods
declare -Ag besharp_oop_type_NaturalOrderIntegersComparator_method_body
declare -Ag besharp_oop_type_NaturalOrderIntegersComparator_method_locals
declare -Ag besharp_oop_type_NaturalOrderIntegersComparator_method_is_returning
declare -Ag besharp_oop_type_NaturalOrderIntegersComparator_method_is_abstract
declare -Ag besharp_oop_type_NaturalOrderIntegersComparator_method_is_using_iterators
declare -Ag besharp_oop_type_NaturalOrderIntegersComparator_method_is_calling_parent
declare -Ag besharp_oop_type_NaturalOrderIntegersComparator_method_is_calling_this
besharp_oop_type_NaturalOrderIntegersComparator_methods['NaturalOrderIntegersComparator']='NaturalOrderIntegersComparator'
besharp_oop_type_NaturalOrderIntegersComparator_method_is_returning["NaturalOrderIntegersComparator"]=false
besharp_oop_type_NaturalOrderIntegersComparator_method_body["NaturalOrderIntegersComparator"]='    :'
besharp_oop_type_NaturalOrderIntegersComparator_method_locals["NaturalOrderIntegersComparator"]=''
besharp_oop_type_NaturalOrderIntegersComparator_method_is_using_iterators["NaturalOrderIntegersComparator"]=false
besharp_oop_type_NaturalOrderIntegersComparator_method_is_calling_parent["NaturalOrderIntegersComparator"]=false
besharp_oop_type_NaturalOrderIntegersComparator_method_is_calling_this["NaturalOrderIntegersComparator"]=false
besharp_oop_type_NaturalOrderIntegersComparator_methods['compare']='compare'
besharp_oop_type_NaturalOrderIntegersComparator_method_is_returning["compare"]=false
besharp_oop_type_NaturalOrderIntegersComparator_method_body["compare"]='    local valueA="${1}";
    local valueB="${2}";
    (( valueA < valueB ))'
besharp_oop_type_NaturalOrderIntegersComparator_method_locals["compare"]=''
besharp_oop_type_NaturalOrderIntegersComparator_method_is_using_iterators["compare"]=false
besharp_oop_type_NaturalOrderIntegersComparator_method_is_calling_parent["compare"]=false
besharp_oop_type_NaturalOrderIntegersComparator_method_is_calling_this["compare"]=false
besharp_oop_type_NaturalOrderIntegersComparator_methods['fastCompareFunction']='fastCompareFunction'
besharp_oop_type_NaturalOrderIntegersComparator_method_is_returning["fastCompareFunction"]=true
besharp_oop_type_NaturalOrderIntegersComparator_method_body["fastCompareFunction"]='    local varAName="${1:-\$valueA}";
    local varBName="${2:-\$valueB}";
    besharp_rcrvs[besharp_rcsl]="(( ${varAName} < ${varBName} )) # "'
besharp_oop_type_NaturalOrderIntegersComparator_method_locals["fastCompareFunction"]=''
besharp_oop_type_NaturalOrderIntegersComparator_method_is_using_iterators["fastCompareFunction"]=false
besharp_oop_type_NaturalOrderIntegersComparator_method_is_calling_parent["fastCompareFunction"]=false
besharp_oop_type_NaturalOrderIntegersComparator_method_is_calling_this["fastCompareFunction"]=false

fi
if ${beshfile_section__code:-false}; then :;
NaturalOrderIntegersComparator ()
{
    :
}
NaturalOrderIntegersComparator.compare ()
{
    local valueA="${1}";
    local valueB="${2}";
    (( valueA < valueB ))
}
NaturalOrderIntegersComparator.fastCompareFunction ()
{
    local varAName="${1:-\$valueA}";
    local varBName="${2:-\$valueB}";
    besharp_rcrvs[besharp_rcsl]="(( ${varAName} < ${varBName} )) # "
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["ReversedOrderComparator"]='true'
besharp_oop_type_is["ReversedOrderComparator"]='class'
besharp_oop_types["ReversedOrderComparator"]="ReversedOrderComparator"
declare -Ag besharp_oop_type_ReversedOrderComparator_interfaces
besharp_oop_type_ReversedOrderComparator_interfaces['Comparator']='Comparator'
besharp_oop_type_ReversedOrderComparator_interfaces['FastComparator']='FastComparator'
besharp_oop_classes["ReversedOrderComparator"]="ReversedOrderComparator"
besharp_oop_type_parent["ReversedOrderComparator"]="Object"
declare -Ag besharp_oop_type_ReversedOrderComparator_fields
declare -Ag besharp_oop_type_ReversedOrderComparator_injectable_fields
declare -Ag besharp_oop_type_ReversedOrderComparator_field_type
declare -Ag besharp_oop_type_ReversedOrderComparator_field_default
declare -Ag besharp_oop_type_ReversedOrderComparator_methods
declare -Ag besharp_oop_type_ReversedOrderComparator_method_body
declare -Ag besharp_oop_type_ReversedOrderComparator_method_locals
declare -Ag besharp_oop_type_ReversedOrderComparator_method_is_returning
declare -Ag besharp_oop_type_ReversedOrderComparator_method_is_abstract
declare -Ag besharp_oop_type_ReversedOrderComparator_method_is_using_iterators
declare -Ag besharp_oop_type_ReversedOrderComparator_method_is_calling_parent
declare -Ag besharp_oop_type_ReversedOrderComparator_method_is_calling_this
besharp_oop_type_ReversedOrderComparator_methods['ReversedOrderComparator']='ReversedOrderComparator'
besharp_oop_type_ReversedOrderComparator_method_is_returning["ReversedOrderComparator"]=false
besharp_oop_type_ReversedOrderComparator_method_body["ReversedOrderComparator"]='    :'
besharp_oop_type_ReversedOrderComparator_method_locals["ReversedOrderComparator"]=''
besharp_oop_type_ReversedOrderComparator_method_is_using_iterators["ReversedOrderComparator"]=false
besharp_oop_type_ReversedOrderComparator_method_is_calling_parent["ReversedOrderComparator"]=false
besharp_oop_type_ReversedOrderComparator_method_is_calling_this["ReversedOrderComparator"]=false
besharp_oop_type_ReversedOrderComparator_methods['compare']='compare'
besharp_oop_type_ReversedOrderComparator_method_is_returning["compare"]=false
besharp_oop_type_ReversedOrderComparator_method_body["compare"]='    local objectA="${1}";
    local objectB="${2}";
    ! $objectB.compareWith $objectA'
besharp_oop_type_ReversedOrderComparator_method_locals["compare"]=''
besharp_oop_type_ReversedOrderComparator_method_is_using_iterators["compare"]=false
besharp_oop_type_ReversedOrderComparator_method_is_calling_parent["compare"]=false
besharp_oop_type_ReversedOrderComparator_method_is_calling_this["compare"]=false
besharp_oop_type_ReversedOrderComparator_methods['fastCompareFunction']='fastCompareFunction'
besharp_oop_type_ReversedOrderComparator_method_is_returning["fastCompareFunction"]=true
besharp_oop_type_ReversedOrderComparator_method_body["fastCompareFunction"]='    local varAName="${1:-\$valueA}";
    local varBName="${2:-\$valueB}";
    ! besharp_rcrvs[besharp_rcsl]="${varAName}.compareWith ${varBName} # "'
besharp_oop_type_ReversedOrderComparator_method_locals["fastCompareFunction"]=''
besharp_oop_type_ReversedOrderComparator_method_is_using_iterators["fastCompareFunction"]=false
besharp_oop_type_ReversedOrderComparator_method_is_calling_parent["fastCompareFunction"]=false
besharp_oop_type_ReversedOrderComparator_method_is_calling_this["fastCompareFunction"]=false

fi
if ${beshfile_section__code:-false}; then :;
ReversedOrderComparator ()
{
    :
}
ReversedOrderComparator.compare ()
{
    local objectA="${1}";
    local objectB="${2}";
    ! $objectB.compareWith $objectA
}
ReversedOrderComparator.fastCompareFunction ()
{
    local varAName="${1:-\$valueA}";
    local varBName="${2:-\$valueB}";
    ! besharp_rcrvs[besharp_rcsl]="${varAName}.compareWith ${varBName} # "
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["ReversedOrderIntegersComparator"]='true'
besharp_oop_type_is["ReversedOrderIntegersComparator"]='class'
besharp_oop_types["ReversedOrderIntegersComparator"]="ReversedOrderIntegersComparator"
declare -Ag besharp_oop_type_ReversedOrderIntegersComparator_interfaces
besharp_oop_type_ReversedOrderIntegersComparator_interfaces['Comparator']='Comparator'
besharp_oop_type_ReversedOrderIntegersComparator_interfaces['FastComparator']='FastComparator'
besharp_oop_classes["ReversedOrderIntegersComparator"]="ReversedOrderIntegersComparator"
besharp_oop_type_parent["ReversedOrderIntegersComparator"]="Object"
declare -Ag besharp_oop_type_ReversedOrderIntegersComparator_fields
declare -Ag besharp_oop_type_ReversedOrderIntegersComparator_injectable_fields
declare -Ag besharp_oop_type_ReversedOrderIntegersComparator_field_type
declare -Ag besharp_oop_type_ReversedOrderIntegersComparator_field_default
declare -Ag besharp_oop_type_ReversedOrderIntegersComparator_methods
declare -Ag besharp_oop_type_ReversedOrderIntegersComparator_method_body
declare -Ag besharp_oop_type_ReversedOrderIntegersComparator_method_locals
declare -Ag besharp_oop_type_ReversedOrderIntegersComparator_method_is_returning
declare -Ag besharp_oop_type_ReversedOrderIntegersComparator_method_is_abstract
declare -Ag besharp_oop_type_ReversedOrderIntegersComparator_method_is_using_iterators
declare -Ag besharp_oop_type_ReversedOrderIntegersComparator_method_is_calling_parent
declare -Ag besharp_oop_type_ReversedOrderIntegersComparator_method_is_calling_this
besharp_oop_type_ReversedOrderIntegersComparator_methods['ReversedOrderIntegersComparator']='ReversedOrderIntegersComparator'
besharp_oop_type_ReversedOrderIntegersComparator_method_is_returning["ReversedOrderIntegersComparator"]=false
besharp_oop_type_ReversedOrderIntegersComparator_method_body["ReversedOrderIntegersComparator"]='    :'
besharp_oop_type_ReversedOrderIntegersComparator_method_locals["ReversedOrderIntegersComparator"]=''
besharp_oop_type_ReversedOrderIntegersComparator_method_is_using_iterators["ReversedOrderIntegersComparator"]=false
besharp_oop_type_ReversedOrderIntegersComparator_method_is_calling_parent["ReversedOrderIntegersComparator"]=false
besharp_oop_type_ReversedOrderIntegersComparator_method_is_calling_this["ReversedOrderIntegersComparator"]=false
besharp_oop_type_ReversedOrderIntegersComparator_methods['compare']='compare'
besharp_oop_type_ReversedOrderIntegersComparator_method_is_returning["compare"]=false
besharp_oop_type_ReversedOrderIntegersComparator_method_body["compare"]='    local valueA="${1}";
    local valueB="${2}";
    ! (( valueA < valueB ))'
besharp_oop_type_ReversedOrderIntegersComparator_method_locals["compare"]=''
besharp_oop_type_ReversedOrderIntegersComparator_method_is_using_iterators["compare"]=false
besharp_oop_type_ReversedOrderIntegersComparator_method_is_calling_parent["compare"]=false
besharp_oop_type_ReversedOrderIntegersComparator_method_is_calling_this["compare"]=false
besharp_oop_type_ReversedOrderIntegersComparator_methods['fastCompareFunction']='fastCompareFunction'
besharp_oop_type_ReversedOrderIntegersComparator_method_is_returning["fastCompareFunction"]=true
besharp_oop_type_ReversedOrderIntegersComparator_method_body["fastCompareFunction"]='    local varAName="${1:-\$valueA}";
    local varBName="${2:-\$valueB}";
    besharp_rcrvs[besharp_rcsl]="! (( ${varAName} < ${varBName} )) # "'
besharp_oop_type_ReversedOrderIntegersComparator_method_locals["fastCompareFunction"]=''
besharp_oop_type_ReversedOrderIntegersComparator_method_is_using_iterators["fastCompareFunction"]=false
besharp_oop_type_ReversedOrderIntegersComparator_method_is_calling_parent["fastCompareFunction"]=false
besharp_oop_type_ReversedOrderIntegersComparator_method_is_calling_this["fastCompareFunction"]=false

fi
if ${beshfile_section__code:-false}; then :;
ReversedOrderIntegersComparator ()
{
    :
}
ReversedOrderIntegersComparator.compare ()
{
    local valueA="${1}";
    local valueB="${2}";
    ! (( valueA < valueB ))
}
ReversedOrderIntegersComparator.fastCompareFunction ()
{
    local varAName="${1:-\$valueA}";
    local varBName="${2:-\$valueB}";
    besharp_rcrvs[besharp_rcsl]="! (( ${varAName} < ${varBName} )) # "
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["SimpleFactory"]='true'
besharp_oop_type_is["SimpleFactory"]='class'
besharp_oop_types["SimpleFactory"]="SimpleFactory"
declare -Ag besharp_oop_type_SimpleFactory_interfaces
besharp_oop_type_SimpleFactory_interfaces['Factory']='Factory'
besharp_oop_classes["SimpleFactory"]="SimpleFactory"
besharp_oop_type_parent["SimpleFactory"]="Object"
declare -Ag besharp_oop_type_SimpleFactory_fields
declare -Ag besharp_oop_type_SimpleFactory_injectable_fields
declare -Ag besharp_oop_type_SimpleFactory_field_type
declare -Ag besharp_oop_type_SimpleFactory_field_default
declare -Ag besharp_oop_type_SimpleFactory_methods
declare -Ag besharp_oop_type_SimpleFactory_method_body
declare -Ag besharp_oop_type_SimpleFactory_method_locals
declare -Ag besharp_oop_type_SimpleFactory_method_is_returning
declare -Ag besharp_oop_type_SimpleFactory_method_is_abstract
declare -Ag besharp_oop_type_SimpleFactory_method_is_using_iterators
declare -Ag besharp_oop_type_SimpleFactory_method_is_calling_parent
declare -Ag besharp_oop_type_SimpleFactory_method_is_calling_this
besharp_oop_type_SimpleFactory_fields['class']='class'
besharp_oop_type_SimpleFactory_field_default['class']=""
besharp_oop_type_SimpleFactory_methods['SimpleFactory']='SimpleFactory'
besharp_oop_type_SimpleFactory_method_is_returning["SimpleFactory"]=false
besharp_oop_type_SimpleFactory_method_body["SimpleFactory"]='    $this.class = "${1}"'
besharp_oop_type_SimpleFactory_method_locals["SimpleFactory"]=''
besharp_oop_type_SimpleFactory_method_is_using_iterators["SimpleFactory"]=false
besharp_oop_type_SimpleFactory_method_is_calling_parent["SimpleFactory"]=false
besharp_oop_type_SimpleFactory_method_is_calling_this["SimpleFactory"]=true
besharp_oop_type_SimpleFactory_methods['create']='create'
besharp_oop_type_SimpleFactory_method_is_returning["create"]=true
besharp_oop_type_SimpleFactory_method_body["create"]='    local class object ;
    __be__class $this.class;
    __be__object @new ${class} "${@}";
    besharp_rcrvs[besharp_rcsl]=$object'
besharp_oop_type_SimpleFactory_method_locals["create"]='local class
local object'
besharp_oop_type_SimpleFactory_method_is_using_iterators["create"]=false
besharp_oop_type_SimpleFactory_method_is_calling_parent["create"]=false
besharp_oop_type_SimpleFactory_method_is_calling_this["create"]=true

fi
if ${beshfile_section__code:-false}; then :;
function __be__class() {
  "${@}"
  class="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__object() {
  "${@}"
  object="${besharp_rcrvs[besharp_rcsl + 1]}"
}
SimpleFactory ()
{
    $this.class = "${1}"
}
SimpleFactory.create ()
{
    local class object;
    __be__class $this.class;
    __be__object @new ${class} "${@}";
    besharp_rcrvs[besharp_rcsl]=$object
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["SingletonFactory"]='true'
besharp_oop_type_is["SingletonFactory"]='class'
besharp_oop_types["SingletonFactory"]="SingletonFactory"
declare -Ag besharp_oop_type_SingletonFactory_interfaces
besharp_oop_type_SingletonFactory_interfaces['Factory']='Factory'
besharp_oop_classes["SingletonFactory"]="SingletonFactory"
besharp_oop_type_parent["SingletonFactory"]="SimpleFactory"
declare -Ag besharp_oop_type_SingletonFactory_fields
declare -Ag besharp_oop_type_SingletonFactory_injectable_fields
declare -Ag besharp_oop_type_SingletonFactory_field_type
declare -Ag besharp_oop_type_SingletonFactory_field_default
declare -Ag besharp_oop_type_SingletonFactory_methods
declare -Ag besharp_oop_type_SingletonFactory_method_body
declare -Ag besharp_oop_type_SingletonFactory_method_locals
declare -Ag besharp_oop_type_SingletonFactory_method_is_returning
declare -Ag besharp_oop_type_SingletonFactory_method_is_abstract
declare -Ag besharp_oop_type_SingletonFactory_method_is_using_iterators
declare -Ag besharp_oop_type_SingletonFactory_method_is_calling_parent
declare -Ag besharp_oop_type_SingletonFactory_method_is_calling_this
besharp_oop_type_SingletonFactory_fields['class']='class'
besharp_oop_type_SingletonFactory_field_default['class']=""
besharp_oop_type_SingletonFactory_fields['object']='object'
besharp_oop_type_SingletonFactory_field_default['object']=""
besharp_oop_type_SingletonFactory_methods['SingletonFactory']='SingletonFactory'
besharp_oop_type_SingletonFactory_method_is_returning["SingletonFactory"]=false
besharp_oop_type_SingletonFactory_method_body["SingletonFactory"]='    $this.class = "${1}"'
besharp_oop_type_SingletonFactory_method_locals["SingletonFactory"]=''
besharp_oop_type_SingletonFactory_method_is_using_iterators["SingletonFactory"]=false
besharp_oop_type_SingletonFactory_method_is_calling_parent["SingletonFactory"]=false
besharp_oop_type_SingletonFactory_method_is_calling_this["SingletonFactory"]=true
besharp_oop_type_SingletonFactory_methods['create']='create'
besharp_oop_type_SingletonFactory_method_is_returning["create"]=true
besharp_oop_type_SingletonFactory_method_body["create"]='    if ! @exists @of $this.object; then
        __be___this_object @parent "${@}";
    fi;
    besharp.returningOf $this.object'
besharp_oop_type_SingletonFactory_method_locals["create"]=''
besharp_oop_type_SingletonFactory_method_is_using_iterators["create"]=false
besharp_oop_type_SingletonFactory_method_is_calling_parent["create"]=true
besharp_oop_type_SingletonFactory_method_is_calling_this["create"]=true

fi
if ${beshfile_section__code:-false}; then :;
function __be___this_object() {
  "${@}"
  eval $this"_object=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
}
SingletonFactory ()
{
    $this.class = "${1}"
}
SingletonFactory.create ()
{
    if ! @exists @of $this.object; then
        __be___this_object @parent "${@}";
    fi;
    besharp.returningOf $this.object
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_is["Entrypoint"]='interface'
besharp_oop_types["Entrypoint"]="Entrypoint"
besharp_oop_interfaces["Entrypoint"]="Entrypoint"
declare -Ag besharp_oop_type_Entrypoint_interfaces
declare -Ag besharp_oop_type_Entrypoint_methods
declare -Ag besharp_oop_type_Entrypoint_method_is_abstract
besharp_oop_type_Entrypoint_methods['main']='main'
besharp_oop_type_Entrypoint_method_is_abstract["main"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Comparable"]='true'
besharp_oop_type_is["Comparable"]='interface'
besharp_oop_types["Comparable"]="Comparable"
besharp_oop_interfaces["Comparable"]="Comparable"
declare -Ag besharp_oop_type_Comparable_interfaces
declare -Ag besharp_oop_type_Comparable_methods
declare -Ag besharp_oop_type_Comparable_method_is_abstract
besharp_oop_type_Comparable_methods['compareWith']='compareWith'
besharp_oop_type_Comparable_method_is_abstract["compareWith"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Comparator"]='true'
besharp_oop_type_is["Comparator"]='interface'
besharp_oop_types["Comparator"]="Comparator"
besharp_oop_interfaces["Comparator"]="Comparator"
declare -Ag besharp_oop_type_Comparator_interfaces
declare -Ag besharp_oop_type_Comparator_methods
declare -Ag besharp_oop_type_Comparator_method_is_abstract
besharp_oop_type_Comparator_methods['compare']='compare'
besharp_oop_type_Comparator_method_is_abstract["compare"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["FastComparator"]='true'
besharp_oop_type_is["FastComparator"]='interface'
besharp_oop_types["FastComparator"]="FastComparator"
besharp_oop_interfaces["FastComparator"]="FastComparator"
declare -Ag besharp_oop_type_FastComparator_interfaces
declare -Ag besharp_oop_type_FastComparator_methods
declare -Ag besharp_oop_type_FastComparator_method_is_abstract
besharp_oop_type_FastComparator_methods['fastCompareFunction']='fastCompareFunction'
besharp_oop_type_FastComparator_method_is_abstract["fastCompareFunction"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Factory"]='true'
besharp_oop_type_is["Factory"]='interface'
besharp_oop_types["Factory"]="Factory"
besharp_oop_interfaces["Factory"]="Factory"
declare -Ag besharp_oop_type_Factory_interfaces
declare -Ag besharp_oop_type_Factory_methods
declare -Ag besharp_oop_type_Factory_method_is_abstract
besharp_oop_type_Factory_methods['create']='create'
besharp_oop_type_Factory_method_is_abstract["create"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Comparators"]='true'
besharp_oop_type_is["Comparators"]='class'
besharp_oop_types["Comparators"]="Comparators"
declare -Ag besharp_oop_type_Comparators_interfaces
besharp_oop_classes["Comparators"]="Comparators"
besharp_oop_type_parent["Comparators"]="Object"
declare -Ag besharp_oop_type_Comparators_fields
declare -Ag besharp_oop_type_Comparators_injectable_fields
declare -Ag besharp_oop_type_Comparators_field_type
declare -Ag besharp_oop_type_Comparators_field_default
declare -Ag besharp_oop_type_Comparators_methods
declare -Ag besharp_oop_type_Comparators_method_body
declare -Ag besharp_oop_type_Comparators_method_locals
declare -Ag besharp_oop_type_Comparators_method_is_returning
declare -Ag besharp_oop_type_Comparators_method_is_abstract
declare -Ag besharp_oop_type_Comparators_method_is_using_iterators
declare -Ag besharp_oop_type_Comparators_method_is_calling_parent
declare -Ag besharp_oop_type_Comparators_method_is_calling_this
besharp_oop_type_static["Comparators"]='Comparators'
besharp_oop_type_static_accessor["Comparators"]='@comparators'
besharp_oop_type_Comparators_methods['Comparators']='Comparators'
besharp_oop_type_Comparators_method_is_returning["Comparators"]=false
besharp_oop_type_Comparators_method_body["Comparators"]='    :'
besharp_oop_type_Comparators_method_locals["Comparators"]=''
besharp_oop_type_Comparators_method_is_using_iterators["Comparators"]=false
besharp_oop_type_Comparators_method_is_calling_parent["Comparators"]=false
besharp_oop_type_Comparators_method_is_calling_this["Comparators"]=false
besharp_oop_type_Comparators_methods['makeForNaturalOrder']='makeForNaturalOrder'
besharp_oop_type_Comparators_method_is_returning["makeForNaturalOrder"]=true
besharp_oop_type_Comparators_method_body["makeForNaturalOrder"]='    local reversed="${1:-false}";
    if $reversed; then
        besharp.returningOf @new ReversedOrderComparator;
    else
        besharp.returningOf @new NaturalOrderComparator;
    fi'
besharp_oop_type_Comparators_method_locals["makeForNaturalOrder"]=''
besharp_oop_type_Comparators_method_is_using_iterators["makeForNaturalOrder"]=false
besharp_oop_type_Comparators_method_is_calling_parent["makeForNaturalOrder"]=false
besharp_oop_type_Comparators_method_is_calling_this["makeForNaturalOrder"]=false
besharp_oop_type_Comparators_methods['makeForNaturalOrderIntegers']='makeForNaturalOrderIntegers'
besharp_oop_type_Comparators_method_is_returning["makeForNaturalOrderIntegers"]=true
besharp_oop_type_Comparators_method_body["makeForNaturalOrderIntegers"]='    local reversed="${1:-false}";
    if $reversed; then
        besharp.returningOf @new ReversedOrderIntegersComparator;
    else
        besharp.returningOf @new NaturalOrderIntegersComparator;
    fi'
besharp_oop_type_Comparators_method_locals["makeForNaturalOrderIntegers"]=''
besharp_oop_type_Comparators_method_is_using_iterators["makeForNaturalOrderIntegers"]=false
besharp_oop_type_Comparators_method_is_calling_parent["makeForNaturalOrderIntegers"]=false
besharp_oop_type_Comparators_method_is_calling_this["makeForNaturalOrderIntegers"]=false
besharp_oop_type_Comparators_methods['makeForReversedOrder']='makeForReversedOrder'
besharp_oop_type_Comparators_method_is_returning["makeForReversedOrder"]=true
besharp_oop_type_Comparators_method_body["makeForReversedOrder"]='    local reversed="${1:-false}";
    if $reversed; then
        besharp.returningOf @new NaturalOrderComparator;
    else
        besharp.returningOf @new ReversedOrderComparator;
    fi'
besharp_oop_type_Comparators_method_locals["makeForReversedOrder"]=''
besharp_oop_type_Comparators_method_is_using_iterators["makeForReversedOrder"]=false
besharp_oop_type_Comparators_method_is_calling_parent["makeForReversedOrder"]=false
besharp_oop_type_Comparators_method_is_calling_this["makeForReversedOrder"]=false
besharp_oop_type_Comparators_methods['makeForReversedOrderIntegers']='makeForReversedOrderIntegers'
besharp_oop_type_Comparators_method_is_returning["makeForReversedOrderIntegers"]=true
besharp_oop_type_Comparators_method_body["makeForReversedOrderIntegers"]='    local reversed="${1:-false}";
    if $reversed; then
        besharp.returningOf @new NaturalOrderIntegersComparator;
    else
        besharp.returningOf @new ReversedOrderIntegersComparator;
    fi'
besharp_oop_type_Comparators_method_locals["makeForReversedOrderIntegers"]=''
besharp_oop_type_Comparators_method_is_using_iterators["makeForReversedOrderIntegers"]=false
besharp_oop_type_Comparators_method_is_calling_parent["makeForReversedOrderIntegers"]=false
besharp_oop_type_Comparators_method_is_calling_this["makeForReversedOrderIntegers"]=false

fi
if ${beshfile_section__code:-false}; then :;
Comparators ()
{
    :
}
Comparators.makeForNaturalOrder ()
{
    local reversed="${1:-false}";
    if $reversed; then
        besharp.returningOf @new ReversedOrderComparator;
    else
        besharp.returningOf @new NaturalOrderComparator;
    fi
}
Comparators.makeForNaturalOrderIntegers ()
{
    local reversed="${1:-false}";
    if $reversed; then
        besharp.returningOf @new ReversedOrderIntegersComparator;
    else
        besharp.returningOf @new NaturalOrderIntegersComparator;
    fi
}
Comparators.makeForReversedOrder ()
{
    local reversed="${1:-false}";
    if $reversed; then
        besharp.returningOf @new NaturalOrderComparator;
    else
        besharp.returningOf @new ReversedOrderComparator;
    fi
}
Comparators.makeForReversedOrderIntegers ()
{
    local reversed="${1:-false}";
    if $reversed; then
        besharp.returningOf @new NaturalOrderIntegersComparator;
    else
        besharp.returningOf @new ReversedOrderIntegersComparator;
    fi
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Objects"]='true'
besharp_oop_type_is["Objects"]='class'
besharp_oop_types["Objects"]="Objects"
declare -Ag besharp_oop_type_Objects_interfaces
besharp_oop_classes["Objects"]="Objects"
besharp_oop_type_parent["Objects"]="Object"
declare -Ag besharp_oop_type_Objects_fields
declare -Ag besharp_oop_type_Objects_injectable_fields
declare -Ag besharp_oop_type_Objects_field_type
declare -Ag besharp_oop_type_Objects_field_default
declare -Ag besharp_oop_type_Objects_methods
declare -Ag besharp_oop_type_Objects_method_body
declare -Ag besharp_oop_type_Objects_method_locals
declare -Ag besharp_oop_type_Objects_method_is_returning
declare -Ag besharp_oop_type_Objects_method_is_abstract
declare -Ag besharp_oop_type_Objects_method_is_using_iterators
declare -Ag besharp_oop_type_Objects_method_is_calling_parent
declare -Ag besharp_oop_type_Objects_method_is_calling_this
besharp_oop_type_static["Objects"]='Objects'
besharp_oop_type_static_accessor["Objects"]='@objects'
besharp_oop_type_Objects_methods['Objects']='Objects'
besharp_oop_type_Objects_method_is_returning["Objects"]=false
besharp_oop_type_Objects_method_body["Objects"]='    :'
besharp_oop_type_Objects_method_locals["Objects"]=''
besharp_oop_type_Objects_method_is_using_iterators["Objects"]=false
besharp_oop_type_Objects_method_is_calling_parent["Objects"]=false
besharp_oop_type_Objects_method_is_calling_this["Objects"]=false

fi
if ${beshfile_section__code:-false}; then :;
Objects ()
{
    :
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["ArrayList"]='true'
besharp_oop_type_is["ArrayList"]='class'
besharp_oop_types["ArrayList"]="ArrayList"
declare -Ag besharp_oop_type_ArrayList_interfaces
besharp_oop_type_ArrayList_interfaces['List']='List'
besharp_oop_classes["ArrayList"]="ArrayList"
besharp_oop_type_parent["ArrayList"]="IndexedArrayCollection"
declare -Ag besharp_oop_type_ArrayList_fields
declare -Ag besharp_oop_type_ArrayList_injectable_fields
declare -Ag besharp_oop_type_ArrayList_field_type
declare -Ag besharp_oop_type_ArrayList_field_default
declare -Ag besharp_oop_type_ArrayList_methods
declare -Ag besharp_oop_type_ArrayList_method_body
declare -Ag besharp_oop_type_ArrayList_method_locals
declare -Ag besharp_oop_type_ArrayList_method_is_returning
declare -Ag besharp_oop_type_ArrayList_method_is_abstract
declare -Ag besharp_oop_type_ArrayList_method_is_using_iterators
declare -Ag besharp_oop_type_ArrayList_method_is_calling_parent
declare -Ag besharp_oop_type_ArrayList_method_is_calling_this
besharp_oop_type_ArrayList_methods['ArrayList']='ArrayList'
besharp_oop_type_ArrayList_method_is_returning["ArrayList"]=false
besharp_oop_type_ArrayList_method_body["ArrayList"]='    @parent'
besharp_oop_type_ArrayList_method_locals["ArrayList"]=''
besharp_oop_type_ArrayList_method_is_using_iterators["ArrayList"]=false
besharp_oop_type_ArrayList_method_is_calling_parent["ArrayList"]=true
besharp_oop_type_ArrayList_method_is_calling_this["ArrayList"]=false
besharp_oop_type_ArrayList_methods['findIndex']='findIndex'
besharp_oop_type_ArrayList_method_is_returning["findIndex"]=true
besharp_oop_type_ArrayList_method_body["findIndex"]='    local item="${1}";
    local minIndex="${2:--1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        if (( idx < minIndex )); then
            continue;
        fi;
        if @same "${temp[$idx]}" "${item}"; then
            besharp_rcrvs[besharp_rcsl]="${idx}";
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=-1'
besharp_oop_type_ArrayList_method_locals["findIndex"]=''
besharp_oop_type_ArrayList_method_is_using_iterators["findIndex"]=false
besharp_oop_type_ArrayList_method_is_calling_parent["findIndex"]=false
besharp_oop_type_ArrayList_method_is_calling_this["findIndex"]=true
besharp_oop_type_ArrayList_methods['findIndices']='findIndices'
besharp_oop_type_ArrayList_method_is_returning["findIndices"]=true
besharp_oop_type_ArrayList_method_body["findIndices"]='    local resultCollection ;
    local item="${1}";
    __be__resultCollection @new ArrayVector;
    besharp_rcrvs[besharp_rcsl]=$resultCollection;
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        if @same "${temp[$idx]}" "${item}"; then
            $resultCollection.add "${idx}";
        fi;
    done'
besharp_oop_type_ArrayList_method_locals["findIndices"]='local resultCollection'
besharp_oop_type_ArrayList_method_is_using_iterators["findIndices"]=false
besharp_oop_type_ArrayList_method_is_calling_parent["findIndices"]=false
besharp_oop_type_ArrayList_method_is_calling_this["findIndices"]=true
besharp_oop_type_ArrayList_methods['findLastIndex']='findLastIndex'
besharp_oop_type_ArrayList_method_is_returning["findLastIndex"]=true
besharp_oop_type_ArrayList_method_body["findLastIndex"]='    local item="${1}";
    local maxIndex="${2:--1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    local found=false;
    for idx in "${!temp[@]}";
    do
        if (( maxIndex >= 0 && idx > maxIndex )); then
            continue;
        fi;
        if @same "${temp[$idx]}" "${item}"; then
            found=true;
            besharp_rcrvs[besharp_rcsl]="${idx}";
        fi;
    done;
    if ! $found; then
        besharp_rcrvs[besharp_rcsl]=-1;
    fi'
besharp_oop_type_ArrayList_method_locals["findLastIndex"]=''
besharp_oop_type_ArrayList_method_is_using_iterators["findLastIndex"]=false
besharp_oop_type_ArrayList_method_is_calling_parent["findLastIndex"]=false
besharp_oop_type_ArrayList_method_is_calling_this["findLastIndex"]=true
besharp_oop_type_ArrayList_methods['get']='get'
besharp_oop_type_ArrayList_method_is_returning["get"]=true
besharp_oop_type_ArrayList_method_body["get"]='    local index="${1}";
    local item;
    eval "item=\"\${${this}[${index}]}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"'
besharp_oop_type_ArrayList_method_locals["get"]=''
besharp_oop_type_ArrayList_method_is_using_iterators["get"]=false
besharp_oop_type_ArrayList_method_is_calling_parent["get"]=false
besharp_oop_type_ArrayList_method_is_calling_this["get"]=true
besharp_oop_type_ArrayList_methods['hasIndex']='hasIndex'
besharp_oop_type_ArrayList_method_is_returning["hasIndex"]=true
besharp_oop_type_ArrayList_method_body["hasIndex"]='    local index="${1}";
    local isset;
    eval "isset=\${${this}[${index}]+isset}";
    if [[ "${isset}" == '"'"'isset'"'"' ]]; then
        besharp_rcrvs[besharp_rcsl]=true;
    else
        besharp_rcrvs[besharp_rcsl]=false;
    fi'
besharp_oop_type_ArrayList_method_locals["hasIndex"]=''
besharp_oop_type_ArrayList_method_is_using_iterators["hasIndex"]=false
besharp_oop_type_ArrayList_method_is_calling_parent["hasIndex"]=false
besharp_oop_type_ArrayList_method_is_calling_this["hasIndex"]=true
besharp_oop_type_ArrayList_methods['hasKey']='hasKey'
besharp_oop_type_ArrayList_method_is_returning["hasKey"]=true
besharp_oop_type_ArrayList_method_body["hasKey"]='    besharp.returningOf $this.hasIndex "${@}"'
besharp_oop_type_ArrayList_method_locals["hasKey"]=''
besharp_oop_type_ArrayList_method_is_using_iterators["hasKey"]=false
besharp_oop_type_ArrayList_method_is_calling_parent["hasKey"]=false
besharp_oop_type_ArrayList_method_is_calling_this["hasKey"]=true
besharp_oop_type_ArrayList_methods['removeIndex']='removeIndex'
besharp_oop_type_ArrayList_method_is_returning["removeIndex"]=false
besharp_oop_type_ArrayList_method_body["removeIndex"]='    local index="${1}";
    unset "${this}[${index}]"'
besharp_oop_type_ArrayList_method_locals["removeIndex"]=''
besharp_oop_type_ArrayList_method_is_using_iterators["removeIndex"]=false
besharp_oop_type_ArrayList_method_is_calling_parent["removeIndex"]=false
besharp_oop_type_ArrayList_method_is_calling_this["removeIndex"]=true
besharp_oop_type_ArrayList_methods['removeIndices']='removeIndices'
besharp_oop_type_ArrayList_method_is_returning["removeIndices"]=false
besharp_oop_type_ArrayList_method_body["removeIndices"]='    local index;
    while @iterate "${@}" @in index; do
        $this.removeIndex "${index}";
    done'
besharp_oop_type_ArrayList_method_locals["removeIndices"]='local index'
besharp_oop_type_ArrayList_method_is_using_iterators["removeIndices"]=true
besharp_oop_type_ArrayList_method_is_calling_parent["removeIndices"]=false
besharp_oop_type_ArrayList_method_is_calling_this["removeIndices"]=true
besharp_oop_type_ArrayList_methods['set']='set'
besharp_oop_type_ArrayList_method_is_returning["set"]=true
besharp_oop_type_ArrayList_method_body["set"]='    local index="${1}";
    local item="${2}";
    eval "${this}[${index}]=\"\${item}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"'
besharp_oop_type_ArrayList_method_locals["set"]=''
besharp_oop_type_ArrayList_method_is_using_iterators["set"]=false
besharp_oop_type_ArrayList_method_is_calling_parent["set"]=false
besharp_oop_type_ArrayList_method_is_calling_this["set"]=true

fi
if ${beshfile_section__code:-false}; then :;
function __be__resultCollection() {
  "${@}"
  resultCollection="${besharp_rcrvs[besharp_rcsl + 1]}"
}
ArrayList ()
{
    @parent
}
ArrayList.findIndex ()
{
    local item="${1}";
    local minIndex="${2:--1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        if (( idx < minIndex )); then
            continue;
        fi;
        if @same "${temp[$idx]}" "${item}"; then
            besharp_rcrvs[besharp_rcsl]="${idx}";
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=-1
}
ArrayList.findIndices ()
{
    local resultCollection;
    local item="${1}";
    __be__resultCollection @new ArrayVector;
    besharp_rcrvs[besharp_rcsl]=$resultCollection;
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        if @same "${temp[$idx]}" "${item}"; then
            $resultCollection.add "${idx}";
        fi;
    done
}
ArrayList.findLastIndex ()
{
    local item="${1}";
    local maxIndex="${2:--1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    local found=false;
    for idx in "${!temp[@]}";
    do
        if (( maxIndex >= 0 && idx > maxIndex )); then
            continue;
        fi;
        if @same "${temp[$idx]}" "${item}"; then
            found=true;
            besharp_rcrvs[besharp_rcsl]="${idx}";
        fi;
    done;
    if ! $found; then
        besharp_rcrvs[besharp_rcsl]=-1;
    fi
}
ArrayList.get ()
{
    local index="${1}";
    local item;
    eval "item=\"\${${this}[${index}]}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"
}
ArrayList.hasIndex ()
{
    local index="${1}";
    local isset;
    eval "isset=\${${this}[${index}]+isset}";
    if [[ "${isset}" == 'isset' ]]; then
        besharp_rcrvs[besharp_rcsl]=true;
    else
        besharp_rcrvs[besharp_rcsl]=false;
    fi
}
ArrayList.hasKey ()
{
    besharp.returningOf $this.hasIndex "${@}"
}
ArrayList.removeIndex ()
{
    local index="${1}";
    unset "${this}[${index}]"
}
ArrayList.removeIndices ()
{
    local index;
    while @iterate "${@}" @in index; do
        $this.removeIndex "${index}";
    done
}
ArrayList.set ()
{
    local index="${1}";
    local item="${2}";
    eval "${this}[${index}]=\"\${item}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["ArrayMap"]='true'
besharp_oop_type_is["ArrayMap"]='class'
besharp_oop_types["ArrayMap"]="ArrayMap"
declare -Ag besharp_oop_type_ArrayMap_interfaces
besharp_oop_type_ArrayMap_interfaces['Map']='Map'
besharp_oop_classes["ArrayMap"]="ArrayMap"
besharp_oop_type_parent["ArrayMap"]="AssocArrayContainer"
declare -Ag besharp_oop_type_ArrayMap_fields
declare -Ag besharp_oop_type_ArrayMap_injectable_fields
declare -Ag besharp_oop_type_ArrayMap_field_type
declare -Ag besharp_oop_type_ArrayMap_field_default
declare -Ag besharp_oop_type_ArrayMap_methods
declare -Ag besharp_oop_type_ArrayMap_method_body
declare -Ag besharp_oop_type_ArrayMap_method_locals
declare -Ag besharp_oop_type_ArrayMap_method_is_returning
declare -Ag besharp_oop_type_ArrayMap_method_is_abstract
declare -Ag besharp_oop_type_ArrayMap_method_is_using_iterators
declare -Ag besharp_oop_type_ArrayMap_method_is_calling_parent
declare -Ag besharp_oop_type_ArrayMap_method_is_calling_this
besharp_oop_type_ArrayMap_methods['ArrayMap']='ArrayMap'
besharp_oop_type_ArrayMap_method_is_returning["ArrayMap"]=false
besharp_oop_type_ArrayMap_method_body["ArrayMap"]='    @parent'
besharp_oop_type_ArrayMap_method_locals["ArrayMap"]=''
besharp_oop_type_ArrayMap_method_is_using_iterators["ArrayMap"]=false
besharp_oop_type_ArrayMap_method_is_calling_parent["ArrayMap"]=true
besharp_oop_type_ArrayMap_method_is_calling_this["ArrayMap"]=false
besharp_oop_type_ArrayMap_methods['findAllKeys']='findAllKeys'
besharp_oop_type_ArrayMap_method_is_returning["findAllKeys"]=true
besharp_oop_type_ArrayMap_method_body["findAllKeys"]='    local resultCollection ;
    local item="${1}";
    __be__resultCollection @new ArrayVector;
    besharp_rcrvs[besharp_rcsl]=$resultCollection;
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local key;
    for key in "${!temp[@]}";
    do
        if @same "${temp[$key]}" "${item}"; then
            $resultCollection.add "${key}";
        fi;
    done'
besharp_oop_type_ArrayMap_method_locals["findAllKeys"]='local resultCollection'
besharp_oop_type_ArrayMap_method_is_using_iterators["findAllKeys"]=false
besharp_oop_type_ArrayMap_method_is_calling_parent["findAllKeys"]=false
besharp_oop_type_ArrayMap_method_is_calling_this["findAllKeys"]=true
besharp_oop_type_ArrayMap_methods['hasAllKeys']='hasAllKeys'
besharp_oop_type_ArrayMap_method_is_returning["hasAllKeys"]=true
besharp_oop_type_ArrayMap_method_body["hasAllKeys"]='    local key;
    while @iterate "${@}" @in key; do
        local isset;
        eval "isset=\"\${${this}[${key}]+isset}\"";
        if [[ "${isset}" != '"'"'isset'"'"' ]]; then
            besharp_rcrvs[besharp_rcsl]=false;
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=true'
besharp_oop_type_ArrayMap_method_locals["hasAllKeys"]='local key'
besharp_oop_type_ArrayMap_method_is_using_iterators["hasAllKeys"]=true
besharp_oop_type_ArrayMap_method_is_calling_parent["hasAllKeys"]=false
besharp_oop_type_ArrayMap_method_is_calling_this["hasAllKeys"]=true
besharp_oop_type_ArrayMap_methods['hasKey']='hasKey'
besharp_oop_type_ArrayMap_method_is_returning["hasKey"]=true
besharp_oop_type_ArrayMap_method_body["hasKey"]='    local key="${1}";
    local isset;
    eval "isset=\${${this}[\"${key}\"]+isset}";
    if [[ "${isset}" == '"'"'isset'"'"' ]]; then
        besharp_rcrvs[besharp_rcsl]=true;
    else
        besharp_rcrvs[besharp_rcsl]=false;
    fi'
besharp_oop_type_ArrayMap_method_locals["hasKey"]=''
besharp_oop_type_ArrayMap_method_is_using_iterators["hasKey"]=false
besharp_oop_type_ArrayMap_method_is_calling_parent["hasKey"]=false
besharp_oop_type_ArrayMap_method_is_calling_this["hasKey"]=true
besharp_oop_type_ArrayMap_methods['hasSomeKeys']='hasSomeKeys'
besharp_oop_type_ArrayMap_method_is_returning["hasSomeKeys"]=true
besharp_oop_type_ArrayMap_method_body["hasSomeKeys"]='    local key;
    while @iterate "${@}" @in key; do
        local isset;
        eval "isset=\"\${${this}[${key}]+isset}\"";
        if [[ "${isset}" == '"'"'isset'"'"' ]]; then
            besharp_rcrvs[besharp_rcsl]=true;
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_ArrayMap_method_locals["hasSomeKeys"]='local key'
besharp_oop_type_ArrayMap_method_is_using_iterators["hasSomeKeys"]=true
besharp_oop_type_ArrayMap_method_is_calling_parent["hasSomeKeys"]=false
besharp_oop_type_ArrayMap_method_is_calling_this["hasSomeKeys"]=true
besharp_oop_type_ArrayMap_methods['remove']='remove'
besharp_oop_type_ArrayMap_method_is_returning["remove"]=true
besharp_oop_type_ArrayMap_method_body["remove"]='    local item="${1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local anyRemoved=false;
    local key;
    for key in "${!temp[@]}";
    do
        if @same "${temp[$key]}" "${item}"; then
            $this.removeKey "${key}";
            anyRemoved=true;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=$anyRemoved'
besharp_oop_type_ArrayMap_method_locals["remove"]=''
besharp_oop_type_ArrayMap_method_is_using_iterators["remove"]=false
besharp_oop_type_ArrayMap_method_is_calling_parent["remove"]=false
besharp_oop_type_ArrayMap_method_is_calling_this["remove"]=true
besharp_oop_type_ArrayMap_methods['removeKey']='removeKey'
besharp_oop_type_ArrayMap_method_is_returning["removeKey"]=false
besharp_oop_type_ArrayMap_method_body["removeKey"]='    local key="${1}";
    unset "${this}[${key}]"'
besharp_oop_type_ArrayMap_method_locals["removeKey"]=''
besharp_oop_type_ArrayMap_method_is_using_iterators["removeKey"]=false
besharp_oop_type_ArrayMap_method_is_calling_parent["removeKey"]=false
besharp_oop_type_ArrayMap_method_is_calling_this["removeKey"]=true
besharp_oop_type_ArrayMap_methods['removeKeys']='removeKeys'
besharp_oop_type_ArrayMap_method_is_returning["removeKeys"]=false
besharp_oop_type_ArrayMap_method_body["removeKeys"]='    local item;
    while @iterate "${@}" @in item; do
        $this.removeKey "${item}";
    done'
besharp_oop_type_ArrayMap_method_locals["removeKeys"]='local item'
besharp_oop_type_ArrayMap_method_is_using_iterators["removeKeys"]=true
besharp_oop_type_ArrayMap_method_is_calling_parent["removeKeys"]=false
besharp_oop_type_ArrayMap_method_is_calling_this["removeKeys"]=true
besharp_oop_type_ArrayMap_methods['set']='set'
besharp_oop_type_ArrayMap_method_is_returning["set"]=false
besharp_oop_type_ArrayMap_method_body["set"]='    local key="${1}";
    local item="${2}";
    eval "${this}[\"\${key}\"]=\"\${item}\""'
besharp_oop_type_ArrayMap_method_locals["set"]=''
besharp_oop_type_ArrayMap_method_is_using_iterators["set"]=false
besharp_oop_type_ArrayMap_method_is_calling_parent["set"]=false
besharp_oop_type_ArrayMap_method_is_calling_this["set"]=true
besharp_oop_type_ArrayMap_methods['setPlainPairs']='setPlainPairs'
besharp_oop_type_ArrayMap_method_is_returning["setPlainPairs"]=true
besharp_oop_type_ArrayMap_method_body["setPlainPairs"]='    if (( $# == 0 )); then
        $this.removeAll;
        return;
    fi;
    if (( ( $# % 2 ) != 0 )); then
        besharp.runtime.error "setPlainPars has got an odd number of elements. Expected pairs!";
        return;
    fi;
    local key;
    local item;
    local isEven=true;
    for item in "${@}";
    do
        if $isEven; then
            isEven=false;
            key="${item}";
        else
            isEven=true;
            eval "${this}[\"\${key}\"]=\"\${item}\"";
        fi;
    done'
besharp_oop_type_ArrayMap_method_locals["setPlainPairs"]=''
besharp_oop_type_ArrayMap_method_is_using_iterators["setPlainPairs"]=false
besharp_oop_type_ArrayMap_method_is_calling_parent["setPlainPairs"]=false
besharp_oop_type_ArrayMap_method_is_calling_this["setPlainPairs"]=true
besharp_oop_type_ArrayMap_methods['swapKeys']='swapKeys'
besharp_oop_type_ArrayMap_method_is_returning["swapKeys"]=false
besharp_oop_type_ArrayMap_method_body["swapKeys"]='    $this.swapElements "${@}"'
besharp_oop_type_ArrayMap_method_locals["swapKeys"]=''
besharp_oop_type_ArrayMap_method_is_using_iterators["swapKeys"]=false
besharp_oop_type_ArrayMap_method_is_calling_parent["swapKeys"]=false
besharp_oop_type_ArrayMap_method_is_calling_this["swapKeys"]=true

fi
if ${beshfile_section__code:-false}; then :;
function __be__resultCollection() {
  "${@}"
  resultCollection="${besharp_rcrvs[besharp_rcsl + 1]}"
}
ArrayMap ()
{
    @parent
}
ArrayMap.findAllKeys ()
{
    local resultCollection;
    local item="${1}";
    __be__resultCollection @new ArrayVector;
    besharp_rcrvs[besharp_rcsl]=$resultCollection;
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local key;
    for key in "${!temp[@]}";
    do
        if @same "${temp[$key]}" "${item}"; then
            $resultCollection.add "${key}";
        fi;
    done
}
ArrayMap.hasAllKeys ()
{
    local key;
    while @iterate "${@}" @in key; do
        local isset;
        eval "isset=\"\${${this}[${key}]+isset}\"";
        if [[ "${isset}" != 'isset' ]]; then
            besharp_rcrvs[besharp_rcsl]=false;
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=true
}
ArrayMap.hasKey ()
{
    local key="${1}";
    local isset;
    eval "isset=\${${this}[\"${key}\"]+isset}";
    if [[ "${isset}" == 'isset' ]]; then
        besharp_rcrvs[besharp_rcsl]=true;
    else
        besharp_rcrvs[besharp_rcsl]=false;
    fi
}
ArrayMap.hasSomeKeys ()
{
    local key;
    while @iterate "${@}" @in key; do
        local isset;
        eval "isset=\"\${${this}[${key}]+isset}\"";
        if [[ "${isset}" == 'isset' ]]; then
            besharp_rcrvs[besharp_rcsl]=true;
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=false
}
ArrayMap.remove ()
{
    local item="${1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local anyRemoved=false;
    local key;
    for key in "${!temp[@]}";
    do
        if @same "${temp[$key]}" "${item}"; then
            $this.removeKey "${key}";
            anyRemoved=true;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=$anyRemoved
}
ArrayMap.removeKey ()
{
    local key="${1}";
    unset "${this}[${key}]"
}
ArrayMap.removeKeys ()
{
    local item;
    while @iterate "${@}" @in item; do
        $this.removeKey "${item}";
    done
}
ArrayMap.set ()
{
    local key="${1}";
    local item="${2}";
    eval "${this}[\"\${key}\"]=\"\${item}\""
}
ArrayMap.setPlainPairs ()
{
    if (( $# == 0 )); then
        $this.removeAll;
        return;
    fi;
    if (( ( $# % 2 ) != 0 )); then
        besharp.runtime.error "setPlainPars has got an odd number of elements. Expected pairs!";
        return;
    fi;
    local key;
    local item;
    local isEven=true;
    for item in "${@}";
    do
        if $isEven; then
            isEven=false;
            key="${item}";
        else
            isEven=true;
            eval "${this}[\"\${key}\"]=\"\${item}\"";
        fi;
    done
}
ArrayMap.swapKeys ()
{
    $this.swapElements "${@}"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["ArraySet"]='true'
besharp_oop_type_is["ArraySet"]='class'
besharp_oop_types["ArraySet"]="ArraySet"
declare -Ag besharp_oop_type_ArraySet_interfaces
besharp_oop_type_ArraySet_interfaces['Set']='Set'
besharp_oop_classes["ArraySet"]="ArraySet"
besharp_oop_type_parent["ArraySet"]="AssocArrayCollection"
declare -Ag besharp_oop_type_ArraySet_fields
declare -Ag besharp_oop_type_ArraySet_injectable_fields
declare -Ag besharp_oop_type_ArraySet_field_type
declare -Ag besharp_oop_type_ArraySet_field_default
declare -Ag besharp_oop_type_ArraySet_methods
declare -Ag besharp_oop_type_ArraySet_method_body
declare -Ag besharp_oop_type_ArraySet_method_locals
declare -Ag besharp_oop_type_ArraySet_method_is_returning
declare -Ag besharp_oop_type_ArraySet_method_is_abstract
declare -Ag besharp_oop_type_ArraySet_method_is_using_iterators
declare -Ag besharp_oop_type_ArraySet_method_is_calling_parent
declare -Ag besharp_oop_type_ArraySet_method_is_calling_this
besharp_oop_type_ArraySet_methods['ArraySet']='ArraySet'
besharp_oop_type_ArraySet_method_is_returning["ArraySet"]=false
besharp_oop_type_ArraySet_method_body["ArraySet"]='    @parent'
besharp_oop_type_ArraySet_method_locals["ArraySet"]=''
besharp_oop_type_ArraySet_method_is_using_iterators["ArraySet"]=false
besharp_oop_type_ArraySet_method_is_calling_parent["ArraySet"]=true
besharp_oop_type_ArraySet_method_is_calling_this["ArraySet"]=false
besharp_oop_type_ArraySet_methods['add']='add'
besharp_oop_type_ArraySet_method_is_returning["add"]=false
besharp_oop_type_ArraySet_method_body["add"]='    local objectId ;
    local item="${1}";
    __be__objectId @object-id "${item}";
    eval "${this}[\"\${objectId}\"]=\"\${item}\""'
besharp_oop_type_ArraySet_method_locals["add"]='local objectId'
besharp_oop_type_ArraySet_method_is_using_iterators["add"]=false
besharp_oop_type_ArraySet_method_is_calling_parent["add"]=false
besharp_oop_type_ArraySet_method_is_calling_this["add"]=true
besharp_oop_type_ArraySet_methods['fill']='fill'
besharp_oop_type_ArraySet_method_is_returning["fill"]=false
besharp_oop_type_ArraySet_method_body["fill"]='    local item="${1}";
    $this.removeAll;
    $this.add "${item}"'
besharp_oop_type_ArraySet_method_locals["fill"]=''
besharp_oop_type_ArraySet_method_is_using_iterators["fill"]=false
besharp_oop_type_ArraySet_method_is_calling_parent["fill"]=false
besharp_oop_type_ArraySet_method_is_calling_this["fill"]=true
besharp_oop_type_ArraySet_methods['frequency']='frequency'
besharp_oop_type_ArraySet_method_is_returning["frequency"]=true
besharp_oop_type_ArraySet_method_body["frequency"]='    local item="${1}";
    if @true $this.has "${item}"; then
        besharp_rcrvs[besharp_rcsl]=1;
    else
        besharp_rcrvs[besharp_rcsl]=0;
    fi'
besharp_oop_type_ArraySet_method_locals["frequency"]=''
besharp_oop_type_ArraySet_method_is_using_iterators["frequency"]=false
besharp_oop_type_ArraySet_method_is_calling_parent["frequency"]=false
besharp_oop_type_ArraySet_method_is_calling_this["frequency"]=true
besharp_oop_type_ArraySet_methods['has']='has'
besharp_oop_type_ArraySet_method_is_returning["has"]=true
besharp_oop_type_ArraySet_method_body["has"]='    local objectId ;
    local item="${1}";
    __be__objectId @object-id "${item}";
    local var="${this}[${objectId}]";
    if [[ "${!var+isset}" == "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=true;
    else
        besharp_rcrvs[besharp_rcsl]=false;
    fi'
besharp_oop_type_ArraySet_method_locals["has"]='local objectId'
besharp_oop_type_ArraySet_method_is_using_iterators["has"]=false
besharp_oop_type_ArraySet_method_is_calling_parent["has"]=false
besharp_oop_type_ArraySet_method_is_calling_this["has"]=true
besharp_oop_type_ArraySet_methods['hasKey']='hasKey'
besharp_oop_type_ArraySet_method_is_returning["hasKey"]=true
besharp_oop_type_ArraySet_method_body["hasKey"]='    besharp.returningOf $this.has "${@}"'
besharp_oop_type_ArraySet_method_locals["hasKey"]=''
besharp_oop_type_ArraySet_method_is_using_iterators["hasKey"]=false
besharp_oop_type_ArraySet_method_is_calling_parent["hasKey"]=false
besharp_oop_type_ArraySet_method_is_calling_this["hasKey"]=true
besharp_oop_type_ArraySet_methods['remove']='remove'
besharp_oop_type_ArraySet_method_is_returning["remove"]=false
besharp_oop_type_ArraySet_method_body["remove"]='    local objectId ;
    local item="${1}";
    __be__objectId @object-id "${item}";
    unset "${this}[${objectId}]"'
besharp_oop_type_ArraySet_method_locals["remove"]='local objectId'
besharp_oop_type_ArraySet_method_is_using_iterators["remove"]=false
besharp_oop_type_ArraySet_method_is_calling_parent["remove"]=false
besharp_oop_type_ArraySet_method_is_calling_this["remove"]=true
besharp_oop_type_ArraySet_methods['replace']='replace'
besharp_oop_type_ArraySet_method_is_returning["replace"]=false
besharp_oop_type_ArraySet_method_body["replace"]='    local fromObjId ;
    local fromItem="${1}";
    local toItem="${2}";
    __be__fromObjId @object-id "${fromItem}";
    local var="${this}[${fromObjId}]";
    if [[ "${!var+isset}" == "isset" ]]; then
        unset "${this}[${fromObjId}]";
    fi;
    $this.add "${toItem}"'
besharp_oop_type_ArraySet_method_locals["replace"]='local fromObjId'
besharp_oop_type_ArraySet_method_is_using_iterators["replace"]=false
besharp_oop_type_ArraySet_method_is_calling_parent["replace"]=false
besharp_oop_type_ArraySet_method_is_calling_this["replace"]=true
besharp_oop_type_ArraySet_methods['shuffle']='shuffle'
besharp_oop_type_ArraySet_method_is_returning["shuffle"]=false
besharp_oop_type_ArraySet_method_body["shuffle"]='    :'
besharp_oop_type_ArraySet_method_locals["shuffle"]=''
besharp_oop_type_ArraySet_method_is_using_iterators["shuffle"]=false
besharp_oop_type_ArraySet_method_is_calling_parent["shuffle"]=false
besharp_oop_type_ArraySet_method_is_calling_this["shuffle"]=false

fi
if ${beshfile_section__code:-false}; then :;
function __be__objectId() {
  "${@}"
  objectId="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__objectId() {
  "${@}"
  objectId="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__objectId() {
  "${@}"
  objectId="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__fromObjId() {
  "${@}"
  fromObjId="${besharp_rcrvs[besharp_rcsl + 1]}"
}
ArraySet ()
{
    @parent
}
ArraySet.add ()
{
    local objectId;
    local item="${1}";
    __be__objectId @object-id "${item}";
    eval "${this}[\"\${objectId}\"]=\"\${item}\""
}
ArraySet.fill ()
{
    local item="${1}";
    $this.removeAll;
    $this.add "${item}"
}
ArraySet.frequency ()
{
    local item="${1}";
    if @true $this.has "${item}"; then
        besharp_rcrvs[besharp_rcsl]=1;
    else
        besharp_rcrvs[besharp_rcsl]=0;
    fi
}
ArraySet.has ()
{
    local objectId;
    local item="${1}";
    __be__objectId @object-id "${item}";
    local var="${this}[${objectId}]";
    if [[ "${!var+isset}" == "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=true;
    else
        besharp_rcrvs[besharp_rcsl]=false;
    fi
}
ArraySet.hasKey ()
{
    besharp.returningOf $this.has "${@}"
}
ArraySet.remove ()
{
    local objectId;
    local item="${1}";
    __be__objectId @object-id "${item}";
    unset "${this}[${objectId}]"
}
ArraySet.replace ()
{
    local fromObjId;
    local fromItem="${1}";
    local toItem="${2}";
    __be__fromObjId @object-id "${fromItem}";
    local var="${this}[${fromObjId}]";
    if [[ "${!var+isset}" == "isset" ]]; then
        unset "${this}[${fromObjId}]";
    fi;
    $this.add "${toItem}"
}
ArraySet.shuffle ()
{
    :
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["ArrayVector"]='true'
besharp_oop_type_is["ArrayVector"]='class'
besharp_oop_types["ArrayVector"]="ArrayVector"
declare -Ag besharp_oop_type_ArrayVector_interfaces
besharp_oop_type_ArrayVector_interfaces['Vector']='Vector'
besharp_oop_classes["ArrayVector"]="ArrayVector"
besharp_oop_type_parent["ArrayVector"]="IndexedArrayCollection"
declare -Ag besharp_oop_type_ArrayVector_fields
declare -Ag besharp_oop_type_ArrayVector_injectable_fields
declare -Ag besharp_oop_type_ArrayVector_field_type
declare -Ag besharp_oop_type_ArrayVector_field_default
declare -Ag besharp_oop_type_ArrayVector_methods
declare -Ag besharp_oop_type_ArrayVector_method_body
declare -Ag besharp_oop_type_ArrayVector_method_locals
declare -Ag besharp_oop_type_ArrayVector_method_is_returning
declare -Ag besharp_oop_type_ArrayVector_method_is_abstract
declare -Ag besharp_oop_type_ArrayVector_method_is_using_iterators
declare -Ag besharp_oop_type_ArrayVector_method_is_calling_parent
declare -Ag besharp_oop_type_ArrayVector_method_is_calling_this
besharp_oop_type_ArrayVector_methods['ArrayVector']='ArrayVector'
besharp_oop_type_ArrayVector_method_is_returning["ArrayVector"]=false
besharp_oop_type_ArrayVector_method_body["ArrayVector"]='    local size="${1:-0}";
    local emptyItem="${2:-}";
    @parent;
    if (( size > 0 )); then
        $this.resize "${size}" "${emptyItem}";
    fi'
besharp_oop_type_ArrayVector_method_locals["ArrayVector"]=''
besharp_oop_type_ArrayVector_method_is_using_iterators["ArrayVector"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["ArrayVector"]=true
besharp_oop_type_ArrayVector_method_is_calling_this["ArrayVector"]=true
besharp_oop_type_ArrayVector_methods['__cloneFrom']='__cloneFrom'
besharp_oop_type_ArrayVector_method_is_returning["__cloneFrom"]=true
besharp_oop_type_ArrayVector_method_body["__cloneFrom"]='    local source="${1}";
    local mode="${2}";
    if [[ "${mode}" == "shallow" ]]; then
        $this.declarePrimitiveVariable "${@}";
        eval "${this}=( \"\${${source}[@]}\" )";
        return;
    fi;
    @parent "${source}" "${mode}"'
besharp_oop_type_ArrayVector_method_locals["__cloneFrom"]=''
besharp_oop_type_ArrayVector_method_is_using_iterators["__cloneFrom"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["__cloneFrom"]=true
besharp_oop_type_ArrayVector_method_is_calling_this["__cloneFrom"]=true
besharp_oop_type_ArrayVector_methods['add']='add'
besharp_oop_type_ArrayVector_method_is_returning["add"]=false
besharp_oop_type_ArrayVector_method_body["add"]='    local item="${1}";
    eval "${this}+=(\"\${item}\")"'
besharp_oop_type_ArrayVector_method_locals["add"]=''
besharp_oop_type_ArrayVector_method_is_using_iterators["add"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["add"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["add"]=true
besharp_oop_type_ArrayVector_methods['call']='call'
besharp_oop_type_ArrayVector_method_is_returning["call"]=true
besharp_oop_type_ArrayVector_method_body["call"]='    eval "besharp.returningOf \"\${@}\" \"\${${this}[@]}\" "'
besharp_oop_type_ArrayVector_method_locals["call"]=''
besharp_oop_type_ArrayVector_method_is_using_iterators["call"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["call"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["call"]=true
besharp_oop_type_ArrayVector_methods['findIndex']='findIndex'
besharp_oop_type_ArrayVector_method_is_returning["findIndex"]=true
besharp_oop_type_ArrayVector_method_body["findIndex"]='    local size ;
    local item="${1}";
    local minIndex="${2:-0}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    __be__size $this.size;
    if (( minIndex < 0 )); then
        minIndex=0;
    fi;
    local idx;
    for ((idx=minIndex; idx < size; ++idx ))
    do
        local lookupItem;
        eval "lookupItem=\"\${${this}[${idx}]}\"";
        if @same "${lookupItem}" "${item}"; then
            besharp_rcrvs[besharp_rcsl]="${idx}";
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=-1'
besharp_oop_type_ArrayVector_method_locals["findIndex"]='local size'
besharp_oop_type_ArrayVector_method_is_using_iterators["findIndex"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["findIndex"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["findIndex"]=true
besharp_oop_type_ArrayVector_methods['findIndices']='findIndices'
besharp_oop_type_ArrayVector_method_is_returning["findIndices"]=true
besharp_oop_type_ArrayVector_method_body["findIndices"]='    local resultCollection size ;
    local item="${1}";
    __be__resultCollection @new ArrayVector;
    besharp_rcrvs[besharp_rcsl]=$resultCollection;
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        return;
    fi;
    __be__size $this.size;
    local idx;
    for ((idx=0; idx < size; ++idx ))
    do
        local lookupItem;
        eval "lookupItem=\"\${${this}[${idx}]}\"";
        if @same "${lookupItem}" "${item}"; then
            $resultCollection.add "${idx}";
        fi;
    done'
besharp_oop_type_ArrayVector_method_locals["findIndices"]='local resultCollection
local size'
besharp_oop_type_ArrayVector_method_is_using_iterators["findIndices"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["findIndices"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["findIndices"]=true
besharp_oop_type_ArrayVector_methods['findLastIndex']='findLastIndex'
besharp_oop_type_ArrayVector_method_is_returning["findLastIndex"]=true
besharp_oop_type_ArrayVector_method_body["findLastIndex"]='    local size ;
    local item="${1}";
    local maxIndex="${2:-}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    __be__size $this.size;
    if [[ "${maxIndex}" == '"'"''"'"' ]] || (( maxIndex >= size )); then
        maxIndex=${size};
    fi;
    local idx;
    for ((idx=maxIndex-1; idx >= 0; --idx ))
    do
        local lookupItem;
        eval "lookupItem=\"\${${this}[${idx}]}\"";
        if @same "${lookupItem}" "${item}"; then
            besharp_rcrvs[besharp_rcsl]="${idx}";
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=-1'
besharp_oop_type_ArrayVector_method_locals["findLastIndex"]='local size'
besharp_oop_type_ArrayVector_method_is_using_iterators["findLastIndex"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["findLastIndex"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["findLastIndex"]=true
besharp_oop_type_ArrayVector_methods['get']='get'
besharp_oop_type_ArrayVector_method_is_returning["get"]=true
besharp_oop_type_ArrayVector_method_body["get"]='    local index="${1}";
    if ! @true $this.hasIndex "${index}"; then
        local size=$( @echo $this.size );
        besharp.runtime.error "Cannot get! ArrayVector index out of range: ${index}. Allowed range: 0 - $(( size - 1))";
    fi;
    local item;
    eval "item=\"\${${this}[${index}]}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"'
besharp_oop_type_ArrayVector_method_locals["get"]=''
besharp_oop_type_ArrayVector_method_is_using_iterators["get"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["get"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["get"]=true
besharp_oop_type_ArrayVector_methods['insertAt']='insertAt'
besharp_oop_type_ArrayVector_method_is_returning["insertAt"]=true
besharp_oop_type_ArrayVector_method_body["insertAt"]='    local size ;
    local index="${1}";
    local item="${2}";
    __be__size $this.size;
    if (( index == size )); then
        eval "${this}[size]=\${item}";
        return;
    fi;
    if ! @true $this.hasIndex "${index}"; then
        besharp.runtime.error "Cannot insertAt! ArrayVector index out of range: ${index}. Allowed range: 0 - ${size}";
        return 1;
    fi;
    local idx;
    for ((idx=size; idx >= index; --idx))
    do
        eval "${this}[idx]=\${${this}[idx - 1]}";
    done;
    eval "${this}[index]=\${item}"'
besharp_oop_type_ArrayVector_method_locals["insertAt"]='local size'
besharp_oop_type_ArrayVector_method_is_using_iterators["insertAt"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["insertAt"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["insertAt"]=true
besharp_oop_type_ArrayVector_methods['insertAtManyIndices']='insertAtManyIndices'
besharp_oop_type_ArrayVector_method_is_returning["insertAtManyIndices"]=true
besharp_oop_type_ArrayVector_method_body["insertAtManyIndices"]='    local size ;
    local item="${1}";
    shift 1;
    local index;
    local indices=();
    while @iterate "${@}" @in index; do
        if ! @true $this.hasIndex "${index}"; then
            __be__size $this.size;
            besharp.runtime.error "Cannot insertAtManyIndices! ArrayVector index out of range: ${index}. Allowed range: 0 - ${size}";
            return 1;
        fi;
        indices[${index}]=dummy;
    done;
    local ordered;
    declare -n ordered="indices";
    local idx;
    local x=0;
    for idx in "${!ordered[@]}";
    do
        $this.insertAt $(( idx + x )) "${item}";
        (( ++x ));
    done'
besharp_oop_type_ArrayVector_method_locals["insertAtManyIndices"]='local index
local size'
besharp_oop_type_ArrayVector_method_is_using_iterators["insertAtManyIndices"]=true
besharp_oop_type_ArrayVector_method_is_calling_parent["insertAtManyIndices"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["insertAtManyIndices"]=true
besharp_oop_type_ArrayVector_methods['insertManyAt']='insertManyAt'
besharp_oop_type_ArrayVector_method_is_returning["insertManyAt"]=false
besharp_oop_type_ArrayVector_method_body["insertManyAt"]='    local index="${1}";
    shift 1;
    local item;
    local x=0;
    while @iterate "${@}" @in item; do
        $this.insertAt $(( index + x )) "${item}";
        (( ++x ));
    done'
besharp_oop_type_ArrayVector_method_locals["insertManyAt"]='local item'
besharp_oop_type_ArrayVector_method_is_using_iterators["insertManyAt"]=true
besharp_oop_type_ArrayVector_method_is_calling_parent["insertManyAt"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["insertManyAt"]=true
besharp_oop_type_ArrayVector_methods['iterationNew']='iterationNew'
besharp_oop_type_ArrayVector_method_is_returning["iterationNew"]=true
besharp_oop_type_ArrayVector_method_body["iterationNew"]='    local size ;
    __be__size $this.size;
    if (( size == 0 )); then
        besharp_rcrvs[besharp_rcsl]="";
        return;
    fi;
    besharp_rcrvs[besharp_rcsl]=0'
besharp_oop_type_ArrayVector_method_locals["iterationNew"]='local size'
besharp_oop_type_ArrayVector_method_is_using_iterators["iterationNew"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["iterationNew"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["iterationNew"]=true
besharp_oop_type_ArrayVector_methods['iterationNext']='iterationNext'
besharp_oop_type_ArrayVector_method_is_returning["iterationNext"]=true
besharp_oop_type_ArrayVector_method_body["iterationNext"]='    local size ;
    local index="${1}";
    __be__size $this.size;
    if (( ++index < size )); then
        besharp_rcrvs[besharp_rcsl]="${index}";
    else
        besharp_rcrvs[besharp_rcsl]="";
    fi'
besharp_oop_type_ArrayVector_method_locals["iterationNext"]='local size'
besharp_oop_type_ArrayVector_method_is_using_iterators["iterationNext"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["iterationNext"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["iterationNext"]=true
besharp_oop_type_ArrayVector_methods['iterationValue']='iterationValue'
besharp_oop_type_ArrayVector_method_is_returning["iterationValue"]=true
besharp_oop_type_ArrayVector_method_body["iterationValue"]='    local index="${1}";
    local item;
    eval "item=\"\${${this}[${index}]}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"'
besharp_oop_type_ArrayVector_method_locals["iterationValue"]=''
besharp_oop_type_ArrayVector_method_is_using_iterators["iterationValue"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["iterationValue"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["iterationValue"]=true
besharp_oop_type_ArrayVector_methods['remove']='remove'
besharp_oop_type_ArrayVector_method_is_returning["remove"]=true
besharp_oop_type_ArrayVector_method_body["remove"]='    local idx ;
    local item="${1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    __be__idx $this.findIndex "${item}";
    if (( idx < 0 )); then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    $this.removeIndex "${idx}";
    besharp_rcrvs[besharp_rcsl]=true'
besharp_oop_type_ArrayVector_method_locals["remove"]='local idx'
besharp_oop_type_ArrayVector_method_is_using_iterators["remove"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["remove"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["remove"]=true
besharp_oop_type_ArrayVector_methods['removeIndex']='removeIndex'
besharp_oop_type_ArrayVector_method_is_returning["removeIndex"]=true
besharp_oop_type_ArrayVector_method_body["removeIndex"]='    local size ;
    local index="${1}";
    __be__size $this.size;
    if ! @true $this.hasIndex "${index}"; then
        besharp.runtime.error "Cannot get! ArrayVector index out of range: ${index}. Allowed range: 0 - $(( size - 1))";
        return 1;
    fi;
    local idx;
    for ((idx=index; idx < size - 1; ++idx))
    do
        eval "${this}[idx]=\${${this}[idx + 1]}";
    done;
    unset "${this}[-1]"'
besharp_oop_type_ArrayVector_method_locals["removeIndex"]='local size'
besharp_oop_type_ArrayVector_method_is_using_iterators["removeIndex"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["removeIndex"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["removeIndex"]=true
besharp_oop_type_ArrayVector_methods['removeIndices']='removeIndices'
besharp_oop_type_ArrayVector_method_is_returning["removeIndices"]=true
besharp_oop_type_ArrayVector_method_body["removeIndices"]='    local size ;
    local index;
    local indices=();
    while @iterate "${@}" @in index; do
        if ! @true $this.hasIndex "${index}"; then
            __be__size $this.size;
            besharp.runtime.error "Cannot get! ArrayVector index out of range: ${index}. Allowed range: 0 - $(( size - 1))";
            return 1;
        fi;
        indices[${index}]=dummy;
    done;
    local ordered;
    declare -n ordered="indices";
    local idx;
    local x=0;
    for idx in "${!ordered[@]}";
    do
        $this.removeIndex $(( idx - x ));
        (( ++x ));
    done'
besharp_oop_type_ArrayVector_method_locals["removeIndices"]='local index
local size'
besharp_oop_type_ArrayVector_method_is_using_iterators["removeIndices"]=true
besharp_oop_type_ArrayVector_method_is_calling_parent["removeIndices"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["removeIndices"]=true
besharp_oop_type_ArrayVector_methods['resize']='resize'
besharp_oop_type_ArrayVector_method_is_returning["resize"]=false
besharp_oop_type_ArrayVector_method_body["resize"]='    local currentSize ;
    local targetSize="${1}";
    local emptyItem="${2:-}";
    if (( targetSize < 0 )); then
        besharp.runtime.error "Negative ArrayVector size?";
    fi;
    __be__currentSize $this.size;
    if (( targetSize >= currentSize )); then
        local i;
        for ((i=currentSize; i < targetSize; ++i ))
        do
            eval "${this}[${i}]=\"\${emptyItem}\"";
        done;
    else
        local i;
        for ((i=targetSize; i < currentSize; ++i ))
        do
            unset "${this}[${i}]";
        done;
    fi'
besharp_oop_type_ArrayVector_method_locals["resize"]='local currentSize'
besharp_oop_type_ArrayVector_method_is_using_iterators["resize"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["resize"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["resize"]=true
besharp_oop_type_ArrayVector_methods['reverse']='reverse'
besharp_oop_type_ArrayVector_method_is_returning["reverse"]=true
besharp_oop_type_ArrayVector_method_body["reverse"]='    local size ;
    __be__size $this.size;
    if (( size < 2 )); then
        return;
    fi;
    local idx1;
    local idx2;
    local tmpValue;
    for ((idx1=0; idx1 < size; ++idx1))
    do
        idx2=$(( size - 1 - idx1 ));
        if (( idx1 >= idx2 )); then
            break;
        fi;
        eval "tmpValue=\"\${${this}[idx1]}\"";
        eval "${this}[idx1]=\"\${${this}[idx2]}\"";
        eval "${this}[idx2]=\"\${tmpValue}\"";
    done'
besharp_oop_type_ArrayVector_method_locals["reverse"]='local size'
besharp_oop_type_ArrayVector_method_is_using_iterators["reverse"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["reverse"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["reverse"]=true
besharp_oop_type_ArrayVector_methods['rotate']='rotate'
besharp_oop_type_ArrayVector_method_is_returning["rotate"]=true
besharp_oop_type_ArrayVector_method_body["rotate"]='    local size ;
    local distance="${1}";
    __be__size $this.size;
    distance=$(( distance % size ));
    if (( distance < 0 )); then
        (( distance += size ));
    fi;
    if (( distance == 0 )) || (( size < 2 )); then
        return;
    fi;
    local values=();
    local position=0;
    local temp;
    declare -n temp="${this}";
    local idx;
    for ((idx=0; idx < size; ++idx ))
    do
        eval "local value=\${${this}[\${idx}]}";
        if (( ++position <= distance )); then
            values+=("${value}");
        else
            eval "${this}[position - distance - 1]=\${${this}[${idx}]}";
        fi;
    done;
    local i;
    for ((i=0; i < distance; ++i ))
    do
        eval "${this}[size - distance + i]=\${values[${i}]}";
    done'
besharp_oop_type_ArrayVector_method_locals["rotate"]='local size'
besharp_oop_type_ArrayVector_method_is_using_iterators["rotate"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["rotate"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["rotate"]=true
besharp_oop_type_ArrayVector_methods['set']='set'
besharp_oop_type_ArrayVector_method_is_returning["set"]=true
besharp_oop_type_ArrayVector_method_body["set"]='    local index="${1}";
    local item="${2}";
    if ! @true $this.hasIndex "${index}"; then
        local size=$( @echo $this.size );
        besharp.runtime.error "Cannot set! ArrayVector index out of range: ${index}. Allowed range: 0 - $(( size - 1))";
    fi;
    eval "${this}[${index}]=\"\${item}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"'
besharp_oop_type_ArrayVector_method_locals["set"]=''
besharp_oop_type_ArrayVector_method_is_using_iterators["set"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["set"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["set"]=true
besharp_oop_type_ArrayVector_methods['setPlain']='setPlain'
besharp_oop_type_ArrayVector_method_is_returning["setPlain"]=false
besharp_oop_type_ArrayVector_method_body["setPlain"]='    eval "${this}=(\"\${@}\")"'
besharp_oop_type_ArrayVector_method_locals["setPlain"]=''
besharp_oop_type_ArrayVector_method_is_using_iterators["setPlain"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["setPlain"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["setPlain"]=true
besharp_oop_type_ArrayVector_methods['shuffle']='shuffle'
besharp_oop_type_ArrayVector_method_is_returning["shuffle"]=true
besharp_oop_type_ArrayVector_method_body["shuffle"]='    local size ;
    __be__size $this.size;
    if (( size < 2 )); then
        return;
    fi;
    local idx1;
    local idx2;
    local tmpValue;
    for ((idx1 = 0; idx1 < size; ++idx1 ))
    do
        idx2=$(( RANDOM % size ));
        if (( idx1 == idx2 )); then
            continue;
        fi;
        eval "tmpValue=\"\${${this}[idx1]}\"";
        eval "${this}[idx1]=\"\${${this}[idx2]}\"";
        eval "${this}[idx2]=\"\${tmpValue}\"";
    done'
besharp_oop_type_ArrayVector_method_locals["shuffle"]='local size'
besharp_oop_type_ArrayVector_method_is_using_iterators["shuffle"]=false
besharp_oop_type_ArrayVector_method_is_calling_parent["shuffle"]=false
besharp_oop_type_ArrayVector_method_is_calling_this["shuffle"]=true

fi
if ${beshfile_section__code:-false}; then :;
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__resultCollection() {
  "${@}"
  resultCollection="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__idx() {
  "${@}"
  idx="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__currentSize() {
  "${@}"
  currentSize="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
ArrayVector ()
{
    local size="${1:-0}";
    local emptyItem="${2:-}";
    @parent;
    if (( size > 0 )); then
        $this.resize "${size}" "${emptyItem}";
    fi
}
ArrayVector.__cloneFrom ()
{
    local source="${1}";
    local mode="${2}";
    if [[ "${mode}" == "shallow" ]]; then
        $this.declarePrimitiveVariable "${@}";
        eval "${this}=( \"\${${source}[@]}\" )";
        return;
    fi;
    @parent "${source}" "${mode}"
}
ArrayVector.add ()
{
    local item="${1}";
    eval "${this}+=(\"\${item}\")"
}
ArrayVector.call ()
{
    eval "besharp.returningOf \"\${@}\" \"\${${this}[@]}\" "
}
ArrayVector.findIndex ()
{
    local size;
    local item="${1}";
    local minIndex="${2:-0}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    __be__size $this.size;
    if (( minIndex < 0 )); then
        minIndex=0;
    fi;
    local idx;
    for ((idx=minIndex; idx < size; ++idx ))
    do
        local lookupItem;
        eval "lookupItem=\"\${${this}[${idx}]}\"";
        if @same "${lookupItem}" "${item}"; then
            besharp_rcrvs[besharp_rcsl]="${idx}";
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=-1
}
ArrayVector.findIndices ()
{
    local resultCollection size;
    local item="${1}";
    __be__resultCollection @new ArrayVector;
    besharp_rcrvs[besharp_rcsl]=$resultCollection;
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        return;
    fi;
    __be__size $this.size;
    local idx;
    for ((idx=0; idx < size; ++idx ))
    do
        local lookupItem;
        eval "lookupItem=\"\${${this}[${idx}]}\"";
        if @same "${lookupItem}" "${item}"; then
            $resultCollection.add "${idx}";
        fi;
    done
}
ArrayVector.findLastIndex ()
{
    local size;
    local item="${1}";
    local maxIndex="${2:-}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    __be__size $this.size;
    if [[ "${maxIndex}" == '' ]] || (( maxIndex >= size )); then
        maxIndex=${size};
    fi;
    local idx;
    for ((idx=maxIndex-1; idx >= 0; --idx ))
    do
        local lookupItem;
        eval "lookupItem=\"\${${this}[${idx}]}\"";
        if @same "${lookupItem}" "${item}"; then
            besharp_rcrvs[besharp_rcsl]="${idx}";
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=-1
}
ArrayVector.get ()
{
    local index="${1}";
    if ! @true $this.hasIndex "${index}"; then
        local size=$( @echo $this.size );
        besharp.runtime.error "Cannot get! ArrayVector index out of range: ${index}. Allowed range: 0 - $(( size - 1))";
    fi;
    local item;
    eval "item=\"\${${this}[${index}]}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"
}
ArrayVector.insertAt ()
{
    local size;
    local index="${1}";
    local item="${2}";
    __be__size $this.size;
    if (( index == size )); then
        eval "${this}[size]=\${item}";
        return;
    fi;
    if ! @true $this.hasIndex "${index}"; then
        besharp.runtime.error "Cannot insertAt! ArrayVector index out of range: ${index}. Allowed range: 0 - ${size}";
        return 1;
    fi;
    local idx;
    for ((idx=size; idx >= index; --idx))
    do
        eval "${this}[idx]=\${${this}[idx - 1]}";
    done;
    eval "${this}[index]=\${item}"
}
ArrayVector.insertAtManyIndices ()
{
    local size;
    local item="${1}";
    shift 1;
    local index;
    local indices=();
    while @iterate "${@}" @in index; do
        if ! @true $this.hasIndex "${index}"; then
            __be__size $this.size;
            besharp.runtime.error "Cannot insertAtManyIndices! ArrayVector index out of range: ${index}. Allowed range: 0 - ${size}";
            return 1;
        fi;
        indices[${index}]=dummy;
    done;
    local ordered;
    declare -n ordered="indices";
    local idx;
    local x=0;
    for idx in "${!ordered[@]}";
    do
        $this.insertAt $(( idx + x )) "${item}";
        (( ++x ));
    done
}
ArrayVector.insertManyAt ()
{
    local index="${1}";
    shift 1;
    local item;
    local x=0;
    while @iterate "${@}" @in item; do
        $this.insertAt $(( index + x )) "${item}";
        (( ++x ));
    done
}
ArrayVector.iterationNew ()
{
    local size;
    __be__size $this.size;
    if (( size == 0 )); then
        besharp_rcrvs[besharp_rcsl]="";
        return;
    fi;
    besharp_rcrvs[besharp_rcsl]=0
}
ArrayVector.iterationNext ()
{
    local size;
    local index="${1}";
    __be__size $this.size;
    if (( ++index < size )); then
        besharp_rcrvs[besharp_rcsl]="${index}";
    else
        besharp_rcrvs[besharp_rcsl]="";
    fi
}
ArrayVector.iterationValue ()
{
    local index="${1}";
    local item;
    eval "item=\"\${${this}[${index}]}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"
}
ArrayVector.remove ()
{
    local idx;
    local item="${1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    __be__idx $this.findIndex "${item}";
    if (( idx < 0 )); then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    $this.removeIndex "${idx}";
    besharp_rcrvs[besharp_rcsl]=true
}
ArrayVector.removeIndex ()
{
    local size;
    local index="${1}";
    __be__size $this.size;
    if ! @true $this.hasIndex "${index}"; then
        besharp.runtime.error "Cannot get! ArrayVector index out of range: ${index}. Allowed range: 0 - $(( size - 1))";
        return 1;
    fi;
    local idx;
    for ((idx=index; idx < size - 1; ++idx))
    do
        eval "${this}[idx]=\${${this}[idx + 1]}";
    done;
    unset "${this}[-1]"
}
ArrayVector.removeIndices ()
{
    local size;
    local index;
    local indices=();
    while @iterate "${@}" @in index; do
        if ! @true $this.hasIndex "${index}"; then
            __be__size $this.size;
            besharp.runtime.error "Cannot get! ArrayVector index out of range: ${index}. Allowed range: 0 - $(( size - 1))";
            return 1;
        fi;
        indices[${index}]=dummy;
    done;
    local ordered;
    declare -n ordered="indices";
    local idx;
    local x=0;
    for idx in "${!ordered[@]}";
    do
        $this.removeIndex $(( idx - x ));
        (( ++x ));
    done
}
ArrayVector.resize ()
{
    local currentSize;
    local targetSize="${1}";
    local emptyItem="${2:-}";
    if (( targetSize < 0 )); then
        besharp.runtime.error "Negative ArrayVector size?";
    fi;
    __be__currentSize $this.size;
    if (( targetSize >= currentSize )); then
        local i;
        for ((i=currentSize; i < targetSize; ++i ))
        do
            eval "${this}[${i}]=\"\${emptyItem}\"";
        done;
    else
        local i;
        for ((i=targetSize; i < currentSize; ++i ))
        do
            unset "${this}[${i}]";
        done;
    fi
}
ArrayVector.reverse ()
{
    local size;
    __be__size $this.size;
    if (( size < 2 )); then
        return;
    fi;
    local idx1;
    local idx2;
    local tmpValue;
    for ((idx1=0; idx1 < size; ++idx1))
    do
        idx2=$(( size - 1 - idx1 ));
        if (( idx1 >= idx2 )); then
            break;
        fi;
        eval "tmpValue=\"\${${this}[idx1]}\"";
        eval "${this}[idx1]=\"\${${this}[idx2]}\"";
        eval "${this}[idx2]=\"\${tmpValue}\"";
    done
}
ArrayVector.rotate ()
{
    local size;
    local distance="${1}";
    __be__size $this.size;
    distance=$(( distance % size ));
    if (( distance < 0 )); then
        (( distance += size ));
    fi;
    if (( distance == 0 )) || (( size < 2 )); then
        return;
    fi;
    local values=();
    local position=0;
    local temp;
    declare -n temp="${this}";
    local idx;
    for ((idx=0; idx < size; ++idx ))
    do
        eval "local value=\${${this}[\${idx}]}";
        if (( ++position <= distance )); then
            values+=("${value}");
        else
            eval "${this}[position - distance - 1]=\${${this}[${idx}]}";
        fi;
    done;
    local i;
    for ((i=0; i < distance; ++i ))
    do
        eval "${this}[size - distance + i]=\${values[${i}]}";
    done
}
ArrayVector.set ()
{
    local index="${1}";
    local item="${2}";
    if ! @true $this.hasIndex "${index}"; then
        local size=$( @echo $this.size );
        besharp.runtime.error "Cannot set! ArrayVector index out of range: ${index}. Allowed range: 0 - $(( size - 1))";
    fi;
    eval "${this}[${index}]=\"\${item}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"
}
ArrayVector.setPlain ()
{
    eval "${this}=(\"\${@}\")"
}
ArrayVector.shuffle ()
{
    local size;
    __be__size $this.size;
    if (( size < 2 )); then
        return;
    fi;
    local idx1;
    local idx2;
    local tmpValue;
    for ((idx1 = 0; idx1 < size; ++idx1 ))
    do
        idx2=$(( RANDOM % size ));
        if (( idx1 == idx2 )); then
            continue;
        fi;
        eval "tmpValue=\"\${${this}[idx1]}\"";
        eval "${this}[idx1]=\"\${${this}[idx2]}\"";
        eval "${this}[idx2]=\"\${tmpValue}\"";
    done
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["PairingHeap"]='true'
besharp_oop_type_is["PairingHeap"]='class'
besharp_oop_types["PairingHeap"]="PairingHeap"
declare -Ag besharp_oop_type_PairingHeap_interfaces
besharp_oop_type_PairingHeap_interfaces['PriorityQueue']='PriorityQueue'
besharp_oop_classes["PairingHeap"]="PairingHeap"
besharp_oop_type_parent["PairingHeap"]="PrimitiveObject"
declare -Ag besharp_oop_type_PairingHeap_fields
declare -Ag besharp_oop_type_PairingHeap_injectable_fields
declare -Ag besharp_oop_type_PairingHeap_field_type
declare -Ag besharp_oop_type_PairingHeap_field_default
declare -Ag besharp_oop_type_PairingHeap_methods
declare -Ag besharp_oop_type_PairingHeap_method_body
declare -Ag besharp_oop_type_PairingHeap_method_locals
declare -Ag besharp_oop_type_PairingHeap_method_is_returning
declare -Ag besharp_oop_type_PairingHeap_method_is_abstract
declare -Ag besharp_oop_type_PairingHeap_method_is_using_iterators
declare -Ag besharp_oop_type_PairingHeap_method_is_calling_parent
declare -Ag besharp_oop_type_PairingHeap_method_is_calling_this
besharp_oop_type_PairingHeap_fields['rootHeap']='rootHeap'
besharp_oop_type_PairingHeap_field_default['rootHeap']=""
besharp_oop_type_PairingHeap_fields['maxNodeIndex']='maxNodeIndex'
besharp_oop_type_PairingHeap_field_default['maxNodeIndex']="0"
besharp_oop_type_PairingHeap_fields['comparatorCallback']='comparatorCallback'
besharp_oop_type_PairingHeap_field_default['comparatorCallback']=""
besharp_oop_type_PairingHeap_fields['reversed']='reversed'
besharp_oop_type_PairingHeap_field_default['reversed']=""
besharp_oop_type_PairingHeap_methods['PairingHeap']='PairingHeap'
besharp_oop_type_PairingHeap_method_is_returning["PairingHeap"]=true
besharp_oop_type_PairingHeap_method_body["PairingHeap"]='    @parent;
    local comparatorOrReverseFlag="${1:-min}";
    case "${comparatorOrReverseFlag}" in
        "min")
            $this.reversed = false
        ;;
        "false")
            $this.reversed = false
        ;;
        "max")
            $this.reversed = true
        ;;
        "true")
            $this.reversed = true
        ;;
        *)
            if @is "${comparatorOrReverseFlag}" FastComparator; then
                __be___this_comparatorCallback $comparator.fastCompareFunction;
                return;
            else
                if @is "${comparatorOrReverseFlag}" Comparator; then
                    $this.comparatorCallback = $comparator.compare;
                    return;
                fi;
            fi;
            besharp.runtime.error "Unknown comparatorOrReverseFlag: ${comparatorOrReverseFlag}"
        ;;
    esac'
besharp_oop_type_PairingHeap_method_locals["PairingHeap"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["PairingHeap"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["PairingHeap"]=true
besharp_oop_type_PairingHeap_method_is_calling_this["PairingHeap"]=true
besharp_oop_type_PairingHeap_methods['add']='add'
besharp_oop_type_PairingHeap_method_is_returning["add"]=false
besharp_oop_type_PairingHeap_method_body["add"]='    local comparator newHeap reversed ;
    local element="${1}";
    if [[ "${2+isset}" == '"'"'isset'"'"' ]]; then
        local value="${2}";
    else
        local value="${element}";
    fi;
    if [[ "${element// /}" != "${element}" ]]; then
        besharp.runtime.error "Invalid element: '"'"'${element}'"'"' PairingHeap elements cannot have spaces. Please provide either an Comparable object or string with no spaces!";
    fi;
    local comparatorVar="${this}_comparatorCallback";
    if [[ -z "${!comparatorVar}" ]]; then
        __be__reversed $this.reversed;
        if [[ "${value}" =~ ^-?[0-9]+$ ]]; then
            __be__comparator @comparators.makeForNaturalOrderIntegers "${reversed}";
        else
            if @is "${value}" Comparable; then
                __be__comparator @comparators.makeForNaturalOrder "${reversed}";
            else
                besharp.runtime.error "Invalid value: '"'"'${value}'"'"'. PairingHeap values can only work with integer numbers and Comparable objects";
            fi;
        fi;
        __be___this_comparatorCallback $comparator.fastCompareFunction;
        @unset $comparator;
    fi;
    __be__newHeap $this.createEmptyHeapNode "${element}" "${value}";
    local rootHeapVar="${this}_rootHeap";
    eval "@let ${this}_rootHeap = $this.merge \"${!rootHeapVar:-}\" \"${newHeap}\""'
besharp_oop_type_PairingHeap_method_locals["add"]='local comparator
local newHeap
local reversed'
besharp_oop_type_PairingHeap_method_is_using_iterators["add"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["add"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["add"]=true
besharp_oop_type_PairingHeap_methods['addMany']='addMany'
besharp_oop_type_PairingHeap_method_is_returning["addMany"]=false
besharp_oop_type_PairingHeap_method_body["addMany"]='    :'
besharp_oop_type_PairingHeap_method_locals["addMany"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["addMany"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["addMany"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["addMany"]=false
besharp_oop_type_PairingHeap_methods['createEmptyHeapNode']='createEmptyHeapNode'
besharp_oop_type_PairingHeap_method_is_returning["createEmptyHeapNode"]=true
besharp_oop_type_PairingHeap_method_body["createEmptyHeapNode"]='    local index ;
    local element="${1}";
    local value="${2}";
    __be__index $this.maxNodeIndex;
    (( ++index ));
    $this.maxNodeIndex = ${index};
    eval "${this}_element[${index}]=\"\${element}\"";
    eval "${this}_value[${index}]=\"\${value}\"";
    eval "${this}_left_child[${index}]=";
    eval "${this}_next_sibling[${index}]=";
    besharp_rcrvs[besharp_rcsl]="${index}"'
besharp_oop_type_PairingHeap_method_locals["createEmptyHeapNode"]='local index'
besharp_oop_type_PairingHeap_method_is_using_iterators["createEmptyHeapNode"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["createEmptyHeapNode"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["createEmptyHeapNode"]=true
besharp_oop_type_PairingHeap_methods['current']='current'
besharp_oop_type_PairingHeap_method_is_returning["current"]=false
besharp_oop_type_PairingHeap_method_body["current"]='    :'
besharp_oop_type_PairingHeap_method_locals["current"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["current"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["current"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["current"]=false
besharp_oop_type_PairingHeap_methods['declarePrimitiveVariable']='declarePrimitiveVariable'
besharp_oop_type_PairingHeap_method_is_returning["declarePrimitiveVariable"]=false
besharp_oop_type_PairingHeap_method_body["declarePrimitiveVariable"]='    declare -a "${this}_element";
    declare -a "${this}_value";
    declare -a "${this}_left_child";
    declare -a "${this}_next_sibling"'
besharp_oop_type_PairingHeap_method_locals["declarePrimitiveVariable"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["declarePrimitiveVariable"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["declarePrimitiveVariable"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["declarePrimitiveVariable"]=true
besharp_oop_type_PairingHeap_methods['destroyHeapNode']='destroyHeapNode'
besharp_oop_type_PairingHeap_method_is_returning["destroyHeapNode"]=false
besharp_oop_type_PairingHeap_method_body["destroyHeapNode"]='    local heap="${1}";
    unset "${this}_element[${heap}]";
    unset "${this}_value[${heap}]";
    unset "${this}_left_child[${heap}]";
    unset "${this}_next_sibling[${heap}]"'
besharp_oop_type_PairingHeap_method_locals["destroyHeapNode"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["destroyHeapNode"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["destroyHeapNode"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["destroyHeapNode"]=true
besharp_oop_type_PairingHeap_methods['destroyPrimitiveVariable']='destroyPrimitiveVariable'
besharp_oop_type_PairingHeap_method_is_returning["destroyPrimitiveVariable"]=false
besharp_oop_type_PairingHeap_method_body["destroyPrimitiveVariable"]='    unset "${this}_element";
    unset "${this}_value";
    unset "${this}_left_child";
    unset "${this}_next_sibling"'
besharp_oop_type_PairingHeap_method_locals["destroyPrimitiveVariable"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["destroyPrimitiveVariable"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["destroyPrimitiveVariable"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["destroyPrimitiveVariable"]=true
besharp_oop_type_PairingHeap_methods['fill']='fill'
besharp_oop_type_PairingHeap_method_is_returning["fill"]=false
besharp_oop_type_PairingHeap_method_body["fill"]='    :'
besharp_oop_type_PairingHeap_method_locals["fill"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["fill"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["fill"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["fill"]=false
besharp_oop_type_PairingHeap_methods['frequency']='frequency'
besharp_oop_type_PairingHeap_method_is_returning["frequency"]=false
besharp_oop_type_PairingHeap_method_body["frequency"]='    :'
besharp_oop_type_PairingHeap_method_locals["frequency"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["frequency"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["frequency"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["frequency"]=false
besharp_oop_type_PairingHeap_methods['has']='has'
besharp_oop_type_PairingHeap_method_is_returning["has"]=false
besharp_oop_type_PairingHeap_method_body["has"]='    :'
besharp_oop_type_PairingHeap_method_locals["has"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["has"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["has"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["has"]=false
besharp_oop_type_PairingHeap_methods['hasAll']='hasAll'
besharp_oop_type_PairingHeap_method_is_returning["hasAll"]=false
besharp_oop_type_PairingHeap_method_body["hasAll"]='    :'
besharp_oop_type_PairingHeap_method_locals["hasAll"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["hasAll"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["hasAll"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["hasAll"]=false
besharp_oop_type_PairingHeap_methods['hasSome']='hasSome'
besharp_oop_type_PairingHeap_method_is_returning["hasSome"]=false
besharp_oop_type_PairingHeap_method_body["hasSome"]='    :'
besharp_oop_type_PairingHeap_method_locals["hasSome"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["hasSome"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["hasSome"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["hasSome"]=false
besharp_oop_type_PairingHeap_methods['isEmpty']='isEmpty'
besharp_oop_type_PairingHeap_method_is_returning["isEmpty"]=true
besharp_oop_type_PairingHeap_method_body["isEmpty"]='    local isset;
    eval "isset=\${${this}_element[@]+isset}";
    if [[ "${isset}" == '"'"'isset'"'"' ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
    else
        besharp_rcrvs[besharp_rcsl]=true;
    fi'
besharp_oop_type_PairingHeap_method_locals["isEmpty"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["isEmpty"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["isEmpty"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["isEmpty"]=true
besharp_oop_type_PairingHeap_methods['isOwningItems']='isOwningItems'
besharp_oop_type_PairingHeap_method_is_returning["isOwningItems"]=false
besharp_oop_type_PairingHeap_method_body["isOwningItems"]='    :'
besharp_oop_type_PairingHeap_method_locals["isOwningItems"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["isOwningItems"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["isOwningItems"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["isOwningItems"]=false
besharp_oop_type_PairingHeap_methods['iterationNew']='iterationNew'
besharp_oop_type_PairingHeap_method_is_returning["iterationNew"]=false
besharp_oop_type_PairingHeap_method_body["iterationNew"]='    ArrayIteration.reversedIterationNew "${this}" "${@}"'
besharp_oop_type_PairingHeap_method_locals["iterationNew"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["iterationNew"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["iterationNew"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["iterationNew"]=true
besharp_oop_type_PairingHeap_methods['iterationNext']='iterationNext'
besharp_oop_type_PairingHeap_method_is_returning["iterationNext"]=false
besharp_oop_type_PairingHeap_method_body["iterationNext"]='    ArrayIteration.reversedIterationNext "${this}" "${@}"'
besharp_oop_type_PairingHeap_method_locals["iterationNext"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["iterationNext"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["iterationNext"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["iterationNext"]=true
besharp_oop_type_PairingHeap_methods['iterationValue']='iterationValue'
besharp_oop_type_PairingHeap_method_is_returning["iterationValue"]=false
besharp_oop_type_PairingHeap_method_body["iterationValue"]='    ArrayIteration.iterationValue "${this}" "${@}"'
besharp_oop_type_PairingHeap_method_locals["iterationValue"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["iterationValue"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["iterationValue"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["iterationValue"]=true
besharp_oop_type_PairingHeap_methods['merge']='merge'
besharp_oop_type_PairingHeap_method_is_returning["merge"]=true
besharp_oop_type_PairingHeap_method_body["merge"]='    local heapA="${1}";
    local heapB="${2}";
    if [[ -z "${heapA}" ]]; then
        besharp_rcrvs[besharp_rcsl]="${heapB}";
        return 0;
    else
        if [[ -z "${heapB}" ]]; then
            besharp_rcrvs[besharp_rcsl]="${heapA}";
            return 0;
        fi;
    fi;
    local valueA="${this}_value[${heapA}]";
    local valueB="${this}_value[${heapB}]";
    local comparatorVar="${this}_comparatorCallback";
    if eval "${!comparatorVar} \"${valueA}\" \"${valueB}\""; then
        if eval "[[ -z \"\${${this}_left_child[${heapA}]}\" ]]"; then
            eval "${this}_left_child[${heapA}]=\"${heapB}\"";
        else
            eval "${this}_next_sibling[${heapB}]=\"\${${this}_left_child[${heapA}]}\"";
            eval "${this}_left_child[${heapA}]=\"${heapB}\"";
        fi;
        besharp_rcrvs[besharp_rcsl]=$heapA;
    else
        if eval "[[ -z \"\${${this}_left_child[${heapB}]}\" ]]"; then
            eval "${this}_left_child[${heapB}]=\"${heapA}\"";
        else
            eval "${this}_next_sibling[${heapA}]=\"\${${this}_left_child[${heapB}]}\"";
            eval "${this}_left_child[${heapB}]=\"${heapA}\"";
        fi;
        besharp_rcrvs[besharp_rcsl]=$heapB;
    fi'
besharp_oop_type_PairingHeap_method_locals["merge"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["merge"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["merge"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["merge"]=true
besharp_oop_type_PairingHeap_methods['mergePairs']='mergePairs'
besharp_oop_type_PairingHeap_method_is_returning["mergePairs"]=true
besharp_oop_type_PairingHeap_method_body["mergePairs"]='    local allTheRestHeap firstTwoHeap ;
    local heap="${1}";
    if [[ -z "${heap}" ]] || eval "[[ -z \"\${${this}_next_sibling[${heap}]}\" ]]"; then
        besharp_rcrvs[besharp_rcsl]="${heap}";
    else
        local otherHeap;
        eval "otherHeap=\"\${${this}_next_sibling[${heap}]}\"";
        local newHeap;
        eval "newHeap=\"\${${this}_next_sibling[${otherHeap}]}\"";
        eval "${this}_next_sibling[${heap}]=";
        eval "${this}_next_sibling[${otherHeap}]=";
        __be__firstTwoHeap $this.merge "${heap}" "${otherHeap}";
        __be__allTheRestHeap $this.mergePairs "${newHeap}";
        besharp.returningOf $this.merge "${firstTwoHeap}" "${allTheRestHeap}";
    fi'
besharp_oop_type_PairingHeap_method_locals["mergePairs"]='local allTheRestHeap
local firstTwoHeap'
besharp_oop_type_PairingHeap_method_is_using_iterators["mergePairs"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["mergePairs"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["mergePairs"]=true
besharp_oop_type_PairingHeap_methods['min']='min'
besharp_oop_type_PairingHeap_method_is_returning["min"]=true
besharp_oop_type_PairingHeap_method_body["min"]='    local rootHeap ;
    __be__rootHeap $this.rootHeap;
    if [[ -z "${rootHeap}" ]]; then
        besharp.runtime.error "There are no elements on the heap!";
    fi;
    eval "besharp_rcrvs[besharp_rcsl]=\${${this}_element[${rootHeap}]}"'
besharp_oop_type_PairingHeap_method_locals["min"]='local rootHeap'
besharp_oop_type_PairingHeap_method_is_using_iterators["min"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["min"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["min"]=true
besharp_oop_type_PairingHeap_methods['ownsItsItems']='ownsItsItems'
besharp_oop_type_PairingHeap_method_is_returning["ownsItsItems"]=false
besharp_oop_type_PairingHeap_method_body["ownsItsItems"]='    :'
besharp_oop_type_PairingHeap_method_locals["ownsItsItems"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["ownsItsItems"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["ownsItsItems"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["ownsItsItems"]=false
besharp_oop_type_PairingHeap_methods['pull']='pull'
besharp_oop_type_PairingHeap_method_is_returning["pull"]=false
besharp_oop_type_PairingHeap_method_body["pull"]='    :'
besharp_oop_type_PairingHeap_method_locals["pull"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["pull"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["pull"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["pull"]=false
besharp_oop_type_PairingHeap_methods['remove']='remove'
besharp_oop_type_PairingHeap_method_is_returning["remove"]=false
besharp_oop_type_PairingHeap_method_body["remove"]='    :'
besharp_oop_type_PairingHeap_method_locals["remove"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["remove"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["remove"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["remove"]=false
besharp_oop_type_PairingHeap_methods['removeAll']='removeAll'
besharp_oop_type_PairingHeap_method_is_returning["removeAll"]=false
besharp_oop_type_PairingHeap_method_body["removeAll"]='    :'
besharp_oop_type_PairingHeap_method_locals["removeAll"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["removeAll"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["removeAll"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["removeAll"]=false
besharp_oop_type_PairingHeap_methods['removeMany']='removeMany'
besharp_oop_type_PairingHeap_method_is_returning["removeMany"]=false
besharp_oop_type_PairingHeap_method_body["removeMany"]='    :'
besharp_oop_type_PairingHeap_method_locals["removeMany"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["removeMany"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["removeMany"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["removeMany"]=false
besharp_oop_type_PairingHeap_methods['removeMin']='removeMin'
besharp_oop_type_PairingHeap_method_is_returning["removeMin"]=false
besharp_oop_type_PairingHeap_method_body["removeMin"]='    local rootHeap ;
    __be__rootHeap $this.rootHeap;
    if [[ -z "${rootHeap}" ]]; then
        besharp.runtime.error "There are no elements on the heap!";
    fi;
    local leftChild;
    eval "leftChild=\${${this}_left_child[${rootHeap}]}";
    __be___this_rootHeap $this.mergePairs "${leftChild}";
    $this.destroyHeapNode "${rootHeap}"'
besharp_oop_type_PairingHeap_method_locals["removeMin"]='local rootHeap'
besharp_oop_type_PairingHeap_method_is_using_iterators["removeMin"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["removeMin"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["removeMin"]=true
besharp_oop_type_PairingHeap_methods['replace']='replace'
besharp_oop_type_PairingHeap_method_is_returning["replace"]=false
besharp_oop_type_PairingHeap_method_body["replace"]='    :'
besharp_oop_type_PairingHeap_method_locals["replace"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["replace"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["replace"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["replace"]=false
besharp_oop_type_PairingHeap_methods['replaceMany']='replaceMany'
besharp_oop_type_PairingHeap_method_is_returning["replaceMany"]=false
besharp_oop_type_PairingHeap_method_body["replaceMany"]='    :'
besharp_oop_type_PairingHeap_method_locals["replaceMany"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["replaceMany"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["replaceMany"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["replaceMany"]=false
besharp_oop_type_PairingHeap_methods['show']='show'
besharp_oop_type_PairingHeap_method_is_returning["show"]=true
besharp_oop_type_PairingHeap_method_body["show"]='    local var="${this}_element[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        echo "<EMPTY>";
        return;
    fi;
    local temp;
    declare -n temp="${this}_element";
    local idx;
    local element;
    local value;
    local leftChild;
    local nextSibling;
    for idx in "${!temp[@]}";
    do
        eval "element=\"\${${this}_element[${idx}]}\"";
        eval "value=\"\${${this}_value[${idx}]}\"";
        eval "leftChild=\"\${${this}_left_child[${idx}]}\"";
        eval "nextSibling=\"\${${this}_next_sibling[${idx}]}\"";
        echo "| #${this} $(besharp.rtti.objectType "${this}") | ${idx} -> [ element: ${element} | value: ${value} | leftChild: ${leftChild} | nextSibling: ${nextSibling} ]";
    done;
    echo "rootHeap: $( @echo $this.rootHeap )";
    echo "maxNodeIndex: $( @echo $this.maxNodeIndex )"'
besharp_oop_type_PairingHeap_method_locals["show"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["show"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["show"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["show"]=true
besharp_oop_type_PairingHeap_methods['shuffle']='shuffle'
besharp_oop_type_PairingHeap_method_is_returning["shuffle"]=false
besharp_oop_type_PairingHeap_method_body["shuffle"]='    :'
besharp_oop_type_PairingHeap_method_locals["shuffle"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["shuffle"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["shuffle"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["shuffle"]=false
besharp_oop_type_PairingHeap_methods['size']='size'
besharp_oop_type_PairingHeap_method_is_returning["size"]=false
besharp_oop_type_PairingHeap_method_body["size"]='    :'
besharp_oop_type_PairingHeap_method_locals["size"]=''
besharp_oop_type_PairingHeap_method_is_using_iterators["size"]=false
besharp_oop_type_PairingHeap_method_is_calling_parent["size"]=false
besharp_oop_type_PairingHeap_method_is_calling_this["size"]=false

fi
if ${beshfile_section__code:-false}; then :;
function __be___this_comparatorCallback() {
  "${@}"
  eval $this"_comparatorCallback=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
}
function __be__comparator() {
  "${@}"
  comparator="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__newHeap() {
  "${@}"
  newHeap="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__reversed() {
  "${@}"
  reversed="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be___this_comparatorCallback() {
  "${@}"
  eval $this"_comparatorCallback=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
}
function __be__index() {
  "${@}"
  index="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__allTheRestHeap() {
  "${@}"
  allTheRestHeap="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__firstTwoHeap() {
  "${@}"
  firstTwoHeap="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__rootHeap() {
  "${@}"
  rootHeap="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__rootHeap() {
  "${@}"
  rootHeap="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be___this_rootHeap() {
  "${@}"
  eval $this"_rootHeap=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
}
PairingHeap ()
{
    @parent;
    local comparatorOrReverseFlag="${1:-min}";
    case "${comparatorOrReverseFlag}" in
        "min")
            $this.reversed = false
        ;;
        "false")
            $this.reversed = false
        ;;
        "max")
            $this.reversed = true
        ;;
        "true")
            $this.reversed = true
        ;;
        *)
            if @is "${comparatorOrReverseFlag}" FastComparator; then
                __be___this_comparatorCallback $comparator.fastCompareFunction;
                return;
            else
                if @is "${comparatorOrReverseFlag}" Comparator; then
                    $this.comparatorCallback = $comparator.compare;
                    return;
                fi;
            fi;
            besharp.runtime.error "Unknown comparatorOrReverseFlag: ${comparatorOrReverseFlag}"
        ;;
    esac
}
PairingHeap.add ()
{
    local comparator newHeap reversed;
    local element="${1}";
    if [[ "${2+isset}" == 'isset' ]]; then
        local value="${2}";
    else
        local value="${element}";
    fi;
    if [[ "${element// /}" != "${element}" ]]; then
        besharp.runtime.error "Invalid element: '${element}' PairingHeap elements cannot have spaces. Please provide either an Comparable object or string with no spaces!";
    fi;
    local comparatorVar="${this}_comparatorCallback";
    if [[ -z "${!comparatorVar}" ]]; then
        __be__reversed $this.reversed;
        if [[ "${value}" =~ ^-?[0-9]+$ ]]; then
            __be__comparator @comparators.makeForNaturalOrderIntegers "${reversed}";
        else
            if @is "${value}" Comparable; then
                __be__comparator @comparators.makeForNaturalOrder "${reversed}";
            else
                besharp.runtime.error "Invalid value: '${value}'. PairingHeap values can only work with integer numbers and Comparable objects";
            fi;
        fi;
        __be___this_comparatorCallback $comparator.fastCompareFunction;
        @unset $comparator;
    fi;
    __be__newHeap $this.createEmptyHeapNode "${element}" "${value}";
    local rootHeapVar="${this}_rootHeap";
    eval "@let ${this}_rootHeap = $this.merge \"${!rootHeapVar:-}\" \"${newHeap}\""
}
PairingHeap.addMany ()
{
    :
}
PairingHeap.createEmptyHeapNode ()
{
    local index;
    local element="${1}";
    local value="${2}";
    __be__index $this.maxNodeIndex;
    (( ++index ));
    $this.maxNodeIndex = ${index};
    eval "${this}_element[${index}]=\"\${element}\"";
    eval "${this}_value[${index}]=\"\${value}\"";
    eval "${this}_left_child[${index}]=";
    eval "${this}_next_sibling[${index}]=";
    besharp_rcrvs[besharp_rcsl]="${index}"
}
PairingHeap.current ()
{
    :
}
PairingHeap.declarePrimitiveVariable ()
{
    declare -a "${this}_element";
    declare -a "${this}_value";
    declare -a "${this}_left_child";
    declare -a "${this}_next_sibling"
}
PairingHeap.destroyHeapNode ()
{
    local heap="${1}";
    unset "${this}_element[${heap}]";
    unset "${this}_value[${heap}]";
    unset "${this}_left_child[${heap}]";
    unset "${this}_next_sibling[${heap}]"
}
PairingHeap.destroyPrimitiveVariable ()
{
    unset "${this}_element";
    unset "${this}_value";
    unset "${this}_left_child";
    unset "${this}_next_sibling"
}
PairingHeap.fill ()
{
    :
}
PairingHeap.frequency ()
{
    :
}
PairingHeap.has ()
{
    :
}
PairingHeap.hasAll ()
{
    :
}
PairingHeap.hasSome ()
{
    :
}
PairingHeap.isEmpty ()
{
    local isset;
    eval "isset=\${${this}_element[@]+isset}";
    if [[ "${isset}" == 'isset' ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
    else
        besharp_rcrvs[besharp_rcsl]=true;
    fi
}
PairingHeap.isOwningItems ()
{
    :
}
PairingHeap.iterationNew ()
{
    ArrayIteration.reversedIterationNew "${this}" "${@}"
}
PairingHeap.iterationNext ()
{
    ArrayIteration.reversedIterationNext "${this}" "${@}"
}
PairingHeap.iterationValue ()
{
    ArrayIteration.iterationValue "${this}" "${@}"
}
PairingHeap.merge ()
{
    local heapA="${1}";
    local heapB="${2}";
    if [[ -z "${heapA}" ]]; then
        besharp_rcrvs[besharp_rcsl]="${heapB}";
        return 0;
    else
        if [[ -z "${heapB}" ]]; then
            besharp_rcrvs[besharp_rcsl]="${heapA}";
            return 0;
        fi;
    fi;
    local valueA="${this}_value[${heapA}]";
    local valueB="${this}_value[${heapB}]";
    local comparatorVar="${this}_comparatorCallback";
    if eval "${!comparatorVar} \"${valueA}\" \"${valueB}\""; then
        if eval "[[ -z \"\${${this}_left_child[${heapA}]}\" ]]"; then
            eval "${this}_left_child[${heapA}]=\"${heapB}\"";
        else
            eval "${this}_next_sibling[${heapB}]=\"\${${this}_left_child[${heapA}]}\"";
            eval "${this}_left_child[${heapA}]=\"${heapB}\"";
        fi;
        besharp_rcrvs[besharp_rcsl]=$heapA;
    else
        if eval "[[ -z \"\${${this}_left_child[${heapB}]}\" ]]"; then
            eval "${this}_left_child[${heapB}]=\"${heapA}\"";
        else
            eval "${this}_next_sibling[${heapA}]=\"\${${this}_left_child[${heapB}]}\"";
            eval "${this}_left_child[${heapB}]=\"${heapA}\"";
        fi;
        besharp_rcrvs[besharp_rcsl]=$heapB;
    fi
}
PairingHeap.mergePairs ()
{
    local allTheRestHeap firstTwoHeap;
    local heap="${1}";
    if [[ -z "${heap}" ]] || eval "[[ -z \"\${${this}_next_sibling[${heap}]}\" ]]"; then
        besharp_rcrvs[besharp_rcsl]="${heap}";
    else
        local otherHeap;
        eval "otherHeap=\"\${${this}_next_sibling[${heap}]}\"";
        local newHeap;
        eval "newHeap=\"\${${this}_next_sibling[${otherHeap}]}\"";
        eval "${this}_next_sibling[${heap}]=";
        eval "${this}_next_sibling[${otherHeap}]=";
        __be__firstTwoHeap $this.merge "${heap}" "${otherHeap}";
        __be__allTheRestHeap $this.mergePairs "${newHeap}";
        besharp.returningOf $this.merge "${firstTwoHeap}" "${allTheRestHeap}";
    fi
}
PairingHeap.min ()
{
    local rootHeap;
    __be__rootHeap $this.rootHeap;
    if [[ -z "${rootHeap}" ]]; then
        besharp.runtime.error "There are no elements on the heap!";
    fi;
    eval "besharp_rcrvs[besharp_rcsl]=\${${this}_element[${rootHeap}]}"
}
PairingHeap.ownsItsItems ()
{
    :
}
PairingHeap.pull ()
{
    :
}
PairingHeap.remove ()
{
    :
}
PairingHeap.removeAll ()
{
    :
}
PairingHeap.removeMany ()
{
    :
}
PairingHeap.removeMin ()
{
    local rootHeap;
    __be__rootHeap $this.rootHeap;
    if [[ -z "${rootHeap}" ]]; then
        besharp.runtime.error "There are no elements on the heap!";
    fi;
    local leftChild;
    eval "leftChild=\${${this}_left_child[${rootHeap}]}";
    __be___this_rootHeap $this.mergePairs "${leftChild}";
    $this.destroyHeapNode "${rootHeap}"
}
PairingHeap.replace ()
{
    :
}
PairingHeap.replaceMany ()
{
    :
}
PairingHeap.show ()
{
    local var="${this}_element[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        echo "<EMPTY>";
        return;
    fi;
    local temp;
    declare -n temp="${this}_element";
    local idx;
    local element;
    local value;
    local leftChild;
    local nextSibling;
    for idx in "${!temp[@]}";
    do
        eval "element=\"\${${this}_element[${idx}]}\"";
        eval "value=\"\${${this}_value[${idx}]}\"";
        eval "leftChild=\"\${${this}_left_child[${idx}]}\"";
        eval "nextSibling=\"\${${this}_next_sibling[${idx}]}\"";
        echo "| #${this} $(besharp.rtti.objectType "${this}") | ${idx} -> [ element: ${element} | value: ${value} | leftChild: ${leftChild} | nextSibling: ${nextSibling} ]";
    done;
    echo "rootHeap: $( @echo $this.rootHeap )";
    echo "maxNodeIndex: $( @echo $this.maxNodeIndex )"
}
PairingHeap.shuffle ()
{
    :
}
PairingHeap.size ()
{
    :
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Queue"]='true'
besharp_oop_type_is["Queue"]='class'
besharp_oop_types["Queue"]="Queue"
declare -Ag besharp_oop_type_Queue_interfaces
besharp_oop_type_Queue_interfaces['Sequence']='Sequence'
besharp_oop_type_Queue_interfaces['MutableContainer']='MutableContainer'
besharp_oop_classes["Queue"]="Queue"
besharp_oop_type_parent["Queue"]="IndexedArrayCollection"
declare -Ag besharp_oop_type_Queue_fields
declare -Ag besharp_oop_type_Queue_injectable_fields
declare -Ag besharp_oop_type_Queue_field_type
declare -Ag besharp_oop_type_Queue_field_default
declare -Ag besharp_oop_type_Queue_methods
declare -Ag besharp_oop_type_Queue_method_body
declare -Ag besharp_oop_type_Queue_method_locals
declare -Ag besharp_oop_type_Queue_method_is_returning
declare -Ag besharp_oop_type_Queue_method_is_abstract
declare -Ag besharp_oop_type_Queue_method_is_using_iterators
declare -Ag besharp_oop_type_Queue_method_is_calling_parent
declare -Ag besharp_oop_type_Queue_method_is_calling_this
besharp_oop_type_Queue_methods['Queue']='Queue'
besharp_oop_type_Queue_method_is_returning["Queue"]=false
besharp_oop_type_Queue_method_body["Queue"]='    @parent'
besharp_oop_type_Queue_method_locals["Queue"]=''
besharp_oop_type_Queue_method_is_using_iterators["Queue"]=false
besharp_oop_type_Queue_method_is_calling_parent["Queue"]=true
besharp_oop_type_Queue_method_is_calling_this["Queue"]=false
besharp_oop_type_Queue_methods['current']='current'
besharp_oop_type_Queue_method_is_returning["current"]=true
besharp_oop_type_Queue_method_body["current"]='    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp.runtime.error "You cannot call Queue.current() on an empty Set! Please use Queue.isEmpty() method to avoid this issue!";
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        local item;
        eval "item=\"\${${this}[${idx}]}\"";
        besharp_rcrvs[besharp_rcsl]="${item}";
        return;
    done'
besharp_oop_type_Queue_method_locals["current"]=''
besharp_oop_type_Queue_method_is_using_iterators["current"]=false
besharp_oop_type_Queue_method_is_calling_parent["current"]=false
besharp_oop_type_Queue_method_is_calling_this["current"]=true
besharp_oop_type_Queue_methods['pull']='pull'
besharp_oop_type_Queue_method_is_returning["pull"]=true
besharp_oop_type_Queue_method_body["pull"]='    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp.runtime.error "You cannot call Queue.pull() on an empty Set! Please use Queue.isEmpty() method to avoid this issue!";
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        local item;
        eval "item=\"\${${this}[${idx}]}\"";
        besharp_rcrvs[besharp_rcsl]="${item}";
        unset "${this}[${idx}]";
        return;
    done'
besharp_oop_type_Queue_method_locals["pull"]=''
besharp_oop_type_Queue_method_is_using_iterators["pull"]=false
besharp_oop_type_Queue_method_is_calling_parent["pull"]=false
besharp_oop_type_Queue_method_is_calling_this["pull"]=true

fi
if ${beshfile_section__code:-false}; then :;
Queue ()
{
    @parent
}
Queue.current ()
{
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp.runtime.error "You cannot call Queue.current() on an empty Set! Please use Queue.isEmpty() method to avoid this issue!";
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        local item;
        eval "item=\"\${${this}[${idx}]}\"";
        besharp_rcrvs[besharp_rcsl]="${item}";
        return;
    done
}
Queue.pull ()
{
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp.runtime.error "You cannot call Queue.pull() on an empty Set! Please use Queue.isEmpty() method to avoid this issue!";
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        local item;
        eval "item=\"\${${this}[${idx}]}\"";
        besharp_rcrvs[besharp_rcsl]="${item}";
        unset "${this}[${idx}]";
        return;
    done
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Stack"]='true'
besharp_oop_type_is["Stack"]='class'
besharp_oop_types["Stack"]="Stack"
declare -Ag besharp_oop_type_Stack_interfaces
besharp_oop_type_Stack_interfaces['Sequence']='Sequence'
besharp_oop_type_Stack_interfaces['MutableContainer']='MutableContainer'
besharp_oop_classes["Stack"]="Stack"
besharp_oop_type_parent["Stack"]="IndexedArrayCollection"
declare -Ag besharp_oop_type_Stack_fields
declare -Ag besharp_oop_type_Stack_injectable_fields
declare -Ag besharp_oop_type_Stack_field_type
declare -Ag besharp_oop_type_Stack_field_default
declare -Ag besharp_oop_type_Stack_methods
declare -Ag besharp_oop_type_Stack_method_body
declare -Ag besharp_oop_type_Stack_method_locals
declare -Ag besharp_oop_type_Stack_method_is_returning
declare -Ag besharp_oop_type_Stack_method_is_abstract
declare -Ag besharp_oop_type_Stack_method_is_using_iterators
declare -Ag besharp_oop_type_Stack_method_is_calling_parent
declare -Ag besharp_oop_type_Stack_method_is_calling_this
besharp_oop_type_Stack_methods['Stack']='Stack'
besharp_oop_type_Stack_method_is_returning["Stack"]=false
besharp_oop_type_Stack_method_body["Stack"]='    @parent'
besharp_oop_type_Stack_method_locals["Stack"]=''
besharp_oop_type_Stack_method_is_using_iterators["Stack"]=false
besharp_oop_type_Stack_method_is_calling_parent["Stack"]=true
besharp_oop_type_Stack_method_is_calling_this["Stack"]=false
besharp_oop_type_Stack_methods['current']='current'
besharp_oop_type_Stack_method_is_returning["current"]=true
besharp_oop_type_Stack_method_body["current"]='    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp.runtime.error "You cannot call Stack.current() on an empty Set! Please use Stack.isEmpty() method to avoid this issue!";
        return;
    fi;
    local size;
    eval "size=\${#${this}}";
    local item;
    eval "item=\"\${${this}[-1]}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"'
besharp_oop_type_Stack_method_locals["current"]=''
besharp_oop_type_Stack_method_is_using_iterators["current"]=false
besharp_oop_type_Stack_method_is_calling_parent["current"]=false
besharp_oop_type_Stack_method_is_calling_this["current"]=true
besharp_oop_type_Stack_methods['iterationNew']='iterationNew'
besharp_oop_type_Stack_method_is_returning["iterationNew"]=false
besharp_oop_type_Stack_method_body["iterationNew"]='    ArrayIteration.reversedIterationNew "${this}" "${@}"'
besharp_oop_type_Stack_method_locals["iterationNew"]=''
besharp_oop_type_Stack_method_is_using_iterators["iterationNew"]=false
besharp_oop_type_Stack_method_is_calling_parent["iterationNew"]=false
besharp_oop_type_Stack_method_is_calling_this["iterationNew"]=true
besharp_oop_type_Stack_methods['iterationNext']='iterationNext'
besharp_oop_type_Stack_method_is_returning["iterationNext"]=false
besharp_oop_type_Stack_method_body["iterationNext"]='    ArrayIteration.reversedIterationNext "${this}" "${@}"'
besharp_oop_type_Stack_method_locals["iterationNext"]=''
besharp_oop_type_Stack_method_is_using_iterators["iterationNext"]=false
besharp_oop_type_Stack_method_is_calling_parent["iterationNext"]=false
besharp_oop_type_Stack_method_is_calling_this["iterationNext"]=true
besharp_oop_type_Stack_methods['iterationValue']='iterationValue'
besharp_oop_type_Stack_method_is_returning["iterationValue"]=false
besharp_oop_type_Stack_method_body["iterationValue"]='    ArrayIteration.iterationValue "${this}" "${@}"'
besharp_oop_type_Stack_method_locals["iterationValue"]=''
besharp_oop_type_Stack_method_is_using_iterators["iterationValue"]=false
besharp_oop_type_Stack_method_is_calling_parent["iterationValue"]=false
besharp_oop_type_Stack_method_is_calling_this["iterationValue"]=true
besharp_oop_type_Stack_methods['pull']='pull'
besharp_oop_type_Stack_method_is_returning["pull"]=true
besharp_oop_type_Stack_method_body["pull"]='    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp.runtime.error "You cannot call Stack.pull() on an empty Set! Please use Stack.isEmpty() method to avoid this issue!";
        return;
    fi;
    local item;
    eval "item=\"\${${this}[-1]}\"";
    besharp_rcrvs[besharp_rcsl]="${item}";
    unset "${this}[-1]"'
besharp_oop_type_Stack_method_locals["pull"]=''
besharp_oop_type_Stack_method_is_using_iterators["pull"]=false
besharp_oop_type_Stack_method_is_calling_parent["pull"]=false
besharp_oop_type_Stack_method_is_calling_this["pull"]=true

fi
if ${beshfile_section__code:-false}; then :;
Stack ()
{
    @parent
}
Stack.current ()
{
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp.runtime.error "You cannot call Stack.current() on an empty Set! Please use Stack.isEmpty() method to avoid this issue!";
        return;
    fi;
    local size;
    eval "size=\${#${this}}";
    local item;
    eval "item=\"\${${this}[-1]}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"
}
Stack.iterationNew ()
{
    ArrayIteration.reversedIterationNew "${this}" "${@}"
}
Stack.iterationNext ()
{
    ArrayIteration.reversedIterationNext "${this}" "${@}"
}
Stack.iterationValue ()
{
    ArrayIteration.iterationValue "${this}" "${@}"
}
Stack.pull ()
{
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp.runtime.error "You cannot call Stack.pull() on an empty Set! Please use Stack.isEmpty() method to avoid this issue!";
        return;
    fi;
    local item;
    eval "item=\"\${${this}[-1]}\"";
    besharp_rcrvs[besharp_rcsl]="${item}";
    unset "${this}[-1]"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["ArrayIteration"]='true'
besharp_oop_type_is["ArrayIteration"]='class'
besharp_oop_types["ArrayIteration"]="ArrayIteration"
declare -Ag besharp_oop_type_ArrayIteration_interfaces
besharp_oop_classes["ArrayIteration"]="ArrayIteration"
besharp_oop_type_parent["ArrayIteration"]="Object"
declare -Ag besharp_oop_type_ArrayIteration_fields
declare -Ag besharp_oop_type_ArrayIteration_injectable_fields
declare -Ag besharp_oop_type_ArrayIteration_field_type
declare -Ag besharp_oop_type_ArrayIteration_field_default
declare -Ag besharp_oop_type_ArrayIteration_methods
declare -Ag besharp_oop_type_ArrayIteration_method_body
declare -Ag besharp_oop_type_ArrayIteration_method_locals
declare -Ag besharp_oop_type_ArrayIteration_method_is_returning
declare -Ag besharp_oop_type_ArrayIteration_method_is_abstract
declare -Ag besharp_oop_type_ArrayIteration_method_is_using_iterators
declare -Ag besharp_oop_type_ArrayIteration_method_is_calling_parent
declare -Ag besharp_oop_type_ArrayIteration_method_is_calling_this
besharp_oop_type_ArrayIteration_methods['ArrayIteration']='ArrayIteration'
besharp_oop_type_ArrayIteration_method_is_returning["ArrayIteration"]=false
besharp_oop_type_ArrayIteration_method_body["ArrayIteration"]='    :'
besharp_oop_type_ArrayIteration_method_locals["ArrayIteration"]=''
besharp_oop_type_ArrayIteration_method_is_using_iterators["ArrayIteration"]=false
besharp_oop_type_ArrayIteration_method_is_calling_parent["ArrayIteration"]=false
besharp_oop_type_ArrayIteration_method_is_calling_this["ArrayIteration"]=false
besharp_oop_type_ArrayIteration_methods['iterationKey']='iterationKey'
besharp_oop_type_ArrayIteration_method_is_returning["iterationKey"]=true
besharp_oop_type_ArrayIteration_method_body["iterationKey"]='    local varName="${this}_system_iterator_$(( besharp_rcsl - 1 ))_${__besharp_iterator_position_in_a_method}";
    local key;
    eval "key=\"\${${varName}[\"${2}\"]}\"";
    besharp_rcrvs[besharp_rcsl]="${key}"'
besharp_oop_type_ArrayIteration_method_locals["iterationKey"]=''
besharp_oop_type_ArrayIteration_method_is_using_iterators["iterationKey"]=false
besharp_oop_type_ArrayIteration_method_is_calling_parent["iterationKey"]=false
besharp_oop_type_ArrayIteration_method_is_calling_this["iterationKey"]=true
besharp_oop_type_ArrayIteration_methods['iterationNew']='iterationNew'
besharp_oop_type_ArrayIteration_method_is_returning["iterationNew"]=true
besharp_oop_type_ArrayIteration_method_body["iterationNew"]='    local stackLvl=$(( besharp_rcsl - 1 ));
    if eval "[[ -z \${!${1}[@]} ]]"; then
        besharp_rcrvs[besharp_rcsl]='"'"''"'"';
    else
        local varName="${this}_system_iterator_${stackLvl}_${__besharp_iterator_position_in_a_method}";
        eval "${varName}=( \"\${!${1}[@]}\" )";
        eval "besharp_runtime_current_iterator__stack_${stackLvl}[${__besharp_iterator_position_in_a_method}]=\${varName}";
        besharp_rcrvs[besharp_rcsl]=0;
    fi'
besharp_oop_type_ArrayIteration_method_locals["iterationNew"]=''
besharp_oop_type_ArrayIteration_method_is_using_iterators["iterationNew"]=false
besharp_oop_type_ArrayIteration_method_is_calling_parent["iterationNew"]=false
besharp_oop_type_ArrayIteration_method_is_calling_this["iterationNew"]=true
besharp_oop_type_ArrayIteration_methods['iterationNext']='iterationNext'
besharp_oop_type_ArrayIteration_method_is_returning["iterationNext"]=true
besharp_oop_type_ArrayIteration_method_body["iterationNext"]='    local varName="${this}_system_iterator_$(( besharp_rcsl - 1 ))_${__besharp_iterator_position_in_a_method}";
    local size;
    eval "size=\${#${varName}[@]}";
    if (( $2 < size - 1 )); then
        besharp_rcrvs[besharp_rcsl]=$(( $2 + 1 ));
    else
        besharp_rcrvs[besharp_rcsl]='"'"''"'"';
    fi'
besharp_oop_type_ArrayIteration_method_locals["iterationNext"]=''
besharp_oop_type_ArrayIteration_method_is_using_iterators["iterationNext"]=false
besharp_oop_type_ArrayIteration_method_is_calling_parent["iterationNext"]=false
besharp_oop_type_ArrayIteration_method_is_calling_this["iterationNext"]=true
besharp_oop_type_ArrayIteration_methods['iterationValue']='iterationValue'
besharp_oop_type_ArrayIteration_method_is_returning["iterationValue"]=true
besharp_oop_type_ArrayIteration_method_body["iterationValue"]='    local varName="${this}_system_iterator_$(( besharp_rcsl - 1 ))_${__besharp_iterator_position_in_a_method}";
    local idx;
    eval "idx=\"\${${varName}[\"${2}\"]}\"";
    local value;
    eval "value=\"\${${1}[${idx}]}\"";
    besharp_rcrvs[besharp_rcsl]="${value}"'
besharp_oop_type_ArrayIteration_method_locals["iterationValue"]=''
besharp_oop_type_ArrayIteration_method_is_using_iterators["iterationValue"]=false
besharp_oop_type_ArrayIteration_method_is_calling_parent["iterationValue"]=false
besharp_oop_type_ArrayIteration_method_is_calling_this["iterationValue"]=true
besharp_oop_type_ArrayIteration_methods['reversedIterationNew']='reversedIterationNew'
besharp_oop_type_ArrayIteration_method_is_returning["reversedIterationNew"]=true
besharp_oop_type_ArrayIteration_method_body["reversedIterationNew"]='    local stackLvl=$(( besharp_rcsl - 1 ));
    if eval "[[ -z \${!${1}[@]} ]]"; then
        besharp_rcrvs[besharp_rcsl]='"'"''"'"';
    else
        local varName="${this}_system_iterator_${stackLvl}_${__besharp_iterator_position_in_a_method}";
        eval "${varName}=( \"\${!${1}[@]}\" )";
        eval "besharp_runtime_current_iterator__stack_${stackLvl}[${__besharp_iterator_position_in_a_method}]=\${varName}";
        local size;
        eval "size=\${#${varName}[@]}";
        besharp_rcrvs[besharp_rcsl]=$(( size - 1 ));
    fi'
besharp_oop_type_ArrayIteration_method_locals["reversedIterationNew"]=''
besharp_oop_type_ArrayIteration_method_is_using_iterators["reversedIterationNew"]=false
besharp_oop_type_ArrayIteration_method_is_calling_parent["reversedIterationNew"]=false
besharp_oop_type_ArrayIteration_method_is_calling_this["reversedIterationNew"]=true
besharp_oop_type_ArrayIteration_methods['reversedIterationNext']='reversedIterationNext'
besharp_oop_type_ArrayIteration_method_is_returning["reversedIterationNext"]=true
besharp_oop_type_ArrayIteration_method_body["reversedIterationNext"]='    local varName="${this}_system_iterator_$(( besharp_rcsl - 1 ))_${__besharp_iterator_position_in_a_method}";
    if (( $2 > 0 )); then
        besharp_rcrvs[besharp_rcsl]=$(( $2 - 1 ));
    else
        besharp_rcrvs[besharp_rcsl]='"'"''"'"';
    fi'
besharp_oop_type_ArrayIteration_method_locals["reversedIterationNext"]=''
besharp_oop_type_ArrayIteration_method_is_using_iterators["reversedIterationNext"]=false
besharp_oop_type_ArrayIteration_method_is_calling_parent["reversedIterationNext"]=false
besharp_oop_type_ArrayIteration_method_is_calling_this["reversedIterationNext"]=true

fi
if ${beshfile_section__code:-false}; then :;
ArrayIteration ()
{
    :
}
ArrayIteration.iterationKey ()
{
    local varName="${this}_system_iterator_$(( besharp_rcsl - 1 ))_${__besharp_iterator_position_in_a_method}";
    local key;
    eval "key=\"\${${varName}[\"${2}\"]}\"";
    besharp_rcrvs[besharp_rcsl]="${key}"
}
ArrayIteration.iterationNew ()
{
    local stackLvl=$(( besharp_rcsl - 1 ));
    if eval "[[ -z \${!${1}[@]} ]]"; then
        besharp_rcrvs[besharp_rcsl]='';
    else
        local varName="${this}_system_iterator_${stackLvl}_${__besharp_iterator_position_in_a_method}";
        eval "${varName}=( \"\${!${1}[@]}\" )";
        eval "besharp_runtime_current_iterator__stack_${stackLvl}[${__besharp_iterator_position_in_a_method}]=\${varName}";
        besharp_rcrvs[besharp_rcsl]=0;
    fi
}
ArrayIteration.iterationNext ()
{
    local varName="${this}_system_iterator_$(( besharp_rcsl - 1 ))_${__besharp_iterator_position_in_a_method}";
    local size;
    eval "size=\${#${varName}[@]}";
    if (( $2 < size - 1 )); then
        besharp_rcrvs[besharp_rcsl]=$(( $2 + 1 ));
    else
        besharp_rcrvs[besharp_rcsl]='';
    fi
}
ArrayIteration.iterationValue ()
{
    local varName="${this}_system_iterator_$(( besharp_rcsl - 1 ))_${__besharp_iterator_position_in_a_method}";
    local idx;
    eval "idx=\"\${${varName}[\"${2}\"]}\"";
    local value;
    eval "value=\"\${${1}[${idx}]}\"";
    besharp_rcrvs[besharp_rcsl]="${value}"
}
ArrayIteration.reversedIterationNew ()
{
    local stackLvl=$(( besharp_rcsl - 1 ));
    if eval "[[ -z \${!${1}[@]} ]]"; then
        besharp_rcrvs[besharp_rcsl]='';
    else
        local varName="${this}_system_iterator_${stackLvl}_${__besharp_iterator_position_in_a_method}";
        eval "${varName}=( \"\${!${1}[@]}\" )";
        eval "besharp_runtime_current_iterator__stack_${stackLvl}[${__besharp_iterator_position_in_a_method}]=\${varName}";
        local size;
        eval "size=\${#${varName}[@]}";
        besharp_rcrvs[besharp_rcsl]=$(( size - 1 ));
    fi
}
ArrayIteration.reversedIterationNext ()
{
    local varName="${this}_system_iterator_$(( besharp_rcsl - 1 ))_${__besharp_iterator_position_in_a_method}";
    if (( $2 > 0 )); then
        besharp_rcrvs[besharp_rcsl]=$(( $2 - 1 ));
    else
        besharp_rcrvs[besharp_rcsl]='';
    fi
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["AssocArrayCollection"]='true'
besharp_oop_type_abstract["AssocArrayCollection"]='true'
besharp_oop_type_is["AssocArrayCollection"]='class'
besharp_oop_types["AssocArrayCollection"]="AssocArrayCollection"
declare -Ag besharp_oop_type_AssocArrayCollection_interfaces
besharp_oop_classes["AssocArrayCollection"]="AssocArrayCollection"
besharp_oop_type_parent["AssocArrayCollection"]="PrimitiveCollection"
declare -Ag besharp_oop_type_AssocArrayCollection_fields
declare -Ag besharp_oop_type_AssocArrayCollection_injectable_fields
declare -Ag besharp_oop_type_AssocArrayCollection_field_type
declare -Ag besharp_oop_type_AssocArrayCollection_field_default
declare -Ag besharp_oop_type_AssocArrayCollection_methods
declare -Ag besharp_oop_type_AssocArrayCollection_method_body
declare -Ag besharp_oop_type_AssocArrayCollection_method_locals
declare -Ag besharp_oop_type_AssocArrayCollection_method_is_returning
declare -Ag besharp_oop_type_AssocArrayCollection_method_is_abstract
declare -Ag besharp_oop_type_AssocArrayCollection_method_is_using_iterators
declare -Ag besharp_oop_type_AssocArrayCollection_method_is_calling_parent
declare -Ag besharp_oop_type_AssocArrayCollection_method_is_calling_this
besharp_oop_type_AssocArrayCollection_methods['AssocArrayCollection']='AssocArrayCollection'
besharp_oop_type_AssocArrayCollection_method_is_returning["AssocArrayCollection"]=false
besharp_oop_type_AssocArrayCollection_method_body["AssocArrayCollection"]='    @parent'
besharp_oop_type_AssocArrayCollection_method_locals["AssocArrayCollection"]=''
besharp_oop_type_AssocArrayCollection_method_is_using_iterators["AssocArrayCollection"]=false
besharp_oop_type_AssocArrayCollection_method_is_calling_parent["AssocArrayCollection"]=true
besharp_oop_type_AssocArrayCollection_method_is_calling_this["AssocArrayCollection"]=false
besharp_oop_type_AssocArrayCollection_methods['declarePrimitiveVariable']='declarePrimitiveVariable'
besharp_oop_type_AssocArrayCollection_method_is_returning["declarePrimitiveVariable"]=false
besharp_oop_type_AssocArrayCollection_method_body["declarePrimitiveVariable"]='    declare -Ag "${this}"'
besharp_oop_type_AssocArrayCollection_method_locals["declarePrimitiveVariable"]=''
besharp_oop_type_AssocArrayCollection_method_is_using_iterators["declarePrimitiveVariable"]=false
besharp_oop_type_AssocArrayCollection_method_is_calling_parent["declarePrimitiveVariable"]=false
besharp_oop_type_AssocArrayCollection_method_is_calling_this["declarePrimitiveVariable"]=true
besharp_oop_type_AssocArrayCollection_methods['destroyPrimitiveVariable']='destroyPrimitiveVariable'
besharp_oop_type_AssocArrayCollection_method_is_returning["destroyPrimitiveVariable"]=false
besharp_oop_type_AssocArrayCollection_method_body["destroyPrimitiveVariable"]='    unset "${this}"'
besharp_oop_type_AssocArrayCollection_method_locals["destroyPrimitiveVariable"]=''
besharp_oop_type_AssocArrayCollection_method_is_using_iterators["destroyPrimitiveVariable"]=false
besharp_oop_type_AssocArrayCollection_method_is_calling_parent["destroyPrimitiveVariable"]=false
besharp_oop_type_AssocArrayCollection_method_is_calling_this["destroyPrimitiveVariable"]=true

fi
if ${beshfile_section__code:-false}; then :;
AssocArrayCollection ()
{
    @parent
}
AssocArrayCollection.declarePrimitiveVariable ()
{
    declare -Ag "${this}"
}
AssocArrayCollection.destroyPrimitiveVariable ()
{
    unset "${this}"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["AssocArrayContainer"]='true'
besharp_oop_type_abstract["AssocArrayContainer"]='true'
besharp_oop_type_is["AssocArrayContainer"]='class'
besharp_oop_types["AssocArrayContainer"]="AssocArrayContainer"
declare -Ag besharp_oop_type_AssocArrayContainer_interfaces
besharp_oop_classes["AssocArrayContainer"]="AssocArrayContainer"
besharp_oop_type_parent["AssocArrayContainer"]="PrimitiveContainer"
declare -Ag besharp_oop_type_AssocArrayContainer_fields
declare -Ag besharp_oop_type_AssocArrayContainer_injectable_fields
declare -Ag besharp_oop_type_AssocArrayContainer_field_type
declare -Ag besharp_oop_type_AssocArrayContainer_field_default
declare -Ag besharp_oop_type_AssocArrayContainer_methods
declare -Ag besharp_oop_type_AssocArrayContainer_method_body
declare -Ag besharp_oop_type_AssocArrayContainer_method_locals
declare -Ag besharp_oop_type_AssocArrayContainer_method_is_returning
declare -Ag besharp_oop_type_AssocArrayContainer_method_is_abstract
declare -Ag besharp_oop_type_AssocArrayContainer_method_is_using_iterators
declare -Ag besharp_oop_type_AssocArrayContainer_method_is_calling_parent
declare -Ag besharp_oop_type_AssocArrayContainer_method_is_calling_this
besharp_oop_type_AssocArrayContainer_methods['AssocArrayContainer']='AssocArrayContainer'
besharp_oop_type_AssocArrayContainer_method_is_returning["AssocArrayContainer"]=false
besharp_oop_type_AssocArrayContainer_method_body["AssocArrayContainer"]='    @parent'
besharp_oop_type_AssocArrayContainer_method_locals["AssocArrayContainer"]=''
besharp_oop_type_AssocArrayContainer_method_is_using_iterators["AssocArrayContainer"]=false
besharp_oop_type_AssocArrayContainer_method_is_calling_parent["AssocArrayContainer"]=true
besharp_oop_type_AssocArrayContainer_method_is_calling_this["AssocArrayContainer"]=false
besharp_oop_type_AssocArrayContainer_methods['declarePrimitiveVariable']='declarePrimitiveVariable'
besharp_oop_type_AssocArrayContainer_method_is_returning["declarePrimitiveVariable"]=false
besharp_oop_type_AssocArrayContainer_method_body["declarePrimitiveVariable"]='    declare -Ag "${this}"'
besharp_oop_type_AssocArrayContainer_method_locals["declarePrimitiveVariable"]=''
besharp_oop_type_AssocArrayContainer_method_is_using_iterators["declarePrimitiveVariable"]=false
besharp_oop_type_AssocArrayContainer_method_is_calling_parent["declarePrimitiveVariable"]=false
besharp_oop_type_AssocArrayContainer_method_is_calling_this["declarePrimitiveVariable"]=true
besharp_oop_type_AssocArrayContainer_methods['destroyPrimitiveVariable']='destroyPrimitiveVariable'
besharp_oop_type_AssocArrayContainer_method_is_returning["destroyPrimitiveVariable"]=false
besharp_oop_type_AssocArrayContainer_method_body["destroyPrimitiveVariable"]='    unset "${this}"'
besharp_oop_type_AssocArrayContainer_method_locals["destroyPrimitiveVariable"]=''
besharp_oop_type_AssocArrayContainer_method_is_using_iterators["destroyPrimitiveVariable"]=false
besharp_oop_type_AssocArrayContainer_method_is_calling_parent["destroyPrimitiveVariable"]=false
besharp_oop_type_AssocArrayContainer_method_is_calling_this["destroyPrimitiveVariable"]=true

fi
if ${beshfile_section__code:-false}; then :;
AssocArrayContainer ()
{
    @parent
}
AssocArrayContainer.declarePrimitiveVariable ()
{
    declare -Ag "${this}"
}
AssocArrayContainer.destroyPrimitiveVariable ()
{
    unset "${this}"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["IndexedArrayCollection"]='true'
besharp_oop_type_abstract["IndexedArrayCollection"]='true'
besharp_oop_type_is["IndexedArrayCollection"]='class'
besharp_oop_types["IndexedArrayCollection"]="IndexedArrayCollection"
declare -Ag besharp_oop_type_IndexedArrayCollection_interfaces
besharp_oop_classes["IndexedArrayCollection"]="IndexedArrayCollection"
besharp_oop_type_parent["IndexedArrayCollection"]="PrimitiveCollection"
declare -Ag besharp_oop_type_IndexedArrayCollection_fields
declare -Ag besharp_oop_type_IndexedArrayCollection_injectable_fields
declare -Ag besharp_oop_type_IndexedArrayCollection_field_type
declare -Ag besharp_oop_type_IndexedArrayCollection_field_default
declare -Ag besharp_oop_type_IndexedArrayCollection_methods
declare -Ag besharp_oop_type_IndexedArrayCollection_method_body
declare -Ag besharp_oop_type_IndexedArrayCollection_method_locals
declare -Ag besharp_oop_type_IndexedArrayCollection_method_is_returning
declare -Ag besharp_oop_type_IndexedArrayCollection_method_is_abstract
declare -Ag besharp_oop_type_IndexedArrayCollection_method_is_using_iterators
declare -Ag besharp_oop_type_IndexedArrayCollection_method_is_calling_parent
declare -Ag besharp_oop_type_IndexedArrayCollection_method_is_calling_this
besharp_oop_type_IndexedArrayCollection_methods['IndexedArrayCollection']='IndexedArrayCollection'
besharp_oop_type_IndexedArrayCollection_method_is_returning["IndexedArrayCollection"]=false
besharp_oop_type_IndexedArrayCollection_method_body["IndexedArrayCollection"]='    @parent'
besharp_oop_type_IndexedArrayCollection_method_locals["IndexedArrayCollection"]=''
besharp_oop_type_IndexedArrayCollection_method_is_using_iterators["IndexedArrayCollection"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_parent["IndexedArrayCollection"]=true
besharp_oop_type_IndexedArrayCollection_method_is_calling_this["IndexedArrayCollection"]=false
besharp_oop_type_IndexedArrayCollection_methods['add']='add'
besharp_oop_type_IndexedArrayCollection_method_is_returning["add"]=false
besharp_oop_type_IndexedArrayCollection_method_body["add"]='    local item="${1}";
    eval "${this}+=( \"\${item}\" )"'
besharp_oop_type_IndexedArrayCollection_method_locals["add"]=''
besharp_oop_type_IndexedArrayCollection_method_is_using_iterators["add"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_parent["add"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_this["add"]=true
besharp_oop_type_IndexedArrayCollection_methods['declarePrimitiveVariable']='declarePrimitiveVariable'
besharp_oop_type_IndexedArrayCollection_method_is_returning["declarePrimitiveVariable"]=false
besharp_oop_type_IndexedArrayCollection_method_body["declarePrimitiveVariable"]='    declare -a "${this}"'
besharp_oop_type_IndexedArrayCollection_method_locals["declarePrimitiveVariable"]=''
besharp_oop_type_IndexedArrayCollection_method_is_using_iterators["declarePrimitiveVariable"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_parent["declarePrimitiveVariable"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_this["declarePrimitiveVariable"]=true
besharp_oop_type_IndexedArrayCollection_methods['destroyPrimitiveVariable']='destroyPrimitiveVariable'
besharp_oop_type_IndexedArrayCollection_method_is_returning["destroyPrimitiveVariable"]=false
besharp_oop_type_IndexedArrayCollection_method_body["destroyPrimitiveVariable"]='    unset "${this}"'
besharp_oop_type_IndexedArrayCollection_method_locals["destroyPrimitiveVariable"]=''
besharp_oop_type_IndexedArrayCollection_method_is_using_iterators["destroyPrimitiveVariable"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_parent["destroyPrimitiveVariable"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_this["destroyPrimitiveVariable"]=true
besharp_oop_type_IndexedArrayCollection_methods['hasIndex']='hasIndex'
besharp_oop_type_IndexedArrayCollection_method_is_returning["hasIndex"]=true
besharp_oop_type_IndexedArrayCollection_method_body["hasIndex"]='    local index="${1}";
    if (( index < 0 )); then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    local isset;
    eval "isset=\${${this}[${index}]+isset}";
    if [[ "${isset}" == '"'"'isset'"'"' ]]; then
        besharp_rcrvs[besharp_rcsl]=true;
    else
        besharp_rcrvs[besharp_rcsl]=false;
    fi'
besharp_oop_type_IndexedArrayCollection_method_locals["hasIndex"]=''
besharp_oop_type_IndexedArrayCollection_method_is_using_iterators["hasIndex"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_parent["hasIndex"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_this["hasIndex"]=true
besharp_oop_type_IndexedArrayCollection_methods['hasKey']='hasKey'
besharp_oop_type_IndexedArrayCollection_method_is_returning["hasKey"]=true
besharp_oop_type_IndexedArrayCollection_method_body["hasKey"]='    besharp.returningOf $this.hasIndex "${@}"'
besharp_oop_type_IndexedArrayCollection_method_locals["hasKey"]=''
besharp_oop_type_IndexedArrayCollection_method_is_using_iterators["hasKey"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_parent["hasKey"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_this["hasKey"]=true
besharp_oop_type_IndexedArrayCollection_methods['indices']='indices'
besharp_oop_type_IndexedArrayCollection_method_is_returning["indices"]=true
besharp_oop_type_IndexedArrayCollection_method_body["indices"]='    local indices ;
    local myself;
    declare -n myself="${this}";
    __be__indices @new ArrayVector;
    $indices.setPlain ${!myself[@]};
    besharp_rcrvs[besharp_rcsl]=$indices'
besharp_oop_type_IndexedArrayCollection_method_locals["indices"]='local indices'
besharp_oop_type_IndexedArrayCollection_method_is_using_iterators["indices"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_parent["indices"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_this["indices"]=true
besharp_oop_type_IndexedArrayCollection_methods['keys']='keys'
besharp_oop_type_IndexedArrayCollection_method_is_returning["keys"]=true
besharp_oop_type_IndexedArrayCollection_method_body["keys"]='    besharp.returningOf $this.indices'
besharp_oop_type_IndexedArrayCollection_method_locals["keys"]=''
besharp_oop_type_IndexedArrayCollection_method_is_using_iterators["keys"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_parent["keys"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_this["keys"]=true
besharp_oop_type_IndexedArrayCollection_methods['remove']='remove'
besharp_oop_type_IndexedArrayCollection_method_is_returning["remove"]=true
besharp_oop_type_IndexedArrayCollection_method_body["remove"]='    local item="${1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    besharp_rcrvs[besharp_rcsl]=false;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        if @same "${temp[$idx]}" "${item}"; then
            unset "${this}[${idx}]";
            besharp_rcrvs[besharp_rcsl]=true;
        fi;
    done'
besharp_oop_type_IndexedArrayCollection_method_locals["remove"]=''
besharp_oop_type_IndexedArrayCollection_method_is_using_iterators["remove"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_parent["remove"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_this["remove"]=true
besharp_oop_type_IndexedArrayCollection_methods['reverse']='reverse'
besharp_oop_type_IndexedArrayCollection_method_is_returning["reverse"]=true
besharp_oop_type_IndexedArrayCollection_method_body["reverse"]='    local size ;
    __be__size $this.size;
    if (( size < 2 )); then
        return;
    fi;
    local indices=();
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        indices+=("${idx}");
    done;
    local idx1;
    local idx2;
    local tmpValue;
    for idx in "${!indices[@]}";
    do
        idx1="${indices[idx]}";
        idx2="${indices[size - 1 - idx]}";
        if (( idx1 >= idx2 )); then
            break;
        fi;
        eval "tmpValue=\"\${${this}[idx1]}\"";
        eval "${this}[idx1]=\"\${${this}[idx2]}\"";
        eval "${this}[idx2]=\"\${tmpValue}\"";
    done'
besharp_oop_type_IndexedArrayCollection_method_locals["reverse"]='local size'
besharp_oop_type_IndexedArrayCollection_method_is_using_iterators["reverse"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_parent["reverse"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_this["reverse"]=true
besharp_oop_type_IndexedArrayCollection_methods['rotate']='rotate'
besharp_oop_type_IndexedArrayCollection_method_is_returning["rotate"]=true
besharp_oop_type_IndexedArrayCollection_method_body["rotate"]='    local size ;
    local distance="${1}";
    __be__size $this.size;
    distance=$(( distance % size ));
    if (( distance < 0 )); then
        (( distance += size ));
    fi;
    if (( distance == 0 )) || (( size < 2 )); then
        return;
    fi;
    local indices=();
    local values=();
    local position=0;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        eval "local value=\${${this}[\${idx}]}";
        indices+=("${idx}");
        if (( ++position <= distance )); then
            values+=("${value}");
        else
            local targetIdx=${indices[position - distance - 1]};
            eval "${this}[${targetIdx}]=\${${this}[${idx}]}";
        fi;
    done;
    local i;
    for ((i=0; i < distance; ++i ))
    do
        local targetIdx="${indices[size - distance + i]}";
        eval "${this}[${targetIdx}]=\${values[${i}]}";
    done'
besharp_oop_type_IndexedArrayCollection_method_locals["rotate"]='local size'
besharp_oop_type_IndexedArrayCollection_method_is_using_iterators["rotate"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_parent["rotate"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_this["rotate"]=true
besharp_oop_type_IndexedArrayCollection_methods['swapIndices']='swapIndices'
besharp_oop_type_IndexedArrayCollection_method_is_returning["swapIndices"]=false
besharp_oop_type_IndexedArrayCollection_method_body["swapIndices"]='    $this.swapElements "${@}"'
besharp_oop_type_IndexedArrayCollection_method_locals["swapIndices"]=''
besharp_oop_type_IndexedArrayCollection_method_is_using_iterators["swapIndices"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_parent["swapIndices"]=false
besharp_oop_type_IndexedArrayCollection_method_is_calling_this["swapIndices"]=true

fi
if ${beshfile_section__code:-false}; then :;
function __be__indices() {
  "${@}"
  indices="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
IndexedArrayCollection ()
{
    @parent
}
IndexedArrayCollection.add ()
{
    local item="${1}";
    eval "${this}+=( \"\${item}\" )"
}
IndexedArrayCollection.declarePrimitiveVariable ()
{
    declare -a "${this}"
}
IndexedArrayCollection.destroyPrimitiveVariable ()
{
    unset "${this}"
}
IndexedArrayCollection.hasIndex ()
{
    local index="${1}";
    if (( index < 0 )); then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    local isset;
    eval "isset=\${${this}[${index}]+isset}";
    if [[ "${isset}" == 'isset' ]]; then
        besharp_rcrvs[besharp_rcsl]=true;
    else
        besharp_rcrvs[besharp_rcsl]=false;
    fi
}
IndexedArrayCollection.hasKey ()
{
    besharp.returningOf $this.hasIndex "${@}"
}
IndexedArrayCollection.indices ()
{
    local indices;
    local myself;
    declare -n myself="${this}";
    __be__indices @new ArrayVector;
    $indices.setPlain ${!myself[@]};
    besharp_rcrvs[besharp_rcsl]=$indices
}
IndexedArrayCollection.keys ()
{
    besharp.returningOf $this.indices
}
IndexedArrayCollection.remove ()
{
    local item="${1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    besharp_rcrvs[besharp_rcsl]=false;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        if @same "${temp[$idx]}" "${item}"; then
            unset "${this}[${idx}]";
            besharp_rcrvs[besharp_rcsl]=true;
        fi;
    done
}
IndexedArrayCollection.reverse ()
{
    local size;
    __be__size $this.size;
    if (( size < 2 )); then
        return;
    fi;
    local indices=();
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        indices+=("${idx}");
    done;
    local idx1;
    local idx2;
    local tmpValue;
    for idx in "${!indices[@]}";
    do
        idx1="${indices[idx]}";
        idx2="${indices[size - 1 - idx]}";
        if (( idx1 >= idx2 )); then
            break;
        fi;
        eval "tmpValue=\"\${${this}[idx1]}\"";
        eval "${this}[idx1]=\"\${${this}[idx2]}\"";
        eval "${this}[idx2]=\"\${tmpValue}\"";
    done
}
IndexedArrayCollection.rotate ()
{
    local size;
    local distance="${1}";
    __be__size $this.size;
    distance=$(( distance % size ));
    if (( distance < 0 )); then
        (( distance += size ));
    fi;
    if (( distance == 0 )) || (( size < 2 )); then
        return;
    fi;
    local indices=();
    local values=();
    local position=0;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        eval "local value=\${${this}[\${idx}]}";
        indices+=("${idx}");
        if (( ++position <= distance )); then
            values+=("${value}");
        else
            local targetIdx=${indices[position - distance - 1]};
            eval "${this}[${targetIdx}]=\${${this}[${idx}]}";
        fi;
    done;
    local i;
    for ((i=0; i < distance; ++i ))
    do
        local targetIdx="${indices[size - distance + i]}";
        eval "${this}[${targetIdx}]=\${values[${i}]}";
    done
}
IndexedArrayCollection.swapIndices ()
{
    $this.swapElements "${@}"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["PrimitiveCollection"]='true'
besharp_oop_type_abstract["PrimitiveCollection"]='true'
besharp_oop_type_is["PrimitiveCollection"]='class'
besharp_oop_types["PrimitiveCollection"]="PrimitiveCollection"
declare -Ag besharp_oop_type_PrimitiveCollection_interfaces
besharp_oop_classes["PrimitiveCollection"]="PrimitiveCollection"
besharp_oop_type_parent["PrimitiveCollection"]="PrimitiveContainer"
declare -Ag besharp_oop_type_PrimitiveCollection_fields
declare -Ag besharp_oop_type_PrimitiveCollection_injectable_fields
declare -Ag besharp_oop_type_PrimitiveCollection_field_type
declare -Ag besharp_oop_type_PrimitiveCollection_field_default
declare -Ag besharp_oop_type_PrimitiveCollection_methods
declare -Ag besharp_oop_type_PrimitiveCollection_method_body
declare -Ag besharp_oop_type_PrimitiveCollection_method_locals
declare -Ag besharp_oop_type_PrimitiveCollection_method_is_returning
declare -Ag besharp_oop_type_PrimitiveCollection_method_is_abstract
declare -Ag besharp_oop_type_PrimitiveCollection_method_is_using_iterators
declare -Ag besharp_oop_type_PrimitiveCollection_method_is_calling_parent
declare -Ag besharp_oop_type_PrimitiveCollection_method_is_calling_this
besharp_oop_type_PrimitiveCollection_methods['PrimitiveCollection']='PrimitiveCollection'
besharp_oop_type_PrimitiveCollection_method_is_returning["PrimitiveCollection"]=false
besharp_oop_type_PrimitiveCollection_method_body["PrimitiveCollection"]='    @parent'
besharp_oop_type_PrimitiveCollection_method_locals["PrimitiveCollection"]=''
besharp_oop_type_PrimitiveCollection_method_is_using_iterators["PrimitiveCollection"]=false
besharp_oop_type_PrimitiveCollection_method_is_calling_parent["PrimitiveCollection"]=true
besharp_oop_type_PrimitiveCollection_method_is_calling_this["PrimitiveCollection"]=false
besharp_oop_type_PrimitiveCollection_methods['addMany']='addMany'
besharp_oop_type_PrimitiveCollection_method_is_returning["addMany"]=false
besharp_oop_type_PrimitiveCollection_method_body["addMany"]='    local item;
    while @iterate "${@}" @in item; do
        $this.add "${item}";
    done'
besharp_oop_type_PrimitiveCollection_method_locals["addMany"]='local item'
besharp_oop_type_PrimitiveCollection_method_is_using_iterators["addMany"]=true
besharp_oop_type_PrimitiveCollection_method_is_calling_parent["addMany"]=false
besharp_oop_type_PrimitiveCollection_method_is_calling_this["addMany"]=true

fi
if ${beshfile_section__code:-false}; then :;
PrimitiveCollection ()
{
    @parent
}
PrimitiveCollection.addMany ()
{
    local item;
    while @iterate "${@}" @in item; do
        $this.add "${item}";
    done
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["PrimitiveContainer"]='true'
besharp_oop_type_abstract["PrimitiveContainer"]='true'
besharp_oop_type_is["PrimitiveContainer"]='class'
besharp_oop_types["PrimitiveContainer"]="PrimitiveContainer"
declare -Ag besharp_oop_type_PrimitiveContainer_interfaces
besharp_oop_classes["PrimitiveContainer"]="PrimitiveContainer"
besharp_oop_type_parent["PrimitiveContainer"]="PrimitiveObject"
declare -Ag besharp_oop_type_PrimitiveContainer_fields
declare -Ag besharp_oop_type_PrimitiveContainer_injectable_fields
declare -Ag besharp_oop_type_PrimitiveContainer_field_type
declare -Ag besharp_oop_type_PrimitiveContainer_field_default
declare -Ag besharp_oop_type_PrimitiveContainer_methods
declare -Ag besharp_oop_type_PrimitiveContainer_method_body
declare -Ag besharp_oop_type_PrimitiveContainer_method_locals
declare -Ag besharp_oop_type_PrimitiveContainer_method_is_returning
declare -Ag besharp_oop_type_PrimitiveContainer_method_is_abstract
declare -Ag besharp_oop_type_PrimitiveContainer_method_is_using_iterators
declare -Ag besharp_oop_type_PrimitiveContainer_method_is_calling_parent
declare -Ag besharp_oop_type_PrimitiveContainer_method_is_calling_this
besharp_oop_type_PrimitiveContainer_fields['owningItems']='owningItems'
besharp_oop_type_PrimitiveContainer_field_default['owningItems']="false"
besharp_oop_type_PrimitiveContainer_methods['PrimitiveContainer']='PrimitiveContainer'
besharp_oop_type_PrimitiveContainer_method_is_returning["PrimitiveContainer"]=false
besharp_oop_type_PrimitiveContainer_method_body["PrimitiveContainer"]='    @parent'
besharp_oop_type_PrimitiveContainer_method_locals["PrimitiveContainer"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["PrimitiveContainer"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["PrimitiveContainer"]=true
besharp_oop_type_PrimitiveContainer_method_is_calling_this["PrimitiveContainer"]=false
besharp_oop_type_PrimitiveContainer_methods['__cloneFrom']='__cloneFrom'
besharp_oop_type_PrimitiveContainer_method_is_returning["__cloneFrom"]=false
besharp_oop_type_PrimitiveContainer_method_body["__cloneFrom"]='    local value ;
    local source="${1}";
    local mode="${2}";
    unset "${this}[@]";
    $this.declarePrimitiveVariable "${@}";
    if [[ "${mode}" == "" ]] || [[ "${mode}" == "shallow" ]]; then
        local temp;
        declare -n temp="${source}";
        local idx;
        for idx in "${!temp[@]}";
        do
            eval "${this}[\"\$idx\"]=\"\${temp[\"\$idx\"]}\"";
        done;
    else
        if [[ "${mode}" == "deep" ]]; then
            local temp;
            declare -n temp="${source}";
            local idx;
            for idx in "${!temp[@]}";
            do
                local value;
                eval "value=\"\${temp[\"\$idx\"]}\"";
                if besharp.rtti.isObjectExist "${value}"; then
                    __be__value @clone $value;
                fi;
                eval "${this}[\"\$idx\"]=\"\${value}\"";
            done;
        else
            if [[ "${mode}" == "@in-place" ]]; then
                local temp;
                declare -n temp="${this}";
                local idx;
                for idx in "${!temp[@]}";
                do
                    local value;
                    eval "value=\"\${temp[\"\$idx\"]}\"";
                    if besharp.rtti.isObjectExist "${value}"; then
                        __be__value @clone $value;
                        eval "${this}[\"\$idx\"]=\"\${value}\"";
                    fi;
                done;
            else
                besharp.runtime.error "Unknown @clone mode: '"'"'$mode'"'"'. Expected one of: '"'"'shallow'"'"', '"'"'deep'"'"', '"'"'in-place'"'"'.";
            fi;
        fi;
    fi'
besharp_oop_type_PrimitiveContainer_method_locals["__cloneFrom"]='local value'
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["__cloneFrom"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["__cloneFrom"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["__cloneFrom"]=true
besharp_oop_type_PrimitiveContainer_methods['__destroy']='__destroy'
besharp_oop_type_PrimitiveContainer_method_is_returning["__destroy"]=false
besharp_oop_type_PrimitiveContainer_method_body["__destroy"]='    $this.destroyOwningItems;
    @parent'
besharp_oop_type_PrimitiveContainer_method_locals["__destroy"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["__destroy"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["__destroy"]=true
besharp_oop_type_PrimitiveContainer_method_is_calling_this["__destroy"]=true
besharp_oop_type_PrimitiveContainer_methods['destroyOwningItems']='destroyOwningItems'
besharp_oop_type_PrimitiveContainer_method_is_returning["destroyOwningItems"]=false
besharp_oop_type_PrimitiveContainer_method_body["destroyOwningItems"]='    if @true $this.isOwningItems; then
        local item;
        while @iterate $this @in item; do
            if @exists "${item}"; then
                @unset "${item}";
            fi;
        done;
    fi'
besharp_oop_type_PrimitiveContainer_method_locals["destroyOwningItems"]='local item'
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["destroyOwningItems"]=true
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["destroyOwningItems"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["destroyOwningItems"]=true
besharp_oop_type_PrimitiveContainer_methods['fill']='fill'
besharp_oop_type_PrimitiveContainer_method_is_returning["fill"]=false
besharp_oop_type_PrimitiveContainer_method_body["fill"]='    local item="${1}";
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        eval "${this}[${idx}]=\"\${item}\"";
    done'
besharp_oop_type_PrimitiveContainer_method_locals["fill"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["fill"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["fill"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["fill"]=true
besharp_oop_type_PrimitiveContainer_methods['frequency']='frequency'
besharp_oop_type_PrimitiveContainer_method_is_returning["frequency"]=true
besharp_oop_type_PrimitiveContainer_method_body["frequency"]='    local item="${1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=0;
        return;
    fi;
    local frequency=0;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        if @same "${temp[$idx]}" "${item}"; then
            (( ++ frequency ));
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=${frequency}'
besharp_oop_type_PrimitiveContainer_method_locals["frequency"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["frequency"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["frequency"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["frequency"]=true
besharp_oop_type_PrimitiveContainer_methods['get']='get'
besharp_oop_type_PrimitiveContainer_method_is_returning["get"]=true
besharp_oop_type_PrimitiveContainer_method_body["get"]='    local key="${1}";
    local isset;
    eval "isset=\${${this}[\"${key}\"]+isset}";
    if [[ "${isset}" != '"'"'isset'"'"' ]]; then
        besharp.runtime.error "Missing '"'"'${key}'"'"' key in ${this} container! Please call ${this}.has() to prevent!";
    fi;
    local item;
    eval "item=\"\${${this}[\"${key}\"]}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"'
besharp_oop_type_PrimitiveContainer_method_locals["get"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["get"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["get"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["get"]=true
besharp_oop_type_PrimitiveContainer_methods['has']='has'
besharp_oop_type_PrimitiveContainer_method_is_returning["has"]=true
besharp_oop_type_PrimitiveContainer_method_body["has"]='    local item="${1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    local x;
    for x in "${!var}";
    do
        if @same "${x}" "${item}"; then
            besharp_rcrvs[besharp_rcsl]=true;
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_PrimitiveContainer_method_locals["has"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["has"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["has"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["has"]=true
besharp_oop_type_PrimitiveContainer_methods['hasAll']='hasAll'
besharp_oop_type_PrimitiveContainer_method_is_returning["hasAll"]=true
besharp_oop_type_PrimitiveContainer_method_body["hasAll"]='    if @true $this.isEmpty; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    local item;
    while @iterate "${@}" @in item; do
        if @false $this.has "${item}"; then
            besharp_rcrvs[besharp_rcsl]=false;
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=true'
besharp_oop_type_PrimitiveContainer_method_locals["hasAll"]='local item'
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["hasAll"]=true
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["hasAll"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["hasAll"]=true
besharp_oop_type_PrimitiveContainer_methods['hasSome']='hasSome'
besharp_oop_type_PrimitiveContainer_method_is_returning["hasSome"]=true
besharp_oop_type_PrimitiveContainer_method_body["hasSome"]='    local item;
    while @iterate "${@}" @in item; do
        if @true $this.has "${item}"; then
            besharp_rcrvs[besharp_rcsl]=true;
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_PrimitiveContainer_method_locals["hasSome"]='local item'
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["hasSome"]=true
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["hasSome"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["hasSome"]=true
besharp_oop_type_PrimitiveContainer_methods['isEmpty']='isEmpty'
besharp_oop_type_PrimitiveContainer_method_is_returning["isEmpty"]=true
besharp_oop_type_PrimitiveContainer_method_body["isEmpty"]='    local isset;
    eval "isset=\${${this}[@]+isset}";
    if [[ "${isset}" == '"'"'isset'"'"' ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
    else
        besharp_rcrvs[besharp_rcsl]=true;
    fi'
besharp_oop_type_PrimitiveContainer_method_locals["isEmpty"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["isEmpty"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["isEmpty"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["isEmpty"]=true
besharp_oop_type_PrimitiveContainer_methods['isOwningItems']='isOwningItems'
besharp_oop_type_PrimitiveContainer_method_is_returning["isOwningItems"]=true
besharp_oop_type_PrimitiveContainer_method_body["isOwningItems"]='    besharp.returningOf $this.owningItems'
besharp_oop_type_PrimitiveContainer_method_locals["isOwningItems"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["isOwningItems"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["isOwningItems"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["isOwningItems"]=true
besharp_oop_type_PrimitiveContainer_methods['iterationNew']='iterationNew'
besharp_oop_type_PrimitiveContainer_method_is_returning["iterationNew"]=false
besharp_oop_type_PrimitiveContainer_method_body["iterationNew"]='    ArrayIteration.iterationNew "${this}" "${@}"'
besharp_oop_type_PrimitiveContainer_method_locals["iterationNew"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["iterationNew"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["iterationNew"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["iterationNew"]=true
besharp_oop_type_PrimitiveContainer_methods['iterationNext']='iterationNext'
besharp_oop_type_PrimitiveContainer_method_is_returning["iterationNext"]=false
besharp_oop_type_PrimitiveContainer_method_body["iterationNext"]='    ArrayIteration.iterationNext "${this}" "${@}"'
besharp_oop_type_PrimitiveContainer_method_locals["iterationNext"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["iterationNext"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["iterationNext"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["iterationNext"]=true
besharp_oop_type_PrimitiveContainer_methods['iterationValue']='iterationValue'
besharp_oop_type_PrimitiveContainer_method_is_returning["iterationValue"]=false
besharp_oop_type_PrimitiveContainer_method_body["iterationValue"]='    ArrayIteration.iterationValue "${this}" "${@}"'
besharp_oop_type_PrimitiveContainer_method_locals["iterationValue"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["iterationValue"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["iterationValue"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["iterationValue"]=true
besharp_oop_type_PrimitiveContainer_methods['keys']='keys'
besharp_oop_type_PrimitiveContainer_method_is_returning["keys"]=true
besharp_oop_type_PrimitiveContainer_method_body["keys"]='    local indices ;
    local myself;
    declare -n myself="${this}";
    __be__indices @new ArrayVector;
    $indices.setPlain "${!myself[@]}";
    besharp_rcrvs[besharp_rcsl]=$indices'
besharp_oop_type_PrimitiveContainer_method_locals["keys"]='local indices'
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["keys"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["keys"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["keys"]=true
besharp_oop_type_PrimitiveContainer_methods['ownsItsItems']='ownsItsItems'
besharp_oop_type_PrimitiveContainer_method_is_returning["ownsItsItems"]=false
besharp_oop_type_PrimitiveContainer_method_body["ownsItsItems"]='    $this.owningItems = "${1:-true}"'
besharp_oop_type_PrimitiveContainer_method_locals["ownsItsItems"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["ownsItsItems"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["ownsItsItems"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["ownsItsItems"]=true
besharp_oop_type_PrimitiveContainer_methods['removeAll']='removeAll'
besharp_oop_type_PrimitiveContainer_method_is_returning["removeAll"]=false
besharp_oop_type_PrimitiveContainer_method_body["removeAll"]='    $this.destroyPrimitiveVariable;
    $this.declarePrimitiveVariable'
besharp_oop_type_PrimitiveContainer_method_locals["removeAll"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["removeAll"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["removeAll"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["removeAll"]=true
besharp_oop_type_PrimitiveContainer_methods['removeMany']='removeMany'
besharp_oop_type_PrimitiveContainer_method_is_returning["removeMany"]=false
besharp_oop_type_PrimitiveContainer_method_body["removeMany"]='    local item;
    while @iterate "${@}" @in item; do
        $this.remove "${item}";
    done'
besharp_oop_type_PrimitiveContainer_method_locals["removeMany"]='local item'
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["removeMany"]=true
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["removeMany"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["removeMany"]=true
besharp_oop_type_PrimitiveContainer_methods['replace']='replace'
besharp_oop_type_PrimitiveContainer_method_is_returning["replace"]=true
besharp_oop_type_PrimitiveContainer_method_body["replace"]='    local fromItem="${1}";
    local toItem="${2}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        if @same "${temp[$idx]}" "${fromItem}"; then
            eval "${this}[$idx]=\${toItem}";
        fi;
    done'
besharp_oop_type_PrimitiveContainer_method_locals["replace"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["replace"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["replace"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["replace"]=true
besharp_oop_type_PrimitiveContainer_methods['replaceMany']='replaceMany'
besharp_oop_type_PrimitiveContainer_method_is_returning["replaceMany"]=false
besharp_oop_type_PrimitiveContainer_method_body["replaceMany"]='    local to ;
    local replaceMap="${1}";
    local from;
    while @iterate @of $replaceMap.keys @in from; do
        __be__to $replaceMap.get "${from}";
        $this.replace "${from}" "${to}";
    done'
besharp_oop_type_PrimitiveContainer_method_locals["replaceMany"]='local from
local to'
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["replaceMany"]=true
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["replaceMany"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["replaceMany"]=true
besharp_oop_type_PrimitiveContainer_methods['show']='show'
besharp_oop_type_PrimitiveContainer_method_is_returning["show"]=true
besharp_oop_type_PrimitiveContainer_method_body["show"]='    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        echo "<EMPTY>";
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        local var="${this}[${idx}]";
        echo "| #${this} $(besharp.rtti.objectType "${this}") | ${idx} -> ${!var}";
    done'
besharp_oop_type_PrimitiveContainer_method_locals["show"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["show"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["show"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["show"]=true
besharp_oop_type_PrimitiveContainer_methods['shuffle']='shuffle'
besharp_oop_type_PrimitiveContainer_method_is_returning["shuffle"]=true
besharp_oop_type_PrimitiveContainer_method_body["shuffle"]='    local size ;
    __be__size $this.size;
    if (( size < 2 )); then
        return;
    fi;
    local indices=();
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        indices+=("${idx}");
    done;
    local index1;
    local index2;
    local tmpValue;
    for idx in "${!indices[@]}";
    do
        index1="${indices[idx]}";
        index2="${indices[RANDOM % size]}";
        if [[ "${index1}" == "${index2}" ]]; then
            continue;
        fi;
        eval "tmpValue=\"\${${this}[\${index1}]}\"";
        eval "${this}[\"\${index1}\"]=\"\${${this}[\${index2}]}\"";
        eval "${this}[\"\${index2}\"]=\"\${tmpValue}\"";
    done'
besharp_oop_type_PrimitiveContainer_method_locals["shuffle"]='local size'
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["shuffle"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["shuffle"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["shuffle"]=true
besharp_oop_type_PrimitiveContainer_methods['size']='size'
besharp_oop_type_PrimitiveContainer_method_is_returning["size"]=true
besharp_oop_type_PrimitiveContainer_method_body["size"]='    local count=0;
    local isset;
    eval "isset=\${${this}[@]+isset}";
    if [[ "${isset}" == '"'"'isset'"'"' ]]; then
        eval "count=\${#${this}[@]}";
    fi;
    besharp_rcrvs[besharp_rcsl]="${count}"'
besharp_oop_type_PrimitiveContainer_method_locals["size"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["size"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["size"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["size"]=true
besharp_oop_type_PrimitiveContainer_methods['swapElements']='swapElements'
besharp_oop_type_PrimitiveContainer_method_is_returning["swapElements"]=true
besharp_oop_type_PrimitiveContainer_method_body["swapElements"]='    local index1="${1}";
    local index2="${2}";
    if [[ "${index1}" == "${index2}" ]]; then
        return;
    fi;
    local isset1;
    eval "isset1=\"\${${this}[${index1}]+isset}\"";
    if [[ "${isset1}" != '"'"'isset'"'"' ]]; then
        besharp.runtime.error "Missing '"'"'${index1}'"'"' key in ${this} container!";
    fi;
    local isset2;
    eval "isset2=\"\${${this}[${index1}]+isset}\"";
    if [[ "${isset2}" != '"'"'isset'"'"' ]]; then
        besharp.runtime.error "Missing '"'"'${index2}'"'"' key in ${this} container!";
    fi;
    local tmpValue="";
    eval "tmpValue=\"\${${this}[\${index1}]}\"";
    eval "${this}[\${index1}]=\"\${${this}[\${index2}]}\"";
    eval "${this}[\${index2}]=\"\${tmpValue}\""'
besharp_oop_type_PrimitiveContainer_method_locals["swapElements"]=''
besharp_oop_type_PrimitiveContainer_method_is_using_iterators["swapElements"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_parent["swapElements"]=false
besharp_oop_type_PrimitiveContainer_method_is_calling_this["swapElements"]=true

fi
if ${beshfile_section__code:-false}; then :;
function __be__value() {
  "${@}"
  value="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__indices() {
  "${@}"
  indices="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__to() {
  "${@}"
  to="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__size() {
  "${@}"
  size="${besharp_rcrvs[besharp_rcsl + 1]}"
}
PrimitiveContainer ()
{
    @parent
}
PrimitiveContainer.__cloneFrom ()
{
    local value;
    local source="${1}";
    local mode="${2}";
    unset "${this}[@]";
    $this.declarePrimitiveVariable "${@}";
    if [[ "${mode}" == "" ]] || [[ "${mode}" == "shallow" ]]; then
        local temp;
        declare -n temp="${source}";
        local idx;
        for idx in "${!temp[@]}";
        do
            eval "${this}[\"\$idx\"]=\"\${temp[\"\$idx\"]}\"";
        done;
    else
        if [[ "${mode}" == "deep" ]]; then
            local temp;
            declare -n temp="${source}";
            local idx;
            for idx in "${!temp[@]}";
            do
                local value;
                eval "value=\"\${temp[\"\$idx\"]}\"";
                if besharp.rtti.isObjectExist "${value}"; then
                    __be__value @clone $value;
                fi;
                eval "${this}[\"\$idx\"]=\"\${value}\"";
            done;
        else
            if [[ "${mode}" == "@in-place" ]]; then
                local temp;
                declare -n temp="${this}";
                local idx;
                for idx in "${!temp[@]}";
                do
                    local value;
                    eval "value=\"\${temp[\"\$idx\"]}\"";
                    if besharp.rtti.isObjectExist "${value}"; then
                        __be__value @clone $value;
                        eval "${this}[\"\$idx\"]=\"\${value}\"";
                    fi;
                done;
            else
                besharp.runtime.error "Unknown @clone mode: '$mode'. Expected one of: 'shallow', 'deep', 'in-place'.";
            fi;
        fi;
    fi
}
PrimitiveContainer.__destroy ()
{
    $this.destroyOwningItems;
    @parent
}
PrimitiveContainer.destroyOwningItems ()
{
    if @true $this.isOwningItems; then
        local item;
        while @iterate $this @in item; do
            if @exists "${item}"; then
                @unset "${item}";
            fi;
        done;
    fi
}
PrimitiveContainer.fill ()
{
    local item="${1}";
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        eval "${this}[${idx}]=\"\${item}\"";
    done
}
PrimitiveContainer.frequency ()
{
    local item="${1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=0;
        return;
    fi;
    local frequency=0;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        if @same "${temp[$idx]}" "${item}"; then
            (( ++ frequency ));
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=${frequency}
}
PrimitiveContainer.get ()
{
    local key="${1}";
    local isset;
    eval "isset=\${${this}[\"${key}\"]+isset}";
    if [[ "${isset}" != 'isset' ]]; then
        besharp.runtime.error "Missing '${key}' key in ${this} container! Please call ${this}.has() to prevent!";
    fi;
    local item;
    eval "item=\"\${${this}[\"${key}\"]}\"";
    besharp_rcrvs[besharp_rcsl]="${item}"
}
PrimitiveContainer.has ()
{
    local item="${1}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    local x;
    for x in "${!var}";
    do
        if @same "${x}" "${item}"; then
            besharp_rcrvs[besharp_rcsl]=true;
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=false
}
PrimitiveContainer.hasAll ()
{
    if @true $this.isEmpty; then
        besharp_rcrvs[besharp_rcsl]=false;
        return;
    fi;
    local item;
    while @iterate "${@}" @in item; do
        if @false $this.has "${item}"; then
            besharp_rcrvs[besharp_rcsl]=false;
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=true
}
PrimitiveContainer.hasSome ()
{
    local item;
    while @iterate "${@}" @in item; do
        if @true $this.has "${item}"; then
            besharp_rcrvs[besharp_rcsl]=true;
            return;
        fi;
    done;
    besharp_rcrvs[besharp_rcsl]=false
}
PrimitiveContainer.isEmpty ()
{
    local isset;
    eval "isset=\${${this}[@]+isset}";
    if [[ "${isset}" == 'isset' ]]; then
        besharp_rcrvs[besharp_rcsl]=false;
    else
        besharp_rcrvs[besharp_rcsl]=true;
    fi
}
PrimitiveContainer.isOwningItems ()
{
    besharp.returningOf $this.owningItems
}
PrimitiveContainer.iterationNew ()
{
    ArrayIteration.iterationNew "${this}" "${@}"
}
PrimitiveContainer.iterationNext ()
{
    ArrayIteration.iterationNext "${this}" "${@}"
}
PrimitiveContainer.iterationValue ()
{
    ArrayIteration.iterationValue "${this}" "${@}"
}
PrimitiveContainer.keys ()
{
    local indices;
    local myself;
    declare -n myself="${this}";
    __be__indices @new ArrayVector;
    $indices.setPlain "${!myself[@]}";
    besharp_rcrvs[besharp_rcsl]=$indices
}
PrimitiveContainer.ownsItsItems ()
{
    $this.owningItems = "${1:-true}"
}
PrimitiveContainer.removeAll ()
{
    $this.destroyPrimitiveVariable;
    $this.declarePrimitiveVariable
}
PrimitiveContainer.removeMany ()
{
    local item;
    while @iterate "${@}" @in item; do
        $this.remove "${item}";
    done
}
PrimitiveContainer.replace ()
{
    local fromItem="${1}";
    local toItem="${2}";
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        if @same "${temp[$idx]}" "${fromItem}"; then
            eval "${this}[$idx]=\${toItem}";
        fi;
    done
}
PrimitiveContainer.replaceMany ()
{
    local to;
    local replaceMap="${1}";
    local from;
    while @iterate @of $replaceMap.keys @in from; do
        __be__to $replaceMap.get "${from}";
        $this.replace "${from}" "${to}";
    done
}
PrimitiveContainer.show ()
{
    local var="${this}[@]";
    if [[ "${!var+isset}" != "isset" ]]; then
        echo "<EMPTY>";
        return;
    fi;
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        local var="${this}[${idx}]";
        echo "| #${this} $(besharp.rtti.objectType "${this}") | ${idx} -> ${!var}";
    done
}
PrimitiveContainer.shuffle ()
{
    local size;
    __be__size $this.size;
    if (( size < 2 )); then
        return;
    fi;
    local indices=();
    local temp;
    declare -n temp="${this}";
    local idx;
    for idx in "${!temp[@]}";
    do
        indices+=("${idx}");
    done;
    local index1;
    local index2;
    local tmpValue;
    for idx in "${!indices[@]}";
    do
        index1="${indices[idx]}";
        index2="${indices[RANDOM % size]}";
        if [[ "${index1}" == "${index2}" ]]; then
            continue;
        fi;
        eval "tmpValue=\"\${${this}[\${index1}]}\"";
        eval "${this}[\"\${index1}\"]=\"\${${this}[\${index2}]}\"";
        eval "${this}[\"\${index2}\"]=\"\${tmpValue}\"";
    done
}
PrimitiveContainer.size ()
{
    local count=0;
    local isset;
    eval "isset=\${${this}[@]+isset}";
    if [[ "${isset}" == 'isset' ]]; then
        eval "count=\${#${this}[@]}";
    fi;
    besharp_rcrvs[besharp_rcsl]="${count}"
}
PrimitiveContainer.swapElements ()
{
    local index1="${1}";
    local index2="${2}";
    if [[ "${index1}" == "${index2}" ]]; then
        return;
    fi;
    local isset1;
    eval "isset1=\"\${${this}[${index1}]+isset}\"";
    if [[ "${isset1}" != 'isset' ]]; then
        besharp.runtime.error "Missing '${index1}' key in ${this} container!";
    fi;
    local isset2;
    eval "isset2=\"\${${this}[${index1}]+isset}\"";
    if [[ "${isset2}" != 'isset' ]]; then
        besharp.runtime.error "Missing '${index2}' key in ${this} container!";
    fi;
    local tmpValue="";
    eval "tmpValue=\"\${${this}[\${index1}]}\"";
    eval "${this}[\${index1}]=\"\${${this}[\${index2}]}\"";
    eval "${this}[\${index2}]=\"\${tmpValue}\""
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["AbstractEmptyCollection"]='true'
besharp_oop_type_abstract["AbstractEmptyCollection"]='true'
besharp_oop_type_is["AbstractEmptyCollection"]='class'
besharp_oop_types["AbstractEmptyCollection"]="AbstractEmptyCollection"
declare -Ag besharp_oop_type_AbstractEmptyCollection_interfaces
besharp_oop_type_AbstractEmptyCollection_interfaces['Collection']='Collection'
besharp_oop_type_AbstractEmptyCollection_interfaces['IterableByKeys']='IterableByKeys'
besharp_oop_classes["AbstractEmptyCollection"]="AbstractEmptyCollection"
besharp_oop_type_parent["AbstractEmptyCollection"]="Object"
declare -Ag besharp_oop_type_AbstractEmptyCollection_fields
declare -Ag besharp_oop_type_AbstractEmptyCollection_injectable_fields
declare -Ag besharp_oop_type_AbstractEmptyCollection_field_type
declare -Ag besharp_oop_type_AbstractEmptyCollection_field_default
declare -Ag besharp_oop_type_AbstractEmptyCollection_methods
declare -Ag besharp_oop_type_AbstractEmptyCollection_method_body
declare -Ag besharp_oop_type_AbstractEmptyCollection_method_locals
declare -Ag besharp_oop_type_AbstractEmptyCollection_method_is_returning
declare -Ag besharp_oop_type_AbstractEmptyCollection_method_is_abstract
declare -Ag besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators
declare -Ag besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent
declare -Ag besharp_oop_type_AbstractEmptyCollection_method_is_calling_this
besharp_oop_type_AbstractEmptyCollection_methods['AbstractEmptyCollection']='AbstractEmptyCollection'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["AbstractEmptyCollection"]=false
besharp_oop_type_AbstractEmptyCollection_method_body["AbstractEmptyCollection"]='    @parent'
besharp_oop_type_AbstractEmptyCollection_method_locals["AbstractEmptyCollection"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["AbstractEmptyCollection"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["AbstractEmptyCollection"]=true
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["AbstractEmptyCollection"]=false
besharp_oop_type_AbstractEmptyCollection_methods['add']='add'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["add"]=false
besharp_oop_type_AbstractEmptyCollection_method_body["add"]='    besharp.runtime.error "You cannot add!"'
besharp_oop_type_AbstractEmptyCollection_method_locals["add"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["add"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["add"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["add"]=false
besharp_oop_type_AbstractEmptyCollection_methods['addMany']='addMany'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["addMany"]=false
besharp_oop_type_AbstractEmptyCollection_method_body["addMany"]='    besharp.runtime.error "You cannot addMany!"'
besharp_oop_type_AbstractEmptyCollection_method_locals["addMany"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["addMany"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["addMany"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["addMany"]=false
besharp_oop_type_AbstractEmptyCollection_methods['fill']='fill'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["fill"]=false
besharp_oop_type_AbstractEmptyCollection_method_body["fill"]='    :'
besharp_oop_type_AbstractEmptyCollection_method_locals["fill"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["fill"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["fill"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["fill"]=false
besharp_oop_type_AbstractEmptyCollection_methods['frequency']='frequency'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["frequency"]=true
besharp_oop_type_AbstractEmptyCollection_method_body["frequency"]='    besharp_rcrvs[besharp_rcsl]=0'
besharp_oop_type_AbstractEmptyCollection_method_locals["frequency"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["frequency"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["frequency"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["frequency"]=false
besharp_oop_type_AbstractEmptyCollection_methods['get']='get'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["get"]=false
besharp_oop_type_AbstractEmptyCollection_method_body["get"]='    besharp.runtime.error "Nothing to get!"'
besharp_oop_type_AbstractEmptyCollection_method_locals["get"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["get"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["get"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["get"]=false
besharp_oop_type_AbstractEmptyCollection_methods['has']='has'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["has"]=true
besharp_oop_type_AbstractEmptyCollection_method_body["has"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_AbstractEmptyCollection_method_locals["has"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["has"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["has"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["has"]=false
besharp_oop_type_AbstractEmptyCollection_methods['hasAll']='hasAll'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["hasAll"]=true
besharp_oop_type_AbstractEmptyCollection_method_body["hasAll"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_AbstractEmptyCollection_method_locals["hasAll"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["hasAll"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["hasAll"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["hasAll"]=false
besharp_oop_type_AbstractEmptyCollection_methods['hasKey']='hasKey'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["hasKey"]=true
besharp_oop_type_AbstractEmptyCollection_method_body["hasKey"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_AbstractEmptyCollection_method_locals["hasKey"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["hasKey"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["hasKey"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["hasKey"]=false
besharp_oop_type_AbstractEmptyCollection_methods['hasSome']='hasSome'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["hasSome"]=true
besharp_oop_type_AbstractEmptyCollection_method_body["hasSome"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_AbstractEmptyCollection_method_locals["hasSome"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["hasSome"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["hasSome"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["hasSome"]=false
besharp_oop_type_AbstractEmptyCollection_methods['isEmpty']='isEmpty'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["isEmpty"]=true
besharp_oop_type_AbstractEmptyCollection_method_body["isEmpty"]='    besharp_rcrvs[besharp_rcsl]=true'
besharp_oop_type_AbstractEmptyCollection_method_locals["isEmpty"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["isEmpty"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["isEmpty"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["isEmpty"]=false
besharp_oop_type_AbstractEmptyCollection_methods['isOwningItems']='isOwningItems'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["isOwningItems"]=true
besharp_oop_type_AbstractEmptyCollection_method_body["isOwningItems"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_AbstractEmptyCollection_method_locals["isOwningItems"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["isOwningItems"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["isOwningItems"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["isOwningItems"]=false
besharp_oop_type_AbstractEmptyCollection_methods['iterationNew']='iterationNew'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["iterationNew"]=true
besharp_oop_type_AbstractEmptyCollection_method_body["iterationNew"]='    besharp_rcrvs[besharp_rcsl]=""'
besharp_oop_type_AbstractEmptyCollection_method_locals["iterationNew"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["iterationNew"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["iterationNew"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["iterationNew"]=false
besharp_oop_type_AbstractEmptyCollection_methods['iterationNext']='iterationNext'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["iterationNext"]=true
besharp_oop_type_AbstractEmptyCollection_method_body["iterationNext"]='    besharp_rcrvs[besharp_rcsl]=""'
besharp_oop_type_AbstractEmptyCollection_method_locals["iterationNext"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["iterationNext"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["iterationNext"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["iterationNext"]=false
besharp_oop_type_AbstractEmptyCollection_methods['iterationValue']='iterationValue'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["iterationValue"]=false
besharp_oop_type_AbstractEmptyCollection_method_body["iterationValue"]='    besharp.runtime.error "Has no values!"'
besharp_oop_type_AbstractEmptyCollection_method_locals["iterationValue"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["iterationValue"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["iterationValue"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["iterationValue"]=false
besharp_oop_type_AbstractEmptyCollection_methods['keys']='keys'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["keys"]=true
besharp_oop_type_AbstractEmptyCollection_method_body["keys"]='    besharp_rcrvs[besharp_rcsl]=$this'
besharp_oop_type_AbstractEmptyCollection_method_locals["keys"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["keys"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["keys"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["keys"]=true
besharp_oop_type_AbstractEmptyCollection_methods['ownsItsItems']='ownsItsItems'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["ownsItsItems"]=false
besharp_oop_type_AbstractEmptyCollection_method_body["ownsItsItems"]='    :'
besharp_oop_type_AbstractEmptyCollection_method_locals["ownsItsItems"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["ownsItsItems"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["ownsItsItems"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["ownsItsItems"]=false
besharp_oop_type_AbstractEmptyCollection_methods['remove']='remove'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["remove"]=true
besharp_oop_type_AbstractEmptyCollection_method_body["remove"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_AbstractEmptyCollection_method_locals["remove"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["remove"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["remove"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["remove"]=false
besharp_oop_type_AbstractEmptyCollection_methods['removeAll']='removeAll'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["removeAll"]=false
besharp_oop_type_AbstractEmptyCollection_method_body["removeAll"]='    :'
besharp_oop_type_AbstractEmptyCollection_method_locals["removeAll"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["removeAll"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["removeAll"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["removeAll"]=false
besharp_oop_type_AbstractEmptyCollection_methods['removeMany']='removeMany'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["removeMany"]=true
besharp_oop_type_AbstractEmptyCollection_method_body["removeMany"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_AbstractEmptyCollection_method_locals["removeMany"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["removeMany"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["removeMany"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["removeMany"]=false
besharp_oop_type_AbstractEmptyCollection_methods['replace']='replace'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["replace"]=false
besharp_oop_type_AbstractEmptyCollection_method_body["replace"]='    :'
besharp_oop_type_AbstractEmptyCollection_method_locals["replace"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["replace"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["replace"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["replace"]=false
besharp_oop_type_AbstractEmptyCollection_methods['replaceMany']='replaceMany'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["replaceMany"]=false
besharp_oop_type_AbstractEmptyCollection_method_body["replaceMany"]='    :'
besharp_oop_type_AbstractEmptyCollection_method_locals["replaceMany"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["replaceMany"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["replaceMany"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["replaceMany"]=false
besharp_oop_type_AbstractEmptyCollection_methods['shuffle']='shuffle'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["shuffle"]=false
besharp_oop_type_AbstractEmptyCollection_method_body["shuffle"]='    :'
besharp_oop_type_AbstractEmptyCollection_method_locals["shuffle"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["shuffle"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["shuffle"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["shuffle"]=false
besharp_oop_type_AbstractEmptyCollection_methods['size']='size'
besharp_oop_type_AbstractEmptyCollection_method_is_returning["size"]=true
besharp_oop_type_AbstractEmptyCollection_method_body["size"]='    besharp_rcrvs[besharp_rcsl]=0'
besharp_oop_type_AbstractEmptyCollection_method_locals["size"]=''
besharp_oop_type_AbstractEmptyCollection_method_is_using_iterators["size"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_parent["size"]=false
besharp_oop_type_AbstractEmptyCollection_method_is_calling_this["size"]=false

fi
if ${beshfile_section__code:-false}; then :;
AbstractEmptyCollection ()
{
    @parent
}
AbstractEmptyCollection.add ()
{
    besharp.runtime.error "You cannot add!"
}
AbstractEmptyCollection.addMany ()
{
    besharp.runtime.error "You cannot addMany!"
}
AbstractEmptyCollection.fill ()
{
    :
}
AbstractEmptyCollection.frequency ()
{
    besharp_rcrvs[besharp_rcsl]=0
}
AbstractEmptyCollection.get ()
{
    besharp.runtime.error "Nothing to get!"
}
AbstractEmptyCollection.has ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
AbstractEmptyCollection.hasAll ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
AbstractEmptyCollection.hasKey ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
AbstractEmptyCollection.hasSome ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
AbstractEmptyCollection.isEmpty ()
{
    besharp_rcrvs[besharp_rcsl]=true
}
AbstractEmptyCollection.isOwningItems ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
AbstractEmptyCollection.iterationNew ()
{
    besharp_rcrvs[besharp_rcsl]=""
}
AbstractEmptyCollection.iterationNext ()
{
    besharp_rcrvs[besharp_rcsl]=""
}
AbstractEmptyCollection.iterationValue ()
{
    besharp.runtime.error "Has no values!"
}
AbstractEmptyCollection.keys ()
{
    besharp_rcrvs[besharp_rcsl]=$this
}
AbstractEmptyCollection.ownsItsItems ()
{
    :
}
AbstractEmptyCollection.remove ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
AbstractEmptyCollection.removeAll ()
{
    :
}
AbstractEmptyCollection.removeMany ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
AbstractEmptyCollection.replace ()
{
    :
}
AbstractEmptyCollection.replaceMany ()
{
    :
}
AbstractEmptyCollection.shuffle ()
{
    :
}
AbstractEmptyCollection.size ()
{
    besharp_rcrvs[besharp_rcsl]=0
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["EmptyMap"]='true'
besharp_oop_type_is["EmptyMap"]='class'
besharp_oop_types["EmptyMap"]="EmptyMap"
declare -Ag besharp_oop_type_EmptyMap_interfaces
besharp_oop_type_EmptyMap_interfaces['Map']='Map'
besharp_oop_classes["EmptyMap"]="EmptyMap"
besharp_oop_type_parent["EmptyMap"]="AbstractEmptyCollection"
declare -Ag besharp_oop_type_EmptyMap_fields
declare -Ag besharp_oop_type_EmptyMap_injectable_fields
declare -Ag besharp_oop_type_EmptyMap_field_type
declare -Ag besharp_oop_type_EmptyMap_field_default
declare -Ag besharp_oop_type_EmptyMap_methods
declare -Ag besharp_oop_type_EmptyMap_method_body
declare -Ag besharp_oop_type_EmptyMap_method_locals
declare -Ag besharp_oop_type_EmptyMap_method_is_returning
declare -Ag besharp_oop_type_EmptyMap_method_is_abstract
declare -Ag besharp_oop_type_EmptyMap_method_is_using_iterators
declare -Ag besharp_oop_type_EmptyMap_method_is_calling_parent
declare -Ag besharp_oop_type_EmptyMap_method_is_calling_this
besharp_oop_type_EmptyMap_methods['EmptyMap']='EmptyMap'
besharp_oop_type_EmptyMap_method_is_returning["EmptyMap"]=false
besharp_oop_type_EmptyMap_method_body["EmptyMap"]='    @parent'
besharp_oop_type_EmptyMap_method_locals["EmptyMap"]=''
besharp_oop_type_EmptyMap_method_is_using_iterators["EmptyMap"]=false
besharp_oop_type_EmptyMap_method_is_calling_parent["EmptyMap"]=true
besharp_oop_type_EmptyMap_method_is_calling_this["EmptyMap"]=false
besharp_oop_type_EmptyMap_methods['findAllKeys']='findAllKeys'
besharp_oop_type_EmptyMap_method_is_returning["findAllKeys"]=true
besharp_oop_type_EmptyMap_method_body["findAllKeys"]='    besharp_rcrvs[besharp_rcsl]=$this'
besharp_oop_type_EmptyMap_method_locals["findAllKeys"]=''
besharp_oop_type_EmptyMap_method_is_using_iterators["findAllKeys"]=false
besharp_oop_type_EmptyMap_method_is_calling_parent["findAllKeys"]=false
besharp_oop_type_EmptyMap_method_is_calling_this["findAllKeys"]=true
besharp_oop_type_EmptyMap_methods['hasAllKeys']='hasAllKeys'
besharp_oop_type_EmptyMap_method_is_returning["hasAllKeys"]=true
besharp_oop_type_EmptyMap_method_body["hasAllKeys"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_EmptyMap_method_locals["hasAllKeys"]=''
besharp_oop_type_EmptyMap_method_is_using_iterators["hasAllKeys"]=false
besharp_oop_type_EmptyMap_method_is_calling_parent["hasAllKeys"]=false
besharp_oop_type_EmptyMap_method_is_calling_this["hasAllKeys"]=false
besharp_oop_type_EmptyMap_methods['hasKey']='hasKey'
besharp_oop_type_EmptyMap_method_is_returning["hasKey"]=true
besharp_oop_type_EmptyMap_method_body["hasKey"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_EmptyMap_method_locals["hasKey"]=''
besharp_oop_type_EmptyMap_method_is_using_iterators["hasKey"]=false
besharp_oop_type_EmptyMap_method_is_calling_parent["hasKey"]=false
besharp_oop_type_EmptyMap_method_is_calling_this["hasKey"]=false
besharp_oop_type_EmptyMap_methods['hasSomeKeys']='hasSomeKeys'
besharp_oop_type_EmptyMap_method_is_returning["hasSomeKeys"]=true
besharp_oop_type_EmptyMap_method_body["hasSomeKeys"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_EmptyMap_method_locals["hasSomeKeys"]=''
besharp_oop_type_EmptyMap_method_is_using_iterators["hasSomeKeys"]=false
besharp_oop_type_EmptyMap_method_is_calling_parent["hasSomeKeys"]=false
besharp_oop_type_EmptyMap_method_is_calling_this["hasSomeKeys"]=false
besharp_oop_type_EmptyMap_methods['removeKey']='removeKey'
besharp_oop_type_EmptyMap_method_is_returning["removeKey"]=false
besharp_oop_type_EmptyMap_method_body["removeKey"]='    :'
besharp_oop_type_EmptyMap_method_locals["removeKey"]=''
besharp_oop_type_EmptyMap_method_is_using_iterators["removeKey"]=false
besharp_oop_type_EmptyMap_method_is_calling_parent["removeKey"]=false
besharp_oop_type_EmptyMap_method_is_calling_this["removeKey"]=false
besharp_oop_type_EmptyMap_methods['removeKeys']='removeKeys'
besharp_oop_type_EmptyMap_method_is_returning["removeKeys"]=false
besharp_oop_type_EmptyMap_method_body["removeKeys"]='    :'
besharp_oop_type_EmptyMap_method_locals["removeKeys"]=''
besharp_oop_type_EmptyMap_method_is_using_iterators["removeKeys"]=false
besharp_oop_type_EmptyMap_method_is_calling_parent["removeKeys"]=false
besharp_oop_type_EmptyMap_method_is_calling_this["removeKeys"]=false
besharp_oop_type_EmptyMap_methods['set']='set'
besharp_oop_type_EmptyMap_method_is_returning["set"]=false
besharp_oop_type_EmptyMap_method_body["set"]='    besharp.runtime.error "You cannot set!"'
besharp_oop_type_EmptyMap_method_locals["set"]=''
besharp_oop_type_EmptyMap_method_is_using_iterators["set"]=false
besharp_oop_type_EmptyMap_method_is_calling_parent["set"]=false
besharp_oop_type_EmptyMap_method_is_calling_this["set"]=false
besharp_oop_type_EmptyMap_methods['setPlainPairs']='setPlainPairs'
besharp_oop_type_EmptyMap_method_is_returning["setPlainPairs"]=false
besharp_oop_type_EmptyMap_method_body["setPlainPairs"]='    besharp.runtime.error "You cannot setPlainPairs!"'
besharp_oop_type_EmptyMap_method_locals["setPlainPairs"]=''
besharp_oop_type_EmptyMap_method_is_using_iterators["setPlainPairs"]=false
besharp_oop_type_EmptyMap_method_is_calling_parent["setPlainPairs"]=false
besharp_oop_type_EmptyMap_method_is_calling_this["setPlainPairs"]=false
besharp_oop_type_EmptyMap_methods['swapKeys']='swapKeys'
besharp_oop_type_EmptyMap_method_is_returning["swapKeys"]=false
besharp_oop_type_EmptyMap_method_body["swapKeys"]='    besharp.runtime.error "You cannot swapKeys!"'
besharp_oop_type_EmptyMap_method_locals["swapKeys"]=''
besharp_oop_type_EmptyMap_method_is_using_iterators["swapKeys"]=false
besharp_oop_type_EmptyMap_method_is_calling_parent["swapKeys"]=false
besharp_oop_type_EmptyMap_method_is_calling_this["swapKeys"]=false

fi
if ${beshfile_section__code:-false}; then :;
EmptyMap ()
{
    @parent
}
EmptyMap.findAllKeys ()
{
    besharp_rcrvs[besharp_rcsl]=$this
}
EmptyMap.hasAllKeys ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
EmptyMap.hasKey ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
EmptyMap.hasSomeKeys ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
EmptyMap.removeKey ()
{
    :
}
EmptyMap.removeKeys ()
{
    :
}
EmptyMap.set ()
{
    besharp.runtime.error "You cannot set!"
}
EmptyMap.setPlainPairs ()
{
    besharp.runtime.error "You cannot setPlainPairs!"
}
EmptyMap.swapKeys ()
{
    besharp.runtime.error "You cannot swapKeys!"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["EmptySet"]='true'
besharp_oop_type_is["EmptySet"]='class'
besharp_oop_types["EmptySet"]="EmptySet"
declare -Ag besharp_oop_type_EmptySet_interfaces
besharp_oop_type_EmptySet_interfaces['Set']='Set'
besharp_oop_classes["EmptySet"]="EmptySet"
besharp_oop_type_parent["EmptySet"]="AbstractEmptyCollection"
declare -Ag besharp_oop_type_EmptySet_fields
declare -Ag besharp_oop_type_EmptySet_injectable_fields
declare -Ag besharp_oop_type_EmptySet_field_type
declare -Ag besharp_oop_type_EmptySet_field_default
declare -Ag besharp_oop_type_EmptySet_methods
declare -Ag besharp_oop_type_EmptySet_method_body
declare -Ag besharp_oop_type_EmptySet_method_locals
declare -Ag besharp_oop_type_EmptySet_method_is_returning
declare -Ag besharp_oop_type_EmptySet_method_is_abstract
declare -Ag besharp_oop_type_EmptySet_method_is_using_iterators
declare -Ag besharp_oop_type_EmptySet_method_is_calling_parent
declare -Ag besharp_oop_type_EmptySet_method_is_calling_this
besharp_oop_type_EmptySet_methods['EmptySet']='EmptySet'
besharp_oop_type_EmptySet_method_is_returning["EmptySet"]=false
besharp_oop_type_EmptySet_method_body["EmptySet"]='    @parent'
besharp_oop_type_EmptySet_method_locals["EmptySet"]=''
besharp_oop_type_EmptySet_method_is_using_iterators["EmptySet"]=false
besharp_oop_type_EmptySet_method_is_calling_parent["EmptySet"]=true
besharp_oop_type_EmptySet_method_is_calling_this["EmptySet"]=false

fi
if ${beshfile_section__code:-false}; then :;
EmptySet ()
{
    @parent
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["EmptyVector"]='true'
besharp_oop_type_is["EmptyVector"]='class'
besharp_oop_types["EmptyVector"]="EmptyVector"
declare -Ag besharp_oop_type_EmptyVector_interfaces
besharp_oop_type_EmptyVector_interfaces['Vector']='Vector'
besharp_oop_classes["EmptyVector"]="EmptyVector"
besharp_oop_type_parent["EmptyVector"]="AbstractEmptyCollection"
declare -Ag besharp_oop_type_EmptyVector_fields
declare -Ag besharp_oop_type_EmptyVector_injectable_fields
declare -Ag besharp_oop_type_EmptyVector_field_type
declare -Ag besharp_oop_type_EmptyVector_field_default
declare -Ag besharp_oop_type_EmptyVector_methods
declare -Ag besharp_oop_type_EmptyVector_method_body
declare -Ag besharp_oop_type_EmptyVector_method_locals
declare -Ag besharp_oop_type_EmptyVector_method_is_returning
declare -Ag besharp_oop_type_EmptyVector_method_is_abstract
declare -Ag besharp_oop_type_EmptyVector_method_is_using_iterators
declare -Ag besharp_oop_type_EmptyVector_method_is_calling_parent
declare -Ag besharp_oop_type_EmptyVector_method_is_calling_this
besharp_oop_type_EmptyVector_methods['EmptyVector']='EmptyVector'
besharp_oop_type_EmptyVector_method_is_returning["EmptyVector"]=false
besharp_oop_type_EmptyVector_method_body["EmptyVector"]='    @parent'
besharp_oop_type_EmptyVector_method_locals["EmptyVector"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["EmptyVector"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["EmptyVector"]=true
besharp_oop_type_EmptyVector_method_is_calling_this["EmptyVector"]=false
besharp_oop_type_EmptyVector_methods['call']='call'
besharp_oop_type_EmptyVector_method_is_returning["call"]=true
besharp_oop_type_EmptyVector_method_body["call"]='    eval "besharp.returningOf \"\${@}\""'
besharp_oop_type_EmptyVector_method_locals["call"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["call"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["call"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["call"]=false
besharp_oop_type_EmptyVector_methods['findIndex']='findIndex'
besharp_oop_type_EmptyVector_method_is_returning["findIndex"]=true
besharp_oop_type_EmptyVector_method_body["findIndex"]='    besharp_rcrvs[besharp_rcsl]=-1'
besharp_oop_type_EmptyVector_method_locals["findIndex"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["findIndex"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["findIndex"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["findIndex"]=false
besharp_oop_type_EmptyVector_methods['findIndices']='findIndices'
besharp_oop_type_EmptyVector_method_is_returning["findIndices"]=true
besharp_oop_type_EmptyVector_method_body["findIndices"]='    besharp_rcrvs[besharp_rcsl]=$this'
besharp_oop_type_EmptyVector_method_locals["findIndices"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["findIndices"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["findIndices"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["findIndices"]=true
besharp_oop_type_EmptyVector_methods['findLastIndex']='findLastIndex'
besharp_oop_type_EmptyVector_method_is_returning["findLastIndex"]=true
besharp_oop_type_EmptyVector_method_body["findLastIndex"]='    besharp_rcrvs[besharp_rcsl]=-1'
besharp_oop_type_EmptyVector_method_locals["findLastIndex"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["findLastIndex"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["findLastIndex"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["findLastIndex"]=false
besharp_oop_type_EmptyVector_methods['hasIndex']='hasIndex'
besharp_oop_type_EmptyVector_method_is_returning["hasIndex"]=true
besharp_oop_type_EmptyVector_method_body["hasIndex"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_EmptyVector_method_locals["hasIndex"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["hasIndex"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["hasIndex"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["hasIndex"]=false
besharp_oop_type_EmptyVector_methods['indices']='indices'
besharp_oop_type_EmptyVector_method_is_returning["indices"]=true
besharp_oop_type_EmptyVector_method_body["indices"]='    besharp_rcrvs[besharp_rcsl]=$this'
besharp_oop_type_EmptyVector_method_locals["indices"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["indices"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["indices"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["indices"]=true
besharp_oop_type_EmptyVector_methods['insertAt']='insertAt'
besharp_oop_type_EmptyVector_method_is_returning["insertAt"]=false
besharp_oop_type_EmptyVector_method_body["insertAt"]='    besharp.runtime.error "You cannot insertAt!"'
besharp_oop_type_EmptyVector_method_locals["insertAt"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["insertAt"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["insertAt"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["insertAt"]=false
besharp_oop_type_EmptyVector_methods['insertAtManyIndices']='insertAtManyIndices'
besharp_oop_type_EmptyVector_method_is_returning["insertAtManyIndices"]=false
besharp_oop_type_EmptyVector_method_body["insertAtManyIndices"]='    besharp.runtime.error "You cannot insertAtManyIndices!"'
besharp_oop_type_EmptyVector_method_locals["insertAtManyIndices"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["insertAtManyIndices"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["insertAtManyIndices"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["insertAtManyIndices"]=false
besharp_oop_type_EmptyVector_methods['insertManyAt']='insertManyAt'
besharp_oop_type_EmptyVector_method_is_returning["insertManyAt"]=false
besharp_oop_type_EmptyVector_method_body["insertManyAt"]='    besharp.runtime.error "You cannot insertManyAt!"'
besharp_oop_type_EmptyVector_method_locals["insertManyAt"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["insertManyAt"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["insertManyAt"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["insertManyAt"]=false
besharp_oop_type_EmptyVector_methods['removeIndex']='removeIndex'
besharp_oop_type_EmptyVector_method_is_returning["removeIndex"]=false
besharp_oop_type_EmptyVector_method_body["removeIndex"]='    besharp.runtime.error "You cannot removeIndex!"'
besharp_oop_type_EmptyVector_method_locals["removeIndex"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["removeIndex"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["removeIndex"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["removeIndex"]=false
besharp_oop_type_EmptyVector_methods['removeIndices']='removeIndices'
besharp_oop_type_EmptyVector_method_is_returning["removeIndices"]=false
besharp_oop_type_EmptyVector_method_body["removeIndices"]='    besharp.runtime.error "You cannot removeIndices!"'
besharp_oop_type_EmptyVector_method_locals["removeIndices"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["removeIndices"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["removeIndices"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["removeIndices"]=false
besharp_oop_type_EmptyVector_methods['resize']='resize'
besharp_oop_type_EmptyVector_method_is_returning["resize"]=false
besharp_oop_type_EmptyVector_method_body["resize"]='    besharp.runtime.error "You cannot resize!"'
besharp_oop_type_EmptyVector_method_locals["resize"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["resize"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["resize"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["resize"]=false
besharp_oop_type_EmptyVector_methods['reverse']='reverse'
besharp_oop_type_EmptyVector_method_is_returning["reverse"]=false
besharp_oop_type_EmptyVector_method_body["reverse"]='    :'
besharp_oop_type_EmptyVector_method_locals["reverse"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["reverse"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["reverse"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["reverse"]=false
besharp_oop_type_EmptyVector_methods['rotate']='rotate'
besharp_oop_type_EmptyVector_method_is_returning["rotate"]=false
besharp_oop_type_EmptyVector_method_body["rotate"]='    :'
besharp_oop_type_EmptyVector_method_locals["rotate"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["rotate"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["rotate"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["rotate"]=false
besharp_oop_type_EmptyVector_methods['set']='set'
besharp_oop_type_EmptyVector_method_is_returning["set"]=false
besharp_oop_type_EmptyVector_method_body["set"]='    besharp.runtime.error "You cannot set!"'
besharp_oop_type_EmptyVector_method_locals["set"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["set"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["set"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["set"]=false
besharp_oop_type_EmptyVector_methods['setPlain']='setPlain'
besharp_oop_type_EmptyVector_method_is_returning["setPlain"]=false
besharp_oop_type_EmptyVector_method_body["setPlain"]='    besharp.runtime.error "You cannot setPlain!"'
besharp_oop_type_EmptyVector_method_locals["setPlain"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["setPlain"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["setPlain"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["setPlain"]=false
besharp_oop_type_EmptyVector_methods['swapIndices']='swapIndices'
besharp_oop_type_EmptyVector_method_is_returning["swapIndices"]=false
besharp_oop_type_EmptyVector_method_body["swapIndices"]='    besharp.runtime.error "You cannot swapIndices!"'
besharp_oop_type_EmptyVector_method_locals["swapIndices"]=''
besharp_oop_type_EmptyVector_method_is_using_iterators["swapIndices"]=false
besharp_oop_type_EmptyVector_method_is_calling_parent["swapIndices"]=false
besharp_oop_type_EmptyVector_method_is_calling_this["swapIndices"]=false

fi
if ${beshfile_section__code:-false}; then :;
EmptyVector ()
{
    @parent
}
EmptyVector.call ()
{
    eval "besharp.returningOf \"\${@}\""
}
EmptyVector.findIndex ()
{
    besharp_rcrvs[besharp_rcsl]=-1
}
EmptyVector.findIndices ()
{
    besharp_rcrvs[besharp_rcsl]=$this
}
EmptyVector.findLastIndex ()
{
    besharp_rcrvs[besharp_rcsl]=-1
}
EmptyVector.hasIndex ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
EmptyVector.indices ()
{
    besharp_rcrvs[besharp_rcsl]=$this
}
EmptyVector.insertAt ()
{
    besharp.runtime.error "You cannot insertAt!"
}
EmptyVector.insertAtManyIndices ()
{
    besharp.runtime.error "You cannot insertAtManyIndices!"
}
EmptyVector.insertManyAt ()
{
    besharp.runtime.error "You cannot insertManyAt!"
}
EmptyVector.removeIndex ()
{
    besharp.runtime.error "You cannot removeIndex!"
}
EmptyVector.removeIndices ()
{
    besharp.runtime.error "You cannot removeIndices!"
}
EmptyVector.resize ()
{
    besharp.runtime.error "You cannot resize!"
}
EmptyVector.reverse ()
{
    :
}
EmptyVector.rotate ()
{
    :
}
EmptyVector.set ()
{
    besharp.runtime.error "You cannot set!"
}
EmptyVector.setPlain ()
{
    besharp.runtime.error "You cannot setPlain!"
}
EmptyVector.swapIndices ()
{
    besharp.runtime.error "You cannot swapIndices!"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["AbstractImmutableCollection"]='true'
besharp_oop_type_abstract["AbstractImmutableCollection"]='true'
besharp_oop_type_is["AbstractImmutableCollection"]='class'
besharp_oop_types["AbstractImmutableCollection"]="AbstractImmutableCollection"
declare -Ag besharp_oop_type_AbstractImmutableCollection_interfaces
besharp_oop_type_AbstractImmutableCollection_interfaces['Collection']='Collection'
besharp_oop_type_AbstractImmutableCollection_interfaces['IterableByKeys']='IterableByKeys'
besharp_oop_classes["AbstractImmutableCollection"]="AbstractImmutableCollection"
besharp_oop_type_parent["AbstractImmutableCollection"]="Object"
declare -Ag besharp_oop_type_AbstractImmutableCollection_fields
declare -Ag besharp_oop_type_AbstractImmutableCollection_injectable_fields
declare -Ag besharp_oop_type_AbstractImmutableCollection_field_type
declare -Ag besharp_oop_type_AbstractImmutableCollection_field_default
declare -Ag besharp_oop_type_AbstractImmutableCollection_methods
declare -Ag besharp_oop_type_AbstractImmutableCollection_method_body
declare -Ag besharp_oop_type_AbstractImmutableCollection_method_locals
declare -Ag besharp_oop_type_AbstractImmutableCollection_method_is_returning
declare -Ag besharp_oop_type_AbstractImmutableCollection_method_is_abstract
declare -Ag besharp_oop_type_AbstractImmutableCollection_method_is_using_iterators
declare -Ag besharp_oop_type_AbstractImmutableCollection_method_is_calling_parent
declare -Ag besharp_oop_type_AbstractImmutableCollection_method_is_calling_this
besharp_oop_type_AbstractImmutableCollection_methods['AbstractImmutableCollection']='AbstractImmutableCollection'
besharp_oop_type_AbstractImmutableCollection_method_is_returning["AbstractImmutableCollection"]=false
besharp_oop_type_AbstractImmutableCollection_method_body["AbstractImmutableCollection"]='    @parent'
besharp_oop_type_AbstractImmutableCollection_method_locals["AbstractImmutableCollection"]=''
besharp_oop_type_AbstractImmutableCollection_method_is_using_iterators["AbstractImmutableCollection"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_parent["AbstractImmutableCollection"]=true
besharp_oop_type_AbstractImmutableCollection_method_is_calling_this["AbstractImmutableCollection"]=false
besharp_oop_type_AbstractImmutableCollection_methods['add']='add'
besharp_oop_type_AbstractImmutableCollection_method_is_returning["add"]=false
besharp_oop_type_AbstractImmutableCollection_method_body["add"]='    besharp.runtime.error "You cannot add!"'
besharp_oop_type_AbstractImmutableCollection_method_locals["add"]=''
besharp_oop_type_AbstractImmutableCollection_method_is_using_iterators["add"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_parent["add"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_this["add"]=false
besharp_oop_type_AbstractImmutableCollection_methods['addMany']='addMany'
besharp_oop_type_AbstractImmutableCollection_method_is_returning["addMany"]=false
besharp_oop_type_AbstractImmutableCollection_method_body["addMany"]='    besharp.runtime.error "You cannot addMany!"'
besharp_oop_type_AbstractImmutableCollection_method_locals["addMany"]=''
besharp_oop_type_AbstractImmutableCollection_method_is_using_iterators["addMany"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_parent["addMany"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_this["addMany"]=false
besharp_oop_type_AbstractImmutableCollection_methods['fill']='fill'
besharp_oop_type_AbstractImmutableCollection_method_is_returning["fill"]=false
besharp_oop_type_AbstractImmutableCollection_method_body["fill"]='    besharp.runtime.error "You cannot fill!"'
besharp_oop_type_AbstractImmutableCollection_method_locals["fill"]=''
besharp_oop_type_AbstractImmutableCollection_method_is_using_iterators["fill"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_parent["fill"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_this["fill"]=false
besharp_oop_type_AbstractImmutableCollection_methods['remove']='remove'
besharp_oop_type_AbstractImmutableCollection_method_is_returning["remove"]=false
besharp_oop_type_AbstractImmutableCollection_method_body["remove"]='    besharp.runtime.error "You cannot remove!"'
besharp_oop_type_AbstractImmutableCollection_method_locals["remove"]=''
besharp_oop_type_AbstractImmutableCollection_method_is_using_iterators["remove"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_parent["remove"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_this["remove"]=false
besharp_oop_type_AbstractImmutableCollection_methods['removeAll']='removeAll'
besharp_oop_type_AbstractImmutableCollection_method_is_returning["removeAll"]=false
besharp_oop_type_AbstractImmutableCollection_method_body["removeAll"]='    besharp.runtime.error "You cannot removeAll!"'
besharp_oop_type_AbstractImmutableCollection_method_locals["removeAll"]=''
besharp_oop_type_AbstractImmutableCollection_method_is_using_iterators["removeAll"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_parent["removeAll"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_this["removeAll"]=false
besharp_oop_type_AbstractImmutableCollection_methods['removeMany']='removeMany'
besharp_oop_type_AbstractImmutableCollection_method_is_returning["removeMany"]=false
besharp_oop_type_AbstractImmutableCollection_method_body["removeMany"]='    besharp.runtime.error "You cannot removeMany!"'
besharp_oop_type_AbstractImmutableCollection_method_locals["removeMany"]=''
besharp_oop_type_AbstractImmutableCollection_method_is_using_iterators["removeMany"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_parent["removeMany"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_this["removeMany"]=false
besharp_oop_type_AbstractImmutableCollection_methods['replace']='replace'
besharp_oop_type_AbstractImmutableCollection_method_is_returning["replace"]=false
besharp_oop_type_AbstractImmutableCollection_method_body["replace"]='    besharp.runtime.error "You cannot replace!"'
besharp_oop_type_AbstractImmutableCollection_method_locals["replace"]=''
besharp_oop_type_AbstractImmutableCollection_method_is_using_iterators["replace"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_parent["replace"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_this["replace"]=false
besharp_oop_type_AbstractImmutableCollection_methods['replaceMany']='replaceMany'
besharp_oop_type_AbstractImmutableCollection_method_is_returning["replaceMany"]=false
besharp_oop_type_AbstractImmutableCollection_method_body["replaceMany"]='    besharp.runtime.error "You cannot replaceMany!"'
besharp_oop_type_AbstractImmutableCollection_method_locals["replaceMany"]=''
besharp_oop_type_AbstractImmutableCollection_method_is_using_iterators["replaceMany"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_parent["replaceMany"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_this["replaceMany"]=false
besharp_oop_type_AbstractImmutableCollection_methods['shuffle']='shuffle'
besharp_oop_type_AbstractImmutableCollection_method_is_returning["shuffle"]=false
besharp_oop_type_AbstractImmutableCollection_method_body["shuffle"]='    besharp.runtime.error "You cannot shuffle!"'
besharp_oop_type_AbstractImmutableCollection_method_locals["shuffle"]=''
besharp_oop_type_AbstractImmutableCollection_method_is_using_iterators["shuffle"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_parent["shuffle"]=false
besharp_oop_type_AbstractImmutableCollection_method_is_calling_this["shuffle"]=false

fi
if ${beshfile_section__code:-false}; then :;
AbstractImmutableCollection ()
{
    @parent
}
AbstractImmutableCollection.add ()
{
    besharp.runtime.error "You cannot add!"
}
AbstractImmutableCollection.addMany ()
{
    besharp.runtime.error "You cannot addMany!"
}
AbstractImmutableCollection.fill ()
{
    besharp.runtime.error "You cannot fill!"
}
AbstractImmutableCollection.remove ()
{
    besharp.runtime.error "You cannot remove!"
}
AbstractImmutableCollection.removeAll ()
{
    besharp.runtime.error "You cannot removeAll!"
}
AbstractImmutableCollection.removeMany ()
{
    besharp.runtime.error "You cannot removeMany!"
}
AbstractImmutableCollection.replace ()
{
    besharp.runtime.error "You cannot replace!"
}
AbstractImmutableCollection.replaceMany ()
{
    besharp.runtime.error "You cannot replaceMany!"
}
AbstractImmutableCollection.shuffle ()
{
    besharp.runtime.error "You cannot shuffle!"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["ImmutableList"]='true'
besharp_oop_type_is["ImmutableList"]='class'
besharp_oop_types["ImmutableList"]="ImmutableList"
declare -Ag besharp_oop_type_ImmutableList_interfaces
besharp_oop_classes["ImmutableList"]="ImmutableList"
besharp_oop_type_parent["ImmutableList"]="ArrayList"
declare -Ag besharp_oop_type_ImmutableList_fields
declare -Ag besharp_oop_type_ImmutableList_injectable_fields
declare -Ag besharp_oop_type_ImmutableList_field_type
declare -Ag besharp_oop_type_ImmutableList_field_default
declare -Ag besharp_oop_type_ImmutableList_methods
declare -Ag besharp_oop_type_ImmutableList_method_body
declare -Ag besharp_oop_type_ImmutableList_method_locals
declare -Ag besharp_oop_type_ImmutableList_method_is_returning
declare -Ag besharp_oop_type_ImmutableList_method_is_abstract
declare -Ag besharp_oop_type_ImmutableList_method_is_using_iterators
declare -Ag besharp_oop_type_ImmutableList_method_is_calling_parent
declare -Ag besharp_oop_type_ImmutableList_method_is_calling_this
besharp_oop_type_ImmutableList_methods['ImmutableList']='ImmutableList'
besharp_oop_type_ImmutableList_method_is_returning["ImmutableList"]=false
besharp_oop_type_ImmutableList_method_body["ImmutableList"]='    @parent;
    eval "${this}=(\"\${@}\")"'
besharp_oop_type_ImmutableList_method_locals["ImmutableList"]=''
besharp_oop_type_ImmutableList_method_is_using_iterators["ImmutableList"]=false
besharp_oop_type_ImmutableList_method_is_calling_parent["ImmutableList"]=true
besharp_oop_type_ImmutableList_method_is_calling_this["ImmutableList"]=true
besharp_oop_type_ImmutableList_methods['add']='add'
besharp_oop_type_ImmutableList_method_is_returning["add"]=false
besharp_oop_type_ImmutableList_method_body["add"]='    besharp.runtime.error "You cannot add!"'
besharp_oop_type_ImmutableList_method_locals["add"]=''
besharp_oop_type_ImmutableList_method_is_using_iterators["add"]=false
besharp_oop_type_ImmutableList_method_is_calling_parent["add"]=false
besharp_oop_type_ImmutableList_method_is_calling_this["add"]=false
besharp_oop_type_ImmutableList_methods['addMany']='addMany'
besharp_oop_type_ImmutableList_method_is_returning["addMany"]=false
besharp_oop_type_ImmutableList_method_body["addMany"]='    besharp.runtime.error "You cannot addMany!"'
besharp_oop_type_ImmutableList_method_locals["addMany"]=''
besharp_oop_type_ImmutableList_method_is_using_iterators["addMany"]=false
besharp_oop_type_ImmutableList_method_is_calling_parent["addMany"]=false
besharp_oop_type_ImmutableList_method_is_calling_this["addMany"]=false
besharp_oop_type_ImmutableList_methods['removeIndex']='removeIndex'
besharp_oop_type_ImmutableList_method_is_returning["removeIndex"]=false
besharp_oop_type_ImmutableList_method_body["removeIndex"]='    besharp.runtime.error "You cannot removeIndex!"'
besharp_oop_type_ImmutableList_method_locals["removeIndex"]=''
besharp_oop_type_ImmutableList_method_is_using_iterators["removeIndex"]=false
besharp_oop_type_ImmutableList_method_is_calling_parent["removeIndex"]=false
besharp_oop_type_ImmutableList_method_is_calling_this["removeIndex"]=false
besharp_oop_type_ImmutableList_methods['removeIndices']='removeIndices'
besharp_oop_type_ImmutableList_method_is_returning["removeIndices"]=false
besharp_oop_type_ImmutableList_method_body["removeIndices"]='    besharp.runtime.error "You cannot removeIndices!"'
besharp_oop_type_ImmutableList_method_locals["removeIndices"]=''
besharp_oop_type_ImmutableList_method_is_using_iterators["removeIndices"]=false
besharp_oop_type_ImmutableList_method_is_calling_parent["removeIndices"]=false
besharp_oop_type_ImmutableList_method_is_calling_this["removeIndices"]=false
besharp_oop_type_ImmutableList_methods['reverse']='reverse'
besharp_oop_type_ImmutableList_method_is_returning["reverse"]=false
besharp_oop_type_ImmutableList_method_body["reverse"]='    besharp.runtime.error "You cannot reverse!"'
besharp_oop_type_ImmutableList_method_locals["reverse"]=''
besharp_oop_type_ImmutableList_method_is_using_iterators["reverse"]=false
besharp_oop_type_ImmutableList_method_is_calling_parent["reverse"]=false
besharp_oop_type_ImmutableList_method_is_calling_this["reverse"]=false
besharp_oop_type_ImmutableList_methods['rotate']='rotate'
besharp_oop_type_ImmutableList_method_is_returning["rotate"]=false
besharp_oop_type_ImmutableList_method_body["rotate"]='    besharp.runtime.error "You cannot rotate!"'
besharp_oop_type_ImmutableList_method_locals["rotate"]=''
besharp_oop_type_ImmutableList_method_is_using_iterators["rotate"]=false
besharp_oop_type_ImmutableList_method_is_calling_parent["rotate"]=false
besharp_oop_type_ImmutableList_method_is_calling_this["rotate"]=false
besharp_oop_type_ImmutableList_methods['set']='set'
besharp_oop_type_ImmutableList_method_is_returning["set"]=false
besharp_oop_type_ImmutableList_method_body["set"]='    besharp.runtime.error "You cannot set!"'
besharp_oop_type_ImmutableList_method_locals["set"]=''
besharp_oop_type_ImmutableList_method_is_using_iterators["set"]=false
besharp_oop_type_ImmutableList_method_is_calling_parent["set"]=false
besharp_oop_type_ImmutableList_method_is_calling_this["set"]=false
besharp_oop_type_ImmutableList_methods['swapIndices']='swapIndices'
besharp_oop_type_ImmutableList_method_is_returning["swapIndices"]=false
besharp_oop_type_ImmutableList_method_body["swapIndices"]='    besharp.runtime.error "You cannot swapIndices!"'
besharp_oop_type_ImmutableList_method_locals["swapIndices"]=''
besharp_oop_type_ImmutableList_method_is_using_iterators["swapIndices"]=false
besharp_oop_type_ImmutableList_method_is_calling_parent["swapIndices"]=false
besharp_oop_type_ImmutableList_method_is_calling_this["swapIndices"]=false

fi
if ${beshfile_section__code:-false}; then :;
ImmutableList ()
{
    @parent;
    eval "${this}=(\"\${@}\")"
}
ImmutableList.add ()
{
    besharp.runtime.error "You cannot add!"
}
ImmutableList.addMany ()
{
    besharp.runtime.error "You cannot addMany!"
}
ImmutableList.removeIndex ()
{
    besharp.runtime.error "You cannot removeIndex!"
}
ImmutableList.removeIndices ()
{
    besharp.runtime.error "You cannot removeIndices!"
}
ImmutableList.reverse ()
{
    besharp.runtime.error "You cannot reverse!"
}
ImmutableList.rotate ()
{
    besharp.runtime.error "You cannot rotate!"
}
ImmutableList.set ()
{
    besharp.runtime.error "You cannot set!"
}
ImmutableList.swapIndices ()
{
    besharp.runtime.error "You cannot swapIndices!"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["ImmutableMap"]='true'
besharp_oop_type_is["ImmutableMap"]='class'
besharp_oop_types["ImmutableMap"]="ImmutableMap"
declare -Ag besharp_oop_type_ImmutableMap_interfaces
besharp_oop_classes["ImmutableMap"]="ImmutableMap"
besharp_oop_type_parent["ImmutableMap"]="ArrayMap"
declare -Ag besharp_oop_type_ImmutableMap_fields
declare -Ag besharp_oop_type_ImmutableMap_injectable_fields
declare -Ag besharp_oop_type_ImmutableMap_field_type
declare -Ag besharp_oop_type_ImmutableMap_field_default
declare -Ag besharp_oop_type_ImmutableMap_methods
declare -Ag besharp_oop_type_ImmutableMap_method_body
declare -Ag besharp_oop_type_ImmutableMap_method_locals
declare -Ag besharp_oop_type_ImmutableMap_method_is_returning
declare -Ag besharp_oop_type_ImmutableMap_method_is_abstract
declare -Ag besharp_oop_type_ImmutableMap_method_is_using_iterators
declare -Ag besharp_oop_type_ImmutableMap_method_is_calling_parent
declare -Ag besharp_oop_type_ImmutableMap_method_is_calling_this
besharp_oop_type_ImmutableMap_methods['ImmutableMap']='ImmutableMap'
besharp_oop_type_ImmutableMap_method_is_returning["ImmutableMap"]=true
besharp_oop_type_ImmutableMap_method_body["ImmutableMap"]='    @parent;
    if (( $# == 0 )); then
        return;
    fi;
    if (( ( $# % 2 ) != 0 )); then
        besharp.runtime.error "ImmutableMap constructor has got an odd number of elements. Expected pairs!";
        return;
    fi;
    local key;
    local item;
    local isEven=true;
    for item in "${@}";
    do
        if $isEven; then
            isEven=false;
            key="${item}";
        else
            isEven=true;
            eval "${this}[\"\${key}\"]=\"\${item}\"";
        fi;
    done'
besharp_oop_type_ImmutableMap_method_locals["ImmutableMap"]=''
besharp_oop_type_ImmutableMap_method_is_using_iterators["ImmutableMap"]=false
besharp_oop_type_ImmutableMap_method_is_calling_parent["ImmutableMap"]=true
besharp_oop_type_ImmutableMap_method_is_calling_this["ImmutableMap"]=true
besharp_oop_type_ImmutableMap_methods['findAllKeys']='findAllKeys'
besharp_oop_type_ImmutableMap_method_is_returning["findAllKeys"]=true
besharp_oop_type_ImmutableMap_method_body["findAllKeys"]='    besharp_rcrvs[besharp_rcsl]=$this'
besharp_oop_type_ImmutableMap_method_locals["findAllKeys"]=''
besharp_oop_type_ImmutableMap_method_is_using_iterators["findAllKeys"]=false
besharp_oop_type_ImmutableMap_method_is_calling_parent["findAllKeys"]=false
besharp_oop_type_ImmutableMap_method_is_calling_this["findAllKeys"]=true
besharp_oop_type_ImmutableMap_methods['hasAllKeys']='hasAllKeys'
besharp_oop_type_ImmutableMap_method_is_returning["hasAllKeys"]=true
besharp_oop_type_ImmutableMap_method_body["hasAllKeys"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_ImmutableMap_method_locals["hasAllKeys"]=''
besharp_oop_type_ImmutableMap_method_is_using_iterators["hasAllKeys"]=false
besharp_oop_type_ImmutableMap_method_is_calling_parent["hasAllKeys"]=false
besharp_oop_type_ImmutableMap_method_is_calling_this["hasAllKeys"]=false
besharp_oop_type_ImmutableMap_methods['hasKey']='hasKey'
besharp_oop_type_ImmutableMap_method_is_returning["hasKey"]=true
besharp_oop_type_ImmutableMap_method_body["hasKey"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_ImmutableMap_method_locals["hasKey"]=''
besharp_oop_type_ImmutableMap_method_is_using_iterators["hasKey"]=false
besharp_oop_type_ImmutableMap_method_is_calling_parent["hasKey"]=false
besharp_oop_type_ImmutableMap_method_is_calling_this["hasKey"]=false
besharp_oop_type_ImmutableMap_methods['hasSomeKeys']='hasSomeKeys'
besharp_oop_type_ImmutableMap_method_is_returning["hasSomeKeys"]=true
besharp_oop_type_ImmutableMap_method_body["hasSomeKeys"]='    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_ImmutableMap_method_locals["hasSomeKeys"]=''
besharp_oop_type_ImmutableMap_method_is_using_iterators["hasSomeKeys"]=false
besharp_oop_type_ImmutableMap_method_is_calling_parent["hasSomeKeys"]=false
besharp_oop_type_ImmutableMap_method_is_calling_this["hasSomeKeys"]=false
besharp_oop_type_ImmutableMap_methods['removeKey']='removeKey'
besharp_oop_type_ImmutableMap_method_is_returning["removeKey"]=false
besharp_oop_type_ImmutableMap_method_body["removeKey"]='    :'
besharp_oop_type_ImmutableMap_method_locals["removeKey"]=''
besharp_oop_type_ImmutableMap_method_is_using_iterators["removeKey"]=false
besharp_oop_type_ImmutableMap_method_is_calling_parent["removeKey"]=false
besharp_oop_type_ImmutableMap_method_is_calling_this["removeKey"]=false
besharp_oop_type_ImmutableMap_methods['removeKeys']='removeKeys'
besharp_oop_type_ImmutableMap_method_is_returning["removeKeys"]=false
besharp_oop_type_ImmutableMap_method_body["removeKeys"]='    :'
besharp_oop_type_ImmutableMap_method_locals["removeKeys"]=''
besharp_oop_type_ImmutableMap_method_is_using_iterators["removeKeys"]=false
besharp_oop_type_ImmutableMap_method_is_calling_parent["removeKeys"]=false
besharp_oop_type_ImmutableMap_method_is_calling_this["removeKeys"]=false
besharp_oop_type_ImmutableMap_methods['set']='set'
besharp_oop_type_ImmutableMap_method_is_returning["set"]=false
besharp_oop_type_ImmutableMap_method_body["set"]='    besharp.runtime.error "You cannot set!"'
besharp_oop_type_ImmutableMap_method_locals["set"]=''
besharp_oop_type_ImmutableMap_method_is_using_iterators["set"]=false
besharp_oop_type_ImmutableMap_method_is_calling_parent["set"]=false
besharp_oop_type_ImmutableMap_method_is_calling_this["set"]=false
besharp_oop_type_ImmutableMap_methods['setPlainPairs']='setPlainPairs'
besharp_oop_type_ImmutableMap_method_is_returning["setPlainPairs"]=false
besharp_oop_type_ImmutableMap_method_body["setPlainPairs"]='    besharp.runtime.error "You cannot setPlainPairs!"'
besharp_oop_type_ImmutableMap_method_locals["setPlainPairs"]=''
besharp_oop_type_ImmutableMap_method_is_using_iterators["setPlainPairs"]=false
besharp_oop_type_ImmutableMap_method_is_calling_parent["setPlainPairs"]=false
besharp_oop_type_ImmutableMap_method_is_calling_this["setPlainPairs"]=false
besharp_oop_type_ImmutableMap_methods['swapKeys']='swapKeys'
besharp_oop_type_ImmutableMap_method_is_returning["swapKeys"]=false
besharp_oop_type_ImmutableMap_method_body["swapKeys"]='    besharp.runtime.error "You cannot swapKeys!"'
besharp_oop_type_ImmutableMap_method_locals["swapKeys"]=''
besharp_oop_type_ImmutableMap_method_is_using_iterators["swapKeys"]=false
besharp_oop_type_ImmutableMap_method_is_calling_parent["swapKeys"]=false
besharp_oop_type_ImmutableMap_method_is_calling_this["swapKeys"]=false

fi
if ${beshfile_section__code:-false}; then :;
ImmutableMap ()
{
    @parent;
    if (( $# == 0 )); then
        return;
    fi;
    if (( ( $# % 2 ) != 0 )); then
        besharp.runtime.error "ImmutableMap constructor has got an odd number of elements. Expected pairs!";
        return;
    fi;
    local key;
    local item;
    local isEven=true;
    for item in "${@}";
    do
        if $isEven; then
            isEven=false;
            key="${item}";
        else
            isEven=true;
            eval "${this}[\"\${key}\"]=\"\${item}\"";
        fi;
    done
}
ImmutableMap.findAllKeys ()
{
    besharp_rcrvs[besharp_rcsl]=$this
}
ImmutableMap.hasAllKeys ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
ImmutableMap.hasKey ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
ImmutableMap.hasSomeKeys ()
{
    besharp_rcrvs[besharp_rcsl]=false
}
ImmutableMap.removeKey ()
{
    :
}
ImmutableMap.removeKeys ()
{
    :
}
ImmutableMap.set ()
{
    besharp.runtime.error "You cannot set!"
}
ImmutableMap.setPlainPairs ()
{
    besharp.runtime.error "You cannot setPlainPairs!"
}
ImmutableMap.swapKeys ()
{
    besharp.runtime.error "You cannot swapKeys!"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["ImmutableSet"]='true'
besharp_oop_type_is["ImmutableSet"]='class'
besharp_oop_types["ImmutableSet"]="ImmutableSet"
declare -Ag besharp_oop_type_ImmutableSet_interfaces
besharp_oop_classes["ImmutableSet"]="ImmutableSet"
besharp_oop_type_parent["ImmutableSet"]="ArraySet"
declare -Ag besharp_oop_type_ImmutableSet_fields
declare -Ag besharp_oop_type_ImmutableSet_injectable_fields
declare -Ag besharp_oop_type_ImmutableSet_field_type
declare -Ag besharp_oop_type_ImmutableSet_field_default
declare -Ag besharp_oop_type_ImmutableSet_methods
declare -Ag besharp_oop_type_ImmutableSet_method_body
declare -Ag besharp_oop_type_ImmutableSet_method_locals
declare -Ag besharp_oop_type_ImmutableSet_method_is_returning
declare -Ag besharp_oop_type_ImmutableSet_method_is_abstract
declare -Ag besharp_oop_type_ImmutableSet_method_is_using_iterators
declare -Ag besharp_oop_type_ImmutableSet_method_is_calling_parent
declare -Ag besharp_oop_type_ImmutableSet_method_is_calling_this
besharp_oop_type_ImmutableSet_methods['ImmutableSet']='ImmutableSet'
besharp_oop_type_ImmutableSet_method_is_returning["ImmutableSet"]=false
besharp_oop_type_ImmutableSet_method_body["ImmutableSet"]='    local objectId ;
    @parent;
    local item;
    for item in "${@}";
    do
        __be__objectId @object-id "${item}";
        eval "${this}[\"\${objectId}\"]=\"\${item}\"";
    done'
besharp_oop_type_ImmutableSet_method_locals["ImmutableSet"]='local objectId'
besharp_oop_type_ImmutableSet_method_is_using_iterators["ImmutableSet"]=false
besharp_oop_type_ImmutableSet_method_is_calling_parent["ImmutableSet"]=true
besharp_oop_type_ImmutableSet_method_is_calling_this["ImmutableSet"]=true
besharp_oop_type_ImmutableSet_methods['add']='add'
besharp_oop_type_ImmutableSet_method_is_returning["add"]=false
besharp_oop_type_ImmutableSet_method_body["add"]='    besharp.runtime.error "You cannot add!"'
besharp_oop_type_ImmutableSet_method_locals["add"]=''
besharp_oop_type_ImmutableSet_method_is_using_iterators["add"]=false
besharp_oop_type_ImmutableSet_method_is_calling_parent["add"]=false
besharp_oop_type_ImmutableSet_method_is_calling_this["add"]=false
besharp_oop_type_ImmutableSet_methods['addMany']='addMany'
besharp_oop_type_ImmutableSet_method_is_returning["addMany"]=false
besharp_oop_type_ImmutableSet_method_body["addMany"]='    besharp.runtime.error "You cannot addMany!"'
besharp_oop_type_ImmutableSet_method_locals["addMany"]=''
besharp_oop_type_ImmutableSet_method_is_using_iterators["addMany"]=false
besharp_oop_type_ImmutableSet_method_is_calling_parent["addMany"]=false
besharp_oop_type_ImmutableSet_method_is_calling_this["addMany"]=false
besharp_oop_type_ImmutableSet_methods['fill']='fill'
besharp_oop_type_ImmutableSet_method_is_returning["fill"]=false
besharp_oop_type_ImmutableSet_method_body["fill"]='    besharp.runtime.error "You cannot fill!"'
besharp_oop_type_ImmutableSet_method_locals["fill"]=''
besharp_oop_type_ImmutableSet_method_is_using_iterators["fill"]=false
besharp_oop_type_ImmutableSet_method_is_calling_parent["fill"]=false
besharp_oop_type_ImmutableSet_method_is_calling_this["fill"]=false
besharp_oop_type_ImmutableSet_methods['remove']='remove'
besharp_oop_type_ImmutableSet_method_is_returning["remove"]=false
besharp_oop_type_ImmutableSet_method_body["remove"]='    besharp.runtime.error "You cannot remove!"'
besharp_oop_type_ImmutableSet_method_locals["remove"]=''
besharp_oop_type_ImmutableSet_method_is_using_iterators["remove"]=false
besharp_oop_type_ImmutableSet_method_is_calling_parent["remove"]=false
besharp_oop_type_ImmutableSet_method_is_calling_this["remove"]=false
besharp_oop_type_ImmutableSet_methods['removeAll']='removeAll'
besharp_oop_type_ImmutableSet_method_is_returning["removeAll"]=false
besharp_oop_type_ImmutableSet_method_body["removeAll"]='    besharp.runtime.error "You cannot removeAll!"'
besharp_oop_type_ImmutableSet_method_locals["removeAll"]=''
besharp_oop_type_ImmutableSet_method_is_using_iterators["removeAll"]=false
besharp_oop_type_ImmutableSet_method_is_calling_parent["removeAll"]=false
besharp_oop_type_ImmutableSet_method_is_calling_this["removeAll"]=false
besharp_oop_type_ImmutableSet_methods['removeMany']='removeMany'
besharp_oop_type_ImmutableSet_method_is_returning["removeMany"]=false
besharp_oop_type_ImmutableSet_method_body["removeMany"]='    besharp.runtime.error "You cannot removeMany!"'
besharp_oop_type_ImmutableSet_method_locals["removeMany"]=''
besharp_oop_type_ImmutableSet_method_is_using_iterators["removeMany"]=false
besharp_oop_type_ImmutableSet_method_is_calling_parent["removeMany"]=false
besharp_oop_type_ImmutableSet_method_is_calling_this["removeMany"]=false
besharp_oop_type_ImmutableSet_methods['replace']='replace'
besharp_oop_type_ImmutableSet_method_is_returning["replace"]=false
besharp_oop_type_ImmutableSet_method_body["replace"]='    besharp.runtime.error "You cannot replace!"'
besharp_oop_type_ImmutableSet_method_locals["replace"]=''
besharp_oop_type_ImmutableSet_method_is_using_iterators["replace"]=false
besharp_oop_type_ImmutableSet_method_is_calling_parent["replace"]=false
besharp_oop_type_ImmutableSet_method_is_calling_this["replace"]=false
besharp_oop_type_ImmutableSet_methods['replaceMany']='replaceMany'
besharp_oop_type_ImmutableSet_method_is_returning["replaceMany"]=false
besharp_oop_type_ImmutableSet_method_body["replaceMany"]='    besharp.runtime.error "You cannot replaceMany!"'
besharp_oop_type_ImmutableSet_method_locals["replaceMany"]=''
besharp_oop_type_ImmutableSet_method_is_using_iterators["replaceMany"]=false
besharp_oop_type_ImmutableSet_method_is_calling_parent["replaceMany"]=false
besharp_oop_type_ImmutableSet_method_is_calling_this["replaceMany"]=false
besharp_oop_type_ImmutableSet_methods['shuffle']='shuffle'
besharp_oop_type_ImmutableSet_method_is_returning["shuffle"]=false
besharp_oop_type_ImmutableSet_method_body["shuffle"]='    besharp.runtime.error "You cannot shuffle!"'
besharp_oop_type_ImmutableSet_method_locals["shuffle"]=''
besharp_oop_type_ImmutableSet_method_is_using_iterators["shuffle"]=false
besharp_oop_type_ImmutableSet_method_is_calling_parent["shuffle"]=false
besharp_oop_type_ImmutableSet_method_is_calling_this["shuffle"]=false

fi
if ${beshfile_section__code:-false}; then :;
function __be__objectId() {
  "${@}"
  objectId="${besharp_rcrvs[besharp_rcsl + 1]}"
}
ImmutableSet ()
{
    local objectId;
    @parent;
    local item;
    for item in "${@}";
    do
        __be__objectId @object-id "${item}";
        eval "${this}[\"\${objectId}\"]=\"\${item}\"";
    done
}
ImmutableSet.add ()
{
    besharp.runtime.error "You cannot add!"
}
ImmutableSet.addMany ()
{
    besharp.runtime.error "You cannot addMany!"
}
ImmutableSet.fill ()
{
    besharp.runtime.error "You cannot fill!"
}
ImmutableSet.remove ()
{
    besharp.runtime.error "You cannot remove!"
}
ImmutableSet.removeAll ()
{
    besharp.runtime.error "You cannot removeAll!"
}
ImmutableSet.removeMany ()
{
    besharp.runtime.error "You cannot removeMany!"
}
ImmutableSet.replace ()
{
    besharp.runtime.error "You cannot replace!"
}
ImmutableSet.replaceMany ()
{
    besharp.runtime.error "You cannot replaceMany!"
}
ImmutableSet.shuffle ()
{
    besharp.runtime.error "You cannot shuffle!"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["ImmutableVector"]='true'
besharp_oop_type_is["ImmutableVector"]='class'
besharp_oop_types["ImmutableVector"]="ImmutableVector"
declare -Ag besharp_oop_type_ImmutableVector_interfaces
besharp_oop_classes["ImmutableVector"]="ImmutableVector"
besharp_oop_type_parent["ImmutableVector"]="ArrayVector"
declare -Ag besharp_oop_type_ImmutableVector_fields
declare -Ag besharp_oop_type_ImmutableVector_injectable_fields
declare -Ag besharp_oop_type_ImmutableVector_field_type
declare -Ag besharp_oop_type_ImmutableVector_field_default
declare -Ag besharp_oop_type_ImmutableVector_methods
declare -Ag besharp_oop_type_ImmutableVector_method_body
declare -Ag besharp_oop_type_ImmutableVector_method_locals
declare -Ag besharp_oop_type_ImmutableVector_method_is_returning
declare -Ag besharp_oop_type_ImmutableVector_method_is_abstract
declare -Ag besharp_oop_type_ImmutableVector_method_is_using_iterators
declare -Ag besharp_oop_type_ImmutableVector_method_is_calling_parent
declare -Ag besharp_oop_type_ImmutableVector_method_is_calling_this
besharp_oop_type_ImmutableVector_methods['ImmutableVector']='ImmutableVector'
besharp_oop_type_ImmutableVector_method_is_returning["ImmutableVector"]=false
besharp_oop_type_ImmutableVector_method_body["ImmutableVector"]='    @parent;
    eval "${this}=(\"\${@}\")"'
besharp_oop_type_ImmutableVector_method_locals["ImmutableVector"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["ImmutableVector"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["ImmutableVector"]=true
besharp_oop_type_ImmutableVector_method_is_calling_this["ImmutableVector"]=true
besharp_oop_type_ImmutableVector_methods['add']='add'
besharp_oop_type_ImmutableVector_method_is_returning["add"]=false
besharp_oop_type_ImmutableVector_method_body["add"]='    besharp.runtime.error "You cannot add!"'
besharp_oop_type_ImmutableVector_method_locals["add"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["add"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["add"]=false
besharp_oop_type_ImmutableVector_method_is_calling_this["add"]=false
besharp_oop_type_ImmutableVector_methods['addMany']='addMany'
besharp_oop_type_ImmutableVector_method_is_returning["addMany"]=false
besharp_oop_type_ImmutableVector_method_body["addMany"]='    besharp.runtime.error "You cannot addMany!"'
besharp_oop_type_ImmutableVector_method_locals["addMany"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["addMany"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["addMany"]=false
besharp_oop_type_ImmutableVector_method_is_calling_this["addMany"]=false
besharp_oop_type_ImmutableVector_methods['insertAt']='insertAt'
besharp_oop_type_ImmutableVector_method_is_returning["insertAt"]=false
besharp_oop_type_ImmutableVector_method_body["insertAt"]='    besharp.runtime.error "You cannot insertAt!"'
besharp_oop_type_ImmutableVector_method_locals["insertAt"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["insertAt"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["insertAt"]=false
besharp_oop_type_ImmutableVector_method_is_calling_this["insertAt"]=false
besharp_oop_type_ImmutableVector_methods['insertAtManyIndices']='insertAtManyIndices'
besharp_oop_type_ImmutableVector_method_is_returning["insertAtManyIndices"]=false
besharp_oop_type_ImmutableVector_method_body["insertAtManyIndices"]='    besharp.runtime.error "You cannot insertAtManyIndices!"'
besharp_oop_type_ImmutableVector_method_locals["insertAtManyIndices"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["insertAtManyIndices"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["insertAtManyIndices"]=false
besharp_oop_type_ImmutableVector_method_is_calling_this["insertAtManyIndices"]=false
besharp_oop_type_ImmutableVector_methods['insertManyAt']='insertManyAt'
besharp_oop_type_ImmutableVector_method_is_returning["insertManyAt"]=false
besharp_oop_type_ImmutableVector_method_body["insertManyAt"]='    besharp.runtime.error "You cannot insertManyAt!"'
besharp_oop_type_ImmutableVector_method_locals["insertManyAt"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["insertManyAt"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["insertManyAt"]=false
besharp_oop_type_ImmutableVector_method_is_calling_this["insertManyAt"]=false
besharp_oop_type_ImmutableVector_methods['removeIndex']='removeIndex'
besharp_oop_type_ImmutableVector_method_is_returning["removeIndex"]=false
besharp_oop_type_ImmutableVector_method_body["removeIndex"]='    besharp.runtime.error "You cannot removeIndex!"'
besharp_oop_type_ImmutableVector_method_locals["removeIndex"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["removeIndex"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["removeIndex"]=false
besharp_oop_type_ImmutableVector_method_is_calling_this["removeIndex"]=false
besharp_oop_type_ImmutableVector_methods['removeIndices']='removeIndices'
besharp_oop_type_ImmutableVector_method_is_returning["removeIndices"]=false
besharp_oop_type_ImmutableVector_method_body["removeIndices"]='    besharp.runtime.error "You cannot removeIndices!"'
besharp_oop_type_ImmutableVector_method_locals["removeIndices"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["removeIndices"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["removeIndices"]=false
besharp_oop_type_ImmutableVector_method_is_calling_this["removeIndices"]=false
besharp_oop_type_ImmutableVector_methods['resize']='resize'
besharp_oop_type_ImmutableVector_method_is_returning["resize"]=false
besharp_oop_type_ImmutableVector_method_body["resize"]='    besharp.runtime.error "You cannot resize!"'
besharp_oop_type_ImmutableVector_method_locals["resize"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["resize"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["resize"]=false
besharp_oop_type_ImmutableVector_method_is_calling_this["resize"]=false
besharp_oop_type_ImmutableVector_methods['reverse']='reverse'
besharp_oop_type_ImmutableVector_method_is_returning["reverse"]=false
besharp_oop_type_ImmutableVector_method_body["reverse"]='    besharp.runtime.error "You cannot reverse!"'
besharp_oop_type_ImmutableVector_method_locals["reverse"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["reverse"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["reverse"]=false
besharp_oop_type_ImmutableVector_method_is_calling_this["reverse"]=false
besharp_oop_type_ImmutableVector_methods['rotate']='rotate'
besharp_oop_type_ImmutableVector_method_is_returning["rotate"]=false
besharp_oop_type_ImmutableVector_method_body["rotate"]='    besharp.runtime.error "You cannot rotate!"'
besharp_oop_type_ImmutableVector_method_locals["rotate"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["rotate"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["rotate"]=false
besharp_oop_type_ImmutableVector_method_is_calling_this["rotate"]=false
besharp_oop_type_ImmutableVector_methods['set']='set'
besharp_oop_type_ImmutableVector_method_is_returning["set"]=false
besharp_oop_type_ImmutableVector_method_body["set"]='    besharp.runtime.error "You cannot set!"'
besharp_oop_type_ImmutableVector_method_locals["set"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["set"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["set"]=false
besharp_oop_type_ImmutableVector_method_is_calling_this["set"]=false
besharp_oop_type_ImmutableVector_methods['setPlain']='setPlain'
besharp_oop_type_ImmutableVector_method_is_returning["setPlain"]=false
besharp_oop_type_ImmutableVector_method_body["setPlain"]='    besharp.runtime.error "You cannot setPlain!"'
besharp_oop_type_ImmutableVector_method_locals["setPlain"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["setPlain"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["setPlain"]=false
besharp_oop_type_ImmutableVector_method_is_calling_this["setPlain"]=false
besharp_oop_type_ImmutableVector_methods['swapIndices']='swapIndices'
besharp_oop_type_ImmutableVector_method_is_returning["swapIndices"]=false
besharp_oop_type_ImmutableVector_method_body["swapIndices"]='    besharp.runtime.error "You cannot swapIndices!"'
besharp_oop_type_ImmutableVector_method_locals["swapIndices"]=''
besharp_oop_type_ImmutableVector_method_is_using_iterators["swapIndices"]=false
besharp_oop_type_ImmutableVector_method_is_calling_parent["swapIndices"]=false
besharp_oop_type_ImmutableVector_method_is_calling_this["swapIndices"]=false

fi
if ${beshfile_section__code:-false}; then :;
ImmutableVector ()
{
    @parent;
    eval "${this}=(\"\${@}\")"
}
ImmutableVector.add ()
{
    besharp.runtime.error "You cannot add!"
}
ImmutableVector.addMany ()
{
    besharp.runtime.error "You cannot addMany!"
}
ImmutableVector.insertAt ()
{
    besharp.runtime.error "You cannot insertAt!"
}
ImmutableVector.insertAtManyIndices ()
{
    besharp.runtime.error "You cannot insertAtManyIndices!"
}
ImmutableVector.insertManyAt ()
{
    besharp.runtime.error "You cannot insertManyAt!"
}
ImmutableVector.removeIndex ()
{
    besharp.runtime.error "You cannot removeIndex!"
}
ImmutableVector.removeIndices ()
{
    besharp.runtime.error "You cannot removeIndices!"
}
ImmutableVector.resize ()
{
    besharp.runtime.error "You cannot resize!"
}
ImmutableVector.reverse ()
{
    besharp.runtime.error "You cannot reverse!"
}
ImmutableVector.rotate ()
{
    besharp.runtime.error "You cannot rotate!"
}
ImmutableVector.set ()
{
    besharp.runtime.error "You cannot set!"
}
ImmutableVector.setPlain ()
{
    besharp.runtime.error "You cannot setPlain!"
}
ImmutableVector.swapIndices ()
{
    besharp.runtime.error "You cannot swapIndices!"
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Collection"]='true'
besharp_oop_type_is["Collection"]='interface'
besharp_oop_types["Collection"]="Collection"
besharp_oop_interfaces["Collection"]="Collection"
declare -Ag besharp_oop_type_Collection_interfaces
besharp_oop_type_Collection_interfaces['MutableContainer']='MutableContainer'
declare -Ag besharp_oop_type_Collection_methods
declare -Ag besharp_oop_type_Collection_method_is_abstract
besharp_oop_type_Collection_methods['add']='add'
besharp_oop_type_Collection_method_is_abstract["add"]='true'
besharp_oop_type_Collection_methods['addMany']='addMany'
besharp_oop_type_Collection_method_is_abstract["addMany"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Container"]='true'
besharp_oop_type_is["Container"]='interface'
besharp_oop_types["Container"]="Container"
besharp_oop_interfaces["Container"]="Container"
declare -Ag besharp_oop_type_Container_interfaces
besharp_oop_type_Container_interfaces['Iterable']='Iterable'
declare -Ag besharp_oop_type_Container_methods
declare -Ag besharp_oop_type_Container_method_is_abstract
besharp_oop_type_Container_methods['isEmpty']='isEmpty'
besharp_oop_type_Container_method_is_abstract["isEmpty"]='true'
besharp_oop_type_Container_methods['size']='size'
besharp_oop_type_Container_method_is_abstract["size"]='true'
besharp_oop_type_Container_methods['has']='has'
besharp_oop_type_Container_method_is_abstract["has"]='true'
besharp_oop_type_Container_methods['hasAll']='hasAll'
besharp_oop_type_Container_method_is_abstract["hasAll"]='true'
besharp_oop_type_Container_methods['hasSome']='hasSome'
besharp_oop_type_Container_method_is_abstract["hasSome"]='true'
besharp_oop_type_Container_methods['frequency']='frequency'
besharp_oop_type_Container_method_is_abstract["frequency"]='true'
besharp_oop_type_Container_methods['isOwningItems']='isOwningItems'
besharp_oop_type_Container_method_is_abstract["isOwningItems"]='true'
besharp_oop_type_Container_methods['ownsItsItems']='ownsItsItems'
besharp_oop_type_Container_method_is_abstract["ownsItsItems"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Iterable"]='true'
besharp_oop_type_is["Iterable"]='interface'
besharp_oop_types["Iterable"]="Iterable"
besharp_oop_interfaces["Iterable"]="Iterable"
declare -Ag besharp_oop_type_Iterable_interfaces
declare -Ag besharp_oop_type_Iterable_methods
declare -Ag besharp_oop_type_Iterable_method_is_abstract
besharp_oop_type_Iterable_methods['iterationNew']='iterationNew'
besharp_oop_type_Iterable_method_is_abstract["iterationNew"]='true'
besharp_oop_type_Iterable_methods['iterationValue']='iterationValue'
besharp_oop_type_Iterable_method_is_abstract["iterationValue"]='true'
besharp_oop_type_Iterable_methods['iterationNext']='iterationNext'
besharp_oop_type_Iterable_method_is_abstract["iterationNext"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["IterableByKeys"]='true'
besharp_oop_type_is["IterableByKeys"]='interface'
besharp_oop_types["IterableByKeys"]="IterableByKeys"
besharp_oop_interfaces["IterableByKeys"]="IterableByKeys"
declare -Ag besharp_oop_type_IterableByKeys_interfaces
declare -Ag besharp_oop_type_IterableByKeys_methods
declare -Ag besharp_oop_type_IterableByKeys_method_is_abstract
besharp_oop_type_IterableByKeys_methods['keys']='keys'
besharp_oop_type_IterableByKeys_method_is_abstract["keys"]='true'
besharp_oop_type_IterableByKeys_methods['get']='get'
besharp_oop_type_IterableByKeys_method_is_abstract["get"]='true'
besharp_oop_type_IterableByKeys_methods['hasKey']='hasKey'
besharp_oop_type_IterableByKeys_method_is_abstract["hasKey"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["List"]='true'
besharp_oop_type_is["List"]='interface'
besharp_oop_types["List"]="List"
besharp_oop_interfaces["List"]="List"
declare -Ag besharp_oop_type_List_interfaces
besharp_oop_type_List_interfaces['Collection']='Collection'
besharp_oop_type_List_interfaces['IterableByKeys']='IterableByKeys'
declare -Ag besharp_oop_type_List_methods
declare -Ag besharp_oop_type_List_method_is_abstract
besharp_oop_type_List_methods['set']='set'
besharp_oop_type_List_method_is_abstract["set"]='true'
besharp_oop_type_List_methods['get']='get'
besharp_oop_type_List_method_is_abstract["get"]='true'
besharp_oop_type_List_methods['indices']='indices'
besharp_oop_type_List_method_is_abstract["indices"]='true'
besharp_oop_type_List_methods['hasIndex']='hasIndex'
besharp_oop_type_List_method_is_abstract["hasIndex"]='true'
besharp_oop_type_List_methods['findIndex']='findIndex'
besharp_oop_type_List_method_is_abstract["findIndex"]='true'
besharp_oop_type_List_methods['findLastIndex']='findLastIndex'
besharp_oop_type_List_method_is_abstract["findLastIndex"]='true'
besharp_oop_type_List_methods['findIndices']='findIndices'
besharp_oop_type_List_method_is_abstract["findIndices"]='true'
besharp_oop_type_List_methods['removeIndex']='removeIndex'
besharp_oop_type_List_method_is_abstract["removeIndex"]='true'
besharp_oop_type_List_methods['removeIndices']='removeIndices'
besharp_oop_type_List_method_is_abstract["removeIndices"]='true'
besharp_oop_type_List_methods['reverse']='reverse'
besharp_oop_type_List_method_is_abstract["reverse"]='true'
besharp_oop_type_List_methods['rotate']='rotate'
besharp_oop_type_List_method_is_abstract["rotate"]='true'
besharp_oop_type_List_methods['swapIndices']='swapIndices'
besharp_oop_type_List_method_is_abstract["swapIndices"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Map"]='true'
besharp_oop_type_is["Map"]='interface'
besharp_oop_types["Map"]="Map"
besharp_oop_interfaces["Map"]="Map"
declare -Ag besharp_oop_type_Map_interfaces
besharp_oop_type_Map_interfaces['MutableContainer']='MutableContainer'
besharp_oop_type_Map_interfaces['IterableByKeys']='IterableByKeys'
declare -Ag besharp_oop_type_Map_methods
declare -Ag besharp_oop_type_Map_method_is_abstract
besharp_oop_type_Map_methods['set']='set'
besharp_oop_type_Map_method_is_abstract["set"]='true'
besharp_oop_type_Map_methods['setPlainPairs']='setPlainPairs'
besharp_oop_type_Map_method_is_abstract["setPlainPairs"]='true'
besharp_oop_type_Map_methods['hasKey']='hasKey'
besharp_oop_type_Map_method_is_abstract["hasKey"]='true'
besharp_oop_type_Map_methods['hasAllKeys']='hasAllKeys'
besharp_oop_type_Map_method_is_abstract["hasAllKeys"]='true'
besharp_oop_type_Map_methods['hasSomeKeys']='hasSomeKeys'
besharp_oop_type_Map_method_is_abstract["hasSomeKeys"]='true'
besharp_oop_type_Map_methods['findAllKeys']='findAllKeys'
besharp_oop_type_Map_method_is_abstract["findAllKeys"]='true'
besharp_oop_type_Map_methods['removeKey']='removeKey'
besharp_oop_type_Map_method_is_abstract["removeKey"]='true'
besharp_oop_type_Map_methods['removeKeys']='removeKeys'
besharp_oop_type_Map_method_is_abstract["removeKeys"]='true'
besharp_oop_type_Map_methods['swapKeys']='swapKeys'
besharp_oop_type_Map_method_is_abstract["swapKeys"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["MutableContainer"]='true'
besharp_oop_type_is["MutableContainer"]='interface'
besharp_oop_types["MutableContainer"]="MutableContainer"
besharp_oop_interfaces["MutableContainer"]="MutableContainer"
declare -Ag besharp_oop_type_MutableContainer_interfaces
besharp_oop_type_MutableContainer_interfaces['Container']='Container'
declare -Ag besharp_oop_type_MutableContainer_methods
declare -Ag besharp_oop_type_MutableContainer_method_is_abstract
besharp_oop_type_MutableContainer_methods['removeAll']='removeAll'
besharp_oop_type_MutableContainer_method_is_abstract["removeAll"]='true'
besharp_oop_type_MutableContainer_methods['remove']='remove'
besharp_oop_type_MutableContainer_method_is_abstract["remove"]='true'
besharp_oop_type_MutableContainer_methods['removeMany']='removeMany'
besharp_oop_type_MutableContainer_method_is_abstract["removeMany"]='true'
besharp_oop_type_MutableContainer_methods['replace']='replace'
besharp_oop_type_MutableContainer_method_is_abstract["replace"]='true'
besharp_oop_type_MutableContainer_methods['replaceMany']='replaceMany'
besharp_oop_type_MutableContainer_method_is_abstract["replaceMany"]='true'
besharp_oop_type_MutableContainer_methods['shuffle']='shuffle'
besharp_oop_type_MutableContainer_method_is_abstract["shuffle"]='true'
besharp_oop_type_MutableContainer_methods['fill']='fill'
besharp_oop_type_MutableContainer_method_is_abstract["fill"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["PriorityQueue"]='true'
besharp_oop_type_is["PriorityQueue"]='interface'
besharp_oop_types["PriorityQueue"]="PriorityQueue"
besharp_oop_interfaces["PriorityQueue"]="PriorityQueue"
declare -Ag besharp_oop_type_PriorityQueue_interfaces
besharp_oop_type_PriorityQueue_interfaces['Sequence']='Sequence'
besharp_oop_type_PriorityQueue_interfaces['MutableContainer']='MutableContainer'
declare -Ag besharp_oop_type_PriorityQueue_methods
declare -Ag besharp_oop_type_PriorityQueue_method_is_abstract
besharp_oop_type_PriorityQueue_methods['add']='add'
besharp_oop_type_PriorityQueue_method_is_abstract["add"]='true'
besharp_oop_type_PriorityQueue_methods['addMany']='addMany'
besharp_oop_type_PriorityQueue_method_is_abstract["addMany"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Sequence"]='true'
besharp_oop_type_is["Sequence"]='interface'
besharp_oop_types["Sequence"]="Sequence"
besharp_oop_interfaces["Sequence"]="Sequence"
declare -Ag besharp_oop_type_Sequence_interfaces
declare -Ag besharp_oop_type_Sequence_methods
declare -Ag besharp_oop_type_Sequence_method_is_abstract
besharp_oop_type_Sequence_methods['current']='current'
besharp_oop_type_Sequence_method_is_abstract["current"]='true'
besharp_oop_type_Sequence_methods['pull']='pull'
besharp_oop_type_Sequence_method_is_abstract["pull"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Set"]='true'
besharp_oop_type_is["Set"]='interface'
besharp_oop_types["Set"]="Set"
besharp_oop_interfaces["Set"]="Set"
declare -Ag besharp_oop_type_Set_interfaces
besharp_oop_type_Set_interfaces['Collection']='Collection'
besharp_oop_type_Set_interfaces['IterableByKeys']='IterableByKeys'
declare -Ag besharp_oop_type_Set_methods
declare -Ag besharp_oop_type_Set_method_is_abstract

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Vector"]='true'
besharp_oop_type_is["Vector"]='interface'
besharp_oop_types["Vector"]="Vector"
besharp_oop_interfaces["Vector"]="Vector"
declare -Ag besharp_oop_type_Vector_interfaces
besharp_oop_type_Vector_interfaces['List']='List'
declare -Ag besharp_oop_type_Vector_methods
declare -Ag besharp_oop_type_Vector_method_is_abstract
besharp_oop_type_Vector_methods['resize']='resize'
besharp_oop_type_Vector_method_is_abstract["resize"]='true'
besharp_oop_type_Vector_methods['setPlain']='setPlain'
besharp_oop_type_Vector_method_is_abstract["setPlain"]='true'
besharp_oop_type_Vector_methods['insertAt']='insertAt'
besharp_oop_type_Vector_method_is_abstract["insertAt"]='true'
besharp_oop_type_Vector_methods['insertManyAt']='insertManyAt'
besharp_oop_type_Vector_method_is_abstract["insertManyAt"]='true'
besharp_oop_type_Vector_methods['insertAtManyIndices']='insertAtManyIndices'
besharp_oop_type_Vector_method_is_abstract["insertAtManyIndices"]='true'
besharp_oop_type_Vector_methods['call']='call'
besharp_oop_type_Vector_method_is_abstract["call"]='true'

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Collections"]='true'
besharp_oop_type_is["Collections"]='class'
besharp_oop_types["Collections"]="Collections"
declare -Ag besharp_oop_type_Collections_interfaces
besharp_oop_classes["Collections"]="Collections"
besharp_oop_type_parent["Collections"]="Object"
declare -Ag besharp_oop_type_Collections_fields
declare -Ag besharp_oop_type_Collections_injectable_fields
declare -Ag besharp_oop_type_Collections_field_type
declare -Ag besharp_oop_type_Collections_field_default
declare -Ag besharp_oop_type_Collections_methods
declare -Ag besharp_oop_type_Collections_method_body
declare -Ag besharp_oop_type_Collections_method_locals
declare -Ag besharp_oop_type_Collections_method_is_returning
declare -Ag besharp_oop_type_Collections_method_is_abstract
declare -Ag besharp_oop_type_Collections_method_is_using_iterators
declare -Ag besharp_oop_type_Collections_method_is_calling_parent
declare -Ag besharp_oop_type_Collections_method_is_calling_this
besharp_oop_type_static["Collections"]='Collections'
besharp_oop_type_static_accessor["Collections"]='@collections'
besharp_oop_type_Collections_fields['empty']='empty'
besharp_oop_type_Collections_field_type['empty']="Collection"
besharp_oop_type_Collections_field_default['empty']=""
besharp_oop_type_Collections_methods['Collections']='Collections'
besharp_oop_type_Collections_method_is_returning["Collections"]=false
besharp_oop_type_Collections_method_body["Collections"]='    __be___this_empty @new EmptySet'
besharp_oop_type_Collections_method_locals["Collections"]=''
besharp_oop_type_Collections_method_is_using_iterators["Collections"]=false
besharp_oop_type_Collections_method_is_calling_parent["Collections"]=false
besharp_oop_type_Collections_method_is_calling_this["Collections"]=true
besharp_oop_type_Collections_methods['cloneTo']='cloneTo'
besharp_oop_type_Collections_method_is_returning["cloneTo"]=true
besharp_oop_type_Collections_method_body["cloneTo"]='    local targetContainer="${1}";
    local sourceIterable="${2}";
    if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetContainer}" )" ]]; then
        @clone @to ${targetContainer} shallow $sourceIterable;
        return;
    fi;
    $targetContainer.removeAll;
    $this.copyTo $targetContainer $sourceIterable'
besharp_oop_type_Collections_method_locals["cloneTo"]=''
besharp_oop_type_Collections_method_is_using_iterators["cloneTo"]=false
besharp_oop_type_Collections_method_is_calling_parent["cloneTo"]=false
besharp_oop_type_Collections_method_is_calling_this["cloneTo"]=true
besharp_oop_type_Collections_methods['copyTo']='copyTo'
besharp_oop_type_Collections_method_is_returning["copyTo"]=true
besharp_oop_type_Collections_method_body["copyTo"]='    local targetContainer="${1}";
    local sourceIterable="${2}";
    if @is $targetContainer @a Map; then
        if ! @is $sourceIterable @an IterableByKeys; then
            besharp.runtime.error "Cannot clone '"'"'$sourceIterable'"'"' to a Map! Source must implement IterableByKeys during cloning maps!";
        fi;
        @maps.copyTo $targetContainer $sourceIterable;
        return;
    fi;
    if @is $targetContainer @a Set; then
        @sets.copyTo $targetContainer $sourceIterable;
        return;
    fi;
    if @is $targetContainer @a Vector; then
        @vectors.copyTo $targetContainer $sourceIterable;
        return;
    fi;
    if @is $targetContainer @a List; then
        @lists.copyTo $targetContainer $sourceIterable;
        return;
    fi;
    if @is $targetContainer @a Collection; then
        $targetContainer.addMany $sourceIterable;
        return;
    fi;
    besharp.runtime.error "Sorry pal. You will have to copy '"'"'${sourceIterable}'"'"' object by yourself! I don'"'"'t know how to add things to '"'"'${targetContainer}'"'"' :( "'
besharp_oop_type_Collections_method_locals["copyTo"]=''
besharp_oop_type_Collections_method_is_using_iterators["copyTo"]=false
besharp_oop_type_Collections_method_is_calling_parent["copyTo"]=false
besharp_oop_type_Collections_method_is_calling_this["copyTo"]=false
besharp_oop_type_Collections_methods['frequency']='frequency'
besharp_oop_type_Collections_method_is_returning["frequency"]=true
besharp_oop_type_Collections_method_body["frequency"]='    local iterable="${1}";
    local subjectItem="${2}";
    if @is $iterable @a Container; then
        besharp.returningOf $iterable.frequency "${subjectItem}";
    else
        local frequency=0;
        local candidateItem;
        while @iterate $iterable @in candidateItem; do
            if @same "${candidateItem}" "${subjectItem}"; then
                (( ++frequency ));
            fi;
        done;
        besharp_rcrvs[besharp_rcsl]="${frequency}";
    fi'
besharp_oop_type_Collections_method_locals["frequency"]='local candidateItem'
besharp_oop_type_Collections_method_is_using_iterators["frequency"]=true
besharp_oop_type_Collections_method_is_calling_parent["frequency"]=false
besharp_oop_type_Collections_method_is_calling_this["frequency"]=false
besharp_oop_type_Collections_methods['has']='has'
besharp_oop_type_Collections_method_is_returning["has"]=true
besharp_oop_type_Collections_method_body["has"]='    local iterable="${1}";
    local value="${2}";
    if @is $iterable @a Container; then
        besharp.returningOf $iterable.has "${value}";
    else
        local subjectItem;
        while @iterate $iterable @in subjectItem; do
            if [[ "${subjectItem}" == "${value}" ]]; then
                besharp_rcrvs[besharp_rcsl]=true;
                return;
            fi;
        done;
        besharp_rcrvs[besharp_rcsl]=false;
    fi'
besharp_oop_type_Collections_method_locals["has"]='local subjectItem'
besharp_oop_type_Collections_method_is_using_iterators["has"]=true
besharp_oop_type_Collections_method_is_calling_parent["has"]=false
besharp_oop_type_Collections_method_is_calling_this["has"]=false
besharp_oop_type_Collections_methods['hasAll']='hasAll'
besharp_oop_type_Collections_method_is_returning["hasAll"]=true
besharp_oop_type_Collections_method_body["hasAll"]='    local uniqueItems ;
    local iterable="${1}";
    shift 1;
    if @is $iterable @a Container; then
        besharp.returningOf $iterable.hasAll "${@}";
    else
        __be__uniqueItems @sets.make "${@}";
        local subjectItem;
        while @iterate $iterable @in subjectItem; do
            $uniqueItems.remove "${subjectItem}";
        done;
        besharp.returningOf $uniqueItems.isEmpty;
        @unset $uniqueItems;
    fi'
besharp_oop_type_Collections_method_locals["hasAll"]='local subjectItem
local uniqueItems'
besharp_oop_type_Collections_method_is_using_iterators["hasAll"]=true
besharp_oop_type_Collections_method_is_calling_parent["hasAll"]=false
besharp_oop_type_Collections_method_is_calling_this["hasAll"]=false
besharp_oop_type_Collections_methods['hasSome']='hasSome'
besharp_oop_type_Collections_method_is_returning["hasSome"]=true
besharp_oop_type_Collections_method_body["hasSome"]='    local subjectItems ;
    local iterable="${1}";
    shift 1;
    if @is $iterable @a Container; then
        besharp.returningOf $iterable.hasSome "${@}";
    else
        __be__subjectItems @sets.make "${@}";
        besharp_rcrvs[besharp_rcsl]=false;
        local subjectItem;
        while @iterate $iterable @in subjectItem; do
            if @true $subjectItems.has "${subjectItem}"; then
                besharp_rcrvs[besharp_rcsl]=true;
                break;
            fi;
        done;
        @unset $subjectItems;
    fi'
besharp_oop_type_Collections_method_locals["hasSome"]='local subjectItem
local subjectItems'
besharp_oop_type_Collections_method_is_using_iterators["hasSome"]=true
besharp_oop_type_Collections_method_is_calling_parent["hasSome"]=false
besharp_oop_type_Collections_method_is_calling_this["hasSome"]=false
besharp_oop_type_Collections_methods['isEmpty']='isEmpty'
besharp_oop_type_Collections_method_is_returning["isEmpty"]=true
besharp_oop_type_Collections_method_body["isEmpty"]='    local iterable="${1}";
    if @is $iterable @a Container; then
        besharp.returningOf $iterable.isEmpty;
    else
        if @returned @of $iterable.iterationNew == ""; then
            besharp_rcrvs[besharp_rcsl]=true;
        else
            besharp_rcrvs[besharp_rcsl]=true;
        fi;
    fi'
besharp_oop_type_Collections_method_locals["isEmpty"]=''
besharp_oop_type_Collections_method_is_using_iterators["isEmpty"]=false
besharp_oop_type_Collections_method_is_calling_parent["isEmpty"]=false
besharp_oop_type_Collections_method_is_calling_this["isEmpty"]=false
besharp_oop_type_Collections_methods['isIntersecting']='isIntersecting'
besharp_oop_type_Collections_method_is_returning["isIntersecting"]=true
besharp_oop_type_Collections_method_body["isIntersecting"]='    local iterableA="${1}";
    local iterableB="${2}";
    if @is $iterableB Set; then
        local source=$iterableB;
        iterableB=$iterableA;
        iterableA=$source;
    fi;
    if @is $iterableA Container; then
        besharp.returningOf $iterableA.hasSome $iterableB;
        return;
    else
        if @is $iterableB Container; then
            besharp.returningOf $iterableB.hasSome $iterableA;
            return;
        fi;
    fi;
    local itemA;
    while @iterate $iterableA @in itemA; do
        local itemB;
        while @iterate $iterableB @in itemB; do
            if @same "${itemA}" "${itemB}"; then
                besharp_rcrvs[besharp_rcsl]=true;
                return;
            fi;
        done;
    done;
    besharp_rcrvs[besharp_rcsl]=false'
besharp_oop_type_Collections_method_locals["isIntersecting"]='local itemA
local itemB'
besharp_oop_type_Collections_method_is_using_iterators["isIntersecting"]=true
besharp_oop_type_Collections_method_is_calling_parent["isIntersecting"]=false
besharp_oop_type_Collections_method_is_calling_this["isIntersecting"]=false
besharp_oop_type_Collections_methods['makeImmutableOf']='makeImmutableOf'
besharp_oop_type_Collections_method_is_returning["makeImmutableOf"]=true
besharp_oop_type_Collections_method_body["makeImmutableOf"]='    local iterable="${1}";
    if @is $iterable Set; then
        besharp.returningOf @sets.makeImmutableOf $iterable;
    else
        if @is $iterable Vector; then
            besharp.returningOf @vectors.makeImmutableOf $iterable;
        else
            if @is $iterable List; then
                besharp.returningOf @lists.makeImmutableOf $iterable;
            else
                if @is $iterable Map; then
                    besharp.returningOf @maps.makeImmutableOf $iterable;
                else
                    if @is $iterable IterableByKeys; then
                        besharp.returningOf @maps.makeImmutableOf $iterable;
                    else
                        if @is $iterable Collection; then
                            besharp.returningOf @vectors.makeImmutableOf $iterable;
                        else
                            if @is $iterable Iterable; then
                                besharp.returningOf @vectors.makeImmutableOf $iterable;
                            else
                                besharp.runtime.error "$iterable must be a type of Collection instead of $(besharp.rtti.objectType $iterable )";
                            fi;
                        fi;
                    fi;
                fi;
            fi;
        fi;
    fi'
besharp_oop_type_Collections_method_locals["makeImmutableOf"]=''
besharp_oop_type_Collections_method_is_using_iterators["makeImmutableOf"]=false
besharp_oop_type_Collections_method_is_calling_parent["makeImmutableOf"]=false
besharp_oop_type_Collections_method_is_calling_this["makeImmutableOf"]=false
besharp_oop_type_Collections_methods['makeOf']='makeOf'
besharp_oop_type_Collections_method_is_returning["makeOf"]=true
besharp_oop_type_Collections_method_body["makeOf"]='    local iterable="${1}";
    if @is $iterable Set; then
        besharp.returningOf @sets.makeOf $iterable;
    else
        if @is $iterable Vector; then
            besharp.returningOf @vectors.makeOf $iterable;
        else
            if @is $iterable List; then
                besharp.returningOf @lists.makeOf $iterable;
            else
                if @is $iterable Map; then
                    besharp.returningOf @maps.makeOf $iterable;
                else
                    if @is $iterable IterableByKeys; then
                        besharp.returningOf @maps.makeOf $iterable;
                    else
                        if @is $iterable Collection; then
                            besharp.returningOf @vectors.makeOf $iterable;
                        else
                            if @is $iterable Iterable; then
                                besharp.returningOf @vectors.makeOf $iterable;
                            else
                                besharp.runtime.error "$iterable must be a type of Collection instead of $(besharp.rtti.objectType $iterable )";
                            fi;
                        fi;
                    fi;
                fi;
            fi;
        fi;
    fi'
besharp_oop_type_Collections_method_locals["makeOf"]=''
besharp_oop_type_Collections_method_is_using_iterators["makeOf"]=false
besharp_oop_type_Collections_method_is_calling_parent["makeOf"]=false
besharp_oop_type_Collections_method_is_calling_this["makeOf"]=false
besharp_oop_type_Collections_methods['makePriorityQueue']='makePriorityQueue'
besharp_oop_type_Collections_method_is_returning["makePriorityQueue"]=true
besharp_oop_type_Collections_method_body["makePriorityQueue"]='    besharp.returningOf @new Heap'
besharp_oop_type_Collections_method_locals["makePriorityQueue"]=''
besharp_oop_type_Collections_method_is_using_iterators["makePriorityQueue"]=false
besharp_oop_type_Collections_method_is_calling_parent["makePriorityQueue"]=false
besharp_oop_type_Collections_method_is_calling_this["makePriorityQueue"]=false
besharp_oop_type_Collections_methods['makeQueue']='makeQueue'
besharp_oop_type_Collections_method_is_returning["makeQueue"]=true
besharp_oop_type_Collections_method_body["makeQueue"]='    besharp.returningOf @new Queue'
besharp_oop_type_Collections_method_locals["makeQueue"]=''
besharp_oop_type_Collections_method_is_using_iterators["makeQueue"]=false
besharp_oop_type_Collections_method_is_calling_parent["makeQueue"]=false
besharp_oop_type_Collections_method_is_calling_this["makeQueue"]=false
besharp_oop_type_Collections_methods['makeStack']='makeStack'
besharp_oop_type_Collections_method_is_returning["makeStack"]=true
besharp_oop_type_Collections_method_body["makeStack"]='    besharp.returningOf @new Stack'
besharp_oop_type_Collections_method_locals["makeStack"]=''
besharp_oop_type_Collections_method_is_using_iterators["makeStack"]=false
besharp_oop_type_Collections_method_is_calling_parent["makeStack"]=false
besharp_oop_type_Collections_method_is_calling_this["makeStack"]=false
besharp_oop_type_Collections_methods['nCopies']='nCopies'
besharp_oop_type_Collections_method_is_returning["nCopies"]=true
besharp_oop_type_Collections_method_body["nCopies"]='    besharp.returningOf @vectors.nCopies "${@}"'
besharp_oop_type_Collections_method_locals["nCopies"]=''
besharp_oop_type_Collections_method_is_using_iterators["nCopies"]=false
besharp_oop_type_Collections_method_is_calling_parent["nCopies"]=false
besharp_oop_type_Collections_method_is_calling_this["nCopies"]=false
besharp_oop_type_Collections_methods['single']='single'
besharp_oop_type_Collections_method_is_returning["single"]=true
besharp_oop_type_Collections_method_body["single"]='    local item="${1}";
    besharp.returningOf @new ImmutableVector "${item}"'
besharp_oop_type_Collections_method_locals["single"]=''
besharp_oop_type_Collections_method_is_using_iterators["single"]=false
besharp_oop_type_Collections_method_is_calling_parent["single"]=false
besharp_oop_type_Collections_method_is_calling_this["single"]=false
besharp_oop_type_Collections_methods['size']='size'
besharp_oop_type_Collections_method_is_returning["size"]=true
besharp_oop_type_Collections_method_body["size"]='    local iterable="${1}";
    if @is $iterable @a Container; then
        besharp.returningOf $iterable.size;
    else
        local size=0;
        local subjectItem;
        while @iterate $iterable @in subjectItem; do
            (( ++size ));
        done;
        besharp_rcrvs[besharp_rcsl]="${size}";
    fi'
besharp_oop_type_Collections_method_locals["size"]='local subjectItem'
besharp_oop_type_Collections_method_is_using_iterators["size"]=true
besharp_oop_type_Collections_method_is_calling_parent["size"]=false
besharp_oop_type_Collections_method_is_calling_this["size"]=false

fi
if ${beshfile_section__code:-false}; then :;
function __be___this_empty() {
  "${@}"
  eval $this"_empty=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
}
function __be__uniqueItems() {
  "${@}"
  uniqueItems="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__subjectItems() {
  "${@}"
  subjectItems="${besharp_rcrvs[besharp_rcsl + 1]}"
}
Collections ()
{
    __be___this_empty @new EmptySet
}
Collections.cloneTo ()
{
    local targetContainer="${1}";
    local sourceIterable="${2}";
    if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetContainer}" )" ]]; then
        @clone @to ${targetContainer} shallow $sourceIterable;
        return;
    fi;
    $targetContainer.removeAll;
    $this.copyTo $targetContainer $sourceIterable
}
Collections.copyTo ()
{
    local targetContainer="${1}";
    local sourceIterable="${2}";
    if @is $targetContainer @a Map; then
        if ! @is $sourceIterable @an IterableByKeys; then
            besharp.runtime.error "Cannot clone '$sourceIterable' to a Map! Source must implement IterableByKeys during cloning maps!";
        fi;
        @maps.copyTo $targetContainer $sourceIterable;
        return;
    fi;
    if @is $targetContainer @a Set; then
        @sets.copyTo $targetContainer $sourceIterable;
        return;
    fi;
    if @is $targetContainer @a Vector; then
        @vectors.copyTo $targetContainer $sourceIterable;
        return;
    fi;
    if @is $targetContainer @a List; then
        @lists.copyTo $targetContainer $sourceIterable;
        return;
    fi;
    if @is $targetContainer @a Collection; then
        $targetContainer.addMany $sourceIterable;
        return;
    fi;
    besharp.runtime.error "Sorry pal. You will have to copy '${sourceIterable}' object by yourself! I don't know how to add things to '${targetContainer}' :( "
}
Collections.frequency ()
{
    local iterable="${1}";
    local subjectItem="${2}";
    if @is $iterable @a Container; then
        besharp.returningOf $iterable.frequency "${subjectItem}";
    else
        local frequency=0;
        local candidateItem;
        while @iterate $iterable @in candidateItem; do
            if @same "${candidateItem}" "${subjectItem}"; then
                (( ++frequency ));
            fi;
        done;
        besharp_rcrvs[besharp_rcsl]="${frequency}";
    fi
}
Collections.has ()
{
    local iterable="${1}";
    local value="${2}";
    if @is $iterable @a Container; then
        besharp.returningOf $iterable.has "${value}";
    else
        local subjectItem;
        while @iterate $iterable @in subjectItem; do
            if [[ "${subjectItem}" == "${value}" ]]; then
                besharp_rcrvs[besharp_rcsl]=true;
                return;
            fi;
        done;
        besharp_rcrvs[besharp_rcsl]=false;
    fi
}
Collections.hasAll ()
{
    local uniqueItems;
    local iterable="${1}";
    shift 1;
    if @is $iterable @a Container; then
        besharp.returningOf $iterable.hasAll "${@}";
    else
        __be__uniqueItems @sets.make "${@}";
        local subjectItem;
        while @iterate $iterable @in subjectItem; do
            $uniqueItems.remove "${subjectItem}";
        done;
        besharp.returningOf $uniqueItems.isEmpty;
        @unset $uniqueItems;
    fi
}
Collections.hasSome ()
{
    local subjectItems;
    local iterable="${1}";
    shift 1;
    if @is $iterable @a Container; then
        besharp.returningOf $iterable.hasSome "${@}";
    else
        __be__subjectItems @sets.make "${@}";
        besharp_rcrvs[besharp_rcsl]=false;
        local subjectItem;
        while @iterate $iterable @in subjectItem; do
            if @true $subjectItems.has "${subjectItem}"; then
                besharp_rcrvs[besharp_rcsl]=true;
                break;
            fi;
        done;
        @unset $subjectItems;
    fi
}
Collections.isEmpty ()
{
    local iterable="${1}";
    if @is $iterable @a Container; then
        besharp.returningOf $iterable.isEmpty;
    else
        if @returned @of $iterable.iterationNew == ""; then
            besharp_rcrvs[besharp_rcsl]=true;
        else
            besharp_rcrvs[besharp_rcsl]=true;
        fi;
    fi
}
Collections.isIntersecting ()
{
    local iterableA="${1}";
    local iterableB="${2}";
    if @is $iterableB Set; then
        local source=$iterableB;
        iterableB=$iterableA;
        iterableA=$source;
    fi;
    if @is $iterableA Container; then
        besharp.returningOf $iterableA.hasSome $iterableB;
        return;
    else
        if @is $iterableB Container; then
            besharp.returningOf $iterableB.hasSome $iterableA;
            return;
        fi;
    fi;
    local itemA;
    while @iterate $iterableA @in itemA; do
        local itemB;
        while @iterate $iterableB @in itemB; do
            if @same "${itemA}" "${itemB}"; then
                besharp_rcrvs[besharp_rcsl]=true;
                return;
            fi;
        done;
    done;
    besharp_rcrvs[besharp_rcsl]=false
}
Collections.makeImmutableOf ()
{
    local iterable="${1}";
    if @is $iterable Set; then
        besharp.returningOf @sets.makeImmutableOf $iterable;
    else
        if @is $iterable Vector; then
            besharp.returningOf @vectors.makeImmutableOf $iterable;
        else
            if @is $iterable List; then
                besharp.returningOf @lists.makeImmutableOf $iterable;
            else
                if @is $iterable Map; then
                    besharp.returningOf @maps.makeImmutableOf $iterable;
                else
                    if @is $iterable IterableByKeys; then
                        besharp.returningOf @maps.makeImmutableOf $iterable;
                    else
                        if @is $iterable Collection; then
                            besharp.returningOf @vectors.makeImmutableOf $iterable;
                        else
                            if @is $iterable Iterable; then
                                besharp.returningOf @vectors.makeImmutableOf $iterable;
                            else
                                besharp.runtime.error "$iterable must be a type of Collection instead of $(besharp.rtti.objectType $iterable )";
                            fi;
                        fi;
                    fi;
                fi;
            fi;
        fi;
    fi
}
Collections.makeOf ()
{
    local iterable="${1}";
    if @is $iterable Set; then
        besharp.returningOf @sets.makeOf $iterable;
    else
        if @is $iterable Vector; then
            besharp.returningOf @vectors.makeOf $iterable;
        else
            if @is $iterable List; then
                besharp.returningOf @lists.makeOf $iterable;
            else
                if @is $iterable Map; then
                    besharp.returningOf @maps.makeOf $iterable;
                else
                    if @is $iterable IterableByKeys; then
                        besharp.returningOf @maps.makeOf $iterable;
                    else
                        if @is $iterable Collection; then
                            besharp.returningOf @vectors.makeOf $iterable;
                        else
                            if @is $iterable Iterable; then
                                besharp.returningOf @vectors.makeOf $iterable;
                            else
                                besharp.runtime.error "$iterable must be a type of Collection instead of $(besharp.rtti.objectType $iterable )";
                            fi;
                        fi;
                    fi;
                fi;
            fi;
        fi;
    fi
}
Collections.makePriorityQueue ()
{
    besharp.returningOf @new Heap
}
Collections.makeQueue ()
{
    besharp.returningOf @new Queue
}
Collections.makeStack ()
{
    besharp.returningOf @new Stack
}
Collections.nCopies ()
{
    besharp.returningOf @vectors.nCopies "${@}"
}
Collections.single ()
{
    local item="${1}";
    besharp.returningOf @new ImmutableVector "${item}"
}
Collections.size ()
{
    local iterable="${1}";
    if @is $iterable @a Container; then
        besharp.returningOf $iterable.size;
    else
        local size=0;
        local subjectItem;
        while @iterate $iterable @in subjectItem; do
            (( ++size ));
        done;
        besharp_rcrvs[besharp_rcsl]="${size}";
    fi
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Lists"]='true'
besharp_oop_type_is["Lists"]='class'
besharp_oop_types["Lists"]="Lists"
declare -Ag besharp_oop_type_Lists_interfaces
besharp_oop_classes["Lists"]="Lists"
besharp_oop_type_parent["Lists"]="Object"
declare -Ag besharp_oop_type_Lists_fields
declare -Ag besharp_oop_type_Lists_injectable_fields
declare -Ag besharp_oop_type_Lists_field_type
declare -Ag besharp_oop_type_Lists_field_default
declare -Ag besharp_oop_type_Lists_methods
declare -Ag besharp_oop_type_Lists_method_body
declare -Ag besharp_oop_type_Lists_method_locals
declare -Ag besharp_oop_type_Lists_method_is_returning
declare -Ag besharp_oop_type_Lists_method_is_abstract
declare -Ag besharp_oop_type_Lists_method_is_using_iterators
declare -Ag besharp_oop_type_Lists_method_is_calling_parent
declare -Ag besharp_oop_type_Lists_method_is_calling_this
besharp_oop_type_static["Lists"]='Lists'
besharp_oop_type_static_accessor["Lists"]='@lists'
besharp_oop_type_Lists_fields['empty']='empty'
besharp_oop_type_Lists_field_type['empty']="List"
besharp_oop_type_Lists_field_default['empty']=""
besharp_oop_type_Lists_methods['Lists']='Lists'
besharp_oop_type_Lists_method_is_returning["Lists"]=false
besharp_oop_type_Lists_method_body["Lists"]='    __be___this_empty @new EmptyVector'
besharp_oop_type_Lists_method_locals["Lists"]=''
besharp_oop_type_Lists_method_is_using_iterators["Lists"]=false
besharp_oop_type_Lists_method_is_calling_parent["Lists"]=false
besharp_oop_type_Lists_method_is_calling_this["Lists"]=true
besharp_oop_type_Lists_methods['cloneTo']='cloneTo'
besharp_oop_type_Lists_method_is_returning["cloneTo"]=true
besharp_oop_type_Lists_method_body["cloneTo"]='    local targetList="${1}";
    local sourceIterable="${2}";
    if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetList}" )" ]]; then
        @clone @to ${targetList} shallow $sourceIterable;
        return;
    fi;
    $targetList.removeAll;
    $this.copyTo $targetList $sourceIterable'
besharp_oop_type_Lists_method_locals["cloneTo"]=''
besharp_oop_type_Lists_method_is_using_iterators["cloneTo"]=false
besharp_oop_type_Lists_method_is_calling_parent["cloneTo"]=false
besharp_oop_type_Lists_method_is_calling_this["cloneTo"]=true
besharp_oop_type_Lists_methods['copyTo']='copyTo'
besharp_oop_type_Lists_method_is_returning["copyTo"]=true
besharp_oop_type_Lists_method_body["copyTo"]='    local value ;
    local targetList="${1}";
    local sourceIterable="${2}";
    if @is $sourceIterable @a PrimitiveObject; then
        if @is $sourceIterable @a List; then
            local source;
            declare -n source=$sourceIterable;
            local idx;
            for idx in "${!source[@]}";
            do
                eval "${targetList}[\"\${idx}\"]=\"\${source[\"\${idx}\"]}\"";
            done;
            return;
        fi;
        if @is $sourceIterable @a Set || @is $sourceIterable @a Map; then
            eval "${targetList}+=( \"\${${sourceIterable}[@]}\" )";
            return;
        fi;
    fi;
    if @is $sourceIterable @a List; then
        local key;
        while @iterate @of $sourceIterable.keys @in key; do
            __be__value $sourceIterable.get "${key}";
            $targetList.set "${key}" "${value}";
        done;
        return;
    fi;
    $targetList.addMany $sourceIterable'
besharp_oop_type_Lists_method_locals["copyTo"]='local key
local value'
besharp_oop_type_Lists_method_is_using_iterators["copyTo"]=true
besharp_oop_type_Lists_method_is_calling_parent["copyTo"]=false
besharp_oop_type_Lists_method_is_calling_this["copyTo"]=false
besharp_oop_type_Lists_methods['intersect']='intersect'
besharp_oop_type_Lists_method_is_returning["intersect"]=true
besharp_oop_type_Lists_method_body["intersect"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.intersectTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Lists_method_locals["intersect"]='local result'
besharp_oop_type_Lists_method_is_using_iterators["intersect"]=false
besharp_oop_type_Lists_method_is_calling_parent["intersect"]=false
besharp_oop_type_Lists_method_is_calling_this["intersect"]=true
besharp_oop_type_Lists_methods['intersectTo']='intersectTo'
besharp_oop_type_Lists_method_is_returning["intersectTo"]=false
besharp_oop_type_Lists_method_body["intersectTo"]='    local targetValue ;
    local targetList="${1}";
    shift 1;
    local targetIdx;
    while @iterate @of $targetList.indices @in targetIdx; do
        __be__targetValue $targetList.get "${targetIdx}";
        local iterable;
        for iterable in "${@}";
        do
            if @true @collections.has $iterable "${targetValue}"; then
                continue;
            fi;
            $targetList.removeIndex "${targetIdx}";
            break;
        done;
    done'
besharp_oop_type_Lists_method_locals["intersectTo"]='local targetIdx
local targetValue'
besharp_oop_type_Lists_method_is_using_iterators["intersectTo"]=true
besharp_oop_type_Lists_method_is_calling_parent["intersectTo"]=false
besharp_oop_type_Lists_method_is_calling_this["intersectTo"]=false
besharp_oop_type_Lists_methods['join']='join'
besharp_oop_type_Lists_method_is_returning["join"]=true
besharp_oop_type_Lists_method_body["join"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.joinTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Lists_method_locals["join"]='local result'
besharp_oop_type_Lists_method_is_using_iterators["join"]=false
besharp_oop_type_Lists_method_is_calling_parent["join"]=false
besharp_oop_type_Lists_method_is_calling_this["join"]=true
besharp_oop_type_Lists_methods['joinTo']='joinTo'
besharp_oop_type_Lists_method_is_returning["joinTo"]=false
besharp_oop_type_Lists_method_body["joinTo"]='    local targetList="${1}";
    shift 1;
    local iterable;
    for iterable in "${@}";
    do
        if @is $iterable @a PrimitiveObject && ( @is $iterable @a List || @is $iterable @a Set || @is $iterable @a Map ); then
            eval "${targetList}+=( \"\${${iterable}[@]}\" )";
        else
            $targetList.addMany $iterable;
        fi;
    done'
besharp_oop_type_Lists_method_locals["joinTo"]=''
besharp_oop_type_Lists_method_is_using_iterators["joinTo"]=false
besharp_oop_type_Lists_method_is_calling_parent["joinTo"]=false
besharp_oop_type_Lists_method_is_calling_this["joinTo"]=false
besharp_oop_type_Lists_methods['make']='make'
besharp_oop_type_Lists_method_is_returning["make"]=true
besharp_oop_type_Lists_method_body["make"]='    local list ;
    __be__list @new ArrayList;
    $list.addMany @array "${@}";
    besharp_rcrvs[besharp_rcsl]=$list'
besharp_oop_type_Lists_method_locals["make"]='local list'
besharp_oop_type_Lists_method_is_using_iterators["make"]=false
besharp_oop_type_Lists_method_is_calling_parent["make"]=false
besharp_oop_type_Lists_method_is_calling_this["make"]=false
besharp_oop_type_Lists_methods['makeImmutable']='makeImmutable'
besharp_oop_type_Lists_method_is_returning["makeImmutable"]=true
besharp_oop_type_Lists_method_body["makeImmutable"]='    besharp.returningOf @new ImmutableList "${@}"'
besharp_oop_type_Lists_method_locals["makeImmutable"]=''
besharp_oop_type_Lists_method_is_using_iterators["makeImmutable"]=false
besharp_oop_type_Lists_method_is_calling_parent["makeImmutable"]=false
besharp_oop_type_Lists_method_is_calling_this["makeImmutable"]=false
besharp_oop_type_Lists_methods['makeImmutableOf']='makeImmutableOf'
besharp_oop_type_Lists_method_is_returning["makeImmutableOf"]=true
besharp_oop_type_Lists_method_body["makeImmutableOf"]='    local immutable ;
    local iterable="${1}";
    __be__immutable @new ImmutableList;
    $this.cloneTo $immutable $iterable;
    besharp_rcrvs[besharp_rcsl]=$immutable'
besharp_oop_type_Lists_method_locals["makeImmutableOf"]='local immutable'
besharp_oop_type_Lists_method_is_using_iterators["makeImmutableOf"]=false
besharp_oop_type_Lists_method_is_calling_parent["makeImmutableOf"]=false
besharp_oop_type_Lists_method_is_calling_this["makeImmutableOf"]=true
besharp_oop_type_Lists_methods['makeOf']='makeOf'
besharp_oop_type_Lists_method_is_returning["makeOf"]=true
besharp_oop_type_Lists_method_body["makeOf"]='    local list value ;
    local iterable="${1}";
    if @is $iterable @exact ArrayList; then
        besharp.returningOf @clone shallow $iterable;
        return;
    fi;
    __be__list @new ArrayList;
    if @is $iterable List; then
        local key;
        while @iterate @of $iterable.keys @in key; do
            __be__value $iterable.get "${key}";
            $list.set "${key}" "${value}";
        done;
        besharp_rcrvs[besharp_rcsl]=$list;
        return;
    fi;
    $list.addMany @iterable "${iterable}";
    besharp_rcrvs[besharp_rcsl]=$list'
besharp_oop_type_Lists_method_locals["makeOf"]='local key
local list
local value'
besharp_oop_type_Lists_method_is_using_iterators["makeOf"]=true
besharp_oop_type_Lists_method_is_calling_parent["makeOf"]=false
besharp_oop_type_Lists_method_is_calling_this["makeOf"]=false
besharp_oop_type_Lists_methods['nCopies']='nCopies'
besharp_oop_type_Lists_method_is_returning["nCopies"]=true
besharp_oop_type_Lists_method_body["nCopies"]='    besharp.returningOf @vectors.nCopies "${@}"'
besharp_oop_type_Lists_method_locals["nCopies"]=''
besharp_oop_type_Lists_method_is_using_iterators["nCopies"]=false
besharp_oop_type_Lists_method_is_calling_parent["nCopies"]=false
besharp_oop_type_Lists_method_is_calling_this["nCopies"]=false
besharp_oop_type_Lists_methods['overlay']='overlay'
besharp_oop_type_Lists_method_is_returning["overlay"]=true
besharp_oop_type_Lists_method_body["overlay"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.overlayTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Lists_method_locals["overlay"]='local result'
besharp_oop_type_Lists_method_is_using_iterators["overlay"]=false
besharp_oop_type_Lists_method_is_calling_parent["overlay"]=false
besharp_oop_type_Lists_method_is_calling_this["overlay"]=true
besharp_oop_type_Lists_methods['overlayTo']='overlayTo'
besharp_oop_type_Lists_method_is_returning["overlayTo"]=false
besharp_oop_type_Lists_method_body["overlayTo"]='    local targetList="${1}";
    shift 1;
    local iterable;
    for iterable in "${@}";
    do
        $this.copyTo $targetList $iterable;
    done'
besharp_oop_type_Lists_method_locals["overlayTo"]=''
besharp_oop_type_Lists_method_is_using_iterators["overlayTo"]=false
besharp_oop_type_Lists_method_is_calling_parent["overlayTo"]=false
besharp_oop_type_Lists_method_is_calling_this["overlayTo"]=true
besharp_oop_type_Lists_methods['single']='single'
besharp_oop_type_Lists_method_is_returning["single"]=true
besharp_oop_type_Lists_method_body["single"]='    local item="${1}";
    besharp.returningOf @new ImmutableList "${item}"'
besharp_oop_type_Lists_method_locals["single"]=''
besharp_oop_type_Lists_method_is_using_iterators["single"]=false
besharp_oop_type_Lists_method_is_calling_parent["single"]=false
besharp_oop_type_Lists_method_is_calling_this["single"]=false
besharp_oop_type_Lists_methods['slice']='slice'
besharp_oop_type_Lists_method_is_returning["slice"]=true
besharp_oop_type_Lists_method_body["slice"]='    local result ;
    local list="${1}";
    local indexA="${2}";
    local indexB="${3}";
    __be__result @new ArrayList;
    $this.sliceTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Lists_method_locals["slice"]='local result'
besharp_oop_type_Lists_method_is_using_iterators["slice"]=false
besharp_oop_type_Lists_method_is_calling_parent["slice"]=false
besharp_oop_type_Lists_method_is_calling_this["slice"]=true
besharp_oop_type_Lists_methods['sliceTo']='sliceTo'
besharp_oop_type_Lists_method_is_returning["sliceTo"]=true
besharp_oop_type_Lists_method_body["sliceTo"]='    local sourceSize value ;
    local targetList="${1}";
    local list="${2}";
    local indexA="${3}";
    local indexB="${4}";
    __be__sourceSize $list.size;
    if (( sourceSize == 0 )); then
        besharp.runtime.error "You cannot slice an empty vector!";
    fi;
    if (( indexA < 0 )) || (( indexA >= sourceSize )) || (( indexB < 0 )) || (( indexB >= sourceSize )); then
        besharp.runtime.error "Invalid range for Lists.slice! Expected: [ 0 - $(( sourceSize - 1 )) ]. Got: [ ${indexA} - ${indexB} ].";
    fi;
    if (( indexA > indexB )); then
        local tmpIndex="${indexA}";
        indexA="${indexB}";
        indexB="${tmpIndex}";
    fi;
    if @is $targetList @a Vector; then
        if @is $targetList @a PrimitiveObject && @is $list @a PrimitiveObject; then
            eval "${targetList}=()";
            local source;
            declare -n source=$list;
            local idx;
            for idx in "${!source[@]}";
            do
                if (( idx >= indexA )) && (( idx <= indexB )); then
                    eval "${targetList}+=(\"\${$list[\"\${idx}\"]}\")";
                fi;
            done;
            return;
        fi;
        $targetList.removeAll;
        local idx;
        local value;
        while @iterate @of $list.indices @in idx; do
            if (( idx >= indexA )) && (( idx <= indexB )); then
                __be__value $list.get "${idx}";
                $targetList.add "${value}";
            fi;
        done;
        return;
    fi;
    if @is $targetList @a PrimitiveObject && @is $list @a PrimitiveObject; then
        eval "${targetList}=()";
        local source;
        declare -n source=$list;
        local idx;
        for idx in "${!source[@]}";
        do
            if (( idx >= indexA )) && (( idx <= indexB )); then
                eval "${targetList}[\"\${idx}\"]=\"\${$list[\"\${idx}\"]}\"";
            fi;
        done;
        return;
    fi;
    $targetList.removeAll;
    local idx;
    local value;
    while @iterate @of $list.indices @in idx; do
        if (( idx >= indexA )) && (( idx <= indexB )); then
            __be__value $list.get "${idx}";
            $targetList.set "${idx}" "${value}";
        fi;
    done'
besharp_oop_type_Lists_method_locals["sliceTo"]='local idx
local sourceSize
local value'
besharp_oop_type_Lists_method_is_using_iterators["sliceTo"]=true
besharp_oop_type_Lists_method_is_calling_parent["sliceTo"]=false
besharp_oop_type_Lists_method_is_calling_this["sliceTo"]=false
besharp_oop_type_Lists_methods['subtract']='subtract'
besharp_oop_type_Lists_method_is_returning["subtract"]=true
besharp_oop_type_Lists_method_body["subtract"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.subtractTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Lists_method_locals["subtract"]='local result'
besharp_oop_type_Lists_method_is_using_iterators["subtract"]=false
besharp_oop_type_Lists_method_is_calling_parent["subtract"]=false
besharp_oop_type_Lists_method_is_calling_this["subtract"]=true
besharp_oop_type_Lists_methods['subtractTo']='subtractTo'
besharp_oop_type_Lists_method_is_returning["subtractTo"]=false
besharp_oop_type_Lists_method_body["subtractTo"]='    local targetValue ;
    local targetList="${1}";
    shift 1;
    local targetIdx;
    while @iterate @of $targetList.indices @in targetIdx; do
        __be__targetValue $targetList.get "${targetIdx}";
        local iterable;
        for iterable in "${@}";
        do
            if @true @collections.has "${iterable}" "${targetValue}"; then
                $targetList.removeIndex "${targetIdx}";
                break;
            fi;
        done;
    done'
besharp_oop_type_Lists_method_locals["subtractTo"]='local targetIdx
local targetValue'
besharp_oop_type_Lists_method_is_using_iterators["subtractTo"]=true
besharp_oop_type_Lists_method_is_calling_parent["subtractTo"]=false
besharp_oop_type_Lists_method_is_calling_this["subtractTo"]=false

fi
if ${beshfile_section__code:-false}; then :;
function __be___this_empty() {
  "${@}"
  eval $this"_empty=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
}
function __be__value() {
  "${@}"
  value="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__targetValue() {
  "${@}"
  targetValue="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__list() {
  "${@}"
  list="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__immutable() {
  "${@}"
  immutable="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__list() {
  "${@}"
  list="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__value() {
  "${@}"
  value="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__sourceSize() {
  "${@}"
  sourceSize="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__value() {
  "${@}"
  value="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__targetValue() {
  "${@}"
  targetValue="${besharp_rcrvs[besharp_rcsl + 1]}"
}
Lists ()
{
    __be___this_empty @new EmptyVector
}
Lists.cloneTo ()
{
    local targetList="${1}";
    local sourceIterable="${2}";
    if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetList}" )" ]]; then
        @clone @to ${targetList} shallow $sourceIterable;
        return;
    fi;
    $targetList.removeAll;
    $this.copyTo $targetList $sourceIterable
}
Lists.copyTo ()
{
    local value;
    local targetList="${1}";
    local sourceIterable="${2}";
    if @is $sourceIterable @a PrimitiveObject; then
        if @is $sourceIterable @a List; then
            local source;
            declare -n source=$sourceIterable;
            local idx;
            for idx in "${!source[@]}";
            do
                eval "${targetList}[\"\${idx}\"]=\"\${source[\"\${idx}\"]}\"";
            done;
            return;
        fi;
        if @is $sourceIterable @a Set || @is $sourceIterable @a Map; then
            eval "${targetList}+=( \"\${${sourceIterable}[@]}\" )";
            return;
        fi;
    fi;
    if @is $sourceIterable @a List; then
        local key;
        while @iterate @of $sourceIterable.keys @in key; do
            __be__value $sourceIterable.get "${key}";
            $targetList.set "${key}" "${value}";
        done;
        return;
    fi;
    $targetList.addMany $sourceIterable
}
Lists.intersect ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.intersectTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Lists.intersectTo ()
{
    local targetValue;
    local targetList="${1}";
    shift 1;
    local targetIdx;
    while @iterate @of $targetList.indices @in targetIdx; do
        __be__targetValue $targetList.get "${targetIdx}";
        local iterable;
        for iterable in "${@}";
        do
            if @true @collections.has $iterable "${targetValue}"; then
                continue;
            fi;
            $targetList.removeIndex "${targetIdx}";
            break;
        done;
    done
}
Lists.join ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.joinTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Lists.joinTo ()
{
    local targetList="${1}";
    shift 1;
    local iterable;
    for iterable in "${@}";
    do
        if @is $iterable @a PrimitiveObject && ( @is $iterable @a List || @is $iterable @a Set || @is $iterable @a Map ); then
            eval "${targetList}+=( \"\${${iterable}[@]}\" )";
        else
            $targetList.addMany $iterable;
        fi;
    done
}
Lists.make ()
{
    local list;
    __be__list @new ArrayList;
    $list.addMany @array "${@}";
    besharp_rcrvs[besharp_rcsl]=$list
}
Lists.makeImmutable ()
{
    besharp.returningOf @new ImmutableList "${@}"
}
Lists.makeImmutableOf ()
{
    local immutable;
    local iterable="${1}";
    __be__immutable @new ImmutableList;
    $this.cloneTo $immutable $iterable;
    besharp_rcrvs[besharp_rcsl]=$immutable
}
Lists.makeOf ()
{
    local list value;
    local iterable="${1}";
    if @is $iterable @exact ArrayList; then
        besharp.returningOf @clone shallow $iterable;
        return;
    fi;
    __be__list @new ArrayList;
    if @is $iterable List; then
        local key;
        while @iterate @of $iterable.keys @in key; do
            __be__value $iterable.get "${key}";
            $list.set "${key}" "${value}";
        done;
        besharp_rcrvs[besharp_rcsl]=$list;
        return;
    fi;
    $list.addMany @iterable "${iterable}";
    besharp_rcrvs[besharp_rcsl]=$list
}
Lists.nCopies ()
{
    besharp.returningOf @vectors.nCopies "${@}"
}
Lists.overlay ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.overlayTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Lists.overlayTo ()
{
    local targetList="${1}";
    shift 1;
    local iterable;
    for iterable in "${@}";
    do
        $this.copyTo $targetList $iterable;
    done
}
Lists.single ()
{
    local item="${1}";
    besharp.returningOf @new ImmutableList "${item}"
}
Lists.slice ()
{
    local result;
    local list="${1}";
    local indexA="${2}";
    local indexB="${3}";
    __be__result @new ArrayList;
    $this.sliceTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Lists.sliceTo ()
{
    local sourceSize value;
    local targetList="${1}";
    local list="${2}";
    local indexA="${3}";
    local indexB="${4}";
    __be__sourceSize $list.size;
    if (( sourceSize == 0 )); then
        besharp.runtime.error "You cannot slice an empty vector!";
    fi;
    if (( indexA < 0 )) || (( indexA >= sourceSize )) || (( indexB < 0 )) || (( indexB >= sourceSize )); then
        besharp.runtime.error "Invalid range for Lists.slice! Expected: [ 0 - $(( sourceSize - 1 )) ]. Got: [ ${indexA} - ${indexB} ].";
    fi;
    if (( indexA > indexB )); then
        local tmpIndex="${indexA}";
        indexA="${indexB}";
        indexB="${tmpIndex}";
    fi;
    if @is $targetList @a Vector; then
        if @is $targetList @a PrimitiveObject && @is $list @a PrimitiveObject; then
            eval "${targetList}=()";
            local source;
            declare -n source=$list;
            local idx;
            for idx in "${!source[@]}";
            do
                if (( idx >= indexA )) && (( idx <= indexB )); then
                    eval "${targetList}+=(\"\${$list[\"\${idx}\"]}\")";
                fi;
            done;
            return;
        fi;
        $targetList.removeAll;
        local idx;
        local value;
        while @iterate @of $list.indices @in idx; do
            if (( idx >= indexA )) && (( idx <= indexB )); then
                __be__value $list.get "${idx}";
                $targetList.add "${value}";
            fi;
        done;
        return;
    fi;
    if @is $targetList @a PrimitiveObject && @is $list @a PrimitiveObject; then
        eval "${targetList}=()";
        local source;
        declare -n source=$list;
        local idx;
        for idx in "${!source[@]}";
        do
            if (( idx >= indexA )) && (( idx <= indexB )); then
                eval "${targetList}[\"\${idx}\"]=\"\${$list[\"\${idx}\"]}\"";
            fi;
        done;
        return;
    fi;
    $targetList.removeAll;
    local idx;
    local value;
    while @iterate @of $list.indices @in idx; do
        if (( idx >= indexA )) && (( idx <= indexB )); then
            __be__value $list.get "${idx}";
            $targetList.set "${idx}" "${value}";
        fi;
    done
}
Lists.subtract ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.subtractTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Lists.subtractTo ()
{
    local targetValue;
    local targetList="${1}";
    shift 1;
    local targetIdx;
    while @iterate @of $targetList.indices @in targetIdx; do
        __be__targetValue $targetList.get "${targetIdx}";
        local iterable;
        for iterable in "${@}";
        do
            if @true @collections.has "${iterable}" "${targetValue}"; then
                $targetList.removeIndex "${targetIdx}";
                break;
            fi;
        done;
    done
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Maps"]='true'
besharp_oop_type_is["Maps"]='class'
besharp_oop_types["Maps"]="Maps"
declare -Ag besharp_oop_type_Maps_interfaces
besharp_oop_classes["Maps"]="Maps"
besharp_oop_type_parent["Maps"]="Object"
declare -Ag besharp_oop_type_Maps_fields
declare -Ag besharp_oop_type_Maps_injectable_fields
declare -Ag besharp_oop_type_Maps_field_type
declare -Ag besharp_oop_type_Maps_field_default
declare -Ag besharp_oop_type_Maps_methods
declare -Ag besharp_oop_type_Maps_method_body
declare -Ag besharp_oop_type_Maps_method_locals
declare -Ag besharp_oop_type_Maps_method_is_returning
declare -Ag besharp_oop_type_Maps_method_is_abstract
declare -Ag besharp_oop_type_Maps_method_is_using_iterators
declare -Ag besharp_oop_type_Maps_method_is_calling_parent
declare -Ag besharp_oop_type_Maps_method_is_calling_this
besharp_oop_type_static["Maps"]='Maps'
besharp_oop_type_static_accessor["Maps"]='@maps'
besharp_oop_type_Maps_fields['empty']='empty'
besharp_oop_type_Maps_field_type['empty']="Map"
besharp_oop_type_Maps_field_default['empty']=""
besharp_oop_type_Maps_methods['Maps']='Maps'
besharp_oop_type_Maps_method_is_returning["Maps"]=false
besharp_oop_type_Maps_method_body["Maps"]='    __be___this_empty @new EmptyMap'
besharp_oop_type_Maps_method_locals["Maps"]=''
besharp_oop_type_Maps_method_is_using_iterators["Maps"]=false
besharp_oop_type_Maps_method_is_calling_parent["Maps"]=false
besharp_oop_type_Maps_method_is_calling_this["Maps"]=true
besharp_oop_type_Maps_methods['cloneTo']='cloneTo'
besharp_oop_type_Maps_method_is_returning["cloneTo"]=true
besharp_oop_type_Maps_method_body["cloneTo"]='    local targetMap="${1}";
    local sourceIterable="${2}";
    if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetMap}" )" ]]; then
        @clone @to ${targetMap} shallow $sourceIterable;
        return;
    fi;
    $targetMap.removeAll;
    $this.copyTo $targetMap $sourceIterable'
besharp_oop_type_Maps_method_locals["cloneTo"]=''
besharp_oop_type_Maps_method_is_using_iterators["cloneTo"]=false
besharp_oop_type_Maps_method_is_calling_parent["cloneTo"]=false
besharp_oop_type_Maps_method_is_calling_this["cloneTo"]=true
besharp_oop_type_Maps_methods['copyTo']='copyTo'
besharp_oop_type_Maps_method_is_returning["copyTo"]=true
besharp_oop_type_Maps_method_body["copyTo"]='    local value ;
    local targetMap="${1}";
    local sourceIterable="${2}";
    if @is $sourceIterable @a PrimitiveObject; then
        local source;
        declare -n source=$sourceIterable;
        local key;
        for key in "${!source[@]}";
        do
            eval "${targetMap}[\"\${key}\"]=\"\${source[\"\${key}\"]}\"";
        done;
        return;
    fi;
    local key;
    while @iterate @of $sourceIterable.keys @in key; do
        __be__value $sourceIterable.get "${key}";
        $targetMap.set "${key}" "${value}";
    done'
besharp_oop_type_Maps_method_locals["copyTo"]='local key
local value'
besharp_oop_type_Maps_method_is_using_iterators["copyTo"]=true
besharp_oop_type_Maps_method_is_calling_parent["copyTo"]=false
besharp_oop_type_Maps_method_is_calling_this["copyTo"]=false
besharp_oop_type_Maps_methods['intersect']='intersect'
besharp_oop_type_Maps_method_is_returning["intersect"]=true
besharp_oop_type_Maps_method_body["intersect"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.intersectTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Maps_method_locals["intersect"]='local result'
besharp_oop_type_Maps_method_is_using_iterators["intersect"]=false
besharp_oop_type_Maps_method_is_calling_parent["intersect"]=false
besharp_oop_type_Maps_method_is_calling_this["intersect"]=true
besharp_oop_type_Maps_methods['intersectKeys']='intersectKeys'
besharp_oop_type_Maps_method_is_returning["intersectKeys"]=true
besharp_oop_type_Maps_method_body["intersectKeys"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.intersectKeysTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Maps_method_locals["intersectKeys"]='local result'
besharp_oop_type_Maps_method_is_using_iterators["intersectKeys"]=false
besharp_oop_type_Maps_method_is_calling_parent["intersectKeys"]=false
besharp_oop_type_Maps_method_is_calling_this["intersectKeys"]=true
besharp_oop_type_Maps_methods['intersectKeysTo']='intersectKeysTo'
besharp_oop_type_Maps_method_is_returning["intersectKeysTo"]=false
besharp_oop_type_Maps_method_body["intersectKeysTo"]='    local targetMap="${1}";
    shift 1;
    local targetKey;
    while @iterate @of $targetMap.keys @in targetKey; do
        local iterable;
        for iterable in "${@}";
        do
            if ! @true @collections.has $iterable "${targetKey}"; then
                $targetMap.removeKey "${targetKey}";
                break;
            fi;
        done;
    done'
besharp_oop_type_Maps_method_locals["intersectKeysTo"]='local targetKey'
besharp_oop_type_Maps_method_is_using_iterators["intersectKeysTo"]=true
besharp_oop_type_Maps_method_is_calling_parent["intersectKeysTo"]=false
besharp_oop_type_Maps_method_is_calling_this["intersectKeysTo"]=false
besharp_oop_type_Maps_methods['intersectTo']='intersectTo'
besharp_oop_type_Maps_method_is_returning["intersectTo"]=true
besharp_oop_type_Maps_method_body["intersectTo"]='    local iterableValue targetValue ;
    local targetMap="${1}";
    shift 1;
    local allPrimitiveMaps=true;
    for iterableByKeys in "${@}";
    do
        if ! @is $iterableByKeys @a PrimitiveObject || ! @is $iterableByKeys @a Map; then
            allPrimitiveMaps=false;
            break;
        fi;
    done;
    if $allPrimitiveMaps; then
        local targetKey;
        local iterable;
        while @iterate @of $targetMap.keys @in targetKey; do
            for iterable in "${@}";
            do
                eval "if [[ \"\${${iterable}[\"\$targetKey\"]+isset}\" == isset ]]                       && [[ \"\${${targetMap}[\"\$targetKey\"]+isset}\" == isset ]]                       && [[ \"\${${iterable}[\"\$targetKey\"]}\" == \"\${${targetMap}[\"\$targetKey\"]}\" ]]; then continue; fi";
                $targetMap.removeKey "${targetKey}";
            done;
        done;
        return;
    fi;
    local targetKey;
    while @iterate @of $targetMap.keys @in targetKey; do
        __be__targetValue $targetMap.get "${targetKey}";
        local iterable;
        for iterable in "${@}";
        do
            if @true $iterable.hasKey "${targetKey}"; then
                __be__iterableValue $iterable.get "${targetKey}";
                if [[ "${iterableValue}" == "${targetValue}" ]]; then
                    continue;
                fi;
            fi;
            $targetMap.removeKey "${targetKey}";
            break;
        done;
    done'
besharp_oop_type_Maps_method_locals["intersectTo"]='local iterableValue
local targetKey
local targetValue'
besharp_oop_type_Maps_method_is_using_iterators["intersectTo"]=true
besharp_oop_type_Maps_method_is_calling_parent["intersectTo"]=false
besharp_oop_type_Maps_method_is_calling_this["intersectTo"]=false
besharp_oop_type_Maps_methods['intersectValues']='intersectValues'
besharp_oop_type_Maps_method_is_returning["intersectValues"]=true
besharp_oop_type_Maps_method_body["intersectValues"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.intersectValuesTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Maps_method_locals["intersectValues"]='local result'
besharp_oop_type_Maps_method_is_using_iterators["intersectValues"]=false
besharp_oop_type_Maps_method_is_calling_parent["intersectValues"]=false
besharp_oop_type_Maps_method_is_calling_this["intersectValues"]=true
besharp_oop_type_Maps_methods['intersectValuesTo']='intersectValuesTo'
besharp_oop_type_Maps_method_is_returning["intersectValuesTo"]=false
besharp_oop_type_Maps_method_body["intersectValuesTo"]='    local targetValue ;
    local targetMap="${1}";
    shift 1;
    local targetKey;
    local targetValue;
    while @iterate @of $targetMap.keys @in targetKey; do
        __be__targetValue $targetMap.get "${targetKey}";
        local iterable;
        for iterable in "${@}";
        do
            if ! @true @collections.has $iterable "${targetValue}"; then
                $targetMap.removeKey "${targetKey}";
                break;
            fi;
        done;
    done'
besharp_oop_type_Maps_method_locals["intersectValuesTo"]='local targetKey
local targetValue'
besharp_oop_type_Maps_method_is_using_iterators["intersectValuesTo"]=true
besharp_oop_type_Maps_method_is_calling_parent["intersectValuesTo"]=false
besharp_oop_type_Maps_method_is_calling_this["intersectValuesTo"]=false
besharp_oop_type_Maps_methods['make']='make'
besharp_oop_type_Maps_method_is_returning["make"]=true
besharp_oop_type_Maps_method_body["make"]='    local map ;
    __be__map @new ArrayMap;
    $map.setPlainPairs "${@}";
    besharp_rcrvs[besharp_rcsl]=$map'
besharp_oop_type_Maps_method_locals["make"]='local map'
besharp_oop_type_Maps_method_is_using_iterators["make"]=false
besharp_oop_type_Maps_method_is_calling_parent["make"]=false
besharp_oop_type_Maps_method_is_calling_this["make"]=false
besharp_oop_type_Maps_methods['makeImmutable']='makeImmutable'
besharp_oop_type_Maps_method_is_returning["makeImmutable"]=true
besharp_oop_type_Maps_method_body["makeImmutable"]='    besharp.returningOf @new ImmutableMap "${@}"'
besharp_oop_type_Maps_method_locals["makeImmutable"]=''
besharp_oop_type_Maps_method_is_using_iterators["makeImmutable"]=false
besharp_oop_type_Maps_method_is_calling_parent["makeImmutable"]=false
besharp_oop_type_Maps_method_is_calling_this["makeImmutable"]=false
besharp_oop_type_Maps_methods['makeImmutableOf']='makeImmutableOf'
besharp_oop_type_Maps_method_is_returning["makeImmutableOf"]=true
besharp_oop_type_Maps_method_body["makeImmutableOf"]='    local immutable ;
    local iterable="${1}";
    __be__immutable @new ImmutableMap;
    $this.cloneTo $immutable $iterable;
    besharp_rcrvs[besharp_rcsl]=$immutable'
besharp_oop_type_Maps_method_locals["makeImmutableOf"]='local immutable'
besharp_oop_type_Maps_method_is_using_iterators["makeImmutableOf"]=false
besharp_oop_type_Maps_method_is_calling_parent["makeImmutableOf"]=false
besharp_oop_type_Maps_method_is_calling_this["makeImmutableOf"]=true
besharp_oop_type_Maps_methods['makeOf']='makeOf'
besharp_oop_type_Maps_method_is_returning["makeOf"]=true
besharp_oop_type_Maps_method_body["makeOf"]='    local map value ;
    local iterableByKeys="${1}";
    __be__map @new ArrayMap;
    local key;
    while @iterate @of $iterableByKeys.keys @in key; do
        __be__value $iterableByKeys.get "${key}";
        $map.set "${key}" "${value}";
    done;
    besharp_rcrvs[besharp_rcsl]=$map'
besharp_oop_type_Maps_method_locals["makeOf"]='local key
local map
local value'
besharp_oop_type_Maps_method_is_using_iterators["makeOf"]=true
besharp_oop_type_Maps_method_is_calling_parent["makeOf"]=false
besharp_oop_type_Maps_method_is_calling_this["makeOf"]=false
besharp_oop_type_Maps_methods['overlay']='overlay'
besharp_oop_type_Maps_method_is_returning["overlay"]=true
besharp_oop_type_Maps_method_body["overlay"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.overlayTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Maps_method_locals["overlay"]='local result'
besharp_oop_type_Maps_method_is_using_iterators["overlay"]=false
besharp_oop_type_Maps_method_is_calling_parent["overlay"]=false
besharp_oop_type_Maps_method_is_calling_this["overlay"]=true
besharp_oop_type_Maps_methods['overlayTo']='overlayTo'
besharp_oop_type_Maps_method_is_returning["overlayTo"]=false
besharp_oop_type_Maps_method_body["overlayTo"]='    local targetMap="${1}";
    shift 1;
    local iterableByKeys;
    for iterableByKeys in "${@}";
    do
        $this.copyTo $targetMap $iterableByKeys;
    done'
besharp_oop_type_Maps_method_locals["overlayTo"]=''
besharp_oop_type_Maps_method_is_using_iterators["overlayTo"]=false
besharp_oop_type_Maps_method_is_calling_parent["overlayTo"]=false
besharp_oop_type_Maps_method_is_calling_this["overlayTo"]=true
besharp_oop_type_Maps_methods['single']='single'
besharp_oop_type_Maps_method_is_returning["single"]=true
besharp_oop_type_Maps_method_body["single"]='    local key="${1}";
    local value="${2}";
    besharp.returningOf @new ImmutableMap "${key}" "${value}"'
besharp_oop_type_Maps_method_locals["single"]=''
besharp_oop_type_Maps_method_is_using_iterators["single"]=false
besharp_oop_type_Maps_method_is_calling_parent["single"]=false
besharp_oop_type_Maps_method_is_calling_this["single"]=false
besharp_oop_type_Maps_methods['subtract']='subtract'
besharp_oop_type_Maps_method_is_returning["subtract"]=true
besharp_oop_type_Maps_method_body["subtract"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.subtractTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Maps_method_locals["subtract"]='local result'
besharp_oop_type_Maps_method_is_using_iterators["subtract"]=false
besharp_oop_type_Maps_method_is_calling_parent["subtract"]=false
besharp_oop_type_Maps_method_is_calling_this["subtract"]=true
besharp_oop_type_Maps_methods['subtractKeys']='subtractKeys'
besharp_oop_type_Maps_method_is_returning["subtractKeys"]=true
besharp_oop_type_Maps_method_body["subtractKeys"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.subtractKeysTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Maps_method_locals["subtractKeys"]='local result'
besharp_oop_type_Maps_method_is_using_iterators["subtractKeys"]=false
besharp_oop_type_Maps_method_is_calling_parent["subtractKeys"]=false
besharp_oop_type_Maps_method_is_calling_this["subtractKeys"]=true
besharp_oop_type_Maps_methods['subtractKeysTo']='subtractKeysTo'
besharp_oop_type_Maps_method_is_returning["subtractKeysTo"]=false
besharp_oop_type_Maps_method_body["subtractKeysTo"]='    local targetMap="${1}";
    shift 1;
    local targetKey;
    while @iterate @of $targetMap.keys @in targetKey; do
        local iterable;
        for iterable in "${@}";
        do
            if @true @collections.has "${iterable}" "${targetKey}"; then
                $targetMap.removeKey "${targetKey}";
                break;
            fi;
        done;
    done'
besharp_oop_type_Maps_method_locals["subtractKeysTo"]='local targetKey'
besharp_oop_type_Maps_method_is_using_iterators["subtractKeysTo"]=true
besharp_oop_type_Maps_method_is_calling_parent["subtractKeysTo"]=false
besharp_oop_type_Maps_method_is_calling_this["subtractKeysTo"]=false
besharp_oop_type_Maps_methods['subtractTo']='subtractTo'
besharp_oop_type_Maps_method_is_returning["subtractTo"]=true
besharp_oop_type_Maps_method_body["subtractTo"]='    local iterableValue targetValue ;
    local targetMap="${1}";
    shift 1;
    local iterableByKeys;
    local allPrimitiveMaps=true;
    for iterableByKeys in "${@}";
    do
        if ! @is $iterableByKeys @a PrimitiveObject || ! @is $iterableByKeys @a Map; then
            allPrimitiveMaps=false;
            break;
        fi;
    done;
    if $allPrimitiveMaps; then
        local targetKey;
        while @iterate @of $targetMap.keys @in targetKey; do
            for iterableByKeys in "${@}";
            do
                eval "if [[ \"\${${iterableByKeys}[\"\$targetKey\"]+isset}\" == isset ]]                       && [[ \"\${${targetMap}[\"\$targetKey\"]+isset}\" == isset ]]                       && [[ \"\${${iterableByKeys}[\"\$targetKey\"]}\" == \"\${${targetMap}[\"\$targetKey\"]}\" ]]; then                           \$targetMap.removeKey "\${targetKey}" continue 2; fi";
            done;
        done;
        return;
    fi;
    local targetKey;
    while @iterate @of $targetMap.keys @in targetKey; do
        for iterableByKeys in "${@}";
        do
            if @true $iterableByKeys.hasKey "${targetKey}" && @true $targetMap.hasKey "${targetKey}"; then
                __be__iterableValue $iterableByKeys.get "${targetKey}";
                __be__targetValue $targetMap.get "${targetKey}";
                if [[ "${iterableValue}" == "${targetValue}" ]]; then
                    $targetMap.removeKey "${targetKey}";
                    continue 2;
                fi;
            fi;
        done;
    done'
besharp_oop_type_Maps_method_locals["subtractTo"]='local iterableValue
local targetKey
local targetValue'
besharp_oop_type_Maps_method_is_using_iterators["subtractTo"]=true
besharp_oop_type_Maps_method_is_calling_parent["subtractTo"]=false
besharp_oop_type_Maps_method_is_calling_this["subtractTo"]=false
besharp_oop_type_Maps_methods['subtractValues']='subtractValues'
besharp_oop_type_Maps_method_is_returning["subtractValues"]=true
besharp_oop_type_Maps_method_body["subtractValues"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.subtractValuesTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Maps_method_locals["subtractValues"]='local result'
besharp_oop_type_Maps_method_is_using_iterators["subtractValues"]=false
besharp_oop_type_Maps_method_is_calling_parent["subtractValues"]=false
besharp_oop_type_Maps_method_is_calling_this["subtractValues"]=true
besharp_oop_type_Maps_methods['subtractValuesTo']='subtractValuesTo'
besharp_oop_type_Maps_method_is_returning["subtractValuesTo"]=false
besharp_oop_type_Maps_method_body["subtractValuesTo"]='    local targetValue ;
    local targetMap="${1}";
    shift 1;
    local targetKey;
    while @iterate @of $targetMap.keys @in targetKey; do
        __be__targetValue $targetMap.get "${targetKey}";
        local iterable;
        for iterable in "${@}";
        do
            if @true @collections.has "${iterable}" "${targetValue}"; then
                $targetMap.removeKey "${targetKey}";
                break;
            fi;
        done;
    done'
besharp_oop_type_Maps_method_locals["subtractValuesTo"]='local targetKey
local targetValue'
besharp_oop_type_Maps_method_is_using_iterators["subtractValuesTo"]=true
besharp_oop_type_Maps_method_is_calling_parent["subtractValuesTo"]=false
besharp_oop_type_Maps_method_is_calling_this["subtractValuesTo"]=false

fi
if ${beshfile_section__code:-false}; then :;
function __be___this_empty() {
  "${@}"
  eval $this"_empty=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
}
function __be__value() {
  "${@}"
  value="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__iterableValue() {
  "${@}"
  iterableValue="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__targetValue() {
  "${@}"
  targetValue="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__targetValue() {
  "${@}"
  targetValue="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__map() {
  "${@}"
  map="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__immutable() {
  "${@}"
  immutable="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__map() {
  "${@}"
  map="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__value() {
  "${@}"
  value="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__iterableValue() {
  "${@}"
  iterableValue="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__targetValue() {
  "${@}"
  targetValue="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__targetValue() {
  "${@}"
  targetValue="${besharp_rcrvs[besharp_rcsl + 1]}"
}
Maps ()
{
    __be___this_empty @new EmptyMap
}
Maps.cloneTo ()
{
    local targetMap="${1}";
    local sourceIterable="${2}";
    if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetMap}" )" ]]; then
        @clone @to ${targetMap} shallow $sourceIterable;
        return;
    fi;
    $targetMap.removeAll;
    $this.copyTo $targetMap $sourceIterable
}
Maps.copyTo ()
{
    local value;
    local targetMap="${1}";
    local sourceIterable="${2}";
    if @is $sourceIterable @a PrimitiveObject; then
        local source;
        declare -n source=$sourceIterable;
        local key;
        for key in "${!source[@]}";
        do
            eval "${targetMap}[\"\${key}\"]=\"\${source[\"\${key}\"]}\"";
        done;
        return;
    fi;
    local key;
    while @iterate @of $sourceIterable.keys @in key; do
        __be__value $sourceIterable.get "${key}";
        $targetMap.set "${key}" "${value}";
    done
}
Maps.intersect ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.intersectTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Maps.intersectKeys ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.intersectKeysTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Maps.intersectKeysTo ()
{
    local targetMap="${1}";
    shift 1;
    local targetKey;
    while @iterate @of $targetMap.keys @in targetKey; do
        local iterable;
        for iterable in "${@}";
        do
            if ! @true @collections.has $iterable "${targetKey}"; then
                $targetMap.removeKey "${targetKey}";
                break;
            fi;
        done;
    done
}
Maps.intersectTo ()
{
    local iterableValue targetValue;
    local targetMap="${1}";
    shift 1;
    local allPrimitiveMaps=true;
    for iterableByKeys in "${@}";
    do
        if ! @is $iterableByKeys @a PrimitiveObject || ! @is $iterableByKeys @a Map; then
            allPrimitiveMaps=false;
            break;
        fi;
    done;
    if $allPrimitiveMaps; then
        local targetKey;
        local iterable;
        while @iterate @of $targetMap.keys @in targetKey; do
            for iterable in "${@}";
            do
                eval "if [[ \"\${${iterable}[\"\$targetKey\"]+isset}\" == isset ]]                       && [[ \"\${${targetMap}[\"\$targetKey\"]+isset}\" == isset ]]                       && [[ \"\${${iterable}[\"\$targetKey\"]}\" == \"\${${targetMap}[\"\$targetKey\"]}\" ]]; then continue; fi";
                $targetMap.removeKey "${targetKey}";
            done;
        done;
        return;
    fi;
    local targetKey;
    while @iterate @of $targetMap.keys @in targetKey; do
        __be__targetValue $targetMap.get "${targetKey}";
        local iterable;
        for iterable in "${@}";
        do
            if @true $iterable.hasKey "${targetKey}"; then
                __be__iterableValue $iterable.get "${targetKey}";
                if [[ "${iterableValue}" == "${targetValue}" ]]; then
                    continue;
                fi;
            fi;
            $targetMap.removeKey "${targetKey}";
            break;
        done;
    done
}
Maps.intersectValues ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.intersectValuesTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Maps.intersectValuesTo ()
{
    local targetValue;
    local targetMap="${1}";
    shift 1;
    local targetKey;
    local targetValue;
    while @iterate @of $targetMap.keys @in targetKey; do
        __be__targetValue $targetMap.get "${targetKey}";
        local iterable;
        for iterable in "${@}";
        do
            if ! @true @collections.has $iterable "${targetValue}"; then
                $targetMap.removeKey "${targetKey}";
                break;
            fi;
        done;
    done
}
Maps.make ()
{
    local map;
    __be__map @new ArrayMap;
    $map.setPlainPairs "${@}";
    besharp_rcrvs[besharp_rcsl]=$map
}
Maps.makeImmutable ()
{
    besharp.returningOf @new ImmutableMap "${@}"
}
Maps.makeImmutableOf ()
{
    local immutable;
    local iterable="${1}";
    __be__immutable @new ImmutableMap;
    $this.cloneTo $immutable $iterable;
    besharp_rcrvs[besharp_rcsl]=$immutable
}
Maps.makeOf ()
{
    local map value;
    local iterableByKeys="${1}";
    __be__map @new ArrayMap;
    local key;
    while @iterate @of $iterableByKeys.keys @in key; do
        __be__value $iterableByKeys.get "${key}";
        $map.set "${key}" "${value}";
    done;
    besharp_rcrvs[besharp_rcsl]=$map
}
Maps.overlay ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.overlayTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Maps.overlayTo ()
{
    local targetMap="${1}";
    shift 1;
    local iterableByKeys;
    for iterableByKeys in "${@}";
    do
        $this.copyTo $targetMap $iterableByKeys;
    done
}
Maps.single ()
{
    local key="${1}";
    local value="${2}";
    besharp.returningOf @new ImmutableMap "${key}" "${value}"
}
Maps.subtract ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.subtractTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Maps.subtractKeys ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.subtractKeysTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Maps.subtractKeysTo ()
{
    local targetMap="${1}";
    shift 1;
    local targetKey;
    while @iterate @of $targetMap.keys @in targetKey; do
        local iterable;
        for iterable in "${@}";
        do
            if @true @collections.has "${iterable}" "${targetKey}"; then
                $targetMap.removeKey "${targetKey}";
                break;
            fi;
        done;
    done
}
Maps.subtractTo ()
{
    local iterableValue targetValue;
    local targetMap="${1}";
    shift 1;
    local iterableByKeys;
    local allPrimitiveMaps=true;
    for iterableByKeys in "${@}";
    do
        if ! @is $iterableByKeys @a PrimitiveObject || ! @is $iterableByKeys @a Map; then
            allPrimitiveMaps=false;
            break;
        fi;
    done;
    if $allPrimitiveMaps; then
        local targetKey;
        while @iterate @of $targetMap.keys @in targetKey; do
            for iterableByKeys in "${@}";
            do
                eval "if [[ \"\${${iterableByKeys}[\"\$targetKey\"]+isset}\" == isset ]]                       && [[ \"\${${targetMap}[\"\$targetKey\"]+isset}\" == isset ]]                       && [[ \"\${${iterableByKeys}[\"\$targetKey\"]}\" == \"\${${targetMap}[\"\$targetKey\"]}\" ]]; then                           \$targetMap.removeKey "\${targetKey}" continue 2; fi";
            done;
        done;
        return;
    fi;
    local targetKey;
    while @iterate @of $targetMap.keys @in targetKey; do
        for iterableByKeys in "${@}";
        do
            if @true $iterableByKeys.hasKey "${targetKey}" && @true $targetMap.hasKey "${targetKey}"; then
                __be__iterableValue $iterableByKeys.get "${targetKey}";
                __be__targetValue $targetMap.get "${targetKey}";
                if [[ "${iterableValue}" == "${targetValue}" ]]; then
                    $targetMap.removeKey "${targetKey}";
                    continue 2;
                fi;
            fi;
        done;
    done
}
Maps.subtractValues ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.subtractValuesTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Maps.subtractValuesTo ()
{
    local targetValue;
    local targetMap="${1}";
    shift 1;
    local targetKey;
    while @iterate @of $targetMap.keys @in targetKey; do
        __be__targetValue $targetMap.get "${targetKey}";
        local iterable;
        for iterable in "${@}";
        do
            if @true @collections.has "${iterable}" "${targetValue}"; then
                $targetMap.removeKey "${targetKey}";
                break;
            fi;
        done;
    done
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Sets"]='true'
besharp_oop_type_is["Sets"]='class'
besharp_oop_types["Sets"]="Sets"
declare -Ag besharp_oop_type_Sets_interfaces
besharp_oop_classes["Sets"]="Sets"
besharp_oop_type_parent["Sets"]="Object"
declare -Ag besharp_oop_type_Sets_fields
declare -Ag besharp_oop_type_Sets_injectable_fields
declare -Ag besharp_oop_type_Sets_field_type
declare -Ag besharp_oop_type_Sets_field_default
declare -Ag besharp_oop_type_Sets_methods
declare -Ag besharp_oop_type_Sets_method_body
declare -Ag besharp_oop_type_Sets_method_locals
declare -Ag besharp_oop_type_Sets_method_is_returning
declare -Ag besharp_oop_type_Sets_method_is_abstract
declare -Ag besharp_oop_type_Sets_method_is_using_iterators
declare -Ag besharp_oop_type_Sets_method_is_calling_parent
declare -Ag besharp_oop_type_Sets_method_is_calling_this
besharp_oop_type_static["Sets"]='Sets'
besharp_oop_type_static_accessor["Sets"]='@sets'
besharp_oop_type_Sets_fields['empty']='empty'
besharp_oop_type_Sets_field_type['empty']="Set"
besharp_oop_type_Sets_field_default['empty']=""
besharp_oop_type_Sets_methods['Sets']='Sets'
besharp_oop_type_Sets_method_is_returning["Sets"]=false
besharp_oop_type_Sets_method_body["Sets"]='    __be___this_empty @new EmptySet'
besharp_oop_type_Sets_method_locals["Sets"]=''
besharp_oop_type_Sets_method_is_using_iterators["Sets"]=false
besharp_oop_type_Sets_method_is_calling_parent["Sets"]=false
besharp_oop_type_Sets_method_is_calling_this["Sets"]=true
besharp_oop_type_Sets_methods['cloneTo']='cloneTo'
besharp_oop_type_Sets_method_is_returning["cloneTo"]=true
besharp_oop_type_Sets_method_body["cloneTo"]='    local targetSet="${1}";
    local sourceIterable="${2}";
    if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetSet}" )" ]]; then
        @clone @to ${targetSet} shallow $sourceIterable;
        return;
    fi;
    $targetSet.removeAll;
    $targetSet.addMany $sourceIterable'
besharp_oop_type_Sets_method_locals["cloneTo"]=''
besharp_oop_type_Sets_method_is_using_iterators["cloneTo"]=false
besharp_oop_type_Sets_method_is_calling_parent["cloneTo"]=false
besharp_oop_type_Sets_method_is_calling_this["cloneTo"]=false
besharp_oop_type_Sets_methods['copyTo']='copyTo'
besharp_oop_type_Sets_method_is_returning["copyTo"]=false
besharp_oop_type_Sets_method_body["copyTo"]='    local targetSet="${1}";
    local sourceIterable="${2}";
    $targetSet.addMany $sourceIterable'
besharp_oop_type_Sets_method_locals["copyTo"]=''
besharp_oop_type_Sets_method_is_using_iterators["copyTo"]=false
besharp_oop_type_Sets_method_is_calling_parent["copyTo"]=false
besharp_oop_type_Sets_method_is_calling_this["copyTo"]=false
besharp_oop_type_Sets_methods['intersect']='intersect'
besharp_oop_type_Sets_method_is_returning["intersect"]=true
besharp_oop_type_Sets_method_body["intersect"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.intersectTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Sets_method_locals["intersect"]='local result'
besharp_oop_type_Sets_method_is_using_iterators["intersect"]=false
besharp_oop_type_Sets_method_is_calling_parent["intersect"]=false
besharp_oop_type_Sets_method_is_calling_this["intersect"]=true
besharp_oop_type_Sets_methods['intersectTo']='intersectTo'
besharp_oop_type_Sets_method_is_returning["intersectTo"]=true
besharp_oop_type_Sets_method_body["intersectTo"]='    local objectId ;
    local targetSet="${1}";
    shift 1;
    local allPrimitiveSets=true;
    for iterable in "${@}";
    do
        if ! @is $iterable @a Set || ! @is $iterable @a PrimitiveObject; then
            allPrimitiveSets=false;
            break;
        fi;
    done;
    if $allPrimitiveSets; then
        local targetItem;
        local iterable;
        local objectId;
        while @iterate $targetSet @in targetItem; do
            for iterable in "${@}";
            do
                __be__objectId @object-id $targetItem;
                eval "if [[ \"\${${iterable}[\"\$objectId\"]+isset}\" == isset ]]; then continue; fi";
                $targetSet.remove "${targetItem}";
            done;
        done;
        return;
    fi;
    local targetItem;
    while @iterate $targetSet @in targetItem; do
        local iterable;
        for iterable in "${@}";
        do
            if @is $iterable @a Set; then
                if @is $iterable @a PrimitiveObject; then
                    __be__objectId @object-id $targetItem;
                    eval "if [[ \"\${${iterable}[\"\$objectId\"]+isset}\" == isset ]]; then continue; fi";
                else
                    if @true $iterable.has $targetItem; then
                        continue;
                    fi;
                fi;
            else
                local item;
                @;
                while @iterate $iterable @in item; do
                    if @same "${targetItem}" "${item}"; then
                        continue 2;
                    fi;
                done;
            fi;
            $targetSet.remove "${targetItem}";
        done;
    done'
besharp_oop_type_Sets_method_locals["intersectTo"]='local item
local objectId
local targetItem'
besharp_oop_type_Sets_method_is_using_iterators["intersectTo"]=true
besharp_oop_type_Sets_method_is_calling_parent["intersectTo"]=false
besharp_oop_type_Sets_method_is_calling_this["intersectTo"]=false
besharp_oop_type_Sets_methods['join']='join'
besharp_oop_type_Sets_method_is_returning["join"]=true
besharp_oop_type_Sets_method_body["join"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.joinTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Sets_method_locals["join"]='local result'
besharp_oop_type_Sets_method_is_using_iterators["join"]=false
besharp_oop_type_Sets_method_is_calling_parent["join"]=false
besharp_oop_type_Sets_method_is_calling_this["join"]=true
besharp_oop_type_Sets_methods['joinTo']='joinTo'
besharp_oop_type_Sets_method_is_returning["joinTo"]=false
besharp_oop_type_Sets_method_body["joinTo"]='    local targetSet="${1}";
    shift 1;
    local iterable;
    for iterable in "${@}";
    do
        if @is $iterable @a PrimitiveObject && @is $iterable @a Set; then
            local temp;
            declare -n temp="${iterable}";
            local key;
            for key in "${!temp[@]}";
            do
                eval "${targetSet}[\"\${key}\"]=\"\${${iterable}[\"\${key}\"]}\"";
            done;
        else
            $targetSet.addMany $iterable;
        fi;
    done'
besharp_oop_type_Sets_method_locals["joinTo"]=''
besharp_oop_type_Sets_method_is_using_iterators["joinTo"]=false
besharp_oop_type_Sets_method_is_calling_parent["joinTo"]=false
besharp_oop_type_Sets_method_is_calling_this["joinTo"]=false
besharp_oop_type_Sets_methods['make']='make'
besharp_oop_type_Sets_method_is_returning["make"]=true
besharp_oop_type_Sets_method_body["make"]='    local set ;
    __be__set @new ArraySet;
    $set.addMany @array "${@}";
    besharp_rcrvs[besharp_rcsl]=$set'
besharp_oop_type_Sets_method_locals["make"]='local set'
besharp_oop_type_Sets_method_is_using_iterators["make"]=false
besharp_oop_type_Sets_method_is_calling_parent["make"]=false
besharp_oop_type_Sets_method_is_calling_this["make"]=false
besharp_oop_type_Sets_methods['makeImmutable']='makeImmutable'
besharp_oop_type_Sets_method_is_returning["makeImmutable"]=true
besharp_oop_type_Sets_method_body["makeImmutable"]='    besharp.returningOf @new ImmutableSet "${@}"'
besharp_oop_type_Sets_method_locals["makeImmutable"]=''
besharp_oop_type_Sets_method_is_using_iterators["makeImmutable"]=false
besharp_oop_type_Sets_method_is_calling_parent["makeImmutable"]=false
besharp_oop_type_Sets_method_is_calling_this["makeImmutable"]=false
besharp_oop_type_Sets_methods['makeImmutableOf']='makeImmutableOf'
besharp_oop_type_Sets_method_is_returning["makeImmutableOf"]=true
besharp_oop_type_Sets_method_body["makeImmutableOf"]='    local iterable="${1}";
    local items=();
    local item;
    while @iterate $iterable @in item; do
        items+=("${item}");
    done;
    besharp.returningOf @new ImmutableSet "${items[@]}"'
besharp_oop_type_Sets_method_locals["makeImmutableOf"]='local item'
besharp_oop_type_Sets_method_is_using_iterators["makeImmutableOf"]=true
besharp_oop_type_Sets_method_is_calling_parent["makeImmutableOf"]=false
besharp_oop_type_Sets_method_is_calling_this["makeImmutableOf"]=false
besharp_oop_type_Sets_methods['makeOf']='makeOf'
besharp_oop_type_Sets_method_is_returning["makeOf"]=true
besharp_oop_type_Sets_method_body["makeOf"]='    local set ;
    local iterable="${1}";
    __be__set @new ArraySet;
    $set.addMany @iterable "${iterable}";
    besharp_rcrvs[besharp_rcsl]=$set'
besharp_oop_type_Sets_method_locals["makeOf"]='local set'
besharp_oop_type_Sets_method_is_using_iterators["makeOf"]=false
besharp_oop_type_Sets_method_is_calling_parent["makeOf"]=false
besharp_oop_type_Sets_method_is_calling_this["makeOf"]=false
besharp_oop_type_Sets_methods['single']='single'
besharp_oop_type_Sets_method_is_returning["single"]=true
besharp_oop_type_Sets_method_body["single"]='    local item="${1}";
    besharp.returningOf @new ImmutableSet "${item}"'
besharp_oop_type_Sets_method_locals["single"]=''
besharp_oop_type_Sets_method_is_using_iterators["single"]=false
besharp_oop_type_Sets_method_is_calling_parent["single"]=false
besharp_oop_type_Sets_method_is_calling_this["single"]=false
besharp_oop_type_Sets_methods['subtract']='subtract'
besharp_oop_type_Sets_method_is_returning["subtract"]=true
besharp_oop_type_Sets_method_body["subtract"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.subtractTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Sets_method_locals["subtract"]='local result'
besharp_oop_type_Sets_method_is_using_iterators["subtract"]=false
besharp_oop_type_Sets_method_is_calling_parent["subtract"]=false
besharp_oop_type_Sets_method_is_calling_this["subtract"]=true
besharp_oop_type_Sets_methods['subtractTo']='subtractTo'
besharp_oop_type_Sets_method_is_returning["subtractTo"]=true
besharp_oop_type_Sets_method_body["subtractTo"]='    local objectId ;
    local targetSet="${1}";
    shift 1;
    local allPrimitiveSets=true;
    for iterable in "${@}";
    do
        if ! @is $iterable @a Set || ! @is $iterable @a PrimitiveObject; then
            allPrimitiveSets=false;
            break;
        fi;
    done;
    if $allPrimitiveSets; then
        local targetItem;
        local iterable;
        local objectId;
        while @iterate $targetSet @in targetItem; do
            for iterable in "${@}";
            do
                __be__objectId @object-id $targetItem;
                eval "if [[ \"\${${iterable}[\"\$objectId\"]+isset}\" == isset ]]; then                       \$targetSet.remove "\${targetItem}"; continue 2; fi";
            done;
        done;
        return;
    fi;
    local targetItem;
    while @iterate $targetSet @in targetItem; do
        local iterable;
        for iterable in "${@}";
        do
            if @is $iterable @a Set; then
                if @is $iterable @a PrimitiveObject; then
                    __be__objectId @object-id $targetItem;
                    eval "if [[ \"\${${iterable}[\"\$objectId\"]+isset}\" == isset ]]; then                             \$targetSet.remove "\${targetItem}"; continue 2; fi";
                else
                    if @true $iterable.has $targetItem; then
                        $targetSet.remove "${targetItem}";
                        continue 2;
                    fi;
                fi;
            else
                local item;
                @;
                while @iterate $iterable @in item; do
                    if @same "${targetItem}" "${item}"; then
                        $targetSet.remove "${targetItem}";
                        continue 3;
                    fi;
                done;
            fi;
        done;
    done'
besharp_oop_type_Sets_method_locals["subtractTo"]='local item
local objectId
local targetItem'
besharp_oop_type_Sets_method_is_using_iterators["subtractTo"]=true
besharp_oop_type_Sets_method_is_calling_parent["subtractTo"]=false
besharp_oop_type_Sets_method_is_calling_this["subtractTo"]=false

fi
if ${beshfile_section__code:-false}; then :;
function __be___this_empty() {
  "${@}"
  eval $this"_empty=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__objectId() {
  "${@}"
  objectId="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__set() {
  "${@}"
  set="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__set() {
  "${@}"
  set="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__objectId() {
  "${@}"
  objectId="${besharp_rcrvs[besharp_rcsl + 1]}"
}
Sets ()
{
    __be___this_empty @new EmptySet
}
Sets.cloneTo ()
{
    local targetSet="${1}";
    local sourceIterable="${2}";
    if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetSet}" )" ]]; then
        @clone @to ${targetSet} shallow $sourceIterable;
        return;
    fi;
    $targetSet.removeAll;
    $targetSet.addMany $sourceIterable
}
Sets.copyTo ()
{
    local targetSet="${1}";
    local sourceIterable="${2}";
    $targetSet.addMany $sourceIterable
}
Sets.intersect ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.intersectTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Sets.intersectTo ()
{
    local objectId;
    local targetSet="${1}";
    shift 1;
    local allPrimitiveSets=true;
    for iterable in "${@}";
    do
        if ! @is $iterable @a Set || ! @is $iterable @a PrimitiveObject; then
            allPrimitiveSets=false;
            break;
        fi;
    done;
    if $allPrimitiveSets; then
        local targetItem;
        local iterable;
        local objectId;
        while @iterate $targetSet @in targetItem; do
            for iterable in "${@}";
            do
                __be__objectId @object-id $targetItem;
                eval "if [[ \"\${${iterable}[\"\$objectId\"]+isset}\" == isset ]]; then continue; fi";
                $targetSet.remove "${targetItem}";
            done;
        done;
        return;
    fi;
    local targetItem;
    while @iterate $targetSet @in targetItem; do
        local iterable;
        for iterable in "${@}";
        do
            if @is $iterable @a Set; then
                if @is $iterable @a PrimitiveObject; then
                    __be__objectId @object-id $targetItem;
                    eval "if [[ \"\${${iterable}[\"\$objectId\"]+isset}\" == isset ]]; then continue; fi";
                else
                    if @true $iterable.has $targetItem; then
                        continue;
                    fi;
                fi;
            else
                local item;
                @;
                while @iterate $iterable @in item; do
                    if @same "${targetItem}" "${item}"; then
                        continue 2;
                    fi;
                done;
            fi;
            $targetSet.remove "${targetItem}";
        done;
    done
}
Sets.join ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.joinTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Sets.joinTo ()
{
    local targetSet="${1}";
    shift 1;
    local iterable;
    for iterable in "${@}";
    do
        if @is $iterable @a PrimitiveObject && @is $iterable @a Set; then
            local temp;
            declare -n temp="${iterable}";
            local key;
            for key in "${!temp[@]}";
            do
                eval "${targetSet}[\"\${key}\"]=\"\${${iterable}[\"\${key}\"]}\"";
            done;
        else
            $targetSet.addMany $iterable;
        fi;
    done
}
Sets.make ()
{
    local set;
    __be__set @new ArraySet;
    $set.addMany @array "${@}";
    besharp_rcrvs[besharp_rcsl]=$set
}
Sets.makeImmutable ()
{
    besharp.returningOf @new ImmutableSet "${@}"
}
Sets.makeImmutableOf ()
{
    local iterable="${1}";
    local items=();
    local item;
    while @iterate $iterable @in item; do
        items+=("${item}");
    done;
    besharp.returningOf @new ImmutableSet "${items[@]}"
}
Sets.makeOf ()
{
    local set;
    local iterable="${1}";
    __be__set @new ArraySet;
    $set.addMany @iterable "${iterable}";
    besharp_rcrvs[besharp_rcsl]=$set
}
Sets.single ()
{
    local item="${1}";
    besharp.returningOf @new ImmutableSet "${item}"
}
Sets.subtract ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.subtractTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Sets.subtractTo ()
{
    local objectId;
    local targetSet="${1}";
    shift 1;
    local allPrimitiveSets=true;
    for iterable in "${@}";
    do
        if ! @is $iterable @a Set || ! @is $iterable @a PrimitiveObject; then
            allPrimitiveSets=false;
            break;
        fi;
    done;
    if $allPrimitiveSets; then
        local targetItem;
        local iterable;
        local objectId;
        while @iterate $targetSet @in targetItem; do
            for iterable in "${@}";
            do
                __be__objectId @object-id $targetItem;
                eval "if [[ \"\${${iterable}[\"\$objectId\"]+isset}\" == isset ]]; then                       \$targetSet.remove "\${targetItem}"; continue 2; fi";
            done;
        done;
        return;
    fi;
    local targetItem;
    while @iterate $targetSet @in targetItem; do
        local iterable;
        for iterable in "${@}";
        do
            if @is $iterable @a Set; then
                if @is $iterable @a PrimitiveObject; then
                    __be__objectId @object-id $targetItem;
                    eval "if [[ \"\${${iterable}[\"\$objectId\"]+isset}\" == isset ]]; then                             \$targetSet.remove "\${targetItem}"; continue 2; fi";
                else
                    if @true $iterable.has $targetItem; then
                        $targetSet.remove "${targetItem}";
                        continue 2;
                    fi;
                fi;
            else
                local item;
                @;
                while @iterate $iterable @in item; do
                    if @same "${targetItem}" "${item}"; then
                        $targetSet.remove "${targetItem}";
                        continue 3;
                    fi;
                done;
            fi;
        done;
    done
}

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_internal["Vectors"]='true'
besharp_oop_type_is["Vectors"]='class'
besharp_oop_types["Vectors"]="Vectors"
declare -Ag besharp_oop_type_Vectors_interfaces
besharp_oop_classes["Vectors"]="Vectors"
besharp_oop_type_parent["Vectors"]="Object"
declare -Ag besharp_oop_type_Vectors_fields
declare -Ag besharp_oop_type_Vectors_injectable_fields
declare -Ag besharp_oop_type_Vectors_field_type
declare -Ag besharp_oop_type_Vectors_field_default
declare -Ag besharp_oop_type_Vectors_methods
declare -Ag besharp_oop_type_Vectors_method_body
declare -Ag besharp_oop_type_Vectors_method_locals
declare -Ag besharp_oop_type_Vectors_method_is_returning
declare -Ag besharp_oop_type_Vectors_method_is_abstract
declare -Ag besharp_oop_type_Vectors_method_is_using_iterators
declare -Ag besharp_oop_type_Vectors_method_is_calling_parent
declare -Ag besharp_oop_type_Vectors_method_is_calling_this
besharp_oop_type_static["Vectors"]='Vectors'
besharp_oop_type_static_accessor["Vectors"]='@vectors'
besharp_oop_type_Vectors_fields['empty']='empty'
besharp_oop_type_Vectors_field_type['empty']="Vector"
besharp_oop_type_Vectors_field_default['empty']=""
besharp_oop_type_Vectors_methods['Vectors']='Vectors'
besharp_oop_type_Vectors_method_is_returning["Vectors"]=false
besharp_oop_type_Vectors_method_body["Vectors"]='    __be___this_empty @new EmptyVector'
besharp_oop_type_Vectors_method_locals["Vectors"]=''
besharp_oop_type_Vectors_method_is_using_iterators["Vectors"]=false
besharp_oop_type_Vectors_method_is_calling_parent["Vectors"]=false
besharp_oop_type_Vectors_method_is_calling_this["Vectors"]=true
besharp_oop_type_Vectors_methods['cloneTo']='cloneTo'
besharp_oop_type_Vectors_method_is_returning["cloneTo"]=true
besharp_oop_type_Vectors_method_body["cloneTo"]='    local targetVector="${1}";
    local sourceIterable="${2}";
    if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetVector}" )" ]]; then
        @clone @to ${targetVector} shallow $sourceIterable;
        return;
    fi;
    $targetVector.removeAll;
    $this.copyTo $targetVector $sourceIterable'
besharp_oop_type_Vectors_method_locals["cloneTo"]=''
besharp_oop_type_Vectors_method_is_using_iterators["cloneTo"]=false
besharp_oop_type_Vectors_method_is_calling_parent["cloneTo"]=false
besharp_oop_type_Vectors_method_is_calling_this["cloneTo"]=true
besharp_oop_type_Vectors_methods['copyTo']='copyTo'
besharp_oop_type_Vectors_method_is_returning["copyTo"]=true
besharp_oop_type_Vectors_method_body["copyTo"]='    local targetVector="${1}";
    local sourceIterable="${2}";
    if @is $sourceIterable @a PrimitiveObject; then
        eval "${targetVector}+=( \"\${${sourceIterable}[@]}\" )";
        return;
    fi;
    $targetVector.addMany $sourceIterable'
besharp_oop_type_Vectors_method_locals["copyTo"]=''
besharp_oop_type_Vectors_method_is_using_iterators["copyTo"]=false
besharp_oop_type_Vectors_method_is_calling_parent["copyTo"]=false
besharp_oop_type_Vectors_method_is_calling_this["copyTo"]=false
besharp_oop_type_Vectors_methods['intersect']='intersect'
besharp_oop_type_Vectors_method_is_returning["intersect"]=true
besharp_oop_type_Vectors_method_body["intersect"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result @new ArrayVector;
    local targetValue;
    while @iterate $first @in targetValue; do
        local iterable;
        for iterable in "${@}";
        do
            if ! @true @collections.has $iterable "${targetValue}"; then
                continue 2;
            fi;
        done;
        $result.add "${targetValue}";
    done;
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Vectors_method_locals["intersect"]='local result
local targetValue'
besharp_oop_type_Vectors_method_is_using_iterators["intersect"]=true
besharp_oop_type_Vectors_method_is_calling_parent["intersect"]=false
besharp_oop_type_Vectors_method_is_calling_this["intersect"]=false
besharp_oop_type_Vectors_methods['intersectTo']='intersectTo'
besharp_oop_type_Vectors_method_is_returning["intersectTo"]=false
besharp_oop_type_Vectors_method_body["intersectTo"]='    local sourceSize targetValue ;
    local targetVector="${1}";
    shift 1;
    local i;
    local targetValue;
    __be__sourceSize $targetVector.size;
    local indicesToRemove=();
    for ((i = 0; i < sourceSize; ++i ))
    do
        __be__targetValue $targetVector.get "${i}";
        local iterable;
        for iterable in "${@}";
        do
            if ! @true @collections.has $iterable "${targetValue}"; then
                indicesToRemove+=("${i}");
                break;
            fi;
        done;
    done;
    $targetVector.removeIndices "${indicesToRemove[@]}"'
besharp_oop_type_Vectors_method_locals["intersectTo"]='local sourceSize
local targetValue'
besharp_oop_type_Vectors_method_is_using_iterators["intersectTo"]=false
besharp_oop_type_Vectors_method_is_calling_parent["intersectTo"]=false
besharp_oop_type_Vectors_method_is_calling_this["intersectTo"]=false
besharp_oop_type_Vectors_methods['join']='join'
besharp_oop_type_Vectors_method_is_returning["join"]=true
besharp_oop_type_Vectors_method_body["join"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.joinTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Vectors_method_locals["join"]='local result'
besharp_oop_type_Vectors_method_is_using_iterators["join"]=false
besharp_oop_type_Vectors_method_is_calling_parent["join"]=false
besharp_oop_type_Vectors_method_is_calling_this["join"]=true
besharp_oop_type_Vectors_methods['joinTo']='joinTo'
besharp_oop_type_Vectors_method_is_returning["joinTo"]=false
besharp_oop_type_Vectors_method_body["joinTo"]='    local targetVector="${1}";
    shift 1;
    local iterable;
    for iterable in "${@}";
    do
        if @is $iterable @a PrimitiveObject && ( @is $iterable @a List || @is $iterable @a Set || @is $iterable @a Map ); then
            eval "${targetVector}+=( \"\${${iterable}[@]}\" )";
        else
            $targetVector.addMany $iterable;
        fi;
    done'
besharp_oop_type_Vectors_method_locals["joinTo"]=''
besharp_oop_type_Vectors_method_is_using_iterators["joinTo"]=false
besharp_oop_type_Vectors_method_is_calling_parent["joinTo"]=false
besharp_oop_type_Vectors_method_is_calling_this["joinTo"]=false
besharp_oop_type_Vectors_methods['make']='make'
besharp_oop_type_Vectors_method_is_returning["make"]=true
besharp_oop_type_Vectors_method_body["make"]='    local vector ;
    __be__vector @new ArrayVector;
    $vector.setPlain "${@}";
    besharp_rcrvs[besharp_rcsl]=$vector'
besharp_oop_type_Vectors_method_locals["make"]='local vector'
besharp_oop_type_Vectors_method_is_using_iterators["make"]=false
besharp_oop_type_Vectors_method_is_calling_parent["make"]=false
besharp_oop_type_Vectors_method_is_calling_this["make"]=false
besharp_oop_type_Vectors_methods['makeImmutable']='makeImmutable'
besharp_oop_type_Vectors_method_is_returning["makeImmutable"]=true
besharp_oop_type_Vectors_method_body["makeImmutable"]='    besharp.returningOf @new ImmutableVector "${@}"'
besharp_oop_type_Vectors_method_locals["makeImmutable"]=''
besharp_oop_type_Vectors_method_is_using_iterators["makeImmutable"]=false
besharp_oop_type_Vectors_method_is_calling_parent["makeImmutable"]=false
besharp_oop_type_Vectors_method_is_calling_this["makeImmutable"]=false
besharp_oop_type_Vectors_methods['makeImmutableOf']='makeImmutableOf'
besharp_oop_type_Vectors_method_is_returning["makeImmutableOf"]=true
besharp_oop_type_Vectors_method_body["makeImmutableOf"]='    local immutable ;
    local iterable="${1}";
    __be__immutable @new ImmutableVector;
    $this.cloneTo $immutable $iterable;
    besharp_rcrvs[besharp_rcsl]=$immutable'
besharp_oop_type_Vectors_method_locals["makeImmutableOf"]='local immutable'
besharp_oop_type_Vectors_method_is_using_iterators["makeImmutableOf"]=false
besharp_oop_type_Vectors_method_is_calling_parent["makeImmutableOf"]=false
besharp_oop_type_Vectors_method_is_calling_this["makeImmutableOf"]=true
besharp_oop_type_Vectors_methods['makeOf']='makeOf'
besharp_oop_type_Vectors_method_is_returning["makeOf"]=true
besharp_oop_type_Vectors_method_body["makeOf"]='    local vector ;
    local iterable="${1}";
    if @is $iterable @exact ArrayVector; then
        besharp.returningOf @clone shallow $iterable;
        return;
    fi;
    __be__vector @new ArrayVector;
    $vector.addMany @iterable "${iterable}";
    besharp_rcrvs[besharp_rcsl]=$vector'
besharp_oop_type_Vectors_method_locals["makeOf"]='local vector'
besharp_oop_type_Vectors_method_is_using_iterators["makeOf"]=false
besharp_oop_type_Vectors_method_is_calling_parent["makeOf"]=false
besharp_oop_type_Vectors_method_is_calling_this["makeOf"]=false
besharp_oop_type_Vectors_methods['nCopies']='nCopies'
besharp_oop_type_Vectors_method_is_returning["nCopies"]=true
besharp_oop_type_Vectors_method_body["nCopies"]='    local item="${1}";
    local numOfCopies="${2}";
    if (( numOfCopies == 0 )); then
        besharp.returningOf @new EmptyVector;
        return;
    fi;
    local copies=();
    while (( numOfCopies-- )); do
        copies+=("${item}");
    done;
    besharp.returningOf @new ImmutableVector "${copies[@]}"'
besharp_oop_type_Vectors_method_locals["nCopies"]=''
besharp_oop_type_Vectors_method_is_using_iterators["nCopies"]=false
besharp_oop_type_Vectors_method_is_calling_parent["nCopies"]=false
besharp_oop_type_Vectors_method_is_calling_this["nCopies"]=false
besharp_oop_type_Vectors_methods['single']='single'
besharp_oop_type_Vectors_method_is_returning["single"]=true
besharp_oop_type_Vectors_method_body["single"]='    local item="${1}";
    besharp.returningOf @new ImmutableVector "${item}"'
besharp_oop_type_Vectors_method_locals["single"]=''
besharp_oop_type_Vectors_method_is_using_iterators["single"]=false
besharp_oop_type_Vectors_method_is_calling_parent["single"]=false
besharp_oop_type_Vectors_method_is_calling_this["single"]=false
besharp_oop_type_Vectors_methods['slice']='slice'
besharp_oop_type_Vectors_method_is_returning["slice"]=true
besharp_oop_type_Vectors_method_body["slice"]='    local result ;
    local list="${1}";
    local indexA="${2}";
    local indexB="${3}";
    __be__result @new ArrayVector;
    $this.sliceTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Vectors_method_locals["slice"]='local result'
besharp_oop_type_Vectors_method_is_using_iterators["slice"]=false
besharp_oop_type_Vectors_method_is_calling_parent["slice"]=false
besharp_oop_type_Vectors_method_is_calling_this["slice"]=true
besharp_oop_type_Vectors_methods['sliceTo']='sliceTo'
besharp_oop_type_Vectors_method_is_returning["sliceTo"]=false
besharp_oop_type_Vectors_method_body["sliceTo"]='    @lists.sliceTo "${@}"'
besharp_oop_type_Vectors_method_locals["sliceTo"]=''
besharp_oop_type_Vectors_method_is_using_iterators["sliceTo"]=false
besharp_oop_type_Vectors_method_is_calling_parent["sliceTo"]=false
besharp_oop_type_Vectors_method_is_calling_this["sliceTo"]=false
besharp_oop_type_Vectors_methods['subtract']='subtract'
besharp_oop_type_Vectors_method_is_returning["subtract"]=true
besharp_oop_type_Vectors_method_body["subtract"]='    local result ;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.subtractTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result'
besharp_oop_type_Vectors_method_locals["subtract"]='local result'
besharp_oop_type_Vectors_method_is_using_iterators["subtract"]=false
besharp_oop_type_Vectors_method_is_calling_parent["subtract"]=false
besharp_oop_type_Vectors_method_is_calling_this["subtract"]=true
besharp_oop_type_Vectors_methods['subtractTo']='subtractTo'
besharp_oop_type_Vectors_method_is_returning["subtractTo"]=false
besharp_oop_type_Vectors_method_body["subtractTo"]='    local sourceSize targetValue ;
    local targetVector="${1}";
    shift 1;
    local i;
    local targetValue;
    __be__sourceSize $targetVector.size;
    local indicesToRemove=();
    for ((i = 0; i < sourceSize; ++i ))
    do
        __be__targetValue $targetVector.get "${i}";
        local iterable;
        for iterable in "${@}";
        do
            if @true @collections.has $iterable "${targetValue}"; then
                indicesToRemove+=("${i}");
                break;
            fi;
        done;
    done;
    $targetVector.removeIndices "${indicesToRemove[@]}"'
besharp_oop_type_Vectors_method_locals["subtractTo"]='local sourceSize
local targetValue'
besharp_oop_type_Vectors_method_is_using_iterators["subtractTo"]=false
besharp_oop_type_Vectors_method_is_calling_parent["subtractTo"]=false
besharp_oop_type_Vectors_method_is_calling_this["subtractTo"]=false

fi
if ${beshfile_section__code:-false}; then :;
function __be___this_empty() {
  "${@}"
  eval $this"_empty=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__sourceSize() {
  "${@}"
  sourceSize="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__targetValue() {
  "${@}"
  targetValue="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__vector() {
  "${@}"
  vector="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__immutable() {
  "${@}"
  immutable="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__vector() {
  "${@}"
  vector="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__result() {
  "${@}"
  result="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__sourceSize() {
  "${@}"
  sourceSize="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__targetValue() {
  "${@}"
  targetValue="${besharp_rcrvs[besharp_rcsl + 1]}"
}
Vectors ()
{
    __be___this_empty @new EmptyVector
}
Vectors.cloneTo ()
{
    local targetVector="${1}";
    local sourceIterable="${2}";
    if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetVector}" )" ]]; then
        @clone @to ${targetVector} shallow $sourceIterable;
        return;
    fi;
    $targetVector.removeAll;
    $this.copyTo $targetVector $sourceIterable
}
Vectors.copyTo ()
{
    local targetVector="${1}";
    local sourceIterable="${2}";
    if @is $sourceIterable @a PrimitiveObject; then
        eval "${targetVector}+=( \"\${${sourceIterable}[@]}\" )";
        return;
    fi;
    $targetVector.addMany $sourceIterable
}
Vectors.intersect ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result @new ArrayVector;
    local targetValue;
    while @iterate $first @in targetValue; do
        local iterable;
        for iterable in "${@}";
        do
            if ! @true @collections.has $iterable "${targetValue}"; then
                continue 2;
            fi;
        done;
        $result.add "${targetValue}";
    done;
    besharp_rcrvs[besharp_rcsl]=$result
}
Vectors.intersectTo ()
{
    local sourceSize targetValue;
    local targetVector="${1}";
    shift 1;
    local i;
    local targetValue;
    __be__sourceSize $targetVector.size;
    local indicesToRemove=();
    for ((i = 0; i < sourceSize; ++i ))
    do
        __be__targetValue $targetVector.get "${i}";
        local iterable;
        for iterable in "${@}";
        do
            if ! @true @collections.has $iterable "${targetValue}"; then
                indicesToRemove+=("${i}");
                break;
            fi;
        done;
    done;
    $targetVector.removeIndices "${indicesToRemove[@]}"
}
Vectors.join ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.joinTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Vectors.joinTo ()
{
    local targetVector="${1}";
    shift 1;
    local iterable;
    for iterable in "${@}";
    do
        if @is $iterable @a PrimitiveObject && ( @is $iterable @a List || @is $iterable @a Set || @is $iterable @a Map ); then
            eval "${targetVector}+=( \"\${${iterable}[@]}\" )";
        else
            $targetVector.addMany $iterable;
        fi;
    done
}
Vectors.make ()
{
    local vector;
    __be__vector @new ArrayVector;
    $vector.setPlain "${@}";
    besharp_rcrvs[besharp_rcsl]=$vector
}
Vectors.makeImmutable ()
{
    besharp.returningOf @new ImmutableVector "${@}"
}
Vectors.makeImmutableOf ()
{
    local immutable;
    local iterable="${1}";
    __be__immutable @new ImmutableVector;
    $this.cloneTo $immutable $iterable;
    besharp_rcrvs[besharp_rcsl]=$immutable
}
Vectors.makeOf ()
{
    local vector;
    local iterable="${1}";
    if @is $iterable @exact ArrayVector; then
        besharp.returningOf @clone shallow $iterable;
        return;
    fi;
    __be__vector @new ArrayVector;
    $vector.addMany @iterable "${iterable}";
    besharp_rcrvs[besharp_rcsl]=$vector
}
Vectors.nCopies ()
{
    local item="${1}";
    local numOfCopies="${2}";
    if (( numOfCopies == 0 )); then
        besharp.returningOf @new EmptyVector;
        return;
    fi;
    local copies=();
    while (( numOfCopies-- )); do
        copies+=("${item}");
    done;
    besharp.returningOf @new ImmutableVector "${copies[@]}"
}
Vectors.single ()
{
    local item="${1}";
    besharp.returningOf @new ImmutableVector "${item}"
}
Vectors.slice ()
{
    local result;
    local list="${1}";
    local indexA="${2}";
    local indexB="${3}";
    __be__result @new ArrayVector;
    $this.sliceTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Vectors.sliceTo ()
{
    @lists.sliceTo "${@}"
}
Vectors.subtract ()
{
    local result;
    local first="${1}";
    shift 1;
    __be__result $this.makeOf $first;
    $this.subtractTo $result "${@}";
    besharp_rcrvs[besharp_rcsl]=$result
}
Vectors.subtractTo ()
{
    local sourceSize targetValue;
    local targetVector="${1}";
    shift 1;
    local i;
    local targetValue;
    __be__sourceSize $targetVector.size;
    local indicesToRemove=();
    for ((i = 0; i < sourceSize; ++i ))
    do
        __be__targetValue $targetVector.get "${i}";
        local iterable;
        for iterable in "${@}";
        do
            if @true @collections.has $iterable "${targetValue}"; then
                indicesToRemove+=("${i}");
                break;
            fi;
        done;
    done;
    $targetVector.removeIndices "${indicesToRemove[@]}"
}

fi
if ${beshfile_section__code:-false}; then :;

fi
if ${beshfile_section__code:-false}; then :;

export besharp_oopRuntime_object_count=0

export besharp_oopRuntime_disable_constructor=false
export besharp_runtime_reset_iteration=0
export besharp_rcsl=1
declare -axg besharp_rcrvs
declare -axg besharp_runtime_current_iterator_keys__stack_x=()

fi
if ${beshfile_section__code:-false}; then :;

function besharp.runtime.entrypoint_micro() {
    set -eu

    if ! command -v "${BESHARP_RUNTIME_PATH:-besharp}" > /dev/null 2> /dev/null; then
        echo "" >&2
        echo "Cannot find ${BESHARP_RUNTIME_PATH:-besharp} !" >&2
        echo "" >&2
        echo "Please either make it accessible by your \$PATH variable, " >&2
        echo "or provide \${BESHARP_RUNTIME_PATH} environment variable pointing to the 'besharp' executable file. " >&2
        return 1
    fi

    "${BESHARP_RUNTIME_PATH:-besharp}" --besharp-include "${0}" \
        "${@}" \
    ;

}

fi
if ${beshfile_section__code:-false}; then :;

function besharp.oopRuntime.turnOnDevelopMode() {
    besharp.oopRuntime.disableCollectingDiBindings
    besharp.oopRuntime.addBootstrapTag develop
}

fi
if ${beshfile_section__code:-false}; then :;

function @class() {
    :
}

function @static() {
    :
}

function @classdone() {
    :
}

function @interface() {
    :
}

function @intdone() {
    :
}

function @var() {
    :
}

function @abstract() {
    :
}

function @internal() {
    :
}

fi
if false; then :;
    besharp.runtime.entrypoint "${@}"

fi
if ${beshfile_section__oop_meta:-false}; then :;
besharp_oop_type_is["AppEntrypoint"]='class'
besharp_oop_types["AppEntrypoint"]="AppEntrypoint"
declare -Ag besharp_oop_type_AppEntrypoint_interfaces
besharp_oop_type_AppEntrypoint_interfaces['Entrypoint']='Entrypoint'
besharp_oop_classes["AppEntrypoint"]="AppEntrypoint"
besharp_oop_type_parent["AppEntrypoint"]="Object"
declare -Ag besharp_oop_type_AppEntrypoint_fields
declare -Ag besharp_oop_type_AppEntrypoint_injectable_fields
declare -Ag besharp_oop_type_AppEntrypoint_field_type
declare -Ag besharp_oop_type_AppEntrypoint_field_default
declare -Ag besharp_oop_type_AppEntrypoint_methods
declare -Ag besharp_oop_type_AppEntrypoint_method_body
declare -Ag besharp_oop_type_AppEntrypoint_method_locals
declare -Ag besharp_oop_type_AppEntrypoint_method_is_returning
declare -Ag besharp_oop_type_AppEntrypoint_method_is_abstract
declare -Ag besharp_oop_type_AppEntrypoint_method_is_using_iterators
declare -Ag besharp_oop_type_AppEntrypoint_method_is_calling_parent
declare -Ag besharp_oop_type_AppEntrypoint_method_is_calling_this
besharp_oop_type_AppEntrypoint_methods['AppEntrypoint']='AppEntrypoint'
besharp_oop_type_AppEntrypoint_method_is_returning["AppEntrypoint"]=false
besharp_oop_type_AppEntrypoint_method_body["AppEntrypoint"]='    @parent "${@}"'
besharp_oop_type_AppEntrypoint_method_locals["AppEntrypoint"]=''
besharp_oop_type_AppEntrypoint_method_is_using_iterators["AppEntrypoint"]=false
besharp_oop_type_AppEntrypoint_method_is_calling_parent["AppEntrypoint"]=true
besharp_oop_type_AppEntrypoint_method_is_calling_this["AppEntrypoint"]=false
besharp_oop_type_AppEntrypoint_methods['greetingText']='greetingText'
besharp_oop_type_AppEntrypoint_method_is_returning["greetingText"]=true
besharp_oop_type_AppEntrypoint_method_body["greetingText"]='    local args="${1}";
    besharp_rcrvs[besharp_rcsl]="$( @ $args.get greeting ) $( @ $args.get subject )$( @ $args.get suffix )"'
besharp_oop_type_AppEntrypoint_method_locals["greetingText"]=''
besharp_oop_type_AppEntrypoint_method_is_using_iterators["greetingText"]=false
besharp_oop_type_AppEntrypoint_method_is_calling_parent["greetingText"]=false
besharp_oop_type_AppEntrypoint_method_is_calling_this["greetingText"]=false
besharp_oop_type_AppEntrypoint_methods['main']='main'
besharp_oop_type_AppEntrypoint_method_is_returning["main"]=true
besharp_oop_type_AppEntrypoint_method_body["main"]='    local args greetingText ;
    __be__args $this.makeArguments "${@}";
    if @true $args.get isAskingForHelp; then
        echo '"'"'An example Hello-World App for the BeSharp Framework.'"'"' 1>&2;
        echo '"'"''"'"' 1>&2;
        echo '"'"'Usage:'"'"' 1>&2;
        $args.printUsage 1>&2;
        return 0;
    fi;
    __be__greetingText $this.greetingText $args;
    if @true $args.get isLoud; then
        echo "$( @fmt bold )${greetingText}$( @fmt reset )";
    else
        echo "${greetingText}";
    fi'
besharp_oop_type_AppEntrypoint_method_locals["main"]='local args
local greetingText'
besharp_oop_type_AppEntrypoint_method_is_using_iterators["main"]=false
besharp_oop_type_AppEntrypoint_method_is_calling_parent["main"]=false
besharp_oop_type_AppEntrypoint_method_is_calling_this["main"]=true
besharp_oop_type_AppEntrypoint_methods['makeArguments']='makeArguments'
besharp_oop_type_AppEntrypoint_method_is_returning["makeArguments"]=true
besharp_oop_type_AppEntrypoint_method_body["makeArguments"]='    local arguments ;
    __be__arguments @new Arguments "${@}";
    $arguments.add greeting '"'"'--greeting'"'"' '"'"'-g'"'"' '"'"'The way you want to greet. Default greeting is: '"'"' '"'"'Hello'"'"';
    $arguments.add subject '"'"'--subject'"'"' '"'"'-s'"'"' '"'"'The subject you want to greet. Default subject is: '"'"' '"'"'World'"'"';
    $arguments.add suffix '"'"'--suffix'"'"' '"'"'-u'"'"' '"'"'The string being placed at the end. Default is: '"'"' '"'"'.'"'"';
    $arguments.addFlag isLoud '"'"'--loud'"'"' '"'"'-l'"'"' '"'"'Makes bold output.'"'"' '"'"'false'"'"';
    $arguments.addFlag isAskingForHelp '"'"'--help'"'"' '"'"'-h'"'"' '"'"'Show help.'"'"' '"'"'false'"'"';
    $arguments.process;
    besharp_rcrvs[besharp_rcsl]=$arguments'
besharp_oop_type_AppEntrypoint_method_locals["makeArguments"]='local arguments'
besharp_oop_type_AppEntrypoint_method_is_using_iterators["makeArguments"]=false
besharp_oop_type_AppEntrypoint_method_is_calling_parent["makeArguments"]=false
besharp_oop_type_AppEntrypoint_method_is_calling_this["makeArguments"]=false
besharp_oop_type_is["Arguments"]='class'
besharp_oop_types["Arguments"]="Arguments"
declare -Ag besharp_oop_type_Arguments_interfaces
besharp_oop_classes["Arguments"]="Arguments"
besharp_oop_type_parent["Arguments"]="Object"
declare -Ag besharp_oop_type_Arguments_fields
declare -Ag besharp_oop_type_Arguments_injectable_fields
declare -Ag besharp_oop_type_Arguments_field_type
declare -Ag besharp_oop_type_Arguments_field_default
declare -Ag besharp_oop_type_Arguments_methods
declare -Ag besharp_oop_type_Arguments_method_body
declare -Ag besharp_oop_type_Arguments_method_locals
declare -Ag besharp_oop_type_Arguments_method_is_returning
declare -Ag besharp_oop_type_Arguments_method_is_abstract
declare -Ag besharp_oop_type_Arguments_method_is_using_iterators
declare -Ag besharp_oop_type_Arguments_method_is_calling_parent
declare -Ag besharp_oop_type_Arguments_method_is_calling_this
besharp_oop_type_Arguments_fields['arguments']='arguments'
besharp_oop_type_Arguments_field_type['arguments']="Map"
besharp_oop_type_Arguments_field_default['arguments']=""
besharp_oop_type_Arguments_fields['inputArgs']='inputArgs'
besharp_oop_type_Arguments_field_type['inputArgs']="Vector"
besharp_oop_type_Arguments_field_default['inputArgs']=""
besharp_oop_type_Arguments_fields['inputValues']='inputValues'
besharp_oop_type_Arguments_field_type['inputValues']="Map"
besharp_oop_type_Arguments_field_default['inputValues']=""
besharp_oop_type_Arguments_fields['argsInOrder']='argsInOrder'
besharp_oop_type_Arguments_field_type['argsInOrder']="Vector"
besharp_oop_type_Arguments_field_default['argsInOrder']=""
besharp_oop_type_Arguments_methods['Arguments']='Arguments'
besharp_oop_type_Arguments_method_is_returning["Arguments"]=false
besharp_oop_type_Arguments_method_body["Arguments"]='    __be___this_inputArgs @vectors.make "${@}";
    __be___this_inputValues @maps.make;
    __be___this_arguments @maps.make;
    __be___this_argsInOrder @vectors.make'
besharp_oop_type_Arguments_method_locals["Arguments"]=''
besharp_oop_type_Arguments_method_is_using_iterators["Arguments"]=false
besharp_oop_type_Arguments_method_is_calling_parent["Arguments"]=false
besharp_oop_type_Arguments_method_is_calling_this["Arguments"]=true
besharp_oop_type_Arguments_methods['add']='add'
besharp_oop_type_Arguments_method_is_returning["add"]=false
besharp_oop_type_Arguments_method_body["add"]='    $this.createArgument false "${@}"'
besharp_oop_type_Arguments_method_locals["add"]=''
besharp_oop_type_Arguments_method_is_using_iterators["add"]=false
besharp_oop_type_Arguments_method_is_calling_parent["add"]=false
besharp_oop_type_Arguments_method_is_calling_this["add"]=true
besharp_oop_type_Arguments_methods['addFlag']='addFlag'
besharp_oop_type_Arguments_method_is_returning["addFlag"]=false
besharp_oop_type_Arguments_method_body["addFlag"]='    $this.createArgument true "${@}"'
besharp_oop_type_Arguments_method_locals["addFlag"]=''
besharp_oop_type_Arguments_method_is_using_iterators["addFlag"]=false
besharp_oop_type_Arguments_method_is_calling_parent["addFlag"]=false
besharp_oop_type_Arguments_method_is_calling_this["addFlag"]=true
besharp_oop_type_Arguments_methods['createArgument']='createArgument'
besharp_oop_type_Arguments_method_is_returning["createArgument"]=false
besharp_oop_type_Arguments_method_body["createArgument"]='    local arg map vector ;
    __be__arg @new Argument;
    $arg.isFlag = "${1}";
    $arg.key = "${2}";
    $arg.longName = "${3}";
    $arg.shortName = "${4}";
    $arg.description = "${5}";
    $arg.defaultValue = "${6}";
    __be__map $this.arguments;
    $map.set "${2}" $arg;
    __be__vector $this.argsInOrder;
    $vector.add $arg'
besharp_oop_type_Arguments_method_locals["createArgument"]='local arg
local map
local vector'
besharp_oop_type_Arguments_method_is_using_iterators["createArgument"]=false
besharp_oop_type_Arguments_method_is_calling_parent["createArgument"]=false
besharp_oop_type_Arguments_method_is_calling_this["createArgument"]=true
besharp_oop_type_Arguments_methods['findArgument']='findArgument'
besharp_oop_type_Arguments_method_is_returning["findArgument"]=true
besharp_oop_type_Arguments_method_body["findArgument"]='    local arguments key ;
    local name="${1}";
    besharp_rcrvs[besharp_rcsl]="";
    while @iterate @of $this.arguments @in argument; do
        if @returned @of $argument.longName == "${name}" || @returned @of $argument.shortName == "${name}"; then
            __be__key $argument.key;
            __be__arguments $this.arguments;
            besharp.returningOf $arguments.get "${key}";
            return;
        fi;
    done;
    besharp.error "Invalid argument: ${name}!"'
besharp_oop_type_Arguments_method_locals["findArgument"]='local argument
local arguments
local key'
besharp_oop_type_Arguments_method_is_using_iterators["findArgument"]=true
besharp_oop_type_Arguments_method_is_calling_parent["findArgument"]=false
besharp_oop_type_Arguments_method_is_calling_this["findArgument"]=true
besharp_oop_type_Arguments_methods['get']='get'
besharp_oop_type_Arguments_method_is_returning["get"]=true
besharp_oop_type_Arguments_method_body["get"]='    local inputValues ;
    local key="${1}";
    __be__inputValues $this.inputValues;
    besharp.returningOf $inputValues.get "${key}"'
besharp_oop_type_Arguments_method_locals["get"]='local inputValues'
besharp_oop_type_Arguments_method_is_using_iterators["get"]=false
besharp_oop_type_Arguments_method_is_calling_parent["get"]=false
besharp_oop_type_Arguments_method_is_calling_this["get"]=true
besharp_oop_type_Arguments_methods['initDefaultValues']='initDefaultValues'
besharp_oop_type_Arguments_method_is_returning["initDefaultValues"]=false
besharp_oop_type_Arguments_method_body["initDefaultValues"]='    local defaultValue inputValues key ;
    __be__inputValues $this.inputValues;
    while @iterate @of $this.arguments @in argument; do
        __be__key $argument.key;
        __be__defaultValue $argument.defaultValue;
        $inputValues.set "${key}" "${defaultValue}";
    done'
besharp_oop_type_Arguments_method_locals["initDefaultValues"]='local argument
local defaultValue
local inputValues
local key'
besharp_oop_type_Arguments_method_is_using_iterators["initDefaultValues"]=true
besharp_oop_type_Arguments_method_is_calling_parent["initDefaultValues"]=false
besharp_oop_type_Arguments_method_is_calling_this["initDefaultValues"]=true
besharp_oop_type_Arguments_methods['printUsage']='printUsage'
besharp_oop_type_Arguments_method_is_returning["printUsage"]=false
besharp_oop_type_Arguments_method_body["printUsage"]='    local arguments ;
    local margin=19;
    __be__arguments $this.arguments;
    while @iterate @of $this.argsInOrder @in arg; do
        local paddingText='"'"''"'"';
        local totalString="$( @ $arg.longName )$( @ $arg.shortName )";
        local paddingSize=$(( margin - ${#totalString} ));
        while (( --paddingSize >= 0 )); do
            paddingText+='"'"' '"'"';
        done;
        echo -n "  ";
        if @true $arg.isFlag; then
            echo -n "$(@ $arg.shortName), $(@ $arg.longName)             ${paddingText} - ";
            @echo $arg.description;
        else
            echo -n "$(@ $arg.shortName) value, $(@ $arg.longName) value ${paddingText} - ";
            echo "$(@ $arg.description)$(@fmt bold)$(@ $arg.defaultValue)$(@fmt reset)";
        fi;
    done'
besharp_oop_type_Arguments_method_locals["printUsage"]='local arg
local arguments'
besharp_oop_type_Arguments_method_is_using_iterators["printUsage"]=true
besharp_oop_type_Arguments_method_is_calling_parent["printUsage"]=false
besharp_oop_type_Arguments_method_is_calling_this["printUsage"]=true
besharp_oop_type_Arguments_methods['process']='process'
besharp_oop_type_Arguments_method_is_returning["process"]=false
besharp_oop_type_Arguments_method_body["process"]='    local arg inputValues key ;
    $this.initDefaultValues;
    __be__inputValues $this.inputValues;
    local nextItemIsValue=false;
    while @iterate @of $this.inputArgs @in arg; do
        if $nextItemIsValue; then
            $inputValues.set "${key}" "${arg}";
            nextItemIsValue=false;
            continue;
        fi;
        __be__arg $this.findArgument "${arg}";
        __be__key $arg.key;
        if @true $arg.isFlag; then
            $inputValues.set "${key}" true;
        else
            nextItemIsValue=true;
        fi;
    done;
    if $nextItemIsValue; then
        local argText;
        argText="$( @ $arg.longName ) ($( @ $arg.shortName ))";
        besharp.error "The value is missing for ${argText} argument!";
    fi'
besharp_oop_type_Arguments_method_locals["process"]='local arg
local inputValues
local key'
besharp_oop_type_Arguments_method_is_using_iterators["process"]=true
besharp_oop_type_Arguments_method_is_calling_parent["process"]=false
besharp_oop_type_Arguments_method_is_calling_this["process"]=true
besharp_oop_type_is["Argument"]='class'
besharp_oop_types["Argument"]="Argument"
declare -Ag besharp_oop_type_Argument_interfaces
besharp_oop_classes["Argument"]="Argument"
besharp_oop_type_parent["Argument"]="Object"
declare -Ag besharp_oop_type_Argument_fields
declare -Ag besharp_oop_type_Argument_injectable_fields
declare -Ag besharp_oop_type_Argument_field_type
declare -Ag besharp_oop_type_Argument_field_default
declare -Ag besharp_oop_type_Argument_methods
declare -Ag besharp_oop_type_Argument_method_body
declare -Ag besharp_oop_type_Argument_method_locals
declare -Ag besharp_oop_type_Argument_method_is_returning
declare -Ag besharp_oop_type_Argument_method_is_abstract
declare -Ag besharp_oop_type_Argument_method_is_using_iterators
declare -Ag besharp_oop_type_Argument_method_is_calling_parent
declare -Ag besharp_oop_type_Argument_method_is_calling_this
besharp_oop_type_Argument_fields['key']='key'
besharp_oop_type_Argument_field_default['key']=""
besharp_oop_type_Argument_fields['longName']='longName'
besharp_oop_type_Argument_field_default['longName']=""
besharp_oop_type_Argument_fields['shortName']='shortName'
besharp_oop_type_Argument_field_default['shortName']=""
besharp_oop_type_Argument_fields['description']='description'
besharp_oop_type_Argument_field_default['description']=""
besharp_oop_type_Argument_fields['defaultValue']='defaultValue'
besharp_oop_type_Argument_field_default['defaultValue']=""
besharp_oop_type_Argument_fields['isFlag']='isFlag'
besharp_oop_type_Argument_field_default['isFlag']=""
besharp_oop_type_Argument_methods['Argument']='Argument'
besharp_oop_type_Argument_method_is_returning["Argument"]=false
besharp_oop_type_Argument_method_body["Argument"]='    @parent "${@}"'
besharp_oop_type_Argument_method_locals["Argument"]=''
besharp_oop_type_Argument_method_is_using_iterators["Argument"]=false
besharp_oop_type_Argument_method_is_calling_parent["Argument"]=true
besharp_oop_type_Argument_method_is_calling_this["Argument"]=false

fi
if ${beshfile_section__code:-false}; then :;
function __be__args() {
  "${@}"
  args="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__greetingText() {
  "${@}"
  greetingText="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__arguments() {
  "${@}"
  arguments="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be___this_argsInOrder() {
  "${@}"
  eval $this"_argsInOrder=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
}
function __be___this_arguments() {
  "${@}"
  eval $this"_arguments=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
}
function __be___this_inputArgs() {
  "${@}"
  eval $this"_inputArgs=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
}
function __be___this_inputValues() {
  "${@}"
  eval $this"_inputValues=\"\${besharp_rcrvs[besharp_rcsl + 1]}\""
}
function __be__arg() {
  "${@}"
  arg="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__map() {
  "${@}"
  map="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__vector() {
  "${@}"
  vector="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__arguments() {
  "${@}"
  arguments="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__key() {
  "${@}"
  key="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__inputValues() {
  "${@}"
  inputValues="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__defaultValue() {
  "${@}"
  defaultValue="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__inputValues() {
  "${@}"
  inputValues="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__key() {
  "${@}"
  key="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__arguments() {
  "${@}"
  arguments="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__arg() {
  "${@}"
  arg="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__inputValues() {
  "${@}"
  inputValues="${besharp_rcrvs[besharp_rcsl + 1]}"
}
function __be__key() {
  "${@}"
  key="${besharp_rcrvs[besharp_rcsl + 1]}"
}
AppEntrypoint ()
{
    @parent "${@}"
}
AppEntrypoint.greetingText ()
{
    local args="${1}";
    besharp_rcrvs[besharp_rcsl]="$( @ $args.get greeting ) $( @ $args.get subject )$( @ $args.get suffix )"
}
AppEntrypoint.main ()
{
    local args greetingText;
    __be__args $this.makeArguments "${@}";
    if @true $args.get isAskingForHelp; then
        echo 'An example Hello-World App for the BeSharp Framework.' 1>&2;
        echo '' 1>&2;
        echo 'Usage:' 1>&2;
        $args.printUsage 1>&2;
        return 0;
    fi;
    __be__greetingText $this.greetingText $args;
    if @true $args.get isLoud; then
        echo "$( @fmt bold )${greetingText}$( @fmt reset )";
    else
        echo "${greetingText}";
    fi
}
AppEntrypoint.makeArguments ()
{
    local arguments;
    __be__arguments @new Arguments "${@}";
    $arguments.add greeting '--greeting' '-g' 'The way you want to greet. Default greeting is: ' 'Hello';
    $arguments.add subject '--subject' '-s' 'The subject you want to greet. Default subject is: ' 'World';
    $arguments.add suffix '--suffix' '-u' 'The string being placed at the end. Default is: ' '.';
    $arguments.addFlag isLoud '--loud' '-l' 'Makes bold output.' 'false';
    $arguments.addFlag isAskingForHelp '--help' '-h' 'Show help.' 'false';
    $arguments.process;
    besharp_rcrvs[besharp_rcsl]=$arguments
}
Argument ()
{
    @parent "${@}"
}
Arguments ()
{
    __be___this_inputArgs @vectors.make "${@}";
    __be___this_inputValues @maps.make;
    __be___this_arguments @maps.make;
    __be___this_argsInOrder @vectors.make
}
Arguments.add ()
{
    $this.createArgument false "${@}"
}
Arguments.addFlag ()
{
    $this.createArgument true "${@}"
}
Arguments.createArgument ()
{
    local arg map vector;
    __be__arg @new Argument;
    $arg.isFlag = "${1}";
    $arg.key = "${2}";
    $arg.longName = "${3}";
    $arg.shortName = "${4}";
    $arg.description = "${5}";
    $arg.defaultValue = "${6}";
    __be__map $this.arguments;
    $map.set "${2}" $arg;
    __be__vector $this.argsInOrder;
    $vector.add $arg
}
Arguments.findArgument ()
{
    local arguments key;
    local name="${1}";
    besharp_rcrvs[besharp_rcsl]="";
    while @iterate @of $this.arguments @in argument; do
        if @returned @of $argument.longName == "${name}" || @returned @of $argument.shortName == "${name}"; then
            __be__key $argument.key;
            __be__arguments $this.arguments;
            besharp.returningOf $arguments.get "${key}";
            return;
        fi;
    done;
    besharp.error "Invalid argument: ${name}!"
}
Arguments.get ()
{
    local inputValues;
    local key="${1}";
    __be__inputValues $this.inputValues;
    besharp.returningOf $inputValues.get "${key}"
}
Arguments.initDefaultValues ()
{
    local defaultValue inputValues key;
    __be__inputValues $this.inputValues;
    while @iterate @of $this.arguments @in argument; do
        __be__key $argument.key;
        __be__defaultValue $argument.defaultValue;
        $inputValues.set "${key}" "${defaultValue}";
    done
}
Arguments.printUsage ()
{
    local arguments;
    local margin=19;
    __be__arguments $this.arguments;
    while @iterate @of $this.argsInOrder @in arg; do
        local paddingText='';
        local totalString="$( @ $arg.longName )$( @ $arg.shortName )";
        local paddingSize=$(( margin - ${#totalString} ));
        while (( --paddingSize >= 0 )); do
            paddingText+=' ';
        done;
        echo -n "  ";
        if @true $arg.isFlag; then
            echo -n "$(@ $arg.shortName), $(@ $arg.longName)             ${paddingText} - ";
            @echo $arg.description;
        else
            echo -n "$(@ $arg.shortName) value, $(@ $arg.longName) value ${paddingText} - ";
            echo "$(@ $arg.description)$(@fmt bold)$(@ $arg.defaultValue)$(@fmt reset)";
        fi;
    done
}
Arguments.process ()
{
    local arg inputValues key;
    $this.initDefaultValues;
    __be__inputValues $this.inputValues;
    local nextItemIsValue=false;
    while @iterate @of $this.inputArgs @in arg; do
        if $nextItemIsValue; then
            $inputValues.set "${key}" "${arg}";
            nextItemIsValue=false;
            continue;
        fi;
        __be__arg $this.findArgument "${arg}";
        __be__key $arg.key;
        if @true $arg.isFlag; then
            $inputValues.set "${key}" true;
        else
            nextItemIsValue=true;
        fi;
    done;
    if $nextItemIsValue; then
        local argText;
        argText="$( @ $arg.longName ) ($( @ $arg.shortName ))";
        besharp.error "The value is missing for ${argText} argument!";
    fi
}

fi
if ${beshfile_section__code:-false}; then :;

@bind Entrypoint @with AppEntrypoint

fi
if ${beshfile_section__launcher:-true}; then :;
    besharp.runtime.entrypoint_embedded_static "${@}"

fi
