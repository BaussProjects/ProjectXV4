module dinymap.tinymap;

import std.stdio;
import std.c.string : memcpy;
import std.conv : to;

import dinymap.tilestats;
import dinymap.tileflag;

/**
*	Structure used for a point array.
*/
struct TilePoint {
	/**
	*	The x axis.
	*/
	ushort x;
	/**
	*	The y axis.
	*/
	ushort y;
	/**
	*	Creates a new instance of TilePoint.
	*	Params:
	*		x =		The x axis.
	*		y =		The y axis.
	*/
	this(ushort x, ushort y) {
		this.x = x;
		this.y = y;
	}
}

/**
*	Tiny map implementation in D.
*/
class TinyMap {
private:
	/**
	*	The tiles.
	*/
	TileStats[TilePoint] m_tiles;
	/**
	*	The maximum x coordinate (Width)
	*/
	ushort m_maxX;
	/**
	*	The maximum y coordinate (Height)
	*/
	ushort m_maxY;
	/**
	*	Boolean determining whether the map has been loaded or not.
	*/
	bool m_loaded;
protected:
	/**
	*	Creates a  new instance of TinyMap.
	*/
	this() {
		m_loaded = false;
	}

public:
	/**
	*	Loads the map.
	*	Params:
	*		mapId =		The map id.
	*/
	void load(ushort mapId) {
		synchronized {
			if (m_loaded)
				return;
			string tinymap = "database\\game\\tinymap\\" ~ to!string(mapId) ~ ".TinyMap";
			import std.file : exists;
			if (!exists(tinymap)) {
				m_loaded = true;
				return;
			}
			
			//ulong size = getSize(dmap);
			scope auto mapFile = File(tinymap, "r");
		
			auto read(T)() {
				T val;
				auto buf = mapFile.byChunk(T.sizeof).front;
				memcpy(&val, buf.ptr, T.sizeof);
				return val;
			}
		
			ushort _mapId = read!ushort;
			m_maxX = read!ushort;
			m_maxY = read!ushort;
		
			foreach (ushort x; 0 .. m_maxX) {
				foreach (ushort y; 0 .. m_maxY) {
					auto tile = new TileStats(cast(TileFlag)read!ubyte, 0);//read!ubyte);
					m_tiles[TilePoint(x,y)] = tile;
				}
			}
			mapFile.close(); // Not sure if necessary because of scope? Keeping it there for safety.
			m_loaded = true;
		}
	}
	
	/**
	*	Validates a specific coordinate.
	*	Params:
	*		x =		The x axis to validate.
	*		y =		The y axis to valdate.
	*	Returns: True if the coordinate is valid.
	*/
	bool validCoord(ushort x, ushort y) {
		if (!m_loaded)
			return true;
		auto p = TilePoint(x, y);
		if (x < m_maxX && y < m_maxY) {
			auto tile = m_tiles.get(p, null);
			if (tile is null)
				return true; // There is no specific tile setting for the point
			return tile.flag != TileFlag.invalid;
		}
		return false; // The point is outside of the map
	}
}