package utils
{
	public class FormatHelper
	{
		public static const PAD_DIRECTION_LEFT:int = 0;
		public static const PAD_DIRECTION_RIGHT:int = 1;
		
		public static function formatEntriesAndWinnings( amount:int, showEntries:Boolean = true ):String
		{
			if( showEntries )
			{
				return amount.toString();
			}
			else
			{
				return ( amount / 100 ).toFixed( 2 );
			}
		}
		
		public static function padString( str:String, length:int, padString:String = " ", direction:int = PAD_DIRECTION_RIGHT ):String
		{
			if( str.length >= length ){
				return str;
			}
			
			var padLen:int = length - str.length;
			var padStr:String = "";
			for( var i:int = 0; i < padLen; i++ ) 
			{
				padStr = padStr.concat( padString );
			}
			
			return direction == PAD_DIRECTION_LEFT ? padStr + str : str + padStr;
		}
	}
}