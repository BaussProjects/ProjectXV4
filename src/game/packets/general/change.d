module packets.general.change;

import enums.pkmode;
import enums.action;
import enums.angle;

import entities.gameclient;
import packets.generaldata;

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

/**
*	Handles the general data packet.
*	Sub-type: changeDirection
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
void handleChangeDirection(GameClient client, GeneralDataPacket packet) {
	client.direction = cast(Angle)packet.direction;
	client.updateSpawn(packet);
}

/**
*	Handles the general data packet.
*	Sub-type: changeAction
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
void handleChangeAction(GameClient client, GeneralDataPacket packet) {
	auto action = cast(Action)cast(ubyte)packet.dwParam1;
	client.action = action;
	client.updateSpawn(packet);
}