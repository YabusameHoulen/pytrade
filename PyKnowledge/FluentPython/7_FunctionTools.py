from functools import reduce
from operator import mul


def factorial(n):
    return reduce(mul, range(1, n + 1))


print(factorial(5))  # 120

### sort by the third element of a tuple

metro_data = [
    ("Mexico City", "MX", 20.142, (19.433333, -99.133333)),
    ("Tokyo", "JP", 36.933, (35.689722, 139.691667)),
    ("Delhi NCR", "IN", 21.935, (28.613889, 77.208889)),
    ("New York-Newark", "US", 20.104, (40.808611, -74.020386)),
    ("São Paulo", "BR", 19.649, (-23.547778, -46.635833)),
]

print(sorted(metro_data, key=lambda x: x[2]))

from operator import itemgetter
print("\n")
print(sorted(metro_data, key=itemgetter(2)))

cc_name = itemgetter(1, 0)
for city in metro_data:
    print(cc_name(city))