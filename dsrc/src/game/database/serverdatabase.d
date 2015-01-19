module database.serverdatabase;

/**
*	Loads the server database.
*/
bool loadDatabase() {
	try {
		import database.statsdatabase;
		loadStats();
		import database.portaldatabase;
		loadPortals();
		import database.mapdatabase;
		loadMaps();
		import database.itemsdatabase;
		loadItems();
		return true;
	}
	catch (Throwable t) {
		import std.stdio : writeln, readln;
		writeln(t);
		readln();
		return false;
	}
}