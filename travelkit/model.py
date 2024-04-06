import dataclasses


@dataclasses.dataclass
class Cleaner:
    title: str
    homepage: str
    is_only_active_if_command: tuple[str, ...]
    file_patterns: tuple[str, ...]
    check: tuple[str, ...]
    fix: tuple[str, ...]
