#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

run_prettier() {
  git ls-files -z -- '*.md' | xargs -0 prettier --write
}

main() {
  run_prettier
}

main "$@"
