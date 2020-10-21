#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

run_git() {
  git diff --check HEAD^
}

main() {
  run_git
}

main "$@"
