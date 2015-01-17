module maps.mapobject;

import std.parallelism : taskPool;

import maps.map;
import enums.entitytype;
import enums.angle;
import enums.maptype;
import packets.spawnpacket;
import packets.generaldata;
import entities.gameclient;
import threading.dict;

/**
*	Map object encapsulation.
*	All entities inherits this class.
*/
class MapObject {
private:
	/**
	*	The uid.
	*/
	uint m_uid;
	
	/**
	*	The map.
	*/
	Map m_map;
	
	/**
	*	The x axis.
	*/
	ushort m_x;
	
	/**
	*	The y axis.
	*/
	ushort m_y;
	
	
	/**
	*	The last x axis.
	*/
	ushort m_lastx;
	
	/**
	*	The last y axis.
	*/
	ushort m_lasty;
	
	/**
	*	The last map.
	*/
	Map m_lastmap;
	
	/**
	*	The last map x axis.
	*/
	ushort m_lastmapx;
	
	/**
	*	The last map y axis.
	*/
	ushort m_lastmapy;
	
	/**
	*	The name.
	*/
	string m_name;
	
	/**
	*	The entity type.
	*/
	EntityType m_etype;
	
	/**
	*	The direction the object is facing.
	*/
	Angle m_direction;
	
	/**
	*	The screen locator for objects.
	*/
	Dict!(uint,MapObject) m_screenObjects;
public:
	/**
	*	Creates a new instance of MapObject.
	*	Params:
	*		etype =		The entity type of the map object.
	*/
	this(EntityType etype) {
		m_etype = etype;
		
		m_screenObjects = new Dict!(uint,MapObject);
	}
	
	@property {
		/**
		*	Gets the uid.
		*/
		uint uid() { return m_uid; }
		/**
		*	Sets the uid.
		*/
		void uid(uint value) {
			m_uid = value;
		}
		
		/**
		*	Gets the map.
		*/
		Map map() { return m_map; }
		
		/**
		*	Gets the map id.
		*/
		ushort mapId() { return m_map.mapId; }
		
		/**
		*	Gets the real map id (Inheritance.)
		*/
		ushort realMapId() { return m_map.inheritanceMap; }
		
		/**
		*	Gets the map name.
		*/
		string mapName() { return m_map.name; }
		
		/**
		*	Gets the x axis.
		*/
		ushort x() { return m_x; }
		
		/**
		*	Sets the x axis.
		*/
		void x(ushort value) {
			m_x = value;
		}
		
		/**
		*	Gets the y axis.
		*/
		ushort y() { return m_y; }
		
		/**
		*	Sets the y axis.
		*/
		void y(ushort value) {
			m_y = value;
		}
		
				/**
		*	Gets the last x axis.
		*/
		ushort lastX() { return m_lastx; }
		
		/**
		*	Sets the last x axis.
		*/
		void lastX(ushort value) {
			m_lastx = value;
		}
		
		/**
		*	Gets the last y axis.
		*/
		ushort lastY() { return m_lasty; }
		
		/**
		*	Sets the last y axis.
		*/
		void lastY(ushort value) {
			m_lasty = value;
		}
		
		/**
		*	Gets the name.
		*/
		string name() { return m_name; }
		
		/**
		*	Sets the name.
		*/
		void name(string name) {
			m_name = name;
		}
		
		/**
		*	Gets the entity type.
		*/
		EntityType etype() { return m_etype; }
		
		/**
		*	Gets the direction.
		*/
		Angle direction() { return m_direction; }
		
		/**
		*	Sets the direction.
		*/
		void direction(Angle value) {
			m_direction = value;
		}
	}

	
	import std.stdio : writeln;
	/**
	*	Teleports the map object.
	*	Params:
	*		mapId =		The map to teleport to.
	*		x =			The x coord to teleport to.
	*		y = 		The y coord to teleport to.
	*/
	void teleport(ushort mapId, ushort x, ushort y) {
		if (!map || mapId != map.mapId || etype == EntityType.player && !(cast(GameClient)this).loaded) {
			// New map ...
			auto newMap = getMap(mapId);
			if (!newMap) {
				import std.conv : to;
				newMap = new Map(mapId, mapId, MapType.safe, to!string(mapId));
				addMap(newMap);
			}
			newMap.load(mapId);
			teleport(newMap, x, y);
		}
		else if (x != m_x || y != m_y) {
			teleport(map, x, y); // New coordinates only ...
		}
	}
	
	/**
	*	Teleports the map object.
	*	Params:
	*		newMap =		The map to teleport to.
	*		x =			The x coord to teleport to.
	*		y = 		The y coord to teleport to.
	*/
	void teleport(Map newMap, ushort x, ushort y) {		
		if (m_map) {
			m_map.remove(this);
		//	clearSpawn();
		}
		
		m_map = newMap;
		newMap.add(this);
		m_x = x;
		m_y = y;
		updateSpawn();
		
		if (etype == EntityType.player) {
			import database.playerdatabase;
			auto client = cast(GameClient)this;
			if (!client.loaded)
				return;
			updateCharacter!ushort(client, "MapID", mapId);
			updateCharacter!ushort(client, "X", x);
			updateCharacter!ushort(client, "Y", y);
			
			import packets.generaldata;
			client.send(new GeneralDataPacket(uid, realMapId, x, y, direction, DataAction.setLocation));
		}
	}
	
