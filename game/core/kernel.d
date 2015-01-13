module core.kernel;

import data.item;
import std.stdio : writeln;
private shared Item[uint] _items;
void addKernelItem(Item i) {
	synchronized {
		auto items = cast(Item[uint])_items;
		items[i.id] = i;
		_items = cast(shared(Item[uint]))items;
	}
}

Item getKernelItem(uint id) {
	synchronized {
		auto items = cast(Item[uint])_items;
		return items[id].copy();
	}
}