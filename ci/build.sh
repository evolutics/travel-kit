#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

main() {
  local -r script_folder="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local -r project_folder="$(dirname "${script_folder}")"

  pushd "${project_folder}"

  local -r base_image="$(docker build \
    --build-arg git=2.26.2 \
    --quiet \
    https://github.com/evolutics/code-cleaner-buffet.git#0.11.0)"

  local -r main_image="$(docker build --build-arg base_image="${base_image}" \
    --quiet .)"

  docker run --rm --volume "$(pwd)":/workdir "${main_image}"

  popd
}

main "$@"
