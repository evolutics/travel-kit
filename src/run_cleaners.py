import subprocess
import sys

import cleaners


def get(get_command):
    exit_status = 0
    for cleaner in cleaners.get().values():
        command = get_command(cleaner)
        if command is not None:
            try:
                subprocess.run(command, check=True, shell=True)
            except subprocess.CalledProcessError:
                exit_status = 1
    sys.exit(exit_status)
