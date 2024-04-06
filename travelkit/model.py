import dataclasses


@dataclasses.dataclass
class Cleaner:
    title: str
    homepage: str
    file_patterns: tuple[str, ...]
    command: tuple[str, ...]
