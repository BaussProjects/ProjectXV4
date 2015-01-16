module data.equipments;

import entities.gameclient;
import data.item;
import packets.item;
import packets.itemusage;

class Equipments {
private:
	GameClient m_owner;
	Item[ItemPosition] m_equips;
	uint[ItemPosition] m_maskedEquips;
public:
	this(GameClient owner) {
		m_owner = owner;
	}
	
	bool contains(ItemPosition pos) {
		synchronized {
			return (m_equips.get(pos, null) !is null);
		}
	}
	
	bool containsMask(ItemPosition pos) {
		synchronized {
			return (m_maskedEquips.get(pos, -1) >= 0);
		}
	}
	
	bool equip(Item item, ItemPosition pos) {
		synchronized {
			if (contains(pos)) {
				if (!unequip(pos))
					return false;
			}
			import std.stdio : writeln;
			m_equips[pos] = item;
			m_owner.updateBaseStats();
			item.send(m_owner, ItemMode.def, pos);
			m_owner.send(new ItemUsagePacket(item.uid, ItemAction.equip, cast(uint)pos));
			return true;
		}
	}
	
	void mask(uint id, ItemPosition pos) {
		synchronized {
			m_maskedEquips[pos] = id;
		}
	}
	
	bool unequip(ItemPosition pos) {
		synchronized {
			if (contains(pos)) {
				auto item = m_equips[pos];
				if (m_owner.inventory.addItem(item)) {
					m_equips.remove(pos);
					m_owner.updateBaseStats();
					item.send(m_owner, ItemMode.def, pos);
					m_owner.send(new ItemUsagePacket(item.uid, ItemAction.unequip, cast(uint)pos));
					return true;
				}
				else
					return false;
			}
		}
		return true;
	}
	
	void unmask(ItemPosition pos) {
		synchronized {
			if (containsMask(pos)) {
				m_maskedEquips.remove(pos);
			}
		}
	}
	
	Item getEquipByPositionn(ItemPosition pos) {
		synchronized {
			return m_equips[pos];
		}
	}
	
	uint getMaskByPosition(ItemPosition pos) {
		synchronized {
			return m_maskedEquips[pos];
		}
	}
}