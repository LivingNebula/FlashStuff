package objects
{
	import mx.utils.StringUtil;

	public class Route
	{
		public var BaseStartValue:int = 0;
		public var BaseEndValue:int = 0;
		public var TotalStartValue:int = 0;
		public var TotalEndValue:int = 0;
		public var Display:String = "";
		public var Func:String = "";
		
		public function Route( baseStartValue:int = 0, baseEndValue:int = 0, func:String = "", display:String = "", totalStartValue:int = 0, totalEndValue:int = 0 )
		{
			BaseStartValue = baseStartValue;
			BaseEndValue = baseEndValue;
			Func = func;
			Display = display;
			TotalStartValue = totalStartValue;
			TotalEndValue = totalEndValue;
		}
		
		public function toString():String
		{
			var sb:String = "";
			
			
			sb += padLeft( "$" + ( TotalStartValue / 100.00 ).toFixed(2), 7 );
			sb += " [";
			sb += padLeft( BaseStartValue.toString(), 3 );
			sb += "]";
			sb += "\t";
			sb += padLeft( Display, 10 );
			sb += "\t";
			sb += " [";
			sb += Func;
			switch( Func )
			{
				case "/":
					sb += padLeft( ( BaseStartValue / BaseEndValue ).toString(), 3);
					break;
				
				case "+":
					sb += padLeft( ( BaseEndValue - BaseStartValue ).toString(), 3);
					break;
				
				case "*":
					sb += padLeft( ( BaseEndValue / BaseStartValue ).toString(), 3);
					break;
			}
			sb += "]";
			sb += "\t";
			sb += padLeft( "$" + ( TotalEndValue / 100.00 ).toFixed(2), 7 );
			sb += " [";
			sb += padLeft( BaseEndValue.toString(), 3 );
			sb += "]";
			
			return sb
		}
		
		private function padLeft( str:String, padLen:int ):String
		{
			if( str.length >= padLen )
			{
				return str;
			}
			
			return mx.utils.StringUtil.repeat(" ", padLen - str.length ) + str;
		}
	}
}