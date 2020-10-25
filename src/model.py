import dataclasses
import re
import typing


@dataclasses.dataclass
class Cleaner:
    is_only_active_if_command: typing.Optional[str]
    file_pattern: typing.Optional[re.Pattern]
    check: typing.Optional[str]
    fix: typing.Optional[str]
