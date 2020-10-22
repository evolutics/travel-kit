#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

run_black() {
  git ls-files -z -- \
    '*.py' \
    '*.pyi' \
    | xargs -0 black
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
    | xargs -0 prettier --write
}

main() {
  local calls='
    run_black
    run_prettier
  '

  local exit_status=0
  for call in ${calls}; do
    if ! "${call}"; then
      exit_status=1
    fi
  done
  exit "${exit_status}"
}

main "$@"
