package assets
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class DataTimer extends Timer
	{
		private var _data:*;
		private var _startDelay:Number;
		private var _repeatDelay:Number;
		private var _repeatCount:int;
		private var _listener:Function;
		private var _startTimeout:uint = 0;
		private var _currentCount:int = 0;
		
		public function get data():*
		{
			return _data;
		}
		
		public function set data( value:* ):void
		{
			_data = value;
		}
		
		public function get startDelay():Number
		{
			return _startDelay;
		}
		
		public function set startDelay( value:Number ):void
		{
			_startDelay = value;
		}
		
		override public function get currentCount():int
		{
			return _currentCount;
		}
		
		override public function get repeatCount():int
		{
			return _repeatCount;
		}
		
		override public function set repeatCount( value:int ):void
		{
			_repeatCount = value;
		}
		
		override public function get running():Boolean
		{
			return super.running || ( _startDelay > 0 && _startTimeout > 0 );
		}
		
		// Initialzes the Data Timer
		public function DataTimer( startDelay:Number, repeatDelay:Number, repeatCount:int=0, data:* = null, listener:Function = null, useWeakReference:Boolean = false )
		{
			// Initialze the super class
			super( repeatDelay, repeatCount == 0 ? 0 : repeatCount - 1 );
			super.addEventListener( TimerEvent.TIMER, internalTimerListener, false, 99, false );
			
			// Store our parameters into private variables
			_data = data;
			_startDelay = startDelay;
			_repeatDelay = repeatDelay;
			_repeatCount = repeatCount;
			
			// If we were passed in a listener, assign it to our TIMER event
			if( listener != null )
			{
				_listener = listener;
				this.addEventListener( TimerEvent.TIMER, _listener, false, 0, useWeakReference );
			}
		}
		
		// Overrides the timer's start method, so we can (optionally) add in our start delay
		override public function start():void
		{
			if( super.running ) 
			{
				return;
			}
			
			if( _startDelay > 0 ) 
			{
				_startTimeout = setTimeout( privateStart, _startDelay );
			}
			else
			{
				privateStart();
			}
		}
				
		private function privateStart():void
		{
			clearTimeout( _startTimeout );
			_startTimeout = 0;
			
			if( _repeatCount == 1 ) 
			{
				dispatchEvent( new TimerEvent( TimerEvent.TIMER, true, true ) );
				dispatchEvent( new TimerEvent( TimerEvent.TIMER_COMPLETE, true, true ) );
			}
			else
			{
				dispatchEvent( new TimerEvent( TimerEvent.TIMER, true, true ) );
				super.start();
			}
		}		
		
		// Overrides the timer's stop method
		override public function stop():void
		{
			if( _startTimeout > 0 )
			{
				clearTimeout( _startTimeout );
				_startTimeout = 0;
			}
			
			super.stop();
		}
		
		// Overrides the timer's reset method
		override public function reset():void
		{
			if( _startTimeout > 0 )
			{
				flash.utils.clearTimeout( _startTimeout );
				_startTimeout = 0;
			}
			
			_currentCount = 0;
			super.reset();			
		}	
		
		// Private listener to handle current count
		private function internalTimerListener( event:TimerEvent ):void
		{
			_currentCount++;
		}
		
		// Custom dispose method to clear up listeners, etc
		public function dispose():void
		{
			this.data = null;
			
			if( _listener != null )
			{
				this.removeEventListener( TimerEvent.TIMER, _listener, false );
			}
			
			super.removeEventListener( TimerEvent.TIMER, internalTimerListener );
			super.stop();
		}
	}
}