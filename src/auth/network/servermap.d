module network.servermap;

import io.inifile;

/**
*	The server map.
*/
private shared string[string] serverMap;

/**
*	Loads the servers.
*/
void loadServers() {
	scope auto ini = new IniFile!(true)("database\\auth\\servers.ini");
	if (!ini.exists())
		return;
	ini.open();
	
	string[string] servers;
	foreach (serverName; ini.keys) {
		servers[serverName] = ini.read!string(serverName);
	}
	serverMap = cast(shared(string[string]))servers;
}

/**
*	Checks whether a server exists.
*	Returns: True if the server exists.
*/
bool serverExists(string serverName) {
	synchronized {
		auto servers = cast(string[string])serverMap;
		return !(servers.get(serverName, null) is null);
	}
}

/**
*	Gets the address of a server.
*	Returns: The address of the server.
*/
auto getAddress(string serverName) {
	import std.array : split;
	
	synchronized {
		auto servers = cast(string[string])serverMap;
		return split(servers[serverName], ":");
	}
}