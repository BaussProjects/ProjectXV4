module main;

import std.stdio : writeln;

import io.inifile;
import network.server;

/**
*	The settings file.
*/
private shared IniFile!(true) settingsFile;

/**
*	Gets the settings.
*/
IniFile!(true) settings() {
	return cast(IniFile!(true))settingsFile;
}

/**
*	The entry point of the game server.
*/
void main() {
	import database.serverdatabase;
	writeln("Loading database ...");
	if (!loadDatabase())
		return;
	auto ini = new IniFile!(true)("database\\game\\settings.ini");
	if (!ini.exists())
		return;
	ini.open();
	settingsFile = cast(shared(IniFile!(true)))ini;
	writeln("Database loaded!");
	run(ini.read!string("IP"), ini.read!ushort("Port"));
}