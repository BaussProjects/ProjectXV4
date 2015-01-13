module main;

import network.server;

void main() {
	import database.serverdatabase;
	if (!loadDatabase())
		return;
	run("192.168.0.15", 5816);
}