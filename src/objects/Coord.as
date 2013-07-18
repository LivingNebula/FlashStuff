package objects
{
	/**
	 * A simple class which represents an x, y screen coordinate. 
	 */
	public class Coord
	{
		public var x:Number;
		public var y:Number;
		
		/**
		 * Constructs a new <code>Coord</code>
		 * 
		 * @param x A <code>Number</code> representing the x position on a screen.
		 * @param y A <code>Number</code> representing the y position on a screen.
		 */
		public function Coord( x:Number, y:Number )
		{
			this.x = x;
			this.y = y;
		}
		
		public function toString():String
		{
			return "{x:" + x.toString() + ", y:" + y.toString() + "}";
		}
	}
}