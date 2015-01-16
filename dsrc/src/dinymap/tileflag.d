 module dinymap.tileflag;
 
 /**
 *	Enumeration for tile flags.
 */
 enum TileFlag : ubyte {
	invalid = 0x01,
	portal = 0x02,
	item = 0x04,
	monster = 0x08,
	npc = 0x10,
	blessed = 0x12
}