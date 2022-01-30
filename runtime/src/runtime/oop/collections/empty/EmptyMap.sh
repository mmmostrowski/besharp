#!/usr/bin/env bash

@internal @class EmptyMap @extends AbstractEmptyCollection @implements Map

  function EmptyMap()
  {
      @parent
  }

  function EmptyMap.set()
  {
      besharp.runtime.error "You cannot set!"
  }

  function EmptyMap.setPlainPairs()
  {
      besharp.runtime.error "You cannot setPlainPairs!"
  }

  function EmptyMap.swapKeys()
  {
      besharp.runtime.error "You cannot swapKeys!"
  }

  function EmptyMap.removeKeys()
  {
      :
  }

  function EmptyMap.removeKey()
  {
      :
  }

  function EmptyMap.findAllKeys()
  {
      @returning $this
  }

  function EmptyMap.hasSomeKeys()
  {
      @returning false
  }

  function EmptyMap.hasAllKeys()
  {
      @returning false
  }

  function EmptyMap.hasKey()
  {
      @returning false
  }

@classdone