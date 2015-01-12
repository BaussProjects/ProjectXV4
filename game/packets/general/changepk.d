module packets.general.changepk;

import packets.generaldata;
import entities.gameclient;

import enums.pkmode;

/**
*	Handles the general data packet.
*	Sub-type: changePkMode
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
void handleChangePK(GameClient client, GeneralDataPacket packet) {
	auto mode = cast(PKMode)(packet.dwParam1 > 3 ? 3 : packet.dwParam1);
	client.pkMode = mode;
	client.send(packet);
}