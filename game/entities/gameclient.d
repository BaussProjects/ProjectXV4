module entities.gameclient;

import std.socket;

import network.handlers;
import network.packet : DataPacket;
import crypto.gamecrypto;

import packets.update;
import database.playerdatabase;

import enums.job;
import enums.entitytype;
import enums.action;
import enums.pkmode;
import maps.mapobject;
import maps.map;

import data.inventory;
import io.inifile;

/**
*	The game client.
*/
class GameClient : MapObject {
private:
	/**
	*	The socket associated with the game client.
	*/
	Socket m_socket;
	
	// Receive ...
	/**
	*	The expected receive size.
	*/
	int m_expectedSize;
	/**
	*	The return size.
	*/
	int m_returnSize;
	/**
	*	The receive buffer.
	*/
	ubyte[] m_receiveBuffer;
	/**
	*	The final buffer.
	*/
	ubyte[] m_finalBuffer;
	/**
	*	A boolean controlling whether the socket is receiving the packet head or not.
	*/
	bool m_isHead;
	
	// Disconnect ...
	/**
	*	A boolean controlling whether the client has been disconnected.
	*/
	bool m_disconnected;
	
	// Socket ...
	/**
	*	The address of the socket.
	*/
	string m_address;
	/**
	*	The id of the socket.
	*/
	size_t m_sid;
	// Client ...
	/**
	*	The cryptography of the client.
	*/
	GameCrypto m_crypto;
	// Player ...
	/**
	* Boolean determining whether the client has loaded yet.
	*/
	bool m_loaded = false;
	
	/**
	*	The account.
	*/
	string m_account;
	/**
	*	The character name.
	*/
	string m_name;
	/**
	*	The spouse.
	*/
	string m_spouse;
	
	/**
	*	The money.
	*/
	uint m_money;
	/**
	*	The cps.
	*/
	uint m_cps;
	/**
	*	The warehouse money.
	*/
	uint m_whMoney;
	
	/**
	*	The level.
	*/
	ubyte m_level;
	
	/**
	*	The experience.
	*/
	ulong m_experience;
	
	/**
	*	The job.
	*/
	Job m_job;
	
	/**
	*	The pk points.
	*/
	short m_pkPoints;
	
	/**
	*	The max hp.
	*/
	int m_maxHp;
	
	/**
	*	The hp.
	*/
	int m_hp;
	
	/**
	*	The max mp.
	*/
	int m_maxMp;
	
	/**
	*	The mp.
	*/
	int m_mp;
	
	/**
	*	The stamina.
	*/
	ubyte m_stamina;
	
	/**
	*	The stat points.
	*/
	ushort m_statPoints;
	
	/**
	*	The strength.
	*/
	ushort m_strength;
	
	/**
	*	The agility.
	*/
	ushort m_agility;
	
	/**
	*	The vitality.
	*/
	ushort m_vitality;
	
	/**
	*	The spirit.
	*/
	ushort m_spirit;
	
	/**
	*	The reborn count.
	*/
	ubyte m_reborns;
	
	/**
	* The hair style.
	*/
	ushort m_hairStyle;
	
	/**
	*	The mesh.
	*/
	uint m_mesh;
	
	/**
	*	The transformation model.
	*/
	ushort m_transform;
	
	/**
	*	The model.
	*/
	ushort m_model;
	
	/**
	*	The avatar.
	*/
	ushort m_avatar;
	
	/**
	*	The current action.
	*/
	Action m_action;
	
	/**
	*	The pk mode.
	*/
	PKMode m_pkMode;
	
	/**
	*	The inventory.
	*/
	Inventory m_inventory;
	
	IniFile!(true) m_playerDbFile;
	IniFile!(true) m_inventoryDbFile;
	
	/**
	*	Calculates the mesh.
	*/
	void calculateMesh() {
		m_mesh = cast(uint)((m_transform * 10000000) + (m_avatar * 10000) + m_model);
	}
public:
	/**
	*	Creates a new instance of GameClient.
	*	Params:
	*		socket =	The socket of the game client.
	*		sid =		The id of the socket.
	*/
	this(Socket socket, size_t sid) {
		assert(socket.isAlive);
		super(EntityType.player);
		
		m_socket = socket;
		m_socket.blocking = false;
		m_expectedSize = 8;
		m_returnSize = 8;
		m_isHead = true;
		m_disconnected = false;
		m_address = m_socket.remoteAddress().toString();
		
		m_crypto = new GameCrypto;
		m_sid = sid;
		
		m_inventory = new Inventory(this);
	}
	
