from typing import List, TypeVar, Generic, Union, Sequence


class Animal:
    pass


class Dog(Animal):
    pass


class Cat(Animal):
    pass


AnimalType = TypeVar("AnimalType", bound=Animal, covariant=True)


class Store(Generic[AnimalType]):
    def __init__(self, stock: List[AnimalType]) -> None:
        self.stock = stock

    def buy(self) -> AnimalType | None:
        if len(self.stock) > 0:
            return self.stock.pop()
        return None


    ### 有了这个函数Store[Dog]就不能看作Store[Animal]的子类型了
    ### 因为Store[Dog]中的操作不再是封闭的 -> 可以卖狗之外的东西了
    ### 这样就不应该标注covariant，(标注之后照样报错)
    # def restock(self, a: AnimalType) -> None:
    #     self.stock.append(a)


wang = Store[Dog]([Dog(), Dog()])
li = Store[Dog]([Dog(), Dog()])

print(wang.buy())
print(wang.buy())
print(wang.buy())

Store[int]([1, 2, 3])  ### 如果不给TypeVar 约束的话里面的值可以是任何东西。。。

Store[Animal]([Cat(), Dog()])


### 这个函数用来说明Store[Dog] 并非 Stroe[Animal] 的子类 ------ Invariant
def buy_animal(recommand_store: Store[Animal]) -> Animal | None:
    return recommand_store.buy()


### 类型协变 covariant
buy_animal(li)

# 系统类型 List 是 invariant, Sequence 是 covariant
List[Dog]
List[Animal]

Sequence[Dog]
Sequence[Animal]
###
