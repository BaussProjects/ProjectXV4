module data.item;

import entities.gameclient;
import packets.item;

class Item {
private:
	uint m_uid;
	uint m_id;
	string m_name;
	ubyte m_job;
	ubyte m_prof;
	ubyte m_level;
	ushort m_strength;
	ushort m_agility;
	ushort m_spirit;
	bool m_tradable;
	uint m_price;
	uint m_maxDamage;
	uint m_minDamage;
	uint m_defense;
	uint m_dexterity;
	uint m_dodge;
	ushort m_hp;
	ushort m_mp;
	uint m_magicAttack;
	uint m_magicDefense;
	int m_range;
	int m_frequency;
	uint m_cpsPrice;
	
	short m_amount;
	short m_maxAmount;
	ubyte m_plus;
	ubyte m_bless;
	ubyte m_enchant;
	ubyte m_gem1;
	ubyte m_gem2;
	short m_rbEffect;
public:
	this() {
		import core.uidgenerator;
		m_uid = getItemUID();
	}
	
	@property {
		/**
		*	Gets the uid.
		*/
		uint uid() { return m_uid; }

		/**
		*	Gets the id.
		*/
		uint id() { return m_id; }

		/**
		*	Sets the id.
		*/
		void id(uint value) {
			m_id = value;
		}


		/**
		*	Gets the name.
		*/
		string name() { return m_name; }

		/**
		*	Sets the name.
		*/
		void name(string value) {
			m_name = value;
		}


		/**
		*	Gets the job.
		*/
		ubyte job() { return m_job; }

		/**
		*	Sets the job.
		*/
		void job(ubyte value) {
			m_job = value;
		}


		/**
		*	Gets the prof.
		*/
		ubyte prof() { return m_prof; }

		/**
		*	Sets the prof.
		*/
		void prof(ubyte value) {
			m_prof = value;
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
		}


		/**
		*	Gets a boolean controlling whether its tradable.
		*/
		bool tradable() { return m_tradable; }

		/**
		*	Sets a boolean controlling whether its tradable.
		*/
		void tradable(bool value) {
			m_tradable = value;
		}


		/**
		*	Gets the price.
		*/
		uint price() { return m_price; }

		/**
		*	Sets the price.
		*/
		void price(uint value) {
			m_price = value;
		}


		/**
		*	Gets the max damage.
		*/
		uint maxDamage() { return m_maxDamage; }

		/**
		*	Sets the max damage.
		*/
		void maxDamage(uint value) {
			m_maxDamage = value;
		}


		/**
		*	Gets the min damage.
		*/
		uint minDamage() { return m_minDamage; }

		/**
		*	Sets the min damage.
		*/
		void minDamage(uint value) {
			m_minDamage = value;
		}


		/**
		*	Gets the defense.
		*/
		uint defense() { return m_defense; }

		/**
		*	Sets the defense.
		*/
		void defense(uint value) {
			m_defense = value;
		}


		/**
		*	Gets the dexterity.
		*/
		uint dexterity() { return m_dexterity; }

		/**
		*	Sets the dexterity.
		*/
		void dexterity(uint value) {
			m_dexterity = value;
		}


		/**
		*	Gets the dodge.
		*/
		uint dodge() { return m_dodge; }

		/**
		*	Sets the dodge.
		*/
		void dodge(uint value) {
			m_dodge = value;
		}


		/**
		*	Gets the hp.
		*/
		ushort hp() { return m_hp; }

		/**
		*	Sets the hp.
		*/
		void hp(ushort value) {
			m_hp = value;
		}


		/**
		*	Gets the mp.
		*/
		ushort mp() { return m_mp; }

		/**
		*	Sets the mp.
		*/
		void mp(ushort value) {
			m_mp = value;
		}


		/**
		*	Gets the dura.
		*/
		short dura() { return m_amount; }

		/**
		*	Sets the dura.
		*/
		void dura(short value) {
			m_amount = value;
		}


		/**
		*	Gets the max dura.
		*/
		short maxDura() { return m_maxAmount; }

		/**
		*	Sets the max dura.
		*/
		void maxDura(short value) {
			m_maxAmount = value;
		}


		/**
		*	Gets the magic attack.
		*/
		uint magicAttack() { return m_magicAttack; }

		/**
		*	Sets the magic attack.
		*/
		void magicAttack(uint value) {
			m_magicAttack = value;
		}


		/**
		*	Gets the magic defense.
		*/
		uint magicDefense() { return m_magicDefense; }

		/**
		*	Sets the magic defense.
		*/
		void magicDefense(uint value) {
			m_magicDefense = value;
		}


		/**
		*	Gets the range.
		*/
		int range() { return m_range; }

		/**
		*	Sets the range.
		*/
		void range(int value) {
			m_range = value;
		}


		/**
		*	Gets the frequency.
		*/
		int frequency() { return m_frequency; }

		/**
		*	Sets the frequency.
		*/
		void frequency(int value) {
			m_frequency = value;
		}


		/**
		*	Gets the cps price.
		*/
		uint cpsPrice() { return m_cpsPrice; }

		/**
		*	Sets the cps price.
		*/
		void cpsPrice(uint value) {
			m_cpsPrice = value;
		}
		
		/**
		*	Gets the amount.
		*/
		short amount() { return m_amount; }

		/**
		*	Sets the amount.
		*/
		void amount(short value) {
			m_amount = value;
		}


		/**
		*	Gets the max amount.
		*/
		short maxAmount() { return m_maxAmount; }

		/**
		*	Sets the max amount.
		*/
		void maxAmount(short value) {
			m_maxAmount = value;
		}


		/**
		*	Gets the plus.
		*/
		ubyte plus() { return m_plus; }

		/**
		*	Sets the plus.
		*/
		void plus(ubyte value) {
			m_plus = value;
		}


		/**
		*	Gets the bless.
		*/
		ubyte bless() { return m_bless; }

		/**
		*	Sets the bless.
		*/
		void bless(ubyte value) {
			m_bless = value;
		}


		/**
		*	Gets the enchant.
		*/
		ubyte enchant() { return m_enchant; }

		/**
		*	Sets the enchant.
		*/
		void enchant(ubyte value) {
			m_enchant = value;
		}


		/**
		*	Gets the gem1.
		*/
		ubyte gem1() { return m_gem1; }

		/**
		*	Sets the gem1.
		*/
		void gem1(ubyte value) {
			m_gem1 = value;
		}


		/**
		*	Gets the gem2.
		*/
		ubyte gem2() { return m_gem2; }

		/**
		*	Sets the gem2.
		*/
		void gem2(ubyte value) {
			m_gem2 = value;
		}


		/**
		*	Gets the rbEffect.
		*/
		short rbEffect() { return m_rbEffect; }

		/**
		*	Sets the rbEffect.
		*/
		void rbEffect(short value) {
			m_rbEffect = value;
		}
		
		// specials ...
		
		ushort baseId() { return cast(ushort)(id / 1000); }
	}

