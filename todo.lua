#!/usr/bin/env lua

function add(db,item) 
end

function done(db,number)
end

function list(db)
    local list = {}
    return list
end


if arg[0] == "todo.lua" or arg[0] == "todo" then
    local db = "~/.todo.db"

    if arg[1] == "-h" or arg[1] == "--help" then
        print("Usage:  todo # list items")
        print("\ttodo description# add description to todo list")
        print("\ttodo -d 01 # mark item 01 as done")
    elseif arg[1] == "-d" or arg[1] == "--done" then
        done(db,arg[2])
        print("Ok, done.")
    elseif arg[1] ~= nil then
        local item = table.concat(arg," ")
        add(db,item)
        print("Ok, added.")
    else
        print("Ok, listing.")
        local items = list(db)
        for k, v in pairs(items) do
            print(k .. " - " .. v)
        end
    end
end
