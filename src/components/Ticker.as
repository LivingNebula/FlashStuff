package components
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import interfaces.IDisposable;
	
	import mx.core.UIComponent;
	
	import objects.ErrorMessage;
	
	import services.SweepsAPI;
	
	import utils.DebugHelper;
	
	public class Ticker extends UIComponent implements IDisposable
	{
		private static const logger:DebugHelper = new DebugHelper( Ticker );
		
		private var _rows:int = 8;
		private var _cols:int = 64;
		private var _color:uint = 0x00FF00;
		private var _ledDiameter:Number = 10;
		private var _currentMessageIndex:int = 0;
		private var _currentCol:int = 0;
		private var _matrix:Array;
		private var _timer:Timer;
		
		private var _messages:Array = ["Sweepstopia!"];
		
		public function Ticker( cols:int = 72, color:uint = 0x00FF00, ledDiameter:Number = 2 )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );
			
			super();
			
			_cols = cols;
			_color = color;
			_ledDiameter = ledDiameter;
			
			generateLeds();
			generateMatrix();
			renderMatrixToLed();
			turnOn();
			
			// Clear Context
			logger.popContext();
		}
		
		/**
		 * Adds a message to the ticker.
		 * 
		 * @param args An object container details about the message to add, primarily a 'message' key.
		 */
		public function add( args:Object ):void
		{
			// Log Activity
			logger.pushContext( "add", arguments );
			
			if( args.message ) 
			{
				_messages.push( args.message );
			}
			else
			{
				logger.error( "Key 'message' not found!" );
				
				var errMsg:ErrorMessage = new ErrorMessage( "Ticker:Key 'message' not found!", "", "", "" );
				for( var key:Object in args )
				{
					errMsg.append( "REQUEST INFO", args[key] );
				}
				SweepsAPI.reportError( errMsg, true );
			}
			
			// Clear Context
			logger.popContext();
		}
		
		/**
		 * Starts the ticker scrolling messages, optionally starting at the
		 * beginning of the message queue.
		 * 
		 * @param reset <code>true</code> to start over at the first message.
		 */
		public function turnOn( reset:Boolean = false ):void
		{
			// Log Activity
			logger.pushContext( "turnOn", arguments );
			
			if( reset )
			{
				_currentCol = 0;
				_currentMessageIndex = 0;
			}
			
			if( _timer == null )
			{
				_timer = new Timer( 50, 0 );
				_timer.addEventListener( TimerEvent.TIMER, onTimer );
				_timer.start();
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Stops the ticker scrolling messages, optionally clearing the display.
		 * 
		 * @param clear <code>true</code> to wipe the display.
		 */
		public function turnOff( clear:Boolean = false ):void
		{
			// Log Activity
			logger.pushContext( "turnOff", arguments );
			
			if( clear )
			{
				clearLeds();
			}
			
			if( _timer != null )
			{
				_timer.removeEventListener( TimerEvent.TIMER, onTimer );
				_timer.stop();
				_timer = null;
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Handles the 'timer' event of the <code>_timer</code> control.
		 */
		private function onTimer( event:TimerEvent ):void
		{
			if( ++_currentCol > _matrix[0].length )
			{
				_currentCol = 0;
				_currentMessageIndex = ( _currentMessageIndex + 1 ) % _messages.length;
				generateMatrix();
				renderMatrixToLed();
				return;	
			}
			
			for( var r:int = 0; r < _rows; r++ )
			{
				_matrix[r].push( _matrix[r].shift() );
			}
			
			renderMatrixToLed();
		}
		
		/**
		 * Creates the LEDs and positions them.
		 */
		private function generateLeds():void
		{
			// Log Activity
			logger.pushContext( "generateLeds", arguments );
				
			for( var i:int = 0; i < _rows * _cols; i++ )
			{
				var col:int = Math.floor( i % _cols );				
				var row:int = Math.floor( i / _cols );
				var x:Number = col * ( _ledDiameter * 1.5 );
				var y:Number = row * ( _ledDiameter * 1.5 );
				
				var led:TickerLED = new TickerLED( _color, _ledDiameter );
				led.x = x;
				led.y = y;
				addChild( led );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Generates an array matrix of 1s and 0s which represent the current message to be displaed.
		 */
		private function generateMatrix():void
		{
			// Log Activity
			logger.pushContext( "generateMatrix", arguments );
			
			_matrix = [];
			var i:int;
			var r:int;
			var c:int;
			var tempMatrix:Array;
			var message:String = _messages[_currentMessageIndex];
			
			// Create the rows and initial blank columns
			for( r = 0; r < _rows; r++ )
			{
				_matrix.push([]);
				for( c = 0; c < _cols; c++ )
				{
					_matrix[r].push( 0 );
				}
			}
			
			// Create all letters
			for( i = 0; i < message.length; i++ )
			{
				tempMatrix = letterToMatrix( message.charAt( i ) );
				for( r = 0; r < _rows; r++ )
				{
					_matrix[r].push.apply( null, tempMatrix[r].concat( 0 ) );
				}
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Rends the current message matrix to the LEDs.
		 */
		private function renderMatrixToLed():void
		{
			var r:int;
			var c:int;
			var led:TickerLED;
			
			for( r = 0; r < _rows; r++ )
			{
				for( c = 0; c < _cols; c++ )
				{
					led = getChildAt( r * _cols + c ) as TickerLED;
					led.toggle( c <= _matrix[r].length - 1 ? _matrix[r][c] == 1 : false );
				}
			}
		}
		
		/**
		 * Turns off all the LEDs.
		 */
		private function clearLeds():void
		{
			var r:int;
			var c:int;
			var led:TickerLED;			
			
			for( r = 0; r < _rows; r++ )
			{
				for( c = 0; c < _cols; c++ )
				{
					led = getChildAt( r * _cols + c ) as TickerLED;
					led.toggle( false );
				}
			}
		}
		
		/**
		 * Returns an array matrix of 1s and 0s which represent a single letter.
		 * 
		 * @param letter The letter to create a matrix array for.
		 */
		private static function letterToMatrix( letter:String ):Array
		{
			var result:Array = [];
			
			switch( letter.toUpperCase() )
			{
				case "A": 
					result[0] = [0,0,0,0];
					result[1] = [0,1,1,0];
					result[2] = [1,0,0,1];
					result[3] = [1,1,1,1];
					result[4] = [1,0,0,1];
					result[5] = [1,0,0,1];
					result[6] = [1,0,0,1];
					result[7] = [0,0,0,0];
					break;
				case "B": 
					result[0] = [0,0,0,0];
					result[1] = [1,1,1,0];
					result[2] = [1,0,0,1];
					result[3] = [1,1,1,0];
					result[4] = [1,1,1,0];
					result[5] = [1,0,0,1];
					result[6] = [1,1,1,0];
					result[7] = [0,0,0,0];
					break;
				case "C": 
					result[0] = [0,0,0,0];
					result[1] = [0,1,1,0];
					result[2] = [1,0,0,1];
					result[3] = [1,0,0,0];
					result[4] = [1,0,0,0];
					result[5] = [1,0,0,1];
					result[6] = [0,1,1,0];
					result[7] = [0,0,0,0];
					break;
				case "D": 
					result[0] = [0,0,0,0];
					result[1] = [1,1,1,0];
					result[2] = [1,0,0,1];
					result[3] = [1,0,0,1];
					result[4] = [1,0,0,1];
					result[5] = [1,0,0,1];
					result[6] = [1,1,1,0];
					result[7] = [0,0,0,0];
					break;
				case "E": 
					result[0] = [0,0,0,0];
					result[1] = [1,1,1,1];
					result[2] = [1,0,0,0];
					result[3] = [1,1,1,1];
					result[4] = [1,0,0,0];
					result[5] = [1,0,0,0];
					result[6] = [1,1,1,1];
					result[7] = [0,0,0,0];
					break;
				case "F": 
					result[0] = [0,0,0,0];
					result[1] = [1,1,1,1];
					result[2] = [1,0,0,0];
					result[3] = [1,1,1,1];
					result[4] = [1,0,0,0];
					result[5] = [1,0,0,0];
					result[6] = [1,0,0,0];
					result[7] = [0,0,0,0];
					break;
				case "G": 
					result[0] = [0,0,0,0];
					result[1] = [1,1,1,1];
					result[2] = [1,0,0,0];
					result[3] = [1,1,1,1];
					result[4] = [1,0,0,1];
					result[5] = [1,0,0,1];
					result[6] = [1,1,1,1];
					result[7] = [0,0,0,0];
					break;
				case "H": 
					result[0] = [0,0,0,0];
					result[1] = [1,0,0,1];
					result[2] = [1,0,0,1];
					result[3] = [1,1,1,1];
					result[4] = [1,0,0,1];
					result[5] = [1,0,0,1];
					result[6] = [1,0,0,1];
					result[7] = [0,0,0,0];
					break;
				case "I":
					result[0] = [0,0,0];
					result[1] = [1,1,1];
					result[2] = [0,1,0];
					result[3] = [0,1,0];
					result[4] = [0,1,0];
					result[5] = [0,1,0];
					result[6] = [1,1,1];
					result[7] = [0,0,0];
					break;
				case "J": 
					result[0] = [0,0,0,0];
					result[1] = [1,1,1,1];
					result[2] = [0,0,0,1];
					result[3] = [0,0,0,1];
					result[4] = [0,0,0,1];
					result[5] = [1,0,0,1];
					result[6] = [0,1,1,0];
					result[7] = [0,0,0,0];
					break;
				case "K": 
					result[0] = [0,0,0,0];
					result[1] = [1,0,0,1];
					result[2] = [1,0,1,0];
					result[3] = [1,1,0,0];
					result[4] = [1,1,0,0];
					result[5] = [1,0,1,0];
					result[6] = [1,0,0,1];
					result[7] = [0,0,0,0];
					break;
				case "L": 
					result[0] = [0,0,0,0];
					result[1] = [1,0,0,0];
					result[2] = [1,0,0,0];
					result[3] = [1,0,0,0];
					result[4] = [1,0,0,0];
					result[5] = [1,0,0,0];
					result[6] = [1,1,1,1];
					result[7] = [0,0,0,0];
					break;
				case "M": 
					result[0] = [0,0,0,0,0];
					result[1] = [1,0,0,0,1];
					result[2] = [1,1,0,1,1];
					result[3] = [1,0,1,0,1];
					result[4] = [1,0,1,0,1];
					result[5] = [1,0,0,0,1];
					result[6] = [1,0,0,0,1];
					result[7] = [0,0,0,0,0];
					break;
				case "N": 
					result[0] = [0,0,0,0,0];
					result[1] = [1,0,0,0,1];
					result[2] = [1,1,0,0,1];
					result[3] = [1,0,1,0,1];
					result[4] = [1,0,1,0,1];
					result[5] = [1,0,0,1,1];
					result[6] = [1,0,0,0,1];
					result[7] = [0,0,0,0,0];
					break;
				case "O": 
					result[0] = [0,0,0,0];
					result[1] = [0,1,1,0];
					result[2] = [1,0,0,1];
					result[3] = [1,0,0,1];
					result[4] = [1,0,0,1];
					result[5] = [1,0,0,1];
					result[6] = [0,1,1,0];
					result[7] = [0,0,0,0];
					break;
				case "P": 
					result[0] = [0,0,0,0];
					result[1] = [1,1,1,1];
					result[2] = [1,0,0,1];
					result[3] = [1,1,1,1];
					result[4] = [1,0,0,0];
					result[5] = [1,0,0,0];
					result[6] = [1,0,0,0];
					result[7] = [0,0,0,0];
					break;
				case "Q": 
					result[0] = [0,0,0,0];
					result[1] = [0,1,1,0];
					result[2] = [1,0,0,1];
					result[3] = [1,0,0,1];
					result[4] = [1,0,0,1];
					result[5] = [1,0,0,1];
					result[6] = [0,1,1,0];
					result[7] = [0,0,0,1];
					break;
				case "R": 
					result[0] = [0,0,0,0];
					result[1] = [1,1,1,1];
					result[2] = [1,0,0,1];
					result[3] = [1,1,1,0];
					result[4] = [1,1,0,0];
					result[5] = [1,0,1,0];
					result[6] = [1,0,0,1];
					result[7] = [0,0,0,0];
					break;
				case "S": 
					result[0] = [0,0,0,0];
					result[1] = [0,1,1,0];
					result[2] = [1,0,0,1];
					result[3] = [1,1,0,0];
					result[4] = [0,0,1,1];
					result[5] = [1,0,0,1];
					result[6] = [0,1,1,0];
					result[7] = [0,0,0,0];
					break;
				case "T": 
					result[0] = [0,0,0,0,0];
					result[1] = [1,1,1,1,1];
					result[2] = [0,0,1,0,0];
					result[3] = [0,0,1,0,0];
					result[4] = [0,0,1,0,0];
					result[5] = [0,0,1,0,0];
					result[6] = [0,0,1,0,0];
					result[7] = [0,0,0,0,0];
					break;
				case "U": 
					result[0] = [0,0,0,0];
					result[1] = [1,0,0,1];
					result[2] = [1,0,0,1];
					result[3] = [1,0,0,1];
					result[4] = [1,0,0,1];
					result[5] = [1,0,0,1];
					result[6] = [0,1,1,0];
					result[7] = [0,0,0,0];
					break;
				case "V": 
					result[0] = [0,0,0,0,0];
					result[1] = [1,0,0,0,1];
					result[2] = [1,0,0,0,1];
					result[3] = [1,0,0,0,1];
					result[4] = [1,0,0,0,1];
					result[5] = [0,1,0,1,0];
					result[6] = [0,0,1,0,0];
					result[7] = [0,0,0,0,0];
					break;
				case "W": 
					result[0] = [0,0,0,0,0,0];
					result[1] = [1,0,0,0,0,1];
					result[2] = [1,0,0,0,0,1];
					result[3] = [1,0,0,0,0,1];
					result[4] = [1,0,1,1,0,1];
					result[5] = [1,0,1,1,0,1];
					result[6] = [0,1,0,0,1,0];
					result[7] = [0,0,0,0,0,0];
					break;
				case "X":
					result[0] = [0,0,0,0,0,0];
					result[1] = [1,0,0,0,0,1];
					result[2] = [0,1,0,0,1,0];
					result[3] = [0,0,1,1,0,0];
					result[4] = [0,0,1,1,0,0];
					result[5] = [0,1,0,0,1,0];
					result[6] = [1,0,0,0,0,1];
					result[7] = [0,0,0,0,0,0];
					break;
				case "Y": 
					result[0] = [0,0,0,0,0];
					result[1] = [1,0,0,0,1];
					result[2] = [0,1,0,1,0];
					result[3] = [0,0,1,0,0];
					result[4] = [0,0,1,0,0];
					result[5] = [0,0,1,0,0];
					result[6] = [0,0,1,0,0];
					result[7] = [0,0,0,0,0];
					break;
				case "Z": 
					result[0] = [0,0,0,0,0,0];
					result[1] = [1,1,1,1,1,1];
					result[2] = [0,0,0,0,1,0];
					result[3] = [0,0,0,1,0,0];
					result[4] = [0,0,1,0,0,0];
					result[5] = [0,1,0,0,0,0];
					result[6] = [1,1,1,1,1,1];
					result[7] = [0,0,0,0,0,0];
					break;
				case " ":
					result[0] = [0,0,0,0];
					result[1] = [0,0,0,0];
					result[2] = [0,0,0,0];
					result[3] = [0,0,0,0];
					result[4] = [0,0,0,0];
					result[5] = [0,0,0,0];
					result[6] = [0,0,0,0];
					result[7] = [0,0,0,0];
					break;
				case ".": 
					result[0] = [0,0];
					result[1] = [0,0];
					result[2] = [0,0];
					result[3] = [0,0];
					result[4] = [0,0];
					result[5] = [1,1];
					result[6] = [1,1];
					result[7] = [0,0];
					break;
				case "/": 
					result[0] = [0,0,0,0,0,0,0];
					result[1] = [0,0,0,0,0,0,1];
					result[2] = [0,0,0,0,0,1,0];
					result[3] = [0,0,0,0,1,0,0];
					result[4] = [0,0,0,1,0,0,0];
					result[5] = [0,0,1,0,0,0,0];
					result[6] = [0,1,0,0,0,0,0];
					result[7] = [0,0,0,0,0,0,0];
					break;
				case ":": 
					result[0] = [0,0];
					result[1] = [1,1];
					result[2] = [1,1];
					result[3] = [0,0];
					result[4] = [0,0];
					result[5] = [1,1];
					result[6] = [1,1];
					result[7] = [0,0];
					break;
				case "!":
					result[0] = [0,0];
					result[1] = [1,1];
					result[2] = [1,1];
					result[3] = [1,1];
					result[4] = [1,1];
					result[5] = [0,0];
					result[6] = [1,1];
					result[7] = [0,0];
					break;
				case "1":
					result[0] = [0,0,0];
					result[1] = [0,1,0];
					result[2] = [1,1,0];
					result[3] = [0,1,0];
					result[4] = [0,1,0];
					result[5] = [0,1,0];
					result[6] = [1,1,1];
					result[7] = [0,0,0];					
					break;
				case "2":
					result[0] = [0,0,0,0,0];
					result[1] = [0,1,1,1,0];
					result[2] = [1,0,0,0,1];
					result[3] = [0,0,0,1,0];
					result[4] = [0,0,1,0,0];
					result[5] = [0,1,0,0,0];
					result[6] = [1,1,1,1,1];
					result[7] = [0,0,0,0,0];					
					break;
				case "3":
					result[0] = [0,0,0,0,0];
					result[1] = [1,1,1,1,0];
					result[2] = [0,0,0,0,1];
					result[3] = [0,1,1,1,0];
					result[4] = [0,0,0,0,1];
					result[5] = [0,0,0,0,1];
					result[6] = [1,1,1,1,0];
					result[7] = [0,0,0,0,0];
					break;
				case "4":
					result[0] = [0,0,0,0,0];
					result[1] = [0,0,0,1,0];
					result[2] = [0,0,1,1,0];
					result[3] = [0,1,0,1,0];
					result[4] = [1,0,0,1,0];
					result[5] = [1,1,1,1,1];
					result[6] = [0,0,0,1,0];
					result[7] = [0,0,0,0,0];
					break;
				case "5":
					result[0] = [0,0,0,0,0];
					result[1] = [1,1,1,1,1];
					result[2] = [1,0,0,0,0];
					result[3] = [1,1,1,1,0];
					result[4] = [0,0,0,0,1];
					result[5] = [1,0,0,0,1];
					result[6] = [0,1,1,1,0];
					result[7] = [0,0,0,0,0];
					break;
				case "6":
					result[0] = [0,0,0,0,0];
					result[1] = [0,1,1,1,0];
					result[2] = [1,0,0,0,0];
					result[3] = [1,1,1,1,0];
					result[4] = [1,0,0,0,1];
					result[5] = [1,0,0,0,1];
					result[6] = [0,1,1,1,0];
					result[7] = [0,0,0,0,0];
					break;
				case "7":
					result[0] = [0,0,0,0,0];
					result[1] = [1,1,1,1,1];
					result[2] = [0,0,0,0,1];
					result[3] = [0,0,0,1,0];
					result[4] = [0,0,1,0,0];
					result[5] = [0,1,0,0,0];
					result[6] = [1,0,0,0,0];
					result[7] = [0,0,0,0,0];
					break;
				case "8":
					result[0] = [0,0,0,0,0];
					result[1] = [0,1,1,1,0];
					result[2] = [1,0,0,0,1];
					result[3] = [0,1,1,1,0];
					result[4] = [1,0,0,0,1];
					result[5] = [1,0,0,0,1];
					result[6] = [0,1,1,1,0];
					result[7] = [0,0,0,0,0];
					break;
				case "9":
					result[0] = [0,0,0,0,0];
					result[1] = [0,1,1,1,0];
					result[2] = [1,0,0,0,1];
					result[3] = [1,0,0,0,1];
					result[4] = [0,1,1,1,1];
					result[5] = [0,0,0,0,1];
					result[6] = [0,1,1,1,0];
					result[7] = [0,0,0,0,0];
					break;
				case "0":
					result[0] = [0,0,0,0,0];
					result[1] = [0,1,1,1,0];
					result[2] = [1,0,0,0,1];
					result[3] = [1,0,0,0,1];
					result[4] = [1,0,0,0,1];
					result[5] = [1,0,0,0,1];
					result[6] = [0,1,1,1,0];
					result[7] = [0,0,0,0,0];
					break;				
				default:
					result[0] = [];
					result[1] = [];
					result[2] = [];
					result[3] = [];
					result[4] = [];
					result[5] = [];
					result[6] = [];
					result[7] = [];						
					break;
			}
			
			return result;			
		}
		
		public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );
			
			// Remove the timer
			if( _timer != null )
			{
				_timer.removeEventListener( TimerEvent.TIMER, onTimer );
				_timer.stop();
				_timer = null;
			}
			
			// Remove the LEDs
			while( numChildren > 0 )
			{
				( getChildAt( 0 ) as TickerLED ).dispose();
				removeChildAt( 0 );
			}
			
			// Clear Context
			logger.popContext();			
		}
	}
}