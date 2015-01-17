module threading.task;

import std.parallelism;

import threading.thread;

private class Task {
	void function() F;
	void delegate() D;
	int delayedTicks;
	int ticks;
	bool executed = false;
	uint taskId;
	this() {
		import core.uidgenerator;
		taskId = getTaskUID();
	}
	
	bool exec() {
		ticks++;
		if (ticks >= delayedTicks) {
			if (!executed) {
				executed = true;
				if (F) F();
				else if (D) D();
			}
			
			return true;
		}
		return false;
	}
}

private shared Task[uint] _tasks;
import core.thread : Thread;
private shared Thread taskThread;

private void handle() {
	while (true) {
		foreach(i, ref task; taskPool.parallel(_tasks.values)) {
			if ((cast(Task)task).exec()) {
				synchronized {
					_tasks.remove(cast(shared(uint))task.taskId);
				}
			}
		}
		sleep(100);
	}
}

void addTask(void function() F, int delayedTicks = 1) {
	synchronized {
		if (taskThread is null) {
			import threading.thread;
			auto t = createThread(&handle);
			t.start();
			taskThread = cast(shared(Thread))t;
		}
		
		auto task = new Task;
		task.F = F;
		task.delayedTicks = delayedTicks;
		
		auto tasks = cast(Task[uint])_tasks;
		tasks[task.taskId] = task;
		_tasks = cast(shared(Task[uint]))tasks;
	}
}

void addTask(void delegate() D, int delayedTicks = 1) {
	synchronized {
		if (taskThread is null) {
			import threading.thread;
			auto t = createThread(&handle);
			t.start();
			taskThread = cast(shared(Thread))t;
		}
		
		auto task = new Task;
		task.D = D;
		task.delayedTicks = delayedTicks;
		
		auto tasks = cast(Task[uint])_tasks;
		tasks[task.taskId] = task;
		_tasks = cast(shared(Task[uint]))tasks;
	}
}