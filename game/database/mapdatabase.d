module database.mapdatabase;

import std.file;
import std.algorithm : endsWith;

import maps.map;
import enums.maptype;
import io.inifile;

/**
*	Loads map info.
*/
void loadMaps() {
	foreach (string f; dirEntries("database\\game\\maps", SpanMode.depth))
	{
		if (endsWith(f, ".ini")) {
			scope auto ini = new IniFile!(true)(f);
			if (!ini.exists())
				return;
			ini.open();
			
			ushort mapId = ini.read!ushort("MapID");
			ushort inheritanceId = ini.read!ushort("Inheritance");
			auto mapType = cast(MapType)ini.read!ubyte("MapType");
			string name = ini.read!string("Name");
			
			auto map = new Map(mapId, inheritanceId, mapType, name);
			if (!mapExists(mapId)) {
				addMap(map);
			}
		}
	}
}