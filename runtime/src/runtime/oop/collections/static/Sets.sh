#!/usr/bin/env bash

@static { @sets }
@internal @class Sets \

    @var Set empty

    function Sets()
    {
        @let $this.empty = @new EmptySet
    }

    function Sets.single()
    {
        local item="${1}"

        @returning @of @new ImmutableSet "${item}"
    }

    function Sets.make()
    {
        @let set = @new ArraySet

        $set.addMany @array "${@}"

        @returning $set
    }

    function Sets.makeOf()
    {
        local iterable="${1}"

        @let set = @new ArraySet

        $set.addMany @iterable "${iterable}"

        @returning $set
    }

    function Sets.makeImmutable()
    {
        @returning @of @new ImmutableSet "${@}"
    }

    function Sets.makeImmutableOf()
    {
        local iterable="${1}"

        local items=()
        local item
        while @iterate $iterable @in item; do
            items+=( "${item}" )
        done

        @returning @of @new ImmutableSet "${items[@]}"
    }

    function Sets.cloneTo()
    {
        local targetSet="${1}"
        local sourceIterable="${2}"

        if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetSet}" )" ]]; then
            @clone @to ${targetSet} shallow $sourceIterable
            return
        fi

        $targetSet.removeAll
        $targetSet.addMany $sourceIterable
    }

    function Sets.copyTo()
    {
        local targetSet="${1}"
        local sourceIterable="${2}"

        $targetSet.addMany $sourceIterable
    }

    function Sets.join()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.joinTo $result "${@}"

        @returning $result
    }

    function Sets.joinTo()
    {
        local targetSet="${1}"
        shift 1

        local iterable
        for iterable in "${@}"; do
             if @is $iterable @a PrimitiveObject && @is $iterable @a Set; then
                  local temp
                  declare -n temp="${iterable}"
                  local key
                  for key in "${!temp[@]}"; do
                      eval "${targetSet}[\"\${key}\"]=\"\${${iterable}[\"\${key}\"]}\""
                  done
              else
                  $targetSet.addMany $iterable
              fi
        done
    }

    function Sets.intersect()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.intersectTo $result "${@}"

        @returning $result
    }

    function Sets.intersectTo()
    {
        local targetSet="${1}"
        shift 1

        local allPrimitiveSets=true
        for iterable in "${@}"; do
            if ! @is $iterable @a Set || ! @is $iterable @a PrimitiveObject; then
                allPrimitiveSets=false
                break
            fi
        done

        if $allPrimitiveSets; then
            local targetItem
            local iterable
            local objectId
            while @iterate $targetSet @in targetItem; do
                for iterable in "${@}"; do
                    @let objectId = @object-id $targetItem
                    eval "if [[ \"\${${iterable}[\"\$objectId\"]+isset}\" == isset ]]; then continue; fi"

                    $targetSet.remove "${targetItem}"
                done
            done
            return
        fi

        local targetItem
        while @iterate $targetSet @in targetItem; do
            local iterable
            for iterable in "${@}"; do
                if @is $iterable @a Set; then
                    if @is $iterable @a PrimitiveObject; then
                        @let objectId = @object-id $targetItem
                        eval "if [[ \"\${${iterable}[\"\$objectId\"]+isset}\" == isset ]]; then continue; fi"
                    else
                        if @true $iterable.has $targetItem; then
                            continue
                        fi
                    fi
                else
                    local item
                    @; while @iterate $iterable @in item; do
                        if @same "${targetItem}" "${item}"; then
                            continue 2
                        fi
                    done
                fi

                $targetSet.remove "${targetItem}"
            done
        done
    }

    function Sets.subtract()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.subtractTo $result "${@}"

        @returning $result
    }

    function Sets.subtractTo()
    {
        local targetSet="${1}"
        shift 1

        local allPrimitiveSets=true
        for iterable in "${@}"; do
            if ! @is $iterable @a Set || ! @is $iterable @a PrimitiveObject; then
                allPrimitiveSets=false
                break
            fi
        done

        if $allPrimitiveSets; then
            local targetItem
            local iterable
            local objectId
            while @iterate $targetSet @in targetItem; do
                for iterable in "${@}"; do
                    @let objectId = @object-id $targetItem
                    eval "if [[ \"\${${iterable}[\"\$objectId\"]+isset}\" == isset ]]; then \
                      \$targetSet.remove "\${targetItem}"; continue 2; fi"
                done
            done
            return
        fi

        local targetItem
        while @iterate $targetSet @in targetItem; do
            local iterable
            for iterable in "${@}"; do
                if @is $iterable @a Set; then
                    if @is $iterable @a PrimitiveObject; then
                        @let objectId = @object-id $targetItem
                        eval "if [[ \"\${${iterable}[\"\$objectId\"]+isset}\" == isset ]]; then \
                            \$targetSet.remove "\${targetItem}"; continue 2; fi"
                    else
                        if @true $iterable.has $targetItem; then
                            $targetSet.remove "${targetItem}"
                            continue 2
                        fi
                    fi
                else
                    local item
                    @; while @iterate $iterable @in item; do
                        if @same "${targetItem}" "${item}"; then
                            $targetSet.remove "${targetItem}"
                            continue 3
                        fi
                    done
                fi
            done
        done
    }

@classdone
