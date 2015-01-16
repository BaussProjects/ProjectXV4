module packets.characterinfo;
		
import network.packet;
import packets.packethandler : PacketType;
import entities.gameclient;

/**
*	The characterinfo packet.
*/
class CharacterInfoPacket : DataPacket {
public:	
	/**
	*	Creates a new instance of CharacterInfoPacket.
	*	Params:
	*		client =	The client to inherit the information from.
	*/
	this(GameClient client) {
		super(PacketType.characterinfo, cast(ushort)(70 + client.name.length + client.spouse.length));
		
		write!uint(client.entityUID); // 4
		write!uint(client.mesh); // 8
		write!ushort(client.hairStyle); // 12
		write!uint(client.money); // 14
		write!uint(client.cps); // 18
		write!ulong(client.experience); // 22
		writeEmpty(46);
		write!ushort(client.strength); // 46
		write!ushort(client.agility); // 48
		write!ushort(client.vitality); // 50
		write!ushort(client.spirit); // 52
		write!ushort(client.statPoints); // 54
		write!ushort(cast(ushort)client.maxHp); // 56
		write!ushort(cast(ushort)client.maxMp); // 58
		write!short(client.pkPoints); // 60
		write!ubyte(client.level); // 62
		write!ushort(cast(ushort)client.job); // 63
		write!ubyte(client.reborns); // 65
		write!ubyte(0x01); // 66
		
		StringPacker.pack(this, [client.name, client.spouse]); // 67
	}
}