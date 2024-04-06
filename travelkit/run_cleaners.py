import fnmatch
import pathlib
import shlex
import subprocess
import sys


def get(cleaners, is_dry_run, file_paths):
    if not file_paths:
        file_paths = _get_default_file_paths()

    exit_status = 0
    for cleaner in cleaners.values():
        command = _resolve_command(cleaner, file_paths)
        if command:
            try:
                _run_command_in_context(is_dry_run, command)
            except subprocess.CalledProcessError:
                exit_status = 1
    sys.exit(exit_status)


def _get_default_file_paths():
    terminator = "\0"
    return (
        subprocess.run(
            ["git", "ls-files", "-z"], check=True, stdout=subprocess.PIPE, text=True
        )
        .stdout.rstrip(terminator)
        .split(terminator)
    )


def _resolve_command(cleaner, file_paths):
    if not cleaner.command:
        return ()

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


def _run_command_in_context(is_dry_run, command):
    if is_dry_run:
        shell_command = " ".join(shlex.quote(str(argument)) for argument in command[1:])
        print(f"Would run: {shell_command}")
        return
    subprocess.run(_executable_command(command), check=True)


def _executable_command(command):
    executable = pathlib.Path(command[0]) / command[1]
    return (executable,) + command[2:]
