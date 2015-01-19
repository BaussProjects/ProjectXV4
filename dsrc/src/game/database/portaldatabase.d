module database.portaldatabase;

import std.file;
import std.array : replace, split;
import std.conv : parse;

private struct PortalPoint {
	ushort startMap;
	ushort startX;
	ushort startY;
	ushort endMap;
	ushort endX;
	ushort endY;
	this(ushort sm, ushort sx, ushort sy, ushort em, ushort ex, ushort ey) {
		startMap = sm;
		startX = sx;
		startY = sy;
		endMap = em;
		endX = ex;
		endY = ey;
	}
}

alias pp = PortalPoint[];
private shared pp[ushort] _portals;

void addPortal(ushort sMap, ushort sX, ushort sY,
	ushort eMap, ushort eX, ushort eY) {
	synchronized {
		auto portals = cast(pp[ushort])_portals;
		portals[sMap] ~= PortalPoint(sMap,sX,sY,eMap,eX,eY);
		_portals = cast(shared(pp[ushort]))portals;
	}
}

import maps.mappoint;
MapPoint getPortal(ushort sMap, ushort sX, ushort sY) {
	synchronized {
		auto portals = cast(pp[ushort])_portals;
		import maps.space;
		import std.algorithm : filter;
		import std.array;
		
		auto matches = filter!((e) => inRange!ushort(sX, sY, e.startX, e.startY, 5) && sMap == e.startMap)(portals[sMap]).array;
		if (!matches || matches.length == 0)
			return MapPoint(0,0,0);
		auto p = matches.front;
		return MapPoint(p.endMap, p.endX, p.endY);
	}
}

/**
*	Loads portal info.
*/
void loadPortals() {
	auto text = readText("database\\game\\misc\\portals.ini");
	text = replace(text, "\r", "");
	foreach (line; split(text, "\n")) {
		if (line && line.length) {
			auto data = split(line, "-");
			addPortal(
				// start
				parse!ushort(data[0]),
				parse!ushort(data[1]),
				parse!ushort(data[2]),
				
				// end
				parse!ushort(data[3]),
				parse!ushort(data[4]),
				parse!ushort(data[5])
			);
		}
	}
}