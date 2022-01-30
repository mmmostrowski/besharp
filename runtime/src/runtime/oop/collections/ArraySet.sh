#!/usr/bin/env bash

@internal @class ArraySet @extends AssocArrayCollection @implements Set

  function ArraySet()
  {
      @parent
  }

  function ArraySet.add()
  {
      local item="${1}"

      @let objectId = @object-id "${item}"

      eval "${this}[\"\${objectId}\"]=\"\${item}\""
  }

  function ArraySet.has()
  {
      local item="${1}"

      @let objectId = @object-id "${item}"

      local var="${this}[${objectId}]"
      if [[ "${!var+isset}" == "isset" ]]; then
          @returning true
      else
          @returning false
      fi
  }

  function ArraySet.hasKey()
  {
      @returning @of $this.has "${@}"
  }

  function ArraySet.remove()
  {
      local item="${1}"

      @let objectId = @object-id "${item}"

      unset "${this}[${objectId}]"
  }

  function ArraySet.shuffle()
  {
      :
  }

  function ArraySet.replace()
  {
      local fromItem="${1}"
      local toItem="${2}"

      @let fromObjId = @object-id "${fromItem}"

      local var="${this}[${fromObjId}]"
      if [[ "${!var+isset}" == "isset" ]]; then
          unset "${this}[${fromObjId}]"
      fi

      $this.add "${toItem}"
  }

  function ArraySet.fill()
  {
      local item="${1}"

      $this.removeAll
      $this.add "${item}"
  }

  function ArraySet.frequency()
  {
      local item="${1}"

      if @true $this.has "${item}"; then
          @returning 1
      else
          @returning 0
      fi
  }

@classdone