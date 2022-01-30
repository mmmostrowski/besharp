#!/usr/bin/env bash

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
