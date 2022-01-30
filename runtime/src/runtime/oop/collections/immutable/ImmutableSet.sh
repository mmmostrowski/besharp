#!/usr/bin/env bash

@internal @class ImmutableSet @extends ArraySet

  function ImmutableSet()
  {
      @parent

      local item
      for item in "${@}"; do
          @let objectId = @object-id "${item}"

          eval "${this}[\"\${objectId}\"]=\"\${item}\""
      done
  }

  function ImmutableSet.add()
  {
      besharp.runtime.error "You cannot add!"
  }

  function ImmutableSet.shuffle()
  {
      besharp.runtime.error "You cannot shuffle!"
  }

  function ImmutableSet.addMany()
  {
      besharp.runtime.error "You cannot addMany!"
  }

  function ImmutableSet.fill()
  {
      besharp.runtime.error "You cannot fill!"
  }

  function ImmutableSet.replace()
  {
      besharp.runtime.error "You cannot replace!"
  }

  function ImmutableSet.replaceMany()
  {
      besharp.runtime.error "You cannot replaceMany!"
  }

  function ImmutableSet.remove()
  {
      besharp.runtime.error "You cannot remove!"
  }

  function ImmutableSet.removeMany()
  {
      besharp.runtime.error "You cannot removeMany!"
  }

  function ImmutableSet.removeAll()
  {
      besharp.runtime.error "You cannot removeAll!"
  }
  
@classdone