import dataclasses
import typing


@dataclasses.dataclass
class Cleaner:
    only_in_git_repository: bool
    file_patterns: typing.Optional[typing.Sequence[str]]
    check: typing.Optional[str]
    fix: typing.Optional[str]


def get():
    return {
        "Black": _black(),
        "Git": _git(),
        "Gitlint": _gitlint(),
        "Haskell Dockerfile Linter": _haskell_dockerfile_linter(),
        "Hunspell": _hunspell(),
        "Prettier": _prettier(),
    }


def _black():
    return Cleaner(
        only_in_git_repository=True,
        file_patterns=[
            "*.py",
            "*.pyi",
        ],
        check="black --check --diff",
        fix="black",
    )


def _git():
    return Cleaner(
        only_in_git_repository=True,
        file_patterns=None,
        check="git diff --check HEAD^",
        fix=None,
    )


def _gitlint():
    return Cleaner(
        only_in_git_repository=True,
        file_patterns=None,
        check="gitlint --ignore body-is-missing",
        fix=None,
    )


def _haskell_dockerfile_linter():
    return Cleaner(
        only_in_git_repository=True,
        file_patterns=[
            "*.Dockerfile",
            "*/Dockerfile",
            "Dockerfile",
        ],
        check="hadolint",
        fix=None,
    )


def _hunspell():
    return Cleaner(
        only_in_git_repository=True,
        file_patterns=None,
        check=(
            r"""git log -1 --format=%B \
  | hunspell -l -d en_US -p ci/personal_words.dic \
  | sort | uniq | tr '\n' '\0' | xargs -0 -r -n 1 sh -c \
  'echo "Misspelling: $@"; exit 1' --"""
        ),
        fix=None,
    )


def _prettier():
    return Cleaner(
        only_in_git_repository=True,
        file_patterns=[
            "*.css",
            "*.html",
            "*.js",
            "*.json",
            "*.md",
            "*.ts",
            "*.yaml",
            "*.yml",
        ],
        check="prettier --check",
        fix="prettier --write",
    )
