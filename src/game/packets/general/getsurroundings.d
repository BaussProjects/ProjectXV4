module packets.general.getsurroundings;

import packets.generaldata;
import entities.gameclient;

/**
*	Handles the general data packet.
*	Sub-type: getSurroundings
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
void handleGetSurroundings(GameClient client, GeneralDataPacket packet) {
	// Map Info ...
	client.clearSpawn();
	client.updateSpawn();
}