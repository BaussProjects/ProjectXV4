module packets;

public {
	// imports ...
	import packets.authrequest;
}

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
void handlePackets(AuthClient client, DataPacket packet) {
	packet.go(2);
	ushort ptype = packet.read!ushort;
	switch (ptype) {
		mixin(getPacketHandlers);
		
		case 1052: break; // ... :/ ???
		
		default: {
			import std.stdio : writeln;
			writeln("Unknown packet: ", ptype);
			break;
		}
	}
}

/**
*	Gets the packet handlers.
*	USE THIS WITH mixin() only!
*/
private string getPacketHandlers()
{
	import std.string : format;
	import std.array : join, split;
	import std.conv : to;
	import std.algorithm : startsWith;
	import std.traits;
	
	string[] cases;
	
	foreach (phandler; __traits(allMembers, packets)) {
		static if (mixin ("isCallable!" ~ phandler)) {
			foreach (pattr; mixin (format("__traits(getAttributes, %s)", phandler))) {
				static if (startsWith(pattr.stringof, "Packet")) { // static if (is(pattr == Packet)) does not seem to work :/
					auto fname = split(phandler.stringof, "\"")[1];
					cases ~= format("case %s: %s(client, packet); break;", to!string(cast(ushort)pattr.type), fname);
				}
			}
		}
	}
	return join(cases, "\n");
}