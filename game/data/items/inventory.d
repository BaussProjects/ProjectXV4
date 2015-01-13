module data.inventory;

import std.string : format;

import data.item;
import packets.messagecore;
import core.msgconst;
import core.kernel;
import entities.gameclient;

class Inventory {
private:
	Item[byte] m_items;
	GameClient m_owner;
	
	byte findPosition() {
		foreach (byte pos; 0 .. 40) {
			if (m_items.get(pos, null) is null)
				return pos;
		}
		return -1;
	}
public:
	this(GameClient owner) {
		m_owner = owner;
	}
	
	void addItem(uint id) {
		addItem(getKernelItem(id));
	}
	void addItem(Item i) {
		synchronized {
			auto pos = findPosition();
			if (pos == -1) {
				m_owner.send(createSystemMessage(INVENTORY_FULL));
				return;
			}
			m_items[pos] = i;
			import packets.item;
			i.send(m_owner, ItemMode.def, ItemPosition.inventory);
			import database.playerdatabase;
			updateCharacterInventory(m_owner, i, pos);
		}
	}
	
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