package components.SuperVideoSlots
{
	import interfaces.IDisposable;
	
	import objects.Route;
	
	import spark.components.SkinnableContainer;
	
	import utils.DebugHelper;
	import utils.MathHelper;
	
	public class SuperVideoSlotsBonusGame extends SkinnableContainer implements IDisposable
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( SuperVideoSlotsBonusGame );	
		
		protected var betAmount:int;
		protected var curLines:int;
		protected var bonusWin:int;
		protected var winAmount:int;
		protected var startingAmount:int;
		protected var revealWinnings:Vector.<Route>;
		
		protected var _onStop:Function;
		protected var _onPlayFreeSpins:Function;
		
		public function set onStop( value:Function ):void
		{
			_onStop = value;
		}
		
		public function set onPlayFreeSpins( value:Function ):void
		{
			_onPlayFreeSpins = value;
		}
		
		public function SuperVideoSlotsBonusGame()
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );
			
			super();
			
			// Clear Context
			logger.popContext();			
		}
				
		public function setParameters( betAmount:int, curLines:int, bonusWin:int, winAmount:int, startingAmount:int = 0 ):void
		{
			// Log Activity
			logger.pushContext( "setParamters", arguments );
			
			this.betAmount = betAmount;
			this.curLines = curLines;
			this.bonusWin = bonusWin;
			this.winAmount = winAmount;
			this.startingAmount = startingAmount;
			
			// Clear Context
			logger.popContext();			
		}
		
		public function resetAndPlay():void
		{
			// Log Activity
			logger.pushContext( "resetAndPlay", arguments );
			
			// Clear Context
			logger.popContext();			
		}
		
		public function playExit( winAmount:int, isCurrency:Boolean ):void
		{
			// Log Activity
			logger.pushContext( "playExit", arguments );
			
			// Clear Context
			logger.popContext();			
		}
		
		protected function calculateRevealWinnings( totalIcons:int, displayAsCurrency:Boolean = true, routeType:int = MathHelper.ROUTE_TYPE_NORMAL ):void
		{
			// Log Activity
			logger.pushContext( "calculateRevealWinnings", arguments );
			
			// Constructs an array of possible step amounts, duplicating the lower step amounts more often
			// and higher step amounts less frequently.
			var maxSteps:int = totalIcons - 1; // We cannot reveal all icons or we wouldn't have an ending icon
			var steps:Array = [];
			for( var i:int = int( Number( maxSteps ) * 0.40 ); i <= maxSteps; i++ )
			{
				for( var j:int = maxSteps - i; j >= 0; j-- )
				{
					steps.push( i );
				}
			}			
			
			// Use calculateRoute to determine what amounts and how many clicks a user will see to reveal their bonus win
			do 
			{
				revealWinnings = MathHelper.calculateRoute( routeType, betAmount, bonusWin, steps[MathHelper.randomNumber( 0, steps.length - 1 )], maxSteps, displayAsCurrency, startingAmount );				
			} 
			while ( revealWinnings == null || revealWinnings.length == 0 );
			
			// Clear Context
			logger.popContext();			
		}				
		
		protected function GotoFreeSpins():void
		{
			// Log Activity
			logger.pushContext( "GotoFreeSpins", arguments );
			
			// Dispatch our event so the game knows we're ready to play out our free spins
			_onPlayFreeSpins( this );
			
			// Clear Context
			logger.popContext();			
		}
		
		protected function GameFinished():void
		{
			// Log Activity
			logger.pushContext( "GameFinished", arguments );
			
			// Dispatch our event so the game knows we're done with the bonus game
			_onStop( this );
			
			// Clear Context
			logger.popContext();			
		}
		
		public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );
			
			_onStop = null;
			_onPlayFreeSpins = null;
			
			// Clear Context
			logger.popContext();			
		}
	}
}