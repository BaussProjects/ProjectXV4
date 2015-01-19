module packets.packethandler;

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
	update = 1017,
	groundobject = 1101
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
	packet.go(2);
	ushort ptype = packet.read!ushort;
	switch (ptype) {
	
		aswitch ptype game\packets @Packet client,packet
		
		default: {
			import std.stdio : writeln;
			writeln("Unknown packet: ", ptype);
			break;
		}
	}
}