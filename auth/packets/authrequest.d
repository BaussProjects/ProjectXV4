module packets.authrequest;

import client.authclient;

import network.packet;

/**
*	The auth request packet.
*/
class AuthRequestPacket : DataPacket {
private:
	/**
	*	The account name.
	*/
	string m_account;
	
	/**
	*	The password.
	*/
	string m_password;
	
	/**
	*	The server name.
	*/
	string m_server;
public:
	/**
	*	Creates a new instance of AuthRequestPacket.
	*	Params:
	*		packet =	The packet.
	*/
	this(DataPacket packet) {
		super(packet);
		
		go(4); // Skips size and type
		m_account = readString(16); // Offset 4
		auto passbytes = readBuffer(16); // Offset 20
		import crypto.rc5;
		m_password = RC5.decrypt(passbytes);
		m_server = readString(16); // Offset 36
	}
	
	@property {
		/**
		*	Gets the account.
		*/
		string account() { return m_account; }
		
		/**
		*	Gets the password.
		*/
		string password() { return m_password; }
		
		/**
		*	Gets the server.
		*/
		string server() { return m_server; }
	}
}

import packets : Packet, PacketType;
/**
*	Handles the auth request packet.
*	Params:
*		client =	The auth client.
*		packet =	The packet.
*/
@Packet(PacketType.authrequest)
void handleAuthRequest(AuthClient client, DataPacket packet) {
	scope auto request = new AuthRequestPacket(packet);
	
	import std.stdio : writefln;
	writefln("[%s]%s has connected with '%s' & '%s'", client.address, request.account, request.password, request.server);
	import database;
	import packets.authresponse;
	
	uint entityUID = 0;
	auto status = authenticateAccount(request.account, request.password, entityUID);
	
	if (status == AccountStatus.ready) {
		client.send(new AuthResponsePacket(entityUID, status, 5816, "192.168.0.15"));
	}
	else {
		client.send(new AuthResponsePacket(entityUID, AccountStatus.error, 0, ""));
	}
}