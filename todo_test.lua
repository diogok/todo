#!/usr/bin/lua

dofile("todo.lua")

os.remove("test.db")
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
os.execute("curl -s -X DELETE ".. couch .."/test_todo > /dev/null ")
os.execute('curl -s -X PUT '.. couch ..'/test_todo > /dev/null')
os.execute('cd couch && ./push.sh dev test_todo nopass > /dev/null')
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
os.execute("curl -s ".. couch .. "/test_todo/_design/app/_list/csv/by_time > couch.db")
items = list("couch.db")
assert(items[1][3] == "Foo")
assert(items[3][3] == "Baz")

-- change up there
items[1][4] = "done"
os.execute("curl -s ".. couch .."/test_todo -X POST -d '".. jsonfy(items[1]) .."' -H 'Content-Type: application/json' > /dev/null")
sync(db,rdb)
os.execute("curl -s ".. couch .. "/test_todo/_design/app/_list/csv/by_time > couch.db")
items = list("couch.db")
assert(items[1][4] == "done")
assert(items[3][4] == "todo")
items = list(db)
assert(items[1][4] == "done")
assert(items[3][4] == "todo")

-- change here
done(db,2)
sync(db,rdb)
os.execute("curl -s ".. couch .. "/test_todo/_design/app/_list/csv/by_time > couch.db")
items = list("couch.db")
assert(items[1][4] == "done")
assert(items[2][4] == "done")

-- change both
done(db,3)
items[1][4] = "done"
os.execute("curl -s ".. couch .."/test_todo -X POST -d '".. jsonfy(items[1]) .."' -H 'Content-Type: application/json' > /dev/null")
sync(db,rdb)
-- is there right?
os.execute("curl -s ".. couch .. "/test_todo/_design/app/_list/csv/by_time > couch.db")
items = list("couch.db")
assert(items[1][4] == "done")
assert(items[2][4] == "done")
assert(items[3][4] == "done")
-- is here right?
items = list(db)
assert(items[1][4] == "done")
assert(items[2][4] == "done")
assert(items[3][4] == "done")


os.execute("curl -s -X DELETE ".. couch .."/test_todo")
os.remove("test.db")
os.remove("couch.db")

print("Passed");
