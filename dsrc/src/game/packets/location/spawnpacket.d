module packets.spawnpacket;

import network.packet;
import packets : Packet, PacketType;
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
	this(uint uid, uint id, ushort x, ushort y, ItemDropType dropType) {
		super(PacketType.groundobject, 20);
		
		write!uint(uid);
		write!uint(id);
		write!ushort(x);
		write!ushort(y);
		write!ushort(cast(ushort)dropType);
	}
}