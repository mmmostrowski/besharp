#!/usr/bin/env bash

# assets and preset files
besharp.compiler.logBuilderSection "Copy assets"
besharp.builder.run cp -rf app/assets/. ${CURRENT_PRESET_DIST}
besharp.builder.run cp -rf ${CURRENT_PRESET_SRC}/files/. ${CURRENT_PRESET_DIST}

