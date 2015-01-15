module crypto.gamecrypto;

import network.packet;

/**
*	The crypto data manager.
*/
private class CryptoData : DataPacket {
	this() {
		super();
	}
}


/**
*	The crypto counter.
*/
private class CryptoCounter {
	/**
	*	The current counter.
	*/
	ushort m_counter = 0;
	@property {
		/**
		*	Gets the first key.
		*/
		ubyte key1() {
			return cast(ubyte)(m_counter & 0xFF);
		}
		
		/**
		*	Gets the second key.
		*/
		ubyte key2() {
			return cast(ubyte)(m_counter >> 8);
		}
	}
	
	/**
	*	Increases the counter.
	*/
	void increment() {
		m_counter++;
	}
	
	/**
	*	Resets the counter.
	*/
	void reset() {
		m_counter = 0;
	}
}

/**
*	The game crypto.
*/
class GameCrypto {
private:
	/**
	*	The size of the key.
	*/
	enum keySize = 256;
	/**
	*	The crypto counters.
	*/
	CryptoCounter m_encryptCounter, m_decryptCounter;
	/**
	*	The crypto buffers.
	*/
    ubyte[] crypt1;
	ubyte[] crypt2;
	ubyte[] crypt3;
	ubyte[] crypt4;
	/**
	* Boolean determining whether it should use the alternative keys.
	*/
    bool m_alternate;
public:
	/**
	*	Creates a new instance of GameCrypto.
	*/
	this() {
		m_alternate = false;
		
		m_encryptCounter = new CryptoCounter;
        m_decryptCounter = new CryptoCounter;

		crypt1 = new ubyte[256];
        crypt2 = new ubyte[256];
        ubyte i_key1 = 157;
        ubyte i_key2 = 98;
        foreach (i; 0 .. 256)
        {
            crypt1[i] = i_key1;
            crypt2[i] = i_key2;
            i_key1 = cast(ubyte)((0xF + cast(ubyte)(i_key1 * 0xFA)) * i_key1 + 0x13);
            i_key2 = cast(ubyte)((0x79 - cast(ubyte)(i_key2 * 0x5C)) * i_key2 + 0x6D);
        }
	}
	
	/**
	*	Encrypts a buffer.
	*	Params:
	*		inBuffer =	The buffer to encrypt.
	*	Returns: The encrypted buffer.
	*/
	ubyte[] encrypt(ubyte[] inBuffer) {
		synchronized {
			ubyte[] buffer = inBuffer.dup;
			foreach (i; 0 .. buffer.length) {
				buffer[i] ^= 0xAB;
				buffer[i] = cast(ubyte)(buffer[i] >> 4 | buffer[i] << 4);
				buffer[i] ^= cast(ubyte)(crypt1[m_encryptCounter.key1] ^ crypt2[m_encryptCounter.key2]);
				m_encryptCounter.increment();
			}
			return buffer;
		}
	}
	
	/**
	*	Decrypts a buffer.
	*	Params:
	*		inBuffer =	The encrypted buffer to decrypt.
	*	Returns: The decrypted buffer.
	*/
	ubyte[] decrypt(ubyte[] inBuffer) {
		synchronized {
			ubyte[] buffer = inBuffer.dup;
			if (!m_alternate) {
				foreach (i; 0 .. buffer.length) {
					buffer[i] ^= 0xAB;
					buffer[i] = cast(ubyte)(buffer[i] >> 4 | buffer[i] << 4);
					buffer[i] ^= cast(ubyte)(crypt2[m_decryptCounter.key2] ^ crypt1[m_decryptCounter.key1]);
					m_decryptCounter.increment();
				}
			}
			else {
				foreach (i; 0 .. buffer.length) {
					buffer[i] ^= 0xAB;
					buffer[i] = cast(ubyte)(buffer[i] >> 4 | buffer[i] << 4);
					buffer[i] ^= cast(ubyte)(crypt4[m_decryptCounter.key2] ^ crypt3[m_decryptCounter.key1]);
					m_decryptCounter.increment();
				}
			}
			return buffer;
		}
	}
	
	/**
	*	Sets the keys of the crypto.
	*	Params:
	*		accountId =		The account id.
	*		token =			The login token.
	*/
	void setKeys(uint accountId, uint token)
    {
        synchronized {
			uint tmpkey1 = cast(uint)((((token) + accountId) ^ 0x4321) ^ (token));
			uint tmpkey2 = cast(uint)(tmpkey1 * tmpkey1);
			crypt3 = new ubyte[0x100];
			crypt4 = new ubyte[0x100];
		
			auto temp = new CryptoData;
			temp.write!uint(tmpkey1);
			ubyte[] tmp1 = temp.pBuffer;
		
			temp = new CryptoData;
			temp.write!uint(tmpkey2);
			ubyte[] tmp2 = temp.pBuffer;
		
			foreach (i; 0 .. 256)
			{
				crypt3[i] = cast(ubyte)(crypt1[i] ^ tmp1[i % 4]);
				crypt4[i] = cast(ubyte)(crypt2[i] ^ tmp2[i % 4]);
			}
			m_alternate = true;
		}
    }
}