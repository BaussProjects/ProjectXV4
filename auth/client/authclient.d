module client.authclient;

import std.socket;

import network.handlers;
import network.packet : DataPacket;
import crypto.authcrypto;

/**
*	The auth client.
*/
class AuthClient {
private:
	/**
	*	The socket associated with the auth client.
	*/
	Socket m_socket;
	
	// Receive ...
	/**
	*	The expected receive size.
	*/
	int m_expectedSize;
	/**
	*	The return size.
	*/
	int m_returnSize;
	/**
	*	The receive buffer.
	*/
	ubyte[] m_receiveBuffer;
	/**
	*	The final buffer.
	*/
	ubyte[] m_finalBuffer;
	/**
	*	A boolean controlling whether the socket is receiving the packet head or not.
	*/
	bool m_isHead;
	
	// Disconnect ...
	/**
	*	A boolean controlling whether the client has been disconnected.
	*/
	bool m_disconnected;
	
	// Socket ...
	/**
	*	The address of the socket.
	*/
	string m_address;
	/**
	*	The id of the socket.
	*/
	size_t m_sid;
	// Client ...
	/**
	*	The cryptography of the client.
	*/
	AuthCrypto m_crypto;
public:
	/**
	*	Creates a new instance of AuthClient.
	*	Params:
	*		socket =	The socket of the auth client.
	*		sid =		The id of the socket.
	*/
	this(Socket socket, size_t sid) {
		assert(socket.isAlive);
		
		m_socket = socket;
		m_socket.blocking = false;
		m_expectedSize = 8;
		m_returnSize = 8;
		m_isHead = true;
		m_disconnected = false;
		m_address = m_socket.remoteAddress().toString();
		
		m_crypto = new AuthCrypto;
		m_sid = sid;
	}
	
	@property {
		/**
		*	Gets the underlying socket.
		*/
		Socket socket() { return m_socket; }
		
		/**
		*	Gets the address of the socket.
		*/
		string address() { return m_address; }
		
		/**
		*	Gets a boolean determining whether the socket is alive or not.
		*/
		bool alive() { return m_socket.isAlive; }
		
		/**
		*	Gets the id of the socket.
		*/
		int sid() { return m_sid; }
	}
	
	/**
	*	Handles the asynchronous socket receive.
	*/
	void handleAsyncReceive() {
		import std.stdio : writeln;
		if (m_disconnected)
			return;
		if (!m_socket.isAlive) {
			disconnect("Dead socket...");
			return;
		}
			
		ubyte[] recvBuf = new ubyte[m_returnSize];
		auto recv = m_socket.receive(recvBuf);
		if (recv == 0 || recv == Socket.ERROR) {
			disconnect("Terminated socket...");
			return;
		}		
		m_receiveBuffer ~= recvBuf;
		
		synchronized {
			m_crypto.decrypt(m_receiveBuffer, m_receiveBuffer, m_receiveBuffer.length);
		}
		
		if (m_isHead) {
			scope auto head = new DataPacket(m_receiveBuffer);
			ushort expectedSize = head.read!ushort;
			if (expectedSize > 1024) {
				disconnect("Packet too big!");
				return;
			}
			
			expectedSize -= 8;
				
			if (expectedSize > 0) {
				m_expectedSize = expectedSize;
				m_returnSize = expectedSize;
				m_finalBuffer ~= m_receiveBuffer;
				m_receiveBuffer = null;
				m_isHead = false;
			}
			else {
				handleReceive(this, head);
				
				m_expectedSize = 8;
				m_returnSize = 8;
				m_finalBuffer = null;
				m_receiveBuffer = null;
				m_isHead = true;
			}
		}
		else {
			m_returnSize -= recv;
			m_finalBuffer ~= m_receiveBuffer;
			if (m_returnSize <= 0) {
				scope auto packet = new DataPacket(m_finalBuffer);
				handleReceive(this, packet);
				m_expectedSize = 8;
				m_returnSize = 8;
				m_finalBuffer = null;
				m_receiveBuffer = null;
				m_isHead = true;
			}
		}
		
	}
	
	/**
	*	Sends a packet to the client.
	*	Params:
	*		packet =	The packet to send.
	*/
	void send(DataPacket packet) {
		try {
			ubyte[] buffer = packet.buffer;
			synchronized {
				m_crypto.encrypt(buffer, buffer, buffer.length);
				m_socket.send(buffer);
			}
		}
		catch {
			disconnect("Send failed.");
		}
	}
	
	/**
	*	Disconnects the client.
	*	Params:
	*		reason =	The reason for the disconnect.
	*/
	void disconnect(string reason = "Unknown") {
		if (m_disconnected)
			return;
		m_disconnected = true;
		
		try {
			m_socket.shutdown(SocketShutdown.BOTH);
			m_socket.close();
		}
		catch { }
		// Handle ...
		handleDisconnect(this, reason);
	}
}