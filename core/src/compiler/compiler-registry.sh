#!/usr/bin/env bash

export besharp_compiler_registry_last_key=

function besharp.compiler.initRegistry() {
    declare -Ag besharp_compiler_registry
    declare -Ag besharp_compiler_registry_key_by_abs_path
    declare -Ag besharp_compiler_registry_relative_path
    declare -Ag besharp_compiler_registry_source
    declare -Ag besharp_compiler_registry_source_hash
    declare -Ag besharp_compiler_registry_source_absolute_path
    declare -Ag besharp_compiler_registry_type
    declare -Ag besharp_compiler_registry_target
    declare -Ag besharp_compiler_registry_target_hash
    declare -Ag besharp_compiler_registry_target_absolute_path
    declare -Ag besharp_compiler_registry_target_runtime_version
    declare -Ag besharp_compiler_registry_target_dependencies
    declare -ag besharp_compiler_beshfiles_to_merge
    export besharp_compiler_registry_current_src_weight=0
}

function besharp.compiler.scanSource() {
    besharp_compiler_registry_current_src_weight=0

    local source
    for source in "${besharp_compiler_args_source[@]}"; do
        (( ++besharp_compiler_registry_current_src_weight ))
        declare -ag "besharp_compiler_src_by_weight_${besharp_compiler_registry_current_src_weight}"

        if [[ -f "${source}" ]] && [[ "${source%.be.sh}" != "${source}" ]]; then
            besharp_compiler_beshfiles_to_merge+=( "${source}" )
            eval "besharp_compiler_src_by_weight_${besharp_compiler_registry_current_src_weight}+=( \"\${source}\" )"
        elif [[ -d "${source}" ]]; then
            besharp.compiler.registerSourceDir "${source}"
        else
            besharp.error "Unknown source: ${source}!"
        fi
    done

    besharp.compiler.calculateSourceHashes
}

function besharp.compiler.prepareTarget() {
    mkdir -p "${besharp_compiler_args_distribution_dir}"
}

function besharp.compiler.scanTarget() {
    besharp.compiler.scanTargetRecursion "${besharp_compiler_args_distribution_dir}"
    besharp.compiler.readTargetMetadata
}

function besharp.compiler.scanTargetRecursion() {
    local dir="${1}"

    local file
    local fileName
    for fileName in $( ls "${dir}" ); do
        file="${dir%/}/${fileName}"
        if [[ -f "${file}" ]]; then
            besharp.compiler.registerTargetFile "${besharp_compiler_args_distribution_dir}" "${file}" "${fileName}"
        elif [[ -d "${file}" ]]; then
            besharp.compiler.scanTargetRecursion "${file}"
        fi
    done
}

function besharp.compiler.registerSourceDir() {
    local source="${1}"

    besharp.compiler.registerSourceDirRecursion "${source}" "${source}"
}

function besharp.compiler.registerSourceDirRecursion() {
    local source="${1}"
    local dir="${2}"

    local file
    local fileName
    for fileName in $( ls "${dir}" ); do
        file="${dir%/}/${fileName}"
        if [[ -f "${file}" ]]; then
            besharp.compiler.registerSourceFile "${source}" "${file}" "${fileName}"
        elif [[ -d "${file}" ]]; then
            besharp.compiler.registerSourceDirRecursion "${source}" "${file}"
        fi
    done
}

function besharp.compiler.registerSourceFile() {
    local source="${1}"
    local file="${2}"
    local fileName="${3}"

    local key
    besharp.compiler.registryKeyOf "${source}" "${file}" "${fileName}"
    key="${besharp_compiler_registry_last_key}"
    if [[ -z "${key}" ]]; then
        return
    fi

    local beshfile
    beshfile="${besharp_compiler_args_distribution_dir%/}/${file#${source}}"

    besharp_compiler_registry["${key}"]="${key}"
    besharp_compiler_registry_source["${key}"]="${source}"
    besharp_compiler_registry_source_absolute_path["${key}"]="${file}"
    besharp_compiler_registry_relative_path["${key}"]="${file#${source}}"
    besharp_compiler_registry_target["${key}"]=""
    besharp_compiler_registry_target_absolute_path["${key}"]="${beshfile%.sh}.be.sh"

    local absPath="${besharp_compiler_registry_source_absolute_path["${key}"]}"
    besharp_compiler_registry_key_by_abs_path["${absPath}"]="${key}"
    local absPath="${besharp_compiler_registry_target_absolute_path["${key}"]}"
    besharp_compiler_registry_key_by_abs_path["${absPath}"]="${key}"

    eval "besharp_compiler_src_by_weight_${besharp_compiler_registry_current_src_weight}+=( \"\${absPath}\" )"

    if besharp.compiler.isFileTypeCompiled "${file}" "${fileName}"; then
        besharp.error "${file} in ${source}? I did not expect compiled files in source folder!"
    elif besharp.compiler.isFileTypeClass "${file}" "${fileName}"; then
        besharp_compiler_registry_type["${key}"]="class"
    elif besharp.compiler.isFileTypeScript "${file}" "${fileName}"; then
        besharp_compiler_registry_type["${key}"]="script"
    else
        besharp.error "Ups. Something went wrong"
    fi
}

