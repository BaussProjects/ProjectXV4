module main;

import network.server;

void main() {
	import database.serverdatabase;
	loadDatabase();
	run("192.168.0.15", 5816);
}