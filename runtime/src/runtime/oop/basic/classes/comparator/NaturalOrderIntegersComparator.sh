#!/usr/bin/env bash

@internal @class NaturalOrderIntegersComparator @implements Comparator FastComparator

  function NaturalOrderIntegersComparator()
  {
      :
  }

  function NaturalOrderIntegersComparator.compare()
  {
      local valueA="${1}"
      local valueB="${2}"

      (( valueA < valueB ))
  }

  function NaturalOrderIntegersComparator.fastCompareFunction()
  {
      local varAName="${1:-\$valueA}"
      local varBName="${2:-\$valueB}"

      @returning "(( ${varAName} < ${varBName} )) # "
  }

@classdone
