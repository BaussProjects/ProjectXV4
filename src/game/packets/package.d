module packets;

import network.packet : DataPacket;
import entities.gameclient;

/**
*	Enumeration of the packet types.
*/
enum PacketType : ushort {
	createCharacter = 1001,
	message = 1004,
	movement = 1005,
	characterinfo = 1006,
	datetime = 1033,
	authmessage = 1052,
	item = 1008,
	itemUsage = 1009,
	generaldata = 1010,
	entityspawn = 1014,
	update = 10017
}

/**
*	The packet attribute.
*/
struct Packet {
public:
	PacketType type;
}

/**
*	The packet handler.
*	Params:
*		client =	The auth client.
*		packet =	The packet.
*/
void handlePackets(GameClient client, DataPacket packet) {
	import packets.authmessage;
	import packets.message;
	import packets.createcharacter;
	import packets.generaldata;
	import packets.movement;
	import packets.itemusage;

	packet.go(2);
	ushort ptype = packet.read!ushort;
	switch (ptype) {
		/* implement __traits ... [Currently only works with a single module idk why... */
		case PacketType.authmessage: handleAuthMessage(client, packet); break;
		case PacketType.message: handleMessage(client, packet); break;
		case PacketType.createCharacter: handleCreateCharacter(client, packet); break;
		case PacketType.generaldata: handleGeneralData(client, packet); break;
		case PacketType.movement: handleMovement(client, packet); break;
		case PacketType.itemUsage: handleItemUsage(client, packet); break;
		
		default: {
			import std.stdio : writeln;
			writeln("Unknown packet: ", ptype);
			break;
		}
	}
}