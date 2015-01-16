module packets.passwordseed;

import network.packet;
import packets.packethandler : PacketType;

/**
*	The password seed packet.
*/
class PasswordSeedPacket : DataPacket {
public:
	/**
	*	Creates a new instance of PasswordSeedPacket.
	*	Params:
	*		seed =	The password seed.
	*/
	this(uint seed) {
		super(PacketType.passwordseed, 8);
		
		write!uint(seed); // Offset 4
	}
}