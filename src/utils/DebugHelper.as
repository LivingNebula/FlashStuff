package utils
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.utils.*;
	
	import mx.collections.ArrayCollection;
	
	import objects.ErrorMessage;
	
	import starling.events.Event;
	
	public class DebugHelper
	{	
		// Constants
		public static const DEBUG_LEVEL_INFO:String  = "INFO "; // Deliberate padding here to make the logs consistent		
		public static const DEBUG_LEVEL_DEBUG:String = "DEBUG";
		public static const DEBUG_LEVEL_WARN:String  = "WARN "; // Deliberate padding here to make the logs consistent
		public static const DEBUG_LEVEL_ERROR:String = "ERROR";
		public static const ROLLING_LOG_LIMIT:int = 60;
		
		// Static Vars
		public static var isDebug:Boolean = false;		
		private static var rollingLog:Array = [];
		
		// Instances Vars
		private var name:String;
		private var contexts:Array = [];
		
		public function DebugHelper( cls:Object ):void
		{
			name = getQualifiedClassName( cls ).split("::").pop();
		}
		
		public function pushContext( context:String, debugArgs:Array = null, log:Boolean = true ):DebugHelper
		{
			contexts.push( context );
			if( log )
			{
				internalLog( DEBUG_LEVEL_DEBUG, name, contexts, filterItems( debugArgs || [] ).join( ", " ), false );
			}
			
			return this;
		}
		
		public function popContext( log:Boolean = true ):DebugHelper
		{
			if( log )
			{
				info("exiting");
			}				
			contexts.pop();
			
			return this;
		}
		
		public function info( ...items ):DebugHelper
		{
			internalLog( DEBUG_LEVEL_INFO, name, contexts, filterItems( items ).join( ", " ) );
			
			return this;
		}
		
		public function debug( ...items ):DebugHelper
		{
			internalLog( DEBUG_LEVEL_DEBUG, name, contexts, filterItems( items ).join( ", " ) );
			
			return this;
		}
		
		public function warn( ...items ):DebugHelper
		{
			internalLog( DEBUG_LEVEL_WARN, name, contexts, filterItems( items ).join( ", " ) );
			
			return this;
		}
		
		public function error( ...items ):DebugHelper
		{
			internalLog( DEBUG_LEVEL_ERROR, name, contexts, items.join( ", " ) );
			
			return this;
		}		
		
		private static function filterItems( items:Array ):Array
		{
			function remove( item:*, index:int, arr:Array ):Boolean {
				return !( item is Function || item is flash.events.Event || item is starling.events.Event || item is ErrorMessage || item is ByteArray );
			}
			
			return items.filter(remove);
		}
		
		private static function internalLog( level:String, name:String, contexts:Array, item:*, ignoreEmpty:Boolean = true ):void
		{
			// Check for empty item
			if( item == null || ( item is String && item == "" ) )
			{
				if( ignoreEmpty ){ return; }
			}
			
			// Create the log
			var dt:Date = new Date();
			var msg:String = "";
			msg += FormatHelper.padString( dt.hours.toString(), 2, "0", FormatHelper.PAD_DIRECTION_LEFT );
			msg += ":";
			msg += FormatHelper.padString( dt.minutes.toString(), 2, "0", FormatHelper.PAD_DIRECTION_LEFT );
			msg += ":";
			msg += FormatHelper.padString( dt.seconds.toString(), 2, "0", FormatHelper.PAD_DIRECTION_LEFT );
			msg += ".";
			msg += FormatHelper.padString( dt.milliseconds.toString(), 3, "0", FormatHelper.PAD_DIRECTION_LEFT );
			msg += " [" + level + "] " + name + "::" + contexts.join( " > " ) + ( contexts.length > 0 ? " > " : "" ) + item.toString();
			
			// Trace all errors
			trace( msg );
			
			// Only console.log messages if we're in debug mode
			if( ExternalInterface.available && isDebug )
			{
				try 
				{
					// Makes an ExternalInterface call to console.log if console exists
					// Otherwise it creates an anoynmous object with a function called log and calls that, to avoid errors
					ExternalInterface.call( "( console || { log: function(){ } } ).log", msg );
				}
				catch( e:Error )
				{
					
				}
			}
			
			// Save everything to a rolling log
			rollingLog.push( msg );
			if( rollingLog.length > ROLLING_LOG_LIMIT )
			{
				rollingLog.shift();
			}
		}
		
		public static function getErrorLog():String
		{
			return rollingLog.join("\n");
		}
	}
}