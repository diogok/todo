#!/usr/bin/lua

dofile("todo.lua")

db = "test.db"

add(db,"Foo")
add(db,"Bar")
list0 = list(db)
assert(list0[1][3] == "Foo")
assert(list0[2][3] == "Bar")

done(db,1)
list1 = list(db)

assert(list1[1][4] == "done")
assert(list1[2][4] == "todo")

os.remove("test.db")

print("Passed");
