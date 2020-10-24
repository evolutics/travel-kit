#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

main() {
  local -r script_folder="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local -r project_folder="$(dirname "${script_folder}")"

  pushd "${project_folder}"

  local -r image='evolutics/travel-kit:dirty'
  DOCKERFILE_PATH=Dockerfile IMAGE_NAME="${image}" hooks/build

  docker run --rm --volume "$(pwd)":/workdir "${image}" check

  popd
}

main "$@"
