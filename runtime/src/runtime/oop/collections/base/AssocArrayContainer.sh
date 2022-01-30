#!/usr/bin/env bash

@abstract @internal @class AssocArrayContainer @extends PrimitiveContainer

    function AssocArrayContainer() {
        @parent
    }

    function AssocArrayContainer.declarePrimitiveVariable()
    {
        declare -Ag "${this}"
    }

    function AssocArrayContainer.destroyPrimitiveVariable()
    {
        unset "${this}"
    }


@classdone