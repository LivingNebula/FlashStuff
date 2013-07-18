package components.VideoBlackjack
{
	import components.ImageButton;
		
	import flash.events.MouseEvent;
	
	import interfaces.IDisposable;
	
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.effects.Sequence;
	import mx.events.EffectEvent;
	
	import objects.Card;
	import objects.Pile;
	
	import spark.components.Group;
	import spark.effects.Animate;
	import spark.effects.Scale;
	import spark.filters.GlowFilter;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.TileLayout;
	import spark.layouts.VerticalLayout;
	import spark.primitives.Graphic;
	
	import utils.FormatHelper;
	import utils.MathHelper;
	
	public class BlackjackHand extends Group implements IDisposable
	{	
		private var _isDealerHand:Boolean = false;
		private var _grpCards:Group;
		private var _grpButtons:Group;
		private var _btnHit:Button;
		private var _btnStay:Button;
		private var _btnSplit:Button;
		private var _btnDouble:Button;
		private var _imgInPlay:Image;
		private var _imgOutcome:Image;
		private var _imgScore:Image;
		private var _cards:Array;
		private var _grpValue:Group;
		private var _lblValue:Label;
		private var _lblPayout:Label;
		
		private var _isRevealed:Boolean = false;
		private var _isSplit:Boolean = false;
		private var _isDouble:Boolean = false;
		
		private var _cardBack:Object;
		private var _srcInPlay:Object; 
		private var _srcScore:Object;
		private var _cardAnimation:Sequence;
		private var _scaleIn:Scale;
		private var _scaleOut:Scale;
		
		private var _onHit:Function;
		private var _onStay:Function;
		private var _onSplit:Function;
		private var _onDouble:Function;
		private var _onReveal:Function;
		
		/**
		 * The function to be called when a player hits.
		 */
		public function set onHit( value:Function ):void
		{
			_onHit = value;
		}
		
		/**
		 * The function to be called when a player stays.
		 */
		public function set onStay( value:Function ):void
		{
			_onStay = value;
		}
		
		/**
		 * The function to be called when a player splits.
		 */
		public function set onSplit( value:Function ):void
		{
			_onSplit = value;
		}
		
		/**
		 * The function to be called when a player doubles.
		 */		
		public function set onDouble( value:Function ):void
		{
			_onDouble = value;
		}
		
		/**
		 * The function to be called when a player reveals.
		 */		
		public function set onReveal( value:Function ):void
		{
			_onReveal = value;
		}
		
		/**
		 * Sets the bet amount for this hand.
		 */
		public function set betAmount( value:Number ):void
		{
			_btnDouble.label = "DOUBLE\n(" + FormatHelper.formatEntriesAndWinnings( value ) + ")";
			_btnSplit.label = "SPLIT\n(" + FormatHelper.formatEntriesAndWinnings( value ) + ")";
		}
		
		/**
		 * Indicates whether or not this is a dealer hand.
		 */
		public function get isDealerHand():Boolean
		{
			return _isDealerHand;
		}
		
		public function set isDealerHand( value:Boolean ):void
		{
			_isDealerHand = value
			_grpButtons.visible = !_isDealerHand;
		}
		
		/**
		 * Indicates if the 2nd card has been reveal (dealer only).
		 */
		public function get isRevealed():Boolean
		{
			return _isRevealed;
		}
		
		/**
		 * Indicates if this hand is the result of a split.
		 */ 
		public function get isSplit():Boolean		
		{
			return _isSplit;
		}
		
		public function set isSplit( value:Boolean ):void 
		{
			_isSplit = value;
		}	
		
		/**
		 * Indicates if this hand is the result of a double.
		 */		
		public function get isDouble():Boolean
		{
			return _isDouble;
		}
		
		public function set isDouble( value:Boolean ):void 
		{
			_isDouble = value;
		}				
		
		/**
		 * Sets the source of the image to be used to represent the back of a card.
		 * 
		 * @param value The <code>Object</code> to be used as the <code>Image</code> source.
		 */
		public function set cardBack( value:Object ):void
		{
			_cardBack = value;
		}		
		
		/**
		 * Sets the source of the image to be used to indicate the hand is being played this round.
		 * 
		 * @param value The <code>Object</code> to be used as the <code>Image</code> source.
		 */
		public function set srcInPlay( value:Object ):void
		{
			_imgInPlay.source = _srcInPlay = value;
		}
		
		/**
		 * Sets the source of the image to be used as the backdrop of hand's score.
		 * 
		 * @param value The <code>Object</code> to be used as the <code>Image</code> source.
		 */
		public function set srcScore( value:Object ):void
		{
			_imgScore.source = _srcScore = value;
		}		
		
		public function BlackjackHand()
		{
			super();
			
			// Create the CARDS array
			_cards = [];
			
			// Create the HIT and STAY buttons
			var layout:TileLayout = new TileLayout();
			layout.requestedColumnCount = 2;
			layout.requestedRowCount = 2;
			_grpButtons = new Group();
			_grpButtons.depth = 2; // ABOVE CARDS & INPLAY GRAPHIC
			_grpButtons.visible = false;
			_grpButtons.layout = layout;
			_grpButtons.top = 75;
			_grpButtons.width = 154;
			addElement( _grpButtons );
			
			_btnHit = new Button();
			_btnHit.height = 30;
			_btnHit.width = 70;
			_btnHit.useHandCursor = true;
			_btnHit.label = "HIT";
			_btnHit.addEventListener( MouseEvent.CLICK, btnHit_ClickHandler );
			_grpButtons.addElement( _btnHit );
			
			_btnStay = new Button();
			_btnStay.height = 30;
			_btnStay.width = 70;
			_btnStay.useHandCursor = true;
			_btnStay.label = "STAY";
			_btnStay.addEventListener( MouseEvent.CLICK, btnStay_ClickHandler );			
			_grpButtons.addElement( _btnStay );
			
			_btnSplit = new Button();
			_btnSplit.height = 30;
			_btnSplit.width = 70;
			_btnSplit.useHandCursor = true;
			_btnSplit.label = "SPLIT";
			_btnSplit.addEventListener( MouseEvent.CLICK, btnSplit_ClickHandler );			
			_grpButtons.addElement( _btnSplit );
			
			_btnDouble = new Button();
			_btnDouble.height = 30;
			_btnDouble.width = 70;
			_btnDouble.useHandCursor = true;
			_btnDouble.label = "DOUBLE";
			_btnDouble.addEventListener( MouseEvent.CLICK, btnDouble_ClickHandler );			
			_grpButtons.addElement( _btnDouble );			
			
			// Create the IN PLAY graphic
			_imgInPlay = new Image();
			_imgInPlay.depth = 1; // ABOVE CARDS, BELOW EVERYTHING ELSE
			_imgInPlay.bottom = 0;
			_imgInPlay.horizontalCenter = 0;			
			addElement( _imgInPlay );
			
			
			// Create the Cards GROUP
			_grpCards = new Group();
			_grpCards.depth = 0; // BOTTOM MOST ITEM
			_grpCards.horizontalCenter = 0;
			_grpCards.width = 130;
			addElement( _grpCards );
			
			// Create the card animation
			_cardAnimation = new Sequence();
			_cardAnimation.repeatCount = 1;
			
			_scaleIn = new Scale();
			_scaleIn.scaleXTo = 0;
			_scaleIn.scaleXFrom = 1;
			_scaleIn.duration = 75;
			_scaleIn.repeatCount = 1;
			_cardAnimation.addChild( _scaleIn );
			
			_scaleOut = new Scale();
			_scaleOut.scaleXTo = 1;
			_scaleOut.scaleXFrom = 0;
			_scaleOut.duration = 150;
			_scaleOut.repeatCount = 1;
			_scaleOut.addEventListener( EffectEvent.EFFECT_START, startReveal );
			_scaleOut.addEventListener( EffectEvent.EFFECT_END, endReveal );
			_cardAnimation.addChild( _scaleOut );
			
			// Create the value group
			_grpValue = new Group();
			_grpValue.visible = false;
			_grpValue.right = 0;
			_grpValue.top = -20;
			_grpValue.depth = 3; // TOP MOST ITEM
			addElement( _grpValue );
			
			_imgScore = new Image();
			_grpValue.addElement( _imgScore );
			
			_lblValue = new Label();
			_lblValue.height = 20;
			_lblValue.width = 40;
			_lblValue.verticalCenter = 0;
			_lblValue.horizontalCenter = 0;
			_lblValue.setStyle( "textAlign", "center" );
			_lblValue.setStyle( "verticalAlign", "center" );
			_lblValue.setStyle( "fontSize", 16 );
			_lblValue.setStyle( "fontWeight", "bold" );
			_lblValue.setStyle( "color", "0xFBD469" );
			_grpValue.addElement( _lblValue );
			
			// Create the RESULT Image
			_imgOutcome = new Image();
			_imgOutcome.horizontalCenter = 0;
			_imgOutcome.top = 50;
			_imgOutcome.visible = false;
			_imgOutcome.depth = 2; // SAME LAYER AS BUTTONS
			addElement( _imgOutcome );
			
			// Create the RESULT Label (for winnings)
			_lblPayout = new Label();
			_lblPayout.width = 154;
			_lblPayout.height = 25;
			_lblPayout.horizontalCenter = 0;
			_lblPayout.top = 81;
			_lblPayout.visible = false;
			_lblPayout.depth = 3; //
			_lblPayout.setStyle( "textAlign", "center" );
			_lblPayout.setStyle( "verticalAlign", "center" );
			_lblPayout.setStyle( "fontSize", 16 );
			_lblPayout.setStyle( "color", "0xFFFFFF" );
			var shd:GlowFilter = new GlowFilter( 0xFFFFFF, .65, 6, 6, 1, 1 );
			_lblPayout.filters = [shd];
			addElement( _lblPayout );
		}
		
		/**
		 * Removes the existing card images, resets the <code>isRevealed</code> state and hides the outcome.
		 */
		public function clear():void
		{
			_cards = [];
			
			_isRevealed = false;
			_isSplit = false;
			_isDouble = false;
			
			_grpCards.removeAllElements();
			_grpValue.visible = false;		
			_imgOutcome.visible = false;
			_lblPayout.visible = false;
		}
		
		/**
		 * Adds a card to the hand, optionally hiding it to be revealed later
		 * 
		 * @param cardImage A <code>Class</code> source to be use for the card's image.
		 * @param isHidden If <code>true</code>, the card placed face down to be revealed later (dealer only).
		 */
		public function hit( cardImage:Class, isHidden:Boolean = false ):void
		{
			_cards.push( cardImage );
			
			// Create our image and add it to the group
			var img:Image = new Image();
			img.source = isHidden && _cardBack != null && _isDealerHand ? _cardBack : cardImage;
			img.y = ( Math.floor( ( _grpCards.numElements ) / 3 ) * 26 ) + ( ( _grpCards.numElements % 3 ) * 3 );
			img.x = ( _grpCards.numElements % 3 ) * 25;
			img.width = 80;
			img.height = 115;
			_grpCards.addElement( img );
			
			// If the card is hidden, set it as the target for our reveal animation
			if( isHidden && _cardBack != null && _isDealerHand )
			{
				_scaleIn.target = img;
				_scaleOut.target = img;
			}
		}
		
		/**
		 * Displays the outcome of the hand, using the provided image.
		 * 
		 * @param cardImage A <code>Class</code> source to be use to display the outcome.
		 */
		public function displayResult( imgSource:Class, winAmount:int = 0 ):void
		{
			_imgOutcome.visible = true;
			_imgOutcome.source = imgSource;
			
			if( winAmount > 0 )
			{
				_lblPayout.visible = true;
				_lblPayout.text = "Win: " + FormatHelper.formatEntriesAndWinnings( winAmount );
			}
		}
		
		/**
		 * Sets the display value for all the cards in the hand.
		 */
		public function setValue( value:int ):void
		{
			_grpValue.visible = true;
			_lblValue.text = value.toString();
		}
		
		/**
		 * Reveals the hidden card ( dealer only ).
		 */
		public function reveal():void
		{
			if( !_isDealerHand || _isRevealed )
			{
				return;
			}
			
			_cardAnimation.play();
			_isRevealed = true;
		}

		/**
		 * Toggles the ability for a player to interact with the hand by hitting or staying.
		 * Optionally enables the "split" and "double" options as well.
		 * 
		 * @param enabled If <code>true</code>, the hand will be enabled.
		 * @param canSplit If <code>true</code>, the "split" button will be enabled.
		 * @param canDouble If <code>true</code>, the "double" button will be enabled.
		 */
		public function toggleEnabled( enabled:Boolean, canSplit:Boolean = false, canDouble:Boolean = false ):void
		{
			_grpButtons.visible = !_isDealerHand && enabled;
			
			// If the hand is already split or doubled, we cannot do it again
			if( !_isSplit && !_isDouble ) 
			{
				_btnSplit.visible = canSplit;
				_btnDouble.visible = canDouble;
			}			
		}	
		
		/**
		 * Disposes of the control by removing all event listeners and performing cleanup,
		 */
		public function dispose():void
		{
			_btnHit.removeEventListener( MouseEvent.CLICK, btnHit_ClickHandler );
			_btnStay.removeEventListener( MouseEvent.CLICK, btnStay_ClickHandler );
			
			_scaleOut.removeEventListener( EffectEvent.EFFECT_START, startReveal );
			_scaleOut.removeEventListener( EffectEvent.EFFECT_END, endReveal );				
		
			_onHit = null;
			_onStay = null;
			_onSplit = null;
			_onDouble = null;
			_onReveal = null;
		}
		
		// Handles the "click" event of the btnHit control
		protected function btnHit_ClickHandler( event:MouseEvent ):void
		{
			_onHit( this );
		}
		
		// Handles the "click" event of the btnStay control
		protected function btnStay_ClickHandler( event:MouseEvent ):void
		{
			_onStay( this );;
		}
		
		// Handles the "click" event of the btnSplit control
		protected function btnSplit_ClickHandler( event:MouseEvent ):void 
		{
			_onSplit( this );
		}
		
		// Handles the "click" event of the btnDouble control
		protected function btnDouble_ClickHandler( event:MouseEvent ):void 
		{
			_onDouble( this );
		}		
		
		// Handles the 'Start Reveal' event of the animation
		protected function startReveal( event:EffectEvent ):void
		{
			( _grpCards.getElementAt(1) as Image ).source = _cards[1];					
			_isRevealed = true;
		}
		
		// Handles the 'End Reveal' event of the animation
		protected function endReveal( event:EffectEvent ):void
		{							
			_onReveal( this );
		}
		
		override public function toString():String
		{
			return this.id.split( "." ).pop();
		}		
	}
}