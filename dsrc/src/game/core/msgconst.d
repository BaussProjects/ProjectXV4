module core.msgconst;

import packets.message;

/*
	Message constants are message strings that are used through out the server.
	This module provides a simple way of quickly editing the strings without having to search through the source.
	The constants are seperated in group.
*/

// Login Sequence -- The messages send upon login/character-creation.
const string LOGIN_ERR = "Failed to login.";
const string NEW_ROLE = "NEW_ROLE";
const string ANSWER_OK = "ANSWER_OK";
const string ANSWER_NO = "This account has been banned!";
const string INVALID_NAME = "Invalid character name. Make sure it's 0-9 or A-Z/a-z";
const string PLAYER_EXISTS = "The character name is taken!";
const string CREATE_FAIL = "Failed to create character!";
const string LOAD_FAIL = "Failed to load character!";
const string MOTD = "Welcome %s to ProjectX V4!";

// Commands
const string CMD_FORMAT = "Invalid format. The correct format is %s";

// Inventory
const string INVENTORY_FULL = "Your inventory is full.";

// Chat
const string PLAYER_OFFLINE_WHISPER = "%s seem to be offline!";