module packets.general.hotkeys;

import packets.generaldata;
import entities.gameclient;

/**
*	Handles the general data packet.
*	Sub-type: hotKeys
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
void handleHotKeys(GameClient client, GeneralDataPacket packet) {
	// Load inventory ...
	client.send(packet);
}