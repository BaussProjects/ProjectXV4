module network.handlers;

import client.authclient;
import network.packet;

/**
*	The handler for new connections.
*	Params:
*		client =	The connected auth client.
*/
void handleConnect(AuthClient client) {
	import std.stdio : writefln;
	writefln("New connection from %s", client.address);
}

/**
*	The handler for a received packet.
*	Params:
*		client =	The auth client.
*		packet =	The received packet.
*/
void handleReceive(AuthClient client, DataPacket packet) {
	import packets : handlePackets;
	handlePackets(client, packet);
}

/**
*	The handler for disconnections.
*	Params:
*		client =	The disconnected auth client.
*		reason =	The reason for the disconnection.
*/
void handleDisconnect(AuthClient client, string reason) {
	// ...
}