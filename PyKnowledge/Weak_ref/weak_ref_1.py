import random

id_user = {}


class User:
    def __init__(self) -> None:
        self._id = random.randint(0, 1000)
        while self._id in id_user:
            self._id = random.randint(0, 1000)
        id_user[self._id] = self


def chat_room():
    u1 = User()
    u2 = User()

    ### 删除后引用消失，但是删除和创建不在一个地方，是个设计问题？？？
    del id_user[u1._id]
    del id_user[u2._id]


chat_room()
chat_room()
[print(f"{k},{v}") for k, v in id_user.items()]
