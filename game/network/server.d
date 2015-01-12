module network.server;

import std.socket;
import core.thread;

import threading.thread;
import entities.gameclient;

/**
*	The next socket id.
*/
private size_t nextSid = 0;

/**
*	The game clients.
*/
private GameClient[size_t] clients;

/**
*	The socket threads.
*/
private shared Thread[] socketThreads;

/**
*	The server socket.
*/
private shared Socket serverSocket;

/**
*	Runs the server.
*	Params:
*		ip =	The ip of the server.
*		port =	The port of the server.
*/
void run(string ip, ushort port) {
	auto server = new TcpSocket;
	server.blocking = false;
	server.bind(new InternetAddress(ip, port));
	server.listen(100);
	serverSocket = cast(shared(Socket))server;
	auto t = createThread({ handle!true(); });
	{
		auto sthreads = cast(Thread[])socketThreads;
		sthreads ~= t;
		socketThreads = cast(shared(Thread[]))sthreads;
	}
	t.start();
}

/**
*	Handling the server.
*	Params:
*		isServer = (Template) A boolean determining whether the handler is for the server socket.
*/
private void handle(bool isServer)() {
	while (true) {
		scope auto selectSet = new SocketSet;
		static if (isServer) {
			auto server = cast(Socket)serverSocket;
			selectSet.add(server);
		}
		foreach (client; clients.values) {
			if (client.alive)
				selectSet.add(client.socket);
			else {
				try {
					client.disconnect("Not alive...");
				}
				catch { }
				removeSocket(client);
			}
		}
		
		auto selectResult = Socket.select(selectSet, null, null);
		if (selectResult < 1)
			continue;

		static if (isServer) {
			if (selectSet.isSet(server)) {
				try {
					auto client = new GameClient(server.accept(), nextSid++);
					addToThread(client);
					
					import network.handlers;
					handleConnect(client);
				}
				catch { }
			}
		}
		
		import std.stdio : writeln;
		foreach (client; clients.values) {
			try {
				if (selectSet.isSet(client.socket)) {
					client.handleAsyncReceive();
				}
			}
			catch (Throwable t) { writeln(t); }
		}
	}
}

/**
*	Adds a client to a socket thread.
*/
private void addToThread(GameClient client) {
	synchronized {
		if (clients.length >= 32) {
			auto sthreads = cast(Thread[])socketThreads;
			auto t = createThread({
				addToThread(client);
				handle!false();
			});
			t.start();
			sthreads ~= t;
			socketThreads = cast(shared(Thread[]))sthreads;
		}
		else {
			clients[client.sid] = client;
		}
	}
}

/**
*	Removes a socket from a socket thread.
*/
private void removeSocket(GameClient client) {
	try {
		if (clients.get(client.sid, null) !is null)
			clients.remove(client.sid);
	}
	catch { }
}