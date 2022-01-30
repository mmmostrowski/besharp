#!/usr/bin/env bash


@internal @class ArrayIteration

    function ArrayIteration()
    {
      :
    }

    function ArrayIteration.iterationNew()
    {
        # local source="${1}"

        local stackLvl=$(( besharp_rcsl - 1 ))

        if eval "[[ -z \${!${1}[@]} ]]"; then
            @returning ''
        else
            local varName="${this}_system_iterator_${stackLvl}_${__besharp_iterator_position_in_a_method}"
            eval "${varName}=( \"\${!${1}[@]}\" )"
            eval "besharp_runtime_current_iterator__stack_${stackLvl}[${__besharp_iterator_position_in_a_method}]=\${varName}"
            @returning 0
        fi
    }

    function ArrayIteration.reversedIterationNew()
    {
        # local source="${1}"

        local stackLvl=$(( besharp_rcsl - 1 ))

        if eval "[[ -z \${!${1}[@]} ]]"; then
            @returning ''
        else
            local varName="${this}_system_iterator_${stackLvl}_${__besharp_iterator_position_in_a_method}"
            eval "${varName}=( \"\${!${1}[@]}\" )"
            eval "besharp_runtime_current_iterator__stack_${stackLvl}[${__besharp_iterator_position_in_a_method}]=\${varName}"

            local size
            eval "size=\${#${varName}[@]}"

            @returning $(( size - 1 ))
        fi
    }

    function ArrayIteration.iterationKey()
    {
        # local source="${1}"
        # local idx="${2}"

        local varName="${this}_system_iterator_$(( besharp_rcsl - 1 ))_${__besharp_iterator_position_in_a_method}"
        local key
        eval "key=\"\${${varName}[\"${2}\"]}\""
        @returning "${key}"
    }

    function ArrayIteration.iterationValue()
    {
        # local source="${1}"
        # local idx="${2}"

        local varName="${this}_system_iterator_$(( besharp_rcsl - 1 ))_${__besharp_iterator_position_in_a_method}"
        local idx
        eval "idx=\"\${${varName}[\"${2}\"]}\""
        local value
        eval "value=\"\${${1}[${idx}]}\""
        @returning "${value}"
    }

    function ArrayIteration.iterationNext()
    {
        # local source="${1}"
        # local idx="${2}"

        local varName="${this}_system_iterator_$(( besharp_rcsl - 1 ))_${__besharp_iterator_position_in_a_method}"

        local size
        eval "size=\${#${varName}[@]}"

        if (( $2 < size - 1 )); then
            @returning $(( $2 + 1 ))
        else
            @returning ''
        fi
    }

    function ArrayIteration.reversedIterationNext()
    {
        # local source="${1}"
        # local idx="${2}"

        local varName="${this}_system_iterator_$(( besharp_rcsl - 1 ))_${__besharp_iterator_position_in_a_method}"

        if (( $2 > 0 )); then
            @returning $(( $2 - 1 ))
        else
            @returning ''
        fi
    }

@classdone