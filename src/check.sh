#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

run_black() {
  git ls-files -z -- \
    '*.py' \
    '*.pyi' \
    | xargs -0 black --check --diff
}

run_git() {
  git diff --check HEAD^
}

run_gitlint() {
  gitlint --ignore body-is-missing
}

run_hadolint() {
  git ls-files -z -- \
    '*.Dockerfile' \
    '*/Dockerfile' \
    Dockerfile \
    | xargs -0 hadolint
}

run_hunspell() {
  git log -1 --format=%B | hunspell -l -d en_US -p ci/personal_words.dic \
    | sort | uniq | tr '\n' '\0' | xargs -0 -r -n 1 sh -c \
    'echo "Misspelling: $@"; exit 1' --
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
  local calls='
    run_black
    run_git
    run_gitlint
    run_hadolint
    run_hunspell
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
