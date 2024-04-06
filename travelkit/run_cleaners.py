import dataclasses
import fnmatch
import pathlib
import shlex
import subprocess
import sys
import typing

from . import model


def get(cleaners, get_command, is_dry_run, file_paths):
    context = _Context(
        get_command=get_command,
        is_dry_run=is_dry_run,
        file_paths=file_paths if file_paths else _get_default_file_paths(),
    )

    exit_status = 0
    for cleaner in cleaners.values():
        command = _resolve_command(cleaner, context)
        if command:
            try:
                _run_command_in_context(context, command)
            except subprocess.CalledProcessError:
                exit_status = 1
    sys.exit(exit_status)


@dataclasses.dataclass
class _Context:
    get_command: typing.Callable[[model.Cleaner], tuple[str, ...]]
    is_dry_run: bool
    file_paths: tuple[str, ...]


def _get_default_file_paths():
    terminator = "\0"
    return (
        subprocess.run(
            ["git", "ls-files", "-z"], check=True, stdout=subprocess.PIPE, text=True
        )
        .stdout.rstrip(terminator)
        .split(terminator)
    )


def _resolve_command(cleaner, context):
    command = context.get_command(cleaner)
    if not command:
        return ()

    if cleaner.file_patterns:
        file_paths = tuple(_filter_file_paths(cleaner, context))
        if file_paths:
            return command + file_paths
        return ()

    return command


def _filter_file_paths(cleaner, context):
    return (
        path
        for path in context.file_paths
        if any(fnmatch.fnmatchcase(path, pattern) for pattern in cleaner.file_patterns)
    )


def _run_command_in_context(context, command):
    if context.is_dry_run:
        shell_command = " ".join(shlex.quote(str(argument)) for argument in command[1:])
        print(f"Would run: {shell_command}")
        return
    subprocess.run(_executable_command(command), check=True)


def _executable_command(command):
    executable = pathlib.Path(command[0]) / command[1]
    return (executable,) + command[2:]
