package utils
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	public class MemoryTracker
	{
		private static var _tracking:Dictionary = new Dictionary( true );
		private static var _trackingCount:int = 0;
		private static var _stage:Stage = null;
		
		public static function set stage( s:Stage ):void
		{
			_stage = s;
		}
				
		public static function track( obj:*, label:String ):void
		{
			_tracking[obj] = label;	
		}
		
		public static function gcAndCheck():void
		{
			_trackingCount = 0;
			_stage.addEventListener(Event.ENTER_FRAME, _gc );
		}
		
		private static function _gc( e:Event ):void
		{
			var runLast:Boolean = false;
			
			System.gc();			
			runLast = _trackingCount++ > 1;
			
			if( runLast )
			{
				( e.target as Stage).removeEventListener( Event.ENTER_FRAME, _gc );
				setTimeout( _doLastGC, 40 );
			}
		}
		
		private static function _doLastGC():void
		{
			System.gc();
			trace( "--------------------------------------------------------------" );
			trace( "Remaining references in the MemoryTracker:" );
			for( var key:Object in _tracking)
			{
				trace( "	Found reference to " + key + ", label: " + _tracking[key] + "" );
			}
			trace( "--------------------------------------------------------------" );
		}
	}
}