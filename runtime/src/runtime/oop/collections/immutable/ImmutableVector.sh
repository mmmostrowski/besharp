#!/usr/bin/env bash

@internal @class ImmutableVector @extends ArrayVector

  function ImmutableVector()
  {
      @parent

      eval "${this}=(\"\${@}\")"
  }

  function ImmutableVector.add()
  {
      besharp.runtime.error "You cannot add!"
  }

  function ImmutableVector.addMany()
  {
      besharp.runtime.error "You cannot addMany!"
  }

  function ImmutableVector.resize()
  {
      besharp.runtime.error "You cannot resize!"
  }

  function ImmutableVector.setPlain()
  {
      besharp.runtime.error "You cannot setPlain!"
  }

  function ImmutableVector.set()
  {
      besharp.runtime.error "You cannot set!"
  }

  function ImmutableVector.insertAt()
  {
      besharp.runtime.error "You cannot insertAt!"
  }

  function ImmutableVector.insertManyAt()
  {
      besharp.runtime.error "You cannot insertManyAt!"
  }

  function ImmutableVector.insertAtManyIndices()
  {
      besharp.runtime.error "You cannot insertAtManyIndices!"
  }

  function ImmutableVector.removeIndex()
  {
      besharp.runtime.error "You cannot removeIndex!"
  }

  function ImmutableVector.removeIndices()
  {
      besharp.runtime.error "You cannot removeIndices!"
  }

  function ImmutableVector.rotate()
  {
      besharp.runtime.error "You cannot rotate!"
  }

  function ImmutableVector.reverse()
  {
      besharp.runtime.error "You cannot reverse!"
  }

  function ImmutableVector.swapIndices()
  {
      besharp.runtime.error "You cannot swapIndices!"
  }

@classdone