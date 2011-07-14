#!/usr/bin/env lua

function explode(line,mark)
    local parts = {}
    for p in string.gmatch(line,"[^".. mark .."]+") do
        table.insert(parts,p)
    end
    return parts
end

function add(db,item) 
    local time = os.time();
    local value = string.gsub(item,";",",");

    local file,r = io.open(db,"a");
    file:write(time .. ";" .. time .. ";" .. value .. ";todo\n")
    file:close()
end

function done(db,n)
    local items = list(db)

    local file = io.open(db,"w+")
    for k, v in pairs(items) do
        if k == tonumber(n) then
            v[4] = "done"
            v[2] = os.time()
        end
        file:write(table.concat(v,";") .. "\n")
    end

    file:close()
end

function list(db)
    local list = {}

    local file = io.open(db,"r")
    for l in file:lines() do
        table.insert(list,explode(l,";"))
    end
    file:close()

    return list
end

function sync(db,remote)
    -- TODO: get remote list 
    --       -> if they have ids I don't insert      ;
    --       -> if I have ids they don't post        ;
    --       -> if I have newer timestamp, put       ;
    --       -> if they have newer timestamp, update ;
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
