package objects
{
	public class ProgressiveBalanceResponse
	{
		private var progressiveBalance:int;         // The balance of the progressive jackpot
		private var progressiveWinUsername:String;  // The last winner of this progressive jackpot
		private var progressiveWinAmount:int;       // The last amount won on the progressive jackpot
		
		private var communityBalance:int;        // The balance of the community jackpot
		private var communityCountdown:Boolean;  // True if we should start our countdown
		private var communityWin:Boolean;        // True if this spin should produce a win
		private var communityCustomerCount:int;  // The amount of players this win is distributed to
		private var communityCustomerWin:int;    // The amount each player wins
		
		private var marqueeVersion:String;  // The version of the marquee
		
		private var fireworks:int;  // The count of fireworks to set off
		
		public function get ProgressiveBalance():int
		{ 
			return this.progressiveBalance; 
		} 
		
		public function get ProgressiveWinUsername():String
		{ 
			return this.progressiveWinUsername; 
		} 
		
		public function get ProgressiveWinAmount():int
		{ 
			return this.progressiveWinAmount; 
		} 
		
		public function get CommunityBalance():int
		{ 
			return this.communityBalance; 
		}
		
		public function get CommunityCountdown():Boolean
		{ 
			return this.communityCountdown; 
		}		
		
		public function get CommunityWin():Boolean
		{ 
			return this.communityWin; 
		}
		
		public function get CommunityCustomerCount():int
		{ 
			return this.communityCustomerCount; 
		}
		
		public function get CommunityCustomerWin():int
		{ 
			return this.communityCustomerWin; 
		}		
		
		public function get MarqueeVersion():String
		{ 
			return this.marqueeVersion; 
		} 		
	
		public function get Fireworks():int
		{
			return this.fireworks;
		}
		
		public function ProgressiveBalanceResponse( jsonResponse:Object )
		{
			// ProgressiveBalance should always be present, ProgressiveWin is optional
			this.progressiveBalance = jsonResponse.ProgressiveBalance.balance;
			this.progressiveWinUsername = jsonResponse.ProgressiveWin != null ? jsonResponse.ProgressiveWin.Username : null;
			this.progressiveWinAmount = jsonResponse.ProgressiveWin != null ? jsonResponse.ProgressiveWin.Amount : -1;
			
			// CommunityBalance should always be present, all subkeys are optional
			this.communityBalance = jsonResponse.CommunityBalance.balance != null ? jsonResponse.CommunityBalance.balance : -1;
			this.communityCountdown = jsonResponse.CommunityBalance.Countdown != null ? jsonResponse.CommunityBalance.Countdown : false;
			this.communityWin = jsonResponse.CommunityBalance.Win != null ? jsonResponse.CommunityBalance.Win : false;
			this.communityCustomerCount = jsonResponse.CommunityBalance.customer_count != null ? jsonResponse.CommunityBalance.customer_count : -1;
			this.communityCustomerWin = jsonResponse.CommunityBalance.customer_win != null ? jsonResponse.CommunityBalance.customer_win : -1;
			
			// MarqueeSettings and version should always be present
			this.marqueeVersion = jsonResponse.MarqueeSettings.Version;
			
			// Fireworks for highwinners
			this.fireworks = jsonResponse.Fireworks != null ? jsonResponse.Fireworks : 0;
		}
		
		public function toString():String
		{
			var str:String = "";
			str += "ProgressiveBalance: " + this.ProgressiveBalance.toString()  + ", ";
			str += "ProgressiveWinUsername: " + this.ProgressiveWinUsername + ", ";
			str += "ProgressiveWinAmount: " + this.ProgressiveWinAmount + ", ";
			
			str += "CommunityBalance: " + this.CommunityBalance.toString()  + ", ";
			str += "CommunityCountdown: " + this.CommunityCountdown.toString()  + ", ";	
			str += "CommunityWin: " + this.CommunityWin.toString()  + ", ";			
			str += "CommunityCustomerCount: " + this.CommunityCustomerCount.toString()  + ", ";
			str += "CommunityCustomerWin: " + this.CommunityCustomerWin.toString()  + ", ";
			
			str += "MarqueeVersion: " + this.MarqueeVersion.toString() + ", ";
			
			str += "Fireworks: " + this.Fireworks.toString();
			
			return str;
		}		
	}
}