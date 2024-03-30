#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

check_basics() {
  nix flake check
  git ls-files -z -- ':!:test/cases/' | xargs -0 nix run . -- check --
  nix run . -- readme | diff README.md -
}

test_cleaner_command_constructions() {
  (
    cd test/cases

    for subcommand in check fix; do
      nix run ../.. -- "${subcommand}" --dry-run -- * \
        | sed 's: /\S* : … :g' \
        | diff "../expected/${subcommand}.txt" -
    done
  )
}

test_cleaners() {
  local -r status="$(git status --porcelain test/cases)"
  if [[ -n "${status}" ]]; then
    >&2 echo "${status}"
    exit 1
  fi

  local actual_output
  actual_output="$(nix run . check test/cases/* 2>&1)" && exit 1
  readonly actual_output

  for lint in test/lints/*; do
    readarray -t expected_lines < <(cat "${lint}")
    for expected_line in "${expected_lines[@]}"; do
      if ! echo "${actual_output}" \
        | grep --fixed-strings --quiet "${expected_line}"; then
        >&2 echo "${lint}: ${expected_line}"
        exit 1
      fi
    done
  done

  nix run . fix test/cases/*

  local -r delta="$(diff --recursive test/fixed test/cases)"
  if [[ "${delta}" != "Only in test/cases: git
Only in test/cases: gitlint
Only in test/cases: hadolint.Dockerfile
Only in test/cases: html5validator.htm
Only in test/cases: htmlhint.htm
Only in test/cases: jsonnet_lint.jsonnet
Only in test/cases: pylint.py
Only in test/cases: shellcheck.sh
Only in test/cases: stylelint.css" ]]; then
    >&2 echo "${delta}"
    exit 1
  fi

  git restore test/cases
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
  test_cleaner_command_constructions
  test_cleaners
  git rm --force flake.lock

  sanity_check_example_integration
}

main "$@"
