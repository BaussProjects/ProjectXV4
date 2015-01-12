module packets.generaldata;

/**
*	Enumeration for general data actions.
*/
enum DataAction : ushort
{
	ninjaStep = 0x9C,
	endFly = 0x78,
	GUIDialog = 0x7E,
	setLocation = 0x4A,
	setMapColor = 0x68,
	jump = 0x85,
	unlearnSpell = 0x6D,
	unlearnProficiency = 0x6E,
       // guardJump = 0x82,
	levelUp = 0x5C,
	friendInfo = 0x8C,
	teleport = 0x56,
	getSurroundings = 0x72,
	removeEntity = 0x84,
	requestTeamPosition = 0x6A,
	changePkMode = 0x60,
	revive = 0x5E,
	requestEntity = 0x66,
	changeAction = 0x51,
	changeDirection = 0x4F,
	hotKeys = 0x4B,
	confirmAssociates = 0x4C,
	confirmProficiencies = 0x4D,
	confirmSpells = 0x4E,
	confirmGuild = 0x61,
	queryEquipment = 0x75,
	login = 0x82,
	changeAvatar = 0x8E,
	enterPortal = 0x55,
	deleteCharacter = 0x5F,
	_switch = 0x74,
	requestFriendInfo = 0x94,
	endTransform = 0x76,
	mining = 0x63,
	startVend = 0x6F,
	spawnEffect = 0x86,
	none = 0x00
}

/**
*	Enumeration for data switches.
*/
enum DataSwitch : uint {
	marriageMouse = 1067,
	enchantWindow = 1091
}

/**
*	Enumeration for data GUI's.
*/
enum DataGUI : uint {
	warehouse = 4,
	compose = 1
}

import network.packet;
import packets : Packet, PacketType;
import core.gametime;
import entities.gameclient;

/**
*	The general data packet.
*/
class GeneralDataPacket : DataPacket {
private:
	/**
	*	The time stamp.
	*/
	uint m_timeStamp;
	/**
	*	The entity uid.
	*/
	uint m_entityUID;
	/**
	*	The DWORD param.
	*/
	uint m_dwParam1;
	/**
	*	The first WORD param.
	*/
	ushort m_wParam1;
	/**
	*	The second WORD param.
	*/
	ushort m_wParam2;
	/**
	*	The direction.
	*/
	ushort m_direction;
	/**
	*	The action.
	*/
	DataAction m_action;
public:
	/**
	*	Creates a new instance of GeneralDataPacket.
	*	Params:
	*		entityUID =			The entity uid.
	*		dwParam1 =			The DWORD param.
	*		wParam1 =			The first WORD param.
	*		wParam2 =			The second WORD param.
	*		direction =			The direction.
	*		action = 			The action.
	*/
	this(uint entityUID, uint dwParam1, ushort wParam1, ushort wParam2, ushort direction, DataAction action) {
		super(PacketType.generaldata, 24);
		
		write!uint(getTimeStamp());
		write!uint(entityUID);
		write!uint(dwParam1);
		write!ushort(wParam1);
		write!ushort(wParam2);
		write!ushort(direction);
		write!ushort(action);
	}
	
	/**
	*	Creates a new instance of GeneralDataPacket.
	*	Params:
	*		entityUID =			The entity uid.
	*		dwParam1 =			The first DWORD param.
	*		dwParam2 =			The second DWORD param.
	*		wParam1 =			The first WORD param.
	*		wParam2 =			The second WORD param.
	*		direction =			The direction.
	*		action = 			The action.
	*/
	this(uint entityUID, ushort dwParam1, ushort dwParam2, ushort wParam1, ushort wParam2, ushort direction, DataAction action) {
		super(PacketType.generaldata, 24);
		
		write!uint(getTimeStamp());
		write!uint(entityUID);
		write!ushort(dwParam1);
		write!ushort(dwParam2);
		write!ushort(wParam1);
		write!ushort(wParam2);
		write!ushort(direction);
		write!ushort(action);
	}
	
