module data.inventory;

import std.string : format;

import data.item;
import packets.messagecore;
import core.msgconst;
import core.kernel;
import entities.gameclient;

/**
*	An inventory wrapper.
*/
class Inventory {
private:
	/**
	*	The items in the inventory.
	*/
	Item[byte] m_items;
	/**
	*	The owner of the inventory.
	*/
	GameClient m_owner;
	
	/**
	*	Finds a valid position within the inventory.
	*	Returns: Returns the valid position or -1 for full inventory.
	*/
	byte findPosition() {
		foreach (byte pos; 0 .. 40) {
			if (m_items.get(pos, null) is null)
				return pos;
		}
		return -1;
	}
public:
	/**
	*	Creates a new instance of Inventory.
	*	Params:
	*		owner =		The owner of the inventory.
	*/
	this(GameClient owner) {
		m_owner = owner;
	}
	
	/**
	*	Adds an item to the inventory by its id.
	*	Params:
	*		id =		The id of the item to add.
	*	Returns: True if the item was added, false if the inventory is full.
	*/
	bool addItem(uint id) {
		return addItem(getKernelItem(id));
	}
	
	/**
	*	Adds an item to the inventory by an item reference.
	*	Params:
	*		i =		The item reference.
	*	Returns: True if the item was added, false if the inventory is full.
	*/
	bool addItem(Item i, byte pos = -1) {
		synchronized {
			if (pos == -1)
				pos = findPosition();
			if (pos == -1) {
				m_owner.send(createSystemMessage(INVENTORY_FULL));
				return false;
			}
			m_items[pos] = i;
			import packets.item;
			i.send(m_owner, ItemMode.def, ItemPosition.inventory);
			import database.playerdatabase;
			updateCharacterInventory(m_owner, i, pos);
		}
		return true;
	}
	
	auto getItemByUID(uint uid, bool remove = false) {
		synchronized {
			foreach (byte pos; m_items.keys) {
				if (m_items[pos].uid == uid) {
					auto item = m_items[pos];
					if(remove) {
						m_items.remove(pos);
						import packets.itemusage;
						m_owner.send(new ItemUsagePacket(uid, ItemAction.removeInventory));
						import database.playerdatabase;
						removeCharacterInventory(m_owner, pos);
					}
					return item;
				}
			}
		}
		return null;
	}
	
	/**
	*	Removes an item from the inventory by its uid.
	*/
	void removeItemByUID(uint uid) {
		synchronized {
			foreach (byte pos; m_items.keys) {
				if (m_items[pos].uid == uid) {
					m_items.remove(pos);
					import packets.itemusage;
					m_owner.send(new ItemUsagePacket(uid, ItemAction.removeInventory));
					import database.playerdatabase;
					removeCharacterInventory(m_owner, pos);
					return;
				}
			}
		}
	}
	
	/**
	*	Removes an item from the inventory by its id and optional count.
	*/
	void removeItemById(uint id, ubyte count = 1) {
		ubyte c = 0;
		synchronized {
			foreach (byte pos; m_items.keys) {
				if (m_items[pos].id == id) {
					auto item = m_items[pos];
					m_items.remove(pos);
					import packets.itemusage;
					m_owner.send(new ItemUsagePacket(item.uid, ItemAction.removeInventory));
					import database.playerdatabase;
					removeCharacterInventory(m_owner, pos);
					c++;
					if (c >= count)
						return;
				}
			}
		}
	}
	
	/**
	*	Clears the inventory.
	*/
	void clear() {
		synchronized {
			foreach (byte pos; m_items.keys) {
				scope auto item = m_items[pos];
				m_items.remove(pos);
				import packets.itemusage;
				m_owner.send(new ItemUsagePacket(item.uid, ItemAction.removeInventory));
				import database.playerdatabase;
				wipeCharacterInventory(m_owner);
			}
		}
	}
}