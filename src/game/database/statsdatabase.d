module database.statsdatabase;

import std.conv : to;
import std.array : split;

import core.kernel;
import io.inifile;

/**
*	Loads stats.
*/
void loadStats() {
	void loadStat(string file, ubyte job) {
		scope auto ini = new IniFile!(true)("database\\game\\misc\\" ~ file);
		if (ini.exists()) {
			ini.open();
			
			foreach (key; ini.keys) {
				ubyte level = to!ubyte(key);
				string data = ini.read!string(key);
				auto stats = split(data, "-");
				addKernelStats(job, level, [
					to!ushort(stats[0]),
					to!ushort(stats[1]),
					to!ushort(stats[2]),
					to!ushort(stats[3])
				]);
			}
		}
	}
	loadStat("trojan.ini", 10);
	loadStat("warrior.ini", 20);
	loadStat("archer.ini", 40);
	loadStat("taoist.ini", 100);
}