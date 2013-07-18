package starling
{
	import assets.Config;
	import assets.DataTimer;
	import assets.Images;
	import assets.SoundManager;
	
	import components.ProgressiveJackpot;
	
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import interfaces.IDisposable;
	
	import mx.core.UIComponent;
	import mx.events.EffectEvent;
	
	import objects.ErrorMessage;
	import objects.PlayGameResponse;
	
	import services.SweepsAPI;
	
	import starling.animation.Transitions;
	import starling.assets.AssetManager;
	import starling.components.ButtonPanel;
	import starling.components.ComplexButton;
	import starling.components.DigitDisplay;
	import starling.components.VideoKeno.VideoKenoBall;
	import starling.components.VideoKeno.VideoKenoNumber;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ClippedSprite;
	import starling.interfaces.IAssetManagerHandler;
	import starling.skins.VideoKenoSkin;
	import starling.skins.VideoKenoSkin_Aladdin;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import utils.ArrayHelper;
	import utils.DebugHelper;
	import utils.MathHelper;

	/**
	 * Starling-Based Video Keno
	 */
	public class StarlingVideoKeno extends Game
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( StarlingVideoKeno );

		// UI Components
		private var _skin:VideoKenoSkin;

		// Objects and Managers
		private var _flasher:Timer;
		private var _backgroundSound:SoundChannel;

		// Configuration Variables
		private var _betAmounts:Array = [20, 30, 50, 100, 200, 300, 500];
		private var _betAmountStep:int = 0;
		private var _qpAmounts:Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
		private var _qpAmountStep:int = 9;
		private var _selNumbers:Array = [];
		private var _pickNumbers:Array = [];
		private var _winAmounts:Array = [];

		// Gamestate Variables
		private var _baseWin:Number = 0.0;
		private var _bonusWin:Number = 0.0;
		private var _totalWin:Number = 0.0;
		private var _lastLineWins:int = 0;
		private var _msAPIStart:Number;
		private var _serverEntries:int;
		private var _serverWinnings:int;
		private var _achievementsEarned:Array;

		private var _spinning:int = 0;
		private var _autoPlay:Boolean = false;
		private var _autoSpinTimeout:uint = uint.MIN_VALUE;
		private var _isReset:Boolean = false;
		private var _bonusBallHit:Boolean = false;

		public function StarlingVideoKeno()
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );

			super();

			// Clear Context
			logger.popContext();
		}

		override protected function init( event:Event ):void
		{
			// Log Activity
			logger.pushContext( "init", arguments );

			// Call our super method
			super.init( event );

			// Configuration the application assets and variables
			_assetManager = new AssetManager( Sweeps.AssetsLocation + "/VideoKeno/" + Sweeps.GameName + "/", this );
			switch ( Sweeps.GameName )
			{
				case assets.Config.DEFAULT_VIDEO_KENO:
				case assets.Config.VIDEO_KENO:
					// Add assets to load
					VideoKenoSkin.appendRequiredAssets( _assetManager );

					_winAmounts = [
						[], //0
						[0, 3.5], //1
						[0, 0, 14.5], //2
						[0, 0, 1, 53], //3
						[0, 0, 1, 6, 135], //4
						[0, 0, 0, 1, 50, 300], //5
						[0, 0, 0, 1, 7, 150, 600], //6
						[0, 0, 0, 0, 1, 60, 400, 700], //7
						[0, 0, 0, 0, 0, 25, 150, 400, 700], //8
						[0, 0, 0, 0, 0, 10, 70, 240, 300, 700], //9
						[0, 0, 0, 0, 0, 5, 30, 150, 250, 400, 700], //10
						[0, 0, 0, 0, 0, 0, 18, 100, 350, 400, 500, 700], //11
						[0, 0, 0, 0, 0, 0, 10, 60, 115, 180, 250, 400, 700], //12
						[1, 0, 0, 0, 0, 0, 8, 16, 110, 150, 200, 250, 600, 750], //13
						[3, 0, 0, 0, 0, 0, 5, 16, 32, 85, 160, 250, 350, 700, 900], //14
						[5, 0, 0, 0, 0, 0, 0, 15, 25, 130, 250, 350, 750, 850, 900, 1000], //15
					];
					break;

				case assets.Config.ALADDINS_KENO:
					// Add assets to load
					VideoKenoSkin_Aladdin.appendRequiredAssets( _assetManager );
					_loadingBackground = Images.Aladdin_Loading_Screen;
					
					_winAmounts = [
						[], //0
						[0, 2.5], //1
						[0, 0, 11.5], //2
						[0, 0, 0.5, 46], //3
						[0, 0, 0.5, 5, 125], //4
						[0, 0, 0, 0.5, 40, 300], //5
						[0, 0, 0, 0.5, 4, 150, 600], //6
						[0, 0, 0, 0, 0.5, 45, 400, 700], //7
						[0, 0, 0, 0, 0, 20, 100, 400, 700], //8
						[0, 0, 0, 0, 0, 5, 70, 240, 300, 700], //9
						[0, 0, 0, 0, 0, 3, 25, 150, 250, 400, 700], //10
						[0, 0, 0, 0, 0, 0, 10, 100, 350, 400, 500, 700], //11
						[0, 0, 0, 0, 0, 0, 7, 50, 110, 180, 250, 400, 700], //12
						[0, 0, 0, 0, 0, 0, 6, 12, 100, 150, 200, 350, 600, 750], //13
						[0, 0, 0, 0, 0, 0, 4, 10, 32, 85, 160, 250, 350, 700, 900], //14
						[0, 0, 0, 0, 0, 0, 0, 10, 25, 130, 250, 350, 750, 850, 900, 1000], //15
					];
					break;
			}

			// Load assets
			_assetManager.loadAssets();

			// Clear Context
			logger.popContext();
		}

		override protected function continueLoadingGame():void
		{
			// Log Activity
			logger.pushContext( "continueLoadingGame", arguments );

			if( _gameLoaded )
			{
				// Clear Context
				logger.popContext();
				return;
			}
			_gameLoaded = true;

			// Call our super method
			super.continueLoadingGame();

			// Setup a timer to display the prize amount
			_flasher = new Timer( 500, 0 );
			_flasher.addEventListener( TimerEvent.TIMER, flasherFired );

			// Init the UI
			switch( Sweeps.GameName )
			{
				case assets.Config.DEFAULT_VIDEO_KENO:
				case assets.Config.VIDEO_KENO:
					_skin = new VideoKenoSkin( this, _assetManager );
					break;

				case assets.Config.ALADDINS_KENO:
					_skin = new VideoKenoSkin_Aladdin( this, _assetManager );
					break;
			}

			// Assign UI click handlers
			_skin.btnClear.addEventListener( Event.TRIGGERED, btnClear_clickHandler );
			for( var i:int = 0; i < _skin.grpNumbers.numChildren; i++ )
			{
				VideoKenoNumber( _skin.grpNumbers.getChildAt( i ) ).addEventListener( starling.events.Event.TRIGGERED, btnNumber_clickHandler );
			}
			addChild( _skin );

			// Default the win and current bet amounts
			resetPrize();
			displayBetAmount();

			_skin.btnPanel.betAmount = getBetAmount();
			_skin.btnPanel.displayBetAmount();

			_skin.btnPanel.quickPickAmount = getQuickPickAmount();
			_skin.btnPanel.displayQuickPickAmount();

			// Disable the Auto Play and Reveal buttons
			_skin.btnPanel.toggleAutoPlayEnabled( false );
			_skin.btnPanel.togglePlayEnabled( false );

			// Enable the main panel
			Sweeps.getInstance().setInAction( false );

			// Play the background audio
			_backgroundSound = SoundManager.toggleSound( _assetManager.getSound( "background" ), _backgroundSound, true, true, 50, int.MAX_VALUE, 250, 25 );

			// Clear Context
			logger.popContext();
		}

		/** Handles the 'firing' event of flasherFired timer */
		private function flasherFired( event:TimerEvent ):void
		{
			_skin.togglePrizeHighlight( ( event.target as Timer ).currentCount % 2 == 0 ? true : false );
		}

		/** Returns the bet amount */
		private function getBetAmount():int
		{
			return _betAmounts[_betAmountStep];
		}

		/** Returns the quick pick amount */
		private function getQuickPickAmount():int
		{
			return _qpAmounts[_qpAmountStep];
		}

		/** Stops auto play */
		private function stopAutoPlay():void
		{
			// Log Activity
			logger.pushContext( "stopAutoPlay", arguments );

			_autoPlay = false;
			_skin.btnPanel.stopAutoPlay();

			// Clear Context
			logger.popContext();
		}

		/** Checks to see if we should auto play again */
		private function checkAutoSpin():void
		{
			// Log Activity
			logger.pushContext( "checkAutoSpin", arguments );

			// Clear any autoplay timeouts
			clearTimeout( _autoSpinTimeout );
			_autoSpinTimeout = uint.MIN_VALUE;

			if( _autoPlay && !_spinning )
			{
				spin();
			}

			// Clear Context
			logger.popContext();
		}

		/** Starts a play */
		private function spin():void
		{
			// Log Activity
			logger.pushContext( "spin", arguments );

			// Clear any autoplay timeouts
			clearTimeout( _autoSpinTimeout );
			_autoSpinTimeout = uint.MIN_VALUE;

			// Make sure we've selected at least 1 number
			if( _selNumbers.length == 0 )
			{
				// Clear Context
				logger.popContext();
				return;
			}

			// Initialize a few variables we'll be using more than once
			var i:int = 0;
			var num:int = 0;


			// Reset the prize display
			resetPrize();

			// Check to see if we have enough credits to pay for this spin/bet
			if( getBetAmount() <= Sweeps.Entries )
			{
				// Decrement our entries amount
				Sweeps.getInstance().displayBalance( Sweeps.Entries - getBetAmount(), Sweeps.Winnings );

				// Call the spin start handler to disable buttons, etc
				spinStarted();

				// Set a spinning count so we can keep tracking if we're still spinning or not
				_spinning = 20;

				// Check if in DEBUG Mode
				if( Sweeps.DEBUG && !Sweeps.DEBUG_W_API )
				{
					// Update our progressive jackpot
					SweepsAPI.progressiveBalanceDemo += Math.ceil( getBetAmount() * ProgressiveJackpot.JACKPOT_BET_PERCENTAGE );
					Sweeps.getInstance().displayProgressiveBalance( SweepsAPI.progressiveBalanceDemo, true );
					Sweeps.getInstance().spinProgressiveReel( -1 );

					// Save our achievements earned for this spin
					_achievementsEarned = null;

					// Default our current win amount
					_totalWin = 0.0;
					_baseWin = 0.0;
					_bonusWin = 0.0;
					_serverEntries = Sweeps.Entries;
					_serverWinnings = Sweeps.Winnings;

					// Randomly choose 20 numbers
					_pickNumbers = [];
					for( i = 0; i < 20; i++ )
					{
						num = MathHelper.randomNumber( 1, 80 );
						while( _pickNumbers.indexOf( num ) >= 0 )
						{
							num = MathHelper.randomNumber( 1, 80 );
						}

						_pickNumbers.push( num );
					}

					_lastLineWins = 0;
					setTimeout( revealPickNumbers, 450 );
				}
				else
				{
					// Save the current ms
					_msAPIStart = flash.utils.getTimer();

					// Call the 'Play Game' API event to get our results
					SweepsAPI.playGame(
						Sweeps.Username,
						Sweeps.Password,
						Sweeps.GameID,
						Sweeps.GameType,
						getBetAmount(),
						_selNumbers.length,
						0,
						handlePlayGameSuccess,
						handlePlayGameError
					);
				}
			}
			else
			{
				// If we're on auto play, make sure to stop it.
				stopAutoPlay();

				// Check to see if we have enough winnings that we could redeem to complete this spin
				if( getBetAmount() <= ( Sweeps.Entries + Sweeps.Winnings ) )
				{
					// Check to see if auto-redeem enabled
					if( Sweeps.AutoRedeemEnabled && Sweeps.Winnings >= 100 )
					{
						var redeemAmount:int = ((getBetAmount() - Sweeps.Entries) <= 100) ? 100 : getBetAmount() - Sweeps.Entries;

						// Send the request to the service API and handle response
						SweepsAPI.redeemEntries( Sweeps.Username, Sweeps.Password, Sweeps.Entries, Sweeps.Winnings, redeemAmount, handleRedeemSuccess, handleRedeemError );
					}
					else
					{
						// Reset the button panel
						spinEnded();

						Sweeps.getInstance().loadRedeemQuick();
					}
				}
				else
				{
					// Reset the button panel
					spinEnded();

					Sweeps.getInstance().createPopUp( "Insufficient Entries", "You do not have enough entries to complete this round.", false, false );
				}
			}

			// Clear Context
			logger.popContext();
		}

		/** Handles success for the SweepsAPI.redeemEntries call */
		private function handleRedeemSuccess( entries:int, winnings:int ):void
		{
			// Log Activity
			logger.pushContext( "handleRedeemSuccess", arguments );

			// Refresh the account balances
			Sweeps.getInstance().displayBalance( entries, winnings );

			// Re-spin
			spin();

			// Clear Context
			logger.popContext();
		}

		/** Handles error for the SweepsAPI.redeemEntries call */
		private function handleRedeemError( errorCode:int, error:String ):void
		{
			// Log Activity
			logger.pushContext( "handleRedeemError" ).error.apply( null, arguments );

			var pTitle:String;
			var pMessage:String;
			var pIsLogout:Boolean = false;
			var pIsError:Boolean = false;

			switch( errorCode )
			{
				case SweepsAPI.ERROR_CODE_UNAUTHORIZED:
					pTitle = "Unauthorized";
					pMessage = "We're sorry, but your account can only be logged in to one computer at a time.";
					pIsLogout = true;
					break;

				case SweepsAPI.ERROR_CODE_INSUFFICIENT_ENTRIES:
					pTitle = "Insufficient Entries";
					pMessage = "We're sorry, but it appears your entries were out of sync with the server.\n\nWe have updated your balances and you may continue playing.";
					pIsError = true;
					break;

				default:
					pTitle = "Oops!";
					pMessage = "We're sorry, but there was an issue while trying to complete this request.\n\nPlease try again.";
					pIsError = true;
					break;
			}

			// Reset the button panel
			spinEnded();

			// Create a popup
			Sweeps.getInstance().createPopUp( pTitle, pMessage, pIsError, pIsLogout );

			// Clear Context
			logger.popContext();
		}

		/** Handles success for the SweepsAPI.playGame call */
		private function handlePlayGameSuccess( response:PlayGameResponse ):void
		{
			// Log Activity
			logger.pushContext( "handlePlayGameSuccess", arguments );

			if( response.ReelOutput != null )
			{
				// Updates the progressive balance && spins the reel
				Sweeps.getInstance().displayProgressiveBalance( response.ProgressiveBalance, response.ProgressiveWin <= 0 );
				Sweeps.getInstance().spinProgressiveReel( response.ProgressiveWin );

				// Stop auto play if we've won the progressive
				if( response.ProgressiveWin > 0 )
				{
					stopAutoPlay();
				}

				// Save our achievements earned for this spin
				_achievementsEarned = response.Achievements;

				// Set our current win amount
				_totalWin = response.WinAmount + response.BonusAmount;
				_bonusWin = response.WinAmount > 0 ? ( response.BonusAmount + response.WinAmount ) / response.WinAmount : 1;
				_baseWin = _totalWin / _bonusWin;
				_serverEntries = response.Entries;
				_serverWinnings = response.Winnings;

				// Choose enough numbers to satisfy lineWins (if any)
				var numGood:Boolean = false;
				var num:int = 0;
				var i:int = 0;

				_pickNumbers = [];
				for( i = 0; i < response.LineWins; i++ )
				{
					while( !numGood )
					{
						num = _selNumbers[MathHelper.randomNumber( 0, _selNumbers.length - 1 )];
						numGood = _pickNumbers.indexOf( num ) == -1;
					}

					_pickNumbers.push( num );
					numGood = false;
				}

				// Fill in the rest of the 20 picks, after lineWins was satisifed
				for( i = response.LineWins; i < 20; i++ )
				{
					// Keep picking new numbers until we've chosen one that isn't already picked and is NOT in the user's list
					while( !numGood )
					{
						num = MathHelper.randomNumber( 1, 80 );
						numGood = _pickNumbers.indexOf( num ) == -1 && _selNumbers.indexOf( num ) == -1;
					}

					_pickNumbers.push( num );
					numGood = false;
				}

				// Randomize the pick numbers so not all of our "hits" happen at the start
				ArrayHelper.randomize( _pickNumbers );

				// Setup the play balls to reveal themselves
				var msAPIElapsed:Number = getTimer() - _msAPIStart;
				_lastLineWins = response.LineWins;
				setTimeout( revealPickNumbers, msAPIElapsed < 450 ? 450 - msAPIElapsed : 0 );
			}
			else
			{
				handlePlayGameError( SweepsAPI.ERROR_CODE_UNKNOWN, "Invalid Reel Output" );
			}

			// Clear Context
			logger.popContext();
		}

		/** Handles errors for the SweepsAPI.playGame call */
		private function handlePlayGameError( errorCode:int, error:String ):void
		{
			// Log Activity
			logger.pushContext( "handlePlayGameError" ).error.apply( null, arguments );

			// We've likely had an error and need to alert the player
			var pTitle:String;
			var pMessage:String;
			var pIsLogout:Boolean;

			switch( errorCode )
			{
				case SweepsAPI.ERROR_CODE_UNAUTHORIZED:
					pTitle = "Unauthorized";
					pMessage = "We're sorry, but your account can only be logged in to one computer at a time.";
					pIsLogout = true;
					break;

				case SweepsAPI.ERROR_CODE_INSUFFICIENT_ENTRIES:
					pTitle = "Insufficient Entries";
					pMessage = "We're sorry, but it appears your entries were out of sync with the server.\n\nWe have updated your balances and you may continue playing.";
					pIsLogout = true;
					break;

				default:
					pTitle = "Oops!";
					pMessage = "We're sorry, but there was an issue while trying to complete this round.\n\nPlease try again.";
					pIsLogout = true;
					break;
			}

			Sweeps.getInstance().createPopUp( pTitle, pMessage, false, pIsLogout );

			// If we're on auto play, make sure to stop it.
			stopAutoPlay();

			// Reset the button panel
			spinEnded();

			// Clear Context
			logger.popContext();
		}

		/** Creates our 20 ball graphics which contain the game's chosen numbers and animates them. */
		private function revealPickNumbers( phase:int = 1 ):void
		{
			// Log Activity
			logger.pushContext( "revealPickNumbers", arguments );

			if( phase == 1 )
			{
				// If we're supposed to get a bonus win, put one of our numbers at the end
				if( _bonusWin > 1.0 || ( _totalWin == 0.0 && MathHelper.randomNumber( 1, 3 ) == 1 ) )
				{
					// If the last number the game picked, isn't one of our selected numbers....
					if( _selNumbers.indexOf( _pickNumbers.slice( -1 ) ) < 0  )
					{
						// Get a list of numbers we're going to 'hit' on
						var matches:Array = _selNumbers.filter( function( num:int, index:int, arr:Array ):Boolean {
							return _pickNumbers.indexOf( num ) >= 0;
						});

						// If we have any matches, randomly place one at the end to be the bonus ball
						if( matches.length > 0 )
						{
							var bonusNumber:int = matches[MathHelper.randomNumber( 0, matches.length - 1 )];
							_pickNumbers.push( _pickNumbers.splice( _pickNumbers.indexOf( bonusNumber ), 1 )[0] );
						}
					}
				}
				// If we're not supposed to get a bonus win, make sure the purple ball isn't a 'HIT'
				else if( _bonusWin <= 1.0 && _totalWin > 0.0 )
				{
					while( _selNumbers.indexOf( _pickNumbers.slice( -1 )[0] ) >= 0 )
					{
						// Randomize our pick numbers until the last one isn't one of our selectd numbers
						ArrayHelper.randomize( _pickNumbers );
					}
				}

				// Play our reveal sound
				SoundManager.playSound( _assetManager.getSound( "reveal_numbers" ), 0, 0 );

				// Animate the balls
				_skin.animateBalls( phase, _pickNumbers, ball_moveEndHandler );
			}
			else
			{
				_skin.animateBalls( phase );
			}

			// Clear Context
			logger.popContext();
		}

		/** Handles the ball tween's complete event */
		protected function ball_moveEndHandler( ball:VideoKenoBall, hitPhase:Boolean = true, endPhase:Boolean = true ):void
		{
			// Log Activity
			logger.pushContext( "ball_moveEndHandler", arguments );

			// Get a reference to the ball and highlight the appropriate button
			var num:VideoKenoNumber = _skin.grpNumbers.getChildAt( ball.value - 1 ) as VideoKenoNumber;
			num.isGameSelected = true;

			if( hitPhase && num.isHit )
			{
				SoundManager.playShiftPitchSound( _assetManager.getSound( "number_hit" ), 0, 0, ball.isBonusBall ? 1.5 : 1.0 );

				var hit:MovieClip = new MovieClip( _assetManager.getTextures( "Hit_" ), 6 );
				hit.x = num.x;
				hit.y = num.y;
				hit.width = num.width;
				hit.height = num.height;

				_skin.grpLayerHits.addChild( hit );
				Starling.juggler.add( hit );
				displayHits( _selNumbers.length, _skin.grpLayerHits.numChildren );

				if( ball.isBonusBall )
				{
					_bonusBallHit = true;
				}
			}

			if( endPhase )
			{
				_spinning--;
				logger.debug( "Balls still animating: " + _spinning );

				if( _spinning == 0 )
				{
					revealPickNumbers( 2 );

					if( _achievementsEarned == null )
					{
						checkWin();
					}
					else
					{
						Sweeps.getInstance().addNewBadges( _achievementsEarned, checkWin );
					}
				}
			}

			// Clear Context
			logger.popContext();
		}

		/** Called when a spin is started to handle audio and notification events */
		private function spinStarted():void
		{
			// Log Activity
			logger.pushContext( "spinStarted", arguments );

			// Flip the reset flag
			_isReset = false;
			_bonusBallHit = false;

			// Remove all the current balls
			_skin.grpBalls.removeChildren( 0, -1, true );

			// Set our Sweeps inAction value
			Sweeps.getInstance().setInAction( true );

			// Disable clear button
			_skin.btnClear.enabled = false;

			if( !_autoPlay ) { _skin.btnPanel.toggleEnabled( false, true ); } else { _skin.btnPanel.toggleEnabled( false ); }

			// Clear Context
			logger.popContext();
		}

		/** Called when a spin is completed to handle audio and notification events */
		private function spinEnded():void
		{
			// Log Activity
			logger.pushContext( "spinEnded", arguments );

			// Clear some variables
			_spinning = 0;

			// Re-enable our button panel
			if( !_autoPlay )
			{
				_skin.btnClear.enabled = true;
				_skin.btnPanel.toggleEnabled( true );

				// Set our Sweeps inAction value
				Sweeps.getInstance().setInAction( false );
			}

			// Clear Context
			logger.popContext();
		}

		/** Returns the results of the current spin (all the icons on the screen) */
		private function getResults():Array
		{
			// Log Activity
			logger.pushContext( "getResults", arguments );

			var results:Array = [];
			for( var i:int = 0; i < _selNumbers.length; i++ )
			{
				var btn:VideoKenoNumber = _skin.grpNumbers.getChildAt( _selNumbers[i] - 1 ) as VideoKenoNumber;
				results.push( [btn.value, btn.isHit] );
			}

			// Clear Context
			logger.popContext();
			return results;
		}

		/** Checks to see if a given spin was a winner */
		private function checkWin( bonusPass:Boolean = false ):void
		{
			// Log Activity
			logger.pushContext( "checkWin", arguments );

			var calculatedWin:Number = 0;
			var results:Array = getResults();
			var winningIndex:int = -1;

			// Determine score
			var hits:int = results.filter( function filterResults( item:Array, index:int, arr:Array ):Boolean {
				return item[1] == true;
			} ).length;
			calculatedWin = _winAmounts[_selNumbers.length][hits];

			// Reset the win amount if in DEBUG mode
			if( Sweeps.DEBUG && !Sweeps.DEBUG_W_API )
			{
				_bonusWin = _bonusBallHit ? [2, 3, 4, 5][MathHelper.randomNumber( 0, 4 )] : 1.0;
				_baseWin = calculatedWin;
				_totalWin = calculatedWin * _bonusWin;
			}

			// Check to see if we've won anything or if we've calculated that we should've won something
			if( _baseWin > 0.0 )
			{
				// Verify our calculations match the API results
				if( _baseWin != calculatedWin )
				{
					var errMsg:ErrorMessage = Sweeps.getInstance().getErrorMessageBase( "VIDEOKENO:Calculated and Supplied Winnings do not match.", "", "", "" );
					errMsg.append( "REVEAL INFO", "User Picks: " + _selNumbers.toString() );
					errMsg.append( "REVEAL INFO", "Game Picks: " + _pickNumbers.toString() );
					errMsg.append( "REVEAL INFO", "Results: " + results.toString() );
					errMsg.append( "REVEAL INFO", "Hits (Server/Client): (" + _lastLineWins.toString() + "/" + hits.toString() + ")" );
					errMsg.append( "REVEAL INFO", "Calculated Winnings (Base/Bonus/Total): (" + calculatedWin.toString() + "/" + _bonusWin.toString() + "/" + ( calculatedWin * _bonusWin ).toString() + ")" );
					errMsg.append( "REVEAL INFO", "Supplied Winnings (Base/Bonus/Total): (" + _baseWin.toString() + "/" + _bonusWin.toString() + "/" + _totalWin.toString() + ")" );

					if( Sweeps.DEBUG && !Sweeps.DEBUG_W_API )
					{
						throw new Error( errMsg.toString() );
					}
					else
					{
						SweepsAPI.reportError( errMsg );
					}
				}

				winningIndex = _winAmounts[_selNumbers.length].indexOf( _baseWin );


				if( !_bonusBallHit || _bonusWin <= 1.0 || bonusPass )
				{
					SoundManager.playSound( _assetManager.getSound( "win" ), 150, 0 );
					displayPrizeHighlight( winningIndex );
					displayPrize( winningIndex, true );
				}
				else
				{
					SoundManager.playSound( _assetManager.getSound( "win" ), 150, 0 );
					displayPrize( winningIndex, false );
					stopAutoPlay();
					loadBonusGame();
				}
			}
			else
			{
				// The serverEntries/serverWinnings should contain the server's Winnings and Entries amounts
				Sweeps.getInstance().displayBalance( _serverEntries, _serverWinnings );

				SoundManager.playSound( _assetManager.getSound( "lose" ), 140, 0 );
				spinEnded();
				_autoSpinTimeout = setTimeout( checkAutoSpin, 2000 );
			}

			// Clear Context
			logger.popContext();
		}

		/** Handles loading the bonus game. **/
		private function loadBonusGame():void
		{
			// Log Activity
			logger.pushContext( "loadBonusGame", arguments );

			_skin.loadBonusGame( getBetAmount(), _baseWin, _bonusWin, checkWin, [true] );

			// Clear Context
			logger.popContext();
		}

		/** Handles highlighting the appropriate row on the pay table */
		private function displayPrizeHighlight( prizeIndex:int ):void
		{
			// Log Activity
			logger.pushContext( "displayPrizeHighlight", arguments );

			// Since the paytable only shows payouts > 0, we have to filter our winAmounts array down to those payouts
			// and then find the index of the paytable line, based on the filtered array and the supplied prizeIndex
			var winAmountsOverZero:Array = _winAmounts[_selNumbers.length].filter( function filterResults( item:int, index:int, arr:Array ):Boolean {
				return item > 0;
			} );
			var highlightIndex:int = ( winAmountsOverZero.length - 1 ) - winAmountsOverZero.indexOf( _winAmounts[_selNumbers.length][prizeIndex] );

			_skin.displayPrizeHighlight( highlightIndex );
			_flasher.start();

			// Clear Context
			logger.popContext();
		}

		/** Handles displaying the prize in the "Win" box on the game */
		private function displayPrize( prizeIndex:int, finalPass:Boolean = false ):void
		{
			// Log Activity
			logger.pushContext( "displayPrize", arguments );

			var possibleWins:Array = new Array();
			for( var i:int = 0; i < _betAmounts.length; i++ )
			{
				for( var x:int = 0; x < _winAmounts.length; x++ )
				{
					for( var y:int = 0; y < _winAmounts[x].length; y++ )
					{
						var possibleWin:int = _betAmounts[i] * _winAmounts[x][y];
						if( possibleWin > 0 && possibleWins.indexOf( possibleWin ) < 0 )
						{
							possibleWins.push( possibleWin );
						}
					}
				}
			}
			possibleWins.sort( Array.NUMERIC );

			var winAmount:int = _winAmounts[_selNumbers.length][prizeIndex] * getBetAmount() * ( finalPass ? _bonusWin : 1 );
			var winPercentage:Number = ( possibleWins.indexOf( winAmount ) + 1 ) / possibleWins.length;

			trace( possibleWins, winPercentage );

			var winningsChnl:SoundChannel = SoundManager.playSound( assets.Sounds["Add_Winnings"], 0, 0 );
			var winningsBdChnl:SoundChannel = SoundManager.playSound( assets.Sounds["Add_Winnings_Backdrop"], 0, 0 );

			// Animate the winning amount display
			_skin.ddWinAmount.animateDisplayAmount( winAmount, Math.ceil( 6 * winPercentage ) * 1000, function( dd:DigitDisplay ):void
			{
				// Stop the sounds
				if( winningsChnl != null && winningsBdChnl != null )
				{
					winningsChnl.stop();
					winningsBdChnl.stop();
				}

				if( finalPass )
				{
					spinEnded();

					_autoSpinTimeout = setTimeout( checkAutoSpin, 2000 );

					// Reset the win amounts if in DEBUG mode
					if( Sweeps.DEBUG && !Sweeps.DEBUG_W_API )
					{
						_serverEntries = Sweeps.Entries;
						_serverWinnings = Sweeps.Winnings + winAmount;
					}

					// The serverEntries/serverWinnings should contain the server's Winnings and Entries amounts
					Sweeps.getInstance().displayBalance( _serverEntries, _serverWinnings );
				}
			} );

			// Clear Context
			logger.popContext();
		}

		/** Resets the prize amounts */
		private function resetPrize():void
		{
			// Log Activity
			logger.pushContext( "resetPrize", arguments );

			// If the game hasn't been loaded, exit out
			if( !_gameLoaded )
			{
				return;
			}

			var i:int = 0;
			_isReset = true;

			// Stop the prize display flasher
			_flasher.stop();
			_skin.togglePrizeHighlight( false );

			// Reset the win amount and hit amounts
			_skin.ddWinAmount.displayAmount = 0;
			displayHits( _selNumbers.length, 0 );

			// Remove all the current balls
			_skin.removeBalls();

			// Remove all the HIT indicators
			_skin.grpLayerHits.removeChildren( 0, -1, true );

			// Set all the buttons back to not being game selected
			var num:VideoKenoNumber;
			for( i = 0; i < 80; i++ )
			{
				num = _skin.grpNumbers.getChildAt( i ) as VideoKenoNumber;
				num.isGameSelected = false;
			}

			// Clear Context
			logger.popContext();
		}

		/** Displays the hit and pick counts */
		private function displayHits( picks:int, hits:int ):void
		{
			// Log Activity
			logger.pushContext( "displayHits", arguments );

			_skin.ddPicks.displayAmount = picks;
			_skin.ddHits.displayAmount = hits;

			// Clear Context
			logger.popContext();
		}

		/** Displays the current bet amount in the "Bet" box */
		private function displayBetAmount():void
		{
			// Log Activity
			logger.pushContext( "displayBetAmount", arguments );

			_skin.ddBetAmount.displayAmount = getBetAmount();

			// Clear Context
			logger.popContext();
		}

		/** Adjusts the payout table to display the proper payouts */
		private function displayPayouts():void
		{
			// Log Activity
			logger.pushContext( "displayPayouts", arguments );

			_skin.displayPayouts( _winAmounts[_selNumbers.length] as Array, getBetAmount() );

			// Clear Context
			logger.popContext();
		}

		/** Handles the 'click' event of the 80 btn controls. */
		protected function btnNumber_clickHandler( event:starling.events.Event ):void
		{
			// Log Activity
			logger.pushContext( "btnNumber_clickHandler", arguments );

			if( _spinning > 0 || _autoPlay )
			{
				// Clear Context
				logger.popContext();
				return;
			}

			if( !_isReset )
			{
				resetPrize();
			}

			var btn:VideoKenoNumber = VideoKenoNumber(event.currentTarget);
			var number:int = btn.value;

			if( _selNumbers.indexOf( number ) >= 0 )
			{
				btn.isUserSelected = false;
				_selNumbers.splice( _selNumbers.indexOf( number ), 1 );
				SoundManager.playSound( _assetManager.getSound( "number_deselected" ), 170, 0 );
			}
			else if( _selNumbers.length < 15 )
			{
				btn.isUserSelected = true;
				_selNumbers.push( number );
				SoundManager.playSound( _assetManager.getSound( "number_selected" ), 170, 0 );
			}
			else
			{
				// Alert too many numbers
				SoundManager.playSound( _assetManager.getSound( "number_disabled" ), 170, 0 );

				// Clear Context
				logger.popContext();

				return;
			}

			/**
			 * 11.12.2012 - Running into some winnings mismatch errors
			 * where it appears like the selNumbers array had the right values, but the visual
			 * components didn't represent those values properly.
			 * So just in case, update all visual components after each number is clicked.
			 */
			for( var i:int = 0; i < _skin.grpNumbers.numChildren; i++ )
			{
				btn = _skin.grpNumbers.getChildAt( i ) as VideoKenoNumber;
				btn.isUserSelected = _selNumbers.indexOf( i + 1 ) >= 0;
			}


			// Toggle game button controls based on numbers selected
			_skin.btnPanel.toggleAutoPlayEnabled( _selNumbers.length != 0 );
			_skin.btnPanel.togglePlayEnabled( _selNumbers.length != 0 );

			displayPayouts();
			displayHits( _selNumbers.length, 0 );

			// Clear Context
			logger.popContext();
		}

		/** Handles the 'click' event of the clear button */
		protected function btnClear_clickHandler( event:Event ):void
		{
			// Log Activity
			logger.pushContext( "btnClear_clickHandler", arguments );

			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 );

			if( _spinning > 0 || _autoPlay )
			{
				// Clear Context
				logger.popContext();
				return;
			}

			// Set all the buttons back to not being user selected
			for( var i:int = 0; i < 80; i++ )
			{
				var num:VideoKenoNumber = _skin.grpNumbers.getChildAt( i ) as VideoKenoNumber;
				num.isUserSelected = false;
			}

			// Disable the Auto Play and Reveal buttons
			_skin.btnPanel.toggleAutoPlayEnabled( false );
			_skin.btnPanel.togglePlayEnabled( false );

			_selNumbers = [];
			displayHits( 0, 0 );
			resetPrize();
			displayPayouts();

			// Clear Context
			logger.popContext();
		}

		/*
		--------------------
		IButtonPanelHandler interface implementation
		--------------------
		*/
		override public function onAutoPlay():void
		{
			// Log Activity
			logger.pushContext( "onAutoPlay", arguments );

			_autoPlay = true;

			// Clear any autoplay timeouts
			clearTimeout( _autoSpinTimeout );
			_autoSpinTimeout = uint.MIN_VALUE;

			// Execute a spin if we're not already spinning
			if( !_spinning )
			{
				spin();
			}

			// Clear Context
			logger.popContext();
		}

		override public function onStop():void
		{
			// Log Activity
			logger.pushContext( "onStop", arguments );

			_autoPlay = false;
			if( _spinning == 0 )
			{
				_skin.btnPanel.toggleEnabled( true );

				// Clear any autoplay timeouts
				clearTimeout( _autoSpinTimeout );
				_autoSpinTimeout = uint.MIN_VALUE;

				// Set our Sweeps inAction value
				Sweeps.getInstance().setInAction( false );
			}

			// Clear Context
			logger.popContext();
		}

		override public function onBetSub():void
		{
			// Log Activity
			logger.pushContext( "onBetSub", arguments );

			if( _betAmountStep > 0 )
			{
				_betAmountStep--;
				_skin.btnPanel.betAmount = getBetAmount();
				_skin.btnPanel.displayBetAmount();
				displayBetAmount();

				// Update displays
				displayPayouts();
				displayHits( _selNumbers.length, 0 );
			}

			// Clear Context
			logger.popContext();
		}

		override public function onBetAdd():void
		{
			// Log Activity
			logger.pushContext( "onBetAdd", arguments );

			if( _betAmountStep < ( _betAmounts.length - 1 ) )
			{
				_betAmountStep++;
				_skin.btnPanel.betAmount = getBetAmount();
				_skin.btnPanel.displayBetAmount();
				displayBetAmount();

				// Update displays
				displayPayouts();
				displayHits( _selNumbers.length, 0 );
			}

			// Clear Context
			logger.popContext();
		}

		override public function onSpin():void
		{
			// Log Activity
			logger.pushContext( "onSpin", arguments );

			spin();

			// Clear Context
			logger.popContext();
		}

		override public function onQuickPickUp():void
		{
			// Log Activity
			logger.pushContext( "onQuickPickUp", arguments );

			if( _qpAmountStep < ( _qpAmounts.length - 1 ) )
			{
				_qpAmountStep++;
				_skin.btnPanel.quickPickAmount = getQuickPickAmount();
				_skin.btnPanel.displayQuickPickAmount();
			}

			// Clear Context
			logger.popContext();
		}

		override public function onQuickPickDown():void
		{
			// Log Activity
			logger.pushContext( "onQuickPickDown", arguments );

			if( _qpAmountStep > 0 )
			{
				_qpAmountStep--;
				_skin.btnPanel.quickPickAmount = getQuickPickAmount();
				_skin.btnPanel.displayQuickPickAmount();
			}

			// Clear Context
			logger.popContext();
		}

		override public function onQuickPick():void
		{
			// Log Activity
			logger.pushContext( "onQuickPick", arguments );

			// Return if we're already spinning
			if( _spinning > 0 || _autoPlay )
			{
				return;
			}

			// Reset if needed
			if( !_isReset )
			{
				resetPrize();
			}

			// Clear all the current picks
			btnClear_clickHandler( null );

			// Randomly select numbers
			var random:int = 0;
			var i:int;
			for( i = 0; i < getQuickPickAmount(); i++ )
			{
				while( _selNumbers.indexOf( random ) >= 0 || random == 0 )
				{
					random = utils.MathHelper.randomNumber( 1, 80 );
				}

				_selNumbers.push( random );
			}

			// Physically select the numbers on the game play area
			for( i = 0; i < _selNumbers.length; i++ )
			{
				( _skin.grpNumbers.getChildAt( _selNumbers[i] - 1 ) as VideoKenoNumber ).isUserSelected = true;
			}

			// Enable game button controls
			_skin.btnPanel.toggleAutoPlayEnabled( true );
			_skin.btnPanel.togglePlayEnabled( true );

			// Update displays
			displayPayouts();
			displayHits( _selNumbers.length, 0 );

			// Clear Context
			logger.popContext();
		}

		override public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );

			// Call our super method
			super.dispose();

			// Clear Context
			logger.popContext();
		}
	}
}