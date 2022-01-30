#!/usr/bin/env bash

@internal @class Stack @extends IndexedArrayCollection @implements Sequence MutableContainer

  function Stack()
  {
      @parent
  }

  function Stack.current()
  {
      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          besharp.runtime.error "You cannot call Stack.current() on an empty Set! Please use Stack.isEmpty() method to avoid this issue!"
          return
      fi

      local size
      eval "size=\${#${this}}"

      local item
      eval "item=\"\${${this}[-1]}\""
      @returning "${item}"
  }

  function Stack.pull()
  {
      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          besharp.runtime.error "You cannot call Stack.pull() on an empty Set! Please use Stack.isEmpty() method to avoid this issue!"
          return
      fi

      local item
      eval "item=\"\${${this}[-1]}\""
      @returning "${item}"

      unset "${this}[-1]"
  }

  function Stack.iterationNew()
  {
      ArrayIteration.reversedIterationNew "${this}" "${@}"
  }

  function Stack.iterationValue()
  {
      ArrayIteration.iterationValue "${this}" "${@}"
  }

  function Stack.iterationNext()
  {
      ArrayIteration.reversedIterationNext "${this}" "${@}"
  }

@classdone