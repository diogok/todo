=TODO=

Simplest possible TODO list management tool.

==Usage==

Download [todo.lua](todo) and put it in your path, and add executable permission

    $ wget todo.lua
    $ chmod +x todo.lua
    $ sudo mv todo.lua /usr/bin/todo

To add an item:
    
    $ todo Must test this awesome tool

To list todo list:

    $ todo
    01 - Must test this awesome tool

To "done" and item:
    
    $ todo -d 01

That's it(for now...)!
