#!/usr/bin/env bash

function @class() {
    :
}

function @static() {
    :
}

function @classdone() {
    :
}

function @interface() {
    :
}

function @intdone() {
    :
}

function @var() {
    :
}

function @abstract() {
    :
}

function @internal() {
    :
}

if ! type -t "@bind" > /dev/null 2> /dev/null ; then
  function @bind() {
      :
  }
fi