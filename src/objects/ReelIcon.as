package objects
{
	public class ReelIcon
	{
		private var _name:String;
		private var _payouts:Array;
		private var _isWild:Boolean;
		private var _isScatter:Boolean;
		private var _lineMultiplierPayout:int = 0;
		private var _staticPayout:int = 0;
		private var _displayName:String = "";
		
		public function get name():String
		{
			return _name;
		}
		
		public function get payouts():Array
		{
			return _payouts;
		}
		
		public function get isWild():Boolean
		{
			return _isWild;
		}
		
		public function get isScatter():Boolean
		{
			return _isScatter;
		}
		
		public function get isMultiplier():Boolean
		{
			return _lineMultiplierPayout > 0;
		}
		
		public function get isStaticPayout():Boolean
		{
			return _staticPayout > 0;
		}
		
		public function get lineMultiplierPayout():int
		{
			return _lineMultiplierPayout;
		}
		
		public function get staticPayout():int
		{
			return _staticPayout;
		}
		
		public function get displayName():String
		{
			return _displayName;
		}
		
		public function set displayName( value:String ):void
		{
			_displayName = value;
		}
		
		public function ReelIcon( name:String, payouts:Array, isWild:Boolean = false, isScatter:Boolean = false, lineMultiplierPayout:int = 0, staticPayout:int = 0, displayName:String = null )
		{
			_name = name;
			_payouts = payouts;
			_isWild = isWild;
			_isScatter = isScatter;
			_lineMultiplierPayout = lineMultiplierPayout;
			_staticPayout = staticPayout;			
			_displayName = displayName;
		}
		
		public function toString():String
		{
			return _name;
		}
	}
}