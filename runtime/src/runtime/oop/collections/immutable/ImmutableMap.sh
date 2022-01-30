#!/usr/bin/env bash

@internal @class ImmutableMap @extends ArrayMap

  function ImmutableMap()
  {
      @parent

      if (( $# == 0 )); then
          return
      fi

      if (( ( $# % 2 ) != 0 )); then
          besharp.runtime.error "ImmutableMap constructor has got an odd number of elements. Expected pairs!"
          return
      fi

      local key
      local item
      local isEven=true
      for item in "${@}"; do
          if $isEven; then
              isEven=false
              key="${item}"
          else
              isEven=true
              eval "${this}[\"\${key}\"]=\"\${item}\""
          fi
      done
  }

  function ImmutableMap.set()
  {
      besharp.runtime.error "You cannot set!"
  }

  function ImmutableMap.setPlainPairs()
  {
      besharp.runtime.error "You cannot setPlainPairs!"
  }

  function ImmutableMap.swapKeys()
  {
      besharp.runtime.error "You cannot swapKeys!"
  }

  function ImmutableMap.removeKeys()
  {
      :
  }

  function ImmutableMap.removeKey()
  {
      :
  }

  function ImmutableMap.findAllKeys()
  {
      @returning $this
  }

  function ImmutableMap.hasSomeKeys()
  {
      @returning false
  }

  function ImmutableMap.hasAllKeys()
  {
      @returning false
  }

  function ImmutableMap.hasKey()
  {
      @returning false
  }

@classdone