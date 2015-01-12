module enums.entitytype;

/**
*	The types of entities.
*/
enum EntityType {
	/**
	*	The entity is a player.
	*/
	player = 0,
	/**
	*	The entity is an item.
	*/
	item = 1,
	/**
	*	The entity is a npc.
	*/
	npc = 2,
	/**
	*	The entity is a monster.
	*/
	monster = 3,
	/**
	*	The entity is a bot.
	*/
	bot = 4
}