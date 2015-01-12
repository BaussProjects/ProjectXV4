module maps.space;

import std.math;

/**
*	Calculates the distance between two points.
*	Params:
*		x1 =	(Template) The first x axis.
*				Point #1
*		y1 =	(Template) The first y axis.
*				Point #1
*		x2 =	(Template) The second x axis.
*				Point #2
*		y2 =	(Template) The second y axis.
*				Point #2
*	Returns: (Template) The distance between the two points.
*/
auto getDistance(T)(T x1, T y1, T x2, T y2) {
	return cast(T)getDistanceSqrt(cast(double)x1, cast(double)y1, cast(double)x2, cast(double)y2);
}

/**
*	Calculates the distance between two points using square root.
*	Params:
*		x1 =	The first x axis.
*				Point #1
*		y1 =	The first y axis.
*				Point #1
*		x2 =	The second x axis.
*				Point #2
*		y2 =	The second y axis.
*				Point #2
*	Returns: (Template) The distance between the two points.
*/
private double getDistanceSqrt(double x1, double y1, double x2, double y2) {
	return sqrt(((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)));
}

/**
*	Checks whether two points are in range of a specific distance.
*	Params:
*		x1 =		The first x axis.
*					Point #1
*		y1 =		The first y axis.
*					Point #1
*		x2 =		The second x axis.
*					Point #2
*		y2 =		The second y axis.
*					Point #2
*		distance =	The distance of the range.
*	Returns: True if the two points are in range.
*/
bool inRange(T)(T x1, T y1, T x2, T y2, T distance) {
	return (getDistance!T(x1, y1, x2, y2) <= distance);
}

/**
*	Checks whether two points are in range of a valid distance (18).
*	Params:
*		x1 =		The first x axis.
*					Point #1
*		y1 =		The first y axis.
*					Point #1
*		x2 =		The second x axis.
*					Point #2
*		y2 =		The second y axis.
*					Point #2
*	Returns: True if the two points are in a valid range.
*/
bool validDistance(T)(T x1, T y1, T x2, T y2) {
	return inRange!T(x1, y1, x2, y2, 18);
}