	void setDb() {
		m_inventoryDbFile = new IniFile!(true)("database\\game\\player_inventories\\" ~ account ~ ".ini");
		m_playerDbFile = new IniFile!(true)("database\\game\\players\\" ~ account ~ ".ini");
	}
	
	@property {
		IniFile!(true) playerDbFile() { return m_playerDbFile; }
		
		IniFile!(true) inventoryDbFile() { return m_inventoryDbFile; }
		/**
		*	Gets the inventory.
		*/
		Inventory inventory() { return m_inventory; }
	
		/**
		*	Gets the underlying socket.
		*/
		Socket socket() { return m_socket; }
		
		/**
		*	Gets the address of the socket.
		*/
		string address() { return m_address; }
		
		/**
		*	Gets a boolean determining whether the socket is alive or not.
		*/
		bool alive() { return m_socket.isAlive; }
		
		/**
		*	Gets the id of the socket.
		*/
		int sid() { return m_sid; }
		/**
		*	Gets the crypto of the client.
		*/
		GameCrypto crypto() { return m_crypto; }
		
		// Player properties ...
		/**
		*	Gets the loading state.
		*/
		bool loaded() { return m_loaded; }
		/**
		*	Sets the loading state.
		*/
		void loaded(bool value) {
			m_loaded = value;
		}
		
		/**
		*	Gets the entity UID.
		*/
		uint entityUID() { return uid; }
		/**
		*	Sets the entityUID.
		*/
		void entityUID(uint value) {
			if (uid > 0)
				return;
			uid = value;
		}
		
		/**
		*	Gets the account.
		*/
		string account() { return m_account; }
		/**
		*	Sets the account.
		*/
		void account(string value) {
			m_account = value;
		}
		
		/**
		*	Gets the spouse.
		*/
		string spouse() { return m_spouse; }
		
		/**
		*	Sets the spouse.
		*/
		void spouse(string value) {
			if (!value || value.length < 4)
				value = "None";
			m_spouse = value;
		}
		
		/**
		*	Gets the money.
		*/
		uint money() { return m_money; }
		
		/**
		* Sets the money.
		*/
		void money(uint value) {
			m_money = value;
			if (m_loaded) {
				updateCharacter!uint(this, "Money", m_money);
				send(new UpdatePacket(entityUID, UpdateType.money, m_money));
			}
		}
		
		/**
		*	Gets the cps.
		*/
		uint cps() { return m_cps; }
		
		/**
		*	Sets the cps.
		*/
		void cps(uint value) {
			m_cps = value;
			if (m_loaded) {
				updateCharacter!uint(this, "CPs", m_cps);
				send(new UpdatePacket(entityUID, UpdateType.cps, m_cps));
			}
		}
		
		/**
		*	Gets the warehouse money.
		*/
		uint whMoney() { return m_whMoney; }
		/**
		*	Sets the warehouse money.
		*/
		void whMoney(uint value) {
			m_whMoney = value;
			if (m_loaded) {
				updateCharacter!uint(this, "WHMoney", m_money);
				//send(new UpdatePacket(entityUID, UpdateType.money, m_money));
			}
		}
		
		/**
		*	Gets the level.
		*/
		ubyte level() { return m_level; }
		
		/**
		*	Sets the level.
		*/
		void level(ubyte value) {
			m_level = value;
			if (m_loaded) {
				experience = 0;
				updateBaseStats();
				updateCharacter!ubyte(this, "Level", m_level);
				send(new UpdatePacket(entityUID, UpdateType.level, cast(ushort)m_level));
				updateSpawn();
			}
		}
		
		/**
		*	Gets the experience.
		*/
		ulong experience() { return m_experience; }
		
		/**
		*	Sets the experience.
		*/
		void experience(ulong value) {
			m_experience = value;
			if (m_loaded) {
				updateCharacter!ulong(this, "Experience", m_experience);
				send(new UpdatePacket(entityUID, UpdateType.experience, m_experience));
			}
		}
		
		/**
		*	Gets the job.
		*/
		Job job() { return m_job; }
		
		/**
		*	Sets the job.
		*/
		void job(Job value) {
			m_job = value;
			if (m_loaded) {
				updateCharacter!ubyte(this, "Job", cast(ubyte)m_job);
				send(new UpdatePacket(entityUID, UpdateType.job, cast(ushort)m_job));
			}
		}
		
		/**
		*	Gets the pk points.
		*/
		short pkPoints() { return m_pkPoints; }
		
		/**
		*	Sets the pk points.
		*/
		void pkPoints(short value) {
			m_pkPoints = value;
			if (m_loaded) {
				updateCharacter!short(this, "PKPoints", m_pkPoints);
				send(new UpdatePacket(entityUID, UpdateType.pkPoints, m_pkPoints));
				// set pk flags ...	
				updateSpawn();
			}
		}
		
		/**
		*	Gets the max hp.
		*/
		int maxHp() { return m_maxHp; }
		
		/**
		*	Sets the max hp.
		*/
		void maxHp(int value) {
			if (value <= 0)
				value = 1;
			m_maxHp = value;
			updateBaseStats();
			if (m_loaded) {
				updateCharacter!int(this, "MaxHP", m_maxHp);
				send(new UpdatePacket(entityUID, UpdateType.maxHp, m_maxHp));
			}
		}
		
		/**
		*	Gets the hp.
		*/
		int hp() { return m_hp; }
		
		/**
		*	Sets the hp.
		*/
		void hp(int value) {
			if (value > maxHp)
				value = maxHp;
			if (value <= 0)
				value = 0;
			m_hp = value;
			if (m_loaded) {
				updateCharacter!int(this, "HP", m_hp);
				send(new UpdatePacket(entityUID, UpdateType.hp, value));
			}
		}
		
		/**
		*	Gets the max mp.
		*/
		int maxMp() { return m_maxMp; }
		
		/**
		*	Sets the mp.
		*/
		void maxMp(int value) {
			if (value <= 0)
				value = 1;
			m_maxMp = value;
			updateBaseStats();
			if (m_loaded) {
				updateCharacter!int(this, "MaxMP", m_maxMp);
				send(new UpdatePacket(entityUID, UpdateType.maxMp, m_maxMp));
			}
		}
		
		/**
		*	Gets the mp.
		*/
		int mp() { return m_mp; }
		/**
		*	Sets the map.
		*/
		void mp(int value) {
			if (value > maxHp)
				value = maxHp;
			if (value <= 0)
				value = 0;
			m_mp = value;
			if (m_loaded) {
				updateCharacter!int(this, "MP", m_mp);
				send(new UpdatePacket(entityUID, UpdateType.mp, value));
			}
		}
		
		/**
		*	Gets the stamina.
		*/
		ubyte stamina() { return m_stamina; }
		/**
		*	Sets the stamina.
		*/
		void stamina(ubyte value) {
			m_stamina = value;
			if (m_loaded) {
				send(new UpdatePacket(entityUID, UpdateType.stamina, cast(ushort)m_stamina));
			}
		}
		
		/**
		*	Gets the stat points.
		*/
		ushort statPoints() { return m_statPoints; }
		
		/**
		*	Sets the stat points.
		*/
		void statPoints(ushort value) {
			m_statPoints = value;
			if (m_loaded) {
				updateCharacter!ushort(this, "StatPoints", m_statPoints);
				send(new UpdatePacket(entityUID, UpdateType.statPoints, m_statPoints));
			}
		}
		
		/**
		*	Gets the strength.
		*/
		ushort strength() { return m_strength; }
		/**
		*	Sets the strength.
		*/
		void strength(ushort value) {
			m_strength = value;
			if (m_loaded) {
				updateBaseStats();
				updateCharacter!ushort(this, "Stamina", m_strength);
				send(new UpdatePacket(entityUID, UpdateType.strength, m_strength));
			}
		}
		
		/**
		*	Gets the agility.
		*/
		ushort agility() { return m_agility; }
		
		/**
		*	Sets the agility.
		*/
		void agility(ushort value) {
			m_agility = value;
			if (m_loaded) {
				updateBaseStats();
				updateCharacter!ushort(this, "Agility", m_agility);
				send(new UpdatePacket(entityUID, UpdateType.agility, m_agility));
			}
		}
		
		/**
		*	Gets the vitality.
		*/
		ushort vitality() { return m_vitality; }
		
		/**
		*	Sets the vitality.
		*/
		void vitality(ushort value) {
			m_vitality = value;
			if (m_loaded) {
				updateBaseStats();
				updateCharacter!ushort(this, "Vitality", m_vitality);
				send(new UpdatePacket(entityUID, UpdateType.vitality, m_vitality));
			}
		}
		
		/**
		*	Gets the spirit.
		*/
		ushort spirit() { return m_spirit; }
		
		/**
		*	Sets the spirit.
		*/
		void spirit(ushort value) {
			m_spirit = value;
			if (m_loaded) {
				updateBaseStats();
				updateCharacter!ushort(this, "Spirit", m_spirit);
				send(new UpdatePacket(entityUID, UpdateType.spirit, m_spirit));
			}
		}
		
		/**
		*	Gets the reborns.
		*/
		ubyte reborns() { return m_reborns; }
		
		/**
		*	Sets the reborns.
		*/
		void reborns(ubyte value) {
			m_reborns = value;
			if (m_loaded) {
				updateBaseStats();
				updateCharacter!ubyte(this, "Reborns", m_reborns);
				send(new UpdatePacket(entityUID, UpdateType.reborns, cast(ushort)m_reborns));
				updateSpawn();
			}
		}
		
		/**
		*	Gets the hair style.
		*/
		ushort hairStyle() { return m_hairStyle; }
		
		/**
		*	Sets the hair style.
		*/
		void hairStyle(ushort value) {
			m_hairStyle = value;
			if (m_loaded) {
				updateCharacter!ushort(this, "HairStyle", m_hairStyle);
				send(new UpdatePacket(entityUID, UpdateType.hairStyle, m_hairStyle));
				updateSpawn();
			}
		}
		
		/**
		*	Gets the mesh.
		*/
		uint mesh() { return m_mesh; }
		
		/**
		*	Gets the transformation model.
		*/
		ushort transform() { return m_transform; }
		
		/**
		*	Sets the transformation model.
		*/
		void transform(ushort value) {
			m_transform = value;
			calculateMesh();
			if (m_loaded) {
				send(new UpdatePacket(entityUID, UpdateType.model, m_mesh));
				updateSpawn();
			}
		}
		
		/**
		*	Gets the model.
		*/
		ushort model() { return m_model; }
		
		/**
		*	Sets the model.
		*/
		void model(ushort value) {
			m_model = value;
			calculateMesh();
			if (m_loaded) {
				updateCharacter!ushort(this, "Model", m_hairStyle);
				send(new UpdatePacket(entityUID, UpdateType.model, m_mesh));
				updateSpawn();
			}
		}
		
		/**
		*	Gets the avatar.
		*/
		ushort avatar() { return m_avatar; }
		
		/**
		*	Sets the avatar.
		*/
		void avatar(ushort value) {
			m_avatar = value;
			calculateMesh();
			if (m_loaded) {
				updateCharacter!ushort(this, "Avatar", m_hairStyle);
				send(new UpdatePacket(entityUID, UpdateType.model, m_mesh));
				updateSpawn();
			}
		}
		
		/**
		*	Gets the action.
		*/
		Action action() { return m_action; }
		
		/**
		*	Sets the action.
		*/
		void action(Action value) {
			m_action = value;
			if (m_loaded) {
				updateSpawn();
			}
		}
		
		/**
		*	Gets the pk mode.
		*/
		PKMode pkMode() { return m_pkMode; }
		
		/**
		*	Sets the pk mode.
		*/
		void pkMode(PKMode value) {
			m_pkMode = value;
		}
	}
	
