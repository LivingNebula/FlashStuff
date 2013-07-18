package services
{
	import components.URLLoader;
	import components.WebSocket;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import mx.utils.UIDUtil;
	
	import objects.ErrorMessage;
	import objects.PlayGameResponse;
	import objects.ProgressiveBalanceResponse;
	
	import utils.DebugHelper;
	import utils.MathHelper;
	
	public class SweepsAPI
	{
		public static const LIVE_DOMAIN:String 	   	  = "play.sweepstopia.com";
		public static const LIVE_SOCKET_DOMAIN:String = "api.sweepstopia.com";
		public static const DEV_DOMAIN:String 		  = "dev.mrsweepscafe.com";
		public static const DEV_SOCKET_DOMAIN:String  = "dev.mrsweepscafe.com";
		
		public static const API_ACCEPTABLE_THRESHOLD:int = 5000; // Report errors if calls to the API take longer than this (in ms)
		public static const API_ERROR_MAX_RETRIES:int 	 = 3;    // How many times to retry (including the initial try) on errors in the API
		
		public static const WEB_SOCKET_PORT:int    = 8888;
		public static const WEB_SOCKET_TIMEOUT:int = 10000;
		
		public static const ERROR_CODE_UNKNOWN:int 			    = 0;
		public static const ERROR_CODE_UNAUTHORIZED:int 		= 1;
		public static const ERROR_CODE_INSUFFICIENT_ENTRIES:int = 2;
		public static const ERROR_CODE_IO:int 				    = 3;
		public static const ERROR_CODE_SECURITY:int 			= 4;
		public static const ERROR_EXCEPTION:int				    = 5;
		public static const ERROR_DUPLICATE_CALLS:int			= 6;
		public static const ERROR_CODE_TIMEOUT:int				= 7;
		
		public static const SOPROGRESSIVE_ACTION_BALANCE:String    = "balance";
		public static const SOPROGRESSIVE_ACTION_CHECKWIN:String   = "check_win";
		
		// Logging
		private static const logger:DebugHelper = new DebugHelper( SweepsAPI );
		
		// Public Class Variables
		public static var callInProgress:Boolean = false;
		public static var progressiveBalanceDemo:int = MathHelper.randomNumber( 500, 5000 );
		public static var communityBalanceDemo:int = MathHelper.randomNumber( 500, 5000 );
		public static var communitySpinTriggered:Boolean = false;
		public static var debug:Boolean = false;
		public static var debug_w_api:Boolean = false;
		public static var release_version:String = "";
		public static var ws:WebSocket;
		public static var urlRequestID:int = 0;
		
		// Error throttling
		public static var errorsThreshold:uint = 10000; // Send at max 1 error every 10 seconds
		public static var lastErrorSent:uint = 0;       // When the last error was sent
		public static var errorsAte:int = 0;            // How many errors were not sent
		
		// Routing
		public static var routeTable:Object = {
			ticker: {
				add: []
			},
			api: {
				login: [],
				progressive_balance: [],
				balance: [],
				play: [],
				skill: [],
				redeem: [],
				achievements: []
			}
		};
		
		public static function addRouteListener( route:String, listener:Function ):void
		{
			// Log Activity
			logger.pushContext( "addRouteListener", arguments );
			
			var keys:Array = route.toLowerCase().split( "/" ).filter( function( r:String, i:int, arr:Array ):Boolean{ return r && r.length > 0; } );
			var routeKey:Object = routeTable;
			var key:String;
			
			// Check to see if we have a route in our table
			while( keys.length > 0 )
			{
				key = keys.shift();
				routeKey[key] = routeKey[key] || ( keys.length > 0 ? {} : [] );
				routeKey = routeKey[key];
			}
			
			// Add route listener
			if( routeKey != null && routeKey is Array )
			{
				routeKey.push( listener );
			}
			
			// Clear Context
			logger.popContext();
		}
		
		public static function removeRouteListener( route:String, listener:Function ):void
		{
			// Log Activity
			logger.pushContext( "removeRouteListener", arguments );
			
			// Determine the routing key
			var handled:Boolean = false;
			var keys:Array = route.toLowerCase().split( "/" ).filter( function( r:String, i:int, arr:Array ):Boolean{ return r && r.length > 0; } );
			var routeKey:Object = routeTable;
			
			// Check to see if we have a route in our table
			while( keys.length > 0 )
			{
				routeKey = routeKey[ keys.shift() ];
				if( !routeKey )
				{
					logger.warn( "Unrecognized routing key!" );
					break;
				}
			}
			
			// Execute all route listeners
			if( routeKey != null && routeKey is Array )
			{
				routeKey.splice( routeKey.indexOf( listener ), 1 );
			}
			
			// Clear Context
			logger.popContext();		
		}
		
		public static function BaseDomain():String
		{
			if( debug )
			{
				return DEV_DOMAIN;
			}
			else
			{
				return LIVE_DOMAIN;
			}
		}
		
		public static function SocketDomain():String
		{
			if( debug )
			{
				return DEV_SOCKET_DOMAIN;
			}
			else
			{
				return LIVE_SOCKET_DOMAIN;
			}
		}
		
		public static function establishSocketConnection():void
		{
			// Log Activity
			logger.pushContext( "establishSocketConnection", arguments );
			// Create the websocket if it doesn't exist
			if( ws == null )
			{
				ws = new WebSocket( "wss://" + SocketDomain() + ":" +  WEB_SOCKET_PORT + "/api", "htp://" + BaseDomain(), null, 10000  );
			}
			
			// Connect the websocket
			ws.connect();
			
			// Clear Context
			logger.popContext();			
		}
		
		public static function login( username:String, password:String, onSuccess:Function, onError:Function ):void
		{
			// Log Activity
			logger.pushContext( "login", arguments );
			if( callInProgress )
			{
				logger.error( "Duplicate calls." );
				onError( SweepsAPI.ERROR_DUPLICATE_CALLS, "Duplicate calls." );
				
				// Clear Context
				logger.popContext();				
				return;
			}
			
			callInProgress = true;
			
			if( debug )
			{
				if( !debug_w_api )
				{
					callInProgress = false;
					onSuccess( true, "" );
					
					// Clear Context
					logger.popContext();
					return;
				}
			}
			
			// Create the request variables
			var variables:URLVariables = new URLVariables();
			variables.Username = username;
			variables.Password = password;
			
			// Send the request over the socket if available
			if( ws != null && ws.connected )
			{
				ws.resetClientID();
				wsRequest( "login", variables, onSuccess, onError );
			}
			else
			{
				urlRequest( "login", variables, onSuccess, onError );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		public static function getSOProgressiveBalance( username:String, password:String, action:String, onSuccess:Function, onError:Function ):void
		{
			// Log Activity
			logger.pushContext( "getSOProgressiveBalance", arguments );
			if( callInProgress )
			{
				logger.error( "Duplicate calls." );
				onError( SweepsAPI.ERROR_DUPLICATE_CALLS, "Duplicate calls." );
				
				// Clear Context
				logger.popContext();				
				return;
			}
			
			callInProgress = true;
			
			if( debug )
			{
				if( !debug_w_api )
				{
					callInProgress = false;
					
					// Create a mock object for our JSON response
					var mockResponse:Object = new Object();
					
					// Pass our marquee settings
					mockResponse.MarqueeSettings = new Object();
					mockResponse.MarqueeSettings.Version = "";
					
					// Pass our current progressive balance
					mockResponse.ProgressiveBalance = new Object();
					mockResponse.ProgressiveBalance.balance = progressiveBalanceDemo;
					
					// Pass our current community balance
					mockResponse.CommunityBalance = new Object();
					mockResponse.CommunityBalance.balance = communityBalanceDemo;
					mockResponse.CommunityBalance.Win = false;
					
					// Randomly produce some fireworks
					mockResponse.Fireworks = MathHelper.randomNumber( 1, 5 );
					
					// Randomly produce a progressive jackpot winner
					if( MathHelper.randomNumber( 0, 100 ) > 50 && progressiveBalanceDemo > 0 )
					{
						mockResponse.ProgressiveWin = new Object();
						mockResponse.ProgressiveWin.Username = "John Doe";
						mockResponse.ProgressiveWin.Amount = progressiveBalanceDemo;
					}
					
					// Randomly produce a community jackpot spin
					if( ( MathHelper.randomNumber( 0, 100 ) > 50 && communityBalanceDemo > 0 ) || communitySpinTriggered )
					{
						mockResponse.CommunityBalance.Countdown = true;
						
						// Pass down the countdown trigger and log when it started
						if( !communitySpinTriggered )
						{
							communitySpinTriggered = true;
						}
						
						// If our action is to check our win, pass down our results and reset
						if( action == SOPROGRESSIVE_ACTION_CHECKWIN )
						{
							mockResponse.CommunityBalance.Win = MathHelper.randomNumber( 0, 1 ) == 1;
							
							if( mockResponse.CommunityBalance.Win == true )
							{
								mockResponse.CommunityBalance.customer_count = MathHelper.randomNumber( 1, 10 );
								mockResponse.CommunityBalance.customer_win = Math.floor( mockResponse.CommunityBalance.balance / mockResponse.CommunityBalance.customer_count );
							}
							
							communitySpinTriggered = false;
						}
					}
					
					// Return the results
					onSuccess( new ProgressiveBalanceResponse( mockResponse ) );
					
					// Clear Context
					logger.popContext();					
					return;
				}
			}
			
			// Create the request variables
			var variables:URLVariables = new URLVariables();
			variables.Username = username;
			variables.Password = password;
			variables.Action = action;
			
			// Send the request over the socket if available
			if( ws != null && ws.connected )
			{
				wsRequest( "progressive_balance", variables, onSuccess, onError );
			}
			else
			{
				urlRequest( "progressive_balance", variables, onSuccess, onError );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		public static function getBalance( username:String, password:String, onSuccess:Function, onError:Function ):void
		{
			// Log Activity
			logger.pushContext( "getBalance", arguments );
			if( callInProgress )
			{
				logger.error( "Duplicate calls." );
				onError( SweepsAPI.ERROR_DUPLICATE_CALLS, "Duplicate calls." );
				
				// Clear Context
				logger.popContext();				
				return;
			}
			
			callInProgress = true;
			
			if( debug )
			{
				if( !debug_w_api )
				{
					callInProgress = false;
					onSuccess( 10000, 0.0, progressiveBalanceDemo );
					
					// Clear Context
					logger.popContext();					
					return;
				}
			}
			
			// Create the request variables
			var variables:URLVariables = new URLVariables();
			variables.Username = username;
			variables.Password = password;
			
			// Send the request over the socket if available
			if( ws != null && ws.connected )
			{
				wsRequest( "balance", variables, onSuccess, onError );
			}
			else
			{
				urlRequest( "balance", variables, onSuccess, onError );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		public static function playGame( username:String, password:String, gameID:int, gameType:int, betAmount:int, betCount:int, skillSurcharge:int, onSuccess:Function, onError:Function ):void
		{
			// Log Activity
			logger.pushContext( "playGame", arguments );
			if( callInProgress )
			{
				logger.error( "Duplicate calls." );
				onError( SweepsAPI.ERROR_DUPLICATE_CALLS, "Duplicate calls." );
				
				// Clear Context
				logger.popContext();				
				return;
			}
			
			callInProgress = true;
			
			if( debug )
			{
				if( !debug_w_api )
				{
					callInProgress = false;
					onError( SweepsAPI.ERROR_CODE_UNKNOWN, "Cannot call SweepsAPI.playGame function in current DEBUG mode" );
					
					// Clear Context
					logger.popContext();					
					return;
				}
			}
			
			// Create the request variables
			var variables:URLVariables = new URLVariables();
			variables.Username = username;
			variables.Password = password;
			variables.GameID = gameID;
			variables.GameType = gameType;
			variables.BetAmount = betAmount;
			variables.BetCount = betCount;
			variables.SkillBased = skillSurcharge;
			
			// Send the request over the socket if available
			if( ws != null && ws.connected )
			{
				wsRequest( "play", variables, onSuccess, onError );
			}
			else
			{
				urlRequest( "play", variables, onSuccess, onError );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		public static function submitBadChoice( username:String, password:String, wasTimeout:Boolean, currentEntries:int, currentWinnings:int, onSuccess:Function, onError:Function ):void
		{
			// Log Activity
			logger.pushContext( "submitBadChoice", arguments );
			if( callInProgress )
			{
				logger.error( "Duplicate calls." );
				onError( SweepsAPI.ERROR_DUPLICATE_CALLS, "Duplicate calls." );
				
				// Clear Context
				logger.popContext();				
				return;
			}
			
			callInProgress = true;
			
			if( debug )
			{
				if( !debug_w_api )
				{
					callInProgress = false;
					onSuccess( currentEntries, currentWinnings );
					
					// Clear Context
					logger.popContext();					
					return;
				}
			}
			
			// Create the request variables
			var variables:URLVariables = new URLVariables();
			variables.Username = username;
			variables.Password = password;
			variables.TimeOut = wasTimeout ? 1 : 0;
			
			// Send the request over the socket if available
			if( ws != null && ws.connected )
			{
				wsRequest( "skill", variables, onSuccess, onError );
			}
			else
			{
				urlRequest( "skill", variables, onSuccess, onError );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		public static function redeemEntries( username:String, password:String, entries:int, winnings:int, redeemAmount:int, onSuccess:Function, onError:Function ):void
		{
			// Log Activity
			logger.pushContext( "redeemEntries", arguments );
			if( callInProgress )
			{
				logger.error( "Duplicate calls." );
				onError( SweepsAPI.ERROR_DUPLICATE_CALLS, "Duplicate calls." );
				
				// Clear Context
				logger.popContext();				
				return;
			}
			
			callInProgress = true;
			
			if( debug )
			{
				if( !debug_w_api )
				{
					callInProgress = false;
					onSuccess( entries + redeemAmount, winnings - redeemAmount );
					
					// Clear Context
					logger.popContext();					
					return;
				}
			}
			
			// Create the request variables
			var variables:URLVariables = new URLVariables();
			variables.Username = username;
			variables.Password = password;
			variables.RedeemAmount = redeemAmount;
			
			// Send the request over the socket if available
			if( ws != null && ws.connected )
			{
				wsRequest( "redeem", variables, onSuccess, onError );
			}
			else
			{
				urlRequest( "redeem", variables, onSuccess, onError );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		public static function getAchievements( username:String, password:String, onSuccess:Function, onError:Function ):void
		{
			// Log Activity
			logger.pushContext( "getAchievements", arguments );
			if( callInProgress )
			{
				logger.error( "Duplicate calls." );
				onError( SweepsAPI.ERROR_DUPLICATE_CALLS, "Duplicate calls." );
				
				// Clear Context
				logger.popContext();				
				return;
			}
			
			callInProgress = true;
			
			if( debug )
			{
				if( !debug_w_api )
				{
					callInProgress = false;
					onSuccess( [ "Bronze", 
								 "Silver", 
								 "Gold",		
								 "Platinum",
								 "AroundTheWorld",
								 "FF10",
								 "FF20",
								 "FF30",
								 "Expert",
								 "Super7",
								 "BonusBuster"
							] );

					// Clear Context
					logger.popContext();					
					return;
				}
			}
			
			// Create the request variables
			var variables:URLVariables = new URLVariables();
			variables.Username = username;
			variables.Password = password;
			
			// Send the request over the socket if available
			if( ws != null && ws.connected )
			{
				wsRequest( "achievements", variables, onSuccess, onError );
			}
			else
			{
				urlRequest( "achievements", variables, onSuccess, onError );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		public static function parseIncomingRequest( request:Object ):Boolean
		{	
			// Log Activity
			logger.pushContext( "parseIncomingRequest", arguments );
			
			// Determine the routing key
			var handled:Boolean = false;
			var keys:Array = request["routing-key"].toLowerCase().split( "/" ).filter( function( r:String, i:int, arr:Array ):Boolean{ return r && r.length > 0; } );
			var routeKey:Object = routeTable;
			
			// Check to see if we have a route in our table
			while( keys.length > 0 )
			{
				routeKey = routeKey[ keys.shift() ];
				if( !routeKey )
				{
					logger.error( "Unrecognized routing key!" );
					
					var errMsg:ErrorMessage = new ErrorMessage( "SweepsAPI:Unrecognized routing key.", "", "", "" );
					for( var key:Object in request )
					{
						errMsg.append( "REQUEST INFO", request[key] );
					}
					reportError( errMsg, true );
					break;
				}
			}
			
			// Execute all route listeners
			if( routeKey != null && routeKey is Array )
			{
				routeKey.forEach( function( f:Function, i:int, a:Array ):void {
					f( request.data );
				});
				
				handled = true;
			}
			
			// Clear Context
			logger.popContext();			
			return handled;
		}
		
		public static function reportError( errorMessage:ErrorMessage, isSevere:Boolean = true ):void
		{
			// Log Activity
			logger.pushContext( "reportError", arguments );
			if( debug )
			{
				if( !debug_w_api )
				{
					// Clear Context
					logger.popContext();					
					return;
				}
			}
			
			// Throttle errors
			if( flash.utils.getTimer() - lastErrorSent < errorsThreshold && flash.utils.getTimer() > errorsThreshold )
			{
				errorsAte++;
				
				// Clear Context
				logger.popContext();
				return;
			}
			
			// Create the request variables
			var dt:Date = new Date();
			var variables:URLVariables = new URLVariables();
			
			// Augment the error message
			errorMessage.append( "THROTTLING INFO", "Unsent Throttled Errors: " + errorsAte );
			errorMessage.append( "DEBUG LOG", DebugHelper.getErrorLog() );
			errorMessage.append( "SYSTEM INFO", "Time: " + dt.hours + ":" + dt.minutes + ":" + dt.seconds + "." + dt.milliseconds );
			errorMessage.append( "SYSTEM INFO", "Flash: v." + flash.system.Capabilities.version );
			errorMessage.append( "SYSTEM INFO", "Sweeps: v." + release_version );
			errorMessage.append( "API INFO", "WebSocket: " + ( !ws ? "null" : ws.getDebugInfo() ) );
			
			// Set the request variables
			variables.Message = errorMessage.toString();
			variables.isSevere = isSevere ? "1" : "0";
			
			errorsAte = 0;
			lastErrorSent = flash.utils.getTimer();
			urlRequest( "error", variables, null, null );
			
			// Clear Context
			logger.popContext();			
		}		
		
		private static function wsRequest( apiMethodCalled:String, variables:Object, onSuccessCallback:Function, onErrorCallback:Function ):void
		{
			logger.pushContext( "wsRequest", [apiMethodCalled] );
			
			var data:Object = {};
			var parts:Array = variables.toString().split("&");
			for( var i:int = 0; i < parts.length; i++ )
			{
				var keyVal:Array = parts[i].split("=");
				if(keyVal.length == 2)
				{
					data[keyVal[0]] = keyVal[1];
				}
			}
			
			ws.sendWithCallback
				( 
					apiMethodCalled,
					data,
					onSocketSuccess( apiMethodCalled, variables, onSuccessCallback, onErrorCallback)
				);
			
			callInProgress = false;
			
			// Clear Context
			logger.popContext();			
		}
		
		private static function onSocketSuccess( apiMethodCalled:String, variables:Object, onSuccessCallback:Function, onErrorCallback:Function ):Function 
		{
			// We're returning a function to create a closure,
			// so that the returned function has access to the variables apiMethodCalled, variables, etc
			
			return function( responseTime:int, data:String ):void
			{
				// Log Activity
				logger.pushContext( "onSocketSuccess", arguments );
				
				var errMsg:ErrorMessage;
				
				// Clear our call in progress
				callInProgress = false;
				
				// Try to parse the response as JSON
				try
				{
					var container:Object = ( JSON.parse( data ) as Object );
				}
				catch( error:Error )
				{
					errMsg = new ErrorMessage("SweepsAPI:Error parsing JSON response.", "", "", "" );
					errMsg.append( "REQUEST INFO", "API Method: " + "/api/" + apiMethodCalled );
					errMsg.append( "REQUEST INFO", "Parameters: " + variables.toString() );
					errMsg.append( "REQUEST INFO", "JSON: " + data );
					
					reportError( errMsg );
					onErrorCallback( SweepsAPI.ERROR_EXCEPTION, "Exception Error" );
					
					// Clear Context
					logger.popContext();					
					return;
				}
				
				// Send an error if we've exceed our timeout threshold - but not on timeout errors as that would be redundant
				if( responseTime > SweepsAPI.API_ACCEPTABLE_THRESHOLD && ( !container.hasOwnProperty( "ErrorCode" ) || container.ErrorCode != SweepsAPI.ERROR_CODE_TIMEOUT ) )
				{
					reportAPIThresholdError( "/" + apiMethodCalled, "WEB", variables, responseTime, responseTime );
				}
								
				
				// Checks for a valid response
				if( !container.hasOwnProperty( "ErrorCode" ) )
				{
					switch( apiMethodCalled )
					{
						case "login":
							onSuccessCallback( container.Valid, container.Message );
							break;
						
						case "balance":
							onSuccessCallback( container.Entries, container.Winnings, container.ProgressiveBalance != null ? container.ProgressiveBalance.balance : -1 );
							break;
						
						case "redeem":
							onSuccessCallback( container.Entries, container.Winnings );
							break;
						
						case "play":
							onSuccessCallback( new PlayGameResponse( container ) );
							break;
						
						case "achievements":
							onSuccessCallback( container.Achievements );
							break;
						
						case "progressive_balance":
							onSuccessCallback( new ProgressiveBalanceResponse( container ) );
							break;
						
						case "skill":
							onSuccessCallback( container.Entries, container.Winnings );
							break;
						
						case "error":
							// Do Nothing
							break;
					}
				} 
				else 
				{
					
					// Handle reporting the error
					if( apiMethodCalled != "error" )
					{
						var isSevere:Boolean = true;
						switch( container.ErrorCode ) 
						{
							case ERROR_CODE_UNAUTHORIZED:
							case ERROR_CODE_INSUFFICIENT_ENTRIES:
								isSevere = false;
								break;
						}
						
						// If this is a socket timeout error, resend over the URL Request
						if( !callInProgress && container.ErrorCode == SweepsAPI.ERROR_CODE_TIMEOUT )
						{
							logger.error( "Response timeout, falling back to URLRequest" );
							reportError( new ErrorMessage( "SweepsAPI:wsRequest > Response timeout, falling back to URLRequest", "", "", "" ), false );
							
							urlRequest( apiMethodCalled, variables, onSuccessCallback, onErrorCallback );
						}
						else
						{
							errMsg = new ErrorMessage( "SweepsAPI:General Error.", "", "", data );
							errMsg.append( "REQUEST INFO", "API Method: " + "/api/" + apiMethodCalled );
							errMsg.append( "REQUEST INFO", "Parameters: " + variables.toString() );
							errMsg.append( "REQUEST INFO", "JSON: " + data );
							
							reportError( errMsg, isSevere );
							if( onErrorCallback != null )
							{
								onErrorCallback( container.ErrorCode, container.Error );
							}
						}
					}
					else
					{
						if( onErrorCallback != null )
						{
							onErrorCallback( container.ErrorCode, container.Error );
						}
					}
				}
				
				// Clear Context
				logger.popContext();				
			};
		}
		
		private static function urlRequest( apiMethod:String, variables:Object, onSuccess:Function, onError:Function ):void
		{
			// Append a request id to the variables object
			variables.urlRequestID = ++urlRequestID;
			
			// Log Activity
			logger.pushContext( "urlRequest", [apiMethod, variables.urlRequestID] );
			
			// Create the request
			var request:URLRequest = new URLRequest();
			request.url = "http://" + BaseDomain() + "/api/" + apiMethod + "/";
			request.method = URLRequestMethod.POST;
			request.data = variables;
			
			// Create the request loader & listeners
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );
			loader.addEventListener( IOErrorEvent.IO_ERROR, getIOErrorHandler( onError ) );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, getSecurityErrorHandler( onError ) );
			loader.addEventListener( Event.COMPLETE, getCompleteHandler( apiMethod, onSuccess, onError ) );
			loader.load( request );
			
			// Clear Context
			logger.popContext();			
		}
		
		private static function httpStatusHandler( event:HTTPStatusEvent ):void
		{
			var loader:URLLoader = event.target as URLLoader;
			var request:URLRequest = loader.Request;
			var variables:URLVariables = request.data as URLVariables;
			
			if( event.status != 200 )
			{
				// Log the error
				logger.pushContext( "httpStatusHandler" ).error( "HTTP Status Code returned was not 200/OK > urlRequestID: " + variables.urlRequestID + ", URL: " + request.url + ", HTTP Status: " + event.status.toString() );
				
				// Clear Context
				logger.popContext();				
			}
		}
		
		private static function getIOErrorHandler( onErrorCallback:Function ):Function 
		{ 
			// We're returning a function to create a closure,
			// so that the returned function has access to the onErrorCallback
			
			return function( event:IOErrorEvent  ):void 
			{
				// Log Activity
				logger.pushContext( "getIOErrorHandler", arguments );
				
				var loader:URLLoader = event.target as URLLoader;
				var request:URLRequest = loader.Request;
				var variables:URLVariables = request.data as URLVariables;
				var errMsg:ErrorMessage;
				
				// Log the error
				logger.error( "IO Error > urlRequestID: " + variables.urlRequestID + ", URL: " + request.url + ", Attemptst: " + loader.Attempts + " Error: " + event.text );
				
				// Don't report errors on error reports
				if( request.url.indexOf( "api/error" ) == - 1 )
				{
					errMsg = new ErrorMessage("SweepsAPI:IO Error", "", event.text, "" );
					errMsg.append( "REQUEST INFO", "urlRequestID: " + variables.urlRequestID );
					errMsg.append( "REQUEST INFO", "URL: " + request.url );
					errMsg.append( "REQUEST INFO", "Parameters: " + variables.toString() );
					errMsg.append( "REQUEST INFO", "ATTEMPTS: " + loader.Attempts );					
					reportError( errMsg, false );
				}
				
				// Reload the URLRequest if we haven't reached our attempt limit and the URLRequest wasn't for an error
				if( loader.Attempts < SweepsAPI.API_ERROR_MAX_RETRIES && request.url.indexOf( "api/error" ) == -1 )
				{
					loader.load( request );
				}
				else // Call the error callback
				{
					callInProgress = false;
					if( onErrorCallback != null )
					{
						onErrorCallback( SweepsAPI.ERROR_CODE_IO, "IO Error." );
					}
					loader.dispose();
				}
				
				// Clear Context
				logger.popContext();				
			};
		}
		
		private static function getSecurityErrorHandler( onErrorCallback:Function ):Function
		{ 
			// We're returning a function to create a closure,
			// so that the returned function has access to the onErrorCallback
			
			return function( event:SecurityErrorEvent ):void 
			{
				// Log Activty
				logger.pushContext( "getSecurityErrorHandler", arguments );
				
				var loader:URLLoader = event.target as URLLoader;
				var request:URLRequest = loader.Request;
				var variables:URLVariables = request.data as URLVariables;
				var errMsg:ErrorMessage;
				
				// Log the error
				logger.error( "Security Error > urlRequestID: " + variables.urlRequestID + ", URL: " + request.url + ", Error: " + event.text );
				
				// Don't report errors on error reports
				if( request.url.indexOf( "api/error" ) == - 1 )
				{
					errMsg = new ErrorMessage("SweepsAPI:Security Error", "", event.text, "" );
					errMsg.append( "REQUEST INFO", "urlRequestID: " + variables.urlRequestID );
					errMsg.append( "REQUEST INFO", "URL: " + request.url );
					errMsg.append( "REQUEST INFO", "Parameters: " + variables.toString() );
					
					reportError( errMsg, false );
				}
				
				// Dont attempt a reload on a securty error, just call the error callback
				callInProgress = false;
				if( onErrorCallback != null )
				{
					onErrorCallback( SweepsAPI.ERROR_CODE_SECURITY, "Security Error." );
				}
				loader.dispose();
				
				// Clear Context
				logger.popContext();				
			};
		}
		
		private static function getCompleteHandler( apiMethodCalled:String, onSuccessCallback:Function, onErrorCallback:Function ):Function 
		{
			// We're returning a function to create a closure,
			// so that the returned function has access to the variables apiMethodCalled, onSuccessCallback, etc
			return function( event:Event ):void 
			{
				// Log Activity
				logger.pushContext( "getCompletedHandler", arguments );
				
				var loader:URLLoader = event.target as URLLoader;
				var request:URLRequest = loader.Request;
				var variables:URLVariables = request.data as URLVariables;
				var errMsg:ErrorMessage;
				
				// Send an error if we've exceed our threshold and the request wasn't already an error report
				if( loader.ResponseTime > SweepsAPI.API_ACCEPTABLE_THRESHOLD && request.url.indexOf( "api/error" ) == -1 )
				{
					reportAPIThresholdError( "/" + apiMethodCalled, "URL", loader.Request.data, loader.ResponseTime, loader.OpenTime );
				}
				
				// Capture the response and make sure we're set for the next API call
				var response:String = event.target.data as String;
				callInProgress = false;
				loader.dispose();
				
				// Try to parse the response as JSON
				try
				{
					var container:Object = ( JSON.parse( response ) as Object );
				}
				catch( error:Error )
				{
					errMsg = new ErrorMessage("SweepsAPI:Error parsing JSON response.", "", "", "" );
					errMsg.append( "REQUEST INFO", "URL: " + request.url );
					errMsg.append( "REQUEST INFO", "Parameters: " + variables.toString() );
					errMsg.append( "REQUEST INFO", "JSON: " + response );
					
					reportError( errMsg );
					if( onErrorCallback != null )
					{
						onErrorCallback( SweepsAPI.ERROR_EXCEPTION, "Exception Error" );
					}
					
					// Clear Context
					logger.popContext();					
					return;
				}
				
				// Check for a valid response
				if( !container.hasOwnProperty( "ErrorCode" ) )
				{
					switch( apiMethodCalled )
					{
						case "login":
							onSuccessCallback( container.Valid, container.Message );
							break;
						
						case "balance":
							onSuccessCallback( container.Entries, container.Winnings, container.ProgressiveBalance != null ? container.ProgressiveBalance.balance : -1 );
							break;
						
						case "redeem":
							onSuccessCallback( container.Entries, container.Winnings );
							break;
						
						case "play":
							onSuccessCallback( new PlayGameResponse( container ) );
							break;
						
						case "achievements":
							onSuccessCallback( container.Achievements );
							break;
						
						case "progressive_balance":
							onSuccessCallback( new ProgressiveBalanceResponse( container ) );
							break;
						
						case "skill":
							onSuccessCallback( container.Entries, container.Winnings );
							break;
						
						case "error":
							// Do Nothing
							break;
					}
				} 
				else 
				{
					
					// Handle reporting the error
					if( apiMethodCalled != "error" )
					{
						var isSevere:Boolean = true;
						switch( container.ErrorCode ) 
						{
							case ERROR_CODE_UNAUTHORIZED:
							case ERROR_CODE_INSUFFICIENT_ENTRIES:
								isSevere = false;
								break;
						}
						
						errMsg = new ErrorMessage( "SweepsAPI:General Error.", "", "", response );
						errMsg.append( "REQUEST INFO", "URL: " + request.url );
						errMsg.append( "REQUEST INFO", "Parameters: " + variables.toString() );
						errMsg.append( "REQUEST INFO", "JSON: " + response );
						
						reportError( errMsg, isSevere );
						if( onErrorCallback != null )
						{
							onErrorCallback( container.ErrorCode, container.Error );
						}
					}
					else
					{
						if( onErrorCallback != null )
						{
							onErrorCallback( container.ErrorCode, container.Error );
						}
					}
				}
				
				// Clear Context
				logger.popContext();				
			};
		}
		
		private static function reportAPIThresholdError( apiMethod:String, apiType:String, data:Object, responseTime:Number, openTime:Number ):void
		{
			// Log Activity
			logger.pushContext( "reportAPIThresholdError", arguments );
			var errMsg:ErrorMessage = new ErrorMessage( "SweepsAPI:A call took longer than expected.", "", "", "" );
			errMsg.append( "CALL INFO", "Call Type: " + apiType );
			errMsg.append( "CALL INFO", "API Method:" + apiMethod );
			errMsg.append( "CALL INFO", "Time to open: " + openTime.toString() );
			errMsg.append( "CALL INFO", "Time to complete: " + responseTime.toString() );
			for( var key:String in data )
			{
				errMsg.append( "CALL INFO", key + ": " + data[key].toString() );
			}
			
			reportError( errMsg, false );
			
			// Clear Context
			logger.popContext();			
		}
	}
}