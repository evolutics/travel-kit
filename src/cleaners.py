import argparse
import dataclasses
import subprocess
import sys
import typing


@dataclasses.dataclass
class Cleaner:
    check: typing.Optional[str]
    fix: typing.Optional[str]


def get():
    return {
        "Black": Cleaner(
            check=_command_for_git_files("black --check --diff", ["*.py", "*.pyi"]),
            fix=_command_for_git_files("black", ["*.py", "*.pyi"]),
        ),
        "Git": Cleaner(check="git diff --check HEAD^", fix=None),
        "Gitlint": Cleaner(check="gitlint --ignore body-is-missing", fix=None),
        "Haskell Dockerfile Linter": Cleaner(
            check=_command_for_git_files(
                "hadolint",
                [
                    "*.Dockerfile",
                    "*/Dockerfile",
                    "Dockerfile",
                ],
            ),
            fix=None,
        ),
        "Hunspell": Cleaner(
            check=(
                "git log -1 --format=%B "
                "| hunspell -l -d en_US -p ci/personal_words.dic "
                "| sort | uniq | tr '\\n' '\\0' | xargs -0 -r -n 1 sh -c "
                """'echo "Misspelling: $@"; exit 1' --"""
            ),
            fix=None,
        ),
        "Prettier": Cleaner(
            check=_command_for_git_files(
                "prettier --check",
                [
                    "*.css",
                    "*.html",
                    "*.js",
                    "*.json",
                    "*.md",
                    "*.ts",
                    "*.yaml",
                    "*.yml",
                ],
            ),
            fix=_command_for_git_files(
                "prettier --write",
                [
                    "*.css",
                    "*.html",
                    "*.js",
                    "*.json",
                    "*.md",
                    "*.ts",
                    "*.yaml",
                    "*.yml",
                ],
            ),
        ),
    }


def _command_for_git_files(command, file_patterns):
    raw_patterns = " ".join(f"'{pattern}'" for pattern in file_patterns)
    return f"git ls-files -z -- {raw_patterns} | xargs -0 {command}"
