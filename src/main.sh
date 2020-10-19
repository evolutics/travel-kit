#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

main() {
  "/opt/travel-kit/${1:-check}.sh"
}

main "$@"
