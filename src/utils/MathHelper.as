package utils
{
	import flash.geom.Point;
	
	import objects.Route;
	
	public class MathHelper
	{
		import mx.collections.ArrayList;
		
		public static const ROUTE_TYPE_NORMAL:int 			  = 0;
		public static const ROUTE_TYPE_UP_ONLY:int 			  = 1;
		public static const ROUTE_TYPE_LIMITED_DEDUCTIONS:int = 2;
		public static const ROUTE_TYPE_PLUS_ONLY_HIGH_YIELD:int = 3;
		
		// Logging
		private static const logger:DebugHelper = new DebugHelper( MathHelper );
		
		private static var reachable:Vector.<Vector.<int>>;
		private static var routeAttempts:int = 0;
		
		/**
		 * Calculates the distance between two points
		 */
		public static function getDistance( point1:Point, point2:Point ):int
		{
			var dx:int = point2.x - point1.x;
			var dy:int = point2.y - point1.y;
			return Math.sqrt( ( dx * dx ) + ( dy * dy ) );
		}
		
		/**
		 * Calculates a random number within between (and including) low and high.
		 */
		public static function randomNumber( low:Number=0, high:Number=1 ):Number
		{
			return Math.floor( Math.random() * ( 1 + high-low ) ) + low;
		}	
		
		/**
		 * Returns a given digit from an int.
		 */
		public static function getDigitFromValue( value:int, digit:int ):int 
		{
			return Math.floor( value / ( Math.pow( 10, digit ) ) % 10 )			
		}
		
		/**
		 * Use in place of the % operator to perform proper mods with negative numbers.
		 */
		public static function mod( op1:int, op2:int ):int
		{
			return ( ( op1 % op2 ) + op2 ) % op2;
		}		
		
		/**
		 * Returns an array of points, even spaced around the circumference of a circle.
		 */ 
		public static function getNPointsOnCircle( center:Point, radius:Number, n:Number, advAngle:int = 0 ):Array
		{
			var alpha:Number = Math.PI * 2 / n;
			var points:Array = new Array( n );
			var a:Number  = ( Math.PI * 2 / 360.0 ) * Number(advAngle);
			
			var i:int = -1;
			while( ++i < n )
			{
				var theta:Number = alpha * i + a;
				var pointOnCircle:Point = new Point( Math.cos( theta ) * radius, Math.sin( theta ) * radius );
				points[ i ] = center.add( pointOnCircle );
			}
			
			return points;			
		} 
		
		/**
		 * Returns array of the possible calcuations each step of a route might take.
		 */
		public static function getRoutePossibilites( routeType:int ):Vector.<Route>
		{
			// Log Activity
			logger.pushContext( "getRoutePossibilites", arguments );
			
			var min:int;
			var max:int;
			var step:int;
			var poss:Vector.<Route> = new Vector.<Route>();
			
			switch( routeType )
			{
				case ROUTE_TYPE_NORMAL:
					min = 3;
					max = 15;
					step = 2;
					break;
				
				case ROUTE_TYPE_UP_ONLY:
					min = 0;
					max = 15;
					step = 1;					
					break;
				
				case ROUTE_TYPE_LIMITED_DEDUCTIONS:
					min = 3;
					max = 15;
					step = 2;						
					break;
				
				case ROUTE_TYPE_PLUS_ONLY_HIGH_YIELD:
					min = 1;
					max = 240;
					step = 3;
					break;
			}
			
			// additions
			for( var i:int = min; i <= max; i += step )
			{
				poss.push( new Route( 0, 0, "+", "+" + i, 0, 0 ) );
			}
			
			// multis/divis
			if( routeType != ROUTE_TYPE_PLUS_ONLY_HIGH_YIELD )
			{
				poss.push( new Route( 0, 0, "*", "x2", 0, 0 ) );
				poss.push( new Route( 0, 0, "*", "x4", 0, 0 ) );
			}
			
			if( routeType == ROUTE_TYPE_NORMAL || routeType == ROUTE_TYPE_LIMITED_DEDUCTIONS )
			{
				poss.push( new Route( 0, 0, "/", "½", 0, 0 ) );
				poss.push( new Route( 0, 0, "/", "¼", 0, 0 ) );
			}
			
			// Clear Context
			logger.popContext();			
			return poss;
		}
		
		/**
		 * Calculates a random path from 0 to targetNumber in the amount of steps provided.
		 * 
		 * @param routeType Defines the types of steps that can be used in determining the route.
		 * @param betAmount The bet amount the player is betting.
		 * @param bonusWin The multiple of betAmount the route should produce as winnings.
		 * @param numSteps The desired number of steps in the route.
		 * @param maxStep The maximum number of steps in the route.
		 * @param displayAsCurrency Determines if the reveal amounts on each route step should be currency or just whole numbers.
		 * @param startingAmount The starting amount the route should use to reach bonusWin.
		 */
		public static function calculateRoute( routeType:int, betAmount:int, bonusWin:int, numSteps:int, maxSteps:int, displayAsCurrency:Boolean = true, startingAmount:int = 0 ):Vector.<Route>
		{
			// Log Activity
			logger.pushContext( "calculateRoute", arguments );
			
			var maxValue:int = routeType == ROUTE_TYPE_PLUS_ONLY_HIGH_YIELD ? bonusWin * 50 : 150;
			var step:int;
			var i:int;
			var calculations:int = 0;
			
			// Build up the map
			if( routeAttempts == 0 || reachable == null || reachable[0][0] != startingAmount || reachable.length <= maxSteps )
			{
				// Initialize the array and set the first step to 0
				reachable = new Vector.<Vector.<int>>;
				reachable.push( new <int>[startingAmount] );
				
				for( step = 1; step <= maxSteps; step++ )
				{
					// Figure out our maxValue
					var lastMax:int = routeType == ROUTE_TYPE_PLUS_ONLY_HIGH_YIELD ? reachable[step - 1][reachable[step - 1].length - 1] : maxValue;
					
					// Add a nested array we can fill for this step
					reachable[step] = new Vector.<int>();
					
					// We need to find out which numbers we can reach for this step, using maxValue to limit how high we can go
					// You can use targetNumber in place of maxValue if you never want the player to be able exceed the eventual winning amount
					for( var n:int = 0; n <= lastMax; n++ )
					{
						calculations++;
						// Determine what numbers are reachable from this amount
						var reachableNumsFrom:Vector.<int> = reacableNumbersFrom( routeType, n );
						for( i = 0; i < reachableNumsFrom.length; i++ )
						{
							// For each of the reachable numbers, make sure they're less than the maxValue and more than 0
							var nextNum:int = reachableNumsFrom[i];
							if( nextNum <= maxValue && nextNum > 0 )
							{
								// Add them to the reachable numbers for this step
								reachable[step].push( nextNum );
							}
						}
					}
				}
				
				logger.debug( "Completed " + calculations + " calculations\n" );
			}
			
			// Increment our route attempts			
			routeAttempts++;			
			
			// figure out how we got there
			var routeTaken:Vector.<Route> = new Vector.<Route>();
			var curRoute:Route = new Route( bonusWin, bonusWin, "", "" );
			var good:Boolean = false;
			var reachableNumsRev:Vector.<Route>;
			
			// Iterate through our steps in reverse, so we can start at our targetNumber and work backwards to 0
			for( step = numSteps - 1; step >= 0; step-- )
			{
				good = false;	
				
				// Get a list of numbers that we could have started from, to get to the current value we're at...
				// That is if we're at 10.00, we cold've been at 5.00 and done a *2 or could've been at 40.00 and done a /4, etc
				reachableNumsRev = reachableNumbersFromReverse( routeType, curRoute.BaseStartValue, betAmount, displayAsCurrency );
				reachableNumsRev.sort(ArrayHelper.sortRandom);
				
				// Step through the current numbers to see if we have a 'good' number
				for( i = 0; i <= reachableNumsRev.length - 1; i++ )
				{
					// Get the next route
					var nextRoute:Route = reachableNumsRev[i] as Route;
					
					// Get an array of all previously taken route steps that match the current route's operate ( 1/2, *4, +0.80, etc);
					var sameRoutes:Vector.<Route> = routeTaken.filter( function doMap( item:Route, index:int, v:Vector.<Route> ):Boolean{ return item.Display == nextRoute.Display; }, null );
					var deductionSteps:Vector.<Route> = routeTaken.filter( function doMap( item:Route, index:int, v:Vector.<Route> ):Boolean{ return item.Func == "/"; }, null );
					
					// Determine if we can use this route - is it reachable and have we taken less than 3 similar steps
					if( reachable[step].indexOf( nextRoute.BaseStartValue ) >= 0 && ( sameRoutes.length <= 3 || routeType == ROUTE_TYPE_LIMITED_DEDUCTIONS || routeType == ROUTE_TYPE_PLUS_ONLY_HIGH_YIELD ) && ( deductionSteps.length <= 3 || routeType != ROUTE_TYPE_LIMITED_DEDUCTIONS ) )
					{
						// If we've found match - that is a number we could have been at to reach our current value,
						// but also a number that could've have been reached in x number of steps - add it to our route
						good = true;
						curRoute = nextRoute;
						routeTaken.splice( 0, 0, curRoute );
						break;
					}
				}
				
				// If we ended up at a number on the current step we couldn't manage to reach from the previous step,
				// recursively call ourselves until we find a good route				
				if( !good )
				{
					return null;
				}
			}
			
			logger.debug( "Completed route in " + routeAttempts.toString() + " attempt(s)" );
			
			routeAttempts = 0;
			reachable = null;
			
			// Clear Context
			logger.popContext();			
			return routeTaken;
		}
		
		/**
		 * Calculates an array of numbers that can be reached, given the current number and the betAmount
		 */
		private static function reacableNumbersFrom( routeType:int, n:int ):Vector.<int>
		{
			var min:int;
			var max:int;
			var step:int;
			var result:Vector.<int> = new Vector.<int>();
			
			switch( routeType )
			{
				case ROUTE_TYPE_NORMAL:
					min = 3;
					max = 15;
					step = 2;
					break;
				
				case ROUTE_TYPE_UP_ONLY:
					min = 0;
					max = 15;
					step = 1;					
					break;
				
				case ROUTE_TYPE_LIMITED_DEDUCTIONS:
					min = 3;
					max = 15;
					step = 2;
					break;
				
				case ROUTE_TYPE_PLUS_ONLY_HIGH_YIELD:
					min = 1;
					max = 250;
					step = 3;
					break;				
			}
			
			// additions
			for( var i:int = min; i <= max; i += step )
			{
				result.push( n + i );
			}
			
			// multis/divis
			if( routeType == ROUTE_TYPE_NORMAL || routeType == ROUTE_TYPE_LIMITED_DEDUCTIONS )
			{
				if( n % 2 == 0 )
				{
					result.push( n / 2 );
				}
				
				if( n % 4 == 0 )
				{
					result.push( n / 4 );
				}
			}
			
			if( routeType != ROUTE_TYPE_PLUS_ONLY_HIGH_YIELD )
			{
				result.push( n * 2 );
				result.push( n * 4 );
			}
			
			return result;
		}
		
		/**
		 * Calculates an array of numbers that could've been used to reach the current number, given the current number and the betAmount
		 */		
		private static function reachableNumbersFromReverse( routeType:int, n:int, betAmount:int, displayAsCurrency:Boolean = true ):Vector.<Route>
		{
			var min:int;
			var max:int;
			var step:int;
			var result:Vector.<Route> = new Vector.<Route>();
			var display:String = "";
			
			switch( routeType )
			{
				case ROUTE_TYPE_NORMAL:
					min = 3;
					max = 15;
					step = 2;
					break;
				
				case ROUTE_TYPE_UP_ONLY:
					min = 0;
					max = 15;
					step = 1;					
					break;
				
				case ROUTE_TYPE_LIMITED_DEDUCTIONS:
					min = 3;
					max = 15;
					step = 2;
					break;
				
				case ROUTE_TYPE_PLUS_ONLY_HIGH_YIELD:
					min = 1;
					max = 240;
					step = 3;
					break;				
			}
			
			// additions
			for( var i:int = min; i <= max; i += step )
			{
				if( displayAsCurrency )
				{
					display = FormatHelper.formatEntriesAndWinnings( i * betAmount );
				}
				else
				{
					display = ( i * betAmount ).toString();
				}
				
				result.push( new Route( n - i, n, "+", "+" + display, ( n - i ) * betAmount, n * betAmount ) );
			}
			
			// multis/divis
			if( routeType != ROUTE_TYPE_PLUS_ONLY_HIGH_YIELD )
			{
				if( n % 2 == 0 )
				{
					result.push( new Route( n / 2, n, "*", "x2", ( n / 2 ) * betAmount, n * betAmount ) );
				}
				
				if( n % 4 == 0 )
				{
					result.push( new Route( n / 4, n, "*", "x4", ( n / 4 ) * betAmount, n * betAmount ) );
				}
			}
			
			if( routeType == ROUTE_TYPE_NORMAL || routeType == ROUTE_TYPE_LIMITED_DEDUCTIONS )
			{
				result.push( new Route( n * 2, n, "/", "½", ( n * 2 ) * betAmount, n * betAmount  ) );
				result.push( new Route( n * 4, n, "/", "¼", ( n * 4 ) * betAmount, n * betAmount  ) );
			}
			
			return result;			
		}
	}
}