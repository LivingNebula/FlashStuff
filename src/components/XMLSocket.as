package components
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import interfaces.IDisposable;
	
	import utils.DebugHelper;
	
	public class XMLSocket extends flash.net.XMLSocket implements IDisposable
	{
		private var eventListeners:Object = {};
		
		private var msAPILoad:Number = 0.0;
		private var msAPIComplete:Number = 0.0;
		private var xmlTimeoutRef:uint = uint.MIN_VALUE;
		
		private var queue:Array = [];
		private var currentRequest:Object;
		private var isWaiting:Boolean = false;
		
		private var curConnectRetries:int = 0;
		private var maxConnectRetries:int = 0;
		
		private var host:String;
		private var port:int;
		
		/**
		 * The amount of time the XML socket took to complete the response from the server.
		 */
		public function get ResponseTime():Number
		{
			return msAPIComplete - msAPILoad;
		}
		
		public function XMLSocket( maxConnectRetries:int )
		{
			this.maxConnectRetries = maxConnectRetries;
			
			super();
			timeout = 20000; // 20 seconds, as the game will log itself out after 15 minutes
			
			addEventListener( DataEvent.DATA, onData, false, 99 );			
			addEventListener( IOErrorEvent.IO_ERROR, ioError, false, 99 );			
			addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 99 );			
			addEventListener( Event.CLOSE, onClose, false, 99 );			
			addEventListener( Event.CONNECT, onConnect, false, 99 );
		}
		
		private function onData( event:DataEvent ):void 
		{
			logger.debug("onData > " + event.toString() );
			
			msAPIComplete = getTimer();
			
			currentRequest.onSuccess( event.data );
			currentRequest = null;
			isWaiting = false;
			
			sendQueue();
		}
		
		private function ioError( event:IOErrorEvent ):void 
		{
			logger.error("ioError > " + event.toString() );
			
			// If we have a current request, immediately call it's onIOError handled
			if( currentRequest != null )
			{
				currentRequest.onIOError( event );
			}
			
			// Attempt to reconnect
			errorReconnect();			
		}
		
		private function onSecurityError( event:SecurityErrorEvent ):void 
		{	
			// Security errors should only happen after a failure to connect, ignore them as we'll have the IOError too
			logger.error("onSecurityError > " + event.toString() );				
		}
		
		private function onClose( event:Event ):void 
		{
			logger.debug("onClose > " + event.toString() );
			
			// If we have a current request, immediately call it's onIOError handled
			if( currentRequest != null )
			{
				currentRequest.onIOError( event );
			}
			
			// Attempt to reconnect
			errorReconnect();				
		}
		
		private function onConnect( event:Event ):void 
		{
			logger.info("onConnect -> Connection established." );
			sendQueue();
		}
		
		public override function connect( host:String, port:int ):void
		{
			logger.info("connect > Attempting to establish connection." );
			
			// Clear any existing setTimeout calls
			if( xmlTimeoutRef > uint.MIN_VALUE )
			{
				clearTimeout( xmlTimeoutRef );
				xmlTimeoutRef = uint.MIN_VALUE;
			}
			
			// Store the host and port for reconnects
			this.host = host;
			this.port = port;
			
			// Call the underlying xmlSocket connect
			super.connect( host, port );
		}
		
		public function sendWithCallback( data:String, onSuccess:Function, onIOError:Function ):void 
		{
			// Set the start time of the call
			msAPILoad = getTimer();
			
			queue.splice( 0, 0, { data:data, onSuccess:onSuccess, onIOError:onIOError } );
			sendQueue();
		}
		
		private function sendQueue():void
		{
			if( !isWaiting && queue.length > 0 )
			{
				isWaiting = true;
				currentRequest = queue.pop();
				super.send( currentRequest.data );
			}
		}
		
		public function errorReconnect():void
		{
			logger.info("errorReconnect -> Closing connection (if needed) and attempting to reconnect after a delay." );
			
			// Clear our queue and requests
			isWaiting = false;
			queue = [];
			currentRequest = null;
			
			// Close the connection if it's connected
			if( connected )
			{
				super.close();
			}
			
			// Increment our retries and reconnect, if allowed
			if( curConnectRetries <= maxConnectRetries ) 
			{
				curConnectRetries++;
				xmlTimeoutRef = setTimeout( connect, curConnectRetries * 60000, host, port );
			}
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