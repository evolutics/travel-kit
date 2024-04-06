import fnmatch
import pathlib
import shlex
import subprocess
import sys


def get(cleaners, is_dry_run, file_paths):
    errors = []
    for identifier, cleaner in cleaners.items():
        resolved_command = _resolve_command(cleaner, file_paths)
        if resolved_command:
            if is_dry_run:
                _dry_run_command(resolved_command)
            else:
                try:
                    subprocess.run(resolved_command, check=True)
                except subprocess.CalledProcessError as error:
                    errors += [f"{identifier}: error code {error.returncode}"]
    if errors:
        sys.exit("\n".join(errors))


def _resolve_command(cleaner, file_paths):
    if cleaner.file_patterns:
        file_paths = tuple(_filter_file_paths(cleaner, file_paths))
        if not file_paths:
            return None
    else:
        file_paths = ()

    executable = str(pathlib.Path(cleaner.command[0]) / cleaner.command[1])
    return (executable,) + cleaner.command[2:] + file_paths


def _filter_file_paths(cleaner, file_paths):
    return (
        path
        for path in file_paths
        if any(fnmatch.fnmatchcase(path, pattern) for pattern in cleaner.file_patterns)
    )


def _dry_run_command(resolved_command):
    shell_command = " ".join(shlex.quote(argument) for argument in resolved_command)
    print(f"Would run: {shell_command}")
