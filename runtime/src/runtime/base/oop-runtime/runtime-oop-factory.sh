#!/usr/bin/env bash

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