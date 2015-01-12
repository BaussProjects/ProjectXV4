module packets.general.confirmassociates;

import packets.generaldata;
import entities.gameclient;

/**
*	Handles the general data packet.
*	Sub-type: confirmAssociates
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
void handleConfirmAssociates(GameClient client, GeneralDataPacket packet) {
	// Load friends & enemies
	client.send(packet);
}