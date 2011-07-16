#!/usr/bin/lua

dofile("todo.lua")

props = {
    [ "Foo" ]="Bar",
    [ "Yo" ]="Eu"
}
os.remove("tmprc")
writeConfig("tmprc", props)
props2 = readConfig("tmprc")
assert(props2["Foo"] == "Bar")
assert(props2["Yo"] == "Eu")
os.remove("tmprc")

db = "http://localhost:5984/todo_test" 
props = {
    [ "localCouch" ]= "http://localhost:5984",
    [ "localDb" ] = "todo_test",
    [ "remoteCouch" ] = "http://localhost:5984"
}
config("tmprc",props)

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
os.remove("tmprc")

print("Passed");
