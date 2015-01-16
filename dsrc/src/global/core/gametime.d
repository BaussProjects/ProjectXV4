module core.gametime;

import std.datetime;

/**
*	Gets the current time's timestamp.
*/
uint getTimeStamp() {
	scope auto time = Clock.currTime();
	auto timeVal = time.toTimeVal();
	import std.c.string : memcpy;
	uint timeStamp;
	memcpy(&timeStamp, &timeVal, uint.sizeof);
	return timeStamp;
}