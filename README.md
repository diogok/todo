# TODO

Simplest possible TODO list management tool.

## Geral

todo is a simple tool for managing simple todo lists. It works registering you todo items, listing it, marking itens done and synchronizing it with diferents machine and the cloud.

You can use the standalone command-line (CLI) version (see below), the web version an soon mobile versions of it. To be able to sync your machines you must register on [online todo list](http://todoist.iriscouch.com/todo_master/_design/site/index.html) and them you are ready to go.

Built with CouchDB, zepto.js and Lua.

## Web

To access the web version of your [online todo list](http://todoist.iriscouch.com/todo_master/_design/site/index.html), there you can either register or login.

Once you register you have you database created and web app replicated, and will be able to sync different machines.

On login you will be redirected to your specific databse.

## Desktop (CLI)

### Dependencies

todo uses local couchdb as storage, and curl to comunicate with it, how to install:

    $ sudo aptitude install couchdb curl

### Installing 

Download [todo](http://github.com/diogok/todo/raw/master/todo.lua), put it in your path and add executable permission:

    $ wget http://github.com/diogok/rodo/raw/master/todo.lua -O todo
    $ chmod +x todo
    $ sudo mv todo /usr/bin/todo

You must configure it so it creates the databases needed, only on first run (config will be writen to ~/.todorc):

    $ todo -c

This will create a database for your user and download need data from the web.

### Usage

To add an item:
    
    $ todo Must test this awesome tool

To list the todo list:

    $ todo
    01 - Must test this awesome tool

To "done" an item:
    
    $ todo -d 01

To open a nice interface on browser:

    $ todo -w

To sinchronize with web version (will ask for username and password):

    $ todo -s 

That's it(for now...)!
