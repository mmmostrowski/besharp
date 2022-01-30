#!/usr/bin/env bash

@static { @vectors }
@internal @class Vectors \

    @var Vector empty

    function Vectors()
    {
        @let $this.empty = @new EmptyVector
    }

    function Vectors.single()
    {
        local item="${1}"

        @returning @of @new ImmutableVector "${item}"
    }

    function Vectors.nCopies()
    {
        local item="${1}"
        local numOfCopies="${2}"

        if (( numOfCopies == 0 )); then
            @returning @of @new EmptyVector
            return
        fi

        local copies=()
        while (( numOfCopies-- )); do
            copies+=( "${item}" )
        done

        @returning @of @new ImmutableVector "${copies[@]}"
    }

    function Vectors.make()
    {
        @let vector = @new ArrayVector

        $vector.setPlain "${@}"

        @returning $vector
    }

    function Vectors.makeOf()
    {
        local iterable="${1}"

        if @is $iterable @exact ArrayVector; then
            @returning @of @clone shallow $iterable
            return
        fi

        @let vector = @new ArrayVector

        $vector.addMany @iterable "${iterable}"

        @returning $vector
    }

    function Vectors.makeImmutable()
    {
        @returning @of @new ImmutableVector "${@}"
    }

    function Vectors.makeImmutableOf()
    {
        local iterable="${1}"

        @let immutable = @new ImmutableVector

        $this.cloneTo $immutable $iterable

        @returning $immutable
    }

    function Vectors.cloneTo()
    {
        local targetVector="${1}"
        local sourceIterable="${2}"

        if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetVector}" )" ]]; then
            @clone @to ${targetVector} shallow $sourceIterable
            return
        fi

        $targetVector.removeAll
        $this.copyTo $targetVector $sourceIterable
    }

    function Vectors.copyTo()
    {
        local targetVector="${1}"
        local sourceIterable="${2}"

        if @is $sourceIterable @a PrimitiveObject; then
            eval "${targetVector}+=( \"\${${sourceIterable}[@]}\" )"
            return
        fi

        $targetVector.addMany $sourceIterable
    }

    function Vectors.join()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.joinTo $result "${@}"

        @returning $result
    }

    function Vectors.joinTo()
    {
        local targetVector="${1}"
        shift 1

        local iterable
        for iterable in "${@}"; do
             if @is $iterable @a PrimitiveObject \
                  && ( @is $iterable @a List \
                      || @is $iterable @a Set \
                      || @is $iterable @a Map ) \
              ; then # note: includes Vector
                  eval "${targetVector}+=( \"\${${iterable}[@]}\" )"
              else
                  $targetVector.addMany $iterable
              fi
        done
    }

    function Vectors.intersect()
    {
        local first="${1}"
        shift 1

        @let result = @new ArrayVector

        local targetValue
        while @iterate $first @in targetValue; do
            local iterable
            for iterable in "${@}"; do
                if ! @true @collections.has $iterable "${targetValue}"; then
                    continue 2
                fi
            done

            $result.add "${targetValue}"
        done


        @returning $result
    }

    function Vectors.intersectTo()
    {
        local targetVector="${1}"
        shift 1

        local i
        local targetValue
        @let sourceSize = $targetVector.size
        local indicesToRemove=()
        for (( i = 0; i < sourceSize; ++i )); do
            @let targetValue = $targetVector.get "${i}"

            local iterable
            for iterable in "${@}"; do
                if ! @true @collections.has $iterable "${targetValue}"; then
                    indicesToRemove+=( "${i}" )
                    break
                fi
            done
        done

        $targetVector.removeIndices "${indicesToRemove[@]}"
    }

    function Vectors.subtract()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.subtractTo $result "${@}"

        @returning $result
    }

    function Vectors.subtractTo()
    {
        local targetVector="${1}"
        shift 1

        local i
        local targetValue
        @let sourceSize = $targetVector.size
        local indicesToRemove=()
        for (( i = 0; i < sourceSize; ++i )); do
            @let targetValue = $targetVector.get "${i}"

            local iterable
            for iterable in "${@}"; do
                if @true @collections.has $iterable "${targetValue}"; then
                    indicesToRemove+=( "${i}" )
                    break
                fi
            done
        done

        $targetVector.removeIndices "${indicesToRemove[@]}"
    }

    function Vectors.slice()
    {
        local list="${1}"
        local indexA="${2}"
        local indexB="${3}"

        @let result = @new ArrayVector

        $this.sliceTo $result "${@}"

        @returning $result
    }

    function Vectors.sliceTo()
    {
        @lists.sliceTo "${@}"
    }

@classdone
