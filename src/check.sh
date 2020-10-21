#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

run_git() {
  git diff --check HEAD^
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
  run_git
  run_hunspell
  run_prettier
}

main "$@"
