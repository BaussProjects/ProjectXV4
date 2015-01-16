module packets.packethandler;

import network.packet : DataPacket;
import client.authclient;

/**
*	Enumeration of the packet types.
*/
enum PacketType : ushort {
	authrequest = 1051,
	authresponse = 1055,
	passwordseed = 1059,
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
void handlePackets(AuthClient authClient, DataPacket packet) {
	packet.go(2);
	ushort ptype = packet.read!ushort;
	switch (ptype) {
	
		aswitch ptype auth\packets @Packet authClient,packet
		
		case 1052: break; // ... :/ ???
		
		default: {
			import std.stdio : writeln;
			writeln("Unknown packet: ", ptype);
			break;
		}
	}
}