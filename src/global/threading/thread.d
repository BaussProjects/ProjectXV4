/*
	threading.thread provides a module handling simple thread management.
*/
module threading.thread;

// version = THREAD_TEST;

import core.thread;
version (THREAD_TEST) {
	import std.stdio : writeln, writefln;
}

/**
*	The event handler used for thread start events.
*	Thread start events are fired whenever a thread is created and started using the createThread() function.
*/
class ThreadStartEvent {
private:
	/**
	*	The function pointer.
	*/
	void function() F;
	/**
	*	The delegate pointer.
	*/
	void delegate() D;
public:
	/**
	*	Creates a new instance of ThreadStartEvent.
	*/
	this(void function() F) {
		this.F = F;
	}
	/**
	*	Creates a new instance of ThreadStartEvent.
	*/
	this(void delegate() D) {
		this.D = D;
	}
	
	/**
	*	Executes the event.
	*/
	void exec() {
		if (F) F();
		else if (D) D();
	}
}

/**
*	The thread start events.
*/
private shared ThreadStartEvent[] threadStartEvents;

/**
*	Adds an event to the thread start events.
*/
void addEvent(ThreadStartEvent event) {
	synchronized {
		auto tse = cast(ThreadStartEvent[])threadStartEvents;
		tse ~= event;
		threadStartEvents = cast(shared(ThreadStartEvent[]))tse;
	}
}

/**
*	Creates a new thread using a function pointer.
*/
Thread createThread(void function() F) {
	auto t = new Thread({
		if (threadStartEvents) {
			auto tse = cast(ThreadStartEvent[])threadStartEvents;
			foreach (event; tse)
				event.exec();
		}
		
		F();
	});
	return t;
}

/**
*	Creates a new thread using a delegate pointer.
*/
Thread createThread(void delegate() D) {
	auto t = new Thread({
		if (threadStartEvents) {
			auto tse = cast(ThreadStartEvent[])threadStartEvents;
			foreach (event; tse)
				event.exec();
		}
		
		D();
	});
	return t;
}

/**
*	Sleeps the current thread for a specific amount of milliseconds.
*/
void sleep(size_t milliseconds) {
	Thread.sleep(dur!("msecs")(milliseconds));
}

version (THREAD_TEST) {
	unittest {
		writeln("BEGIN THREAD_TEST...");
		
		addEvent(new ThreadStartEvent({ writeln("Started a thread..."); }));
		foreach (i; 0 .. 5) {
			createThread({ writeln("Thread: ", i); }).start();
			sleep(2000);
		}
		
		writeln("ENDED THREAD_TEST...");
	}
}