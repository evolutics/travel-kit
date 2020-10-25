import re

import model


def get():
    return {
        "Ansible Lint": _ansible_lint(),
        "Black": _black(),
        "Git": _git(),
        "Gitlint": _gitlint(),
        "Haskell Dockerfile Linter": _haskell_dockerfile_linter(),
        "Hunspell": _hunspell(),
        "Prettier": _prettier(),
        "Pylint": _pylint(),
    }


def _ansible_lint():
    return model.Cleaner(
        is_only_active_if_command=None,
        file_pattern=None,
        check="ansible-lint",
        fix=None,
    )


def _black():
    return model.Cleaner(
        is_only_active_if_command=None,
        file_pattern=re.compile(r"\.(py|pyi)$"),
        check="black --check --diff --",
        fix="black --",
    )


def _git():
    return model.Cleaner(
        is_only_active_if_command=_is_in_git_repository(),
        file_pattern=re.compile(""),
        check="git diff --check HEAD^ --",
        fix=None,
    )


def _is_in_git_repository():
    return "git rev-parse"


def _gitlint():
    return model.Cleaner(
        is_only_active_if_command=_is_in_git_repository(),
        file_pattern=None,
        check="gitlint --ignore body-is-missing",
        fix=None,
    )


def _haskell_dockerfile_linter():
    return model.Cleaner(
        is_only_active_if_command=None,
        file_pattern=re.compile(r"(^|\.)Dockerfile$"),
        check="hadolint --",
        fix=None,
    )


def _hunspell():
    return model.Cleaner(
        is_only_active_if_command=_is_in_git_repository(),
        file_pattern=None,
        check=(
            r"""git log -1 --format=%B \
  | hunspell -l -d en_US -p ci/personal_words.dic \
  | sort | uniq | tr '\n' '\0' | xargs -0 -r -n 1 sh -c \
  'echo "Misspelling: $@"; exit 1' --"""
        ),
        fix=None,
    )


def _prettier():
    return model.Cleaner(
        is_only_active_if_command=None,
        file_pattern=re.compile(r"\.(css|html|js|json|md|ts|yaml|yml)$"),
        check="prettier --check --",
        fix="prettier --write --",
    )


def _pylint():
    return model.Cleaner(
        is_only_active_if_command=None,
        file_pattern=re.compile(r"\.py$"),
        check="pylint --",
        fix=None,
    )
