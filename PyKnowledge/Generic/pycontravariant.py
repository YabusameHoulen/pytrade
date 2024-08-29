from typing import TypeVar, Generic


class Animal:
    pass


class Dog(Animal):
    pass


class Cat(Animal):
    pass


AnimalType = TypeVar("AnimalType", bound=Animal, contravariant=True)


class Doctor(Generic[AnimalType]):
    def treat(self, a: AnimalType) -> None:
        print(f"Treating {a}")


def treat_my_dog(d: Doctor[Dog]) -> None:
    d.treat(Dog())


wang = Doctor[Dog]()
treat_my_dog(wang)

### Doctor[Animal] 不是 Doctor[Dog] 子类型, 所以这个不能用, 应该设置contravariant 属性
zhang = Doctor[Animal]()
treat_my_dog(zhang)
