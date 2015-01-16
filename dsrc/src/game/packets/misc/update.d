module packets.update;

/**
*	Enumeration for update types.
*/
enum UpdateType : uint {
	hp = 0x00,
    maxHp = 0x01,
    mp = 0x02,
    maxMp = 0x03,
    money = 0x04,
	experience = 0x05,
	pkPoints = 0x06,
	job = 0x07,
	none = 0xFFFFFFFF,
	qwRaiseFlag = 0x08,
	stamina = 0x09,
	statPoints = 0x0B,
	model = 0x0C,
	level = 0x0D,
	spirit = 0x0E,
	vitality = 0x0F,
	strength = 0x10,
	agility = 0x11,
	reborns = 0x17,
	raiseFlag = 0x1A,
	hairStyle = 0x1B,
	cps = 0x1E,
	xpCircle = 0x1F,
	doubleExpTimer = 0x13,
	cursedTimer = 0x15,
	luckyTimeTimer = 0x1D,
	heavensBlessing = 0x12
}


/*
enum UpdateType : uint
{
	none = 0xFFFFFFFF,
	
	hp = 0,
	maxHp,
	mp,
	maxMp,
	money,
	experience,
	pkPoints,
	job,
	sizeAdd,
	stamina,
	statPoints = 11,
	model,
	level,
	spirit,
	vitality,
	strength,
	agility,
	heavensBlessing,
	doubleExpTimer,
	cursedTimer = 21,
	reborns = 23,
	raiseFlag = 26,
	hairStyle,
	xpCircle,
	luckyTimeTimer,
	cps,
	trainingPoints = 32,
	mentorBattlePower = 36,
	quizShowPoints = 40
}*/
		
import network.packet;
import packets : PacketType;

/**
*	The update packet.
*/
class UpdatePacket : DataPacket {
public:	
	/**
	*	Creates a new instance of UpdatePacket.
	*	Params:
	*		uid =		The uid.
	*		update =	The update type.
	*		value =		The value.
	*/
	this(uint uid, UpdateType update, ushort value) {
		super(PacketType.update, 20);
		
		write!uint(uid);
		write!uint(1);
		write!uint(cast(uint)update);
		write!ushort(value);
	}
	
	/**
	*	Creates a new instance of UpdatePacket.
	*	Params:
	*		uid =		The uid.
	*		update =	The update type.
	*		value =		The value.
	*/
	this(uint uid, UpdateType update, uint value) {
		super(PacketType.update, 20);
		
		write!uint(uid);
		write!uint(1);
		write!uint(cast(uint)update);
		write!uint(value);
	}
	
	/**
	*	Creates a new instance of UpdatePacket.
	*	Params:
	*		uid =		The uid.
	*		update =	The update type.
	*		value =		The value.
	*/
	this(uint uid, UpdateType update, ulong value) {
		super(PacketType.update, 24);
		
		write!uint(uid);
		write!uint(1);
		write!uint(cast(uint)update);
		write!ulong(value);
	}
	
	/**
	*	Creates a new instance of UpdatePacket.
	*	Params:
	*		uid =		The uid.
	*		update =	The update type.
	*		value =		The value.
	*/
	this(uint uid, UpdateType update, short value) {
		super(PacketType.update, 20);
		
		write!uint(uid);
		write!uint(1);
		write!uint(cast(uint)update);
		write!short(value);
	}
}