module packets.general.jump;

import packets.generaldata;
import entities.gameclient;

/**
*	Handles the general data packet.
*	Sub-type: jump
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
void handleJump(GameClient client, GeneralDataPacket packet) {
	ushort newX = packet.dwParam1_low;
	ushort newY = packet.dwParam1_high;
	
	// check valid coords ...
	
	client.x = newX;
	client.y = newY;
	client.updateSpawn(packet);
}