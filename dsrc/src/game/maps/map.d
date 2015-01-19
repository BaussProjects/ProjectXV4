module maps.map;

import std.parallelism : taskPool;
import std.array;
import std.algorithm : filter;

import threading.dict;
import maps.space;
import maps.mapobject;
import enums.maptype;
import enums.entitytype;
import dinymap.tinymap;

/**
*	The dictionary for all the global maps.
*/
private shared Dict!(ushort,Map) globalMaps;

/**
*	Adds a global map.
*	Params:
*		map =	The map to add.
*/
void addMap(Map map) {
	synchronized {
		if (globalMaps is null) {
			globalMaps = new shared(Dict!(ushort,Map));
		}
		auto smaps = cast(Dict!(ushort,Map))globalMaps;
		smaps.add(map.mapId, map);
		globalMaps = cast(shared(Dict!(ushort,Map)))smaps;
	}
}

/**
*	Gets a global map.
*	Params:
*		mapId =		The map to get.
*	Returns: The map if found, otherwise null.
*/
Map getMap(ushort mapId) {
	synchronized {
		if (globalMaps is null) {
			globalMaps = new shared(Dict!(ushort,Map));
			return null;
		}
		
		auto smaps = cast(Dict!(ushort,Map))globalMaps;
		if (!smaps.contains(mapId))
			return null;
		return smaps.get(mapId);
	}
}

/**
*	Checks whether a specific map exists.
*	Params:
*		mapId =		The map id of the map to check.
*	Returns: True if the map exists.
*/
bool mapExists(ushort mapId) {
	return (getMap(mapId) !is null);
}

/**
*	A map encapsulation class.
*/
class Map : TinyMap {
private:
	/**
	*	The map id.
	*/
	ushort m_id;
	
	/**
	*	The map inheritance id.
	*/
	ushort m_inheritanceMap;
	
	/**
	*	The name.
	*/
	string m_name;
	
	/**
	*	The map type.
	*/
	MapType m_type;
	
	/**
	*	The map entities.
	*/
	Dict!(uint,MapObject) entities;
	
	/**
	*	The map items.
	*/
	Dict!(uint,MapObject) items;
public:
	/**
	*	Creates a new instance of Map.
	*	Params:
	*		id =				The id of the map.
	*		inheritanceMap =	The id to inheritance.
	*		mtype =				The type of the map.
	*		name =				The name of the map. (default = "CQMap")
	*/
	this(ushort id, ushort inhertianceMap, MapType mtype, string name = "CQMap") {
		m_id = id;
		m_name = name;
		m_inheritanceMap = inhertianceMap;
		m_type = mtype;
		
		entities = new Dict!(uint,MapObject);
		items = new Dict!(uint,MapObject);
	}
	
	@property {
		/**
		*	Gets the map id.
		*/
		ushort mapId() { return m_id; }
		
		/**
		*	Gets the inheritance map id.
		*/
		ushort inheritanceMap() { return m_inheritanceMap; }
		
		/**
		*	Gets the name.
		*/
		string name() { return m_name; }
		
		/**
		*	Gets the map type.
		*/
		MapType mtype() { return m_type; }
	}
	
	/**
	*	Adds a map object to the map.
	*	Params:
	*		mo =		The map object to add.
	*/
	void add(MapObject mo) {
		if (mo.etype == EntityType.item)
			items.add(mo.uid, mo);
		else
			entities.add(mo.uid, mo);
	}
	
	/**
	*	Removes a map object from the map.
	*	Params:
	*		mo =	The map object to remove.
	*/
	void remove(MapObject mo) {
		if (mo.etype == EntityType.item)
			items.remove(mo.uid);
		else
			entities.remove(mo.uid);
	}

	/**
	*	Finds an entity by its name.
	*	Params:
	*		name =	The name to search by.
	*	Returns: The map object of the entity, null if not found.
	*/
	auto findEntityByName(string name) {
		synchronized {
			scope auto entities = filter!(e => e.name == name)(entities.values).array;
			if (!entities || entities.length == 0)
				return null;
			return entities.front;
		}
	}
	
	/**
	*	Finds an item by its name.
	*	Params:
	*		name =	The name to search by.
	*	Returns: The map object of the item, null if not found.
	*/
	auto findItemByName(string name) {
		synchronized {
			scope auto _items = filter!(i => i.name == name)(items.values).array;
			if (!_items || _items.length == 0)
				return null;
			return _items.front;
		}
	}
	
		/**
	*	Finds an entity by its uid.
	*	Params:
	*		uid =	The uid to search by.
	*	Returns: The map object of the entity, null if not found.
	*/
	auto findEntityByUID(uint uid) {
		synchronized {
			scope auto entities = filter!(e => e.uid == uid)(entities.values).array;
			if (!entities || entities.length == 0)
				return null;
			return entities.front;
		}
	}
	
	/**
	*	Finds an item by its uid.
	*	Params:
	*		uid =	The uid to search by.
	*	Returns: The map object of the item, null if not found.
	*/
	auto findItemByUID(uint uid) {
		synchronized {
			scope auto _items = filter!(i => i.uid == uid)(items.values).array;
			if (!_items || _items.length == 0)
				return null;
			return _items.front;
		}
	}
	
	/**
	*	Finds entities within a range of a specific point.
	*	Params:
	*		x =			The x axis of the point.
	*		y =			The y axis of the point.
	*		distance =	The distance of the range.
	*	Returns: The entities found in an array.
	*/
	auto findEntitiesInRange(ushort x, ushort y, ushort distance) {
		synchronized {
			scope auto points = filter!(e => inRange!ushort(x, y, e.x, e.y, distance))(entities.values);
			return points.array;
		}
	}
	
	/**
	*	Finds items within a range of a specific point.
	*	Params:
	*		x =			The x axis of the point.
	*		y =			The y axis of the point.
	*		distance =	The distance of the range.
	*	Returns: The items found in an array.
	*/
	auto findItemsInRange(ushort x, ushort y, ushort distance) {
		synchronized {
			scope auto points = filter!(i => inRange!ushort(x, y, i.x, i.y, distance))(items.values);
			return points.array;
		}
	}
	
	/**
	*	Finds all local entities to a specific point.
	*	Params:
	*		x =			The x axis of the point.
	*		y =			The y axis of the point.
	*	Returns: The entities found in an array.
	*/
	auto findLocalEntities(ushort x, ushort y) {
		return findEntitiesInRange(x, y, 18);
	}
	
	/**
	*	Finds all local items to a specific point.
	*	Params:
	*		x =			The x axis of the point.
	*		y =			The y axis of the point.
	*	Returns: The items found in an array.
	*/
	auto findLocalItems(ushort x, ushort y) {
		return findItemsInRange(x, y, 18);
	}
	
	/**
	*	Saves the map to a map file.
	*	Params:
	*		name =		The name of the map.
	*/
	void save(string name) {
		m_name = name;
		import std.conv : to;
		import io.inifile;
		scope auto ini = new IniFile!(true)("database\\game\\maps\\" ~ m_name ~ ".ini");
		if (ini.exists())
			return;
		ini.write!ushort("MapID", m_id);
		ini.write!ushort("Inheritance", m_inheritanceMap);
		ini.write!ubyte("MapType", cast(ubyte)m_type);
		ini.write!string("Name", m_name);
		ini.close();
	}
}