	/**
	*	Updates the base stats.
	*/
	void updateBaseStats() {
		// TODO: Implement calculations ...
	}
	
	/**
	*	Handles the asynchronous socket receive.
	*/
	void handleAsyncReceive() {
		import std.stdio : writeln;
		if (m_disconnected)
			return;
		if (!m_socket.isAlive) {
			disconnect("Dead socket...");
			return;
		}
		
		ubyte[] recvBuf = new ubyte[m_returnSize];
		auto recv = m_socket.receive(recvBuf);
		if (recv == 0 || recv == Socket.ERROR) {
			disconnect("Terminated socket...");
			return;
		}		
		m_receiveBuffer ~= recvBuf;
		
		synchronized {
			m_receiveBuffer = m_crypto.decrypt(m_receiveBuffer);
		}
		
		if (m_isHead) {
			scope auto head = new DataPacket(m_receiveBuffer);
			ushort expectedSize = head.read!ushort;
			if (expectedSize > 1024) {
				disconnect("Packet too big!");
				return;
			}
			
			expectedSize -= 8;
			
			if (expectedSize > 0) {
				m_expectedSize = expectedSize;
				m_returnSize = expectedSize;
				m_finalBuffer ~= m_receiveBuffer;
				m_receiveBuffer = null;
				m_isHead = false;
			}
			else {
				handleReceive(this, head);
				
				m_expectedSize = 8;
				m_returnSize = 8;
				m_finalBuffer = null;
				m_receiveBuffer = null;
				m_isHead = true;
			}
		}
		else {
			m_returnSize -= recv;
			m_finalBuffer ~= m_receiveBuffer;
			if (m_returnSize <= 0) {
				scope auto packet = new DataPacket(m_finalBuffer);
				handleReceive(this, packet);
				m_expectedSize = 8;
				m_returnSize = 8;
				m_finalBuffer = null;
				m_receiveBuffer = null;
				m_isHead = true;
			}
		}
		
	}
	
