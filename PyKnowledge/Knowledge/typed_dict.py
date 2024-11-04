from typing import TypedDict, NotRequired, Required

### 新版python 才行 ？
### ReadOnly Required NotRequired


class PersonInfo(TypedDict, total=False):
    name: Required[str]
    age: int


def print_info(person: PersonInfo):
    print(f"person name {person['name']}")
    print(f"person age {person['age']}")


print_info({"name": "me", "age": 4})
