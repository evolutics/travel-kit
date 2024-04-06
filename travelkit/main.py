#!/usr/bin/env python3

from importlib import resources
import argparse
import json

from . import model
from . import readme
from . import run_cleaners


def main():
    cleaners = _get_cleaners()

    parser = argparse.ArgumentParser()

    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--readme", action="store_true", help=argparse.SUPPRESS)
    parser.add_argument(
        "--skip",
        action="append",
        choices=cleaners,
        default=[],
        help="Do not use this tool.",
    )
    parser.add_argument("file_paths", nargs="*")

    arguments = parser.parse_args()

    if arguments.readme:
        print(readme.get(cleaners))
        return

    run_cleaners.get(
        cleaners={
            identifier: cleaner
            for identifier, cleaner in cleaners.items()
            if identifier not in arguments.skip
        },
        is_dry_run=arguments.dry_run,
        file_paths=arguments.file_paths,
    )


def _get_cleaners():
    data_path = resources.files("travelkit").joinpath("cleaners.json")
    with data_path.open("br") as data_file:
        data = json.load(data_file)

    return {identifier: _get_cleaner(cleaner) for identifier, cleaner in data.items()}


def _get_cleaner(raw):
    return model.Cleaner(
        title=raw["title"],
        homepage=raw["homepage"],
        file_patterns=tuple(raw["file_patterns"]),
        command=tuple(raw["command"]),
    )


if __name__ == "__main__":
    main()
