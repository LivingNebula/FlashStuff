package components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import spark.primitives.Graphic;
		
	public class AnimatedImage extends Sprite
	{
		private var _imageArray:Array;
		private var _timer:Timer;
		private var _currentIndex:int = 0;
		private var _direction:int = 0;
		private var _reverse:Boolean = false;
		private var _repeatDelay:Number = 1000;
		private var _repeatCount:int = 0;
		private var _delay:Number = 100;
		private var _timeoutRef:uint = uint.MIN_VALUE;
		private var _callback:Function = null;		
		private var _callbackTimer:Timer;
		private var _delayCallback:Boolean = false;		
		
		// Constructor
		public function AnimatedImage( imageArray:Array )
		{				
			// Store the image array and default the index
			_imageArray = imageArray;			
			_currentIndex = 0;
		}
		
		// Starts the animation loop
		public function start_loop( delay:Number, repeatCount:int, repeatDelay:Number, reverse:Boolean, callback:Function = null, delayCallback:Boolean = false ):void
		{
			_delay = delay;
			_repeatCount = repeatCount;
			_repeatDelay = repeatDelay;
			_reverse = reverse;
			_callback = callback;
			_delayCallback = delayCallback;
			
			// Start the timer for the loop
			_timer = new Timer( delay, repeatCount * _imageArray.length );					
			_timer.addEventListener( TimerEvent.TIMER, loop_Animation );					
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, animation_Complete );			
			_timer.start();
		}
		
		// Restarts the animation using the existing settings
		public function restart_loop( callback:Function = null, delayCallback:Boolean = false ):void
		{
			stop_loop();
			start_loop( _delay, _repeatCount, _repeatDelay, _reverse, callback, delayCallback );
		}			
		
		// Stops the animation loop
		public function stop_loop():void
		{					
			_timer.removeEventListener( TimerEvent.TIMER, loop_Animation );
			_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, animation_Complete );
			_timer.stop();
			_currentIndex = 0;
			_direction = 0;
		}
		
		// Loops the images in the array
		private function loop_Animation( event:TimerEvent ):void 
		{		
			// Load the image from the array
			var bmp:Bitmap = _imageArray[_currentIndex] as Bitmap;
			if( bmp == null )
			{
				bmp = new _imageArray[_currentIndex]();
			}
			
			// Clear the sprite and draw the image 
			super.graphics.clear();
			super.graphics.beginBitmapFill( bmp.bitmapData );
			super.graphics.drawRect( 0, 0, bmp.width, bmp.height );
			super.graphics.endFill();
			
			// Increment/decrement the current image index 
			_currentIndex += _direction == 0 ? 1 : -1;
			
			// Check if the current index less than or equal to array bounds
			if( _currentIndex < 0 || _currentIndex >= _imageArray.length )
			{
				// Set the direction and current index
				_direction = _reverse == true ? 1 - _direction : 0;
				_currentIndex = _direction == 0 ? 0 : _imageArray.length - 1;
				
				if( _repeatDelay > 0 && ( _reverse == false || _direction == 0 ) )
				{
					_timer.stop();
					_timeoutRef = flash.utils.setTimeout( function temp():void
					{
						flash.utils.clearTimeout( _timeoutRef );
						_timer.start();
					}, _repeatDelay );
				}
			}
		}
		
		// Handles the timer complete event of the animation
		private function animation_Complete( event:TimerEvent ):void 
		{
			if( _callback != null )
			{
				if( _delayCallback )
				{
					_callbackTimer = new Timer( 350, 1 );
					_callbackTimer.addEventListener( TimerEvent.TIMER_COMPLETE, callbackTimer_Complete );
					_callbackTimer.start();
				}
				else
				{
					_callback();
				}					
			}
		}
		
		// Handles the timer complete event of the callback
		private function callbackTimer_Complete( event:TimerEvent ):void 
		{
			_callbackTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, callbackTimer_Complete );
			_callback();
		}
		
		public function dispose():void
		{
			if( _timer != null )
			{
				_timer.removeEventListener( TimerEvent.TIMER, loop_Animation );
				_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, animation_Complete );
			}
			
			if( _callbackTimer != null )
			{
				_callbackTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, callbackTimer_Complete );
			}
		}
	}
}