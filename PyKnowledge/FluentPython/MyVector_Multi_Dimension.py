from array import array
import reprlib
import math
import operator

class Vector:
    typecode = "d"

    def __init__(self, components):
        self._components = array(self.typecode, components)

    def __iter__(self):
        return iter(self._components)

    def __repr__(self):
        components = reprlib.repr(self._components)
        components = components[components.find("[") : -1]

        return f"Vector({components})"

    def __str__(self):
        return str(tuple(self))

    def __bytes__(self):
        return bytes([ord(self.typecode)]) + bytes(self._components)

    def __eq__(self, other):
        return tuple(self) == tuple(other)

    def __abs__(self):
        return math.hypot(*self)

    def __bool__(self):
        return bool(abs(self))

    @classmethod
    def frombytes(cls, octets):
        typecode = chr(octets[0])
        memv = memoryview(octets[1:]).cast(typecode)
        return cls(memv)

    def __getitem__(self, key):
        if isinstance(key,slice):
            cls = type(self)
            return cls(self._components[key])
        index = operator.index(key)
        return self._components[index]

    def __len__(self):
        return len(self._components)
    


v1 = Vector([1,2,3])
print(v1)
print(len(v1))
print(f"{v1[0]:<8},{v1[1]:>8}")
print(f"{Vector(range(7))!r}")
print(Vector(range(7)))
print(f"{Vector(range(7))[2:5]}")