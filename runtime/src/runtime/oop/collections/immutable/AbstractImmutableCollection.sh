#!/usr/bin/env bash

@abstract @internal @class AbstractImmutableCollection @implements Collection IterableByKeys

  function AbstractImmutableCollection()
  {
      @parent
  }

  function AbstractImmutableCollection.add()
  {
      besharp.runtime.error "You cannot add!"
  }

  function AbstractImmutableCollection.shuffle()
  {
      besharp.runtime.error "You cannot shuffle!"
  }

  function AbstractImmutableCollection.addMany()
  {
      besharp.runtime.error "You cannot addMany!"
  }

  function AbstractImmutableCollection.fill()
  {
      besharp.runtime.error "You cannot fill!"
  }

  function AbstractImmutableCollection.replace()
  {
      besharp.runtime.error "You cannot replace!"
  }

  function AbstractImmutableCollection.replaceMany()
  {
      besharp.runtime.error "You cannot replaceMany!"
  }

  function AbstractImmutableCollection.remove()
  {
      besharp.runtime.error "You cannot remove!"
  }

  function AbstractImmutableCollection.removeMany()
  {
      besharp.runtime.error "You cannot removeMany!"
  }

  function AbstractImmutableCollection.removeAll()
  {
      besharp.runtime.error "You cannot removeAll!"
  }

@classdone