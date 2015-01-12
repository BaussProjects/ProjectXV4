module packets.update;

/**
*	Enumeration for update types.
*/
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
}
		
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