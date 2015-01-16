module threading.dict;

import std.string : format;

/**
*	Exception type made for dict handlers.
*/
class DictException : Throwable {
public:
	/**
	*	Creates a new instance of DictException.
	*	Params:
	*		msg =	The message of the exception.
	*/
	this(string msg) {
		super(msg);
	}
}

/**
*	A key value based dict collection.
*/
class Dict(TKey,TValue) {
private:
	/**
	*	The values.
	*/
	TValue[TKey] m_values;
public:
	/**
	*	Creates a new instance of Dict.
	*/
	this() { }
	
	/**
	*	Adds a value to the collection.
	*	Params:
	*		key =	The key to add.
	*		value =	The value to add.
	*/
	void add(TKey key, TValue value) {
		if (contains(key))
			throw new DictException(format("%s already exists in the collection.", key));
		synchronized {
			m_values[key] = value;
		}
	}
	
	/**
	*	Removes a value from the collection.
	*	Params:
	*		key =	The key to remove.
	*/
	void remove(TKey key) {
		if (!contains(key))
			throw new DictException(format("%s does not exist in the collection.", key));
		synchronized {	
			m_values.remove(key);
		}
	}
	
	/**
	*	Checks whether a key exists in the map.
	*	Params:
	*		key =	The key to check.
	*	Returns: True if the key exists.
	*/
	bool contains(TKey key) {
		synchronized {
			return (m_values.get(key, null) !is null);
		}
	}
	
	/**
	*	Gets a value from the collection.
	*	Params:
	*		key =	The key.
	*	Returns: The value.
	*/
	TValue get(TKey key) {
		if (!contains(key))
			throw new DictException(format("%s does not exist in the collection.", key));
		synchronized {
			return m_values[key];
		}
	}
	
	@property {
		/**
		*	Gets the values.
		*/
		TValue[] values() { return m_values.values; }
		/**
		*	Gets the keys.
		*/
		TKey[] keys() { return m_values.keys; }
	}
}