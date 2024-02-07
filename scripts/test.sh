#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

check_basics() {
  nix flake check
  git ls-files -z | xargs -0 nix run . -- check --
  nix run . -- readme | diff README.md -
}

test_cleaner_sample_runs() {
  echo '{"hi" :5 }' >sample.json
  nix run . -- check sample.json && exit 1
  nix run . -- fix sample.json
  nix run . -- check sample.json
  rm sample.json
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
  test_cleaner_sample_runs
  git rm --force flake.lock

  sanity_check_example_integration
}

main "$@"
