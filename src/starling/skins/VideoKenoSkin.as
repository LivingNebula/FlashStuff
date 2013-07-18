package starling.skins
{
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;

	import starling.Game;
	import starling.animation.Transitions;
	import starling.assets.AssetManager;
	import starling.components.ButtonPanel;
	import starling.components.ComplexButton;
	import starling.components.DigitDisplay;
	import starling.components.VideoKeno.VideoKenoBall;
	import starling.components.VideoKeno.VideoKenoNumber;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.ClippedSprite;
	import starling.text.TextField;

	import utils.DebugHelper;

	public class VideoKenoSkin extends Sprite
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( VideoKenoSkin );

		// Objects and Managers
		protected var _assetManager:AssetManager;
		protected var _game:Game;

		// UI Components
		public var btnClear:ComplexButton;
		public var btnPanel:ButtonPanel;
		public var ddBetAmount:DigitDisplay;
		public var ddHits:DigitDisplay;
		public var ddPicks:DigitDisplay;
		public var ddWinAmount:DigitDisplay;
		public var grpNumbers:Sprite;
		public var grpPayouts:Sprite;
		public var grpPaytable:ClippedSprite;
		public var grpBalls:Sprite;
		public var grpHits:Sprite;
		public var grpPays:Sprite;
		public var grpLayerHits:Sprite;
		public var imgSkin:Image;
		public var imgPaytable:Image;

		// Handlers and Callbacks
		protected var _ballInPlaceCallback:Function;

		public static function appendRequiredAssets( assetManager:AssetManager ):void
		{
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_ATLAS, "TextureAtlas" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "lose" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "number_deselected" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "number_disabled" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "number_hit" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "number_selected" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "reveal_numbers" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "win" );
		}

		public function VideoKenoSkin( game:Game, assetManager:AssetManager )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );

			_game = game;
			_assetManager = assetManager;

			initUI();

			// Clear Context
			logger.popContext();
		}

		protected function initUI():void
		{
			// Log Activity
			logger.pushContext( "initUI", arguments );
			// Base Skin
			imgSkin = new Image( _assetManager.getTexture( "Skin" ) );
			imgSkin.pivotX = imgSkin.pivotY = 0;
			imgSkin.x = 0;
			imgSkin.y = 0;
			addChild( imgSkin );

			// Clear button
			btnClear = new ComplexButton(
				_assetManager.getTexture( "Clear_Up" ),
				"",
				_assetManager.getTexture( "Clear_Down" ),
				_assetManager.getTexture( "Clear_Over" ),
				_assetManager.getTexture( "Clear_Disabled" )
			);
			btnClear.pivotX = btnClear.pivotY = 0;
			btnClear.x = 464;
			btnClear.y = 115;
			addChild( btnClear );

			// Button container
			grpNumbers = new Sprite();
			grpNumbers.width = 440;
			grpNumbers.height = 352;
			grpNumbers.x = 310;
			grpNumbers.y = 156;
			addChild( grpNumbers );

			// Create the buttons
			for( var row:int = 0; row < 8; row++ )
			{
				for( var col:int = 0; col < 10; col++ )
				{
					var btn:VideoKenoNumber = new VideoKenoNumber(
						_assetManager.getTexture( "Number_Up" ),
						row * 10 + col + 1,
						_assetManager.getTexture( "Number_Down" ),
						_assetManager.getTexture( "Number_Over" ),
						null,
						_assetManager.getTexture( "Number_UserSelected" ),
						_assetManager.getTexture( "Number_GameSelected" )
					);
					btn.x = col * 47;
					btn.y = row * 39;
					grpNumbers.addChild( btn );
				}
			}

			// Hit indicators
			grpLayerHits = new Sprite();
			grpLayerHits.width = 440;
			grpLayerHits.height = 352;
			grpLayerHits.x = 310;
			grpLayerHits.y = 156;
			addChild( grpLayerHits );

			// Balls
			grpBalls = new Sprite();
			grpBalls.width = 424;
			grpBalls.height = 78;
			grpBalls.x = 346;
			grpBalls.y = 28;
			addChild( grpBalls );

			// Paytable Container
			grpPaytable = new ClippedSprite();
			grpPaytable.width = 275;
			grpPaytable.height = 180;
			grpPaytable.x = 25;
			grpPaytable.y = 287;
			grpPaytable.visible = false;
			addChild( grpPaytable );

			// Paytable image
			imgPaytable = new Image( _assetManager.getTexture( "Paytable" ) );
			grpPaytable.addChild( imgPaytable );

			// Digit Displays
			ddPicks = new DigitDisplay( 40, 30, 0, false, "digital7", 36 );
			ddPicks.x = 417;
			ddPicks.y = 116;
			addChild( ddPicks );

			ddHits = new DigitDisplay( 40, 30, 0, false, "digital7", 36);
			ddHits.x = 695;
			ddHits.y = 116;
			addChild( ddHits );

			ddWinAmount = new DigitDisplay( 128, 30, 0, true, "digital7", 36 );
			ddWinAmount.x = 162;
			ddWinAmount.y = 128;
			addChild( ddWinAmount );

			ddBetAmount = new DigitDisplay( 128, 30, 0, true, "digital7", 36);
			ddBetAmount.x = 162;
			ddBetAmount.y = 175;
			addChild( ddBetAmount );

			// PayTables
			grpPayouts = new Sprite();
			grpPayouts.width = 220;
			grpPayouts.height = 180;
			grpPayouts.x = 60;
			grpPayouts.y = 290;
			addChild( grpPayouts );

			grpHits = new Sprite();
			grpHits.width = 95;
			grpHits.height = 180;
			grpHits.x = 0;
			grpHits.y = -5;
			grpPayouts.addChild( grpHits );

			grpPays = new Sprite();
			grpPays.width = 95;
			grpPays.height = 180;
			grpPays.x = 125;
			grpPays.y = -5;
			grpPayouts.addChild( grpPays );

			var dsFilter:DropShadowFilter = new DropShadowFilter( 1, 45, 0x000000 );
			for( var i:int = 0; i < 10; i++ )
			{
				var lblHit:TextField = new TextField( 95, 18, "-", "Verdana", 16, 0xFFFFFF );
				lblHit.x = 0;
				lblHit.y = i * 18;
				lblHit.height = 20;
				lblHit.nativeFilters = [dsFilter];
				grpHits.addChild( lblHit );

				var lblPay:TextField = new TextField( 95, 18, "-", "Verdana", 16, 0xFFFFFF );
				lblPay.x = 0;
				lblPay.y = i * 18;
				lblPay.height = 20;
				lblPay.nativeFilters = [dsFilter];
				grpPays.addChild( lblPay );
			}

			// Button Panel
			btnPanel = new ButtonPanel( ButtonPanel.MENU_TYPE_VIDEO_KENO, _game );
			btnPanel.x = 0;
			btnPanel.y = 470;
			addChild( btnPanel );

			// Clear Context
			logger.popContext();
		}

		/**
		 * Removes the balls from the display and stops any animations.
		 */
		public function removeBalls():void
		{
			// Log Activity
			logger.pushContext( "removeBalls", arguments );
			
			var ball:VideoKenoBall;

			while( grpBalls.numChildren > 0 )
			{
				ball = grpBalls.getChildAt( 0 ) as VideoKenoBall;

				Starling.juggler.removeTweens( ball );
				grpBalls.removeChild( ball, true );
			}
			
			// Clear Context
			logger.popContext();
		}

		/**
		 * Animates the balls into position
		 * @param phase There are 2 phases, 1 animates the balls to indicate hits.
		 * 2 animates the balls into the correct rotation after being dispalyed.
		 * @param pickNumbers One ball is created for each number in this array, the nubmer is used as the ball's label.
		 * @param ballInPlaceCallback Called as each ball is dropped into place.
		 */
		public function animateBalls( phase:int = 1, pickNumbers:Array = null, ballInPlaceCallback:Function = null ):void
		{
			// Log Activity
			logger.pushContext( "animateBalls", arguments );
			var ball:VideoKenoBall;
			var index:int;

			_ballInPlaceCallback = ballInPlaceCallback;

			if( phase == 1 && pickNumbers != null )
			{
				for( index = 0; index < pickNumbers.length; index++ )
				{
					ball = new VideoKenoBall( _assetManager.getTexture( "Ball" ), pickNumbers[index] );
					ball.x = ( ball.width >> 1 ) + 500;
					ball.y = ( ball.width >> 1 ) + ( index % 2 == 0 ? 0 : 40 );
					grpBalls.addChild( ball );

					Starling.juggler.tween( ball, 2.00, {
						transition: starling.animation.Transitions.EASE_OUT,
						x: ( ball.width >> 1 ) + ( index * 20 ) - ( index % 2 != 0 ? 20 : 0 ),
						delay: index * 100 * 0.001,
						onStart: ball_moveStartHander,
						onStartArgs: [ball],
						onUpdate: ball_moveUpdateHandler,
						onUpdateArgs: [ball],
						onComplete: ball_moveEndHandler,
						onCompleteArgs: [ball]
					});
				}
			}
			else if( phase == 2 )
			{
				for( index = 0; index < grpBalls.numChildren; index++ )
				{
					ball = grpBalls.getChildAt( index ) as VideoKenoBall;

					Starling.juggler.tween( ball, 0.25, {
						transition: starling.animation.Transitions.EASE_OUT,
						y: ball.y - 20,
						rotation: 0,
						delay: index * 25 * 0.001
					});

					Starling.juggler.tween( ball, 0.25, {
						transition: starling.animation.Transitions.EASE_IN,
						y: ball.y,
						delay: index * 25 * 0.001 + ( 0.25 ),
						onComplete: ball_moveEndHandler,
						onCompleteArgs: [ball]
					});
				}
			}

			// Clear Context
			logger.popContext();
		}

		/** Handles the ball tween's start event */
		protected function ball_moveStartHander( ball:VideoKenoBall ):void
		{

		}

		/** Handles the ball tween's update event */
		protected function ball_moveUpdateHandler( ball:VideoKenoBall ):void
		{
			var moved:Number = ball.x - ( ( ball.width >> 1 ) + 424 );
			var cir:Number = Math.PI * 32;
			var rot:Number = moved / cir;

			ball.rotation = ( ( rot * 360 ) * Math.PI ) / 180;
		}

		/** Handles the ball tween's complete event */
		protected function ball_moveEndHandler( ball:VideoKenoBall, hitPhase:Boolean = true, endPhase:Boolean = true ):void
		{
			// Log Activity
			logger.pushContext( "ball_moveEndHandler", arguments );
			if( endPhase )
			{
				// Remove the tween from the juggler
				Starling.juggler.removeTweens( ball );
			}

			// Execute the callback
			if( _ballInPlaceCallback != null )
			{
				_ballInPlaceCallback( ball, hitPhase, endPhase );
			}

			// Clear Context
			logger.popContext();
		}

		/** Handles updating the payout table. **/
		public function displayPayouts( payoutTable:Array, betAmount:Number ):void
		{
			// Log Activity
			logger.pushContext( "displayPayouts", arguments );

			var payoutCount:int = payoutTable.length;
			var txtHit:TextField;
			var txtPay:TextField;
			var i:int = 0;
			var index:int = 0;
			var scaledFontSize:Number = 14;

			// Reset all the payouts to -, -
			for( i = 0; i < 10; i++ )
			{
				txtHit = grpHits.getChildAt( i ) as TextField;
				txtPay = grpPays.getChildAt( i ) as TextField;

				txtHit.text = "-";
				txtPay.text = "-";
			}

			// Fill the payouts based on the number of selected numbers
			for( i = payoutCount - 1; i >= 0; i-- )
			{
				if( payoutTable[i] != 0 )
				{
					txtHit = grpHits.getChildAt( index ) as TextField;
					txtPay = grpPays.getChildAt( index ) as TextField;

					txtHit.text = i.toString();
					txtPay.text = ( payoutTable[i] * betAmount ).toString();
					txtPay.fontSize = scaledFontSize;

					if( i == payoutCount - 1 )
					{
						while( txtPay.textBounds.height > txtPay.height || txtPay.textBounds.width > txtPay.width )
						{
							if( scaledFontSize < 4 ) break;
							txtPay.fontSize = --scaledFontSize;
						}
					}

					index++;
				}
			}

			// Clear Context
			logger.popContext();
		}

		/** Handles higlighting the winning amount */
		public function displayPrizeHighlight( highlightIndex:int ):void
		{
			// Log Activity
			logger.pushContext( "displayPrizeHighlight", arguments );
			grpPaytable.visible = true;
			grpPaytable.clipRect = new Rectangle( grpPaytable.x, grpPaytable.y + highlightIndex * 18, grpPaytable.width, 18 );

			// Clear Context
			logger.popContext();
		}

		/** Handles toggling the winning highlight */
		public function togglePrizeHighlight( visible:Boolean ):void
		{
			grpPaytable.visible = visible;
		}

		/** Handles display the bonus game. **/
		public function loadBonusGame( betAmount:int, winAmount:Number, bonusAmount:Number, bonusGameCompletedCallback:Function, bonusGameCompletedArgs:Array ):void
		{
			// Log Activity
			logger.pushContext( "loadBonusGame", arguments );

			bonusGameCompletedCallback.apply( null, bonusGameCompletedArgs );

			// Clear Context
			logger.popContext();
		}
	}
}