#!/usr/bin/env python3

import argparse

from . import cleaners
from . import readme
from . import run_cleaners


def main():
    cleaners_ = cleaners.get()

    parser = argparse.ArgumentParser()

    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--readme", action="store_true", help=argparse.SUPPRESS)
    parser.add_argument(
        "--skip",
        action="append",
        choices=cleaners_,
        default=[],
        help="Do not use this tool.",
    )
    parser.add_argument("file_paths", nargs="*")

    arguments = parser.parse_args()

    if arguments.readme:
        print(readme.get(cleaners_))
        return

    run_cleaners.get(
        cleaners={
            identifier: cleaner
            for identifier, cleaner in cleaners_.items()
            if identifier not in arguments.skip
        },
        is_dry_run=arguments.dry_run,
        file_paths=arguments.file_paths,
    )


if __name__ == "__main__":
    main()