	/**
	*	Creates a new instance of GeneralDataPacket.
	*	Params:
	*		entityUID =			The entity uid.
	*		dwParam1 =			The DWORD param.
	*		direction =			The direction.
	*		action = 			The action.
	*/
	this(uint entityUID, uint dwParam1, ushort direction, DataAction action) {
		super(PacketType.generaldata, 24);
		
		write!uint(getTimeStamp());
		write!uint(entityUID);
		write!uint(dwParam1);
		write!ushort(0);
		write!ushort(0);
		write!ushort(direction);
		write!ushort(action);
	}
	
	/**
	*	Creates a new instance of GeneralDataPacket.
	*	Params:
	*		entityUID =			The entity uid.
	*		dwParam1 =			The first DWORD param.
	*		dwParamw =			The second DWORD param.
	*		direction =			The direction.
	*		action = 			The action.
	*/
	this(uint entityUID, ushort dwParam1, ushort dwParam2, ushort direction, DataAction action) {
		super(PacketType.generaldata, 24);
		
		write!uint(getTimeStamp());
		write!uint(entityUID);
		write!ushort(dwParam1);
		write!ushort(dwParam2);
		write!ushort(0);
		write!ushort(0);
		write!ushort(direction);
		write!ushort(action);
	}
	
	/**
	*	Creates a new instance of GeneralDataPacket.
	*	Params:
	*		packet =	The packet.
	*/
	this(DataPacket packet) {
		super(packet);
		
		go(4);
		m_timeStamp = read!uint;
		m_entityUID = read!uint;
		m_dwParam1 = read!uint;
		m_wParam1 = read!ushort;
		m_wParam2 = read!ushort;
		m_direction = read!ushort;
		m_action = cast(DataAction)read!ushort;
	}
	
	@property {
		/**
		*	Gets the time stamp.
		*/
		uint timeStamp() { return m_timeStamp; }
		/**
		*	Gets the entity uid.
		*/
		uint entityUID() { return m_entityUID; }
		/**
		*	Gets the DWORD param.
		*/
		uint dwParam1() { return m_dwParam1; }
		/**
		*	Gets the DWORD param (low)
		*/
		ushort dwParam1_low() {
			return cast(ushort)m_dwParam1;
		}
		/**
		*	Gets the DWORD param (high)
		*/
		ushort dwParam1_high() {
			return cast(ushort)(m_dwParam1 >> 16);
		}
		/**
		*	Gets the first WORD param.
		*/
		ushort wParam1() { return m_wParam1; }
		/**
		*	Gets the second WORD param.
		*/
		ushort wParam2() { return m_wParam2; }
		/**
		*	Gets the direction.
		*/
		ushort direction() { return m_direction; }
		/**
		*	Gets the action.
		*/
		DataAction action() { return m_action; }
	}
}

/**
*	Handles the general packet.
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
@Packet(PacketType.generaldata)
void handleGeneralData(GameClient client, DataPacket packet) {
	scope auto generalData = new GeneralDataPacket(packet);
	
	import packets.general.setlocation;
	import packets.general.getsurroundings;
	import packets.general.hotkeys;
	import packets.general.confirmassociates;
	import packets.general.changepk;
	import packets.general.jump;
	
	switch (generalData.action) {
		case DataAction.setLocation: handleSetLocation(client, generalData); break;
		case DataAction.getSurroundings: handleGetSurroundings(client, generalData); break;
		case DataAction.hotKeys: handleHotKeys(client, generalData); break;
		case DataAction.confirmAssociates: handleConfirmAssociates(client, generalData); break;
		case DataAction.changePkMode: handleChangePK(client, generalData); break;
		case DataAction.jump: handleJump(client, generalData); break;
		
		case DataAction.confirmProficiencies:
		case DataAction.confirmSpells:
		case DataAction.confirmGuild:
			client.send(generalData);
			break;
			
		case DataAction.login: {
			client.loaded = true;
			client.send(generalData);
			import packets.messagecore;
			import core.msgconst;
			import std.string : format;
			client.send(createSystemMessage(format(MOTD, client.name)));
			import std.stdio : writefln;
			writefln("%s has logged in!", client.name);
			break;
		}
			
		default: {
			import std.stdio : writefln;
			writefln("Unknown Sub-type: [%s]%s", "General Data", generalData.action);
			break;
		}
	}
}