module threading.task;

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

private shared Task[int] _tasks;
import core.thread : Thread;
private Thread taskThread;
private void handle() {
	while (true) {
		import threading.thread;
		synchronized {
			auto tasks = cast(Task[int])_tasks;
			foreach (task; tasks) {
				if (task.exec()) {
					tasks.remove(task.taskId);
					_tasks = cast(shared(Task[int]))tasks;
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
			taskThread = createThread(&handle);
			taskThread.start();
		}
		
		auto task = new Task;
		task.F = F;
		task.delayedTicks = delayedTicks;
		
		auto tasks = cast(Task[int])_tasks;
		tasks[task.taskId] = task;
		_tasks = cast(shared(Task[int]))tasks;
	}
}

void addTask(void delegate() D, int delayedTicks = 1) {
	synchronized {
		if (taskThread is null) {
			import threading.thread;
			taskThread = createThread(&handle);
			taskThread.start();
		}
		
		auto task = new Task;
		task.D = D;
		task.delayedTicks = delayedTicks;
		
		auto tasks = cast(Task[int])_tasks;
		tasks[task.taskId] = task;
		_tasks = cast(shared(Task[int]))tasks;
	}
}