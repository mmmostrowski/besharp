#!/usr/bin/env bash

function besharp.compiler.generateBeshfileMeta() {
    local item="${1}"

    local sourceHash
    sourceHash="${besharp_compiler_registry_source_hash[${item}]}"

    local itemKey
    itemKey="${item}"

    local dependencies=""

    besharp.compiler.generateBeshfileMetaHeader "${sourceHash}" "${itemKey}" "${dependencies}"
}

function besharp.compiler.generateBeshfileMetaHeader() {
    local sourceHash="${1}"
    local itemKey="${2}"
    local dependencies="${3}"

    echo "#!/usr/bin/env bash"
    echo "# <<< BeShMeTa"
    echo "# ${sourceHash} ${besharp_runtime_version} ${itemKey}"
    echo "# ${dependencies}"
    echo "# >>> BeShMeTa"
}

function besharp.compiler.generateComposedBeshfileMetaHeader() {
    besharp.compiler.generateBeshfileMetaHeader "unknown-source" "composed-beshfile" ""
}

function besharp.compiler.generateBeshfileSection() {
    local sectionCode="${1}"
    local enabledByDefault="${2:-false}"

    local content=""
    content="$( cat - )"
    if [[ -z "${content}" ]]; then
        return
    fi

    echo "if \${beshfile_section__${sectionCode}:-${enabledByDefault}}; then :; "
    echo "${content}"
    echo ''
    echo 'fi'
}

function besharp.compiler.disableBeshfileSectionPermanently() {
    local sectionCode="${1}"

    sed "s/if \${beshfile_section__${sectionCode}:-.*}; then/if false; then/g"
}

function besharp.compiler.mergeBeshfiles() {
    local entrypoint="${1}"
    shift 1

    local prepend=''
    local append=''
    if [[ -n "${entrypoint}" ]]; then
        prepend="$(
            echo 'beshfile_section__code=true;beshfile_section__oop_meta=true'
            besharp.runtime.generateInitializer | sed 's/$/ #besharp-initializer-marker/g'
        )"

        append="$(
            echo "    ${entrypoint} \"\${@}\" " \
                |  besharp.compiler.generateBeshfileSection "launcher" "true"
        )"
    fi

    besharp.compiler.generateComposedBeshfileMetaHeader

    echo "${prepend}"
    tail --quiet -n +6 "${@}" \
        | besharp.grepList -v -E 'beshfile_section__(code|oop_meta)=true' \
        | besharp.grepList -v -F '#besharp-initializer-marker' \
        | besharp.compiler.disableBeshfileSectionPermanently "launcher" \
        | besharp.grepList -v -E '^#.*/bin.+bash'
    echo "${append}"
}

