import pathlib
import shlex
import textwrap


def get(cleaners):
    menu = "\n\n".join(
        _menu_entry(identifier, cleaner) for identifier, cleaner in cleaners.items()
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
    humanized_command = " ".join(
        ("…" if pathlib.Path(argument).is_absolute() else shlex.quote(argument))
        for argument in cleaner.command[1:]
    )
    pattern_indicator = "".join(f" {pattern}" for pattern in cleaner.file_patterns)
    return f"""Command (file patterns apply recursively):

```bash
{humanized_command}{pattern_indicator}
```"""
