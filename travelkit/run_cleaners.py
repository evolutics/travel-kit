import dataclasses
import pathlib
import subprocess
import sys
import typing

from . import model


def get(cleaners, get_command, is_dry_run, file_paths):
    context = _Context(
        get_command=get_command,
        is_dry_run=is_dry_run,
        file_paths=file_paths,
        command_exit_statuses=_get_activation_command_statuses(cleaners),
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
    file_paths: typing.Sequence[pathlib.Path]
    command_exit_statuses: typing.Mapping[tuple[str, ...], int]


def _get_activation_command_statuses(cleaners):
    unique_commands = sorted(
        {
            cleaner.is_only_active_if_command
            for cleaner in cleaners.values()
            if cleaner.is_only_active_if_command
        }
    )
    return {
        command: subprocess.run(
            _executable_command(command),
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ).returncode
        for command in unique_commands
    }


def _executable_command(command):
    executable = pathlib.Path(command[0]) / command[1]
    return (executable,) + command[2:]


def _resolve_command(cleaner, context):
    if (
        cleaner.is_only_active_if_command
        and context.command_exit_statuses[cleaner.is_only_active_if_command]
    ):
        return ()

    command = context.get_command(cleaner)
    if not command:
        return ()

    if cleaner.file_pattern:
        file_paths = tuple(sorted(_get_file_paths(cleaner, context)))
        if file_paths:
            return command + file_paths
        return ()

    return command


def _get_file_paths(cleaner, context):
    if context.file_paths:
        paths = context.file_paths
    else:
        paths = pathlib.Path(".").glob("**/*")

    return (path for path in paths if cleaner.file_pattern.search(path.as_posix()))


def _run_command_in_context(context, command):
    if context.is_dry_run:
        shell_command = " ".join(str(argument) for argument in command[1:])
        print(f"Would run command: {shell_command}")
        return
    subprocess.run(_executable_command(command), check=True)
