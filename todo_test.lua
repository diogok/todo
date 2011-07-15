#!/usr/bin/lua

dofile("todo.lua")

os.remove("test.db")
db = "http://localhost:5984/todo_test" 
os.execute("curl -X DELETE ".. db)

setup(db)
os.execute("cd couch && ./push.sh dev todo_test nopass")

add(db,"Foo")
add(db,"Bar")
list0 = list(db)
assert(list0[1][3] == "Foo")
assert(list0[2][3] == "Bar")

done(db,1)
list1 = list(db)
for k,v in pairs(list1) do
    if v[3] == "Foo" then assert(v[4] == "done") end
    if v[3] == "Bar" then assert(v[4] == "todo") end
end

os.execute("curl -X DELETE ".. db)

print("Passed");
