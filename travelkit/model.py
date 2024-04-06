import dataclasses


@dataclasses.dataclass
class Cleaner:
    title: str
    homepage: str
    file_patterns: tuple[str, ...]
    check: tuple[str, ...]
    fix: tuple[str, ...]
