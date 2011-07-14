#!/usr/bin/env lua

function explode(line,mark)
    local parts = {}
    for p in string.gmatch(line,"[^".. mark .."]+") do
        table.insert(parts,p)
    end
    return parts
end

function addItem(db,item)
    local file,r = io.open(db,"a");
    file:write(table.concat(item,";") .."\n")
    file:close()
end

function add(db,item) 
    local time = os.time();
    local id = time .. "_".. tostring(table.maxn(list(db))) .."_".. string.sub(os.tmpname(),10);
    local value = string.gsub(item,";",",");
    addItem(db,{id, time,value,"todo"})
end

function updateItem(db,n,item)
    local items = list(db)

    local file = io.open(db,"w+")
    for k, v in pairs(items) do
        if k == n then
            file:write(table.concat(item,";") .. "\n")
        else
            file:write(table.concat(v,";") .. "\n")
        end
    end

    file:close()
end

function done(db,n)
    local items = list(db)
    for k, v in pairs(items) do
        if k == tonumber(n) then
            v[4] = "done"
            v[2] = os.time()
            updateItem(db,k,v);
        end
    end
end

function list(db)
    local list = {}

    local file = io.open(db,"r")
    if file ~= nil then
        for l in file:lines() do
            table.insert(list,explode(l,";"))
        end
        file:close()
    end

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

function get(base,file) 
    os.execute("curl -s ".. base .. "/_design/app/_list/csv/by_time > ".. file)
end

function post(base,file)
    os.execute("curl -s -X POST ".. base .."/_bulk_docs -d @" .. file .. " -H 'Content-Type: application/json' > /dev/null ")
end

function sync(db,remote)
    local tmp = os.tmpname()
    get(remote,tmp)
    remoteItems = list(tmp)
    localItems = list(db)
    os.remove(tmp)

    for rKey, rValue in pairs(remoteItems) do
        local toAddLocal = true
        for lKey, lValue  in pairs(localItems) do
            if lValue[0] == rValue[0] then toAddLocal = false end
        end
        if toAddLocal then addItem(db,rValue) end
    end

    for rKey, rValue in pairs(remoteItems) do
        for lKey, lValue in pairs(localItems) do
            if lValue[1] == rValue[1] and rValue[2] >= lValue[2] and lValue[4] ~= "done" then 
                updateItem(db,lKey,rValue)
            end
        end
    end

    local toGo = {}
    for lKey, lValue in pairs(localItems) do
        local toAddRemote = true
        for rKey, rValue in pairs(remoteItems) do
            if lValue[1] == rValue[1] then toAddRemote = false end
        end
        if toAddRemote then  table.insert(toGo,lValue) end
    end

    for lKey, lValue in pairs(localItems) do
        for rKey, rValue in pairs(remoteItems) do
            if lValue[1] == rValue[1] and lValue[4] == "done" then
                lValue[5] = rValue[5]
                table.insert(toGo,lValue)
            elseif lValue[1] == rValue[1] and lValue[2] > rValue[2] then
                lValue[5] = rValue[5]
                table.insert(toGo,lValue)
            end
        end
    end

    local toWrite = {}
    for k,v in pairs( toGo ) do
        local json = jsonfy(v)
        table.insert(toWrite,json)
    end

    local wtmp = os.tmpname()
    local file = io.open(wtmp,"w");
    file:write('{"docs":['.. table.concat(toWrite,",") ..']}')
    file:close()
    post(remote,wtmp)
end


if arg[0] == "todo.lua" or arg[0] == "todo" then
    local db = os.getenv("HOME") ..  "/.todo.db"
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
