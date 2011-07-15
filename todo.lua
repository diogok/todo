#!/usr/bin/env lua

function explode(line,mark)
    local parts = {}
    for p in string.gmatch(line,"[^".. mark .."]+") do
        table.insert(parts,p)
    end
    return parts
end

function addItem(db,item)
    local json = jsonfy(item)
    local tmp = os.tmpname()
    local file = io.open(tmp,"w")
    file:write(json)
    file:close()
    post(db,tmp)
    os.remove(tmp)
end

function add(db,content) 
    local time = os.time();
    local id = time .. "_".. tostring(table.maxn(list(db))) .."_".. string.sub(os.tmpname(),10);
    local value = string.gsub(content,";",",");
    addItem(db,{id, time,value,"todo"})
end

function updateItem(db,item)
    local json = jsonfy(item)
    local tmp = os.tmpname()
    local file = io.open(tmp,"w")
    file:write(json)
    file:close()
    post(db,tmp)
    os.remove(tmp)
end

function done(db,n)
    local items = list(db)
    for k, v in pairs(items) do
        if k == tonumber(n) then
            v[4] = "done"
            v[2] = os.time()
            updateItem(db,v);
        end
    end
end

function list(db)
    local list = {}
    local tmp = os.tmpname()
    get(db,tmp)

    local file = io.open(tmp,"r")
    if file ~= nil then
        for l in file:lines() do
            table.insert(list,explode(l,";"))
        end
        file:close()
    end

    os.remove(tmp)
    return list
end

function item2json(item) 
    if item[5] ~= nil then
        return '{"_id":"'.. item[1] ..'","_rev":"'.. item[5] ..'","timestamp":"'.. item[2] ..'","content": "'.. item[3] ..'","status":"'.. item[4] ..'"}'
    else
        return '{"_id":"'.. item[1] ..'","timestamp":"'.. item[2] ..'","content": "'.. item[3] ..'","status":"'.. item[4] ..'"}'
    end
end

function jsonfy(item)
    return string.gsub(item2json(item),"'","\\'")
end

function get(couch,file) 
    os.execute("curl -s ".. couch .."/_design/app/_list/csv/ordered > ".. file)
end

function post(couch,file)
    os.execute("curl -s -X POST ".. couch .." -d @" .. file .. " -H 'Content-Type: application/json' > /dev/null ")
end

function sync(db,remote)
end

function setup(db)
    os.execute("curl -s -X PUT ".. db .." > /dev/null")
end

if arg[0] == "todo.lua" or arg[0] == "todo" then
    local db = "http://localhost:5984/todo" 
    local remote = "http://manifesto.couchone.com/";

    if arg[1] == "-h" or arg[1] == "--help" then
        print("Usage:  todo # list items")
        print("\ttodo description# add description to todo list")
        print("\ttodo -d 01 # mark item 01 as done")
    elseif arg[1] == "-d" or arg[1] == "--done" then
        done(db,arg[2])
        print("Ok, done.")
    elseif arg[1] == "-s" or arg[1] == "--sync" then
    elseif arg[1] ~= nil then
        local item = table.concat(arg," ")
        add(db,item)
        print("Ok, added.")
    else
        print("Ok, listing.")
        local items = list(db)
        for k, v in pairs(items) do
            if v[4] == "todo" then
                print(k .. " - " .. v[3])
            end
        end
    end
end
