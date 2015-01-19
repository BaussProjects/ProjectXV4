module packets.spawnpacket;

import network.packet;
import packets.packethandler : Packet, PacketType;
import core.gametime;

/**
*	Exception thrown for spawn errors.
*/
class SpawnException : Throwable {
public:
	this(string msg) {
		super(msg);
	}
}

/**
*	The general data packet.
*/
class SpawnPacket : DataPacket {
protected:
	this(ushort type, ushort size) {
		super(type, size);
	}
	this(DataPacket packet) {
		super(packet);
	}
}

/**
*	The entity spawn packet (Players + Mobs)
*	This is created within the createSpawnPacket()
*/
class EntitySpawnPacket : SpawnPacket {
public:
	this(ushort size) {
		super(PacketType.entityspawn, size);
	}
}

enum ItemDropType : ushort {
	visible = 0x01,
	remove = 0x02,
	pickup = 0x03,
	castTrap = 10,
	effect = 13
}

/*
	money,
	cps,
	item
*/
class ItemSpawnPacket : SpawnPacket {
private:
	uint m_uid;
	uint m_id;
	ushort m_x;
	ushort m_y;
	ItemDropType m_type;
public:
	this(uint uid, uint id, ushort x, ushort y, ItemDropType dropType) {
		super(PacketType.groundobject, 20);
		
		write!uint(uid);
		write!uint(id);
		write!ushort(x);
		write!ushort(y);
		write!ushort(cast(ushort)dropType);
	}
	
	this(DataPacket packet) {
		super(packet);
		
		go(4);
		m_uid = read!uint;
		m_id = read!uint;
		m_x = read!ushort;
		m_y = read!ushort;
		m_type = cast(ItemDropType)read!ushort;
	}
	
	@property {
		uint uid() { return m_uid; }
		uint id() { return m_id; }
		ushort x() { return m_x; }
		ushort y() { return m_y; }
		ItemDropType type() { return m_type; }
	}
}

import entities.gameclient;
@Packet(PacketType.groundobject) void handleGroundObject(GameClient client, DataPacket packet) {
	scope auto groundObject = new ItemSpawnPacket(packet);
	
	auto i = client.map.findItemByUID(groundObject.uid);
	if (i) {
		import data.item;
		(cast(Item)i).pickUp(client);
	}
}