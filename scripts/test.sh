#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

main() {
  local -r script_folder="$(dirname "$(readlink --canonicalize "$0")")"
  cd "$(dirname "${script_folder}")"

  nix flake check

  git ls-files -z | xargs -0 nix run . -- check --

  nix run . -- readme | diff README.md -

  git rm --force flake.lock

  (
    cd example
    nix flake check
    nix develop . --command travel-kit --help
    git rm --force flake.lock
  )
}

main "$@"
