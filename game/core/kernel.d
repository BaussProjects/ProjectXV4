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