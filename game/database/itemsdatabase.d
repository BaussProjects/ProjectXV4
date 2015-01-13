module database.itemsdatabase;

import std.file;
import std.array : replace, split;
import std.algorithm : canFind;
import std.conv : to;

import data.item;

void loadItems() {
	string text = readText("database\\game\\misc\\items.txt");
	text = replace(text, "\r", "");
	auto lines = split(text, "\n");
	foreach (string line; lines)
	{
		if (!line || !line.length || !canFind(line, "::"))
			continue;
			
		scope auto itemData = split(line, "::");
		auto item = new Item();
		item.id = to!uint(itemData[0]);
		item.name = itemData[1];
		item.job = to!ubyte(itemData[2]);
		item.prof = to!ubyte(itemData[3]);
		item.level = to!ubyte(itemData[4]);
		item.strength = to!ushort(itemData[5]);
		item.agility = to!ushort(itemData[6]);
		item.spirit = to!ushort(itemData[7]);
		item.tradable = ((to!ubyte(itemData[8])) > 0);
		item.price = to!uint(itemData[9]);
		item.maxDamage = to!uint(itemData[10]);
		item.minDamage = to!uint(itemData[11]);
		item.defense = to!uint(itemData[12]);
		item.dexterity = to!uint(itemData[13]);
		item.dodge = to!uint(itemData[14]);
		item.hp = to!ushort(itemData[15]);
		item.mp = to!ushort(itemData[16]);
		if (item.isArrow()) {
			item.maxAmount = to!ushort(itemData[18]);
			item.amount = item.maxAmount;
		}
		else if (!item.isMisc()) {
			item.maxDura = 100;
			item.dura = 100;
		}
		item.magicAttack = to!uint(itemData[19]);
		item.magicDefense = to!uint(itemData[20]);
		item.range = to!int(itemData[21]);
		item.frequency = to!int(itemData[22]);
		item.cpsPrice = to!uint(itemData[23]);
		
		import core.kernel;
		addKernelItem(item);
	}
}