#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

black_check() {
  git ls-files -z -- \
    '*.py' \
    '*.pyi' \
    | xargs -0 black --check --diff
}

black_fix() {
  git ls-files -z -- \
    '*.py' \
    '*.pyi' \
    | xargs -0 black
}

git_check() {
  git diff --check HEAD^
}

gitlint_check() {
  gitlint --ignore body-is-missing
}

hadolint_check() {
  git ls-files -z -- \
    '*.Dockerfile' \
    '*/Dockerfile' \
    Dockerfile \
    | xargs -0 hadolint
}

hunspell_check() {
  git log -1 --format=%B | hunspell -l -d en_US -p ci/personal_words.dic \
    | sort | uniq | tr '\n' '\0' | xargs -0 -r -n 1 sh -c \
    'echo "Misspelling: $@"; exit 1' --
}

prettier_check() {
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

prettier_fix() {
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
  case "$1" in
    check)
      local calls='
        black_check
        git_check
        gitlint_check
        hadolint_check
        hunspell_check
        prettier_check
      '
      ;;
    fix)
      local calls='
        black_fix
        prettier_fix
      '
      ;;
  esac

  local exit_status=0
  for call in ${calls}; do
    if ! "${call}"; then
      exit_status=1
    fi
  done
  exit "${exit_status}"
}

main "$@"
