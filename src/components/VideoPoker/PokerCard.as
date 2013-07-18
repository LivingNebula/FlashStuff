package components.VideoPoker
{	
	import interfaces.IDisposable;
	
	import mx.controls.Image;
	import mx.effects.Sequence;
	import mx.events.EffectEvent;
	
	import spark.components.Group;
	import spark.effects.Animate;
	import spark.effects.Scale;
	
	public class PokerCard extends Group implements IDisposable
	{
		private var _cardBack:Object;
		private var _cardFront:Object;
		private var _cardHold:Object;
		private var _isHeld:Boolean = false;
		private var _isRevealed:Boolean = false;
		private var _onRevealed:Function;
		
		private var _cardImage:Image;
		private var _holdImage:Image;
		private var _cardAnimation:Sequence;
		private var scaleIn:Scale;
		private var scaleOut:Scale;
		
		public function set onRevealed( value:Function ):void
		{
			_onRevealed = value;
		}
		
		public function get onRevealed():Function
		{
			return _onRevealed;
		}
		
		public function set cardBack( value:Object ):void
		{
			_cardBack = value;
			setFaceDown();
		}
		
		public function set cardHold( value:Object ):void
		{
			_cardHold = value;
			_holdImage.source = _cardHold;
		}
		
		public function get isHeld():Boolean
		{
			return _isHeld;
		}
		
		public function set isHeld( value:Boolean ):void
		{
			_isHeld = value;
			_holdImage.visible = _isHeld;			
		}
		
		public function get isRevealed():Boolean
		{
			return _isRevealed;
		}
		
		public function PokerCard()
		{
			super();
			
			// Create and the card image
			_cardImage = new Image();
			_cardImage.buttonMode = true;
			addElement( _cardImage );
			
			// Create and add the hold image
			_holdImage = new Image();
			_holdImage.visible = false;
			addElement( _holdImage );
			
			// Create the card animation
			_cardAnimation = new Sequence();
			_cardAnimation.repeatCount = 1;
			
			scaleIn = new Scale( _cardImage );
			scaleIn.scaleXTo = 0;
			scaleIn.scaleXFrom = 1;
			scaleIn.duration = 75;
			scaleIn.repeatCount = 1;
			_cardAnimation.addChild( scaleIn );
			
			scaleOut = new Scale( _cardImage );
			scaleOut.scaleXTo = 1;
			scaleOut.scaleXFrom = 0;
			scaleOut.duration = 75;
			scaleOut.repeatCount = 1;
			scaleOut.addEventListener( EffectEvent.EFFECT_START, startReveal );
			scaleOut.addEventListener( EffectEvent.EFFECT_END, endReveal );
			_cardAnimation.addChild( scaleOut );
		}
		
		// Handles the 'Start Reveal' event of the animation
		protected function startReveal( event:EffectEvent ):void
		{
			_cardImage.source = _cardFront;					
			_isRevealed = true;
		}
		
		// Handles the 'End Reveal' event of the animation
		protected function endReveal( event:EffectEvent ):void
		{							
			_onRevealed( this );
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			_cardImage.width = this.width;
			_cardImage.height = this.height;
			_cardImage.top = 0;
			_cardImage.horizontalCenter = 0;		
			
			_holdImage.bottom = 0;
			_holdImage.horizontalCenter = 0;			
		}
		
		public function setFaceDown():void
		{
			_cardImage.source = _cardBack;
			_isRevealed = false;
			_isHeld = false;
			_holdImage.visible = false;
		}
		
		public function reveal( cardFront:Object ):void
		{
			_cardFront = cardFront;
			_cardAnimation.play();
		}		
		
		public function dispose():void
		{
			if( scaleOut != null )
			{
				scaleOut.removeEventListener( EffectEvent.EFFECT_START, startReveal );
				scaleOut.removeEventListener( EffectEvent.EFFECT_END, endReveal );
			}
		}
		
		override public function toString():String
		{
			return this.id.split( "." ).pop();
		}		
	}
}