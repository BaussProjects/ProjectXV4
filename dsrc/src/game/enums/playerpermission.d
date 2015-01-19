module enums.playerpermission;

/**
*	Enumeration for player permissions.
*/
enum PlayerPermission : ubyte {
	/**
	*	Full access to everything.
	*/
	owner = 0, // Displays [ADM]
	/**
	*	Full access to all player/server/develop management (Excluding database.)
	*/
	projectManager = 1, // Displays [PM]
	/**
	*	Full access to all player/develop management (Excluding database.)
	*/
	developer = 2, // Displays [D]
	/**
	*	Full access to all player management (Excluding database.)
	*/
	gameMaster = 3, // Displays [GM]
	/**
	*	Access to basic player management.
	*/
	gameModerator = 4, // Displays [M]
	/**
	*	Access to board settings only.
	*/
	forumModerator = 5, // Displays [F]
	/**
	*	Access to special features.
	*/
	premium = 6, // Displays [V]
	/**
	*	Regular player access only.
	*/
	player = 7 // Displays nothing
}