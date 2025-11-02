#!/bin/bash

set -o errexit -o nounset -o pipefail

check_basics() {
  nix flake check
  git ls-files -z -- ':!:test/cases' | xargs -0 nix run . --
  nix run . -- --readme | diff <(sed '1,/^## Tools$/d' README.md) -
}

test_cleaner_calls() {
  (
    cd test/cases

    nix run ../.. -- --dry-run \
      | sed 's: /\S*/: /…/:g' \
      | diff '../expected_calls.txt' -
  )
}

test_cleaner_effects() {
  local -r status="$(git status --porcelain test/cases)"
  if [[ -n "${status}" ]]; then
    >&2 echo "${status}"
    exit 1
  fi

  local actual_output
  actual_output="$(cd test/cases && nix run ../.. 2>&1)" && exit 1
  readonly actual_output

  diff <(cd test/cases && git ls-files --modified) \
    <(cd test/fixed && git ls-files)

  local -r delta="$(diff --recursive test/cases test/fixed)"
  if [[ "${delta}" != "Only in test/cases: git
Only in test/cases: gitlint
Only in test/cases: golangci-lint.go
Only in test/cases: hadolint.Dockerfile
Only in test/cases: htmlhint.htm
Only in test/cases: jsonnet_lint.jsonnet
Only in test/cases: pylint.py
Only in test/cases: shellcheck.sh
Only in test/cases: stylelint.css" ]]; then
    >&2 echo "${delta}"
    exit 1
  fi

  git restore test/cases

  for lint in $(git ls-files test/lints); do
    readarray -t expected_lines < <(cat "${lint}")
    for expected_line in "${expected_lines[@]}"; do
      if ! echo "${actual_output}" \
        | grep --fixed-strings --quiet "${expected_line}"; then
        >&2 printf '%s\nExpected string in actual output above: %s\nFile:%s\n' \
          "${actual_output}" "${expected_line}" "${lint}"
        exit 1
      fi
    done
  done
}

sanity_check_example_integration() {
  (
    cd example
    trap 'git rm --force flake.lock' EXIT
    nix flake check
    nix develop . --command travel-kit --help
  )
}

main() {
  cd -- "$(dirname -- "$0")/.."

  (
    trap 'git rm --force flake.lock' EXIT
    check_basics
    test_cleaner_calls
    test_cleaner_effects
  )

  sanity_check_example_integration
}

main "$@"
