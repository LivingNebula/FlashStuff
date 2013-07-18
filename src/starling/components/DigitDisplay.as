package starling.components
{
	import interfaces.IDisposable;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class DigitDisplay extends TextField implements IDisposable
	{
		import utils.FormatHelper;
		
		private var _displayAmount:int = 0;
		private var _isCurrency:Boolean = true;
		private var _targetAmount:int = 0;
		private var _twn:Tween;
		private var _animationCallback:Function;
		private var _isAnimating:Boolean = false;
		private var _twnObject:Object;
		
		[Embed(source="/../fonts/digital-7.ttf", embedAsCFF="false", fontFamily="digital7", mimeType='application/x-font' )] 
		private static const digital7:Class;
		
		public function DigitDisplay( width:int, height:int, defaultAmount:int, isCurrency:Boolean = true, fontName:String = "digital7", fontSize:Number = 12, color:uint = 0xF48784, bold:Boolean = false )
		{
			super( width, height, defaultAmount.toString(), fontName, fontSize, color, bold );
			super.hAlign = HAlign.RIGHT;
			
			_displayAmount = defaultAmount;
			_isCurrency = isCurrency;
		}
		
		public function set displayAmount( newAmount:int ):void
		{
			_displayAmount = newAmount;
			updateDisplay();
		}	
		
		public function get displayAmount():int
		{
			return _displayAmount;
		}
		
		public function set isCurrency( value:Boolean ):void
		{
			_isCurrency = value;
			updateDisplay();
		}
		
		public function get isCurrency():Boolean
		{
			return _isCurrency;
		}
		
		public function get isAnimating():Boolean
		{
			return _isAnimating;
		}
		
		public function animateDisplayAmount( newAmount:int, duration:Number, callback:Function = null ):void
		{
			_animationCallback = callback;
			_targetAmount = newAmount;
			_isAnimating = true;
			
			_twnObject = { amount: displayAmount };
			_twn = new Tween( _twnObject, duration / 1000 );
			_twn.animate( "amount", newAmount );
			_twn.onUpdate = onTweenUpdate;
			_twn.onComplete = onTweenEnd;
			Starling.juggler.add( _twn );
		}
		
		public function endAnimation():void
		{
			if( _twn != null )
			{
				Starling.juggler.remove( _twn );
				onTweenEnd();
			}
		}
		
		private function updateDisplay():void
		{
			text = _isCurrency ? FormatHelper.formatEntriesAndWinnings( _displayAmount ) : _displayAmount.toString();
		}
		
		public function onTweenUpdate():void
		{
			// Update the display amount
			displayAmount = _twnObject.amount < 1.00 ? _twnObject.amount : Math.round( _twnObject.amount );
		}
		
		public function onTweenEnd():void
		{
			// Cleanup the tween
			_twn = null;
			_twnObject = null;
			_isAnimating = false;
			
			// Update the display amount
			displayAmount = _targetAmount;
			
			// Execute the animation callback
			if( _animationCallback != null )
			{
				_animationCallback( this );
				_animationCallback = null;
			}
		}		
	}
}