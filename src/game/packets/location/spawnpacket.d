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