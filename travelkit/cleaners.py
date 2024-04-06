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
        file_patterns=tuple(raw["file_patterns"]),
        command=tuple(raw["command"]),
    )
