package objects
{
	public class ReelPosition
	{
		public var Icon:String = "";
		public var Position:int = -1;
		public var WinAnimation:* = null;
		
		public function ReelPosition( icon:String, position:int )
		{
			Icon = icon;
			Position = position;
		}
		
		public function toString():String
		{
			var str:String = "";		
			
			str += Position.toString();
			str += " [" + Icon.replace( "ReelIcon_", "" ) + "]";
			
			return str;
		}
	}
}