module main;

import std.stdio : writeln;

import network.server;

/**
*	The entry point of the game server.
*/
void main() {
	import database.serverdatabase;
	writeln("Loading database ...");
	if (!loadDatabase())
		return;
	writeln("Database loaded!");
	run("192.168.0.15", 5816);
}