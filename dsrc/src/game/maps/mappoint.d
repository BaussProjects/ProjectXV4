module maps.mappoint;

struct MapPoint {
private:
	ushort m_map;
	ushort m_x;
	ushort m_y;
public:
	this(ushort map, ushort x, ushort y) {
		m_map = map;
		m_x = x;
		m_y = y;
	}
	
	@property {
		ushort map() { return m_map; }
		ushort x() { return m_x; }
		ushort y() { return m_y; }
	}
}