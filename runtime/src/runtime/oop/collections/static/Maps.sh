#!/usr/bin/env bash

@static { @maps }
@internal @class Maps \

    @var Map empty

    function Maps()
    {
        @let $this.empty = @new EmptyMap
    }

    function Maps.single()
    {
        local key="${1}"
        local value="${2}"

        @returning @of @new ImmutableMap "${key}" "${value}"
    }

    function Maps.make()
    {
        @let map = @new ArrayMap

        $map.setPlainPairs "${@}"

        @returning $map
    }

    function Maps.makeOf()
    {
        local iterableByKeys="${1}"

        @let map = @new ArrayMap

        local key
        while @iterate @of $iterableByKeys.keys @in key; do
            @let value = $iterableByKeys.get "${key}"

            $map.set "${key}" "${value}"
        done

        @returning $map
    }

    function Maps.makeImmutable()
    {
        @returning @of @new ImmutableMap "${@}"
    }

    function Maps.makeImmutableOf()
    {
        local iterable="${1}"

        @let immutable = @new ImmutableMap

        $this.cloneTo $immutable $iterable

        @returning $immutable
    }

    function Maps.cloneTo()
    {
        local targetMap="${1}"
        local sourceIterable="${2}"

        if [[ "$( besharp.rtti.objectType "${sourceIterable}" )" == "$( besharp.rtti.objectType "${targetMap}" )" ]]; then
            @clone @to ${targetMap} shallow $sourceIterable
            return
        fi

        $targetMap.removeAll
        $this.copyTo $targetMap $sourceIterable
    }

    function Maps.copyTo()
    {
        local targetMap="${1}"
        local sourceIterable="${2}"

        if @is $sourceIterable @a PrimitiveObject; then
            local source
            declare -n source=$sourceIterable
            local key
            for key in "${!source[@]}"; do
                eval "${targetMap}[\"\${key}\"]=\"\${source[\"\${key}\"]}\""
            done

            return
        fi

        local key
        while @iterate @of $sourceIterable.keys @in key; do
            @let value = $sourceIterable.get "${key}"
            $targetMap.set "${key}" "${value}"
        done
    }

    function Maps.overlay()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.overlayTo $result "${@}"

        @returning $result
    }

    function Maps.overlayTo()
    {
        local targetMap="${1}"
        shift 1

        local iterableByKeys
        for iterableByKeys in "${@}"; do
            $this.copyTo $targetMap $iterableByKeys
        done
    }

    function Maps.intersect()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.intersectTo $result "${@}"

        @returning $result
    }

    function Maps.intersectTo()
    {
        local targetMap="${1}"
        shift 1

        local allPrimitiveMaps=true
        for iterableByKeys in "${@}"; do
            if ! @is $iterableByKeys @a PrimitiveObject || ! @is $iterableByKeys @a Map; then
                allPrimitiveMaps=false
                break
            fi
        done

        if $allPrimitiveMaps; then
            local targetKey
            local iterable
            while @iterate @of $targetMap.keys @in targetKey; do
                for iterable in "${@}"; do

                    eval "if [[ \"\${${iterable}[\"\$targetKey\"]+isset}\" == isset ]] \
                      && [[ \"\${${targetMap}[\"\$targetKey\"]+isset}\" == isset ]] \
                      && [[ \"\${${iterable}[\"\$targetKey\"]}\" == \"\${${targetMap}[\"\$targetKey\"]}\" ]]; then continue; fi"

                    $targetMap.removeKey "${targetKey}"
                done
            done
            return
        fi

        local targetKey
        while @iterate @of $targetMap.keys @in targetKey; do
            @let targetValue = $targetMap.get "${targetKey}"

            local iterable
            for iterable in "${@}"; do
                if @true $iterable.hasKey "${targetKey}"; then
                    @let iterableValue = $iterable.get "${targetKey}"

                    if [[ "${iterableValue}" == "${targetValue}" ]]; then
                        continue
                    fi
                fi

                $targetMap.removeKey "${targetKey}"
                break
            done
        done
    }

    function Maps.intersectKeys()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.intersectKeysTo $result "${@}"

        @returning $result
    }

    function Maps.intersectKeysTo()
    {
        local targetMap="${1}"
        shift 1

        local targetKey
        while @iterate @of $targetMap.keys @in targetKey; do
            local iterable
            for iterable in "${@}"; do
                if ! @true @collections.has $iterable "${targetKey}"; then
                    $targetMap.removeKey "${targetKey}"
                    break
                fi
            done
        done
    }

    function Maps.intersectValues()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.intersectValuesTo $result "${@}"

        @returning $result
    }

    function Maps.intersectValuesTo()
    {
        local targetMap="${1}"
        shift 1

        local targetKey
        local targetValue
        while @iterate @of $targetMap.keys @in targetKey; do
            @let targetValue = $targetMap.get "${targetKey}"

            local iterable
            for iterable in "${@}"; do
                if ! @true @collections.has $iterable "${targetValue}"; then
                    $targetMap.removeKey "${targetKey}"
                    break
                fi
            done
        done
    }

    function Maps.subtract()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.subtractTo $result "${@}"

        @returning $result
    }

    function Maps.subtractTo()
    {
        local targetMap="${1}"
        shift 1

        local iterableByKeys
        local allPrimitiveMaps=true
        for iterableByKeys in "${@}"; do
            if ! @is $iterableByKeys @a PrimitiveObject || ! @is $iterableByKeys @a Map; then
                allPrimitiveMaps=false
                break
            fi
        done

        if $allPrimitiveMaps; then
            local targetKey
            while @iterate @of $targetMap.keys @in targetKey; do
                for iterableByKeys in "${@}"; do
                    eval "if [[ \"\${${iterableByKeys}[\"\$targetKey\"]+isset}\" == isset ]] \
                      && [[ \"\${${targetMap}[\"\$targetKey\"]+isset}\" == isset ]] \
                      && [[ \"\${${iterableByKeys}[\"\$targetKey\"]}\" == \"\${${targetMap}[\"\$targetKey\"]}\" ]]; then \
                          \$targetMap.removeKey "\${targetKey}" continue 2; fi"
                done
            done
            return
        fi

        local targetKey
        while @iterate @of $targetMap.keys @in targetKey; do
            for iterableByKeys in "${@}"; do
                if @true $iterableByKeys.hasKey "${targetKey}" && @true $targetMap.hasKey "${targetKey}"; then
                    @let iterableValue = $iterableByKeys.get "${targetKey}"
                    @let targetValue = $targetMap.get "${targetKey}"

                    if [[ "${iterableValue}" == "${targetValue}" ]]; then
                        $targetMap.removeKey "${targetKey}"
                        continue 2
                    fi
                fi
            done
        done
    }

    function Maps.subtractValues()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.subtractValuesTo $result "${@}"

        @returning $result
    }

    function Maps.subtractValuesTo()
    {
        local targetMap="${1}"
        shift 1

        local targetKey
        while @iterate @of $targetMap.keys @in targetKey; do
            @let targetValue = $targetMap.get "${targetKey}"

            local iterable
            for iterable in "${@}"; do
                if @true @collections.has "${iterable}" "${targetValue}"; then
                    $targetMap.removeKey "${targetKey}"
                    break
                fi
            done
        done
    }

    function Maps.subtractKeys()
    {
        local first="${1}"
        shift 1

        @let result = $this.makeOf $first

        $this.subtractKeysTo $result "${@}"

        @returning $result
    }

    function Maps.subtractKeysTo()
    {
        local targetMap="${1}"
        shift 1

        local targetKey
        while @iterate @of $targetMap.keys @in targetKey; do
            local iterable
            for iterable in "${@}"; do
                if @true @collections.has "${iterable}" "${targetKey}"; then
                    $targetMap.removeKey "${targetKey}"
                    break
                fi
            done
        done
    }

@classdone
