/// @desc scrEnumerator

function scrEnumerator() {
	
	// DEBUG
	enum DEBUGPAD {
		
		PAD,
		AXISR,
		AXISU,
		AXISL,
		AXISD,
		DPADR,
		DPADU,
		DPADL,
		DPADD,
		SELECT,
		START,
		BUTTONX,
		BUTTONA,
		BUTTONY,
		BUTTONB
		
	}
	
	enum PAD {
		
		ID,
		GUID,
		HATS,
		BUTTONS,
		DESC,
		CONFIG,
		length
		
	}
	
	enum CONFIG {
		
		R,
		U,
		L,
		D,
		B1,
		B2,
		SELECT,
		START,
		length
		
	}
	
	enum PALSRC {
		
		SPRITE,
		SURFACE
		
	}
	
	enum PAL {
		
		SHADER,
		TEXTURE,
		TEXTUVS,
		TEXSIZE,
		INDEX,
		length
		
	}
	
	enum DIST {
		
		ONE,
		TWO,
		THREE,
		FOUR,
		length
		
	}
	
	enum PHASE {
		
		ONE,
		TWO,
		THREE,
		FOUR,
		FIVE,
		length
		
	}
	
	// LIBRARY CATEGORIES
	enum CAT {
		
		FRAGMENTS,
		FRAGIMAGES,
		FRAGSIZES,
		FRAGSETS,
		DUNGEONS,
		length
		
	}
	
	// CATEGORY FRAGMENTS
	enum FRAGCAT {
		
		WALK,
		BEYE,
		TURN,
		ROOM,
		ANIM,
		length
		
	}
	
	enum WALKFRAG {
		
		CF,
		CORR,
		CORRTAIL,
		SKELETON,
		STATIC,
		WALL,
		length
		
	}
	
	enum BEYEFRAG {
		
		CHEST,
		EXITDR,
		EXITDRLD,
		EXITDRMC,
		EXITDRMCON,
		EXITDRON,
		EXITGE,
		EXITGEON,
		EXITSTAD,
		EXITSTAU,
		INFINITY,
		ODIN,
		SKELETON,
		WALL,
		WALLLR,
		length
		
	}
	
	enum TURNFRAG {
		
		TCC2C,
		TCC2W,
		TCW2C,
		TCW2W,
		TWC2C,
		TWC2W,
		TWW2C,
		TWW2W,
		length
		
	}
	
	enum ROOMFRAG {
		
		WALL,
		FLOOR,
		length
		
	}
	
	enum ANIMFRAG {
		
		DOOR,
		DOORMC,
		GATE,
		length
		
	}
	
	enum FRAGIMAGES {
		
		WALK,
		TURN,
		length
		
	}
	
	enum FRAGSIZE {
		
		INFINITY,
		DIST4LR,
		DIST4TD,
		DIST4BE,
		DIST3LR,
		DIST3TD,
		DIST3BE,
		DIST2LR,
		DIST2TD,
		DIST2BE,
		DIST1LR,
		DIST1TD,
		DIST1BE,
		STATIC,
		TURN,
		length
		
	}
	
	enum FRAGSET {
		
		ONE,
		TWO
		
	}
	
	// CATEGORY DUNGEONS
	enum DUNGEON {
		
		// PALMA
		LALACAVE,
		MEDUSACAVE,
		MEDUSATOWER,
		
		// MOTAVIA
		NAHARUCAVE,
		
		// DEZORIS
		length
		
	}
	
	enum DUNGPAL {
		
		WALL,
		CORR,
		IMGIND,
		INDEX,
		length
		
	}
	
	enum DUNGCOLOUR {
		
		DEFAULT,
		GREEN,
		RED,
		ORANGE,
		DESERT,
		YELLOW,
		BLUEDARK,
		BLUEGRAY,
		BLUELIGHT,
		BLUEICE,
		BLUEBLACK,
		BLACK,
		length
		
	}
	
	enum DUNGLVL {
		
		LVL7,
		LVL6,
		LVL5,
		LVL4,
		LVL3,
		LVL2,
		LVL1,
		SUB1,
		SUB2,
		SUB3,
		length
		
	}
	
	enum CONTSLOT {
		
		BASESTRUCT,
		PASSAGE,
		OBJECT,
		DECOR,
		length
		
	}
	
	enum SLOT {
		
		CHEST,
		CORRIDOR,
		CORRIDORTRAP,
		DOOR,
		DOORLOCKED,
		DOORMAGIC,
		DOOROPEN,
		DOORLOCKEDOPEN,
		DOORMAGICOPEN,
		GATE,
		GATEOPEN,
		ODIN,
		SKELETON,
		STAIRSDOWN,
		STAIRSUP,
		WALL,
		WALLFAKE,
		length
		
	}
	
	// STATES
	enum STATE {
		
		EAST,
		NORTH,
		WEST,
		SOUTH,
		ACTION,
		ROOM,
		EXIT,
		INIT,
		length
		
	}
	
	enum ACTION {
		
		CHEST,
		DOOR,
		FLOORTRAP,
		INVENTORY,
		ODIN,
		WAIT,
		length
		
	}
	
	enum ENCOUNTER {
		
		length
		
	}
	
}