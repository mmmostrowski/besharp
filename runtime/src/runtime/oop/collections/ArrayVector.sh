#!/usr/bin/env bash

@internal @class ArrayVector @extends IndexedArrayCollection @implements Vector

  function ArrayVector()
  {
      local size="${1:-0}"
      local emptyItem="${2:-}"

      @parent

      if (( size > 0 )); then
          $this.resize "${size}" "${emptyItem}"
      fi
  }

  function ArrayVector.__cloneFrom()
  {
      local source="${1}"
      local mode="${2}"

      if [[ "${mode}" == "shallow" ]]; then
          # declare variable on behalf of @parent due to performance
          $this.declarePrimitiveVariable "${@}"
          eval "${this}=( \"\${${source}[@]}\" )"
          return
      fi

      @parent "${source}" "${mode}"
  }

  function ArrayVector.call()
  {
      eval "@returning @of \"\${@}\" \"\${${this}[@]}\" "
  }

  function ArrayVector.iterationNew()
  {
      @let size = $this.size

      if (( size == 0 )); then
          @returning ""
          return
      fi

      @returning 0
  }

  function ArrayVector.iterationValue()
  {
      local index="${1}"

      local item
      eval "item=\"\${${this}[${index}]}\""
      @returning "${item}"
  }

  function ArrayVector.iterationNext()
  {
      local index="${1}"

      @let size = $this.size

      if (( ++index < size )); then
          @returning "${index}"
      else
          @returning ""
      fi
  }

  function ArrayVector.resize()
  {
      local targetSize="${1}"
      local emptyItem="${2:-}"

      if (( targetSize < 0 )); then
          besharp.runtime.error "Negative ArrayVector size?"
      fi

      @let currentSize = $this.size

      if (( targetSize >= currentSize )); then
          local i
          for (( i=currentSize; i < targetSize; ++i )); do
              eval "${this}[${i}]=\"\${emptyItem}\""
          done
      else
          local i
          for (( i=targetSize; i < currentSize; ++i )); do
              unset "${this}[${i}]"
          done
      fi
  }

  function ArrayVector.remove()
  {
      local item="${1}"

      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          @returning false
          return
      fi

      @let idx = $this.findIndex "${item}"
      if (( idx < 0 )); then
          @returning false
          return
      fi

      $this.removeIndex "${idx}"
      @returning true
  }

  function ArrayVector.add()
  {
      local item="${1}"

      eval "${this}+=(\"\${item}\")"
  }

  function ArrayVector.setPlain()
  {
      eval "${this}=(\"\${@}\")"
  }

  function ArrayVector.set()
  {
      local index="${1}"
      local item="${2}"

      if ! @true $this.hasIndex "${index}"; then
          local size=$( @echo $this.size )
          besharp.runtime.error "Cannot set! ArrayVector index out of range: ${index}. Allowed range: 0 - $(( size - 1))"
      fi

      eval "${this}[${index}]=\"\${item}\""
      @returning "${item}"
  }

  function ArrayVector.get()
  {
      local index="${1}"

      if ! @true $this.hasIndex "${index}"; then
          local size=$( @echo $this.size )
          besharp.runtime.error "Cannot get! ArrayVector index out of range: ${index}. Allowed range: 0 - $(( size - 1))"
      fi

      local item
      eval "item=\"\${${this}[${index}]}\""
      @returning "${item}"
  }

  function ArrayVector.findIndex()
  {
      local item="${1}"
      local minIndex="${2:-0}"

      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          @returning false
          return
      fi

      @let size = $this.size

      if (( minIndex < 0 )); then
          minIndex=0
      fi

      local idx
      for (( idx=minIndex; idx < size; ++idx )); do
          local lookupItem
          eval "lookupItem=\"\${${this}[${idx}]}\""
          if @same "${lookupItem}" "${item}"; then
              @returning "${idx}"
              return
          fi
      done

      @returning -1
  }

  function ArrayVector.findLastIndex()
  {
      local item="${1}"
      local maxIndex="${2:-}"

      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          @returning false
          return
      fi

      @let size = $this.size

      if [[ "${maxIndex}" == '' ]] || (( maxIndex >= size )); then
          maxIndex=${size}
      fi

      local idx
      for (( idx=maxIndex-1; idx >= 0; --idx )); do
          local lookupItem
          eval "lookupItem=\"\${${this}[${idx}]}\""
          if @same "${lookupItem}" "${item}"; then
              @returning "${idx}"
              return
          fi
      done

      @returning -1
  }

  function ArrayVector.findIndices()
  {
      local item="${1}"

      @let resultCollection = @new ArrayVector
      @returning $resultCollection

      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          return
      fi

      @let size = $this.size

      local idx
      for (( idx=0; idx < size; ++idx )); do
          local lookupItem
          eval "lookupItem=\"\${${this}[${idx}]}\""
          if @same "${lookupItem}" "${item}"; then
              $resultCollection.add "${idx}"
          fi
      done
  }

  function ArrayVector.insertAt()
  {
      local index="${1}"
      local item="${2}"

      @let size = $this.size

      if (( index == size )); then
          eval "${this}[size]=\${item}"
          return
      fi

      if ! @true $this.hasIndex "${index}"; then
          besharp.runtime.error "Cannot insertAt! ArrayVector index out of range: ${index}. Allowed range: 0 - ${size}"
          return 1
      fi

      local idx
      for (( idx=size; idx >= index; --idx)); do
          eval "${this}[idx]=\${${this}[idx - 1]}"
      done

      eval "${this}[index]=\${item}"
  }

  function ArrayVector.insertManyAt()
  {
      local index="${1}"
      shift 1

      local item
      local x=0
      while @iterate "${@}" @in item; do
          $this.insertAt $(( index + x )) "${item}"
          (( ++x ))
      done
  }

  function ArrayVector.insertAtManyIndices()
  {
      local item="${1}"
      shift 1

      local index
      local indices=( )
      while @iterate "${@}" @in index; do
          if ! @true $this.hasIndex "${index}"; then
              @let size = $this.size
              besharp.runtime.error "Cannot insertAtManyIndices! ArrayVector index out of range: ${index}. Allowed range: 0 - ${size}"
              return 1
          fi
          indices[${index}]=dummy
      done

      local ordered
      declare -n ordered="indices"
      local idx
      local x=0
      for idx in "${!ordered[@]}"; do
          $this.insertAt $(( idx + x )) "${item}"
          (( ++x ))
      done
  }

  function ArrayVector.removeIndex()
  {
      local index="${1}"

      @let size = $this.size

      if ! @true $this.hasIndex "${index}"; then
          besharp.runtime.error "Cannot get! ArrayVector index out of range: ${index}. Allowed range: 0 - $(( size - 1))"
          return 1
      fi

      local idx
      for (( idx=index; idx < size - 1; ++idx)); do
          eval "${this}[idx]=\${${this}[idx + 1]}"
      done

      unset "${this}[-1]"
  }

  function ArrayVector.removeIndices()
  {
      local index
      local indices=( )
      while @iterate "${@}" @in index; do
          if ! @true $this.hasIndex "${index}"; then
              @let size = $this.size
              besharp.runtime.error "Cannot get! ArrayVector index out of range: ${index}. Allowed range: 0 - $(( size - 1))"
              return 1
          fi
          indices[${index}]=dummy
      done

      local ordered
      declare -n ordered="indices"
      local idx
      local x=0
      for idx in "${!ordered[@]}"; do
          $this.removeIndex $(( idx - x ))
          (( ++x ))
      done
  }

  function ArrayVector.rotate()
  {
      local distance="${1}"

      @let size = $this.size

      distance=$(( distance % size ))
      if (( distance < 0 )); then
          (( distance += size ))
      fi

      if (( distance == 0 )) || (( size < 2 )); then
          return
      fi

      local values=()
      local position=0
      local temp
      declare -n temp="${this}"
      local idx
      for (( idx=0; idx < size; ++idx )); do
          eval "local value=\${${this}[\${idx}]}"

          if (( ++position <= distance )); then
              # 1. collect first n-th items
              values+=( "${value}" )
          else
              # 2. rotate other items directly by given distance
              eval "${this}[position - distance - 1]=\${${this}[${idx}]}"
          fi
      done

      local i
      for (( i=0; i < distance; ++i )); do
          # 3. put collected items at the end
          eval "${this}[size - distance + i]=\${values[${i}]}"
      done
  }

  function ArrayVector.reverse()
  {
      @let size = $this.size

      if (( size < 2 )); then
          return
      fi

      local idx1
      local idx2
      local tmpValue
      for (( idx1=0; idx1 < size; ++idx1)); do
          idx2=$(( size - 1 - idx1 ))

          if (( idx1 >= idx2 )); then
              break
          fi

          eval "tmpValue=\"\${${this}[idx1]}\""
          eval "${this}[idx1]=\"\${${this}[idx2]}\""
          eval "${this}[idx2]=\"\${tmpValue}\""
      done
  }

  function ArrayVector.shuffle()
  {
      @let size = $this.size


      if (( size < 2 )); then
          return
      fi

      local idx1
      local idx2
      local tmpValue
      for (( idx1 = 0; idx1 < size; ++idx1 )); do
          idx2=$(( RANDOM % size ))
          if (( idx1 == idx2 )); then
              continue
          fi

          eval "tmpValue=\"\${${this}[idx1]}\""
          eval "${this}[idx1]=\"\${${this}[idx2]}\""
          eval "${this}[idx2]=\"\${tmpValue}\""
      done
  }

@classdone