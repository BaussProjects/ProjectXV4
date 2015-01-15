module threading.queue;

import std.string : format;

/**
*	Exception type made for map handlers.
*/
class QueueException : Throwable {
public:
	/**
	*	Creates a new instance of QueueException.
	*	Params:
	*		msg =	The message of the exception.
	*/
	this(string msg) {
		super(msg);
	}
}

/**
*	A key value based map collection.
*/
class Queue(T) {
private:
	/**
	*	The values.
	*/
	T[] m_queue;
public:
	/**
	*	Creates a new instance of Map.
	*/
	this() { }
	
	/**
	*	Adds a value to the collection.
	*	Params:
	*		value =	The value to enqueue.
	*/
	void enqueue(T value) {
		synchronized {
			m_queue ~= value;
		}
	}
	
	/**
	*	Removes a value from the collection.
	*	Returns: The value dequeued.
	*/
	auto dequeue() {
		if (!contains(key))
			throw new QueueException(format("%s does not exist in the collection.", key));
		synchronized {	
			auto v = m_queue[0];
			m_queue = m_queue[1 .. $];
			return v;
		}
	}
	
	/**
	*	Checks whether the queue has any elements.
	*	Returns: True if the collection contains the key.
	*/
	bool has() {
		synchronized {
			return m_queue && m_queue.length > 0;
		}
	}
	
	@property {
		/**
		*	Gets the length of the queue.
		*/
		size_t length() { return m_queue.length; }
	}
}