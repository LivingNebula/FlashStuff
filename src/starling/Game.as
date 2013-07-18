package starling
{
	import starling.assets.AssetManager;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.interfaces.IAssetManagerHandler;
	import starling.interfaces.IButtonPanelHandler;

	import utils.DebugHelper;

	/**
	 * Base class for all of Sweeptopia's Starling-Based games.
	 */
	public class Game extends Sprite implements IAssetManagerHandler, IButtonPanelHandler
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( Game );

		// UI
		protected var _loadingBackground:Class;

		// Objects and Managers
		protected var _assetManager:AssetManager;

		// Gamestate Variables
		protected var _assetsLoaded:Boolean = false;
		protected var _achievementsLoaded:Boolean = false;
		protected var _gameLoaded:Boolean = false;

		public function Game()
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );

			super();
			addEventListener( Event.ADDED_TO_STAGE, init );

			// Clear Context
			logger.popContext();
		}

		protected function init( event:Event ):void
		{
			// Log Activity
			logger.pushContext( "init", arguments );
			// Clear Context
			logger.popContext();
		}

		/** Notifes the game that our achievements have loaded */
		public function setAchievementsLoaded():void
		{
			// Log Activity
			logger.pushContext( "setAchievementsLoaded", arguments );

			_achievementsLoaded = true;

			// Check to see if we can load our game
			if( _achievementsLoaded && _assetsLoaded && !_gameLoaded )
			{
				continueLoadingGame();
			}

			// Clear Context
			logger.popContext();
		}

		/**
		 * Continues loading the game components after the achievements and assets have been loaded.
		 */
		protected function continueLoadingGame():void
		{
			// Log Activity
			logger.pushContext( "continueLoadingGame", arguments );

			// Remove the progress meter
			Sweeps.getInstance().stopProgressMeter();

			// Clear Context
			logger.popContext();
		}

		/*
		--------------------
		IAssetManagerHandler interface implementation
		--------------------
		*/
		public function onLoadAssetsStarted():void
		{
			// Log Activity
			logger.pushContext( "onLoadAssetsStarted", arguments );

			// Start the progress meter
			Sweeps.getInstance().startProgressMeter( _loadingBackground );

			// Clear Context
			logger.popContext();
		}

		public function onLoadAssetsProgress( progress:Number ):void
		{
			Sweeps.getInstance().updateProgressMeter( progress );
		}

		public function onLoadAssetsError( errorCode:int, error:String ):void
		{
			// Log Activity
			logger.pushContext( "onLoadAssetsError", arguments );

			// Remove the progress meter
			Sweeps.getInstance().stopProgressMeter();

			// Display a popup indicating an error occurred
			Sweeps.getInstance().createPopUp( "Oops!", "We're sorry, but there was an error while trying to complete this request.\n\nPlease try again.", false, false );

			// Enable the main panel
			Sweeps.getInstance().setInAction( false );

			// Return to the main menu
			Sweeps.getInstance().quit();

			// Clear Context
			logger.popContext();
		}

		public function onLoadAssetsComplete():void
		{
			// Log Activity
			logger.pushContext( "onLoadAssetsComplete", arguments );

			_assetsLoaded = true;

			// Check to see if we can load our game
			if( _achievementsLoaded && _assetsLoaded && !_gameLoaded )
			{
				continueLoadingGame();
			}

			// Clear Context
			logger.popContext();
		}

		/*
		--------------------
		IButtonPanelHandler interface implementation
		--------------------
		*/
		public function onAutoPlay():void
		{
		}

		public function onStop():void
		{
		}

		public function onInfo():void
		{
		}

		public function onNudge( direction:String = "" ):void
		{
		}

		public function onBetOne():void
		{
		}

		public function onBetMax():void
		{
		}

		public function onBetSub():void
		{
		}

		public function onBetAdd():void
		{
		}

		public function onLineAdd():void
		{
		}

		public function onSpin():void
		{
		}

		public function onSpinStop():void
		{
		}

		public function onDeal():void
		{
		}

		public function onDraw():void
		{
		}

		public function onQuickPickUp():void
		{
		}

		public function onQuickPickDown():void
		{
		}

		public function onQuickPick():void
		{
		}

		override public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );

			// Dispose of the asset manager to release our textures from the GPU
			if( _assetManager != null )
			{
				_assetManager.dispose();
				_assetManager = null;
			}

			// Call our super method
			super.dispose();

			// Clear Context
			logger.popContext();
		}
	}
}