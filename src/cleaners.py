import json
import pathlib
import re

import model


def get():
    data_path = pathlib.Path(__file__).parent / "cleaners.json"
    with data_path.open() as data_file:
        data = json.load(data_file)

    return {title: _get_cleaner(cleaner) for title, cleaner in data.items()}


def _get_cleaner(raw):
    return model.Cleaner(
        is_only_active_if_command=raw["is_only_active_if_command"],
        file_pattern=None
        if raw["file_pattern"] is None
        else re.compile(raw["file_pattern"]),
        check=raw["check"],
        fix=raw["fix"],
    )
