module core.color;

import std.c.string : memcpy;
		
/**
*	Struct for a base color scheme (Alpha, Red, Green, Blue.)
*/
struct Color {
	ubyte a;
	ubyte r;
	ubyte g;
	ubyte b;
	/**
	*	Creates a new color by ARGB.
	*	Params:
	*		_a =	The alpha channel.
	*		_r =	The red color channel.
	*		_g =	The green color channel.
	*		_b =	The blue color channel.
	*/
	this(ubyte _a, ubyte _r, ubyte _g, ubyte _b) {
		a = _a;
		r = _r;
		g = _g;
		b = _b;
	}
	
	/**
	*	Converts a color to a 32 bit unsigned int.
	*	Params:
	*		color =	The color to convert.
	*	Returns: The converted color value.
	*/
	static uint toUInt32(Color color) {
		uint val;
		memcpy(&val, &color, uint.sizeof);
		return val;
	}
}

/**
	*	Creates a color from RGB.
	*	Params:
	*		r =	The red color channel.
	*		g =	The green color channel.
	*		b =	The blue color channel.
	*	Returns: The color.
	*/
Color colorFromRGB(ubyte r, ubyte g, ubyte b) {
	return colorFromARGB(0xff, r, g, b);
}

/**
	*	Creates a color from ARGB.
	*	Params:
	*		a =	The alpha channel.
	*		r =	The red color channel.
	*		g =	The green color channel.
	*		b =	The blue color channel.
	*	Returns: The color.
	*/
Color colorFromARGB(ubyte a, ubyte r, ubyte g, ubyte b) {
	return Color(a, r, g, b);
}

/**
*	Class containing basic color schemes.
*/
static class Colors {
public:
static:
	// Contrast colors ...
	/**
	*	White color.
	*/
	Color white = colorFromRGB(0xff, 0xff, 0xff);
	/**
	*	Black color.
	*/
	Color black = colorFromRGB(0x00, 0x00, 0x00);

	// Base colors ...
	/**
	*	Red color.
	*/
	Color red = colorFromRGB(0xff, 0x00, 0x00);
	/**
	*	Green color.
	*/
	Color green = colorFromRGB(0x00, 0xff, 0x00);
	/**
	*	Blue color.
	*/
	Color blue = colorFromRGB(0x00, 0x00, 0xff);
	/**
	*	Yellow color.
	*/
	Color yellow = colorFromRGB(0xff, 0xff, 0x00);

	// Fancy colors ...
	/**
	*	Magenta color.
	*/
	Color magenta = colorFromRGB(0xff, 0x40, 0xa7);
	/**
	*	Brown color.
	*/
	Color brown = colorFromRGB(0x80, 0x4a, 0x2d);
	/**
	*	Orange color.
	*/
	Color orange = colorFromRGB(0xff, 0x81, 0x00);
	/**
	*	Light-blue color.
	*/
	Color lightBlue = colorFromRGB(0xaf, 0xee, 0xee);
	/**
	*	Light-green color.
	*/
	Color lightGreen = colorFromRGB(0x49, 0xff,0x45);
	/**
	*	Pink color.
	*/
	Color pink = colorFromRGB(0xff, 0x69, 0xb4);
}