package objects
{
	public class LineWin
	{
		public var ThemeIndex:int = 0;
		public var LineNumber:int = 0;
		public var WinCount:int = 0;
		public var Icon:String = "";	
		public var ContainsWilds:Boolean = false;
		public var WildIcon:String = "";
		public var ContainsMultiplier:Boolean = false;
		public var MultiplierIcon:String = "";		
		
		public function LineWin( lineNumber:int, winCount:int, icon:String, themeIndex:int = 0, cotainsWilds:Boolean = false, wildIcon:String = "", containsMultiplier:Boolean = false, multiplierIcon:String = "" )
		{
			ThemeIndex = themeIndex;
			LineNumber = lineNumber;
			WinCount = winCount;
			Icon = icon;
			ContainsWilds = cotainsWilds;
			WildIcon = wildIcon;
			ContainsMultiplier = containsMultiplier;
			MultiplierIcon = multiplierIcon;
		}
		
		public function toString():String
		{
			var str:String = "";		
			
			str += ThemeIndex.toString() + ":";
			str += LineNumber.toString() + ": ";
			str += WinCount.toString();
			str += " [" + Icon + "]";
			str += " ( Wild ? " + ContainsWilds + " " + ( ContainsWilds ? WildIcon : "" ) + " )";
			str += " ( Multiplier ? " + ContainsMultiplier + " " + ( ContainsMultiplier ? MultiplierIcon : "" ) + " )";
			
			return str;
		}
	}
}