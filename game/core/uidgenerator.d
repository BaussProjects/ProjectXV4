module core.uidgenerator;

private shared uint nextItemUID = 0;
uint getItemUID() {
	synchronized {
		uint uid = cast(uint)nextItemUID;
		nextItemUID = cast(shared(uint))(uid + 1);
		return uid;
	}
}