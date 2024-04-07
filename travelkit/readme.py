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
    humanized_command = _humanize_command(cleaner.command)
    pattern_indicator = "".join(f" {pattern}" for pattern in cleaner.file_patterns)
    return f"""```bash
{humanized_command}{pattern_indicator}
```"""


def _humanize_command(command):
    def humanize(index, argument):
        if index == 0:
            return shlex.quote(pathlib.Path(argument).name)
        if pathlib.Path(argument).is_absolute():
            return "…"
        return shlex.quote(argument)

    return " ".join(humanize(index, argument) for index, argument in enumerate(command))
