# TODO

Simplest possible TODO list management tool.

## Usage

### CLI

Download [todo](http://github.com/diogok/todo/raw/master/todo.lua) and put it in your path, and add executable permission

    $ wget http://github.com/diogok/rodo/raw/master/todo.lua -O todo
    $ chmod +x todo
    $ sudo mv todo /usr/bin/todo

To add an item:
    
    $ todo Must test this awesome tool

To list todo list:

    $ todo
    01 - Must test this awesome tool

To "done" an item:
    
    $ todo -d 01

That's it(for now...)!
