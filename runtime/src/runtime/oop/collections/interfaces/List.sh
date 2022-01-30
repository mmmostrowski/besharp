#!/usr/bin/env bash

@internal @interface List @implements Collection IterableByKeys

  @interface function List.set
  @interface function List.get
  @interface function List.indices

  @interface function List.hasIndex
  @interface function List.findIndex
  @interface function List.findLastIndex
  @interface function List.findIndices

  @interface function List.removeIndex
  @interface function List.removeIndices

  @interface function List.reverse
  @interface function List.rotate
  @interface function List.swapIndices

@intdone