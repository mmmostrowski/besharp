#!/usr/bin/env bash

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

