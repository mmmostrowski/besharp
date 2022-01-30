#!/usr/bin/env bash

@internal @class SimpleFactory @implements Factory

  @var class

  function SimpleFactory()
  {
      $this.class = "${1}"
  }

  function SimpleFactory.create()
  {
      @let class = $this.class

      @let object = @new ${class} "${@}"

      @returning $object
  }

@classdone