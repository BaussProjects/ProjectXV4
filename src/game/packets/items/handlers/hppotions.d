module packets.items.handlers.hppotions;

import packets.item : ItemPosition;
import entities.gameclient;
import data.item;

private enum hpmatcher = [
	1000000 : 70,
	1000010 : 100,
	1000020 : 250,
	1000030 : 500,
	1002010 : 1200,
	1002020 : 2000,
	1002050 : 3000
];

void useHpPotion(GameClient client, Item item) {
	int hp = hpmatcher.get(item.id, -1);
	if (hp > 0) {
		if (client.hp < client.maxHp) {
			client.inventory.removeItemByUID(item.uid);
			client.hp = (client.hp + hp);
		}
	}
}