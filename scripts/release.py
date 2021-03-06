#!/usr/bin/env python3

import argparse
import subprocess


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("version")
    arguments = parser.parse_args()
    version = arguments.version

    commit = _get_commit_to_release()
    _check_that_current(commit)
    _check_that_test_passed(commit)
    _tag(commit, version)


def _get_commit_to_release():
    return subprocess.run(
        ["git", "rev-parse", "HEAD"], capture_output=True, check=True, text=True
    ).stdout.rstrip()


def _check_that_current(commit):
    subprocess.run(["git", "fetch"], check=True)
    subprocess.run(["git", "diff", "--exit-code", commit, "origin/main"], check=True)


def _check_that_test_passed(commit):
    input(f"Check that test has passed for commit (control+C if not): {commit}")


def _tag(commit, version):
    subprocess.run(
        ["git", "tag", "--annotate", version, "--message", version, commit], check=True
    )
    subprocess.run(["git", "push", "origin", version], check=True)


if __name__ == "__main__":
    main()
