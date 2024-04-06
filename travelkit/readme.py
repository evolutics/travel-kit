import pathlib
import shlex
import textwrap


def get(cleaners):
    menu = "\n\n".join(
        [_menu_entry(identifier, cleaner) for identifier, cleaner in cleaners.items()]
    )
    return f"\nThe following tools are integrated:\n\n{menu}"


def _menu_entry(identifier, cleaner):
    details = textwrap.indent(_details(cleaner), "  ")
    return f"""- [**{cleaner.title}**]({cleaner.homepage})

  <details>

  <summary>Details of <code>{identifier}</code></summary>

{details}

  </details>"""


def _details(cleaner):
    return "\n\n".join(
        ([_file_pattern_entry(cleaner.file_patterns)] if cleaner.file_patterns else [])
        + [_command_entry(cleaner.command)]
    )


def _file_pattern_entry(file_patterns):
    humanized_patterns = ", ".join(f"`{pattern}`" for pattern in file_patterns)
    return f"Only applied to files matching patterns: {humanized_patterns}"


def _command_entry(command):
    humanized_command = " ".join(
        ("…" if pathlib.Path(argument).is_absolute() else shlex.quote(argument))
        for argument in command[1:]
    )
    return f"""Command:

```bash
{humanized_command}
```"""
