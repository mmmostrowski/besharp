#!/usr/bin/env bash

@abstract @internal @class PrimitiveCollection @extends PrimitiveContainer

  function PrimitiveCollection()
  {
      @parent
  }

  function PrimitiveCollection.addMany()
  {
      local item
      while @iterate "${@}" @in item; do
          $this.add "${item}"
      done
  }

@classdone