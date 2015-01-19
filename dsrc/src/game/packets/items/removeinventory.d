module packets.items.removeinventory;

import packets.itemusage;
import entities.gameclient;

/**
*	Handles the item usage packet.
*	Sub-type: removeInventory (use)
*	Params:
*		client =	The game client.
*		item =	The packet.
*/
void handleRemoveInventory(GameClient client, ItemUsagePacket item) {
	auto i = client.inventory.getItemByUID(item.uid, true);
		if (i !is null)
			i.drop(client.map, client.x, client.y);
}