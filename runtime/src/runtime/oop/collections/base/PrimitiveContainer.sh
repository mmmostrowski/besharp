#!/usr/bin/env bash

@abstract @internal @class PrimitiveContainer @extends PrimitiveObject

  @var owningItems = false

  function PrimitiveContainer()
  {
      @parent
  }

  function PrimitiveContainer.__cloneFrom()
  {
      local source="${1}"
      local mode="${2}"

      # declare variable on behalf of @parent due to performance
      unset "${this}[@]"
      $this.declarePrimitiveVariable "${@}"

      if [[ "${mode}" == "" ]] || [[ "${mode}" == "shallow" ]]; then
          local temp
          declare -n temp="${source}"
          local idx
          for idx in "${!temp[@]}"; do
              eval "${this}[\"\$idx\"]=\"\${temp[\"\$idx\"]}\""
          done
      elif [[ "${mode}" == "deep" ]]; then
          local temp
          declare -n temp="${source}"
          local idx
          for idx in "${!temp[@]}"; do
              local value
              eval "value=\"\${temp[\"\$idx\"]}\""

              if besharp.rtti.isObjectExist "${value}"; then
                  @let value = @clone $value
              fi

              eval "${this}[\"\$idx\"]=\"\${value}\""
          done
      elif [[ "${mode}" == "@in-place" ]]; then
          local temp
          declare -n temp="${this}"
          local idx
          for idx in "${!temp[@]}"; do
              local value
              eval "value=\"\${temp[\"\$idx\"]}\""
              if besharp.rtti.isObjectExist "${value}"; then
                  @let value = @clone $value
                  eval "${this}[\"\$idx\"]=\"\${value}\""
              fi
          done
      else
          besharp.runtime.error "Unknown @clone mode: '$mode'. Expected one of: 'shallow', 'deep', 'in-place'."
      fi
  }

  function PrimitiveContainer.__destroy()
  {
      $this.destroyOwningItems
      @parent
  }

  function PrimitiveContainer.ownsItsItems()
  {
      $this.owningItems = "${1:-true}"
  }

  function PrimitiveContainer.isOwningItems()
  {
      @returning @of $this.owningItems
  }

  function PrimitiveContainer.destroyOwningItems()
  {
      if @true $this.isOwningItems; then
          local item
          while @iterate $this @in item; do
              if @exists "${item}"; then
                  @unset "${item}"
              fi
          done
      fi
  }

  function PrimitiveContainer.replace()
  {
      local fromItem="${1}"
      local toItem="${2}"

      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          return
      fi

      local temp
      declare -n temp="${this}"
      local idx
      for idx in "${!temp[@]}"; do
          if @same "${temp[$idx]}" "${fromItem}"; then
              eval "${this}[$idx]=\${toItem}"
          fi
      done
  }

  function PrimitiveContainer.replaceMany()
  {
      local replaceMap="${1}"

      local from
      while @iterate @of $replaceMap.keys @in from; do
          @let to = $replaceMap.get "${from}"

          $this.replace "${from}" "${to}"
      done
  }

  function PrimitiveContainer.get()
  {
      local key="${1}"

      local isset
      eval "isset=\${${this}[\"${key}\"]+isset}"
      if [[ "${isset}" != 'isset' ]]; then
          besharp.runtime.error "Missing '${key}' key in ${this} container! Please call ${this}.has() to prevent!"
      fi

      local item
      eval "item=\"\${${this}[\"${key}\"]}\""
      @returning "${item}"
  }

  function PrimitiveContainer.keys()
  {
      local myself
      declare -n myself="${this}"

      @let indices = @new ArrayVector
      $indices.setPlain "${!myself[@]}"

      @returning $indices
  }

  function PrimitiveContainer.has()
  {
      local item="${1}"

      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          @returning false
          return
      fi

      local x
      for x in "${!var}"; do
          if @same "${x}" "${item}"; then
              @returning true
              return
          fi
      done

      @returning false
  }

  function PrimitiveContainer.hasAll()
  {
      if @true $this.isEmpty; then
          @returning false
          return
      fi

      local item
      while @iterate "${@}" @in item; do
          if @false $this.has "${item}"; then
              @returning false
              return
          fi
      done
      @returning true
  }

  function PrimitiveContainer.hasSome()
  {
      local item
      while @iterate "${@}" @in item; do
          if @true $this.has "${item}"; then
              @returning true
              return
          fi
      done
      @returning false
  }

  function PrimitiveContainer.frequency()
  {
      local item="${1}"

      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          @returning 0
          return
      fi

      local frequency=0

      local temp
      declare -n temp="${this}"
      local idx
      for idx in "${!temp[@]}"; do
          if @same "${temp[$idx]}" "${item}"; then
              (( ++ frequency ))
          fi
      done

      @returning ${frequency}
  }

  function PrimitiveContainer.removeAll()
  {
      $this.destroyPrimitiveVariable
      $this.declarePrimitiveVariable
  }

  function PrimitiveContainer.removeMany()
  {
      local item
      while @iterate "${@}" @in item; do
          $this.remove "${item}"
      done
  }

  function PrimitiveContainer.isEmpty()
  {
      local isset
      eval "isset=\${${this}[@]+isset}"
      if [[ "${isset}" == 'isset' ]]; then
          @returning false
      else
          @returning true
      fi
  }

  function PrimitiveContainer.size()
  {
      local count=0

      local isset
      eval "isset=\${${this}[@]+isset}"
      if [[ "${isset}" == 'isset' ]]; then
          eval "count=\${#${this}[@]}"
      fi

      @returning "${count}"
  }

  function PrimitiveContainer.fill()
  {
      local item="${1}"

      local temp
      declare -n temp="${this}"
      local idx
      for idx in "${!temp[@]}"; do
          eval "${this}[${idx}]=\"\${item}\""
      done
  }

  function PrimitiveContainer.swapElements()
  {
      local index1="${1}"
      local index2="${2}"

      if [[ "${index1}" == "${index2}" ]] ; then
          return
      fi

      local isset1
      eval "isset1=\"\${${this}[${index1}]+isset}\""
      if [[ "${isset1}" != 'isset' ]]; then
          besharp.runtime.error "Missing '${index1}' key in ${this} container!"
      fi

      local isset2
      eval "isset2=\"\${${this}[${index1}]+isset}\""
      if [[ "${isset2}" != 'isset' ]]; then
          besharp.runtime.error "Missing '${index2}' key in ${this} container!"
      fi

      local tmpValue=""

      eval "tmpValue=\"\${${this}[\${index1}]}\""
      eval "${this}[\${index1}]=\"\${${this}[\${index2}]}\""
      eval "${this}[\${index2}]=\"\${tmpValue}\""
  }

  function PrimitiveContainer.shuffle()
  {
      @let size = $this.size

      if (( size < 2 )); then
          return
      fi


      local indices=()
      local temp
      declare -n temp="${this}"
      local idx
      for idx in "${!temp[@]}"; do
          indices+=( "${idx}" )
      done

      local index1
      local index2
      local tmpValue
      for idx in "${!indices[@]}"; do
          index1="${indices[idx]}"
          index2="${indices[RANDOM % size]}"
          if [[ "${index1}" == "${index2}" ]]; then
              continue
          fi

          eval "tmpValue=\"\${${this}[\${index1}]}\""
          eval "${this}[\"\${index1}\"]=\"\${${this}[\${index2}]}\""
          eval "${this}[\"\${index2}\"]=\"\${tmpValue}\""
      done
  }

  function PrimitiveContainer.iterationNew()
  {
      ArrayIteration.iterationNew "${this}" "${@}"
  }

  function PrimitiveContainer.iterationValue()
  {
      ArrayIteration.iterationValue "${this}" "${@}"
  }

  function PrimitiveContainer.iterationNext()
  {
      ArrayIteration.iterationNext "${this}" "${@}"
  }

  function PrimitiveContainer.show()
  {
      local var="${this}[@]"

      if [[ "${!var+isset}" != "isset" ]]; then
          echo "<EMPTY>"
          return
      fi

      local temp
      declare -n temp="${this}"
      local idx
      for idx in "${!temp[@]}"; do
          local var="${this}[${idx}]"
          echo "| #${this} $(besharp.rtti.objectType "${this}") | ${idx} -> ${!var}"
      done
  }

@classdone