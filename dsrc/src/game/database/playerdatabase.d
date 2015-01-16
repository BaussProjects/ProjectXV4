module database.playerdatabase;

import std.conv : to;

import io.inifile;

/**
*	Gets the account name by entity uid.
*	Params:
*		uid =		The entity uid.
*		success =	A boolean set whether the account name was retrieved or not.
*	Returns: The account name associated with the entity uid.
*/
string getAccountName(uint uid, out bool success) {
	scope auto matchIni = new IniFile!(true)("database\\auth\\accountmatcher.ini");
	matchIni.open();
	string key = "UID" ~ to!string(uid);
	success = matchIni.has(key);
	if (!success)
		return null;
	string account = matchIni.read!string(key);
	return account;
}

/**
*	Checks whether a character exists for a specific account.
*	Params:
*		account =	The account.
*	Returns: A boolean determining whether the character exists.
*/
bool playerExists(string account) {
	scope auto accountIni = new IniFile!(true)("database\\game\\players\\" ~ account ~ ".ini");
	return accountIni.exists();
}

/**
*	Checks whether an account is banned.
*	Params:
*		account =	The account.
*	Returns: A boolean determining whether the character is banned.
*/
bool playerBanned(string account) {
	string file = "database\\auth\\accounts\\" ~ account ~ ".ini";
	scope auto ini = new IniFile!(true)(file);
	if (!ini.exists())
		return true;
	ini.open();
	return ini.read!bool("Banned");
}

/**
*	Checks whether a character name is already taken.
*	Params:
*		name =	The name to check.
*/
bool playerNameTaken(string name) {
	import io.safeio;
	if (!exists("database\\game\\names.txt"))
		return false;
	foreach (l; readLines("database\\game\\names.txt")) {
		if (l == name)
			return true;
	}
	return false;
}

import entities.gameclient;
import data.item;

/**
*	Loads player info.
*	Params:
*		client =	The player to load.
*	Returns: True if the player was loaded.
*/
bool loadPlayer(GameClient client) {
	try {
		auto ini = client.playerDbFile;
		if (!ini.exists())
			return false;
		ini.open();
		// Name
		client.name = ini.read!string("Name");
		client.spouse = ini.read!string("Spouse");
		// check for divorce ...
		
		// Location
		
		ushort mapid = ini.read!ushort("MapID");
		//client.lastMapId = ini.read!ushort("LastMapID");
		ushort x = ini.read!ushort("X");
		ushort y = ini.read!ushort("Y");
		client.teleport(mapid, x, y);
		
		// Money
		client.money = ini.read!uint("Money");
		client.cps = ini.read!uint("CPs");
		client.whMoney = ini.read!uint("WHMonney");
		
		// Stats
		client.level = ini.read!ubyte("Level");
		client.experience = ini.read!ulong("Experience");
		client.job = cast(Job)ini.read!ubyte("Job");
		client.pkPoints = ini.read!short("PKPoints");
		client.maxHp = ini.read!int("MaxHP");
		client.maxMp = ini.read!int("MaxMP");
		client.hp = ini.read!int("HP");
		client.mp = ini.read!int("MP");
		client.statPoints = ini.read!ushort("StatPoints");
		client.strength = ini.read!ushort("Strength");
		client.agility = ini.read!ushort("Agility");
		client.vitality = ini.read!ushort("Vitality");
		client.spirit = ini.read!ushort("Spirit");
		client.reborns = ini.read!ubyte("Reborns");
		
		// Look
		client.model = ini.read!ushort("Model");
		client.avatar = ini.read!ushort("Avatar");
		client.hairStyle = ini.read!ushort("HairStyle");
		
		import std.conv : to;
		
		// Inventory
		auto invIni = client.inventoryDbFile;
		if (invIni.exists()) {
			invIni.open();
			foreach (byte pos; 0 .. 40) {
				string posStr = to!string(pos);
				if (invIni.has(posStr)) {
					client.inventory.addItem(
						Item.fromString(
							invIni.read!string(posStr)
						)
					);
				}
			}
		}
		
		client.updateStatPoints();
		client.updateBaseStats();
	}
	catch (Throwable t) {
		import std.stdio : writeln;
		writeln(t);
		return false;
	}
	return true;
}

