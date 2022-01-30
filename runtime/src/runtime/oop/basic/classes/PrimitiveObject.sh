#!/usr/bin/env bash

@abstract @internal @class PrimitiveObject

  function PrimitiveObject()
  {
      $this.declarePrimitiveVariable
  }

  function PrimitiveObject.__cloneFrom()
  {
      @parent "${@}"

      $this.declarePrimitiveVariable
  }

  @abstract function PrimitiveObject.declarePrimitiveVariable

  @abstract function PrimitiveObject.destroyPrimitiveVariable

  function PrimitiveObject.__destroy()
  {
        $this.destroyPrimitiveVariable
  }

@classdone