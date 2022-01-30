#!/usr/bin/env bash

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

