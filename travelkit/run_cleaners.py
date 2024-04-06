import fnmatch
import pathlib
import shlex
import subprocess
import sys


def get(cleaners, is_dry_run, file_paths):
    exit_status = 0
    for cleaner in cleaners.values():
        command = _resolve_command(cleaner, file_paths)
        if command:
            if is_dry_run:
                _dry_run_command(command)
            else:
                try:
                    _run_command(command)
                except subprocess.CalledProcessError:
                    exit_status = 1
    sys.exit(exit_status)


def _resolve_command(cleaner, file_paths):
    if cleaner.file_patterns:
        file_paths = tuple(_filter_file_paths(cleaner, file_paths))
        if file_paths:
            return cleaner.command + file_paths
        return ()

    return cleaner.command


def _filter_file_paths(cleaner, file_paths):
    return (
        path
        for path in file_paths
        if any(fnmatch.fnmatchcase(path, pattern) for pattern in cleaner.file_patterns)
    )


def _dry_run_command(command):
    shell_command = " ".join(shlex.quote(argument) for argument in command[1:])
    print(f"Would run: {shell_command}")


def _run_command(command):
    executable = pathlib.Path(command[0]) / command[1]
    subprocess.run((executable,) + command[2:], check=True)
