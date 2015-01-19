module core.kernel;

import std.algorithm : filter;
import std.array;

import data.item;

/**
*	The base item stats.
*/
private shared Item[uint] _items;

/**
*	Adds a kernel item (base item.)
*	Params:
*		i =		The item to add.
*/
void addKernelItem(Item i) {
	synchronized {
		auto items = cast(Item[uint])_items;
		items[i.id] = i;
		_items = cast(shared(Item[uint]))items;
	}
}

/**
*	Retrieves a kernel item (base item.)
*	Params:
*		id =	The id of the item to retrieve.
*	Returns: A copy of the kernel item.
*/
Item getKernelItem(uint id) {
	synchronized {
		auto items = cast(Item[uint])_items;
		return items[id].copy();
	}
}

alias statsArray = ushort[][ubyte];
private shared statsArray[ubyte] _stats;

void addKernelStats(ubyte job, ubyte level, ushort[] s) {
	synchronized {
		auto stats = cast(statsArray[ubyte])_stats;
		stats[job][level] = s;
		_stats = cast(shared(statsArray[ubyte]))stats;
	}
}

ushort[] getKernelStats(ubyte job, ubyte level) {
	synchronized {
		auto stats = cast(statsArray[ubyte])_stats;
		return stats[job][level];
	}
}

ubyte getBaseJob(ubyte job) {
	if (job < 20)
		return 10;
	else if (job < 40)
		return 20;
	else if (job < 100)
		return 40;
	else
		return 100;
}

import entities.gameclient;
private shared GameClient[uint] _clients;

GameClient[] getClientsByAccount(string account) {
	synchronized {
		auto clients = cast(GameClient[uint])_clients;
		scope auto matchingClients = filter!(e => e.account == account)(clients.values).array;
		if (!matchingClients || matchingClients.length == 0)
			return null;
		return matchingClients;
	}
}

GameClient getClientByName(string name) {
	synchronized {
		auto clients = cast(GameClient[uint])_clients;
		scope auto matchingClients = filter!(e => e.name == name)(clients.values).array;
		if (!matchingClients || matchingClients.length == 0)
			return null;
		return matchingClients.front;
	}
}

GameClient getClientByUID(uint uid) {
	synchronized {
		auto clients = cast(GameClient[uint])_clients;
		scope auto matchingClients = filter!(e => e.uid == uid)(clients.values).array;
		if (!matchingClients || matchingClients.length == 0)
			return null;
		return matchingClients.front;
	}
}

bool containsClient(GameClient client) {
	return getClientByUID(client.uid) !is null;
}

void addClient(GameClient client) {
	synchronized {
		auto clients = cast(GameClient[uint])_clients;
		clients[client.entityUID] = client;
		_clients = cast(shared(GameClient[uint]))clients;
	}
}

void removeClient(GameClient client) {
	synchronized {
		auto clients = cast(GameClient[uint])_clients;
		clients.remove(client.entityUID);
		_clients = cast(shared(GameClient[uint]))clients;
	}
}