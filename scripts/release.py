#!/usr/bin/env python3

import argparse
import subprocess


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("version")
    arguments = parser.parse_args()
    version = arguments.version

    _check_that_head_is_current()
    _check_that_head_build_passed()
    _tag_head(version)


def _check_that_head_is_current():
    subprocess.run(["git", "fetch"], check=True)
    subprocess.run(["git", "diff", "--exit-code", "HEAD", "origin/main"], check=True)


def _check_that_head_build_passed():
    input("Check that the build for HEAD has passed (control+C if not).")


def _tag_head(version):
    subprocess.run(
        ["git", "tag", "--annotate", version, "--message", version], check=True
    )
    subprocess.run(["git", "push", "origin", version], check=True)


if __name__ == "__main__":
    main()
