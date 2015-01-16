module network.packet;

import std.c.string;

version (Windows) {
	/**
	*	The new line on windows.
	*/
	private const string newLine = "\r\n";
}
else {
	/**
	*	The new line on other systems.
	*/
	private const string newLine = "\n";
}

/**
*	A data packet class.
*/
class DataPacket {
protected:
	/**
	*	The data packet buffer.
	*/
	ubyte[] b;
	/**
	*	The current read offset.
	*/
	size_t offset = 0;
	
	/**
	*	Creates a new instance of DataPacket.
	*/
	this() { }
public:
	/**
	*	Creates a new instance of DataPacket.
	*	Params:
	*		type =	The type of the packet.
	*		size =	The size of the packet.
	*/
	this(ushort type, ushort size) {
		assert(size < 1024);
		write!ushort(size);
		write!ushort(type);
	}
	
	/**
	*	Creates a new instance of DataPacket.
	*	Params:
	*		buffer =	The buffer.
	*/
	this(ubyte[] buffer) {
		assert(buffer !is null);
		assert(buffer.length > 4);
		
		b = buffer.dup;
	}
	
	/**
	*	Creates a new instance of DataPacket.
	*	Params:
	*		packet =	The packet.
	*/
	this(DataPacket packet) {
		assert(packet !is null);
		assert(packet.plength > 4);
		b = packet.b.dup;
	}
	
	/**
	*	Appends bytes to the buffer.
	*	Params:
	*		buffer =	The buffer to append.
	*/
	void writeBuffer(ubyte[] buffer) {
		b ~= buffer;
	}
	
	/**
	*	Writes an empty buffer until the specific offset.
	*	Params:
	*		toOffset =	The offset to reach.
	*/
	void writeEmpty(size_t toOffset) {
		while (b.length < toOffset)
			write!ubyte(0);
	}
	
	/**
	*	Writes a value to the buffer.
	*	Params:
	*		value =		The value to write.
	*/
	void write(T)(T value) {
		ubyte[] pBuffer = new ubyte[T.sizeof];
		auto ptr = &value;
		memcpy(pBuffer.ptr, ptr, T.sizeof);
		writeBuffer(pBuffer);
	}
	
	/**
	*	Writes a string value to the buffer.
	*	Params:
	*		value =		The string value to write.
	*/
	void writeString(string value) {
		writeBuffer(cast(ubyte[])value);
	}
	
	/**
	*	Reads a value from the buffer.
	*	Returns: The value read.
	*/
	auto read(T)() {
		ubyte[] pBuffer = b[offset .. (offset + T.sizeof)];
		T val;
		memcpy(&val, pBuffer.ptr, T.sizeof);
		offset += T.sizeof;
		return val;
	}
	
	/**
	*	Reads a buffer value.
	*	Params:
	*		size =	The size of the buffer to read.
	*	Returns: The value read.
	*/
	ubyte[] readBuffer(size_t size) {
		ubyte[] pBuffer = b[offset .. (offset + size)];
		offset += size;
		return pBuffer;
	}
	
	/**
	*	Reads a string value.
	*	Params:
	*		size =	The size of the string to read.
	*	Returns: The string value read.
	*/
	string readString(size_t size) {
		import std.array : replace;
		return replace(cast(string)readBuffer(size), "\0", "");
	}
	
	/**
	*	Skips offsets for reading.
	*	Params:
	*		offsets =	The amount of offsets to skip.
	*/
	void skip(size_t offsets = 1) {
		offset += offsets;
	}
	
	/**
	*	Goes to a specific offset for reading.
	*	Params:
	*		offset =	The offset to go to.
	*/
	void go(size_t offset) {
		this.offset = offset;
	}
	
	@property {
		/**
		*	Gets the final buffer.
		*/
		ubyte[] buffer() {
			ushort vlen = vlength;
			while (b.length != vlen) {
				write!ubyte(0);
			}
			return b;
		}
		
		ubyte[] pBuffer() {
			return b;
		}
		
		/**
		*	Gets the physical length of the packet.
		*/
		size_t plength() {
			return b.length;
		}
		
		/**
		*	Gets the virtual length of the packet.
		*/
		ushort vlength() {
			size_t oldOffset = offset;
			offset = 0;
			ushort size = read!ushort;
			offset = oldOffset;
			return size;
		}
		
		/**
		*	Gets the packet type.
		*/
		ushort ptype() {
			size_t oldOffset = offset;
			offset = 2;
			ushort p = read!ushort;
			offset = oldOffset;
			return p;
		}
	}
	
	/**
	*	Gets the string of the packet.
	*	Returns the string of the packet.
	*/
	override string toString() {
		import std.conv : to;
		import std.string : format;
		
		string s = format("Packet: %s P-Size: %s V-Size: %s", ptype, plength, vlength);
		s ~= newLine;
		s ~= "bytes[";
		foreach (v; b) {
			s ~= "0x" ~ to!string(v, 16) ~ ", ";
		}
		s.length -= 2;
		s ~= "]";
		s ~= newLine;
		s ~= "text('";
		foreach (v; b) {
			s ~= (v >= 32 && v <= 126 ? cast(char)v : '.');
		}
		return s ~ "')";
	}
}

/**
*	A string packer class.
*/
class StringPacker {
public:
static:
	/**
	*	Packs the strings into a packet.
	*	Params:
	*		packet =	The packet to pack the strings into.
	*		strings =	The strings to pack.
	*/
	void pack(DataPacket packet, string[] strings) {
		packet.write!ubyte(cast(ubyte)strings.length);
		foreach (s; strings) {
			if (s) {
				packet.write!ubyte(cast(ubyte)s.length);
				if (s.length)
					packet.writeString(s);
			}
			else
				packet.write!ubyte(0);
		}
	}
	
	/**
	*	Unpacks strings from a packet.
	*	Params:
	*		packet =	The packet to unpack strings from.
	*	Returns: The unpacked strings.
	*/
	string[] unpack(DataPacket packet) {
		string[] strings;
		ubyte stringCount = packet.read!ubyte;
		foreach (i; 0 .. stringCount) {
			ubyte stringSize = packet.read!ubyte;
			if (stringSize > 0) {
				strings ~= packet.readString(stringSize);
			}
			else
				strings  ~= null;
		}
		return strings;
	}
}