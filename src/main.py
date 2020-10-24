#!/usr/bin/env python3

import argparse
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers()

    subparser = subparsers.add_parser("check")
    subparser.set_defaults(
        calls=[
            _black_check,
            _git_check,
            _gitlint_check,
            _hadolint_check,
            _hunspell_check,
            _prettier_check,
        ]
    )
    subparser = subparsers.add_parser("fix")
    subparser.set_defaults(
        calls=[
            _black_fix,
            _prettier_fix,
        ]
    )

    arguments = parser.parse_args()

    exit_status = 0
    for call in arguments.calls:
        try:
            subprocess.run(call(), check=True, shell=True)
        except subprocess.CalledProcessError:
            exit_status = 1
    sys.exit(exit_status)


def _black_check():
    return "git ls-files -z -- '*.py' '*.pyi' | xargs -0 black --check --diff"


def _black_fix():
    return "git ls-files -z -- '*.py' '*.pyi' | xargs -0 black"


def _git_check():
    return "git diff --check HEAD^"


def _gitlint_check():
    return "gitlint --ignore body-is-missing"


def _hadolint_check():
    return (
        "git ls-files -z -- "
        "'*.Dockerfile' "
        "'*/Dockerfile' "
        "Dockerfile "
        "| xargs -0 hadolint"
    )


def _hunspell_check():
    return (
        "git log -1 --format=%B | hunspell -l -d en_US -p ci/personal_words.dic "
        "| sort | uniq | tr '\\n' '\\0' | xargs -0 -r -n 1 sh -c "
        """'echo "Misspelling: $@"; exit 1' --"""
    )


def _prettier_check():
    return (
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
    )


def _prettier_fix():
    return (
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
    )


if __name__ == "__main__":
    main()
