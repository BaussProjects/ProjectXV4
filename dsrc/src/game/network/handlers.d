module network.handlers;

import entities.gameclient;
import network.packet;

/**
*	The handler for new connections.
*	Params:
*		client =	The connected game client.
*/
void handleConnect(GameClient client) {
	import std.stdio : writefln;
	writefln("New connection from %s", client.address);
}

/**
*	The handler for a received packet.
*	Params:
*		client =	The game client.
*		packet =	The received packet.
*/
void handleReceive(GameClient client, DataPacket packet) {
	import packets.packethandler : handlePackets;
	handlePackets(client, packet);
}

/**
*	The handler for disconnections.
*	Params:
*		client =	The disconnected game client.
*		reason =	The reason for the disconnection.
*/
void handleDisconnect(GameClient client, string reason) {
	import std.stdio : writefln;
	
	if (client.map !is null) {
		client.map.remove(client);
		client.clearSpawn();
		//client.clearSpawn();
	}
	
	import core.kernel;
	removeClient(client);
	
	if (!client.loaded)
		writefln("Disconnection from %s Reason: %s", client.address, reason);
	else {
		import database.playerdatabase;
		updateCharacter!ushort(client, "MapID", client.mapId);
		updateCharacter!ushort(client, "X", client.x);
		updateCharacter!ushort(client, "Y", client.y);
			
		writefln("Disconnection from %s Reason: %s", client.name, reason);
	}
}