	bool isValidOffItem() {
		if (id >= 70019001 && id <= 70129001)
			return false;
		
		return tradable;
	}
	
	bool isShield() {
		return (id >= 900000 && id <= 900999);
	}
	
	bool isArmor() {
		return (id >= 130000 && id <= 136999);
	}
	
	bool isHeadGear() {
		return ((id >= 111000 && id <= 118999) || (id >= 123000 && id <= 123999) || (id >= 141999 && id <= 143999));
	}
	
	bool isOneHand() {
		return (id >= 410000 && id <= 499999 || id >= 601000 && id <= 601999 || id >= 610000 && id <= 610999);
	}
	
	bool isBacksword() {
		return (id >= 421000 && id <= 421999);
	}
	
	bool isSwordOrBlade() {
		return (id >= 410000 && id <= 421999);
	}
	
	bool isTwoHand() {
		return (id > 510000 && id < 599999);
	}
	
	bool isArrow() {
		return (id >= 1050000 && id <= 1051000);
	}
	
	bool isBow() {
		return (id >= 500000 && id < 510000);
	}
	
	bool isNecklace() {
		return (id >= 120000 && id <= 121999);
	}
	
	bool isRing() {
		return (id >= 150000 && id <= 159999);
	}
	
	bool isBoots() {
		return (id >= 160000 && id <= 160999);
	}
	
