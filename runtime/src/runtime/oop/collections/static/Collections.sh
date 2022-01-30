#!/usr/bin/env bash

@static { @collections }
@internal @class Collections \

    @var Collection empty

    function Collections()
    {
        @let $this.empty = @new EmptySet
    }

    function Collections.single()
    {
        local item="${1}"

        @returning @of @new ImmutableVector "${item}"
    }

    function Collections.nCopies()
    {
        @returning @of @vectors.nCopies "${@}"
    }

    function Collections.makeStack()
    {
        @returning @of @new Stack
    }

    function Collections.makeQueue()
    {
        @returning @of @new Queue
    }

    function Collections.makePriorityQueue()
    {
        @returning @of @new Heap
    }

    function Collections.makeOf()
    {
        local iterable="${1}"

        if @is $iterable Set; then
            @returning @of @sets.makeOf $iterable
        elif @is $iterable Vector; then
            @returning @of @vectors.makeOf $iterable
        elif @is $iterable List; then
            @returning @of @lists.makeOf $iterable
        elif @is $iterable Map; then
            @returning @of @maps.makeOf $iterable
        elif @is $iterable IterableByKeys; then
            @returning @of @maps.makeOf $iterable
        elif @is $iterable Collection; then
            @returning @of @vectors.makeOf $iterable
        elif @is $iterable Iterable; then
            @returning @of @vectors.makeOf $iterable
        else
            besharp.runtime.error "$iterable must be a type of Collection instead of $(besharp.rtti.objectType $iterable )"
        fi
    }

    function Collections.makeImmutableOf()
    {
        local iterable="${1}"

        if @is $iterable Set; then
            @returning @of @sets.makeImmutableOf $iterable
        elif @is $iterable Vector; then
            @returning @of @vectors.makeImmutableOf $iterable
        elif @is $iterable List; then
            @returning @of @lists.makeImmutableOf $iterable
        elif @is $iterable Map; then
            @returning @of @maps.makeImmutableOf $iterable
        elif @is $iterable IterableByKeys; then
            @returning @of @maps.makeImmutableOf $iterable
        elif @is $iterable Collection; then
            @returning @of @vectors.makeImmutableOf $iterable
        elif @is $iterable Iterable; then
            @returning @of @vectors.makeImmutableOf $iterable
        else
            besharp.runtime.error "$iterable must be a type of Collection instead of $(besharp.rtti.objectType $iterable )"
        fi
    }

    function Collections.cloneTo()
    {
        local targetContainer="${1}"
        local sourceIterable="${2}"

        if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetContainer}" )" ]]; then
            @clone @to ${targetContainer} shallow $sourceIterable
            return
        fi

        $targetContainer.removeAll
        $this.copyTo $targetContainer $sourceIterable
    }

    function Collections.copyTo()
    {
        local targetContainer="${1}"
        local sourceIterable="${2}"

        if @is $targetContainer @a Map; then
            if ! @is $sourceIterable @an IterableByKeys; then
                besharp.runtime.error "Cannot clone '$sourceIterable' to a Map! Source must implement IterableByKeys during cloning maps!"
            fi
            @maps.copyTo $targetContainer $sourceIterable
            return
        fi

        if @is $targetContainer @a Set; then
            @sets.copyTo $targetContainer $sourceIterable
            return
        fi

        if @is $targetContainer @a Vector; then
            @vectors.copyTo $targetContainer $sourceIterable
            return
        fi

        if @is $targetContainer @a List; then
            @lists.copyTo $targetContainer $sourceIterable
            return
        fi

        if @is $targetContainer @a Collection; then
            $targetContainer.addMany $sourceIterable
            return
        fi

        besharp.runtime.error "Sorry pal. You will have to copy '${sourceIterable}' object by yourself! I don't know how to add things to '${targetContainer}' :( "
    }

    function Collections.isEmpty()
    {
        local iterable="${1}"

        if @is $iterable @a Container; then
            @returning @of $iterable.isEmpty
        else
            if @returned @of $iterable.iterationNew == ""; then
                @returning true
            else
                @returning true
            fi
        fi
    }

    function Collections.size()
    {
        local iterable="${1}"

        if @is $iterable @a Container; then
            @returning @of $iterable.size
        else
            local size=0

            local subjectItem
            while @iterate $iterable @in subjectItem; do
                (( ++size ))
            done

            @returning "${size}"
        fi
    }

    function Collections.has()
    {
        local iterable="${1}"
        local value="${2}"

        if @is $iterable @a Container; then
            @returning @of $iterable.has "${value}"
        else
            local subjectItem
            while @iterate $iterable @in subjectItem; do
                if [[ "${subjectItem}" == "${value}" ]]; then
                    @returning true
                    return
                fi
            done

            @returning false
        fi
    }

    function Collections.hasAll()
    {
        local iterable="${1}"
        shift 1

        if @is $iterable @a Container; then
            @returning @of $iterable.hasAll "${@}"
        else
            @let uniqueItems = @sets.make "${@}"

            local subjectItem
            while @iterate $iterable @in subjectItem; do
                $uniqueItems.remove "${subjectItem}"
            done

            @returning @of $uniqueItems.isEmpty
            @unset $uniqueItems
        fi
    }

    function Collections.hasSome()
    {
        local iterable="${1}"
        shift 1

        if @is $iterable @a Container; then
            @returning @of $iterable.hasSome "${@}"
        else
            @let subjectItems = @sets.make "${@}"

            @returning false
            local subjectItem
            while @iterate $iterable @in subjectItem; do
                if @true $subjectItems.has "${subjectItem}"; then
                    @returning true
                    break
                fi
            done

            @unset $subjectItems
        fi
    }

    function Collections.isIntersecting()
    {
        local iterableA="${1}"
        local iterableB="${2}"

        if @is $iterableB Set; then
            # performance tweak
            local source=$iterableB
            iterableB=$iterableA
            iterableA=$source
        fi

        if @is $iterableA Container; then
            @returning @of $iterableA.hasSome $iterableB
            return
        elif @is $iterableB Container; then
            @returning @of $iterableB.hasSome $iterableA
            return
        fi

        local itemA
        while @iterate $iterableA @in itemA; do
            local itemB
            while @iterate $iterableB @in itemB; do
                if @same "${itemA}" "${itemB}"; then
                    @returning true
                    return
                fi
            done
        done
        @returning false
    }

    function Collections.frequency()
    {
        local iterable="${1}"
        local subjectItem="${2}"

        if @is $iterable @a Container; then
            @returning @of $iterable.frequency "${subjectItem}"
        else
            local frequency=0

            local candidateItem
            while @iterate $iterable @in candidateItem; do
                if @same "${candidateItem}" "${subjectItem}"; then
                  (( ++frequency ))
                fi
            done

            @returning "${frequency}"
        fi
    }

@classdone
