from importlib import resources
import json

from . import model


def get():
    data_path = resources.files("travelkit").joinpath("cleaners.json")
    with data_path.open("br") as data_file:
        data = json.load(data_file)

    return {identifier: _get_cleaner(cleaner) for identifier, cleaner in data.items()}


def _get_cleaner(raw):
    return model.Cleaner(
        title=raw["title"],
        homepage=raw["homepage"],
        is_only_active_if_command=tuple(raw["is_only_active_if_command"]),
        file_patterns=tuple(raw["file_patterns"]),
        check=tuple(raw["check"]),
        fix=tuple(raw["fix"]),
    )
