#!/usr/bin/env bash

@internal @class NaturalOrderComparator @implements Comparator FastComparator

  function NaturalOrderComparator()
  {
      :
  }

  function NaturalOrderComparator.compare()
  {
      local objectA="${1}"
      local objectB="${2}"

      $objectB.compareWith $objectA
  }

  function NaturalOrderComparator.fastCompareFunction()
  {
      local varAName="${1:-\$valueA}"
      local varBName="${2:-\$valueB}"

      @returning "${varAName}.compareWith ${varBName} # "
  }

@classdone