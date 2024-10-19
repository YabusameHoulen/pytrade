# python 使用 type 类 创建class, 可以用type 动态创建 class


class Student:
    def greeting(self):
        print("Hello Student")


print(type(Student))
print(isinstance(Student, type))

class_body = """
def greeting(self):
    print("Hello customer")
    
def jump(self):
    print("Jump")
"""

class_dict = {}

exec(class_body, globals(), class_dict)

Customer = type("Consumer", (object,), class_dict)

c = Customer()
c.greeting()
c.jump()