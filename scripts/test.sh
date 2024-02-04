#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

main() {
  local -r script_folder="$(dirname "$(readlink --canonicalize "$0")")"
  cd "$(dirname "${script_folder}")"

  git ls-files -z | xargs -0 nix develop ./example --command travel-kit check --

  nix develop ./example --command travel-kit readme | diff README.md -

  (
    cd example
    nix flake check
    nix develop . --command travel-kit --help
    git rm --force flake.lock
  )
}

main "$@"
