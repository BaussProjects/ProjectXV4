module io.inifile;

import std.array : replace, split;
import std.string : format;
import std.algorithm : canFind;
import std.conv : to;
import std.file;

alias fexists = std.file.exists;
alias fwrite = std.file.write;

/**
*	A simple inifile wrapper.
*/
class IniFile(bool safe) {
private:
	/**
	*	The file name.
	*/
	string m_fileName;
	/**
	*	The values.
	*/
	string[string] m_values;
	/**
	*	Set to true if there has been written any values to the file.
	*/
	bool newData = false;
	
	/**
	*	Parses the ini file from a string.
	*	Params:
	*		text =	The text to parse.
	*/
	void parseFrom(string text) {
		foreach (line; split(text, "\n")) {
			if (canFind(line, "=")) {
				auto data = split(line, "=");
				if (data.length == 2) {
					if (data[1]) {
						if (data[1].length) {
							string key = data[0];
							string value = data[1];
							
							m_values[key] = value;
						}
					}
				}
			}
		}
	}
	
	/**
	*	Parses the inifile to a string.
	*	Returns: The parsed string.
	*/
	string parseTo() {
		string text;
		foreach (key; m_values.keys) {
			string value = m_values[key];			
			text ~= format("%s=%s\r\n", key, value);
		}
		return text;
	}
public:
	/**
	*	Creates a new instance of IniFile.
	*	Params:
	*		fileName =	The file name.
	*/
	this(string fileName) {
		m_fileName = fileName;
	}
	
	/**
	*	Checks whether the file exists or not.
	*	Returns: True if the file exists.
	*/
	bool exists() {
		static if (safe) {
			synchronized {
				return fexists(m_fileName);
			}
		}
		else {
			return fexists(m_fileName);
		}
	}
	
	/**
	*	Opens the inifile and parses the content.
	*/
	void open() {
		static if (safe) {
			synchronized {
				string text = readText(m_fileName);
				text = replace(text, "\r", "");
				parseFrom(text);
			}
		}
		else {
			string text = readText(m_fileName);
			text = replace(text, "\r", "");
			parseFrom(text);
		}
	}
	
	/**
	*	Closes the inifile and writes updated values to it.
	*/
	void close() {
		static if (safe) {
			synchronized {
				if (!newData) {
					m_values = null;
					return;
				}
				
				string text = parseTo;
				fwrite(m_fileName, text);
			}
		}
		else {
			if (!newData) {
				m_values = null;
				return;
			}
			
			string text = parseTo;
			fwrite(m_fileName, text);
		}
	}
	
	/**
	*	Writes a value to the inifile.
	*	Params:
	*		key =	The key.
	*		value =	The value.
	*/
	void write(T)(string key, T value) {
		static if (safe) {
			synchronized {
				newData = true;
				m_values[key] = to!string(value);
			}
		}
		else {
			newData = true;
			m_values[key] = to!string(value);
		}
	}
	
	/**
	*	Reads a value from the inifile.
	*	Params:
	*		key =	The key.
	*	Returns: (T) The read value.
	*/
	auto read(T)(string key) {
		static if (safe) {
			synchronized {
				string value = m_values[key];
				return to!T(value);
			}
		}
		else {
			string value = m_values[key];
			return to!T(value);
		}
	}
	
	/**
	*	Deletes a value from the inifile.
	*	Params:
	*		key =	The key to remove.
	*/
	void remove(string key) {
		m_values.remove(key);
	}
	
	/**
	*	Checks whether the ini file contains a specific key.
	*	Params:
	*		key =	The key to check.
	*	Returns: True if the key exists.
	*/
	bool has(string key) {
		return (m_values.get(key, null) !is null);
	}
	
	@property {
		/**
		*	Gets the keys.
		*/
		string[] keys() { return m_values.keys; }
	}
}

version (INIFILE_TEST) {
	unittest {
		writeln("BEGINS INIFILE_TEST...");
		
		try {
			auto iniFile = new IniFile!(false)("test.ini"); // Creates a new non-threadsafe inifile.
			if (iniFile.exists()) { // Checks if the ini file exists.
				iniFile.open(); // If the file exists open and read it.
				
				iniFile.write!string("str","Hello Inifile!"); // Add or update the value or "str" to "Hello Inifile!"
			}
			else {
				// If the ini file doesn't exist
				iniFile.write!int("value", 100); // Add the key "value" with the value "100" to the inifile.
				iniFile.write!string("str", "Hello World!"); // Add the key "str" with the value "Hello World!" to the inifile.
			}
			iniFile.close(); // Close the inifile. Clears the values and writes them to the file if any changes has been made.
		}
		catch (Throwable t) {
			writeln(t);
		}
		
		writeln("INIFILE_TEST ENDED...");
	}
}