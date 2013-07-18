package starling.skins
{

	import assets.SoundManager;

	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	import starling.Game;
	import starling.animation.Transitions;
	import starling.assets.AssetManager;
	import starling.components.Actor;
	import starling.components.ButtonPanel;
	import starling.components.ComplexButton;
	import starling.components.DigitDisplay;
	import starling.components.ScratchRevealBonusGame;
	import starling.components.ScratchRevealIcon;
	import starling.components.VideoKeno.VideoKenoBall;
	import starling.components.VideoKeno.VideoKenoNumber;
	import starling.components.WordBalloon;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.ClippedSprite;
	import starling.extensions.PDParticleSystem;
	import starling.interfaces.IScratchRevealBonusGameHandler;
	import starling.text.TextField;

	import utils.ArrayHelper;
	import utils.DebugHelper;
	import utils.MathHelper;

	public class VideoKenoSkin_Aladdin extends VideoKenoSkin implements IScratchRevealBonusGameHandler
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( VideoKenoSkin_Aladdin );

		// UI Components
		private var actGenie:Actor;
		private var actLamp:Actor;
		private var actSmoke:Actor;
		private var actLampSmoke:Actor;
		private var mcYouWon:MovieClip;
		private var srBonusGame:ScratchRevealBonusGame;
		private var imgBorder:Image;
		private var wbGenie:WordBalloon;
		private var imgWinsEntriesBar:Image;
		private var bonusBallParticleSystem:PDParticleSystem;
		private var paytableParticleSystem:PDParticleSystem;

		// Gamestate Variables
		private var _highlightIndex:int;

		// Objects and Managers
		private var _bonusGameCompletedCallback:Function;
		private var _bonusGameCompletedArgs:Array;

		public static function appendRequiredAssets( assetManager:AssetManager ):void
		{
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_ATLAS, "ButtonPanelAtlas" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_ATLAS, "BonusSymbolAtlas" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_ATLAS, "TextureAtlas" );

			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "lose" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "number_deselected" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "number_disabled" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "number_hit" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "number_selected" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "reveal_numbers" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "win" )
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "background" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "ball_released" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SOUND, "reveal_bonus" );

			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SWF, "Genie1" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SWF, "Lamp_Solo" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SWF, "Misty_Smoke" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_SWF, "Lamp_Smoke" );

			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_PS, "bonusBallParticle" );
			assetManager.addAssetToLoad( AssetManager.ASSET_TYPE_PS, "paytableParticle" );
		}

		public function VideoKenoSkin_Aladdin( game:Game, assetManager:AssetManager )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );

			super( game, assetManager );

			// Clear Context
			logger.popContext();
		}

		override protected function initUI():void
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
			btnClear.x = 434;
			btnClear.y = 151;
			addChild( btnClear );

			// Button container
			grpNumbers = new Sprite();
			grpNumbers.width = 440;
			grpNumbers.height = 352;
			grpNumbers.x = 310;
			grpNumbers.y = 181;
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
						_assetManager.getTexture( "Number_GameSelected" ),
						_assetManager.getTexture( "Number_Hit" )
					);
					btn.x = col * 31;
					btn.y = row * 29;
					btn.fontSize = 12;
					btn.fontColor = 0xffde00;
					btn.fontBold = true;
					grpNumbers.addChild( btn );
				}
			}

			// Hit indicators
			grpLayerHits = new Sprite();
			grpLayerHits.width = 440;
			grpLayerHits.height = 352;
			grpLayerHits.x = 310;
			grpLayerHits.y = 181;
			addChild( grpLayerHits );

			// Balls
			grpBalls = new Sprite();
			grpBalls.width = 800;
			grpBalls.height = 600;
			grpBalls.x = 0;
			grpBalls.y = 0;
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
//			imgPaytable = new Image( _assetManager.getTexture( "Paytable" ) );
//			grpPaytable.addChild( imgPaytable );

			// Digit Displays
			ddPicks = new DigitDisplay( 40, 30, 0, false, "digital7", 22 );
			ddPicks.x = 384;
			ddPicks.y = 149;
			addChild( ddPicks );

			ddHits = new DigitDisplay( 40, 30, 0, false, "digital7", 22 );
			ddHits.x = 540;
			ddHits.y = 149;
			addChild( ddHits );

			// PayTables
			grpPayouts = new Sprite();
			grpPayouts.width = 100;
			grpPayouts.height = 294;
			grpPayouts.x = 679;
			grpPayouts.y = 118;
			addChild( grpPayouts );

			grpHits = new Sprite();
			grpHits.width = 50;
			grpHits.height = 294;
			grpHits.x = 0;
			grpHits.y = 5;
			grpPayouts.addChild( grpHits );

			grpPays = new Sprite();
			grpPays.width = 50;
			grpPays.height = 294;
			grpPays.x = 50;
			grpPays.y = 5;
			grpPayouts.addChild( grpPays );

			var dsFilter:DropShadowFilter = new DropShadowFilter( 1, 45, 0x000000 );
			for( var i:int = 0; i < 10; i++ )
			{
				var lblHit:TextField = new TextField( 50, 18, "-", "Verdana", 14, 0xFFFFFF );
				lblHit.x = 0;
				lblHit.y = i * 24;
				lblHit.height = 24;
				lblHit.nativeFilters = [dsFilter];
				grpHits.addChild( lblHit );

				var lblPay:TextField = new TextField( 50, 18, "-", "Verdana", 14, 0xFFFFFF );
				lblPay.x = 0;
				lblPay.y = i * 24;
				lblPay.height = 24;
				lblPay.nativeFilters = [dsFilter];
				grpPays.addChild( lblPay );
			}

			// Genie
			actGenie = new Actor( 300, 560 );
			actGenie.touchable = false;
