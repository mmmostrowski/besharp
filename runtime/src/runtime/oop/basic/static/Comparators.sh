#!/usr/bin/env bash

@static { @comparators }
@internal @class Comparators \

    function Comparators()
    {
        :
    }

    function Comparators.makeForNaturalOrder()
    {
        local reversed="${1:-false}"

        if $reversed; then
            @returning @of @new ReversedOrderComparator
        else
            @returning @of @new NaturalOrderComparator
        fi
    }

    function Comparators.makeForReversedOrder()
    {
        local reversed="${1:-false}"

        if $reversed; then
            @returning @of @new NaturalOrderComparator
        else
            @returning @of @new ReversedOrderComparator
        fi
    }

    function Comparators.makeForNaturalOrderIntegers()
    {
        local reversed="${1:-false}"

        if $reversed; then
            @returning @of @new ReversedOrderIntegersComparator
        else
            @returning @of @new NaturalOrderIntegersComparator
        fi
    }

    function Comparators.makeForReversedOrderIntegers()
    {
        local reversed="${1:-false}"

        if $reversed; then
            @returning @of @new NaturalOrderIntegersComparator
        else
            @returning @of @new ReversedOrderIntegersComparator
        fi
    }

@classdone
