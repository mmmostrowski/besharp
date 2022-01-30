#!/usr/bin/env bash

@internal @class Queue @extends IndexedArrayCollection @implements Sequence MutableContainer

  function Queue()
  {
      @parent
  }

  function Queue.current()
  {
      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          besharp.runtime.error "You cannot call Queue.current() on an empty Set! Please use Queue.isEmpty() method to avoid this issue!"
          return
      fi

      local temp
      declare -n temp="${this}"
      local idx
      for idx in "${!temp[@]}"; do
          local item
          eval "item=\"\${${this}[${idx}]}\""
          @returning "${item}"
          return
      done
  }

  function Queue.pull()
  {
      local var="${this}[@]"
      if [[ "${!var+isset}" != "isset" ]]; then
          besharp.runtime.error "You cannot call Queue.pull() on an empty Set! Please use Queue.isEmpty() method to avoid this issue!"
          return
      fi

      local temp
      declare -n temp="${this}"
      local idx
      for idx in "${!temp[@]}"; do
          local item
          eval "item=\"\${${this}[${idx}]}\""
          @returning "${item}"
          unset "${this}[${idx}]"
          return
      done
  }

@classdone