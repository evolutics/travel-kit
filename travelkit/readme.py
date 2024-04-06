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
    humanized_command = " ".join(
        ("…" if pathlib.Path(argument).is_absolute() else shlex.quote(argument))
        for argument in cleaner.command[1:]
    )
    pattern_indicator = "".join(f" {pattern}" for pattern in cleaner.file_patterns)
    return f"""```bash
{humanized_command}{pattern_indicator}
```"""
