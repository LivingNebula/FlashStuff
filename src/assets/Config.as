package assets
{
	public class Config
	{
		// Compiler Arguments
		private static const COMPILER_DEBUG:Boolean = CONFIG::debug;					// Flag for Release/Debug mode - (False: Release | True: Debug)
		private static const COMPILER_DEBUG_W_API:Boolean = CONFIG::debug_w_api;		// Flag to enable API calls in Debug mode
		private static const COMPILER_RELEASE_VERSION:String = CONFIG::version; 		// Release version indicator
		private static const COMPILER_BUILD_W_SCRIPT:Boolean = CONFIG::build_w_script; 	// Flag for build type (False: Script | True: Local)

		// Local config settings
		private static const LOCAL_DEBUG:Boolean = false; 					// Flag for Release/Debug mode - (False: Release | True: Debug)
		private static const LOCAL_DEBUG_W_API:Boolean = false;			 	// Flag to enable API calls in Debug mode
		private static const LOCAL_RELEASE_VERSION:String = "v. <version>"; // Release version indicator

		// Game types
		public static const GAME_TYPE_SINGLELINE_SLOTS:int   	= 1;
		public static const GAME_TYPE_VIDEO_SLOTS:int         	= 2;
		public static const GAME_TYPE_VIDEO_POKER:int         	= 3;
		public static const GAME_TYPE_VIDEO_KENO:int          	= 4;
		public static const GAME_TYPE_VIDEO_SLOTS_FSBONUS:int 	= 5;
		public static const GAME_TYPE_VIDEO_BLACKJACK:int	  	= 6;
		public static const GAME_TYPE_VIDEO_SLOTS_25:int  	  	= 7;
		public static const GAME_TYPE_SINGLINE_SLOTS_BIGPAY:int = 8;
		public static const GAME_TYPE_SUPER_VIDEO_SLOTS:int     = 9;
		public static const GAME_TYPE_QUAD_VIDEO_SLOTS:int		= 10;

		// QuadVideoSlots
		public static const MUMMYS_MONEY:String 		= "MummysMoney";

		// SinglelineSlots
		public static const FLAMING_7S:String 			= "Flaming7s";
		public static const GOLDEN_HORSESHOE:String 	= "GoldenHorseshoe";
		public static const HAUNTED_MANSION:String 		= "HauntedMansion";
		public static const NEPTUNES_TRIDENT:String 	= "NeptunesTrident";
		public static const OIL_TYCOON:String 			= "OilTycoon";
		public static const PIRATES_BOOTY:String 		= "PiratesBooty";
		public static const ROCK_STAR:String 			= "RockStar";
		public static const TIKI_TREASURE:String 		= "TikiTreasure";
		public static const WILD_WEST:String 			= "WildWest";

		// SuperVideoSlots
		public static const MOUNT_OLYMPUS:String 		= "MountOlympus";

		// VideoBlackjack
		public static const THE_BIG_DEAL:String 		= "TheBigDeal";

		// VideoKeno
		public static const DEFAULT_VIDEO_KENO:String 	= "Default";
		public static const VIDEO_KENO:String 		  	= "VideoKeno";
		public static const ALADDINS_KENO:String		= "AladdinsKeno";

		// VideoPoker
		public static const CROWN_JEWELS:String  		= "CrownJewels"
		public static const LUCKY_DAWG:String 	 		= "LuckyDawg";
		public static const POWER_POKER:String 	 		= "PowerPoker";
		public static const SAFE_CRACKER:String  		= "SafeCracker";
		public static const SHARP_SHOOTER:String 		= "SharpShooter";

		// VideoSlots
		public static const ATLANTIS:String 			= "Atlantis";
		public static const CHERRY_BOMB:String 			= "CherryBomb";
		public static const EMERALD_ERUPTION:String 	= "EmeraldEruption";
		public static const FLYING_FRUITS:String 		= "FlyingFruits_v2";
		public static const HOMERUN_DERBY:String 		= "HomeRunDerby_v2";
		public static const IRISH_LUCK:String 			= "IrishLuck_v2";
		public static const LUCKY_DUCKY:String 			= "LuckyDucky";
		public static const MAYAN_MONEY:String 			= "MayanMoney";
		public static const MEDUSAS_TREASURE:String 	= "MedusasTreasure";
		public static const SHARK_ATTACK:String 		= "SharkAttack";

		private static var AssetFileNames:Object = {};

		// QuadVideoSlots
		AssetFileNames[Config.MUMMYS_MONEY] =  		{ "ID": "28", "Type": GAME_TYPE_QUAD_VIDEO_SLOTS, 		"Label": "Mummy's Money", 		"MenuItem": Images.btnQVDSlot1, 	"Asset": CONFIG::MummysMoney, 		"Local": MUMMYS_MONEY + "_Skin.swf" };

		// SinglelineSlots
		AssetFileNames[Config.FLAMING_7S] =  		{ "ID":  "6", "Type": GAME_TYPE_SINGLELINE_SLOTS, 		"Label": "Flaming 7s", 			"MenuItem": Images.btnSLSlot4, 		"Asset": CONFIG::Flaming7s, 		"Local": FLAMING_7S + "_Skin.swf" };
		AssetFileNames[Config.GOLDEN_HORSESHOE] = 	{ "ID": "13", "Type": GAME_TYPE_SINGLELINE_SLOTS, 		"Label": "Golden Horseshoe", 	"MenuItem": Images.btnSLSlot7, 		"Asset": CONFIG::GoldenHorseshoe, 	"Local": GOLDEN_HORSESHOE + "_Skin.swf" };
		AssetFileNames[Config.HAUNTED_MANSION] = 	{ "ID":  "4", "Type": GAME_TYPE_SINGLELINE_SLOTS, 		"Label": "Haunted Mansion", 	"MenuItem": Images.btnSLSlot2, 		"Asset": CONFIG::HauntedMansion, 	"Local": HAUNTED_MANSION + "_Skin.swf" };
		AssetFileNames[Config.NEPTUNES_TRIDENT] =  	{ "ID": "14", "Type": GAME_TYPE_SINGLELINE_SLOTS, 		"Label": "Neptune's Trident", 	"MenuItem": Images.btnSLSlot8, 		"Asset": CONFIG::NeptunesTrident, 	"Local": NEPTUNES_TRIDENT + "_Skin.swf" };
		AssetFileNames[Config.OIL_TYCOON] =  		{ "ID": "22", "Type": GAME_TYPE_SINGLINE_SLOTS_BIGPAY, 	"Label": "Oil Tycoon", 			"MenuItem": Images.btnSLSlot9, 		"Asset": CONFIG::OilTycoon, 		"Local": OIL_TYCOON + "_Skin.swf" };
		AssetFileNames[Config.PIRATES_BOOTY] = 		{ "ID":  "1", "Type": GAME_TYPE_SINGLELINE_SLOTS, 		"Label": "Pirate's Booty", 		"MenuItem": Images.btnSLSlot1, 		"Asset": CONFIG::PiratesBooty, 		"Local": PIRATES_BOOTY + "_Skin.swf" };
		AssetFileNames[Config.ROCK_STAR] = 			{ "ID":  "7", "Type": GAME_TYPE_SINGLELINE_SLOTS, 		"Label": "Rock Star", 			"MenuItem": Images.btnSLSlot5, 		"Asset": CONFIG::RockStar, 			"Local": ROCK_STAR + "_Skin.swf" };
		AssetFileNames[Config.TIKI_TREASURE] = 		{ "ID": "12", "Type": GAME_TYPE_SINGLELINE_SLOTS, 		"Label": "Tiki Treasure", 		"MenuItem": Images.btnSLSlot6, 		"Asset": CONFIG::TikiTreasure, 		"Local": TIKI_TREASURE + "_Skin.swf" };
		AssetFileNames[Config.WILD_WEST] =  		{ "ID":  "5", "Type": GAME_TYPE_SINGLELINE_SLOTS, 		"Label": "Wild West", 			"MenuItem": Images.btnSLSlot3, 		"Asset": CONFIG::WildWest, 			"Local": WILD_WEST + "_Skin.swf" };

		// SuperVideoSlots
		AssetFileNames[Config.MOUNT_OLYMPUS] = 		{ "ID": "24", "Type": GAME_TYPE_SUPER_VIDEO_SLOTS, 		"Label": "Mount Olympus", 		"MenuItem": Images.btnSVDSlot1, 	"Asset": CONFIG::MountOlympus, 		"Local": MOUNT_OLYMPUS + "_Skin.swf" };

		// VideoBlackjack
		AssetFileNames[Config.THE_BIG_DEAL] = 		{ "ID": "20", "Type": GAME_TYPE_VIDEO_BLACKJACK, 		"Label": "The Big Deal", 		"MenuItem": Images.btnVDBlackjack1, "Asset": CONFIG::TheBigDeal,	 	"Local": THE_BIG_DEAL + "_Skin.swf" };

		// VideoKeno
		AssetFileNames[Config.DEFAULT_VIDEO_KENO] = { "ID": "10", "Type": GAME_TYPE_VIDEO_KENO, 			"Label": "Video Keno", 			"MenuItem": Images.btnVDKeno1, 		"Asset": "", 						"Local": "" };
		AssetFileNames[Config.VIDEO_KENO] = 		{ "ID": "18", "Type": GAME_TYPE_VIDEO_KENO, 			"Label": "Video Keno", 			"MenuItem": Images.btnVDKeno2, 		"Asset": "", 						"Local": "" };
		AssetFileNames[Config.ALADDINS_KENO] = 		{ "ID": "31", "Type": GAME_TYPE_VIDEO_KENO, 			"Label": "Aladdin's Keno",		"MenuItem": Images.btnVDKeno3, 		"Asset": "", 						"Local": "" };

		// VideoPoker
		AssetFileNames[Config.CROWN_JEWELS] = 		{ "ID":  "3", "Type": GAME_TYPE_VIDEO_POKER, 			"Label": "Crown Jewels", 		"MenuItem": Images.btnVDPoker1, 	"Asset": CONFIG::CrownJewels, 		"Local": CROWN_JEWELS + "_Skin.swf" };
		AssetFileNames[Config.LUCKY_DAWG] = 		{ "ID": "16", "Type": GAME_TYPE_VIDEO_POKER, 			"Label": "Lucky Dawg", 			"MenuItem": Images.btnVDPoker4, 	"Asset": CONFIG::LuckyDawg, 		"Local": LUCKY_DAWG + "_Skin.swf" };
		AssetFileNames[Config.POWER_POKER] = 		{ "ID": "15", "Type": GAME_TYPE_VIDEO_POKER, 			"Label": "Power Poker", 		"MenuItem": Images.btnVDPoker3, 	"Asset": CONFIG::PowerPoker, 		"Local": POWER_POKER + "_Skin.swf" };
		AssetFileNames[Config.SAFE_CRACKER] = 		{ "ID": "17", "Type": GAME_TYPE_VIDEO_POKER, 			"Label": "Safe Cracker", 		"MenuItem": Images.btnVDPoker5, 	"Asset": CONFIG::SafeCracker, 		"Local": SAFE_CRACKER + "_Skin.swf" };
		AssetFileNames[Config.SHARP_SHOOTER] = 		{ "ID": "11", "Type": GAME_TYPE_VIDEO_POKER, 			"Label": "Sharp Shooter", 		"MenuItem": Images.btnVDPoker2, 	"Asset": CONFIG::SharpShooter, 		"Local": SHARP_SHOOTER + "_Skin.swf" };

		// VideoSlots
		AssetFileNames[Config.ATLANTIS] = 			{ "ID": "30", "Type": GAME_TYPE_VIDEO_SLOTS_25, 		"Label": "Atlantis", 			"MenuItem": Images.btnVDSlot10, 	"Asset": CONFIG::Atlantis, 			"Local": ATLANTIS + "_Skin.swf" };
		AssetFileNames[Config.CHERRY_BOMB] = 		{ "ID": "21", "Type": GAME_TYPE_VIDEO_SLOTS_25, 		"Label": "Cherry Bomb", 		"MenuItem": Images.btnVDSlot4,		"Asset": CONFIG::CherryBomb, 		"Local": CHERRY_BOMB + "_Skin.swf" };
		AssetFileNames[Config.EMERALD_ERUPTION] = 	{ "ID": "29", "Type": GAME_TYPE_VIDEO_SLOTS_25, 		"Label": "Emerald Eruption", 	"MenuItem": Images.btnVDSlot9, 		"Asset": CONFIG::EmeraldEruption, 	"Local": EMERALD_ERUPTION + "_Skin.swf" };
		AssetFileNames[Config.FLYING_FRUITS] = 		{ "ID":  "9", "Type": GAME_TYPE_VIDEO_SLOTS_FSBONUS, 	"Label": "Flying Fruits", 		"MenuItem": Images.btnVDSlot3, 		"Asset": CONFIG::FlyingFruits, 		"Local": FLYING_FRUITS + "_Skin.swf" };
		AssetFileNames[Config.HOMERUN_DERBY] =  	{ "ID":  "8", "Type": GAME_TYPE_VIDEO_SLOTS_FSBONUS, 	"Label": "Home Run Derby", 		"MenuItem": Images.btnVDSlot1, 		"Asset": CONFIG::HomeRunDerby, 		"Local": HOMERUN_DERBY + "_Skin.swf" };
		AssetFileNames[Config.IRISH_LUCK] = 		{ "ID":  "2", "Type": GAME_TYPE_VIDEO_SLOTS_FSBONUS, 	"Label": "Irish Luck", 			"MenuItem": Images.btnVDSlot2,		"Asset": CONFIG::IrishLuck, 		"Local": IRISH_LUCK + "_Skin.swf" };
		AssetFileNames[Config.LUCKY_DUCKY] = 		{ "ID": "23", "Type": GAME_TYPE_VIDEO_SLOTS_25, 		"Label": "Lucky Ducky", 		"MenuItem": Images.btnVDSlot5, 		"Asset": CONFIG::LuckyDucky, 		"Local": LUCKY_DUCKY + "_Skin.swf" };
		AssetFileNames[Config.MAYAN_MONEY] =  		{ "ID": "27", "Type": GAME_TYPE_VIDEO_SLOTS_25, 		"Label": "Mayan Money", 		"MenuItem": Images.btnVDSlot8, 		"Asset": CONFIG::MayanMoney, 		"Local": MAYAN_MONEY + "_Skin.swf" };
		AssetFileNames[Config.MEDUSAS_TREASURE] =  	{ "ID": "25", "Type": GAME_TYPE_VIDEO_SLOTS_25, 		"Label": "Medusa's Treasure", 	"MenuItem": Images.btnVDSlot6, 		"Asset": CONFIG::MedusasTreasure, 	"Local": MEDUSAS_TREASURE + "_Skin.swf" };
		AssetFileNames[Config.SHARK_ATTACK] =  		{ "ID": "26", "Type": GAME_TYPE_VIDEO_SLOTS_25, 		"Label": "Shark Attack", 		"MenuItem": Images.btnVDSlot7, 		"Asset": CONFIG::SharkAttack, 		"Local": SHARK_ATTACK + "_Skin.swf" };

		public function Config()
		{

		}

		public static function get Debug():Boolean
		{
			return COMPILER_BUILD_W_SCRIPT ? COMPILER_DEBUG : LOCAL_DEBUG;
		}

		public static function get Debug_w_api():Boolean
		{
			return COMPILER_BUILD_W_SCRIPT ? COMPILER_DEBUG_W_API : LOCAL_DEBUG_W_API;
		}

		public static function get Build_Version():String
		{
			return COMPILER_BUILD_W_SCRIPT ? COMPILER_RELEASE_VERSION : LOCAL_RELEASE_VERSION;
		}

		public static function Game_Asset( gameName:String ):String
		{
			return AssetFileNames[gameName][COMPILER_BUILD_W_SCRIPT ? "Asset" : "Local"];
		}

		public static function Game_ID( gameName:String ):String
		{
			return AssetFileNames[gameName]["ID"];
		}

		public static function Game_Type( gameName:String ):String
		{
			return AssetFileNames[gameName]["Type"];
		}

		public static function Game_Label( gameName:String ):String
		{
			return AssetFileNames[gameName]["Label"];
		}

		public static function Game_Menu_Item( gameName:String ):Class
		{
			return AssetFileNames[gameName]["MenuItem"] as Class;
		}
	}
}