import dataclasses
import json
import pathlib
import subprocess
import sys
import typing

import cleaners


def get(cleaners, get_command, is_dry_run, file_paths):
    context = _Context(
        get_command=get_command,
        is_dry_run=is_dry_run,
        file_paths=file_paths,
        command_exit_statuses=_get_activation_command_statuses(cleaners),
    )

    exit_status = 0
    for cleaner in cleaners.values():
        resolved_command = _resolve_command(cleaner, context)
        if resolved_command:
            try:
                _run_command_in_context(context, resolved_command)
            except subprocess.CalledProcessError:
                exit_status = 1
    sys.exit(exit_status)


@dataclasses.dataclass
class _Context:
    get_command: typing.Callable[[cleaners.Cleaner], str]
    is_dry_run: bool
    file_paths: typing.Sequence[pathlib.Path]
    command_exit_statuses: typing.Mapping[str, int]


@dataclasses.dataclass
class _ResolvedCommand:
    command: str
    input_parts: typing.Optional[typing.Sequence[str]]


def _get_activation_command_statuses(cleaners):
    unique_commands = sorted(
        {
            cleaner.is_only_active_if_command
            for cleaner in cleaners.values()
            if cleaner.is_only_active_if_command is not None
        }
    )
    return {
        command: subprocess.run(
            command, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        ).returncode
        for command in unique_commands
    }


def _resolve_command(cleaner, context):
    if (
        cleaner.is_only_active_if_command is not None
        and context.command_exit_statuses[cleaner.is_only_active_if_command]
    ):
        return None

    command = context.get_command(cleaner)
    if command is None:
        return None

    if cleaner.file_pattern:
        input_parts = sorted(str(path) for path in _get_file_paths(cleaner, context))
        if input_parts:
            return _ResolvedCommand(
                command=f"xargs -0 {command}", input_parts=input_parts
            )
        return None

    return _ResolvedCommand(command=command, input_parts=None)


def _get_file_paths(cleaner, context):
    if context.file_paths:
        paths = context.file_paths
    else:
        paths = pathlib.Path(".").glob("**/*")

    return (path for path in paths if cleaner.file_pattern.search(str(path)))


def _run_command_in_context(context, resolved_command):
    if context.is_dry_run:
        return _dry_run_command(resolved_command)
    return _run_command(resolved_command)


def _dry_run_command(resolved_command):
    if resolved_command.input_parts is None:
        comment = "Would run command:"
    else:
        comment = "Would run command (inputs below):"
    print(f"{comment} {resolved_command.command}")

    if resolved_command.input_parts is not None:
        print(json.dumps(resolved_command.input_parts, indent=2))


def _run_command(resolved_command):
    if resolved_command.input_parts is None:
        input_ = None
    else:
        input_ = "".join([part + "\x00" for part in resolved_command.input_parts])

    return subprocess.run(
        resolved_command.command, check=True, input=input_, shell=True, text=True
    )
