cobralovelib
============

This is just a collection of libs that I've created over the past week to help with Ludum Dare. Some of it is generic enough Lua that it could be used elsewhere, but for the most part, it is all Love2D related (or at least uses Love2D functions for various things).


camera.lua
------------

The start to a basic camera. It still needs some work, as it doesn't handle drawing objects other than a centered one (the player).

keyhandler.lua
------------

Basic keyhandler. Just reads in and writes to an XML file of keys, which must have been created beforehand. See the keys.xml file for an example.

loader.lua
------------

Loads in a Tiled map, and parses the XML into a more useable format. Not really any better than other ones that I saw, but I wanted to write my own one.

menuhandler.lua
------------

Start to a menu handling system. Handles drawing of menu nodes, and traversal of nodes by key press. Kinda depends on keyhandler.lua even though it doesn't call it.

Menu nodes can have a display name that can be a string or a function, if the node needs to have an updating name. You can do some fun stuff with that, along with closures.

player.lua
------------

Start to a player type class. Needs a lot of work.

screenhandler.lua
------------

Simple but useful (I think) start to a screen handler. Currently, takes in screen tables and manages the current screen, along with switching between screens. 
I'll probably add stuff like a background buffer if the screen should be a popup with a transparent back.

shapes.lua
------------

Beginning of a shape and collision library. Only has Rects and Circles, and right now only collision between two circles is implented.

tileset.lua
------------

Handles setting up Quads for a tileset image, and drawing those quads. The draw part of it takes either a tile number, or the X and Y coords of the tile on the tilemap.
The more advanced part of it, XMLTileset, reads in an XML file with the animations states in it, so they can be looked up in a table instead of just having number scattered through the code to represent states.

utils.lua
------------

All the functions that didn't fit other places. There is basic documentation above each function.

vector.lua
------------

Just your average 2D (x,y) vector lib. Has all the basic stuff...

xml.lua
------------

A nice XML reader (not mine... I've added credits to the function), and a really lame XML writer (Mainly just for the keyhandler lib)