//			actGenie.addStaticImage( _assetManager.getTexture( "Keno Interface_00005" ) );
			actGenie.addAnimation( "Genie1", _assetManager.getSWF( "Genie1" ) );
			actGenie.x = 0;
			actGenie.y = 0;
			actGenie.playAnimation( "Genie1", 0 );
			addChild( actGenie );

			// Bonus Game
			srBonusGame = new ScratchRevealBonusGame( this, _game, _assetManager );
			srBonusGame.x = 290;
			srBonusGame.y = 85;
			srBonusGame.alpha = 0;
			srBonusGame.visible = false;
			addChild( srBonusGame );

			// Word Balloon
			wbGenie = new WordBalloon( _assetManager.getTexture( "DialogBalloon" ), "", new Rectangle( 24, 22, 142, 66 ) );
			wbGenie.x = 166;
			wbGenie.y = 4;
			wbGenie.visible = false;
			addChild( wbGenie);

			// Smoke
			actSmoke = new Actor( 800, 250 );
			actSmoke.touchable = false;
//			actSmoke.addStaticImage( _assetManager.getTexture( "Keno Interface_00005" ) );
			actSmoke.addAnimation( "Smoke", _assetManager.getSWF( "Misty_Smoke" ) );
			actSmoke.x = 0;
			actSmoke.y = 260;
			actSmoke.alpha = 0.75;
			actSmoke.playAnimation( "Smoke", 0 );
			addChild( actSmoke );

			// Lamp
			actLamp = new Actor( 330, 240 );
			actLamp.touchable = false;
//			actLamp.addStaticImage( _assetManager.getTexture( "Keno Interface_00005" ) );
			actLamp.addAnimation( "Lamp", _assetManager.getSWF( "Lamp_Solo" ) );
			actLamp.x = 0;
			actLamp.y = 310;
			actLamp.playAnimation( "Lamp", 0 );
			addChild( actLamp );

			// Lamp Smoke
			actLampSmoke = new Actor( 120, 220 );
			actLampSmoke.touchable = false;
