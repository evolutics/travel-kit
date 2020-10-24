#!/usr/bin/env python3

import argparse

import readme
import run_cleaners


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers()

    for subcommand, function in {
        "check": lambda: run_cleaners.get(lambda cleaner: cleaner.check),
        "fix": lambda: run_cleaners.get(lambda cleaner: cleaner.fix),
        "readme": lambda: print(readme.get()),
    }.items():
        subparser = subparsers.add_parser(subcommand)
        subparser.set_defaults(function=function)

    arguments = parser.parse_args()
    arguments.function()


if __name__ == "__main__":
    main()
