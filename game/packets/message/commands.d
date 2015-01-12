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
	void reportFormat(GameClient client, string format) {
		// TODO: Report ...
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
}