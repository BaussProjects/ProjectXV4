module maps.mapobject;

import maps.map;
import enums.entitytype;
import enums.angle;
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
	*	The screen locator for entities.
	*/
	Dict!(uint,MapObject) m_screenEntities;
	
	/**
	*	The screen locator for items.
	*/
	Dict!(uint,MapObject) m_screenItems;
public:
	/**
	*	Creates a new instance of MapObject.
	*	Params:
	*		etype =		The entity type of the map object.
	*/
	this(EntityType etype) {
		m_etype = etype;
		
		m_screenEntities = new Dict!(uint,MapObject);
		m_screenItems = new Dict!(uint,MapObject);
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

	/**
	*	Teleports the map object.
	*	Params:
	*		mapId =		The map to teleport to.
	*		x =			The x coord to teleport to.
	*		y = 		The y coord to teleport to.
	*/
	void teleport(ushort mapId, ushort x, ushort y) {
		auto newMap = getMap(mapId);
		if (!newMap)
			return;
		
		if (m_map) {
			m_map.remove(this);
			clearSpawn();
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
	*	Clears the spawn.
	*/
	void clearSpawn() {
		auto locals = map.findLocalEntities(x, y);
		if (!locals || locals.length == 0)
			return;
		scope auto rmvSpawn = new GeneralDataPacket(uid, 0, 0, DataAction.removeEntity);
		
		synchronized {
			foreach (local; locals) {
				if (local.uid == uid)
					continue;
				
				bool inScreen = m_screenEntities.contains(local.uid);
				if (inScreen)
					m_screenEntities.remove(local.uid);
				
				(cast(GameClient)this).send(new GeneralDataPacket(local.uid, 0, 0, DataAction.removeEntity));
					
				if (local.etype == EntityType.player) {
					auto player = cast(GameClient)local;
					player.send(rmvSpawn);
				}
			}
		}
	}
	
	import network.packet;
	/**
	*	Updates the spawn.
	*/
	void updateSpawn(DataPacket packet = null) {
		auto locals = map.findLocalEntities(x, y);
		if (!locals || locals.length == 0)
			return;
		scope auto spawn = createSpawn();
		
		synchronized {
			foreach (local; locals) {
				if (local.uid == uid)
					continue;
				bool inScreen = m_screenEntities.contains(local.uid);
				if (!inScreen) {
					m_screenEntities.add(local.uid, local);
					
					auto client = cast(GameClient)this;
					client.send(local.createSpawn());
				}
				
				if (local.etype == EntityType.player) {
					auto player = cast(GameClient)local;
					if (!inScreen)
						player.send(spawn);
					if (packet !is null)
						player.send(packet);
				}
			}
		}
	}
	
	/**
	*	 Override this ...
	*/
	SpawnPacket createSpawn() {
		import std.conv : to;
		throw new SpawnException("createSpawn() has to be override for type: " ~ to!string(m_etype));
	}
}