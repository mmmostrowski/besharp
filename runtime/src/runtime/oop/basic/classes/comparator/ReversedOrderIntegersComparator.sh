#!/usr/bin/env bash

@internal @class ReversedOrderIntegersComparator @implements Comparator FastComparator

  function ReversedOrderIntegersComparator()
  {
      :
  }

  function ReversedOrderIntegersComparator.compare()
  {
      local valueA="${1}"
      local valueB="${2}"

      ! (( valueA < valueB ))
  }

  function ReversedOrderIntegersComparator.fastCompareFunction()
  {
      local varAName="${1:-\$valueA}"
      local varBName="${2:-\$valueB}"

      @returning "! (( ${varAName} < ${varBName} )) # "
  }

@classdone