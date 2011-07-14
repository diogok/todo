# TODO

Simplest possible TODO list management tool.

## Dependencies

todo uses local couchdb as storage, how to install:

    $ sudo aptitude install couchdb

Right now it expects it to run on default port, but soon to be configurable

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
