module database;

import packets.authresponse;
import io.inifile;

/**
*	The next entity uid to use.
*/
private shared uint nextEntityUID = 1000000;

/**
*	Generates an entity uid.
*	Returns: The generated entity uid.
*/
private uint generateEntityUID() {
	synchronized {
		auto nEntityUID = cast(uint)nextEntityUID;
		uint uid = nEntityUID;
		nEntityUID++;
		nextEntityUID = cast(shared(uint))nEntityUID;
		return uid;
	}
}

/**
*	Authenticates an account.
*	Params:
*		account =	The account name.
*		password =	The password.
*		entityUID = (out) The generated entity uid.
*	Returns: The status of the authentication.
*/
AccountStatus authenticateAccount(string account, string password, out uint entityUID) {
	entityUID = 0;
	try {
		string file = "database\\auth\\accounts\\" ~ account ~ ".ini";
		scope auto ini = new IniFile!(true)(file);
		if (!ini.exists())
			return AccountStatus.invalidAccountOrPassword;
		ini.open();
		uint oldEntityUID = ini.read!uint("EntityUID");
		entityUID = writeEntityUID(ini, account, oldEntityUID);
		if (ini.read!string("Password") != password) {
			ini.write!uint("EntityUID", 0);
			ini.close();
			return AccountStatus.invalidAccountOrPassword;
		}
		/*if (ini.read!bool("Banned")) {
			ini.write!uint("EntityUID", 0);
			ini.close();
			return AccountStatus.error;
		}*/
		ini.close();
		return AccountStatus.ready;
	}
	catch {
		return AccountStatus.invalidAccountOrPassword;//databaseError;
	}
}

/**
*	Writes & Gets the entity uid to the account matcher.
*	Params:
*		ini =			The inifile of the account.
*		account =		The account name.
*		oldEntityUID =	The old entity uid.
*	Returns the new entity uid.
*/
uint writeEntityUID(IniFile!(true) ini, string account, uint oldEntityUID) {
	uint entityUID = generateEntityUID();
	ini.write!uint("EntityUID", entityUID);
	
	scope auto ini2 = new IniFile!(true)("database\\auth\\accountmatcher.ini");
	ini2.open();
	import std.conv : to;
	string key = "UID" ~ to!string(oldEntityUID);
	if (oldEntityUID > 0)
		ini2.remove(key);
	key = "UID" ~ to!string(entityUID);
	ini2.write!string(key, account);
	ini2.close();
	return entityUID;
}