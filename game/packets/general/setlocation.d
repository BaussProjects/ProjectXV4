module packets.general.setlocation;

import packets.generaldata;
import entities.gameclient;

/**
*	Handles the general data packet.
*	Sub-type: setLocation
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
void handleSetLocation(GameClient client, GeneralDataPacket packet) {
	client.send(new GeneralDataPacket(client.entityUID, client.realMapId, client.x, client.y, packet.direction, DataAction.setLocation));
	
	// load shit ...
}