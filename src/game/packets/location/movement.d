module packets.movement;

import network.packet;
import packets : Packet, PacketType;
import core.gametime;
import entities.gameclient;
import enums.angle;

/**
*	The movement packet.
*/
class MovementPacket : DataPacket {
private:
	/**
	*	The uid.
	*/
	uint m_uid;
	/**
	*	The direction.
	*/
	ubyte m_direction;
	/**
	*	Boolean determining whether the client is running or not.
	*/
	bool m_running;
	
	/**
	*	Creates a new instance of MovementPacket.
	*	Params:
	*		packet =	The packet.
	*/
	this(DataPacket packet) {
		super(packet);
		
		go(4);
		m_uid = read!uint;
		m_direction = read!ubyte;
		m_running = read!bool;
	}
	
	@property {
		/**
		*	Gets the entity uid.
		*/
		uint entityUID() { return m_uid; }
		/**
		*	Gets the direction.
		*/
		ubyte direction() { return m_direction; }
		/**
		*	Gets a boolean determining whether the client is running or not.
		*/
		bool running() { return m_running; }
	}
}

/**
*	The delta array for x directions.
*/
private enum deltaX = [ 0, -1, -1, -1, 0, 1, 1, 1, 0 ];

/**
*	The delta array for y directions.
*/
private enum deltaY = [ 1, 1, 0, -1, -1, -1, 0, 1, 0 ];
		
/**
*	Handles the general packet.
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
@Packet(PacketType.movement)
void handleMovement(GameClient client, DataPacket packet) {
	scope auto move = new MovementPacket(packet);
	if (move.entityUID != client.uid) {
		client.disconnect("Invalid move UID");
		return;
	}
	
	int newDir = cast(int)(move.direction % 8);
	ushort newX = cast(ushort)(client.x + deltaX[newDir]);
	ushort newY = cast(ushort)(client.y + deltaY[newDir]);
	
	if (!client.map.validCoord(newX, newY)) {
		client.pullBack();
		return;
	}
	
	import enums.action;
	client.action = Action.none;
	client.direction = cast(Angle)newDir;
	client.lastX = client.x;
	client.lastY = client.y;
	client.x = cast(ushort)newX;
	client.y = cast(ushort)newY;
	client.updateSpawn(packet);
}