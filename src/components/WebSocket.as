package components
{
	import com.worlize.websocket.WebSocket;
	import com.worlize.websocket.WebSocketErrorEvent;
	import com.worlize.websocket.WebSocketEvent;
	import com.worlize.websocket.WebSocketMessage;
	
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.system.Security;
	import flash.utils.*;
	
	import interfaces.IDebuggable;
	import interfaces.IDisposable;
	
	import mx.utils.UIDUtil;
	
	import objects.ErrorMessage;
	
	import services.SweepsAPI;
	
	import utils.DebugHelper;
	
	public class WebSocket implements IDisposable, IDebuggable
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( components.WebSocket );	
		
		private var uri:String;
		private var origin:String;
		private var protocols:*;
		private var timeout:uint;
		
		private var reconnectTimeout:uint;
		private var messageQueue:Object    = {};
		private var messageCounter:int     = 0;
		private var clientID:String;
		private var lastRequestID:String;
		private var reconnectCounter:int   = 0;
		private var pingTimer:Timer;
		private var pongTimeout:uint;
		private var socket:com.worlize.websocket.WebSocket;
		
		private static const PING_INTERVAL:int = 5; // How often we ping the socker server (seconds);
		private static const PONG_TIMEOUT:int = 4;  // How long we wait for a pong response (seconds);
		
		public function get connected():Boolean
		{
			return socket != null && socket.connected;
		}
		
		public function WebSocket( uri:String, origin:String, protocols:* = null, timeout:uint = 10000 )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );
			
			// Override Worlize WebSocket Logger
			com.worlize.websocket.WebSocket.logger = function( text:String ):void {
				logger.pushContext( "com.worlize.websocket.WebSocket" );
				logger.debug( text );
				logger.popContext();
			};
			
			this.uri = uri;
			this.origin = origin;
			this.protocols = protocols;
			this.timeout = timeout;
			
			// Create the initial clientID
			resetClientID();

			// Create the socket
			createSocket();
			
			// Clear Context
			logger.popContext();			
		}	
		
		public function resetClientID():void
		{
			clientID = mx.utils.UIDUtil.createUID();			
		}
		
		private function createSocket():void
		{
			// Log Activity
			logger.pushContext( "createSocket", arguments );			
			this.reconnectCounter += 1;
			
			socket = new com.worlize.websocket.WebSocket( uri, origin, protocols, timeout );
			socket.debug = true;
			socket.addEventListener( WebSocketEvent.OPEN, onConnect );
			socket.addEventListener( WebSocketEvent.MESSAGE, onMessage );
			socket.addEventListener( WebSocketEvent.CLOSED, onClose );
			socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			socket.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			socket.addEventListener( WebSocketErrorEvent.ABNORMAL_CLOSE, onError );
			socket.addEventListener( WebSocketErrorEvent.CONNECTION_FAIL, onError );
			socket.addEventListener( WebSocketEvent.PONG, onPong );
			
			// Clear Context
			logger.popContext();			
		}
		
		private function destroySocket():void
		{
			// Log Activity
			logger.pushContext( "destroySocket", arguments );
			if( socket )
			{
				// Remove active listeners
				socket.removeEventListener( WebSocketEvent.OPEN, onConnect );
				socket.removeEventListener( WebSocketEvent.MESSAGE, onMessage );
				socket.removeEventListener( WebSocketEvent.CLOSED, onClose );
				socket.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
				socket.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
				socket.removeEventListener( WebSocketErrorEvent.ABNORMAL_CLOSE, onError );
				socket.removeEventListener( WebSocketErrorEvent.CONNECTION_FAIL, onError );
				socket.removeEventListener( WebSocketEvent.PONG, onPong );
				
				// Add passive listeners
				socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onIgnoredError );
				socket.addEventListener( IOErrorEvent.IO_ERROR, onIgnoredError );
				socket.addEventListener( WebSocketErrorEvent.ABNORMAL_CLOSE, onIgnoredError );
				socket.addEventListener( WebSocketErrorEvent.CONNECTION_FAIL, onIgnoredError );
				
				// Turn off the sockets debug mode
				socket.debug = false;
				
				// Close the socket
				if( socket.connected )
				{
					socket.close( false );
				}
				
				socket = null;
			}
			
			// Clear Context
			logger.popContext();			
		}
				
		/**
		 * Handles any connect events.
		 */		
		private function onConnect( event:WebSocketEvent ):void 
		{
			// Log Activity
			logger.pushContext( "onConnect", arguments );
			
			// Send Queued Messages
			sendQueuedMessages();
			
			// Clear Context
			logger.popContext();			
		}			
		
		/**
		 * Handles any incoming messages by routing them to correct callback in the message queue.
		 */		
		private function onMessage( event:WebSocketEvent ):void 
		{
			// Log Activity
			logger.pushContext( "onMessage", arguments );
			if( event.message.type == WebSocketMessage.TYPE_UTF8 )
			{
				logger.debug( "Data: " + event.message.utf8Data );
				
				var container:Object = JSON.parse( event.message.utf8Data ) as Object;				
				if( container != null )
				{
					// If we have a request id, handle this as a response to an outgoing request
					if( container.hasOwnProperty( "request-id" ) )
					{
						if( container.hasOwnProperty( "data" ) )
						{
							var requestInfo:Object = messageQueue[container["request-id"]];
							if( requestInfo != null )
							{
								clearTimeout( requestInfo.requestTimeout );							
								requestInfo.callback( getTimer() - requestInfo.requestTime, JSON.stringify( container["data"] ) );
								delete messageQueue[container["request-id"]];
							}
							else
							{
								SweepsAPI.reportError( new ErrorMessage( "WebSocket:Request-id not found in message queue after receiving response.", "", "", "" ).append( "REQUEST INFO", "Request-id: " + container["request-id"] ) );
							}
						} 
						else
						{
							SweepsAPI.reportError( new ErrorMessage( "WebSocket:Parsed JSON response has key 'request-id', but not 'data'.", "", "", "" ).append( "RESPONSE INFO", "JSON: " + event.message.utf8Data ) );	
						}
					}
					
					// Attempt to handle all incoming messages
					if( !SweepsAPI.parseIncomingRequest( container ) )
					{
						SweepsAPI.reportError( new ErrorMessage( "WebSocket:Parsed JSON response has invalid routing-key.", "", "", "" ).append( "RESPONSE INFO", "JSON: " + event.message.utf8Data ) );
					}
				}
			}
			else
			{
				logger.debug( "Length: " + event.message.binaryData.length );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Handles any close events.
		 */		
		private function onClose( event:WebSocketEvent ):void 
		{
			// Log Activity
			logger.pushContext( "onClose", [event.message ? event.message : event.toString()] );
			
			// Attempt to reconnect
			errorReconnect();
			
			// Clear Context
			logger.popContext();			
		}			
		
		/**
		 * Handles any generic error events.
		 */		
		private function onError( event:WebSocketErrorEvent ):void 
		{
			// Log Activity
			logger.pushContext( "onError" ).error.apply( null, arguments );
			
			// Attempt to reconnect
			errorReconnect();
			
			// Clear Context
			logger.popContext();
		}
		
		/**
		 * Handles any onSecurityError events.
		 */
		private function onSecurityError( event:SecurityErrorEvent ):void
		{
			// Log Activity
			logger.pushContext( "onSecurityError" ).error.apply( null, arguments );
			
			// Attempt to reconnect
			errorReconnect();
			
			// Clear Context
			logger.popContext();
		}
		
		/**
		 * Handles any IOError events.
		 */
		private function onIOError( event:IOErrorEvent ):void 
		{
			// Log Activity
			logger.pushContext( "onIOError" ).error.apply( null, arguments );
			
			// Attempt to reconnect
			errorReconnect();
			
			// Clear Context
			logger.popContext();
		}
		
		/**
		 * Handles all errors from inactive sockets.
		 */
		private function onIgnoredError( event:ErrorEvent ):void
		{
			// Log Activity
			logger.pushContext( "onIgnoredError" );
			
			// Clear Context
			logger.popContext();
		}
		
		/**
		 *  Handles any pong events.
		 */
		private function onPong( event:WebSocketEvent ):void
		{
			if( pongTimeout != uint.MIN_VALUE )
			{
				clearTimeout( pongTimeout );
				pongTimeout = uint.MIN_VALUE;
			}
		}
		
		/**
		 * Handles a pong timeout.
		 */
		private function onPongTimeout():void
		{
			// Log Activity
			logger.pushContext( "onPongTimeout" );
			
			// Log the error
			logger.error( "Pong not received within " + PONG_TIMEOUT + " second(s) after Ping." );
			
			// Report the error
			SweepsAPI.reportError( new ErrorMessage( "WebSocket:Pong not received within " + PONG_TIMEOUT + " second(s) after Ping.", "", "", "" ) );
			
			if( pongTimeout != uint.MIN_VALUE )
			{
				clearTimeout( pongTimeout );
				pongTimeout = uint.MIN_VALUE;
			}
			
			errorReconnect();
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Handles the pingTimer onTimer events.
		 */ 
		private function pingTimer_onTimer( event:TimerEvent ):void
		{
			ping();
		}
		
		/**
		 * Sends a ping to the socket server and setups a timeout for the pong event.
		 */
		public function ping( payload:ByteArray = null ):void
		{
			socket.ping(payload);
			pongTimeout = setTimeout( onPongTimeout, PONG_TIMEOUT * 1000 );
		}
		
		/**
		 * Loads the security policy file and Connects the WebSocket.
		 */
		public function connect():void
		{
			// Log Activity
			logger.pushContext( "connect", arguments );
			logger.info( "Attempting to establish connection..." );
			
			// Clear any existing setTimeout calls
			if( reconnectTimeout > uint.MIN_VALUE )
			{
				clearTimeout( reconnectTimeout );
				reconnectTimeout = uint.MIN_VALUE;
			}
			
			// Force a security policy check
			Security.loadPolicyFile( "xmlsocket:// " + SweepsAPI.SocketDomain() + ":843" );			
			
			// Call the underlying WebSocket connect
			socket.connect();
			
			// Clear Context
			logger.popContext();			
		}	
		
		/**
		 * Sends a request over the WebSocket and places the request in a queue to waiting for a response.
		 * When the response is received, the callback function is executed with the response.
		 * 
		 * @param apiMethod The apiMethod being called.
		 * @param variables A list of key/value pairs to be sent to the api.
		 * @param callback The function to be executed once a response is received.
		 */
		public function sendWithCallback( apiMethod:String, variables:Object, callback:Function, websocketTimeout:int = SweepsAPI.WEB_SOCKET_TIMEOUT ):void
		{
			// Log Activity
			logger.pushContext( "sendWithCallback", [apiMethod, ( apiMethod == "error" ? "" : variables ), callback, websocketTimeout] );
			
			// Create the message object
			var message:Object = {};
			var requestID:String = getNextRequestID();;
			
			message["routing-key"] = "/api/" + apiMethod;
			message["client-id"] = clientID;
			message["request-id"] = requestID;
			message["data"] = variables;
			
			// Create a timeout to trigger this request's callback after 20 seconds
			var requestTimeout:uint = setTimeout( function(): void {
				if( messageQueue[requestID] )
				{
					errorReconnect( 20000 );
					callback( getTimer() - messageQueue[requestID].requestTime, "{ \"ErrorCode\": \"" + SweepsAPI.ERROR_CODE_TIMEOUT + "\", \"Error\": \"WebSocket:sendWithCallback > Timed out waiting for response.\" }" );
					delete messageQueue[requestID];
				}
				else 
				{
					logger.error( "setTimeout for requestID " + requestID + " was not cleared!" );
					SweepsAPI.reportError( new ErrorMessage( "WebSocket:setTimeout for requestID " + requestID + " was not cleared!", "", "", "" ), false );
				}
			}, websocketTimeout );
			
			// Store the message in the queue
			messageQueue[requestID] = { 
				requestTime: getTimer(),
				requestTimeout: requestTimeout,
				clientID: clientID,
				apiMethod: apiMethod,
				variables: variables,
				callback: callback
			};
			
			// Encode the object into a JSON string and send it
			logger.debug( "Sending request: " + requestID );
			socket.sendUTF( JSON.stringify( message ) );
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Returns the next valid request id based on the clientID, reconnect counter and message counter.
		 */
		private function getNextRequestID():String
		{
			lastRequestID = clientID + "-C" + reconnectCounter + "-M" + ( ++messageCounter ).toString();
			return lastRequestID;
		}
		
		/**
		 * Executes the callback function with an error for any queued messages, clears their timeouts and removes them from the queue.
		 */
		protected function purgeMesagesQueue():void
		{
			// Log Activity
			logger.pushContext( "purgeMesagesQueue", arguments );
			
			for( var requestID:String in messageQueue )
			{
				clearTimeout( messageQueue[requestID].requestTimeout );
				messageQueue[requestID].callback( getTimer() - messageQueue[requestID].requestTime, "{ \"ErrorCode\": \"" + SweepsAPI.ERROR_CODE_TIMEOUT + "\", \"Error\": \"WebSocket:sendWithCallback > Timed out waiting for response.\" }" );
				delete messageQueue[requestID];
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Resends and queued messages.
		 */
		protected function sendQueuedMessages():void
		{
			// Log Activity
			logger.pushContext( "sendQueuedMessages", arguments );
			
			// Get a list of all the old requests ids
			var oldRequestIDs:Array = [];
			for( var oldRequestID:String in messageQueue )
			{
				oldRequestIDs.push( oldRequestID );
			}
		
			// Loop over all queued messages
			for( var i:int = 0; i < oldRequestIDs.length; i++ )
			{
				// Get the old requestID
				var requestID:String = oldRequestIDs[i];
				
				// Resend the request
				logger.debug("sendQueuedMessages > Resending requestID " + requestID );				
				sendWithCallback( 
					messageQueue[requestID].apiMethod, 
					messageQueue[requestID].variables, 
					messageQueue[requestID].callback,
					SweepsAPI.WEB_SOCKET_TIMEOUT - ( getTimer() - messageQueue[requestID].requestTime )
				);
				
				// Clear the existing timeout and request
				clearTimeout( messageQueue[requestID].requestTimeout );
				delete messageQueue[requestID];
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Closes the connection if needed and attempts to reconnect after 20 seconds.
		 */
		protected function errorReconnect( reconnectDelay:int = 10 ):void
		{
			// Log Activity
			logger.pushContext( "errorReconnect", arguments );
			
			// Stop the ping timer and reset it
			if( pingTimer )
			{
				pingTimer.stop();
				pingTimer.reset();
			}
			
			// Clear the pong timeout if one exists
			if( pongTimeout != uint.MIN_VALUE )
			{
				clearTimeout( pongTimeout );
				pongTimeout = uint.MIN_VALUE;
			}
			
			// Check if we need to recreate the socket or of it's already in process
			if( reconnectTimeout == uint.MIN_VALUE )
			{				
				logger.info( "Recreating the socket and reconnecting after a delay." );
				
				// Close the connection if it's connected
				destroySocket();
				
				// Recreate the socket
				createSocket();
				
				// Reset the ClientID
				resetClientID();
				
				// Set a timeout to reconnect the socket
				reconnectTimeout = setTimeout( connect, reconnectDelay );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		public function getDebugInfo():String
		{
			var str:String = "";
			
			str += "ClientID: " + clientID + "\n";
			str += "Last Request ID: " + lastRequestID + "\n";
			str += "Connected: " + connected.toString() + "\n";
			
			return str;
		}
		
		/**
		 * Disposes of the WebSocket
		 */
		public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );
			// Stop any reconnect timeout
			if( reconnectTimeout != uint.MIN_VALUE )
			{
				clearTimeout( reconnectTimeout );
				reconnectTimeout = uint.MIN_VALUE;
			}
			
			// Close the connection if it's connected
			destroySocket();
			
			// Stop the ping timer and reset it
			if( pingTimer )
			{
				pingTimer.stop();
				pingTimer.removeEventListener( TimerEvent.TIMER, pingTimer_onTimer );
				pingTimer = null;
			}
			
			// Clear the pong timeout if one exists
			if( pongTimeout != uint.MIN_VALUE )
			{
				clearTimeout( pongTimeout );
				pongTimeout = uint.MIN_VALUE;
			}
			
			// Clear Context
			logger.popContext();			
		}
	}
}