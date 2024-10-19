### e.g.  type 类就是一个元类, 用于创建其他 class 的类
### 可以在定义类的时候制定 metaclass
### 这个元类默认定义了一个 类属性 freedom 为 True 给所有子类
### 元类和父类 的差别


class Human(type):
    @staticmethod
    def __new__(mcs, *args, **kargs):
        class_ = super().__new__(mcs, *args)
        class_.freedom = True
        if kargs:
            for name, value in kargs.items():
                setattr(class_, name, value)

        return class_


class Person(object, metaclass=Human, country="China"):
    def __init__(self, name, age) -> None:
        self.name = name
        self.age = age


me = Person("xx", 12)
print(type(me))
print(isinstance(me, Person))
print(Person.__base__)  ### 元类不为父类
print(me.country)
print([attr for attr in dir(me)])
