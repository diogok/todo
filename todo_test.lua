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

-- test sync
couch = 'http://localhost:5984'
os.execute('curl -X PUT '.. couch ..'/test_todo')
os.execute('cd couch && ./push.sh dev test_todo nopass')
rdb = couch .. "/test_todo"

add(db,"Foo")
add(db,"Bar")
add(db,"Baz")
sync(db,rdb)

-- test nothing lost
items = list(db)
assert(items[1][3] == "Foo")
assert(items[3][3] == "Baz")

-- test is up there
os.execute("curl ".. couch .. "/test_todo/_design/app/_list/csv/by_time > couch.db");
items = list("couch.db")
assert(items[1][3] == "Foo")
assert(items[3][3] == "Baz")

os.execute('curl -X DELETE '.. couch ..'/test_todo')
os.remove("test.db")
os.remove("couch.db")

print("Passed");
