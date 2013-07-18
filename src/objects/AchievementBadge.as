package objects
{
	import assets.Achievements.Badges;
	
	import utils.DebugHelper;

	public class AchievementBadge extends Achievement
	{				
		// Logging
		private static const logger:DebugHelper = new DebugHelper( AchievementBadge );	
		
		public static const BADGE_PREFIX:String 		= "Badge";
		public static const BADGE_BRONZE:String 		= "Bronze";		
		public static const BADGE_SILVER:String 		= "Silver";		
		public static const BADGE_GOLD:String 			= "Gold";		
		public static const BADGE_PLATINUM:String 		= "Platinum";		
		public static const BADGE_AROUNDTHEWORLD:String = "AroundTheWorld";		
		public static const BADGE_FF10:String 			= "FF10";		
		public static const BADGE_FF20:String 			= "FF20";		
		public static const BADGE_FF30:String 			= "FF30";
		public static const BADGE_EXPERT:String 		= "Expert";
		public static const BADGE_SUPER7:String 		= "Super7";
		public static const BADGE_BONUS:String 			= "BonusBuster";
		
		private static var badgeList:Array = null;		
		private static var badgeDetails:Object = 
			{
				"Bronze": 		  { "Display":"Bronze", "ImagePrefix":"badgeBronze", "Description":"Press reveal over 250 times.", "PopupDescription":"You've pressed reveal over 250 times." },
				"Silver": 		  { "Display":"Silver", "ImagePrefix":"badgeSilver", "Description":"Press reveal over 1,000 times.", "PopupDescription":"You've pressed reveal over 1,000 times." },
				"Gold": 		  { "Display":"Gold", "ImagePrefix":"badgeGold", "Description":"Press reveal over 10,000 times.", "PopupDescription":"You've pressed reveal over 10,000 times." },
				"Platinum": 	  { "Display":"Platinum", "ImagePrefix":"badgePlatinum", "Description":"Press reveal over 100,000 times.", "PopupDescription":"You've pressed reveal over 100,000 times." },
				"AroundTheWorld": { "Display":"Around The World", "ImagePrefix":"badgeArThWrld", "Description":"10 reveals on 20 different games.", "PopupDescription":"You have 10 reveals on 20 different games." },
				"FF10": 		  { "Display":"FF10", "ImagePrefix":"badgeFreqFly10", "Description":"Play for 10 consecutive days. (Based on EST)", "PopupDescription":"You've played for 10 consecutive days. Now shoot for 20! (Based on EST)" },
				"FF20": 		  { "Display":"FF20", "ImagePrefix":"badgeFreqFly20", "Description":"Play for 20 consecutive days. (Based on EST)", "PopupDescription":"You've played for 20 consecutive days. Now shoot for 30! (Based on EST)" },
				"FF30": 		  { "Display":"FF30", "ImagePrefix":"badgeFreqFly30", "Description":"Play for 30 consecutive days. (Based on EST)", "PopupDescription":"You've played for 30 consecutive days. (Based on EST)" },
				"Expert": 		  { "Display":"Expert", "ImagePrefix":"badgeExpert", "Description":"Press reveal over 10,000 times on a single game.", "PopupDescription":"You've pressed reveal over 10,000 times on a single game." },
				"Super7": 		  { "Display":"Super Seven", "ImagePrefix":"badgeSupSev", "Description":"Play on each day of the week, Sunday - Saturday. Non-consecutive.", "PopupDescription":"You've played on each day of the week, Sunday - Saturday. Non-consecutive." },
				"BonusBuster":    { "Display":"Bonus Buster", "ImagePrefix":"badgeBonBus", "Description":"Play a bonus game on 4 different games.", "PopupDescription":"You've played a bonus game on 4 different games." }			
			};
		
		public function AchievementBadge( id:String, name:String )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );
			
			var details:Object = badgeDetails[name];
			this.ID = id;
			this.Name = name;
			this.DisplayName = details["Display"];
			this.ImageClass = assets.Achievements.Badges[details["ImagePrefix"]];
			this.ImageClassEmpty = assets.Achievements.Badges[details["ImagePrefix"] + "Empty"];
			this.ImageClassMedium = assets.Achievements.Badges[details["ImagePrefix"] + "Medium"];
			this.ImageClassEmptyMedium = assets.Achievements.Badges[details["ImagePrefix"] + "EmptyMedium"];			
			this.ImageClassSmall = assets.Achievements.Badges[details["ImagePrefix"] + "Small"];
			this.ImageClassEmptySmall = assets.Achievements.Badges[details["ImagePrefix"] + "EmptySmall"];			
			this.Description = details["Description"];
			this.PopupDescription = details["PopupDescription"];
			
			// Clear Context
			logger.popContext();
		}
		
		public static function getBadgeList():Array
		{
			// Log Activity
			logger.pushContext( "getBadgeList", arguments );
			
			if( badgeList == null )
			{
				badgeList = new Array();
				badgeList.push( new AchievementBadge( BADGE_PREFIX + AchievementBadge.BADGE_BRONZE, AchievementBadge.BADGE_BRONZE ) );		
				badgeList.push( new AchievementBadge( BADGE_PREFIX + AchievementBadge.BADGE_SILVER, AchievementBadge.BADGE_SILVER ) );	
				badgeList.push( new AchievementBadge( BADGE_PREFIX + AchievementBadge.BADGE_GOLD, AchievementBadge.BADGE_GOLD) );	
				badgeList.push( new AchievementBadge( BADGE_PREFIX + AchievementBadge.BADGE_PLATINUM, AchievementBadge.BADGE_PLATINUM) );	
				badgeList.push( new AchievementBadge( BADGE_PREFIX + AchievementBadge.BADGE_AROUNDTHEWORLD, AchievementBadge.BADGE_AROUNDTHEWORLD ) );		
				badgeList.push( new AchievementBadge( BADGE_PREFIX + AchievementBadge.BADGE_FF10, AchievementBadge.BADGE_FF10 ) );
				badgeList.push( new AchievementBadge( BADGE_PREFIX + AchievementBadge.BADGE_FF20, AchievementBadge.BADGE_FF20 ) );
				badgeList.push( new AchievementBadge( BADGE_PREFIX + AchievementBadge.BADGE_FF30, AchievementBadge.BADGE_FF30 ) );
				badgeList.push( new AchievementBadge( BADGE_PREFIX + AchievementBadge.BADGE_EXPERT, AchievementBadge.BADGE_EXPERT ) );
				badgeList.push( new AchievementBadge( BADGE_PREFIX + AchievementBadge.BADGE_SUPER7, AchievementBadge.BADGE_SUPER7 ) );
				badgeList.push( new AchievementBadge( BADGE_PREFIX + AchievementBadge.BADGE_BONUS, AchievementBadge.BADGE_BONUS ) );
			}
			
			// Clear Context
			logger.popContext();			
			return badgeList;
		}		
	}
}