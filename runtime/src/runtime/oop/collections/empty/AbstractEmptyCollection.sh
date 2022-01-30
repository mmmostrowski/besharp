#!/usr/bin/env bash

@abstract @internal @class AbstractEmptyCollection @implements Collection IterableByKeys

  function AbstractEmptyCollection()
  {
      @parent
  }

  function AbstractEmptyCollection.isEmpty()
  {
      @returning true
  }

  function AbstractEmptyCollection.iterationNew()
  {
      @returning ""
  }

  function AbstractEmptyCollection.iterationValue()
  {
      besharp.runtime.error "Has no values!"
  }

  function AbstractEmptyCollection.iterationNext()
  {
      @returning ""
  }

  function AbstractEmptyCollection.add()
  {
      besharp.runtime.error "You cannot add!"
  }

  function AbstractEmptyCollection.shuffle()
  {
      :
  }

  function AbstractEmptyCollection.get()
  {
      besharp.runtime.error "Nothing to get!"
  }

  function AbstractEmptyCollection.keys()
  {
      @returning $this
  }

  function AbstractEmptyCollection.addMany()
  {
      besharp.runtime.error "You cannot addMany!"
  }

  function AbstractEmptyCollection.fill()
  {
      :
  }

  function AbstractEmptyCollection.replace()
  {
      :
  }

  function AbstractEmptyCollection.replaceMany()
  {
      :
  }

  function AbstractEmptyCollection.remove()
  {
      @returning false
  }

  function AbstractEmptyCollection.removeMany()
  {
      @returning false
  }

  function AbstractEmptyCollection.removeAll()
  {
      :
  }

  function AbstractEmptyCollection.ownsItsItems()
  {
      :
  }

  function AbstractEmptyCollection.isOwningItems()
  {
      @returning false
  }

  function AbstractEmptyCollection.frequency()
  {
      @returning 0
  }

  function AbstractEmptyCollection.hasSome()
  {
      @returning false
  }

  function AbstractEmptyCollection.hasAll()
  {
      @returning false
  }

  function AbstractEmptyCollection.has()
  {
      @returning false
  }

  function AbstractEmptyCollection.hasKey()
  {
      @returning false
  }

  function AbstractEmptyCollection.size()
  {
      @returning 0
  }

@classdone