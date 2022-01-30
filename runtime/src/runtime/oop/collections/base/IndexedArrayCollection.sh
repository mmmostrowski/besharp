#!/usr/bin/env bash

@abstract @internal @class IndexedArrayCollection @extends PrimitiveCollection

    function IndexedArrayCollection() {
        @parent
    }

    function IndexedArrayCollection.declarePrimitiveVariable()
    {
        declare -a "${this}"
    }

    function IndexedArrayCollection.destroyPrimitiveVariable()
    {
        unset "${this}"
    }

    function IndexedArrayCollection.hasIndex()
    {
        local index="${1}"

        if (( index < 0 )); then
            @returning false
            return
        fi

        local isset
        eval "isset=\${${this}[${index}]+isset}"
        if [[ "${isset}" == 'isset' ]]; then
            @returning true
        else
            @returning false
        fi
    }

    function IndexedArrayCollection.hasKey()
    {
        @returning @of $this.hasIndex "${@}"
    }

    function IndexedArrayCollection.indices()
    {
        local myself
        declare -n myself="${this}"

        @let indices = @new ArrayVector
        $indices.setPlain ${!myself[@]}

        @returning $indices
    }

    function IndexedArrayCollection.keys()
    {
        @returning @of $this.indices
    }

    function IndexedArrayCollection.add()
    {
        local item="${1}"

        eval "${this}+=( \"\${item}\" )"
    }

    function IndexedArrayCollection.remove()
    {
        local item="${1}"

        local var="${this}[@]"
        if [[ "${!var+isset}" != "isset" ]]; then
            @returning false
            return
        fi

        @returning false

        local temp
        declare -n temp="${this}"
        local idx
        for idx in "${!temp[@]}"; do
            if @same "${temp[$idx]}" "${item}"; then
                unset "${this}[${idx}]"
                @returning true
            fi
        done
    }

    function IndexedArrayCollection.swapIndices()
    {
        $this.swapElements "${@}"
    }

    function IndexedArrayCollection.rotate()
    {
        local distance="${1}"

        @let size = $this.size

        distance=$(( distance % size ))
        if (( distance < 0 )); then
            (( distance += size ))
        fi

        if (( distance == 0 )) || (( size < 2 )); then
            return
        fi

        local indices=()
        local values=()
        local position=0
        local temp
        declare -n temp="${this}"
        local idx
        for idx in "${!temp[@]}"; do
            eval "local value=\${${this}[\${idx}]}"

            indices+=( "${idx}" )
            if (( ++position <= distance )); then
                # 1. collect first n-th items
                values+=( "${value}" )
            else
                # 2. rotate other items directly by given distance
                local targetIdx=${indices[position - distance - 1]}
                eval "${this}[${targetIdx}]=\${${this}[${idx}]}"
            fi
        done

        local i
        for (( i=0; i < distance; ++i )); do
            # 3. put collected items at the end
            local targetIdx="${indices[size - distance + i]}"
            eval "${this}[${targetIdx}]=\${values[${i}]}"
        done
    }

    function IndexedArrayCollection.reverse()
    {
        @let size = $this.size

        if (( size < 2 )); then
            return
        fi

        local indices=()
        local temp
        declare -n temp="${this}"
        local idx
        for idx in "${!temp[@]}"; do
            indices+=( "${idx}" )
        done

        local idx1
        local idx2
        local tmpValue
        for idx in "${!indices[@]}"; do
            idx1="${indices[idx]}"
            idx2="${indices[size - 1 - idx]}"

            if (( idx1 >= idx2 )); then
                break
            fi

            eval "tmpValue=\"\${${this}[idx1]}\""
            eval "${this}[idx1]=\"\${${this}[idx2]}\""
            eval "${this}[idx2]=\"\${tmpValue}\""
        done
    }

@classdone