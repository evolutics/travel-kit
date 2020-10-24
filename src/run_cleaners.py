import subprocess
import sys


def get(cleaners, get_command):
    is_in_git_repository = _is_in_git_repository()

    exit_status = 0
    for cleaner in cleaners.values():
        command = _command_in_context(cleaner, is_in_git_repository, get_command)
        if command is not None:
            try:
                subprocess.run(command, check=True, shell=True)
            except subprocess.CalledProcessError:
                exit_status = 1
    sys.exit(exit_status)


def _is_in_git_repository():
    try:
        subprocess.run(["git", "rev-parse"], capture_output=True, check=True)
    except subprocess.CalledProcessError:
        return False
    return True


def _command_in_context(cleaner, is_in_git_repository, get_command):
    if cleaner.only_in_git_repository and not is_in_git_repository:
        return None

    command = get_command(cleaner)
    if command is None:
        return None

    if cleaner.file_patterns is None:
        return command

    raw_patterns = " ".join(f"'{pattern}'" for pattern in cleaner.file_patterns)
    return f"git ls-files -z -- {raw_patterns} | xargs -0 {command}"
