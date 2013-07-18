package assets
{
	import flash.utils.Timer;
	
	public class SimpleDataTimer extends Timer
	{
		private var _data:*;
		
		public function get data():*
		{
			return _data;
		}
		
		public function set data( value:* ):void
		{
			_data = value;
		}
		
		// Initializes the Simple Data Timer
		public function SimpleDataTimer( delay:Number, repeatCount:int = 0 )
		{
			// Initialize the super class
			super( delay, repeatCount );
			
			_data = null;
		}
	}
}