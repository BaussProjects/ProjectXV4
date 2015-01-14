module core.uidgenerator;

/**
*	The next item uid.
*/
private shared uint nextItemUID = 0;

/**
*	Gets a unique id for an item.
*/
uint getItemUID() {
	synchronized {
		uint uid = cast(uint)nextItemUID;
		nextItemUID = cast(shared(uint))(uid + 1);
		return uid;
	}
}