/**
*	Updates character info.
*	Params:
*		client =	The client to update.
*		dbName =	The entry to update.
*		value =		The value to update.
*/
void updateCharacter(T)(GameClient client, string dbName, T value) {
	if (!client.loaded)
		return;
	
	//scope auto ini = new IniFile!(true)("database\\game\\players\\" ~ client.account ~ ".ini");
	auto ini = client.playerDbFile;
	if (!ini.exists())
		return;
	ini.open();
	ini.write!T(dbName, value);
	ini.close();
}

/**
*	Updates an item in the inventory of the character.
*	Params:
*		client = 	The client (character.)
*		item =		The item to update.
*		pos =		The position in the inventory.
*/
void updateCharacterInventory(GameClient client, Item item, byte pos) {
	if (!client.loaded)
		return;
		
	//scope auto ini = new IniFile!(true)("database\\game\\player_inventories\\" ~ client.account ~ ".ini");
	auto ini = client.inventoryDbFile;
	if (ini.exists())
		ini.open();
	
	import std.conv : to;
	ini.write!string(to!string(pos), item.toString());
	ini.close();
}

/**
*	Removes an item from the inventory of the character.
*	Params:
*		client = 	The client (character.)
*		pos =		The position in the inventory.
*/
void removeCharacterInventory(GameClient client, byte pos) {
	if (!client.loaded)
		return;
		
	//scope auto ini = new IniFile!(true)("database\\game\\player_inventories\\" ~ client.account ~ ".ini");
	auto ini = client.inventoryDbFile;
	if (!ini.exists())
		return;
	ini.open();
	import std.conv : to;
	ini.remove(to!string(pos));
	ini.close();
}

/**
*	Wipes the inventory of a character.
*	Params:
*		client = 	The client (character.)
*/
void wipeCharacterInventory(GameClient client) {
	auto ini = client.inventoryDbFile;
	ini.clear();
	/*import io.safeio;
	if (!exists("database\\game\\player_inventories\\" ~ client.account ~ ".ini"))
		return;
	remove("database\\game\\player_inventories\\" ~ client.account ~ ".ini");*/
}

import enums.job;
/**
*	Creates a player.
*	Params:
*		account =	The account name.
*		name =		The character name.
*		job =		The character job.
*		mesh =		The mesh.
*	Returns: True if the character was created.
*/
bool createPlayer(string account, string name, Job job, ushort mesh) {
	try {
		import io.safeio;
		append("database\\game\\names.txt", name ~ "\r\n");
		
		scope auto ini = new IniFile!(true)("database\\game\\players\\" ~ account ~ ".ini");
		if (ini.exists())
			return false;
		
		// Name
		ini.write!string("Name", name);
		ini.write!string("Spouse", "none");
		
		// Location
		ini.write!ushort("MapID", 1002);
		ini.write!ushort("LastMapID", 1002);
		ini.write!ushort("X", 400);
		ini.write!ushort("Y", 400);
		
		// Money
		ini.write!uint("Money", 100);
		ini.write!uint("CPs", 0);
		ini.write!uint("WHMonney", 0);
		
		// Stats
		ini.write!ubyte("Level", 1);
		ini.write!ulong("Experience", 0);
		ini.write!ubyte("Job", cast(ubyte)job);
		ini.write!short("PKPoints", 0);
		ini.write!int("MaxHP", 100);
		ini.write!int("MaxMP", 0);
		ini.write!int("HP", 100);
		ini.write!int("MP", 100);
		ini.write!ushort("StatPoints", 0);
		ini.write!ushort("Strength", 25);
		ini.write!ushort("Agility", 25);
		ini.write!ushort("Vitality", 25);
		ini.write!ushort("Spirit", 0);
		ini.write!ubyte("Reborns", 0);
		
		// Look
		ini.write!ushort("Model", mesh);
		ini.write!ushort("Avatar", 112);
		ini.write!ushort("HairStyle", 410);
		
		ini.close();
		
		return true;
	}
	catch (Throwable t) {
		import std.stdio : writeln;
		writeln(t);
		return false;
	}
}