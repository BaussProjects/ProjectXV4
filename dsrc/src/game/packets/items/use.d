module packets.items.use;

import packets.itemusage;
import packets.item : ItemPosition;
import entities.gameclient;
import data.item;

/**
*	Handles the item usage packet.
*	Sub-type: equip (use)
*	Params:
*		client =	The game client.
*		item =	The packet.
*/
void handleUse(GameClient client, ItemUsagePacket item) {
	uint uid = item.uid;
	auto pos = cast(ItemPosition)item.dwParam1;
	auto i = client.inventory.getItemByUID(uid);
	if (i !is null) {
		if (!i.isMisc()) {
			if (client.equipments.equip(i, pos)) {
				client.inventory.removeItemByUID(uid);
			}
		} else {
			switch (i.id) {
				case 1000000:
				case 1000010:
				case 1000020:
				case 1000030:
				case 1002010:
				case 1002020:
				case 1002050: {
					import packets.items.handlers.hppotions;
					useHpPotion(client, i);
					break;
				}
				
				default: {
					// can't use ...
					break;
				}
			}
		}
	}
}

/**
*	Handles the item usage packet.
*	Sub-type: unequip
*	Params:
*		client =	The game client.
*		item =	The packet.
*/
void handleUnequip(GameClient client, ItemUsagePacket item) {
	auto pos = cast(ItemPosition)item.dwParam1;
	client.equipments.unequip(pos);
}