//			actLampSmoke.addStaticImage( _assetManager.getTexture( "Keno Interface_00005" ) );
			actLampSmoke.addAnimation( "LampSmoke", _assetManager.getSWF( "Lamp_Smoke" ) );
			actLampSmoke.x = 228;
			actLampSmoke.y = 220;
			actLampSmoke.visible = false;
			addChild( actLampSmoke );

			// Wins & Entries Bar
			imgWinsEntriesBar = new Image( _assetManager.getTexture( "WinsEntriesBar" ) );
			imgWinsEntriesBar.touchable = false;
			imgWinsEntriesBar.x = 297;
			imgWinsEntriesBar.y = 425;
			addChild( imgWinsEntriesBar );

			ddWinAmount = new DigitDisplay( 61, 16, 0, true, "digital7", 20 );
			ddWinAmount.x = 367;
			ddWinAmount.y = 448;
			addChild( ddWinAmount );

			ddBetAmount = new DigitDisplay( 61, 16, 0, true, "digital7", 20 );
			ddBetAmount.x = 540;
			ddBetAmount.y = 448;
			addChild( ddBetAmount );

			// Border
			imgBorder = new Image( _assetManager.getTexture( "Border" ) );
			imgBorder.touchable = false;
			addChild( imgBorder );

			// Button Panel
			btnPanel = new ButtonPanel( ButtonPanel.MENU_TYPE_VIDEO_KENO_QP, _game, _assetManager );
			btnPanel.x = 0;
			btnPanel.y = 470;
			addChild( btnPanel );

			// You Won
			mcYouWon = new MovieClip( _assetManager.getTextures( "YouWon", "TextureAtlas" ) );
			mcYouWon.touchable = false;
			mcYouWon.x = grpNumbers.x + ( grpNumbers.width >> 1 ) - ( mcYouWon.width >> 1 );
			mcYouWon.y = grpNumbers.y + ( grpNumbers.height >> 1 ) - ( mcYouWon.height >> 1 );
			addChild( mcYouWon );

			// Clear Context
			logger.popContext();
		}

		override public function animateBalls( phase:int = 1, pickNumbers:Array = null, ballInPlaceCallback:Function = null ):void
		{
			// Log Activity
			logger.pushContext( "animateBalls", arguments );
			var ball:VideoKenoBall;
			var num:VideoKenoNumber;
			var index:int;

			var baseDelay:Number;
			var seqDelay:Number = 0.5;
			var addDelay:Number = 0.005;
			var flightTime:Number = 0.75;

			var peakY:Number;
			var vallY:Number;
			var distUp:Number;
			var distDown:Number;

			var imgPrefix:String;

			_ballInPlaceCallback = ballInPlaceCallback;

			if( phase == 1 && pickNumbers != null )
			{
				actLampSmoke.playAnimation( "LampSmoke", 0 );
				actLampSmoke.visible = true;

				for( index = 0; index < pickNumbers.length; index++ )
				{
					imgPrefix = index < pickNumbers.length - 1 ? "Ball" : "BallBonus";

					ball = new VideoKenoBall( _assetManager.getTexture( imgPrefix ), pickNumbers[index], 8, _assetManager.getTexture( imgPrefix + "_Shadow" ) );
					ball.x = 280 + ( ball.width >> 2 );
					ball.y = 420 + ( ball.height >> 2 );
					ball.toggleLabel( false );
					ball.visible = false;
					ball.isBonusBall = ( imgPrefix == "BallBonus" );
					grpBalls.addChild( ball );

					num = grpNumbers.getChildAt( ball.value - 1 ) as VideoKenoNumber;
					baseDelay = index * seqDelay;
					seqDelay += addDelay;

					if( ball.isBonusBall )
					{
						flightTime *= 2;
					}

					// Rise
					peakY = ( grpNumbers.y + num.y + ( ball.height >> 1 ) ) - utils.MathHelper.randomNumber( 50, 150 );
					distUp = ball.y - peakY;
					Starling.juggler.tween( ball, flightTime, {
						transition: starling.animation.Transitions.EASE_OUT,
						y: peakY,
						delay: baseDelay,
						onStart: ball_moveStartHander,
						onStartArgs: [ball],
						onUpdate: ball_moveUpdateHandler,
						onUpdateArgs: [ball]
					});

					// Fall
					vallY = grpNumbers.y + num.y + ( ball.height >> 1 );
					distDown = vallY - peakY;
					Starling.juggler.tween( ball, flightTime, {
						transition: starling.animation.Transitions.EASE_IN,
						y: vallY,
						delay: baseDelay + flightTime,
						onUpdate: ball_moveUpdateHandler,
						onUpdateArgs: [ball]
					});

					// Move Right
					Starling.juggler.tween( ball, flightTime + flightTime, {
						transition: starling.animation.Transitions.LINEAR,
						x: grpNumbers.x + num.x + ( ball.width >> 1 ),
						delay: baseDelay,
						onUpdate: ball_moveUpdateHandler,
						onUpdateArgs: [ball],
						onComplete: ball_moveEndHandler,
						onCompleteArgs: [ball, true, false]
					});

					// Fade Out
					Starling.juggler.tween( ball, 0.50, {
						transition: starling.animation.Transitions.LINEAR,
						alpha: 0,
						delay: baseDelay + flightTime + flightTime
					});

					// Position
					Starling.juggler.tween( ball, 0.01, {
						x: 338 + ( ball.width >> 1 ) + ( index * 12.5 ) - ( index % 2 != 0 ? 12.5 : 0 ),
						y: 96 + ( ball.width >> 1 ) + ( index % 2 == 0 ? 0 : 26 ),
						delay: baseDelay + flightTime + flightTime + 0.50
					});

					// Fade In
					Starling.juggler.tween( ball, 1.00, {
						transition: starling.animation.Transitions.LINEAR,
						alpha: 1,
						delay: baseDelay + flightTime + flightTime + 0.50 + 0.01,
						onComplete: ball_moveEndHandler,
						onCompleteArgs: [ball, false, true]
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

		override protected function ball_moveEndHandler( ball:VideoKenoBall, hitPhase:Boolean = true, endPhase:Boolean = true ):void
		{
			// Log Activity
			logger.pushContext( "ball_moveEndHandler", arguments );

			if( ball.isBonusBall && bonusBallParticleSystem )
			{
				ball.removeChild( bonusBallParticleSystem );
				bonusBallParticleSystem.stop();

				setTimeout( function():void {
					Starling.juggler.remove( bonusBallParticleSystem );
					bonusBallParticleSystem = null;
				}, bonusBallParticleSystem.lifespan * 1000 );
			}
			ball.toggleLabel( true );
			super.ball_moveEndHandler( ball, hitPhase, endPhase );

			// Clear Context
			logger.popContext();
		}

		override protected function ball_moveStartHander( ball:VideoKenoBall ):void
		{
			ball.visible = true;
			assets.SoundManager.playSound( _assetManager.getSound( "ball_released" ), 0, 1 );

			if( ball.isBonusBall )
			{
				// Stop the lamp smoke
				actLampSmoke.stop( false );
				actLampSmoke.visible = false;

				// Create the particle system for the bonus ball
				var ps:Object = _assetManager.getParticleSystem( "bonusBallParticle" );

				bonusBallParticleSystem = new PDParticleSystem( ps.pex, ps.tex );
				bonusBallParticleSystem.emitterX = ball.x;
				bonusBallParticleSystem.emitterY = ball.y;
				addChild( bonusBallParticleSystem );

				bonusBallParticleSystem.start();
				Starling.juggler.add( bonusBallParticleSystem );
			}
		}

		override protected function ball_moveUpdateHandler( ball:VideoKenoBall ):void
		{
			var moved:Number = ball.x - ( ( ball.width >> 1 ) + 424 );
			var cir:Number = Math.PI * 32;
			var rot:Number = moved / cir;

			ball.rotation = ( ( rot * 360 ) * Math.PI ) / 180;

			if( ball.isBonusBall && bonusBallParticleSystem )
			{
				bonusBallParticleSystem.emitterX = ball.x;
				bonusBallParticleSystem.emitterY = ball.y;
				bonusBallParticleSystem.emitAngle = ball.rotation;
			}
		}

		override public function displayPayouts( payoutTable:Array, betAmount:Number ):void
		{
			// Log Activity
			logger.pushContext( "displayPayouts", arguments );

			// Create the particle system for the bonus ball
			var ps:Object = _assetManager.getParticleSystem( "paytableParticle" );

			paytableParticleSystem = new PDParticleSystem( ps.pex, ps.tex );
			paytableParticleSystem.startSize *= 1.5;
			paytableParticleSystem.emitterX = grpPayouts.x + ( grpPayouts.width >> 1 );
			paytableParticleSystem.emitterY = grpPayouts.y + ( grpPayouts.height >> 1 );
			addChild( paytableParticleSystem );

			paytableParticleSystem.start( 0.250 );
			Starling.juggler.add( paytableParticleSystem );

			function temp(sys:PDParticleSystem):void
			{
				setTimeout( function():void {
					sys.stop( false );
				}, 250 );

				setTimeout( function():void {
					removeChild( sys );
					Starling.juggler.remove( sys );
				}, 1250 );
			}( paytableParticleSystem );

			// Call our super method
			super.displayPayouts( payoutTable, betAmount );

			// Clear Context
			logger.popContext();
		}

		override public function displayPrizeHighlight( highlightIndex:int ):void
		{
			// Log Activity
			logger.pushContext( "displayPrizeHighlight", arguments );
			mcYouWon.visible = true;
			mcYouWon.addEventListener( starling.events.Event.COMPLETE, function (event:starling.events.Event ):void {
				mcYouWon.removeEventListener( starling.events.Event.COMPLETE, arguments.callee );
				mcYouWon.visible = false;
				Starling.juggler.remove( mcYouWon );
			} );
			mcYouWon.play();
			Starling.juggler.add( mcYouWon );

			this._highlightIndex = highlightIndex;
			togglePrizeHighlight( true );

			// Clear Context
			logger.popContext();
		}

		override public function togglePrizeHighlight( visible:Boolean ):void
		{
			( grpHits.getChildAt( _highlightIndex ) as TextField ).color = visible ? 0xFFDE00 : 0xFFFFFF;
			( grpPays.getChildAt( _highlightIndex ) as TextField ).color = visible ? 0xFFDE00 : 0xFFFFFF;
		}

		override public function loadBonusGame( betAmount:int, winAmount:Number, bonusAmount:Number, bonusGameCompletedCallback:Function, bonusGameCompletedArgs:Array ):void
		{
			// Log Activity
			logger.pushContext( "loadBonusGame", arguments );

			// Save the callback info
			_bonusGameCompletedCallback = bonusGameCompletedCallback;
			_bonusGameCompletedArgs = bonusGameCompletedArgs;

			// Setup the payout displays
			var possibleWins:Array = [2, 3, 4, 5];
			ArrayHelper.randomize( possibleWins.splice( possibleWins.indexOf( bonusAmount ), 1 ) );
			srBonusGame.setParameters( betAmount * winAmount, [bonusAmount], possibleWins );
			srBonusGame.resetAndPlay();

			// Fade in the bonus game UI
			srBonusGame.alpha = 0;
			srBonusGame.visible = true;
			Starling.juggler.tween( srBonusGame, 1, {
				alpha: 1,
				onComplete: function():void {
					Starling.juggler.removeTweens( srBonusGame );
				}
			});

			// Make the Genie speak
			wbGenie.visible = true;
			wbGenie.say( "Choose a lamp and multiply your win!", 2000 );

			// Clear Context
			logger.popContext();
		}

		/*
		--------------------
		IScratchRevealBonusGameHandler interface implementation
		--------------------
		*/
		public function onBonusIconClicked( icon:ScratchRevealIcon ):void
		{
			// Log Activity
			logger.pushContext( "onBonusIconClicked", arguments );

			SoundManager.playSound( _assetManager.getSound( "reveal_bonus" ), 0, 1 );

			wbGenie.say( "Let me work my magic...", 50, 0, true, function():void {
				wbGenie.say( "ABRACADABRA!", 50, 250, false );
			} );

			// Clear Context
			logger.popContext();
		}

		public function onBonusIconRevealed( icon:ScratchRevealIcon ):void
		{
			// Log Activity
			logger.pushContext( "onBonusIconRevealed", arguments );

			wbGenie.say( "Ah ha! Very good!", 100 );

			// Clear Context
			logger.popContext();
		}

		public function onBonusWinningsDisplay():void
		{
			// Log Activity
			logger.pushContext( "onBonusWinningsDisplay", arguments );

			wbGenie.say( "Now, let's see what was behind the other lamps...", 1000, 0, false, srBonusGame.revealPossible );

			// Clear Context
			logger.popContext();
		}

		public function onBonusPossibleRevealed():void
		{
			// Log Activity
			logger.pushContext( "onBonusPossibleRevealed", arguments );

			wbGenie.say( "May your luck continue on your next game!", 100, 0, true, function():void {

				_bonusGameCompletedCallback.apply( null, _bonusGameCompletedArgs );

				// Fade out the bonus game UI
				Starling.juggler.tween( srBonusGame, 3, {
					alpha: 0,
					onComplete: function():void {
						Starling.juggler.removeTweens( srBonusGame );
						srBonusGame.alpha = 1;
						srBonusGame.visible = false;
					}
				});

				// Fade out the word balloon
				Starling.juggler.tween( wbGenie, 5, {
					alpha: 0,
					onComplete: function():void {
						Starling.juggler.removeTweens( wbGenie );
						wbGenie.alpha = 1;
						wbGenie.visible = false;
					}
				});
			} );

			// Clear Context
			logger.popContext();
		}
	}
}