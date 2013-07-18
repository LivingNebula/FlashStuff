package starling.components
{
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import utils.DebugHelper;
	
	public class WordBalloon extends Sprite
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( WordBalloon );
		
		// UI Components
		private var _imgBalloon:Image;
		private var _txtDialog:TextField;
		
		// Objects and Managers
		private var _wordTimer:Timer;
		private var _onComplete:Function;
		
		// Gamestate Variables
		private var _words:Array;
		private var _wordsPerSecond:Number;
		private var _sayTimeout:uint;
		
		public function get text():String
		{
			return _txtDialog.text;
		}
		
		public function set text( value:String ):void
		{
			_txtDialog.text = value;
		}
		
		public function WordBalloon( texture:Texture, text:String, textBoundingRect:Rectangle = null )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );
			
			super();
			
			_imgBalloon = new Image( texture );
			addChild( _imgBalloon );
			
			_txtDialog = new TextField( textBoundingRect ? textBoundingRect.width : _imgBalloon.width, textBoundingRect ? textBoundingRect.height : _imgBalloon.height, text );
			_txtDialog.x = textBoundingRect ? textBoundingRect.x : 0;
			_txtDialog.y = textBoundingRect ? textBoundingRect.y : 0;
			_txtDialog.hAlign = starling.utils.HAlign.LEFT;
			_txtDialog.vAlign = starling.utils.VAlign.TOP;
			addChild( _txtDialog );
			
			// Clear Context
			logger.popContext();
		}
		
		public function say( text:String, duration:int, delay:int = 0, clear:Boolean = true, onComplete:Function = null ):void
		{
			// Log Activity
			logger.pushContext( "say", arguments );
			
			if( delay > 0 )
			{
				_sayTimeout = setTimeout( say, delay, text, duration, 0, clear, onComplete );
				
				// Clear Context
				return;
			}
			
			if( clear ) 
			{ 
				_txtDialog.text = ""; 
			}
			
			_words = text.split( " " );
			_onComplete = onComplete;

			cleanupWordTimer();
			_wordTimer = new Timer( duration / _words.length, _words.length );
			_wordTimer.addEventListener( TimerEvent.TIMER, onWordTimer_Timer );
			_wordTimer.addEventListener( TimerEvent.TIMER_COMPLETE, onWordTimer_Complete );
			_wordTimer.start();
			
			// Clear Context
			logger.popContext();			
		}
		
		protected function onWordTimer_Timer( event:TimerEvent ):void
		{
			// Log Activity
			logger.pushContext( "onWordTimer_Timer", arguments, false );
			
			_txtDialog.text += _words[ _wordTimer.currentCount - 1] + " ";
			
			// Clear Context
			logger.popContext( false );
		}
		
		protected function onWordTimer_Complete( event:TimerEvent ):void
		{
			// Log Activity
			logger.pushContext( "onWordTimer_Complete", arguments );
			
			cleanupWordTimer();
			if( _onComplete != null )
			{
				_onComplete();
			}
			
			// Clear Context
			logger.popContext();
		}
		
		private function cleanupWordTimer():void
		{
			// Log Activity
			logger.pushContext( "cleanupWordTimer", arguments );
			
			if( _wordTimer != null )
			{
				_wordTimer.removeEventListener( TimerEvent.TIMER, onWordTimer_Timer );
				_wordTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, onWordTimer_Complete );	
				_wordTimer.stop();
				_wordTimer = null;
			}
			
			// Clear Context
			logger.popContext();
		}
		
		override public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );
			
			clearTimeout( _sayTimeout );
			cleanupWordTimer();
			
			super.dispose();
			
			// Clear Context
			logger.popContext();
		}
	}
}