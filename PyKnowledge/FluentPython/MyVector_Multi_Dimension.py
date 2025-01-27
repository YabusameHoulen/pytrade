from array import array
import reprlib
import math
import operator
import functools
import itertools
from collections import abc


class Vector:
    typecode = "d"
    __match_args__ = ("x", "y", "z", "t")

    def __getattribute__(self, name):
        cls = type(self)
        try:
            pos = cls.__match_args__.index(name)
        except ValueError:
            pos = -1
        if 0 <= pos < len(self._components):
            return self._components[pos]
        msg = f"{cls.__name__!r} object has no attribute {name!r}"

        raise AttributeError(msg)

    def __init__(self, components):
        self._components = array(self.typecode, components)

    def __iter__(self):
        return iter(self._components)

    def angle(self, n):
        r = math.hypot(*self[n:])
        a = math.atan2(r, self[n - 1])
        if (n == len(self) - 1) and (self[-1] < 0):
            return math.pi * 2 - a
        else:
            return a

    def angles(self):
        return (self.angle(n) for n in range(1, len(self)))

    def __format__(self, format_spec):
        if format_spec.endswith("h"):
            format_spec = format_spec[:-1]
            coords = itertools.chain([abs(self)], self.angles)
            outer_fmt = "<{}>"
        else:
            coords = self
            outer_fmt = "({})"

        components = (format(c, format_spec) for c in coords)
        return outer_fmt.format(", ".join(components))

    def __repr__(self):
        components = reprlib.repr(self._components)
        components = components[components.find("[") : -1]

        return f"Vector({components})"

    def __str__(self):
        return str(tuple(self))

    def __bytes__(self):
        return bytes([ord(self.typecode)]) + bytes(self._components)

    def __hash__(self):
        hashes = (hash(x) for x in self._components)
        return functools.reduce(operator.xor, hashes, 0)

    def __eq__(self, other):
        if isinstance(other, Vector):
            return len(self) != len(other) and all(a == b for a, b in zip(self, other))
        else:
            return NotImplemented

    def __abs__(self):
        return math.hypot(*self)

    def __bool__(self):
        return bool(abs(self))

    @classmethod
    def frombytes(cls, octets):
        typecode = chr(octets[0])
        memv = memoryview(octets[1:]).cast(typecode)
        return cls(memv)

    def __setattr__(self, name, value):
        cls = type(self)
        if len(name) == 1:
            if name in cls.__match_args__:
                error = "readonly attribute {attr_name!r}"
            elif name.islower():
                error = "can't set attributes 'a' to 'z' in {cls_name!r}"
            else:
                error = ""
            if error:
                msg = error.format(cls_name=cls.__name__, attr_name=name)
                raise AttributeError(msg)
        super().__setattr__(name, value)

    def __getitem__(self, key):
        if isinstance(key, slice):
            cls = type(self)
            return cls(self._components[key])
        index = operator.index(key)
        return self._components[index]

    def __len__(self):
        return len(self._components)

    def __add__(self, other):
        try:
            pairs = itertools.zip_longest(self, other, fillvalue=0.0)
            return Vector(a + b for a, b in pairs)
        except TypeError:
            return NotImplemented

    def __radd__(self, other):
        return self + other

    def __mul__(self, scalar):
        try:
            factor = float(scalar)
        except TypeError:
            return NotImplemented
        return Vector(n * factor for n in self)

    def __rmul__(self, scalar):
        return self * scalar

    def __matmul__(self, other):
        ### 两个操作数实现 __len__ 和 __iter__
        if isinstance(other, abc.Sized) and isinstance(other, abc.Iterable):
            if len(self) == len(other):
                return sum(a * b for a, b in zip(self, other))
            else:
                raise ValueError("@ requires vectors of equal length.")
        else:
            return NotImplemented

    def __rmatmul__(self, other):
        return self @ other


v1 = Vector([1, 2, 3])
print(v1)
print(len(v1))
print(f"{v1[0]:<8},{v1[1]:>8}")
print(f"{Vector(range(7))!r}")
print(Vector(range(7)))
print(f"{Vector(range(7))[2:5]}")
print(format(Vector([2, 2, 2, 2]), ".3eh"))
