module packets.authmessage;

import entities.gameclient;
import network.packet;
import packets.messagecore;
import core.msgconst;

/**
*	The auth message packet.
*/
class AuthMessagePacket : DataPacket {
private:
	/**
	*	The entity uid.
	*/
	uint m_entityUID;
	/**
	*	The key.
	*/
	uint m_key;
public:
	/**
	*	Creates a new instance of AuthMessagePacket.
	*	Params:
	*		packet =	The packet.
	*/
	this(DataPacket packet) {
		super(packet);
		
		go(4); // Skips size and type
		m_entityUID = read!uint; // Offset 4
		m_key = read!uint; // Offset 8
	}
	
	@property {
		/**
		*	Gets the entity uid.
		*/
		uint entityUID() { return m_entityUID; }
		
		/**
		*	Gets the key.
		*/
		uint key() { return m_key; }
	}
}

import packets.packethandler : Packet, PacketType;
/**
*	Handles the auth message packet.
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
@Packet(PacketType.authmessage) void handleAuthMessage(GameClient client, DataPacket packet) {
	scope auto auth = new AuthMessagePacket(packet);
	
	if (auth.entityUID == 0 || auth.key == 0) {
		client.disconnect();
		return;
	}
	
	client.crypto.setKeys(auth.entityUID, auth.key);
	
	import database.playerdatabase;
	bool success;
	string account = getAccountName(auth.entityUID, success);
	if (!success || playerBanned(account)) {
		client.send(createLoginMessage(ANSWER_NO));
		return;
	}
	client.account = account;
	client.entityUID = auth.entityUID;
			
	if (playerExists(account)) {
		client.setDb();
		
		if (loadPlayer(client)) {
			client.send(createLoginMessage(ANSWER_OK));
			import packets.datetime;
			import packets.characterinfo;
			client.send(new CharacterInfoPacket(client));
			client.send(new DateTimePacket());
		}
		else
			client.send(createLoginMessage(LOAD_FAIL));
	}
	else {
		client.send(createLoginMessage(NEW_ROLE));
	}
}