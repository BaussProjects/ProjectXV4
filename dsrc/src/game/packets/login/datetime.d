module packets.datetime;

import network.packet;
import packets : PacketType;

/**
*	The date time packet.
*/
class DateTimePacket : DataPacket {
public:
	/**
	*	Creates a new instance of DateTimePacket,
	*	then writes the current time to it.
	*/
	this() {
		super(PacketType.datetime, 36);
		
		import std.datetime;
		scope auto time = Clock.currTime();
		writeEmpty(8);
		write!int(cast(int)time.year);
		write!int(cast(int)time.month);
		write!int(cast(int)time.dayOfYear);
		write!int(cast(int)time.day);
		write!int(cast(int)time.hour);
		write!int(cast(int)time.minute);
		write!int(cast(int)time.second);
	}
}