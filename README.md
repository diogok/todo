# TODO

Simplest possible TODO list management tool.

## Dependencies

todo uses local couchdb as storage, how to install:

    $ sudo aptitude install couchdb

## Installing 

Download [todo](http://github.com/diogok/todo/raw/master/todo.lua), put it in your path and add executable permission:

    $ wget http://github.com/diogok/rodo/raw/master/todo.lua -O todo
    $ chmod +x todo
    $ sudo mv todo /usr/bin/todo

You must configure it so it creates the databases needed, only on first run (config will be writen to ~/.todorc):

    $ todo -c

## Usage

To add an item:
    
    $ todo Must test this awesome tool

To list the todo list:

    $ todo
    01 - Must test this awesome tool

To "done" an item:
    
    $ todo -d 01

That's it(for now...)!

