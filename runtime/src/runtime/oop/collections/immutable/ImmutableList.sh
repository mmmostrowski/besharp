#!/usr/bin/env bash

@internal @class ImmutableList @extends ArrayList

    function ImmutableList()
    {
        @parent
  
        eval "${this}=(\"\${@}\")"
    }
  
    function ImmutableList.add()
    {
        besharp.runtime.error "You cannot add!"
    }
  
    function ImmutableList.addMany()
    {
        besharp.runtime.error "You cannot addMany!"
    }
  
    function ImmutableList.set()
    {
        besharp.runtime.error "You cannot set!"
    }
  
    function ImmutableList.removeIndex()
    {
        besharp.runtime.error "You cannot removeIndex!"
    }
  
    function ImmutableList.removeIndices()
    {
        besharp.runtime.error "You cannot removeIndices!"
    }
  
    function ImmutableList.rotate()
    {
        besharp.runtime.error "You cannot rotate!"
    }
  
    function ImmutableList.reverse()
    {
        besharp.runtime.error "You cannot reverse!"
    }
  
    function ImmutableList.swapIndices()
    {
        besharp.runtime.error "You cannot swapIndices!"
    }

@classdone