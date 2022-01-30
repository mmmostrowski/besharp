#!/usr/bin/env bash

set -eu

function main() {
    echo 'BeSharp by Maciej Ostrowski (c) 2022'
    echo '--'

    case "$( cat /besharp-docker-deploy-mode )" in
       'deploy-framework')
            "${@}"
          ;;
        'deploy-app')
            "/besharp/app/dist/$( cat /besharp/build/default.preset )/app" "${@}"
          ;;
        *)
          echo "Unknown preset in /besharp/docker/deploy-preset!" >&2
          return 1
          ;;
    esac
}
main "${@}"