/*
	io.safeio provides a thread-safe (by choice) wrapper for file handling.
	It provides thread-safety for both reading and writing.
*/
module io.safeio;

// version = SAFEIO_TEST;

import std.file;
alias fwrite = std.file.write;
alias fread = std.file.readText;
alias fexists = std.file.exists;
version (SAFEIO_TEST) {
	import std.stdio : writeln;
}

/**
*	Writes text to a file thread-safe.
*/
void write(string fileName, string text) {
	synchronized {
		fwrite(fileName, text);
	}
}

/**
*	Appends text to a file thread-safe.
*/
void append(string fileName, string text) {
	synchronized {
		if (fexists(fileName)) {
			auto s = fread(fileName);
			fwrite(fileName, s ~ text);
		}
		else
			fwrite(fileName, text);
	}
}

/**
*	Reads text from a file thread-safe.
*/
string read(string fileName) {
	synchronized {
		return fread(fileName);
	}
}

/**
*	Reads lines from a file thread-safe.
*/
auto readLines(string fileName) {
	auto txt = read(fileName);
	import std.array : replace, split;
	txt = replace(txt, "\r", "");
	return split(txt, "\n");
}
/**
*	Returns true if the file exists.
*	Accessing the file thread-safe.
*/
bool exists(string fileName) {
	synchronized {
		return fexists(fileName);
	}
}

version (SAFEIO_TEST) {
	unittest {
		writeln("BEGINS SAFEIO_TEST...");
		write("hello.txt", "Hello World!"); // Writes "Hello World!" to "hello.txt"
		string text = read("hello.txt"); // Reads the text from "hello.txt"
		writeln(text); // Prints out the text
		writeln("ENDED SAFEIO_TEST...");
	}
}