	bool isGarment() {
		if (id == 134155 || id == 131155 || id == 133155 || id == 130155)
			return true;
		return (id >= 181000 && id <= 194999);
	}
	
	bool isFan() {
		return (id >= 201000 && id <= 201999);
	}
	
	bool isTower() {
		return (id >= 202000 && id <= 202999);
	}
	
	bool isSteed() {
		return (id == 300000);
	}
	
	bool isBottle() {
		return (id >= 2100025 && id <= 2100095);
	}
	
	bool isMountArmor() {
		return (id >= 200000 && id <= 200420);
	}
	
	bool isMisc() {
		return (!isHeadGear() && !isArmor() &&
	        !isShield() && !isOneHand() &&
	        !isTwoHand() && !isNecklace() &&
	        !isRing() && !isArrow() &&
	        !isBow() && !isBoots() &&
	        !isGarment() && !isFan() &&
	        !isTower() && !isBottle() &&
	        !isSteed() && !isMountArmor());
	}	
		
	auto copy() {
		auto newItem = new Item();
		newItem.m_id = m_id;
		newItem.m_name = m_name;
		newItem.m_job = m_job;
		newItem.m_prof = m_prof;
		newItem.m_level = m_level;
		newItem.m_strength = m_strength;
		newItem.m_agility = m_agility;
		newItem.m_spirit = m_spirit;
		newItem.m_tradable = m_tradable;
		newItem.m_price = m_price;
		newItem.m_maxDamage = m_maxDamage;
		newItem.m_minDamage = m_minDamage;
		newItem.m_defense = m_defense;
		newItem.m_dexterity = m_dexterity;
		newItem.m_dodge = m_dodge;
		newItem.m_hp = m_hp;
		newItem.m_mp = m_mp;
		newItem.maxAmount = m_maxAmount;
		newItem.amount = m_amount;
		//newItem.m_dura = m_dura;
		//newItem.m_maxDura = m_maxDura;
		newItem.m_magicAttack = m_magicAttack;
		newItem.m_magicDefense = m_magicDefense;
		newItem.m_range = m_range;
		newItem.m_frequency = m_frequency;
		newItem.m_cpsPrice = m_cpsPrice;
		return newItem;
	}
	
	import packets.item;
	void send(GameClient client, ItemMode mode, ItemPosition pos) {
		client.send(new ItemPacket(
			m_uid, m_id, m_amount, m_maxAmount,
			mode, pos,
			m_plus, m_bless, m_enchant,
			m_gem1, m_gem2, m_rbEffect
		));
	}
	
	override string toString() {
		import std.conv : to;
		return to!string(m_id) ~ "-" ~
			to!string(m_tradable) ~ "-" ~
			to!string(m_amount) ~ "-" ~
			to!string(m_plus) ~ "-" ~
			to!string(m_bless) ~ "-" ~
			to!string(m_enchant) ~ "-" ~
			to!string(m_gem1) ~ "-" ~
			to!string(m_gem2) ~ "-" ~
			to!string(m_rbEffect);
	}
	
	static auto fromString(string itemString) {
		import std.array : split;
		import std.conv : to;
		import core.kernel;
		
		scope auto itemData = split(itemString, "-");
		
		uint id = to!uint(itemData[0]);	
		auto item = getKernelItem(id);
		
		item.m_tradable = to!bool(itemData[1]);
		item.m_amount = to!short(itemData[2]);
		item.m_plus = to!ubyte(itemData[3]);
		item.m_bless = to!ubyte(itemData[4]);
		item.m_enchant = to!ubyte(itemData[5]);
		item.m_gem1 = to!ubyte(itemData[6]);
		item.m_gem2 = to!ubyte(itemData[7]);
		item.m_rbEffect = to!ubyte(itemData[8]);
		return item;
	}
}