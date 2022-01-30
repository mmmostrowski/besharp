#!/usr/bin/env bash

@internal @class PairingHeap @extends PrimitiveObject @implements PriorityQueue

    @var rootHeap
    @var maxNodeIndex=0
    @var comparatorCallback
    @var reversed

    function PairingHeap()
    {
        @parent

        local comparatorOrReverseFlag="${1:-min}"

        case "${comparatorOrReverseFlag}" in
          "min")
              $this.reversed = false
            ;;
          "false")
              $this.reversed = false
            ;;
          "max")
              $this.reversed = true
            ;;
          "true")
              $this.reversed = true
            ;;
          *)
              if @is "${comparatorOrReverseFlag}" FastComparator; then
                  @let $this.comparatorCallback = $comparator.fastCompareFunction
                  return
              elif @is "${comparatorOrReverseFlag}" Comparator; then
                  $this.comparatorCallback = $comparator.compare
                  return
              fi
              besharp.runtime.error "Unknown comparatorOrReverseFlag: ${comparatorOrReverseFlag}"
            ;;
        esac
    }

    function PairingHeap.add()
    {
        local element="${1}"

        if [[ "${2+isset}" == 'isset' ]]; then
            local value="${2}"
        else
            local value="${element}"
        fi

        if [[ "${element// /}" != "${element}" ]]; then
            besharp.runtime.error "Invalid element: '${element}' PairingHeap elements cannot have spaces. Please provide either an Comparable object or string with no spaces!"
        fi

        local comparatorVar="${this}_comparatorCallback"
        if [[ -z "${!comparatorVar}" ]]; then
            @let reversed = $this.reversed

            if [[ "${value}" =~ ^-?[0-9]+$ ]]; then
                @let comparator = @comparators.makeForNaturalOrderIntegers "${reversed}"
            elif @is "${value}" Comparable; then
                @let comparator = @comparators.makeForNaturalOrder "${reversed}"
            else
                besharp.runtime.error "Invalid value: '${value}'. PairingHeap values can only work with integer numbers and Comparable objects"
            fi

            @let $this.comparatorCallback = $comparator.fastCompareFunction
            @unset $comparator
        fi

        @let newHeap = $this.createEmptyHeapNode "${element}" "${value}"

        local rootHeapVar="${this}_rootHeap"
        eval "@let ${this}_rootHeap = $this.merge \"${!rootHeapVar:-}\" \"${newHeap}\""
    }

    function PairingHeap.merge()
    {
        local heapA="${1}"
        local heapB="${2}"

        if [[ -z "${heapA}" ]]; then
            @returning "${heapB}"
            return 0
        elif [[ -z "${heapB}" ]]; then
            @returning "${heapA}"
            return 0
        fi

        local valueA="${this}_value[${heapA}]"
        local valueB="${this}_value[${heapB}]"
        local comparatorVar="${this}_comparatorCallback"
        if eval "${!comparatorVar} \"${valueA}\" \"${valueB}\""; then
            if eval "[[ -z \"\${${this}_left_child[${heapA}]}\" ]]"; then
                eval "${this}_left_child[${heapA}]=\"${heapB}\""
            else
                eval "${this}_next_sibling[${heapB}]=\"\${${this}_left_child[${heapA}]}\""
                eval "${this}_left_child[${heapA}]=\"${heapB}\""
            fi
            @returning $heapA
        else
            if eval "[[ -z \"\${${this}_left_child[${heapB}]}\" ]]"; then
                eval "${this}_left_child[${heapB}]=\"${heapA}\""
            else
                eval "${this}_next_sibling[${heapA}]=\"\${${this}_left_child[${heapB}]}\""
                eval "${this}_left_child[${heapB}]=\"${heapA}\""
            fi
            @returning $heapB
        fi
    }

    function PairingHeap.min()
    {
        @let rootHeap = $this.rootHeap

        if [[ -z "${rootHeap}" ]]; then
            besharp.runtime.error "There are no elements on the heap!"
        fi

        eval "@returning \${${this}_element[${rootHeap}]}"
    }

    function PairingHeap.removeMin()
    {
        @let rootHeap = $this.rootHeap

        if [[ -z "${rootHeap}" ]]; then
            besharp.runtime.error "There are no elements on the heap!"
        fi

        local leftChild
        eval "leftChild=\${${this}_left_child[${rootHeap}]}"

        @let $this.rootHeap = $this.mergePairs "${leftChild}"

        $this.destroyHeapNode "${rootHeap}"
    }

    function PairingHeap.mergePairs()
    {
        local heap="${1}"

        if [[ -z "${heap}" ]] || eval "[[ -z \"\${${this}_next_sibling[${heap}]}\" ]]"; then
            @returning "${heap}"
        else
            local otherHeap
            eval "otherHeap=\"\${${this}_next_sibling[${heap}]}\""

            local newHeap
            eval "newHeap=\"\${${this}_next_sibling[${otherHeap}]}\""

            eval "${this}_next_sibling[${heap}]="
            eval "${this}_next_sibling[${otherHeap}]="

            @let firstTwoHeap = $this.merge "${heap}" "${otherHeap}"
            @let allTheRestHeap = $this.mergePairs "${newHeap}"

            @returning @of $this.merge "${firstTwoHeap}" "${allTheRestHeap}"
        fi
    }

    function PairingHeap.createEmptyHeapNode()
    {
        local element="${1}"
        local value="${2}"

        @let index = $this.maxNodeIndex
        (( ++index ))
        $this.maxNodeIndex = ${index}

        eval "${this}_element[${index}]=\"\${element}\""
        eval "${this}_value[${index}]=\"\${value}\""
        eval "${this}_left_child[${index}]="
        eval "${this}_next_sibling[${index}]="

        @returning "${index}"
    }

    function PairingHeap.destroyHeapNode()
    {
        local heap="${1}"

        unset "${this}_element[${heap}]"
        unset "${this}_value[${heap}]"
        unset "${this}_left_child[${heap}]"
        unset "${this}_next_sibling[${heap}]"
    }

    function PairingHeap.isEmpty()
    {
        local isset
        eval "isset=\${${this}_element[@]+isset}"
        if [[ "${isset}" == 'isset' ]]; then
            @returning false
        else
            @returning true
        fi
    }

    function PairingHeap.declarePrimitiveVariable()
    {
        declare -a "${this}_element"
        declare -a "${this}_value"
        declare -a "${this}_left_child"
        declare -a "${this}_next_sibling"
    }

    function PairingHeap.destroyPrimitiveVariable()
    {
        unset "${this}_element"
        unset "${this}_value"
        unset "${this}_left_child"
        unset "${this}_next_sibling"
    }

    function PairingHeap.show()
    {
        local var="${this}_element[@]"

        if [[ "${!var+isset}" != "isset" ]]; then
            echo "<EMPTY>"
            return
        fi

        local temp
        declare -n temp="${this}_element"
        local idx
        local element
        local value
        local leftChild
        local nextSibling
        for idx in "${!temp[@]}"; do
            eval "element=\"\${${this}_element[${idx}]}\""
            eval "value=\"\${${this}_value[${idx}]}\""
            eval "leftChild=\"\${${this}_left_child[${idx}]}\""
            eval "nextSibling=\"\${${this}_next_sibling[${idx}]}\""

            echo "| #${this} $(besharp.rtti.objectType "${this}") | ${idx} -> [ element: ${element} | value: ${value} | leftChild: ${leftChild} | nextSibling: ${nextSibling} ]"
        done

        echo "rootHeap: $( @echo $this.rootHeap )"
        echo "maxNodeIndex: $( @echo $this.maxNodeIndex )"
    }































    function PairingHeap.ownsItsItems()
    {
      :
    }

    function PairingHeap.isOwningItems()
    {
      :
    }

    function PairingHeap.addMany()
    {
      :
    }

    function PairingHeap.size()
    {
      :
    }

    function PairingHeap.has()
    {
      :
    }

    function PairingHeap.hasSome()
    {
      :
    }

    function PairingHeap.hasAll()
    {
      :
    }

    function PairingHeap.current()
    {
      :
    }

    function PairingHeap.pull()
    {
      :
    }

    function PairingHeap.fill()
    {
      :
    }

    function PairingHeap.shuffle()
    {
      :
    }

    function PairingHeap.replace()
    {
      :
    }

    function PairingHeap.replaceMany()
    {
      :
    }

    function PairingHeap.remove()
    {
      :
    }

    function PairingHeap.removeMany()
    {
      :
    }

    function PairingHeap.removeAll()
    {
      :
    }

    function PairingHeap.frequency()
    {
      :
    }

    function PairingHeap.iterationNew()
    {
        ArrayIteration.reversedIterationNew "${this}" "${@}"
    }

    function PairingHeap.iterationValue()
    {
        ArrayIteration.iterationValue "${this}" "${@}"
    }

    function PairingHeap.iterationNext()
    {
        ArrayIteration.reversedIterationNext "${this}" "${@}"
    }


@classdone