#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

main() {
  local -r script_folder="$(dirname "$(readlink --canonicalize "$0")")"
  local -r project_folder="$(dirname "${script_folder}")"
  cd "${project_folder}"

  local -r image='evolutics/travel-kit:dirty'
  DOCKERFILE_PATH=Dockerfile IMAGE_NAME="${image}" hooks/build

  docker run --entrypoint sh --rm --volume "$(pwd)":/workdir "${image}" -c \
    'git ls-files -z | xargs -0 travel-kit check --'

  docker run --rm --volume "$(pwd)":/workdir "${image}" readme \
    | diff README.md -
}

main "$@"
