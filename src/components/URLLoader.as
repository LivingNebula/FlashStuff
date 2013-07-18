package components
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import interfaces.IDisposable;
	
	public class URLLoader extends flash.net.URLLoader implements IDisposable
	{
		private var eventListeners:Object = {};
		private var msAPILoad:Number = 0.0;
		private var msAPIOpen:Number = 0.0;
		private var msAPIComplete:Number = 0.0;
		private var apiResponseThreshold:Number = 0.0;
		private var request:URLRequest;
		private var attempts:int = 0;
		
		/**
		 * The URL Request for this URL Loader.
		 */
		public function get Request():URLRequest
		{
			return request;
		}
		
		/**
		 * The amount of time the URL loader took to receive the first response from the server.
		 */
		public function get OpenTime():Number
		{
			return msAPIOpen - msAPILoad;
		}
		
		/**
		 * The amount of time the URL loader took to complete the response from the server.
		 */
		public function get ResponseTime():Number
		{
			return msAPIComplete - msAPILoad;
		}	
		
		/**
		 * How many times load has been called on this particular URLLoader instance
		 */
		public function get Attempts():int
		{
			return attempts;
		}
		
		public function URLLoader( request:URLRequest = null, apiResponseThreshold:Number = 0.0 )
		{			
			// Call the super constructor
			super( request );
			
			// Add internal event listeners to track response times
			addEventListener( Event.OPEN, onOpen, false, 99, false );
			addEventListener( Event.COMPLETE, onComplete, false, 99, false );
		}
		
		public override function load( request:URLRequest ):void
		{
			// Set the start time of the call
			msAPILoad = getTimer();
			
			// Update the attempts count
			attempts++;
			
			// Issue the load call to the super class
			this.request = request;
			super.load( request );
		}
		
		public override function addEventListener( type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false ):void
		{
			if( eventListeners[type] == null )
			{
				eventListeners[type] = [];
			}
			
			eventListeners[type].push( listener );
			super.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		// Handles the 'open' event of this URL Loader
		private function onOpen( event:Event ):void
		{
			msAPIOpen = getTimer();
		}
		
		// Handles the 'complete' event of this URL Loader
		private function onComplete( event:Event ):void 
		{
			msAPIComplete = getTimer();
		}
		
		private function removeAllEventListeners():void
		{
			for( var type:String in eventListeners )
			{
				var arr:Array = eventListeners[type] as Array;
				
				if( arr != null )
				{
					for( var i:int = 0; i < arr.length; i++ )
					{
						removeEventListener( type, arr[i] );
					}
				}
				
				eventListeners[type] = [];
			}
		}	
		
		public function dispose():void
		{
			removeAllEventListeners();
		}
	}
}