function besharp.compiler.registerTargetFile() {
    local target="${1}"
    local file="${2}"
    local fileName="${3}"

    if [[ -z "${file}" ]] || [[ "${file}" == '.' ]] || [[ "${file}" == '..' ]]; then
        return
    fi

    local key
    besharp.compiler.registryKeyOf "${target}" "${file}" "${fileName}"
    key="${besharp_compiler_registry_last_key}"
    if [[ -z "${key}" ]]; then
        return
    fi

    if [[ "${besharp_compiler_registry[${key}]+isset}" == 'isset' ]]; then
        besharp_compiler_registry_target["${key}"]="${target}"
    else
        rm -rf "${file}"
        besharp.compiler.logTargetRemoval "${file}"
    fi
}

function besharp.compiler.readTargetMetadata() {
    for key in "${besharp_compiler_registry[@]}"; do
        besharp_compiler_registry_target_hash["${key}"]=
        besharp_compiler_registry_target_runtime_version["${key}"]=
        besharp_compiler_registry_target_dependencies["${key}"]=
    done

    local lineNum=0
    local currentPath=
    local currentKey=
    while read line; do
        if [[ -z "${line}" ]]; then
            continue
        fi

        case $(( lineNum++ % 5 )) in
          "0")
              currentPath="${line%:# <<< BeShMeTa}"
              currentKey="${besharp_compiler_registry_key_by_abs_path[${currentPath}]:-}"
          ;;
          "1")
              local items=( ${line#${currentPath}-} )

              besharp_compiler_registry_target_hash["${currentKey}"]="${items[1]}"
              besharp_compiler_registry_target_runtime_version["${currentKey}"]="${items[2]}"
          ;;
          "2")
              besharp_compiler_registry_target_dependencies["${currentKey}"]="${line#${currentPath}-#}"
          ;;
          "3")
              if [[ "${line}" != "${currentPath}-# >>> BeShMeTa" ]]; then
                  besharp.compiler.logBesharpCorruptedFile "${currentPath}"
              fi
              currentPath=
              currentKey=
          ;;
        esac
    done<<<"$( besharp.grepList -A 3 -E "^# <<< BeShMeTa$" "${besharp_compiler_registry_target_absolute_path[@]}" 2> /dev/null )"
}

function besharp.compiler.calculateSourceHashes() {
    local key
    local allPathsInOrder=""
    allPathsInOrder="$(
        for key in "${besharp_compiler_registry[@]}"; do
            echo "${besharp_compiler_registry_source_absolute_path[${key}]}"
        done
    )"

    if [[ -z "${allPathsInOrder}" ]]; then
        return
    fi

    local registryKeys=( ${besharp_compiler_registry[@]} )
    local line
    local idx=0
    local oddEven=true
    for line in $( md5sum ${allPathsInOrder} ); do
        if $oddEven; then
            oddEven=false
            key="${registryKeys[${idx}]}"

            besharp_compiler_registry_source_hash["${key}"]="${line}"
            (( ++idx ))
        else
            oddEven=true
        fi
    done
}

function besharp.compiler.findChangedSourceItems() {
    if $besharp_compiler_args_skip_unchanged; then
        local key
        for key in "${besharp_compiler_registry[@]}"; do
            if besharp.compiler.isSourceAndTargetSame "${key}"; then
                besharp.compiler.logNoFileChangesNothingToCompile "${key}"
                continue
            fi

            besharp.compiler.logChangesDetectedCompilationNeeded "${key}"
            echo "${key}"
        done
    else
        local key
        for key in "${besharp_compiler_registry[@]}"; do
            besharp.compiler.logFoundForCompilation "${key}"
            echo "${key}"
        done
    fi
}

function besharp.compiler.isSourceAndTargetSame() {
    local key="${1}"

    [[ "${besharp_compiler_registry_source_hash[${key}]}" == "${besharp_compiler_registry_target_hash[${key}]}" ]]
}

function besharp.compiler.registryKeyOf() {
    local baseDir="${1}"
    local filePath="${2}"
    local fileName="${3}"

    if [[ "${filePath}" =~ ^.+\.include\.sh$ ]]; then
        return
    elif besharp.compiler.isFileTypeClass "${filePath}" "${fileName}"; then
        filePath="${filePath#${baseDir}}"
    elif besharp.compiler.isFileTypeScript "${filePath}" "${fileName}"; then
        filePath="${filePath#${baseDir}}"
    else
        besharp.error "Unknown '${filePath}' file in the source folder! Expected only files ending with *.sh. Consider using assets/ folder."
        return
    fi

    filePath="${filePath%.sh}"
    filePath="${filePath%.be}"

    besharp_compiler_registry_last_key="${filePath}"
}

function besharp.compiler.isFileTypeClass() {
    local filePath="${1}"
    local fileName="${2:-}"

    if [[ -z "${fileName}" ]]; then
        fileName="$( basename "${filePath}" )"
    fi

    [[ "${fileName}" =~ ^[A-Z].*(\.be)?\.sh$ ]]
}

function besharp.compiler.isFileTypeCompiled() {
    local filePath="${1}"
    local fileName="${2:-}"

    if [[ -z "${fileName}" ]]; then
        fileName="$( basename "${filePath}" )"
    fi

    [[ "${fileName}" =~ ^[a-zA-Z].*\.be\.sh$ ]]
}

function besharp.compiler.isFileTypeScript() {
    local filePath="${1}"
    local fileName="${2:-}"

    if [[ -z "${fileName}" ]]; then
        fileName="$( basename "${filePath}" )"
    fi

    [[ "${fileName}" =~ ^[a-z].*(\.be)?\.sh$ ]]
}

