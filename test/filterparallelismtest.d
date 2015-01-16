module filterparallelismtest;

import std.stdio : stdout, writefln, writeln, readln;
import std.algorithm : filter;
import std.math : sqrt;
import std.parallelism;
import std.datetime : StopWatch;

private struct Point {
	ushort x;
	ushort y;
	this(ushort x, ushort y) {
		this.x = x;
		this.y = y;
	}
}

private class PointObject {
	Point p;
	this(Point p) {
		this.p = p;
	}
}

void run_filterparallelismtest() {
	writefln("%s is running...", __MODULE__);
	PointObject[Point] pointObjects;
	
	writeln("Creating points...");
	foreach (ushort x; 0 .. 1000) {
		foreach (ushort y; 0 .. 1000) {
			auto p = Point(y, x);
			pointObjects[p] = new PointObject(p);
		}
	}
	writefln("%s points created...", pointObjects.length);
	
	ushort centerX = 100;
	ushort centerY = 100;
	ushort distance = 18;
	
	auto getDistance(T)(T x1, T y1, T x2, T y2) {
		return cast(T)getDistanceSqrt(cast(double)x1, cast(double)y1, cast(double)x2, cast(double)y2);
	}

	double getDistanceSqrt(double x1, double y1, double x2, double y2) {
		return sqrt(((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2)));
	}
	
	bool inRange(T)(T x1, T y1, T x2, T y2, T distance) {
		return (getDistance!T(x1, y1, x2, y2) <= distance);
	}
	
	StopWatch sw;
	sw.start();
	writeln("Test started...");
	writeln("Finding points...");
	auto points = filter!(a => inRange!ushort(centerX, centerY, a.p.x, a.p.y, distance))(pointObjects.values);
	writeln("Found points...");
	
	writeln("Iterating points...");
	/*foreach (p; points) {
		writefln("x: %s y: %s", p.p.x, p.p.y);
	}*/
	foreach(i, ref p; taskPool.parallel(points)) {
		writefln("x: %s y: %s", p.p.x, p.p.y);
	}

	writeln("Iterating finished...");
	sw.stop();
	writefln("%s finished in %s msecs...", __MODULE__, sw.peek().msecs);
	readln();
	// clear console ...
	auto cb = new void[1024];
	stdout.rawWrite(cb);
	writeln();
}