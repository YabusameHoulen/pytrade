import random
import weakref

id_user = weakref.WeakValueDictionary()


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
    ### 弱引用方式会在离开作用域时删除
    # del id_user[u1._id]
    # del id_user[u2._id]


u = User()
chat_room()
chat_room()
[print(f"{k},{v}") for k, v in id_user.items()]


u_ref = weakref.ref(u)

u = None
print(u_ref())

### 所有类的实例容器都是可以被弱引用的