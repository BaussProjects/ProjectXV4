module threading.selector;

import std.string : format;

/**
*	Exception type made for selector handlers.
*/
class SelectorException : Throwable {
public:
	/**
	*	Creates a new instance of SelectorException.
	*	Params:
	*		msg =	The message of the exception.
	*/
	this(string msg) {
		super(msg);
	}
}

/**
*	A 2-key value based selector collection.
*/
class Selector(TKey1,TKey2,TValue) {
private:
	/**
	*	The key1-values.
	*/
	TValue[TKey1] m_values1;
	/**
	*	The key2 values.
	*/
	TValue[TKey2] m_values2;
	/**
	*	The key1-key2 keys.
	*/
	TKey1[TKey2] m_keys1;
	/**
	*	The key2-key1 keys.
	*/
	TKey2[TKey1] m_keys2;
public:
	/**
	*	Creates a new instance of Selector.
	*/
	this() { }
	
	/**
	*	Adds a value to the collection.
	*	Params:
	*		key1 =	The first key.
	*		key2 =	The second key.
	*		value =	The value.
	*/
	void add(TKey1 key1, TKey2 key2, TValue value) {
		if (contains(key1) || contains(key2))
			throw new SelectorException(format("%s and %s already exists in the collection.", key1, key2));
		synchronized {
			m_values1[key1] = value;
			m_values2[key2] = value;
			
			m_keys1[key2] = key1;
			m_keys2[key1] = key2;
		}
	}
	
	/**
	*	Removes a value from the collection.
	*	Params:
	*		key =	The key.
	*/
	void remove(TKey1 key) {
		if (!contains(key))
			throw new SelectorException(format("%s does not exist in the collection.", key));
		synchronized {	
			m_values1.remove(key);
			auto key2 = m_keys2[key];
			m_values2.remove(key2);
		
			m_keys1.remove(key2);
			m_keys2.remove(key);
		}
	}
	
	/**
	*	Removes a value from the collection.
	*	Params:
	*		key =	The key.
	*/
	void remove(TKey2 key) {
		if (!contains(key))
			throw new SelectorException(format("%s does not exist in the collection.", key));
		synchronized {	
			m_values2.remove(key);
			auto key1 = m_keys1[key];
			m_values1.remove(key1);
		
			m_keys2.remove(key1);
			m_keys1.remove(key);
		}
	}
	
	/**
	*	Checks whether a key exists within the collection.
	*	Returns: True if the collection contains the key.
	*	Params:
	*		key =	The key.
	*/
	bool contains(TKey1 key) {
		synchronized {
			return (m_values1.get(key, null) !is null);
		}
	}
	
	/**
	*	Checks whether a key exists within the collection.
	*	Returns: True if the collection contains the key.
	*	Params:
	*		key =	The key.
	*/
	bool contains(TKey2 key) {
		synchronized {
			return (m_values2.get(key, null) !is null);
		}
	}
	
	/**
	*	Gets a value from the collection.
	*	Params:
	*		key =	The key.
	*	Returns: The value.
	*/
	TValue get(TKey1 key) {
		if (!contains(key))
			throw new SelectorException(format("%s does not exist in the collection.", key));
		synchronized {
			return m_values1[key];
		}
	}
	
	/**
	*	Gets a value from the collection.
	*	Params:
	*		key =	The key.
	*	Returns: The value.
	*/
	TValue get(TKey2 key) {
		if (!contains(key))
			throw new SelectorException(format("%s does not exist in the collection.", key));
		synchronized {
			return m_values2[key];
		}
	}
	
	@property {
		/**
		*	Gets the values of the collection.
		*/
		TValue[] values() { return m_values1.values; }
		/**
		*	Gets the first key type of the collection.
		*/
		TKey1[] keys1() { return m_values1.keys; }
		/**
		*	Gets the second key type of the collection.
		*/
		TKey2[] keys2() { return m_values2.keys; }
	}
}