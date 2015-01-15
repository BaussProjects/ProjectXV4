module dinymap.tilestats;

import dinymap.tileflag;

/**
*	Tile information class.
*/
class TileStats {
private:
	/**
	*	The flag.
	*/
	TileFlag m_flag;
	/**
	*	The height.
	*/
	ubyte m_height;
public:
	/**
	*	Creates a new instance of TileStats.
	*	Params:
	*		flag =		The flag of the tile.
	*		height =	The height of the tile.
	*/
	this(TileFlag flag, ubyte height) {
		m_flag = flag;
		m_height = height;
	}
	
	@property {
		/**
		*	Gets the flag.
		*/
		TileFlag flag() { return m_flag; }
		
		/**
		*	Gets the height.
		*/
		ubyte height() { return m_height; }
	}
}