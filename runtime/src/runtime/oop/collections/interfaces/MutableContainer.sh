#!/usr/bin/env bash

@internal @interface MutableContainer @implements Container

  @interface function MutableContainer.removeAll
  @interface function MutableContainer.remove
  @interface function MutableContainer.removeMany
  @interface function MutableContainer.replace
  @interface function MutableContainer.replaceMany
  @interface function MutableContainer.shuffle
  @interface function MutableContainer.fill

@intdone