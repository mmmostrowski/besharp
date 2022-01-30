#!/usr/bin/env bash

function besharp.oopRuntime.turnOnDevelopMode() {
    besharp.oopRuntime.disableCollectingDiBindings
    besharp.oopRuntime.addBootstrapTag develop
}
