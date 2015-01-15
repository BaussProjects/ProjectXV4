module main;

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
*	Entry point for the auth server.
*/
void main() {
	auto ini = new IniFile!(true)("database\\auth\\settings.ini");
	if (!ini.exists())
		return;
	ini.open();
	settingsFile = cast(shared(IniFile!(true)))ini;
	import network.servermap;
	loadServers();
	run(ini.read!string("IP"), ini.read!ushort("Port"));
}