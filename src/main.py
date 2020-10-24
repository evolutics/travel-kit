#!/usr/bin/env python3

import argparse
import dataclasses
import subprocess
import sys
import typing

import cleaners


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers()

    for subcommand, function in {"check": _check, "fix": _fix}.items():
        subparser = subparsers.add_parser(subcommand)
        subparser.set_defaults(function=function)

    arguments = parser.parse_args()
    arguments.function()


def _check():
    _run_commands_independently(
        [
            cleaner.check
            for cleaner in cleaners.get().values()
            if cleaner.check is not None
        ]
    )


def _run_commands_independently(commands):
    exit_status = 0
    for command in commands:
        try:
            subprocess.run(command, check=True, shell=True)
        except subprocess.CalledProcessError:
            exit_status = 1
    sys.exit(exit_status)


def _fix():
    _run_commands_independently(
        [cleaner.fix for cleaner in cleaners.get().values() if cleaner.fix is not None]
    )


if __name__ == "__main__":
    main()
