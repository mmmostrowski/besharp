#!/usr/bin/env bash

@static { @lists }
@internal @class Lists

    @var List empty

    function Lists()
    {
        @let $this.empty = @new EmptyVector
    }

    function Lists.single()
    {
        local item="${1}"

        @returning @of @new ImmutableList "${item}"
    }

    function Lists.nCopies()
    {
        @returning @of @vectors.nCopies "${@}"
    }

    function Lists.make()
    {
        @let list = @new ArrayList

        $list.addMany @array "${@}"

        @returning $list
    }

    function Lists.makeOf()
    {
        local iterable="${1}"

        if @is $iterable @exact ArrayList; then
            @returning @of @clone shallow $iterable
            return
        fi

        @let list = @new ArrayList

        if @is $iterable List; then
            local key
            while @iterate @of $iterable.keys @in key; do
                @let value = $iterable.get "${key}"

                $list.set "${key}" "${value}"
            done
            @returning $list
            return
        fi

        $list.addMany @iterable "${iterable}"
        @returning $list
    }

    function Lists.makeImmutable()
    {
        @returning @of @new ImmutableList "${@}"
    }

    function Lists.makeImmutableOf()
    {
        local iterable="${1}"

        @let immutable = @new ImmutableList

        $this.cloneTo $immutable $iterable

        @returning $immutable
    }

    function Lists.cloneTo()
    {
        local targetList="${1}"
        local sourceIterable="${2}"

        if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetList}" )" ]]; then
            @clone @to ${targetList} shallow $sourceIterable
            return
        fi

        $targetList.removeAll
        $this.copyTo $targetList $sourceIterable
    }

    function Lists.copyTo()
    {
        local targetList="${1}"
        local sourceIterable="${2}"

        if @is $sourceIterable @a PrimitiveObject; then
            if @is $sourceIterable @a List; then
                local source
                declare -n source=$sourceIterable
                local idx
                for idx in "${!source[@]}"; do
                    eval "${targetList}[\"\${idx}\"]=\"\${source[\"\${idx}\"]}\""
                done

                return
            fi

            if @is $sourceIterable @a Set \
                || @is $sourceIterable @a Map \
            ; then
                eval "${targetList}+=( \"\${${sourceIterable}[@]}\" )"
                return
            fi
        fi

        if @is $sourceIterable @a List; then
            local key
            while @iterate @of $sourceIterable.keys @in key; do
                @let value = $sourceIterable.get "${key}"
                $targetList.set "${key}" "${value}"
            done
            return
        fi

        $targetList.addMany $sourceIterable
    }

    function Lists.overlay()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.overlayTo $result "${@}"

        @returning $result
    }

    function Lists.overlayTo()
    {
        local targetList="${1}"
        shift 1

        local iterable
        for iterable in "${@}"; do
            $this.copyTo $targetList $iterable
        done
    }

    function Lists.join()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.joinTo $result "${@}"

        @returning $result
    }

    function Lists.joinTo()
    {
        local targetList="${1}"
        shift 1

        local iterable
        for iterable in "${@}"; do
             if @is $iterable @a PrimitiveObject \
                  && ( @is $iterable @a List \
                      || @is $iterable @a Set \
                      || @is $iterable @a Map ) \
              ; then
                  eval "${targetList}+=( \"\${${iterable}[@]}\" )"
              else
                  $targetList.addMany $iterable
              fi
        done
    }

    function Lists.intersect()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.intersectTo $result "${@}"

        @returning $result
    }

    function Lists.intersectTo()
    {
        local targetList="${1}"
        shift 1

        local targetIdx
        while @iterate @of $targetList.indices @in targetIdx; do
            @let targetValue = $targetList.get "${targetIdx}"

            local iterable
            for iterable in "${@}"; do
                if @true @collections.has $iterable "${targetValue}"; then
                    continue
                fi

                $targetList.removeIndex "${targetIdx}"
                break
            done
        done
    }

    function Lists.subtract()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.subtractTo $result "${@}"

        @returning $result
    }

    function Lists.subtractTo()
    {
        local targetList="${1}"
        shift 1

        local targetIdx
        while @iterate @of $targetList.indices @in targetIdx; do
            @let targetValue = $targetList.get "${targetIdx}"

            local iterable
            for iterable in "${@}"; do
                if @true @collections.has "${iterable}" "${targetValue}"; then
                    $targetList.removeIndex "${targetIdx}"
                    break
                fi
            done
        done
    }

    function Lists.slice()
    {
        local list="${1}"
        local indexA="${2}"
        local indexB="${3}"

        @let result = @new ArrayList

        $this.sliceTo $result "${@}"

        @returning $result
    }

    function Lists.sliceTo()
    {
        local targetList="${1}"
        local list="${2}"
        local indexA="${3}"
        local indexB="${4}"

        @let sourceSize = $list.size

        if (( sourceSize == 0 )); then
            besharp.runtime.error "You cannot slice an empty vector!"
        fi

        if (( indexA < 0 )) || (( indexA >= sourceSize )) \
              || (( indexB < 0 )) || (( indexB >= sourceSize )) \
        ; then
            besharp.runtime.error "Invalid range for Lists.slice! Expected: [ 0 - $(( sourceSize - 1 )) ]. Got: [ ${indexA} - ${indexB} ]."
        fi

        if (( indexA > indexB )); then
            local tmpIndex="${indexA}"
            indexA="${indexB}"
            indexB="${tmpIndex}"
        fi

        if @is $targetList @a Vector; then

            if @is $targetList @a PrimitiveObject \
                && @is $list @a PrimitiveObject;
            then
                eval "${targetList}=()"

                local source
                declare -n source=$list
                local idx
                for idx in "${!source[@]}"; do
                    if (( idx >= indexA )) && (( idx <= indexB )); then
                        eval "${targetList}+=(\"\${$list[\"\${idx}\"]}\")"
                    fi
                done

                return
            fi

            $targetList.removeAll

            local idx
            local value
            while @iterate @of $list.indices @in idx; do
                if (( idx >= indexA )) && (( idx <= indexB )); then
                    @let value = $list.get "${idx}"

                    $targetList.add "${value}"
                fi
            done

            return
        fi

        if @is $targetList @a PrimitiveObject \
            && @is $list @a PrimitiveObject;
        then
            eval "${targetList}=()"

            local source
            declare -n source=$list
            local idx
            for idx in "${!source[@]}"; do
                if (( idx >= indexA )) && (( idx <= indexB )); then
                    eval "${targetList}[\"\${idx}\"]=\"\${$list[\"\${idx}\"]}\""
                fi
            done

            return
        fi

        $targetList.removeAll

        local idx
        local value
        while @iterate @of $list.indices @in idx; do
            if (( idx >= indexA )) && (( idx <= indexB )); then
                @let value = $list.get "${idx}"

                $targetList.set "${idx}" "${value}"
            fi
        done
    }


@classdone
