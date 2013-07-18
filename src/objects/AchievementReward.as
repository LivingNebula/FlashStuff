package objects
{
	import assets.Achievements.Rewards;
	
	import utils.DebugHelper;
	
	public class AchievementReward extends Achievement
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( AchievementReward );	
		
		public static const REWARD_RABBITS_FOOT:String = "RabbitsFoot";		
		public static const REWARD_NUDGE:String 	   = "Nudge";		
		public static const REWARD_GAME_CHANGER:String = "GameChanger";	
		
		private static var rewardList:Array = null;		
		private static var rewardDetails:Object = 
			{
				"GameChanger": 	{ "Display":"Game Changer", "BadgesRequired":["Bronze"], "ImagePrefix":"rewardGameChanger", "Description":"Ability to switch backgrounds in Video Slots", "PopupDescription":"You can now switch backgrounds in Video Slots." },	
				"Nudge": 		{ "Display":"Nudge", "BadgesRequired":["AroundTheWorld","Silver"], "ImagePrefix":"rewardNudge", "Description":"Ability to nudge a reel in Singleline Slots", "PopupDescription":"You can now nudge a reel in Singleline Slots." },				
				"RabbitsFoot": 	{ "Display":"Rabbit's Foot", "BadgesRequired":["Super7","BonusBuster","Gold"], "ImagePrefix":"rewardRabbitsFoot", "Description":"Ability to undo a reveal in a bonus game.", "PopupDescription":"You can now undo a reveal in a bonus game." }			
			};	
		
		private var badgesRequired:Array;

		public function get BadgesRequired():Array
		{
			return this.badgesRequired;
		}
		
		public function set BadgesRequired( _badgesRequired:Array ):void
		{
			this.badgesRequired = _badgesRequired;
		}

		public function AchievementReward( name:String )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );
			
			var details:Object = rewardDetails[name];
			this.Name = name;
			this.DisplayName = details["Display"];
			this.BadgesRequired = details["BadgesRequired"];
			this.ImageClass = assets.Achievements.Rewards[details["ImagePrefix"]];
			this.ImageClassEmpty = assets.Achievements.Rewards[details["ImagePrefix"] + "Empty"];
			this.ImageClassSmall = assets.Achievements.Rewards[details["ImagePrefix"] + "Small"];
			this.ImageClassEmptySmall = assets.Achievements.Rewards[details["ImagePrefix"] + "EmptySmall"];
			this.Description = details["Description"];
			this.PopupDescription = details["PopupDescription"];
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Returns an array of all available rewards
		 */
		public static function getRewardList():Array
		{
			// Log Activity
			logger.pushContext( "getRewardList", arguments );
			
			if( rewardList == null )
			{
				rewardList = new Array();
				rewardList.push( new AchievementReward( AchievementReward.REWARD_RABBITS_FOOT ) );		
				rewardList.push( new AchievementReward( AchievementReward.REWARD_NUDGE ) );	
				rewardList.push( new AchievementReward( AchievementReward.REWARD_GAME_CHANGER ) );	
			}
			
			// Clear Context
			logger.popContext();			
			return rewardList;
		}	
		
		/**
		 * Returns an array of reward names that are attainable based on the supplied badge names
		 */
		public static function getApplicableRewards( badges:Array ):Array
		{
			// Log Activity
			logger.pushContext( "getApplicableRewards", arguments );
			
			var applicable:Array = [], attainable:Boolean, i:int, j:int, rewards:Array = getRewardList();
			
			// For all available rewards
			for( i = 0; i < rewards.length; i++ )
			{
				attainable = true;
				
				// For all required bages of this reward
				for( j = 0; j < rewards[i].BadgesRequired.length; j++ )
				{
					// If we do not have a given badge in our list, we cannot attain this reward
					if( badges.indexOf( rewards[i].BadgesRequired[j] ) == -1 )
					{
						attainable = false;
						break;
					}
				}
				
				// If the reward is attainable, add it to the list
				if( attainable ) 
				{
					applicable.push( rewards[i].Name );
				}
			}
			
			// Clear Context
			logger.popContext();			
			return applicable;
		}
	}
}