package utils
{
	import assets.SkinManager;
	
	import components.GradientLabel;
	import components.SpriteUIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import mx.controls.Label;
	import mx.events.FlexEvent;
	import mx.graphics.ImageSnapshot;
	import mx.styles.IStyleManager2;
	
	import objects.Coord;
	import objects.ReelIcon;
	
	import spark.components.Group;

	public class GraphicHelper
	{
		/**
		 * Accepts coordinates for a line from A to B and returns a path of commands and coordinates from A to B to A
		 * suitable for a drawPath command.
		 * 
		 * @param coords A list of coordinates for a line.
		 * @param thickness A value indicating how thick the line should be, aka strokeWidth.
		 */
		public static function getLinePathFromLine( coords:Vector.<Coord>, thickness:int = 4 ):Object
		{
			var retCommands:Vector.<int> = new Vector.<int>();
			var retCoords:Vector.<Number> = new Vector.<Number>();
			var coordsFwd:Vector.<Coord> = new Vector.<Coord>();
			var coordsBck:Vector.<Coord> = new Vector.<Coord>();
			
			if( thickness < 2 )
			{
				thickness == 2;
			}
			
			for( var i:int = 0; i < coords.length - 1; i++ ) {
				var c1:Coord = coords[i];
				var c2:Coord = coords[i + 1];
				
				var r:Number = Math.atan2( ( c2.y - c1.y ),( c2.x - c1.x ) );
				var cos:Number = Math.cos( r );
				var sin:Number = Math.sin( r );
				
				var x1:Number = cos * 0 - sin * -( thickness/2 );
				var y1:Number = sin * 0 + cos * -( thickness/2 );
				var x2:Number = cos * 0 - sin * ( thickness/2 );
				var y2:Number = sin * 0 + cos * ( thickness/2 );    
				
				coordsFwd.push( new Coord( c1.x + x1, c1.y + y1 ) );
				coordsFwd.push( new Coord( c2.x + x1, c2.y + y1 ) );
				coordsBck.push( new Coord( c1.x + x2, c1.y + y2 ) );
				coordsBck.push( new Coord( c2.x + x2, c2.y + y2 ) );    
			}
			
			while( coordsBck.length > 0 )
			{
				coordsFwd.push( coordsBck.pop() );
			}
			
			while( coordsFwd.length > 0 )
			{
				var c:Coord = coordsFwd.shift();
				retCommands.push( retCommands.length == 0 ? 1 : 2 );
				retCoords.push( c.x );
				retCoords.push( c.y );
			}
			
			return { commands: retCommands, coords: retCoords };
		}
		
		public function GraphicHelper()
		{
		}
	}
}