from array import array
import math


class Vector2d:
    __match_args__ = ("x", "y")
    typecode = "d"

    def __init__(self, x, y):
        self.__x = float(x)
        self.__y = float(y)

    @property
    def x(self):
        return self.__x

    @property
    def y(self):
        return self.__y

    def __iter__(self):
        return (i for i in (self.x, self.y))

    def __repr__(self):
        class_name = type(self).__name__
        return "{}({!r}, {!r})".format(class_name, *self)

    def __str__(self):
        return str(tuple(self))

    def __bytes__(self):
        return bytes([ord(self.typecode)]) + bytes(array(self.typecode, self))

    def __eq__(self, other):
        return tuple(self) == tuple(other)

    def __hash__(self):
        return hash((self.x, self.y))

    def __abs__(self):
        return math.hypot(self.x, self.y)

    def __bool__(self):
        return bool(abs(self))

    def angle(self):
        return math.atan2(self.y, self.x)

    def __format__(self, fmt_spec=""):
        if fmt_spec.endswith("p"):
            fmt_spec = fmt_spec[:-1]
            coords = (abs(self), self.angle())
            outer_fmt = "<{}, {}>"
        else:
            coords = self
            outer_fmt = "({}, {})"
            components = (format(c, fmt_spec) for c in coords)
            return outer_fmt.format(*components)

    @classmethod
    def frombytes(cls, octets):
        typecode = chr(octets[0])
        memv = memoryview(octets[1:]).cast(typecode)
        return cls(*memv)


test = Vector2d(3, 4)
print(f"{test.x}")

for i in test:
    print(i)

print([test, test, test])
### in order to be used as the dict key or as a set element, it must be hashable
print({test: 1})
print({test})


def keyword_pattern_demo(V: Vector2d) -> None:
    match V:
        case Vector2d(x=0, y=0):
            print(f"{V!a} is null !")
        case _:
            print(f"{V!r} is awesome !")


keyword_pattern_demo(test)
keyword_pattern_demo(Vector2d(0, 0))


class Pixel:
    __slots__ = ("x", "y")

p = Pixel()
# print(p.__dict__)

class OpenPixel(Pixel):
    pass

tp = OpenPixel()
print(tp.__dict__)