# TODO

Simplest possible TODO list management tool.

## General

todo is a simple tool for managing simple todo lists. It works registering you todo items, listing it, marking items done and synchronizing it with diferents machines and the cloud.

You can use the standalone command-line (CLI) version (see below), the web version an soon mobile versions of it. To be able to sync your machines you must register on [online todo list](http://todoist.iriscouch.com/todo_master/_design/site/index.html) and them you are ready to go.

The standalone, mobile and local web ui work offline.

Built with CouchDB, zepto.js and Lua.

## Web

Go and access the web version of your [online todo list](http://todoist.iriscouch.com/todo_master/_design/site/index.html), there you can either register or login, and them start to manage your items todo.

Once you register you will have your database created and the web app replicated, them you will be able to sync between different machines.

On login you will be redirected to your specific database.

Changes on your database will appear live on the app, no need to refresh.

## Desktop (CLI)

### Dependencies

todo is written in lua, uses local couchdb as storage, and curl to comunicate with it, here is how to install both:

    $ sudo aptitude install couchdb curl lua5.1

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
