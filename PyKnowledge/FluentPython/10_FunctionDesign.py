from abc import ABC, abstractmethod
from collections.abc import Sequence
from decimal import Decimal
from typing import NamedTuple, Optional


class Customer(NamedTuple):
    name: str
    fidelity: int


class LineItem(NamedTuple):
    product: str
    quantity: int
    price: Decimal

    def total(self) -> Decimal:
        return self.price * self.quantity


class Order(NamedTuple):  # 上下⽂
    customer: Customer
    cart: Sequence[LineItem]
    promotion: Optional["Promotion"] = None

    def total(self) -> Decimal:
        totals = (item.total() for item in self.cart)
        return sum(totals, start=Decimal(0))

    def due(self) -> Decimal:
        if self.promotion is None:
            discount = Decimal(0)
        else:
            discount = self.promotion.discount(self)
        return self.total() - discount

    def __repr__(self):
        return f"<Order total: {self.total():.2f} due: {self.due():.2f}>"


class Promotion(ABC):  # 策略：抽象基类
    @abstractmethod
    def discount(self, order: Order) -> Decimal:
        """返回折扣⾦额（正值）"""


class FidelityPromo(Promotion):  # 第⼀个具体策略
    """为积分为1000或以上的顾客提供5%折扣"""

    def discount(self, order: Order) -> Decimal:
        rate = Decimal("0.05")
        if order.customer.fidelity >= 1000:
            return order.total() * rate
        return Decimal(0)


class BulkItemPromo(Promotion):  # 第⼆个具体策略
    """单个商品的数量为20个或以上时提供10%折扣"""

    def discount(self, order: Order) -> Decimal:
        discount = Decimal(0)
        for item in order.cart:
            if item.quantity >= 20:
                discount += item.total() * Decimal("0.1")
        return discount


class LargeOrderPromo(Promotion):  # 第三个具体策略
    """订单中不同商品的数量达到10个或以上时提供7%折扣"""

    def discount(self, order: Order) -> Decimal:
        distinct_items = {item.product for item in order.cart}
        if len(distinct_items) >= 10:
            return order.total() * Decimal("0.07")
        return Decimal(0)


joe = Customer("John Doe", 0)
ann = Customer("Ann Smith", 1100)
cart = [
    LineItem("banana", 4, Decimal(".5")),
    LineItem("apple", 10, Decimal("1.5")),
    LineItem("watermelon", 5, Decimal(5)),
]
Order(joe, cart, FidelityPromo())
print(Order(joe, cart, FidelityPromo()))
print(Order(joe, cart, BulkItemPromo()))
print(Order(joe, cart, LargeOrderPromo()))
print(Order(ann, cart, FidelityPromo()))
print(Order(ann, cart, BulkItemPromo()))
print(Order(ann, cart, LargeOrderPromo()))