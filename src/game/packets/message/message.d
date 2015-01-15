module packets.message;

import network.packet;
import entities.gameclient;
import core.color;
import packets : Packet, PacketType;

/**
*	Enumeration for message types.
*/
enum MessageType : uint {
	talk = 2000,
	whisper,
	team,
	guild,
	clan,
	friend = 2009,
	center = 2011,
	topleft,
	ghost,
	service,
	tip,
	world = 2021,
	qualifier,
	register = 2100,
	entrance,
	messageBox,
	hawkMessage = 2104,
	website,
	guildWarFirst = 2108,
	guildWarNext,
	guildBullentin = 2111,
	broadcast = 2500,
	monster = 2600,
	slideFromRight = 100000,
	slideFromRightRedVib = 1000000,
	whiteVibrate = 10000000
}

/**
*	The message packet.
*/
class MessagePacket : DataPacket {
private:
	/**
	*	The message type.
	*/
	MessageType m_msgType;
	
	/**
	*	The color.
	*/
	uint m_color;
	
	/**
	*	The sender.
	*/
	string m_from;
	
	/**
	*	The receiver.
	*/
	string m_to;
	
	/**
	*	The message.
	*/
	string m_msg;
	
	/**
	*	The time.
	*/
	uint m_time;
	
	/**
	*	The receiver mesh.
	*/
	uint m_toMesh;
	
	/**
	*	The sender mesh.
	*/
	uint m_fromMesh;
public:
	/**
	*	Creates a new instance of MessagePacket.
	*	Params:
	*		msgType =		The message type.
	*		color =			The color of the message.
	*		fromMsg =		The sender of the message.
	*		toMsg =			The receiver of the message.
	*		msg =			The message.
	*		time =			The time of the message.
	*		toMesh =		The receiver mesh.
	*		fromMesh =		The sender mesh.
	*/
	this(MessageType msgType, uint color, string fromMsg, string toMsg, string msg, uint time, uint toMesh, uint fromMesh) {
		ushort size = cast(ushort)(fromMsg.length + toMsg.length + msg.length + 1 + 4 + 24);
		super(PacketType.message, size);
		
		write!uint(color); // Offset 4
		write!uint(msgType); // Offset 8
		write!uint(time); // Offset 12
		write!uint(toMesh); // Offset 16
		write!uint(fromMesh); // Offset 20
		
		StringPacker.pack(this, [fromMsg, toMsg, null, msg]); // Offset 24+
	}
	
	/**
	*	Creates a new instance of MessagePacket.
	*	Params:
	*		msgType =		The message type.
	*		color =			The color of the message.
	*		fromMsg =		The sender of the message.
	*		toMsg =			The receiver of the message.
	*		msg =			The message.
	*		time =			The time of the message.
	*		toMesh =		The receiver mesh.
	*		fromMesh =		The sender mesh.
	*/
	this(MessageType msgType, Color color, string fromMsg, string toMsg, string msg, uint time, uint toMesh, uint fromMesh) {
		this(msgType, Color.toUInt32(color), fromMsg, toMsg, msg, time, toMesh, fromMesh);
	}
	
	/**
	*	Creates a new instance of MessagePacket.
	*	Params:
	*		packet =	The packet.
	*/
	this(DataPacket packet) {
		super(packet);

		go(4); // Skips size and type
		m_color = read!uint; // Offset 4
		m_msgType = cast(MessageType)read!uint; // Offset 8
		m_time = read!uint; // Offset 12
		m_toMesh = read!uint; // Offset 16
		m_fromMesh = read!uint; // Offset 20
		
		auto msgData = StringPacker.unpack(this); // Offset 24+
		m_from = msgData[0];
		m_to = msgData[1];
		m_msg = msgData[3];
	}
	
	@property {
		/**
		*	Gets the message type.
		*/
		MessageType messageType() { return m_msgType; }
		
		/**
		*	Gets the color.
		*/
		uint color() { return m_color; }
		
		/**
		*	Gets the time.
		*/
		uint time() { return m_time; }
		
		/**
		*	Gets the receiver mesh.
		*/
		uint toMesh() { return m_toMesh; }
		
		/**
		*	Gets the sender mesh.
		*/
		uint fromMesh() { return m_fromMesh; }
		
		/**
		*	Gets the sender.
		*/
		string from() { return m_from; }
		
		/**
		*	Gets the sender.
		*/
		string to() { return m_to; }
		
		/**
		*	Gets the message.
		*/
		string message() { return m_msg; }
	}
}

/**
*	Handles the message packet.
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
@Packet(PacketType.message)
void handleMessage(GameClient client, DataPacket packet) {
	scope auto msg = new MessagePacket(packet);
	import std.algorithm : canFind, startsWith;
	
	if (startsWith(msg.message, "@") ||
		startsWith(msg.message, "/")) {
		import std.array : split;
		import packets.commands;
		string commandText = msg.message;
		if (!canFind(commandText, " "))
			handleCommands(client, [commandText], commandText);
		else
			handleCommands(client, split(commandText, " "), commandText);
		return;
	}
	
	switch (msg.messageType) {
		case MessageType.talk: {
			client.sendToScreen(msg);
			break;
		}
		
		default: {
			import std.stdio : writefln;
			writefln("Unknown Sub-type: [%s]%s", "Message", msg.messageType);
			break;
		}
	}
}