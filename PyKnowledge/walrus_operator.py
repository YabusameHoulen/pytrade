(a := 1)
print(a)

### 海象运算符
### 这样len(l)使用了两次，在l比较大的时候有性能影响
l = [1, 2, 3]
if len(l) > 0:
    print(f"the length of l is {len(l)}")


l = [1, 2, 3]
if (n := len(l)) > 0:
    print(f"the length of l is {n}")


# while True:
#     cmd = input()
#     if cmd == "exit":
#         break
#     print(f"got input {cmd}")


# while (cmd := input()) != "exit":
#     print(f"got input {cmd}")

### Julia 不需要这个玩意， 因为Python需要区分语句和表达式


a = 2
match a:
    case 2:
        print("hello")
    case 3:
        print("world")


l = [2, 4, 6, 7, 11, 12]
print("This is a even list ? \n", all((n := i) % 2 == 0 for i in l))
print("the first none even element is ", n)
