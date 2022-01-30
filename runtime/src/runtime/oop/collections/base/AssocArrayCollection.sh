#!/usr/bin/env bash

@abstract @internal @class AssocArrayCollection @extends PrimitiveCollection

    function AssocArrayCollection() {
        @parent
    }

    function AssocArrayCollection.declarePrimitiveVariable()
    {
        declare -Ag "${this}"
    }

    function AssocArrayCollection.destroyPrimitiveVariable()
    {
        unset "${this}"
    }


@classdone