module packets.item;

import network.packet;
import packets.packethandler : Packet, PacketType;

/**
*	Enumeration of item modes.
*/
enum ItemMode : ushort {
	def = 0x01,
	trade = 0x02,
	update = 0x03,
	view = 0x04
}

/**
*	Enumeration of item positions.
*/
enum ItemPosition : uint {
	inventory = 0,
	head,
	necklace,
	armor,
	rightHand,
	leftHand,
	ring,
	bottle,
	boots,
	garment,
	attackTalisman,
	defenseTalisman
}
	
/**
*	The item packet.
*/
class ItemPacket : DataPacket {
public:
	/**
	*	Creates a new instance of item packet.
	*	Params:
	*		uid =			The uid of the item.
	*		id =			The id of the item.
	*		amount =		The amount of the item.
	*		maxAmount =		The maximum amount of the item.
	*		mode =			The mode of the item.
	*		pos =			The position of the item.
	*		plus =			The plus of the item.
	*		bless =			The bless of the item.
	*		enchant =		The enchant of the item.
	*		gem1 =			The first socket gem of the item.
	*		gem2 =			The second socket gem of the item.
	*		rbEffect =		The reborn effect of the item.
	*/
	this(uint uid, uint id, short amount, short maxAmount,
		ItemMode mode, ItemPosition pos,
		ubyte plus = 0, ubyte bless = 0, ubyte enchant = 0,
		ubyte gem1 = 0, ubyte gem2 =0, short rbEffect = 0) {
		super(PacketType.item, 36);
		
		write!uint(uid);
		write!uint(id);
		write!short(amount);
		write!short(maxAmount);
		write!ushort(cast(ushort)mode);
		write!uint(cast(uint)pos);
		writeEmpty(24);
		write!ubyte(gem1);
		write!ubyte(gem2);
		writeEmpty(28);
		write!ubyte(plus);
		write!ubyte(bless);
		write!ubyte(enchant);
		//write!short(rbEffect);
	}
}