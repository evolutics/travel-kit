import readme_template


def get(cleaners):
    menu = "\n\n".join(
        [_menu_entry(title, cleaner) for title, cleaner in cleaners.items()]
    )
    return readme_template.get().format(menu=menu)


def _menu_entry(title, cleaner):
    details = _details(cleaner)
    return f"""<details>
<summary><strong>{title}</strong></summary>

{details}

</details>"""


def _details(cleaner):
    return "\n\n".join(
        _is_only_active_if_command_entries(cleaner.is_only_active_if_command)
        + _file_pattern_entries(cleaner.file_pattern)
        + _command_entries(cleaner)
    )


def _is_only_active_if_command_entries(is_only_active_if_command):
    if is_only_active_if_command:
        return [f"Only used if command returns 0: `{is_only_active_if_command}`"]
    return []


def _file_pattern_entries(file_pattern):
    if file_pattern:
        if file_pattern.pattern:
            return [f"Only applied to files matching regex: `{file_pattern.pattern}`"]
        return ["Only applied to files."]
    return []


def _command_entries(cleaner):
    return [
        _command_entry(key, command)
        for key, command in {"check": cleaner.check, "fix": cleaner.fix}.items()
        if command is not None
    ]


def _command_entry(key, command):
    return f"""`{key}` command:

```bash
{command}
```"""
