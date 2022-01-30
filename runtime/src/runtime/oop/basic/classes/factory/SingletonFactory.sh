#!/usr/bin/env bash

@internal @class SingletonFactory @extends SimpleFactory @implements Factory

  @var class

  @var object

  function SingletonFactory()
  {
      $this.class = "${1}"
  }

  function SingletonFactory.create()
  {
      if ! @exists @of $this.object; then
          @let $this.object = @parent "${@}"
      fi
      @returning @of $this.object
  }

@classdone