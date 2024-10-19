from enum import Enum,Flag

class Permission(Flag):
    none = 0
    read = 2
    write = 4
    execute = 8
    
rw = Permission.write | Permission.write
print(rw)