	/**
	*	Pulls the object back to its last coordinate.
	*/
	void pullBack() {
		teleport(mapId, lastX, lastY);
	}
	
	void clearSpawn() {
		scope auto locals = (map.findLocalEntities(x, y) ~ map.findLocalItems(x, y) ~ getScreenObjects());
		if (!locals || locals.length == 0)
			return;
		m_screenObjects = null;
		
		DataPacket rmvSpawn;
		scope(exit) rmvSpawn = null;
		if (etype == EntityType.item)
			rmvSpawn = new ItemSpawnPacket(uid, 0, 0, 0, ItemDropType.remove);
		else
			rmvSpawn = new GeneralDataPacket(uid, 0, 0, DataAction.removeEntity);
			
		foreach(i, ref local; taskPool.parallel(locals)) {
			if (local.uid == uid)
				continue;
			
			if (local.m_screenObjects.contains(uid))
				local.m_screenObjects.remove(uid);
						
			if (etype == EntityType.player) {
				DataPacket localRmvSpawn;
				scope(exit) localRmvSpawn = null;
				
				if (local.etype == EntityType.item)
					localRmvSpawn = new ItemSpawnPacket(local.uid, 0, 0, 0, ItemDropType.remove);
				else
					localRmvSpawn = new GeneralDataPacket(local.uid, 0, 0, DataAction.removeEntity);
				
				auto client = cast(GameClient)this;
				client.send(localRmvSpawn);
			}
			
			if (local.etype == EntityType.player) {
				auto localClient = cast(GameClient)local;
				localClient.send(rmvSpawn);
			}
		}
	}
	
	void updateSpawn(DataPacket packet = null) {
		import packets.spawnpacket;
		
		DataPacket rmvSpawn;
		scope(exit) rmvSpawn = null;
						
		if (etype == EntityType.item)
			rmvSpawn = new ItemSpawnPacket(uid, 0, 0, 0, ItemDropType.remove);
		else
			rmvSpawn = new GeneralDataPacket(uid, 0, 0, DataAction.removeEntity);
							
		// clear screen
		scope auto scos = getScreenObjects();
		if (scos && scos.length > 0) {
			foreach (local; taskPool.parallel(scos)) {
				import maps.space;
				if (!map || !local.map
					||local.mapId != mapId ||
					!validDistance!ushort(local.x, local.y, x, y)) {
					m_screenObjects.remove(local.uid);
					if (local.m_screenObjects.contains(uid))
						local.m_screenObjects.remove(uid);
				
					if (etype == EntityType.player) {
						DataPacket localRmvSpawn;
						scope(exit) localRmvSpawn = null;
						
						if (local.etype == EntityType.item)
							localRmvSpawn = new ItemSpawnPacket(local.uid, 0, 0, 0, ItemDropType.remove);
						else
							localRmvSpawn = new GeneralDataPacket(local.uid, 0, 0, DataAction.removeEntity);
						
						auto client = cast(GameClient)this;
						client.send(localRmvSpawn);
					}
					
					if (local.etype == EntityType.player) {
						auto localClient = cast(GameClient)local;
						localClient.send(rmvSpawn);
					}
				}
			}
		}
		
		if(!map)
			return;
		
		// get new locals ...
		scope auto spawn = createSpawn();
		if (spawn is null)
			return;

		scope auto locals = (map.findLocalEntities(x, y) ~ map.findLocalItems(x, y));
		if (!locals || locals.length == 0)
			return;
		
		foreach(i, ref local; taskPool.parallel(locals)) {
			if (local.uid == uid)
				continue;
			if (etype == EntityType.player) {
				auto client = cast(GameClient)this;
				scope auto localSpawn = local.createSpawn();
				if (localSpawn)
					client.send(localSpawn);
			}
			
			if (local.etype == EntityType.player) {
				auto localClient = cast(GameClient)local;
				if (!m_screenObjects.contains(local.uid))
					localClient.send(spawn);
				
				if (packet !is null)
					localClient.send(packet);
			}
			
			if (!m_screenObjects.contains(local.uid))
				m_screenObjects.add(local.uid, local);
			
			if (!local.m_screenObjects.contains(uid)) {
				local.m_screenObjects.add(uid, this);
			}
		}
	}

	auto getScreenObjects() {
		if (m_screenObjects)
			return m_screenObjects.values;
		return null;
	}
	/**
	*	 Override this ...
	*/
	SpawnPacket createSpawn() {
		import std.conv : to;
		throw new SpawnException("createSpawn() has to be override for type: " ~ to!string(m_etype));
	}
}