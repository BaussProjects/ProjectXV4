module packets.itemusage;

/**
*	Enumeration of item actions.
*/
enum ItemAction : uint {
    buyItem = 0x01,
    sellItem = 0x02,
    removeInventory = 0x03,
    equip = 0x04,
    setEquipPosition = 0x05,
    unequip = 0x06,
    upgradeEnchant = 0x07,
    showWarehouseMoney = 0x09,
    depositWarehouse = 0x0A,
    withdrawWarehouseMoney = 0x0B,
    repairItem = 0x0E,
    updateDurability = 0x11,
    removeEquipment = 0x12,
    upgradeDragonball = 0x13,
    upgradeMeteor = 0x14,
    showVendingList = 0x15,
    addVendingItemGold = 0x16,
    removeVendingItem = 0x17,
    buyVendingItem = 0x18,
    updateArrowCount = 0x19,
    particleEffect = 0x1A,
    ping = 0x1B,
    updateEnchant = 0x1C,
    addVendingItemConquerPts = 0x1D,
    updatePurity = 0x23,
    dropItem = 0x25,
    dropGold = 0xC
}

import network.packet;
import packets : Packet, PacketType;
import core.gametime;
import entities.gameclient;
		
/**
*	The item usage packet.
*/
class ItemUsagePacket : DataPacket {
private:
	/**
	*	The uid.
	*/
	uint m_uid;
	/**
	*	The first DWORD parameter.
	*/
	uint m_dwParam1;
	/**
	*	The action.
	*/
	ItemAction m_action;
	/**
	*	The time stamp.
	*/
	uint m_timeStamp;
	
	/**
	*	The second DWORD parameter.
	*/
	uint m_dwParam2;
	
	/**
	*	The third DWORD parameter.
	*/
	uint m_dwParam3;
public:
	/**
	*	Creates a new instance of ItemUsagePacket.
	*	Params:
	*		packet =	The packet.
	*/
	this(DataPacket packet) {
		super(packet);
		
		go(4);
		m_uid = read!uint;
		m_dwParam1 = read!uint;
		m_action = cast(ItemAction)read!uint;
		m_timeStamp = read!uint;
		m_dwParam2 = read!uint;
	}
	
	/**
	*	Creates a new instance of ItemUsagePacket.
	*	Params:
	*		uid =		The uid.
	*		action =	The action.
	*/
	this(uint uid, ItemAction action) {
		super(PacketType.itemUsage, 24);
		write!uint(uid);
		writeEmpty(12);
		write!uint(cast(uint)action);
	}
	
	/**
	*	Creates a new instance of ItemUsagePacket.
	*	Params:
	*		uid =		The uid.
	*		action =	The action.
	*/
	this(uint uid, ItemAction action, uint dwParam1) {
		super(PacketType.itemUsage, 24);
		write!uint(uid);
		write!uint(dwParam1);
		write!uint(cast(uint)action);
	}
	
	@property {
		/**
		*	Gets the uid.
		*/
		uint uid() { return m_uid; }
		/**
		*	Gets the first DWORD parameter.
		*/
		uint dwParam1() { return m_dwParam1; }
		/**
		*	Gets the action.
		*/
		ItemAction action() { return m_action; }
		/**
		*	Gets the time stamp.
		*/
		uint timeStamp() { return m_timeStamp; }
		
		/**
		*	Gets the second DWORD parameter.
		*/
		uint dwParam2() { return m_dwParam2; }
	}
}

/**
*	Handles the item usage packet.
*	Params:
*		client =	The game client.
*		packet =	The packet.
*/
@Packet(PacketType.itemUsage)
void handleItemUsage(GameClient client, DataPacket packet) {
	scope auto item = new ItemUsagePacket(packet);
	
	import packets.items.use;
	
	switch (item.action) {
		case ItemAction.ping: {
			client.send(packet);
			break;
		}
		
		case ItemAction.equip: handleUse(client, item); break;
		case ItemAction.unequip: handleUnequip(client, item); break;
		
		default: {
			import std.stdio : writefln;
			writefln("Unknown Sub-type: [%s]%s", "Item Usage", item.action);
			break;
		}
	}
}