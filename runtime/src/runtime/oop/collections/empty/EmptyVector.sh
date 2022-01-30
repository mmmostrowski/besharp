#!/usr/bin/env bash

@internal @class EmptyVector @extends AbstractEmptyCollection @implements Vector

  function EmptyVector()
  {
      @parent
  }

  function EmptyVector.resize()
  {
      besharp.runtime.error "You cannot resize!"
  }

  function EmptyVector.setPlain()
  {
      besharp.runtime.error "You cannot setPlain!"
  }

  function EmptyVector.set()
  {
      besharp.runtime.error "You cannot set!"
  }

  function EmptyVector.findIndex()
  {
      @returning -1
  }

  function EmptyVector.findLastIndex()
  {
      @returning -1
  }

  function EmptyVector.findIndices()
  {
      @returning $this
  }

  function EmptyVector.insertAt()
  {
      besharp.runtime.error "You cannot insertAt!"
  }

  function EmptyVector.insertManyAt()
  {
      besharp.runtime.error "You cannot insertManyAt!"
  }

  function EmptyVector.insertAtManyIndices()
  {
      besharp.runtime.error "You cannot insertAtManyIndices!"
  }

  function EmptyVector.removeIndex()
  {
      besharp.runtime.error "You cannot removeIndex!"
  }

  function EmptyVector.removeIndices()
  {
      besharp.runtime.error "You cannot removeIndices!"
  }

  function EmptyVector.rotate()
  {
      :
  }

  function EmptyVector.reverse()
  {
      :
  }

  function EmptyVector.swapIndices()
  {
      besharp.runtime.error "You cannot swapIndices!"
  }

  function EmptyVector.hasIndex()
  {
      @returning false
  }

  function EmptyVector.indices()
  {
      @returning $this
  }

  function EmptyVector.call()
  {
      eval "@returning @of \"\${@}\""
  }

@classdone