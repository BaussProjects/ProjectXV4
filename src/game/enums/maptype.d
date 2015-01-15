module enums.maptype;

/**
*	Enumerator of map types.
*/
enum MapType : ubyte {
	/**
	*	PKing is disallowed.
	*/
	safe = 0,
	/**
	*	PKing is disallowed for anyone below level 25.
	*/
	SsafeNoob = 1,
	/**
	*	PKing is allowed with consequences.
	*/
	pk = 2,
	/**
	*	PKing is allowed without death.
	*/
	noDie = 3,
	/**
	*	PKing is allowed without consequences.
	*/
	duel = 4
}