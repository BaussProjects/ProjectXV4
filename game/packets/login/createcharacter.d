module packets.createcharacter;

import network.packet;
import entities.gameclient;
import enums.job;

/**
*	The create character packet.
*/
class CreateCharacterPacket : DataPacket {
private:
	/**
	*	The account name.
	*/
	string m_account;
	
	/**
	*	The character name.
	*/
	string m_character;
	
	/**
	*	The password.
	*/
	string m_password;
	
	/**
	*	The mesh.
	*/
	ushort m_mesh;
	
	/**
	*	The job.
	*/
	Job m_job;
	
	/**
	*	The entity uid.
	*/
	uint m_entityUID;
public:
	/**
	*	Creates a new instance of CreateCharacterPacket.
	*	Params:
	*		packet =	The packet.
	*/
	this(DataPacket packet) {
		super(packet);

		go(4); // Skips size and type
		m_account = readString(16);
		m_character = readString(16);
		m_password = readString(16);
		m_mesh = read!ushort;
		ushort job = read!ushort;
		if (job > ubyte.max)
			m_job = Job.unknown;
		else
			m_job = cast(Job)job;
		m_entityUID = read!uint;
	}
	
	@property {
		/**
		*	Gets the account.
		*/
		string account() { return m_account; }
		
		/**
		*	Gets the character.
		*/
		string character() { return m_character; }
		
		/**
		*	Gets the password.
		*/
		string password() { return m_password; }
		
		/**
		*	Gets the mesh.
		*/
		ushort mesh() { return m_mesh; }
		
		/**
		*	Gets the job.
		*/
		Job job() { return m_job; }
		
		/**
		*	Gets the uid.
		*/
		uint entityUID() { return m_entityUID; }
	}
}

/**
*	Checks whether a name is valid or not.
*	Params:
*		name =	The name to validate.
*	Returns: True if the name is valid, false otherwise.
*/
private bool validName(string name) {
	if (!name)
		return false;
	if (!name.length)
		return false;
	if (name.length < 4)
		return false;
	if (name.length > 16)
		return false;
	if (name == "none")
		return false;
	foreach (c; name) {
		if (!(c >= 48 && c <= 57 ||
			c >= 65 && c <= 90 ||
			c >= 97 && c <= 122))
		return false;
	}
	return true;
}

import packets : Packet, PacketType;
/**
*	Handles the create character packet.
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
@Packet(PacketType.createCharacter)
void handleCreateCharacter(GameClient client, DataPacket packet) {
	scope auto createCharacter = new CreateCharacterPacket(packet);
	import enums.job;
	switch (createCharacter.job) {
		case Job.internTrojan:
		case Job.internWarrior:
		case Job.internArcher:
		case Job.internTaoist:
			break;
		
		default: {
			client.disconnect("Invalid job.");
			return;
		}
	}
	
	if (createCharacter.mesh != 1003 && createCharacter.mesh != 1004 &&
		createCharacter.mesh != 2001 && createCharacter.mesh != 2002) {
		client.disconnect("Invalid mesh.");
		return;
	}
	
	import packets.messagecore;
	import core.msgconst;
	if (!validName(createCharacter.character)) {
		client.send(createCharacterCreationMessage(INVALID_NAME));
		return;
	}
	
	import database.playerdatabase;
	
	if (playerNameTaken(createCharacter.character)) {
		client.send(createCharacterCreationMessage(PLAYER_EXISTS));
		return;
	}
	if (createPlayer(client.account, createCharacter.character, createCharacter.job, createCharacter.mesh))
		client.send(createCharacterCreationMessage(ANSWER_OK));
	else
		client.send(createCharacterCreationMessage(CREATE_FAIL));
}