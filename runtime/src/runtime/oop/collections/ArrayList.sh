#!/usr/bin/env bash

@internal @class ArrayList @extends IndexedArrayCollection @implements List

  function ArrayList()
  {
      @parent
  }

  function ArrayList.set()
  {
      local index="${1}"
      local item="${2}"

      eval "${this}[${index}]=\"\${item}\""
      @returning "${item}"
  }

  function ArrayList.get()
  {
      local index="${1}"

      local item
      eval "item=\"\${${this}[${index}]}\""
      @returning "${item}"
  }

  function ArrayList.findIndex()
  {
      local item="${1}"
      local minIndex="${2:--1}"

      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          @returning false
          return
      fi

      local temp
      declare -n temp="${this}"
      local idx
      for idx in "${!temp[@]}"; do
          if (( idx < minIndex )); then
              continue
          fi

          if @same "${temp[$idx]}" "${item}"; then
              @returning "${idx}"
              return
          fi
      done

      @returning -1
  }

  function ArrayList.findLastIndex()
  {
      local item="${1}"
      local maxIndex="${2:--1}"

      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          @returning false
          return
      fi

      local temp
      declare -n temp="${this}"
      local idx
      local found=false
      for idx in "${!temp[@]}"; do
          if (( maxIndex >= 0 && idx > maxIndex )); then
              continue
          fi

          if @same "${temp[$idx]}" "${item}"; then
              found=true
              @returning "${idx}"
          fi
      done

      if ! $found; then
          @returning -1
      fi
  }

  function ArrayList.findIndices()
  {
      local item="${1}"

      @let resultCollection = @new ArrayVector
      @returning $resultCollection

      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          return
      fi

      local temp
      declare -n temp="${this}"
      local idx
      for idx in "${!temp[@]}"; do
          if @same "${temp[$idx]}" "${item}"; then
              $resultCollection.add "${idx}"
          fi
      done
  }

  function ArrayList.removeIndex()
  {
      local index="${1}"

      unset "${this}[${index}]"
  }

  function ArrayList.removeIndices()
  {
      local index
      while @iterate "${@}" @in index; do
          $this.removeIndex "${index}"
      done
  }

  function ArrayList.hasIndex()
  {
      local index="${1}"

      local isset
      eval "isset=\${${this}[${index}]+isset}"
      if [[ "${isset}" == 'isset' ]]; then
          @returning true
      else
          @returning false
      fi
  }

  function ArrayList.hasKey()
  {
      @returning @of $this.hasIndex "${@}"
  }

@classdone