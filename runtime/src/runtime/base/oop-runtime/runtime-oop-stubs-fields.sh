#!/usr/bin/env bash

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