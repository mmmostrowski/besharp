#!/usr/bin/env bash

@internal @class ArrayMap @extends AssocArrayContainer @implements Map

    function ArrayMap()
    {
        @parent
    }

    function ArrayMap.set()
    {
        local key="${1}"
        local item="${2}"

        eval "${this}[\"\${key}\"]=\"\${item}\""
    }

    function ArrayMap.setPlainPairs()
    {
        if (( $# == 0 )); then
            $this.removeAll
            return
        fi

        if (( ( $# % 2 ) != 0 )); then
            besharp.runtime.error "setPlainPars has got an odd number of elements. Expected pairs!"
            return
        fi

        local key
        local item
        local isEven=true
        for item in "${@}"; do
            if $isEven; then
                isEven=false
                key="${item}"
            else
                isEven=true
                eval "${this}[\"\${key}\"]=\"\${item}\""
            fi
        done
    }

    function ArrayMap.hasKey()
    {
        local key="${1}"

        local isset
        eval "isset=\${${this}[\"${key}\"]+isset}"
        if [[ "${isset}" == 'isset' ]]; then
            @returning true
        else
            @returning false
        fi
    }

    function ArrayMap.findAllKeys()
    {
        local item="${1}"

        @let resultCollection = @new ArrayVector
        @returning $resultCollection

        local var="${this}[@]"
        if [[ "${!var+isset}" != "isset" ]]; then
            return
        fi

        local temp
        declare -n temp="${this}"
        local key
        for key in "${!temp[@]}"; do
            if @same "${temp[$key]}" "${item}"; then
                $resultCollection.add "${key}"
            fi
        done
    }

    function ArrayMap.remove()
    {
        local item="${1}"

        local var="${this}[@]"
        if [[ "${!var+isset}" != "isset" ]]; then
            @returning false
            return
        fi

        local temp
        declare -n temp="${this}"
        local anyRemoved=false
        local key
        for key in "${!temp[@]}"; do
            if @same "${temp[$key]}" "${item}"; then
                $this.removeKey "${key}"
                anyRemoved=true
            fi
        done

        @returning $anyRemoved
    }

    function ArrayMap.removeKey()
    {
        local key="${1}"

        unset "${this}[${key}]"
    }

    function ArrayMap.removeKeys()
    {
        local item
        while @iterate "${@}" @in item; do
            $this.removeKey "${item}"
        done
    }

    function ArrayMap.hasSomeKeys()
    {
        local key
        while @iterate "${@}" @in key; do
            local isset
            eval "isset=\"\${${this}[${key}]+isset}\""
            if [[ "${isset}" == 'isset' ]]; then
                @returning true
                return
            fi
        done

        @returning false
    }

    function ArrayMap.hasAllKeys()
    {
        local key
        while @iterate "${@}" @in key; do
            local isset
            eval "isset=\"\${${this}[${key}]+isset}\""
            if [[ "${isset}" != 'isset' ]]; then
                @returning false
                return
            fi
        done

        @returning true
    }

    function ArrayMap.swapKeys()
    {
        $this.swapElements "${@}"
    }

@classdone