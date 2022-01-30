#!/usr/bin/env bash

@internal @class ReversedOrderComparator @implements Comparator FastComparator

  function ReversedOrderComparator()
  {
      :
  }

  function ReversedOrderComparator.compare()
  {
      local objectA="${1}"
      local objectB="${2}"

      ! $objectB.compareWith $objectA
  }

  function ReversedOrderComparator.fastCompareFunction()
  {
      local varAName="${1:-\$valueA}"
      local varBName="${2:-\$valueB}"

      ! @returning "${varAName}.compareWith ${varBName} # "
  }

@classdone