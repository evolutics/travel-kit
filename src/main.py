#!/usr/bin/env python3

import argparse
import dataclasses
import pathlib
import typing

import cleaners
import readme
import run_cleaners


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers()

    for key, subcommand in _subcommands().items():
        subparser = subparsers.add_parser(key)
        subparser.set_defaults(function=subcommand.function)
        subcommand.configure_subparser(subparser)

    arguments = parser.parse_args()
    arguments.function(arguments)


@dataclasses.dataclass
class _Subcommand:
    configure_subparser: typing.Callable[[argparse.ArgumentParser], None]
    function: typing.Callable[[typing.Any], None]


def _subcommands():
    return {
        "check": _subcommand_to_run_cleaner(lambda cleaner: cleaner.check),
        "fix": _subcommand_to_run_cleaner(lambda cleaner: cleaner.fix),
        "readme": _Subcommand(
            lambda subparser: None,
            function=lambda arguments: print(readme.get(cleaners.get())),
        ),
    }


def _subcommand_to_run_cleaner(get_command):
    unfiltered_cleaners = cleaners.get()

    def configure_subparser(subparser):
        subparser.add_argument("--dry-run", action="store_true")
        subparser.add_argument(
            "--skip",
            action="append",
            choices=unfiltered_cleaners,
            default=[],
            help="Do not use this tool.",
        )
        subparser.add_argument("file_paths", nargs="*", type=pathlib.Path)

    def function(arguments):
        filtered_cleaners = {
            title: cleaner
            for title, cleaner in unfiltered_cleaners.items()
            if title not in arguments.skip
        }
        return run_cleaners.get(
            cleaners=filtered_cleaners,
            get_command=get_command,
            is_dry_run=arguments.dry_run,
            file_paths=arguments.file_paths,
        )

    return _Subcommand(configure_subparser=configure_subparser, function=function)


if __name__ == "__main__":
    main()
