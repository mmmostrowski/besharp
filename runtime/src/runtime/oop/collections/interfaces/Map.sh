#!/usr/bin/env bash

@internal @interface Map @implements MutableContainer IterableByKeys

  @interface function Map.set
  @interface function Map.setPlainPairs

  @interface function Map.hasKey
  @interface function Map.hasAllKeys
  @interface function Map.hasSomeKeys

  @interface function Map.findAllKeys

  @interface function Map.removeKey
  @interface function Map.removeKeys

  @interface function Map.swapKeys


@intdone