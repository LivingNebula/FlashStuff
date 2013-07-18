package objects
{
	public class PlayGameResponse
	{
		private var reelOutput:Array;
		private var winAmount:Number;
		private var bonusAmount:Number;
		private var scatterAmount:Number;
		private var lineWins:int;
		private var freeSpins:Array;
		private var freeSpinBonusIcon:String;
		private var entries:int;
		private var winnings:int;
		private var hand:Array;
		private var progressiveBalance:int;
		private var progressiveWin:int;
		private var achievements:Array;
		
		public function get ReelOutput():Array
		{ 
			return this.reelOutput; 
		} 
		
		public function get WinAmount():Number
		{ 
			return this.winAmount; 
		} 
		
		public function get BonusAmount():Number
		{ 
			return this.bonusAmount; 
		} 
		
		public function get ScatterAmount():Number
		{ 
			return this.scatterAmount; 
		} 
		
		public function get LineWins():int
		{ 
			return this.lineWins; 
		} 
		
		public function get FreeSpins():Array
		{ 
			return this.freeSpins; 
		} 
		
		public function get FreeSpinBonusIcon():String
		{
			return this.freeSpinBonusIcon;
		}
		
		public function get Entries():int
		{ 
			return this.entries; 
		} 
		
		public function get Winnings():int
		{ 
			return this.winnings; 
		} 
		
		public function get Hand():Array
		{ 
			return this.hand; 
		} 
		
		public function get ProgressiveBalance():int
		{ 
			return this.progressiveBalance; 
		} 
		
		public function get ProgressiveWin():int
		{ 
			return this.progressiveWin; 
		}
		
		public function get Achievements():Array
		{
			return this.achievements;
		}
		
		public function PlayGameResponse( jsonResponse:Object )
		{
			this.reelOutput = jsonResponse.ReelOutput;
			this.winAmount = jsonResponse.WinAmount;
			this.bonusAmount = jsonResponse.BonusAmount;
			this.scatterAmount = jsonResponse.ScatterAmount;
			this.lineWins = jsonResponse.LineWins;
			this.freeSpins = jsonResponse.FreeSpins;
			this.freeSpinBonusIcon = jsonResponse.BonusSymbol;
			this.entries = jsonResponse.Entries;
			this.winnings = jsonResponse.Winnings;
			this.hand = jsonResponse.Hand;
			this.progressiveBalance = jsonResponse.ProgressiveBalance != null ? jsonResponse.ProgressiveBalance.balance : -1;
			this.progressiveWin = jsonResponse.ProgressiveWin != null ? jsonResponse.ProgressiveWin.win_amount : -1;
			this.achievements = jsonResponse.Achievements;
		}
		
		public function toString():String
		{
			var str:String = "";
			str += "ReelOutput: " + ( this.reelOutput == null ? "null" : this.reelOutput.toString() ) + ", ";
			str += "WinAmount: " + this.winAmount.toString() + ", ";
			str += "BonusAmount: " + this.bonusAmount.toString() + ", ";
			str += "ScatterAmount: " + this.scatterAmount.toString() + ", ";
			str += "LineWins: " + this.lineWins.toString() + ", ";
			str += "FreeSpins: " + ( this.freeSpins == null ? "null" : this.freeSpins.toString() ) + ", ";
			str += "FreeSpinBonusIcon: " + ( this.freeSpinBonusIcon == null ? "null" : this.freeSpinBonusIcon ) + ", ";
			str += "Entries: " + this.entries.toString() + ", ";
			str += "Winnings: " + this.winnings.toString() + ", ";
			str += "Hand: " + ( this.hand == null ? "null" : this.hand.toString() ) + ", ";
			str += "ProgressiveBalance: " + this.progressiveBalance.toString() + ", ";
			str += "ProgressiveWin: " + this.progressiveWin.toString() + ", ";
			str += "Achievements: " + ( this.achievements == null ? "null" : this.achievements.toString() );
			
			return str;
		}
	}
}