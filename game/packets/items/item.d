module packets.item;

import network.packet;
import packets : Packet, PacketType;

enum ItemMode : ushort {
	def = 0x01,
	trade = 0x02,
	update = 0x03,
	view = 0x04
}

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
	
class ItemPacket : DataPacket {
public:
	this(uint uid, uint id, short amount, short maxAmount,
		ItemMode mode, ItemPosition pos,
		ubyte plus = 0, ubyte bless = 0, ubyte enchant = 0,
		ubyte gem1 = 0, ubyte gem2 =0, short rbEffect = 0) {
		super(PacketType.item, 36);
		/*		uint UID
		uint ID
		short Durability
		short MaxDurability
		ushort Mode
		ushort Position
		ubyte gem1 // 24
		ubyte gem2
		ubyte plus// 28
		ubyte bless
		ubyte enchant
		*/
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