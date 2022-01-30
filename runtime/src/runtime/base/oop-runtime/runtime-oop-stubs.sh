#!/usr/bin/env bash

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

