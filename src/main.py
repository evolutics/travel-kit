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
            check="git ls-files -z -- '*.py' '*.pyi' | xargs -0 black --check --diff",
            fix="git ls-files -z -- '*.py' '*.pyi' | xargs -0 black",
        ),
        "Git": _Cleaner(check="git diff --check HEAD^", fix=None),
        "Gitlint": _Cleaner(check="gitlint --ignore body-is-missing", fix=None),
        "Haskell Dockerfile Linter": _Cleaner(
            check=(
                "git ls-files -z -- "
                "'*.Dockerfile' "
                "'*/Dockerfile' "
                "Dockerfile "
                "| xargs -0 hadolint"
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
            check=(
                "git ls-files -z -- "
                "'*.css' "
                "'*.html' "
                "'*.js' "
                "'*.json' "
                "'*.md' "
                "'*.ts' "
                "'*.yaml' "
                "'*.yml' "
                "| xargs -0 prettier --check"
            ),
            fix=(
                "git ls-files -z -- "
                "'*.css' "
                "'*.html' "
                "'*.js' "
                "'*.json' "
                "'*.md' "
                "'*.ts' "
                "'*.yaml' "
                "'*.yml' "
                "| xargs -0 prettier --write"
            ),
        ),
    }


if __name__ == "__main__":
    main()
