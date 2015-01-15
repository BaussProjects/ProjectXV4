module packets.messagecore;

import packets.message;
import core.color;

/**
*	Creates a login message.
*	Params:
*		msg =	The message.
*	Returns: The newly created message.
*/
auto createLoginMessage(string msg) {
		return new MessagePacket(MessageType.entrance, Colors.white, "SYSTEM", "ALLUSERS", msg, 0, 0, 0);
}

/**
*	Creates a character creation message.
*	Params:
*		msg =	The message.
*	Returns: The newly created message.
*/
auto createCharacterCreationMessage(string msg) {
		return new MessagePacket(MessageType.register, Colors.white, "SYSTEM", "ALLUSERS", msg, 0, 0, 0);
}

/**
*	Creates a system #1 message.
*	Params:
*		msg =	The message.
*	Returns: The newly created message.
*/
auto createSystemMessage(string msg) {
		return new MessagePacket(MessageType.talk, Colors.red, "SYSTEM", "YOU", msg, 0, 0, 0);
}

/**
*	Creates a system #2 message.
*	Params:
*		msg =	The message.
*	Returns: The newly created message.
*/
auto createSystemMessage2(string msg) {
		return new MessagePacket(MessageType.topleft, Colors.red, "SYSTEM", "YOU", msg, 0, 0, 0);
}