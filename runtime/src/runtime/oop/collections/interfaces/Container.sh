#!/usr/bin/env bash

@internal @interface Container @implements Iterable

  @interface function Container.isEmpty
  @interface function Container.size

  @interface function Container.has
  @interface function Container.hasAll
  @interface function Container.hasSome

  @interface function Container.frequency

  @interface function Container.isOwningItems
  @interface function Container.ownsItsItems

@intdone