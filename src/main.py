#!/usr/bin/env python3

import argparse
import dataclasses
import subprocess
import sys
import typing


def main():
    cleaners = _cleaners()

    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers()

    subparser = subparsers.add_parser("check")
    subparser.set_defaults(
        commands=[
            cleaner.check for cleaner in cleaners.values() if cleaner.check is not None
        ]
    )
    subparser = subparsers.add_parser("fix")
    subparser.set_defaults(
        commands=[
            cleaner.fix for cleaner in cleaners.values() if cleaner.fix is not None
        ]
    )

    arguments = parser.parse_args()

    exit_status = 0
    for command in arguments.commands:
        try:
            subprocess.run(command, check=True, shell=True)
        except subprocess.CalledProcessError:
            exit_status = 1
    sys.exit(exit_status)


@dataclasses.dataclass
class _Cleaner:
    check: typing.Optional[str]
    fix: typing.Optional[str]


def _cleaners():
    return {
        "Black": _Cleaner(
            check=_command_for_git_files("black --check --diff", ["*.py", "*.pyi"]),
            fix=_command_for_git_files("black", ["*.py", "*.pyi"]),
        ),
        "Git": _Cleaner(check="git diff --check HEAD^", fix=None),
        "Gitlint": _Cleaner(check="gitlint --ignore body-is-missing", fix=None),
        "Haskell Dockerfile Linter": _Cleaner(
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
        "Hunspell": _Cleaner(
            check=(
                "git log -1 --format=%B "
                "| hunspell -l -d en_US -p ci/personal_words.dic "
                "| sort | uniq | tr '\\n' '\\0' | xargs -0 -r -n 1 sh -c "
                """'echo "Misspelling: $@"; exit 1' --"""
            ),
            fix=None,
        ),
        "Prettier": _Cleaner(
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


if __name__ == "__main__":
    main()