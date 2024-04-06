import pathlib
import shlex
import textwrap

from . import readme_template


def get(cleaners):
    menu = "\n\n".join(
        [_menu_entry(identifier, cleaner) for identifier, cleaner in cleaners.items()]
    )
    return readme_template.get().format(menu=menu)


def _menu_entry(identifier, cleaner):
    details = textwrap.indent(_details(cleaner), "  ")
    return f"""- [**{cleaner.title}**]({cleaner.homepage})

  <details>

  <summary>Details of <code>{identifier}</code></summary>

{details}

  </details>"""


def _details(cleaner):
    return "\n\n".join(
        _is_only_active_if_command_entries(cleaner.is_only_active_if_command)
        + _file_pattern_entries(cleaner.file_patterns)
        + _command_entries(cleaner)
    )


def _is_only_active_if_command_entries(is_only_active_if_command):
    if is_only_active_if_command:
        command = _humanize_command(is_only_active_if_command)
        return [f"Only used if command returns 0: `{command}`"]
    return []


def _humanize_command(command):
    return " ".join(
        ("…" if pathlib.Path(argument).is_absolute() else shlex.quote(argument))
        for argument in command[1:]
    )


def _file_pattern_entries(file_patterns):
    if file_patterns:
        humanized_patterns = ", ".join(f"`{pattern}`" for pattern in file_patterns)
        return [f"Only applied to files matching patterns: {humanized_patterns}"]
    return []


def _command_entries(cleaner):
    return [
        _command_entry(key, command)
        for key, command in {"check": cleaner.check, "fix": cleaner.fix}.items()
        if command
    ]


def _command_entry(key, command):
    command = _humanize_command(command)
    return f"""`{key}` command:

```bash
{command}
```"""
