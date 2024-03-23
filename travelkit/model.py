import dataclasses
import re
import typing


@dataclasses.dataclass
class Cleaner:
    title: str
    homepage: str
    is_only_active_if_command: tuple[str, ...]
    file_pattern: typing.Optional[re.Pattern]
    check: tuple[str, ...]
    fix: tuple[str, ...]
