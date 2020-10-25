import dataclasses
import pathlib
import subprocess
import sys
import typing

import cleaners


def get(cleaners, get_command):
    context = _Context(
        get_command=get_command, is_in_git_repository=_is_in_git_repository()
    )

    exit_status = 0
    for cleaner in cleaners.values():
        resolved_command = _resolve_command(cleaner, context)
        if resolved_command:
            try:
                _run_command(resolved_command)
            except subprocess.CalledProcessError:
                exit_status = 1
    sys.exit(exit_status)


@dataclasses.dataclass
class _Context:
    get_command: typing.Callable[[cleaners.Cleaner], str]
    is_in_git_repository: bool


@dataclasses.dataclass
class _ResolvedCommand:
    command: str
    input_parts: typing.Optional[typing.Sequence[str]]


def _is_in_git_repository():
    try:
        subprocess.run(["git", "rev-parse"], capture_output=True, check=True)
    except subprocess.CalledProcessError:
        return False
    return True


def _resolve_command(cleaner, context):
    if cleaner.only_in_git_repository and not context.is_in_git_repository:
        return None

    command = context.get_command(cleaner)
    if command is None:
        return None

    if cleaner.file_pattern:
        file_paths = sorted(_get_file_paths(cleaner, context))
        if file_paths:
            return _ResolvedCommand(
                command=f"xargs -0 {command}", input_parts=file_paths
            )
        return None

    return _ResolvedCommand(command=command, input_parts=None)


def _get_file_paths(cleaner, context):
    if context.is_in_git_repository:
        paths = subprocess.run(
            ["git", "ls-files", "-z"], capture_output=True, check=True, text=True
        ).stdout.split("\x00")[:-1]
    else:
        paths = (str(path) for path in pathlib.Path(".").glob("**/*"))

    return (path for path in paths if cleaner.file_pattern.search(path))


def _run_command(resolved_command):
    if resolved_command.input_parts is None:
        input_ = None
    else:
        input_ = "".join([part + "\x00" for part in resolved_command.input_parts])

    return subprocess.run(
        resolved_command.command, check=True, input=input_, shell=True, text=True
    )
