package starling.components
{
	import flash.utils.setTimeout;

	import starling.Game;
	import starling.assets.AssetManager;
	import starling.components.DigitDisplay;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.interfaces.IScratchRevealBonusGameHandler;

	import utils.ArrayHelper;
	import utils.DebugHelper;

	public class ScratchRevealBonusGame extends Sprite
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( ScratchRevealBonusGame );

		// UI Components
		private var imgBonusPanel:Image;
		private var ddBonusWinBase:starling.components.DigitDisplay;
		private var ddBonusWinMult:DigitDisplay;
		private var ddBonusWinTotl:DigitDisplay;
		private var grpIcons:Sprite;

		// Objects and Managers
		private var _handler:IScratchRevealBonusGameHandler;
		private var _assetManager:AssetManager;

		// Gamestate Variables
		private var _winAmount:Number;
		private var _bonusWins:Array;
		private var _possibleWins:Array;

		public function ScratchRevealBonusGame( handler:IScratchRevealBonusGameHandler, game:Game, assetManager:AssetManager )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );

			super();

			_handler = handler;
			_assetManager = assetManager;

			imgBonusPanel = new Image( _assetManager.getTexture( "BonusPanel" ) );
			addChild( imgBonusPanel );

			ddBonusWinBase = new DigitDisplay( 60, 17, 0, false, "digital7", 16 );
			ddBonusWinBase.x = 18;
			ddBonusWinBase.y = 295;
			addChild( ddBonusWinBase );

			ddBonusWinMult = new DigitDisplay( 60, 17, 0, false, "digital7", 16 );
			ddBonusWinMult.x = 121;
			ddBonusWinMult.y = 295;
			addChild( ddBonusWinMult );

			ddBonusWinTotl = new DigitDisplay( 100, 17, 0, false, "digital7", 16 );
			ddBonusWinTotl.x = 218;
			ddBonusWinTotl.y = 295;
			addChild( ddBonusWinTotl );

			grpIcons = new Sprite();
			grpIcons.width = this.width;
			grpIcons.height = this.height;
			addChild( grpIcons );

			// Clear Context
			logger.popContext();
		}

		public function setParameters( winAmount:Number, bonusWins:Array, possibleWins:Array ):void
		{
			// Log Activity
			logger.pushContext( "setParameters", arguments );

			_winAmount = winAmount;
			_bonusWins = bonusWins;
			_possibleWins = possibleWins;

			// Clear Context
			logger.popContext();
		}

		public function resetAndPlay():void
		{
			// Log Activity
			logger.pushContext( "resetAndPlay", arguments );

			// Reset the payouts
			ddBonusWinBase.displayAmount = _winAmount;
			ddBonusWinMult.displayAmount = 0;
			ddBonusWinTotl.displayAmount = 0;

			// Clear any existing icons
			grpIcons.removeChildren( 0, -1, true );

			// Create the bonus icons
			for( var i:int = 0; i < 4; i++ )
			{
				var icon:ScratchRevealIcon = new ScratchRevealIcon( _assetManager.getTexture( "BonusSymbol" ), new MovieClip( _assetManager.getTextures( "Lamp Reveal_", "BonusSymbolAtlas" ), 12 ) );
				icon.x = 30 + ( Math.floor( i % 2 ) * 150 );
				icon.y = 72 + ( Math.floor( i / 2 ) * 100 );
				icon.fontSize = 30;
				icon.color = 0xD59200;
				icon.addEventListener( starling.events.Event.TRIGGERED, onBonusIconClick );
				grpIcons.addChild( icon );
			}

			// Clear Context
			logger.popContext();
		}

		protected function onBonusIconClick( event:Event ):void
		{
			// Log Activity
			logger.pushContext( "onBousIconClick", arguments );

			// Get the icon clicked
			var icon:ScratchRevealIcon = event.currentTarget as ScratchRevealIcon;
			if( icon )
			{
				// Notify the handler
				_handler.onBonusIconClicked( icon );

				// Reveal the selected icon
				icon.reveal( _bonusWins.pop(), onBonusIconReveal );
			}

			// Disable the other bonus icons
			if( _bonusWins.length == 0 )
			{
				for( var i:int = 0; i < grpIcons.numChildren; i++ )
				{
					icon = grpIcons.getChildAt( i ) as ScratchRevealIcon;

					if( icon )
					{
						icon.enabled = false;
					}
				}
			}

			// Clear Context
			logger.popContext();
		}

		protected function onBonusIconReveal( icon:ScratchRevealIcon, bonusAmount:int ):void
		{
			// Log Activity
			logger.pushContext( "onBonusIconReveal", arguments );

			// Notify the handler
			_handler.onBonusIconRevealed( icon );

			ddBonusWinMult.displayAmount += bonusAmount;
			if( _bonusWins.length == 0 )
			{
				ddBonusWinTotl.animateDisplayAmount( ddBonusWinBase.displayAmount * ddBonusWinMult.displayAmount, 1000, onBonusWinningsDisplay );
			}

			// Clear Context
			logger.popContext();
		}

		protected function onBonusWinningsDisplay():void
		{
			// Log Activity
			logger.pushContext( "onBonusWinningsDisplay", arguments );

			// Notify the handler
			_handler.onBonusWinningsDisplay();

			// Clear Context
			logger.popContext();
		}

		public function revealPossible():void
		{
			// Log Activity
			logger.pushContext( "revealPossible", arguments );

			var icon:ScratchRevealIcon;
			for( var i:int = 0; i < grpIcons.numChildren; i++ )
			{
				icon = grpIcons.getChildAt( i ) as ScratchRevealIcon;

				if( icon && !icon.isRevealed )
				{
					icon.color = 0x000000;
					icon.reveal( _possibleWins.pop(), null );
				}
			}

			// Notify the handler
			setTimeout( _handler.onBonusPossibleRevealed, 2000 );

			// Clear Context
			logger.popContext();
		}
	}
}