	/**
	*	Sends a packet to the client.
	*	Params:
	*		packet =	The packet to send.
	*/
	void send(DataPacket packet) {
		try {
			ubyte[] buffer = packet.buffer;
			synchronized {
				//buffer ~= cast(ubyte[])"TQServer";
				buffer = m_crypto.encrypt(buffer);
				m_socket.send(buffer);
			}
		}
		catch {
			disconnect("Failed to send...");
		}
	}
	
	/**
	*	Sends a packet to all clients within the screen.
	*	Params:
	*		packet = The packet to send.
	*/
	void sendToScreen(DataPacket packet) {
		try {
			auto locals = map.findLocalEntities(super.x, super.y);
			if (!locals || locals.length == 0)
				return;
				
			synchronized {
				foreach (local; locals) {
					if (local.uid == uid)
						continue;
					if (local.etype == EntityType.player) {
						auto player = cast(GameClient)local;
						player.send(packet);
					}
				}
			}
		}
		catch {
			disconnect("Failed to send...");
		}
	}
	
	/**
	*	Disconnects the client.
	*	Params:
	*		reason =	The reason for the disconnect.
	*/
	void disconnect(string reason = "Unknown") {
		if (m_disconnected)
			return;
		m_disconnected = true;
		
		try {
			m_socket.shutdown(SocketShutdown.BOTH);
			m_socket.close();
		}
		catch { }
		
		handleDisconnect(this, reason);
	}

