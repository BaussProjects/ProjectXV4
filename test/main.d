module main;

void main() {
	import std.stdio : writeln, readln;
	
	import filtertest;
	run_filtertest();
	
	import filterparallelismtest;
	run_filterparallelismtest();
	
	writeln("All tests finished...");
	readln();
}