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

test_cleaner_command_constructions() {
  (
    cd test/cases
    rm --force -- *

    touch \
      alejandra.nix \
      black.py \
      git \
      gitlint \
      hadolint.Dockerfile \
      html5validator.css \
      htmlhint.htm \
      jsonnet_lint.jsonnet \
      jsonnetfmt.jsonnet \
      prettier.css \
      pylint.py \
      shellcheck.sh \
      shfmt.sh \
      stylelint.css

    for subcommand in check fix; do
      nix run ../.. -- "${subcommand}" --dry-run -- * \
        | sed 's: /\S* : … :g' \
        | diff "../expected/${subcommand}.txt" -
    done
  )
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
  test_cleaner_command_constructions
  git rm --force flake.lock

  sanity_check_example_integration
}

main "$@"