	import packets.spawnpacket;
	/**
	*	Creates the spawn packet for the client.
	*	Returns: The spawn packet.
	*/
	override SpawnPacket createSpawn() {
		auto spawn = new EntitySpawnPacket(cast(ushort)(85 + name.length));
		spawn.write!uint(uid); // 4
		spawn.write!uint(mesh); // 8
		spawn.write!ulong(0); // 12 statusFlag
		spawn.write!ushort(0); // 20 guildId
		spawn.writeEmpty(23);
		spawn.write!ubyte(0); // 23 guildRank
		
		spawn.write!uint(0); // 24 garment
		spawn.write!uint(0); // 28 helmet
		spawn.write!uint(0); // 32 armor
		spawn.write!uint(0); // 36 right hand
		spawn.write!uint(0); // 40 left hand
		
		spawn.writeEmpty(48);
		spawn.write!ushort(cast(ushort)maxHp); // 48
		spawn.write!ushort(level); // 50
		spawn.write!ushort(super.x); // 52
		spawn.write!ushort(super.y); // 54
		spawn.write!ushort(hairStyle); // 56
		spawn.write!ubyte(cast(ubyte)super.direction); // 58
		spawn.write!ubyte(cast(ubyte)action); // 59
		spawn.write!ubyte(reborns); // 60
		
		spawn.write!ushort(level); // levelPotency 62
		spawn.write!int(0); // otherPotency 64
		spawn.write!uint(0); // nobilityRank 68
		
		spawn.writeEmpty(80);
		import network.packet;
		StringPacker.pack(spawn, [name]); // 80
		return spawn;
	}
}