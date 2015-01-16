module packets.authresponse;

import network.packet;
import packets.packethandler : PacketType;

/**
*	Enumeration for account statuses.
*/
enum AccountStatus : uint {
	error,
	invalidAccountOrPassword,
	ready,
	/*pointCardExpired = 6,
	monthlyCardExpired = 7,
	serverIsDown = 10,
	pleaseTryAgainLater,
	accountBanned,
	serverIsBusy = 20,
	serverIsBusyTryAgainLater,
	accountLocked,
	accountNotActivated = 30,
	failedToActivateAccount = 31,
	invalidInput = 40,
	invalidInfo,
	timedOut,
	recheckSerialNumber,
	unbound = 46,
	used3LoginAttempts = 51,
	failedToLogin,
	databaseError = 54,
	invalidAccountId = 57,
	serversNotConfigured = 59,
	serverLocked = 70,
	accountLockedByPhone = 72*/
}
	
/**
*	The auth response packet.
*/
class AuthResponsePacket : DataPacket {
public:
	/**
	*	Creates a new instance of AuthResponsePacket.
	*	Params:
	*		entityUID =		The uid of the auth client.
	*		status =		The status of the account.
	*		port =			The port of the game server.
	*		ip =			The ip of the game server.
	*/
	this(uint entityUID, AccountStatus status, uint port, string ip) {
		assert(entityUID == 0 || entityUID >= 1000000);
		assert(ip.length < 16);
		
		super(PacketType.authresponse, 52);
		
		write!uint(entityUID); // Offset 4
		write!uint(status); // Offset 8
		writeString(ip); // Offset 12
		writeEmpty(28);
		write!uint(port); // Offset 28
	}
}