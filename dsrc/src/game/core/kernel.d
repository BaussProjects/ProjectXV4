module core.kernel;

import data.item;
import std.stdio : writeln;

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