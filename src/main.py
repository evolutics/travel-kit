#!/usr/bin/env python3

import argparse

import cleaners
import readme
import run_cleaners


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers()

    for subcommand, function in {
        "check": lambda filtered_cleaners: run_cleaners.get(
            filtered_cleaners, lambda cleaner: cleaner.check
        ),
        "fix": lambda filtered_cleaners: run_cleaners.get(
            filtered_cleaners, lambda cleaner: cleaner.fix
        ),
        "readme": lambda filtered_cleaners: print(readme.get(filtered_cleaners)),
    }.items():
        subparser = subparsers.add_parser(subcommand)
        subparser.set_defaults(function=function)

    arguments = parser.parse_args()

    filtered_cleaners = cleaners.get()
    arguments.function(filtered_cleaners)


if __name__ == "__main__":
    main()
