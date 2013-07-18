package components.QuadVideoSlots
{
	import flash.geom.Point;

	public class PathFinderPath
	{
		private var _pathData:String
		private var _children:Array;
		private var _parent:PathFinderPath = null;
		
		public function get children():Array
		{
			return _children;
		}
		
		public function get parent():PathFinderPath
		{
			return _parent;
		}
		
		public function set parent( value:PathFinderPath ):void
		{
			_parent = value;
		}
		
		public function get pathData():String
		{
			return _pathData;
		}
		
		public function getPathPoints():Vector.<Point>
		{
			var points:Array = _pathData.split( /[^-0-9]+/gi );
			points.shift();
			
			var pts:Vector.<Point> = new Vector.<Point>();
			for( var i:int = 0; i < points.length; i += 2 )
			{
				pts.push( new Point( points[i], points[i + 1] ) );
			}
			
			return pts;
		}
		
		public function getLastPoint():Point
		{
			return getPathPoints().pop();
		}
		
		public function PathFinderPath( pathData:String )
		{
			_pathData = pathData;
			_children = [];
		}
		
		public function addChild( child:PathFinderPath ):PathFinderPath
		{
			child.parent = this;
			_children.push( child );
			
			return this;
		}
	}
}