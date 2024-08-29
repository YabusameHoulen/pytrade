### 上下文管理器
import os

# def change_dir(path):
#     os.chdir(path)


# with change_dir("/PyKnowledge") as old_dir:
#     print(f"old dir is {old_dir}")
#     print(f"current dir is {os.getcwd()}")


print(f"after change the dir is {os.getcwd()}")


### 使用 @contextmanager 来进行管理
from contextlib import contextmanager

@contextmanager 
def new_change_dir(path):
    old_dir = os.getcwd()
    os.chdir(path)
    try:
        yield old_dir ### 相当于用with 中包含的所有语句来替换yield语句
    except ZeroDivisionError:
        pass

    os.chdir(old_dir)

with new_change_dir(".\PyKnowledge") as old_dir:
    print(f"old dir is {old_dir}")
    1/0
    print(f"current dir is {os.getcwd()}")

print(f"after change the dir is {os.getcwd()}")