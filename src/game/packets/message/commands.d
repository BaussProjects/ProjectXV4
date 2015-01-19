module packets.commands;

import entities.gameclient;
import std.string : isNumeric, toLower;

/**
*	Handles the commands.
*	Params:
*		client =		The client that sent the command.
*		command =		The command array.
*		commandText =	The command text.
*/
void handleCommands(GameClient client, string[] command, string commandText) {
	if (command.length > 1) {
		commandText = commandText[command[0].length + 1 .. $];
	}
	
	switch (toLower(command[0][1 .. $])) {
		case "dc": cmd_dc(client); break;
		case "mm": cmd_mm(client, command); break;
		case "savemap": cmd_saveMap(client, commandText); break;
		case "item": cmd_item(client, command); break;
		case "ritem": cmd_ritem(client, command); break;
		case "clearinv": cmd_clearinv(client); break;
		case "ditem2": cmd_ditem(client, command); break;
		default: {
			break;
		}
	}
}

private {
	/**
	*	Tries to parse a numeric value from an input.
	*	Params:
	*		input =		The input to parse.
	*		res =		(out) The resulting value.
	*	Returns: True if the parsing was a success.
	*/
	bool tryParse(T)(string input, out T res) {
		res = 0;
		if (!input || !input.length)
			return false;
		if (!isNumeric(input))
			return false;
		import std.conv : parse;
		res = parse!T(input);
		return true;
	}
	
	/**
	*	Reports invalid formats to the client.
	*/
	void reportFormat(GameClient client, string frmt) {
		import std.string : format;
		import packets.messagecore;
		import core.msgconst;
			client.send(createSystemMessage(format(CMD_FORMAT, frmt)));
	}
	
	/**
	*	Handles the @dc | /dc command.
	*/
	void cmd_dc(GameClient client) {
		client.disconnect("Command");
	}
	
	/**
	*	Handles the @mm | /mm command.
	*/
	void cmd_mm(GameClient client, string[] command) {
		ushort mapid;
		ushort x;
		ushort y;
		
		if (command.length != 4 ||
			!tryParse!ushort(command[1], mapid) ||
			!tryParse!ushort(command[2], x) ||
			!tryParse!ushort(command[3], y)) {
			reportFormat(client, "@mm mapid x y | /mmm mapid x y");
			return;
		}
		client.teleport(mapid, x, y);
	}
	
	void cmd_saveMap(GameClient client, string commandText) {
		client.map.save(commandText);
	}
	
	void cmd_item(GameClient client, string[] command) {
		uint itemid;
		if (!tryParse!uint(command[1], itemid)) {
			reportFormat(client, "@item id | /item id");
			return;
		}
		client.inventory.addItem(itemid);
	}
	void cmd_ritem(GameClient client, string[] command) {
		uint itemid;
		ubyte count;
		if (command.length != 3 || !tryParse!uint(command[1], itemid) || !tryParse!ubyte(command[2], count)) {
			reportFormat(client, "@ritem id count | /ritem id count");
			return;
		}
		client.inventory.removeItemById(itemid, count);
	}
	
	void cmd_clearinv(GameClient client) {
		client.inventory.clear();
	}
	
	void cmd_ditem(GameClient client, string[] command) {
		uint itemid;
		if (command.length != 2 || !tryParse!uint(command[1], itemid)) {
			reportFormat(client, "@ditem id | /ditem id");
			return;
		}
		import core.kernel;
		auto i = getKernelItem(itemid);
		i.drop(client.map, client.x, client.y);
	}
}