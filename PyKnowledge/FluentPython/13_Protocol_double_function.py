from typing import TypeVar
from typing import Protocol

T = TypeVar("T")


class Repeatable(Protocol):
    def __mul__(self: T, repeat_count: int) -> T: ...


RT = TypeVar("RT", bound=Repeatable)


def double(x: RT) -> RT:
    return x * 2
