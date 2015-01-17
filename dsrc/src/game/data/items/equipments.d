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
	
	bool equip(Item item, ItemPosition pos, bool force = false) {
		synchronized {
			if (!force) {
				if (pos == ItemPosition.left && !contains(ItemPosition.right)) {
					return false;
				}
				// do sex check (also get that shit from item data ...)
				
				// do job check
				
				// do prof check
				
				// do pos check ...
				if (item.isHeadGear() && pos != ItemPosition.head ||
					item.isArmor() && pos != ItemPosition.armor ||
					item.isNecklace() && pos != ItemPosition.necklace ||
					item.isRing() && pos != ItemPosition.ring ||
					item.isBoots() && pos != ItemPosition.boots ||
					item.isBottle() && pos != ItemPosition.bottle ||
					item.isGarment() && pos != ItemPosition.garment) {
					return false;
				}
				
				if (item.isTwoHand() && contains(ItemPosition.left)) {
					return false;
				}
				
				if (item.isTwoHand() && pos != ItemPosition.right ||
					item.isOneHand() && pos != (ItemPosition.right || ItemPosition.left)) {
					return false;
				}
				if (item.isOneHand() && pos == ItemPosition.left && m_owner.level < 40) {
					return false;
				}
				if (item.isShield() && pos != ItemPosition.left ||
					item.isShield() && m_owner.level < 40) {
					return false;
				}
					
				// do stats check ...
				if (item.level > 70 || m_owner.reborns == 0) {
					if (item.strength > m_owner.strength ||
						item.agility > m_owner.agility ||
						item.spirit > m_owner.spirit) {
						return false;
					}
				}
				
				if (contains(pos)) {
					if (!unequip(pos))
						return false;
				}
			}
			import std.stdio : writeln;
			m_equips[pos] = item;
			m_owner.updateBaseStats();
			item.send(m_owner, ItemMode.def, pos);
			m_owner.send(new ItemUsagePacket(item.uid, ItemAction.equip, cast(uint)pos));
			m_owner.send(new ItemUsagePacket(item.uid, ItemAction.setEquipPosition, cast(uint)pos));
			m_owner.updateSpawn();
			import database.playerdatabase;
			updateCharacterEquipments(m_owner, item, cast(ushort)pos);
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
					m_owner.updateSpawn();
					import database.playerdatabase;
					removeCharacterEquipments(m_owner, cast(ushort)pos);
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