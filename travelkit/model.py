import dataclasses


@dataclasses.dataclass
class Cleaner:
    title: str
    homepage: str
    command: tuple[str, ...]
    file_patterns: tuple[str, ...]
