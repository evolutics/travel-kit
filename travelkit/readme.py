import pathlib
import shlex
import textwrap


def get(cleaners):
    menu = "\n\n".join(_menu_entry(cleaner) for cleaner in cleaners.values())
    return f"\nThe following tools are integrated:\n\n{menu}"


def _menu_entry(cleaner):
    details = textwrap.indent(_details(cleaner), "  ")
    return f"""- [**{cleaner.title}**]({cleaner.homepage})

{details}"""


def _details(cleaner):
    symbolic_command_call = _symbolic_command_call(cleaner)
    return f"""```bash
{symbolic_command_call}
```"""


def _symbolic_command_call(cleaner):
    executable = shlex.quote(pathlib.Path(cleaner.command[0]).name)
    options = (
        "…" if pathlib.Path(option).is_absolute() else shlex.quote(option)
        for option in cleaner.command[1:]
    )

    return " ".join((executable,) + tuple(options) + cleaner.file_patterns)
