#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

main() {
  local -r script_folder="$(dirname "$(readlink --canonicalize "$0")")"
  cd "$(dirname "${script_folder}")"

  local -r image='evolutics/travel-kit:dirty'
  scripts/build.py "${image}"

  docker run --entrypoint sh --rm --volume "${PWD}":/workdir "${image}" -c \
    'git ls-files -z | xargs -0 travel-kit check --'

  docker run --rm --volume "${PWD}":/workdir "${image}" readme \
    | diff README.md -
}

main "$@"
