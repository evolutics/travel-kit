#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

run_git() {
  git diff --check HEAD^
}

run_prettier() {
  git ls-files -z -- \
    '*.css' \
    '*.html' \
    '*.js' \
    '*.json' \
    '*.md' \
    '*.ts' \
    '*.yaml' \
    '*.yml'\
    | xargs -0 prettier --check
}

main() {
  run_git
  run_prettier
}

main "$@"
