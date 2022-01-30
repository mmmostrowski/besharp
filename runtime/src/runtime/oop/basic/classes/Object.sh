#!/usr/bin/env bash

@abstract @internal @class Object

  function Object()
  {
      :
  }

  function Object.__destroy()
  {
      :
  }

  function Object.__objectId()
  {
      @returning "${this}"
  }

  function Object.__cloneFrom()
  {
      local source="${1}"
      local mode="${2}"

      if [[ "${mode}" == "" ]] || [[ "${mode}" == "shallow" ]]; then
          local field
          for field in $(besharp.rtti.allFieldsOf "$( besharp.rtti.objectType "${this}" )" ); do
              @let $this.$field = $source.$field
          done
      elif [[ "${mode}" == "deep" ]]; then
          local field
          for field in $(besharp.rtti.allFieldsOf "$( besharp.rtti.objectType "${this}" )" ); do
              @let value = $source.$field
              if besharp.rtti.isObjectExist "${value}"; then
                 @let $this.$field = @clone $value
              else
                 $this.$field = "${value}"
              fi
          done
      elif [[ "${mode}" == "@in-place" ]]; then
          local field
          for field in $(besharp.rtti.allFieldsOf "$( besharp.rtti.objectType "${this}" )" ); do
              @let value = $this.$field
              if besharp.rtti.isObjectExist "${value}"; then
                 @let $this.$field = @clone $value
              fi
          done
      else
          besharp.runtime.error "Unknown @clone mode: '$mode'. Expected one of: 'shallow', 'deep', '@in-place'."
      fi
  }

@classdone