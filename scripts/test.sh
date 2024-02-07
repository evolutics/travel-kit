#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

check_basics() {
  nix flake check
  git ls-files -z | xargs -0 nix run . -- check --
  nix run . -- readme | diff README.md -
}

sanity_check_example_integration() {
  (
    cd example
    nix flake check
    nix develop . --command travel-kit --help
    git rm --force flake.lock
  )
}

main() {
  local -r script_folder="$(dirname "$(readlink --canonicalize "$0")")"
  cd "$(dirname "${script_folder}")"

  check_basics
  git rm --force flake.lock

  sanity_check_example_integration
}

main "$@"
