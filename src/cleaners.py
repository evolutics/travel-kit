import dataclasses
import typing


@dataclasses.dataclass
class Cleaner:
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
    file_patterns = [
        "*.py",
        "*.pyi",
    ]
    return Cleaner(
        check=_command_for_git_files("black --check --diff", file_patterns),
        fix=_command_for_git_files("black", file_patterns),
    )


def _command_for_git_files(command, file_patterns):
    raw_patterns = " ".join(f"'{pattern}'" for pattern in file_patterns)
    return f"git ls-files -z -- {raw_patterns} | xargs -0 {command}"


def _git():
    return Cleaner(check="git diff --check HEAD^", fix=None)


def _gitlint():
    return Cleaner(check="gitlint --ignore body-is-missing", fix=None)


def _haskell_dockerfile_linter():
    return Cleaner(
        check=_command_for_git_files(
            "hadolint",
            [
                "*.Dockerfile",
                "*/Dockerfile",
                "Dockerfile",
            ],
        ),
        fix=None,
    )


def _hunspell():
    return Cleaner(
        check=(
            "git log -1 --format=%B "
            "| hunspell -l -d en_US -p ci/personal_words.dic "
            "| sort | uniq | tr '\\n' '\\0' | xargs -0 -r -n 1 sh -c "
            """'echo "Misspelling: $@"; exit 1' --"""
        ),
        fix=None,
    )


def _prettier():
    file_patterns = [
        "*.css",
        "*.html",
        "*.js",
        "*.json",
        "*.md",
        "*.ts",
        "*.yaml",
        "*.yml",
    ]
    return Cleaner(
        check=_command_for_git_files("prettier --check", file_patterns),
        fix=_command_for_git_files("prettier --write", file_patterns),
    )
