#!/usr/bin/env bash

# assets and preset files
besharp.compiler.logBuilderSection "Copy assets"
besharp.builder.run cp -rf app/assets/. ${CURRENT_PRESET_DIST}
besharp.builder.run cp -rf ${CURRENT_PRESET_SRC}/files/. ${CURRENT_PRESET_DIST}

# app dist
besharp.compiler.logBuilderSection "Copy app"
besharp.builder.run rm -rf ${CURRENT_PRESET_DIST}/dist/
besharp.builder.run mkdir -p ${CURRENT_PRESET_DIST}/dist/
besharp.builder.run cp -rf app/dist/.compiled/. ${CURRENT_PRESET_DIST}/dist/

