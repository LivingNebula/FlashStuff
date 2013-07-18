package objects
{
	import assets.Config;
	
	import services.SweepsAPI;
	
	import utils.DebugHelper;
	import utils.MathHelper;
		
	public class BlackjackLogic
	{
		public static const RESULT_WIN:String 			= "win";
		public static const RESULT_LOSE:String 			= "loss";
		public static const RESULT_PUSH:String 			= "push";
		public static const RESULT_BLACKJACK:String 	= "blackjack";
		public static const HIT_MAX:int 				= 16; // The highest value where we'll assume players and dealers would still HIT
		
		private static const GAME_TYPE:int 				= Config.GAME_TYPE_VIDEO_BLACKJACK;
		
		// Logging
		private static const logger:DebugHelper = new DebugHelper( BlackjackLogic );	
		
		private static var deck:Deck;
		private static var discardDeck:Deck;
		
		public function BlackjackLogic()
		{
		}
		
		/**
		 * Retrieves all the possible outcomes of a Blackjack hand.
		 * 
		 * @return An <code>Array</code> containing all the possible outcomes.
		 */			
		public static function getPossibleResults():Array
		{
			var results:Array = [];
			results.push( RESULT_WIN );
			results.push( RESULT_LOSE );
			results.push( RESULT_PUSH );
			results.push( RESULT_BLACKJACK );
			
			return results;
		}
		
		/**
		 * Determines the outcome of the player's hand vs the dealer's hand.
		 * 
		 * @param dealerHand A <code>Pile</code> representing the dealer's hand.
		 * @param playerHand A <code>Pile</code> representing the player's hand.
		 * @return A result indiciating the player's hand outcome.
		 */
		public static function getResult( dealerHand:Pile, playerHand:Pile, isSplit:Boolean = false ):String
		{
			var dealerValue:int = dealerHand.getFaceValue( GAME_TYPE );
			var dealerCount:int = dealerHand.cardCount;			
			var handValue:int = playerHand.getFaceValue( GAME_TYPE );
			var cardCount:int = playerHand.cardCount;	
			var actualResult:String;
			
			// Determine our result					
			if( handValue <= 21 )
			{
				// If we have more than the dealer, or 21 or less and the dealer busted we won
				if( handValue > dealerValue || dealerValue > 21 )
				{
					// Did we get a blackjack?
					if( handValue == 21 && cardCount == 2 && !isSplit )
					{
						actualResult = BlackjackLogic.RESULT_BLACKJACK;
					}
					else
					{
						actualResult = BlackjackLogic.RESULT_WIN;
					}
				}					
					// If the dealer has more than us or we busted, we've lost
				else if( dealerValue > handValue || handValue > 21 )
				{
					actualResult = BlackjackLogic.RESULT_LOSE;
				}
					// If we have the same amount as the dealer, we may have pushed
				else if( handValue == dealerValue )
				{
					// If the player has blacjack then the dealer has to have blackjack for a push
					if( cardCount == 2 && handValue == 21 && !isSplit )
					{
						actualResult = dealerCount == 2 ? BlackjackLogic.RESULT_PUSH : BlackjackLogic.RESULT_BLACKJACK;
					}
						// If the dealer has black, we lost because we know we don't have blackjack here
					else if( dealerCount == 2 && dealerValue == 21 )
					{
						actualResult = BlackjackLogic.RESULT_LOSE;
					}
						// Okay, we pushed
					else
					{
						actualResult = BlackjackLogic.RESULT_PUSH;
					}
				}
			}
			else
			{
				actualResult = BlackjackLogic.RESULT_LOSE;
			}
			
			return actualResult;
		}
		
		/**
		 * Returns a pile of cards that when adding up their face value, based on <code>gameType</code>, will equal <code>result</code>.
		 * 
		 * @param deck The deck to draw cards from.
		 * @param result The value the resulting cards in the pile should equal.
		 * @param gameType The game type to be used when calcuating the cards' face values.
		 * @return A <code>Pile</code> who card's face values add upto <code>result</code>.
		 */
		private static function satisfyHand( result:int, gameType:int, avoidSplitAndDouble:Boolean = false, startingValue:int = 0 ):Pile
		{
			// Log Activity
			logger.pushContext( "satisfyHand", arguments );			
			var actualValue:int = result == -1 ? 21 : result;
			var targetValue:int;
			var pile:Pile = new Pile();
			var card:Card;
			var lastCardValue:int;
			var lastCard:Card;			
			var cardCount:int;
			var maxDeckValue:int;
			var minDeckValue:int;
			var maxValue:int;
			var minValue:int
			var i:int;
			var retryCount:int;
			var low:int;
			var high:int;
			var cardCounts:Array = [];
			
			// Popuplate the pile
			if( result == -1 )
			{
				// This case is simple enough, just give them a 10 value card and a 1/11 value (ACE) card
				pile.addCard( deck.getCardByFaceValue( gameType, 10, "" ) );
				pile.addCard( deck.getCardByFaceValue( gameType, 11, "" ) );
				pile.shuffle();
			}
			else
			{				
				// Grab our last card and make sure that it's large enough so that whatever we had before was less or equal to HIT_MAX
				// Make sure it's not an ace intended to be counted as 11, unless the hand is supposed to be 21.
				// Otherwise, if it the the play were to to HIT past 21, the ace could then be counted as 1 and mess up our logic. 
				maxValue = deck.getMaxFaceValue( gameType, actualValue == 21 ? 11 : 10 );
				minValue = deck.getMinFaceValue( gameType, actualValue - BlackjackLogic.HIT_MAX );
				
				logger.debug( "maxValue: " + maxValue + ", minValue:" + minValue );
				
				// If we have a startingValue (for splits), make sure our max value doesn't end up making it impossible to reach our target
				// i.e. - If our target is 18 and our startingValuing is 9, our maxValue can't be 10 or we could end up pick 19 on the first two cards
				if( startingValue > 0 )
				{
					if( maxValue > actualValue - startingValue )
					{
						maxValue = actualValue - startingValue;
					}
					else if( maxValue == 11 && startingValue == 10 )
					{
						maxValue == 10;
					}
				}
				
				logger.debug( "maxValue: " + maxValue + ", minValue:" + minValue );
				
				// Draw a card and save it to the side (do this in a loop in case we randomly pick a card value that's no longer in the deck)
				while( lastCard == null )
				{ 
					lastCardValue = MathHelper.randomNumber( minValue, maxValue );
					lastCard = deck.getCardByFaceValue( gameType, lastCardValue, "" );
				}
				targetValue = actualValue - lastCardValue - startingValue; // Determine what the rest of our cards now have to total upto
				
				logger.debug( "targetValue: " + targetValue + ", actualValue:" + actualValue + ", lastCardValue: " + lastCardValue );
				
				// Figure out how many cards we want to draw based on our new targetValue
				// If it's 21, make sure it's more than 1 as that would give us 2 cards total which would be Blackjack and that is handled elsewhere
				// We choose a random amount of cards between (how many would it take to reach our target value if we drew all 11's) and (how many if we draw all 4's)
				var minCardCount:int = actualValue == 21 && startingValue == 0 ? 2 : Math.ceil( targetValue / deck.getMaxFaceValue( gameType, actualValue == 21 ? 11 : 10 ) );
				var maxCardCount:int = Math.ceil( targetValue / deck.getMinFaceValue( gameType, 5 ) );
				cardCount = getWeightedCardCount( minCardCount, maxCardCount );
				
				logger.debug( "minCardCount: " + minCardCount + ", maxCardCount:" + maxCardCount + ", targetValue:" + targetValue + ", cardCount:" + cardCount );
				
				for( i = 0; i < cardCount; i++ ) 
				{
					// Find out what cards are still in the deck as we've already drawn some
					maxDeckValue = deck.getMaxFaceValue( gameType, actualValue == 21 ? 11 : 10 ); // The highest available card in the deck (exclude 11 valued aces unless we're shooting for 21 for simplicity)
					minDeckValue = deck.getMinFaceValue( gameType ); // The lowest available card in the deck
					
					// Figure out the max and min values that our next card can be, based on how many cards left we need to draw
					maxValue = ( targetValue - pile.getFaceValue( gameType ) ) - ( ( cardCount - i - 1 ) * minDeckValue ); // The max value of our next card
					minValue = ( targetValue - pile.getFaceValue( gameType ) ) - ( ( cardCount - i - 1 ) * maxDeckValue ); // The min value of our next card
					
					// Make sure our math didn't go screwy and give us numbers out of range
					if( maxValue > maxDeckValue ) { maxValue = maxDeckValue; } 										
					if( minValue < minDeckValue ) { minValue = minDeckValue; }
					
					// If our minimum value is 1, it could also be counted as 11 - so make sure that doesn't affect our hand adversely
					if( minValue == 1 ) {
						// Make sure that by drawing an ace, you wouldn't fall in a range where they player would normally hold
						if( pile.getFaceValue( gameType ) + startingValue + 11 > BlackjackLogic.HIT_MAX && pile.getFaceValue( gameType ) + startingValue + 11 <= 21 ) {
							minValue = 2;
							maxValue -= 1;
						}
					}					
					
					// Draw a card and add it to the pile (do this in a loop in case we randomly pick a card value that's no longer in the deck)
					retryCount = 0;
					card = null;
					while( card == null )
					{
						retryCount++;
						card = deck.getCardByFaceValue( gameType, MathHelper.randomNumber( minValue, maxValue ), "" );
						
						// If we can't seem to find a card after a few attempts, add the cards back into the pile and recursively call ourselves
						if( retryCount > 3 && card == null )
						{
							logger.warn( "Failed to find card => result:" + result + ", cardCount:" + cardCount + ", cardNum:" + ( i + 1 ) + ", min/max:" + minValue + "/" + maxValue);
							deck.addPile( pile, true );	
							deck.addCard( lastCard, true );
							
							// Clear Context
							logger.popContext();							
							return null;
						}
					}					
					pile.addCard( card );
				}
				
				// We've picked all our cards, so reverse the deck and add our last card back into the pile
				pile.reverse();
				pile.addCard( lastCard );
				
				// Make sure the pile doesn't interfere with our split and double restrictions
				if( avoidSplitAndDouble )
				{
					var card1Value:int = pile.getCard( 0 ).getFaceValue( GAME_TYPE );
					var card2Value:int = pile.getCard( 1 ).getFaceValue( GAME_TYPE );
					
					// If the cards are the same value or the cards total value combined is 9, 10, 11
					// We need to redraw our hand
					if( card1Value == card2Value || [9, 10, 11].indexOf( card1Value + card2Value ) >= 0 )
					{
						logger.warn( "Failed to avoid split and double => result:" + result + ", cardCount:" + cardCount + ", cardNum:" + ( i + 1 ) + ", min/max:" + minValue + "/" + maxValue);
						deck.addPile( pile, true );
						
						// Clear Context
						logger.popContext();						
						return null;					
					}
				}
				
				// There are some weird cases where when using a starting value (for splits) that you'll end up with a hand that doesn't
				// match your target result. If so, rerurn the logic
				if( pile.getFaceValue( Config.GAME_TYPE_VIDEO_BLACKJACK ) + startingValue != actualValue )
				{
					logger.warn( "Failed to meet target value => result:" + result + ", cardCount:" + cardCount + ", cardNum:" + ( i + 1 ) + ", min/max:" + minValue + "/" + maxValue);
					deck.addPile( pile, true );
					
					// Clear Context
					logger.popContext();					
					return null;					
				}				
				
				// Add one final card to the pile to make sure the hand busts if the player hits past where we want them to be
				// We only need to do this if the goal is less than 21 because at 21 the game wouldn't them hit and over 21 we've already busted
				if( actualValue < 21 )
				{
					// Draw a card and add it to the pile (do this in a loop in case we randomly pick a card value that's no longer in the deck)
					card = null;
					while( card == null )
					{
						card = deck.getCardByFaceValue( gameType, MathHelper.randomNumber( 22 - actualValue, 10 ), "" );
					}
					pile.addCard( card );
				}
			}	
			
			// Clear Context
			logger.popContext();			
			return pile;
		}
		
		/**
		 * Returns an object containing two players hands to satisfy the requested hands.
		 */
		public static function satisfySplit( dealerValue:int, playerHand:Hand, targetResult:String, splitResult:String ):Object
		{
			// Log Activity
			logger.pushContext( "satisfySplit", arguments );	
			var card:Card;
			var j:int, k:int;
			var hand:Hand;
			var ret:Object = { dealerHand: null, dealerValue: 0, playerHands: [], playerValues: [] };
			var results:Array = [ targetResult, splitResult ];
			var tmpPile:Pile;
			var retryCount:int;
			var errMsg:ErrorMessage;
			
			// Put our player's undrawn cards back in the deck
			for( var i:int = 0; i <= playerHand.drawCards.cardCount; i++ )
			{
				deck.addCard( playerHand.drawCards.drawCard() );
			}		
			
			// See what type of hand we should produce for this result
			for( i = 0; i < results.length; i++ )
			{
				// Create a new hand and pull in one of the split cards from our original hand
				hand = new Hand(); 
				hand.playCards.addCard( playerHand.playCards.drawCard() );
				ret.playerHands.push( hand );
				var total:int = 0;
				var splitValue:int = hand.playCards.getCard( 0 ).getFaceValue( GAME_TYPE );
				
				switch( results[i] )
				{
					case RESULT_BLACKJACK:
					case RESULT_WIN:
						// Check to see if we're trying to get blackjack and if we split on a 10's or Ace's
						if( 
							( results[i] == RESULT_BLACKJACK ) && 
							( [10, 11].indexOf( splitValue ) >= 0 ) &&
							( deck.getMaxFaceValue( GAME_TYPE ) == ( splitValue == 10 ? 11 : 10 ) )
						)
						{
							// This case is simple enough, just give them a 10 value card and a 1/11 value (ACE) card
							total = -1;							
							hand.drawCards.addCard( deck.getCardByFaceValue( GAME_TYPE, splitValue == 10 ? 11 : 10, "" ) );
						}
						else
						{
							// If the dealer busted, target the player for 17 or more
							// If the dealer didn't bust, target the play for at least 1 more than the dealer
							tmpPile = null;
							retryCount = 0;
							while( tmpPile == null )
							{
								retryCount++;
								total = dealerValue > 21 ? 17 + MathHelper.randomNumber( 0, 4 ) : dealerValue + 1 + MathHelper.randomNumber( 0, 21 - ( dealerValue + 1 ) );
								tmpPile = satisfyHand( total, GAME_TYPE, false, hand.playCards.getFaceValue( GAME_TYPE ) );
								
								// If we can't draw a winning handle after a while, force a loss
								if( retryCount > 10 && tmpPile == null )
								{
									errMsg = new ErrorMessage( "BlackjackLogic:Could not produce winning hand for satisfySplit.", "", "", "" );
									errMsg.append( "SPLIT INFO", "Dealer Value: " + dealerValue );
									errMsg.append( "SPLIT INFO", "Target Total: " + total );
									errMsg.append( "SPLIT INFO", "Deck: " + deck.toString() );
									
									if( Sweeps.DEBUG && !Sweeps.DEBUG_W_API ) 
									{
										throw new Error( errMsg.toString() );
									}
									else
									{
										SweepsAPI.reportError( errMsg );
									}
									
									results[i] = RESULT_LOSE;
									i--;
									break;
								}
							}
							tmpPile.popCardsToPile( hand.drawCards );
						}
						break;
					
					case RESULT_LOSE:
						// Target the user for a bust or for less than what the dealer received.
						var possibleValues:Array = [];
						for( j = 17; j <= 26; j++ )
						{
							if( j < dealerValue || j > 21 )
							{
								possibleValues.push( j );
								
								// Weight values less than the dealer more heavily so the player busts less often
								if( j < dealerValue )
								{
									possibleValues.push( j );
									possibleValues.push( j );
								}
							}
						}
						
						tmpPile = null;
						while( tmpPile == null )
						{
							total = possibleValues[MathHelper.randomNumber( 0, possibleValues.length - 1 )];
							tmpPile = satisfyHand( total, GAME_TYPE, false, hand.playCards.getFaceValue( GAME_TYPE ) );
						}
						tmpPile.popCardsToPile( hand.drawCards );
						break;
					
					case RESULT_PUSH:
						// Target the user for the same thing the dealer got (use dealerResult and not dealerValue so we'll properly PUSH blackjacks)
						tmpPile = null;
						retryCount = 0;
						while( tmpPile == null )
						{
							retryCount++;
							total = dealerValue;
							tmpPile = satisfyHand( total, GAME_TYPE, false, hand.playCards.getFaceValue( GAME_TYPE ) );
							
							// If we can't draw a winning handle after a while, force a loss
							if( retryCount > 10 && tmpPile == null )
							{
								errMsg = new ErrorMessage( "BlackjackLogic:Could not produce produce hand for satisfySplit.", "", "", "" );
								errMsg.append( "SPLIT INFO", "Dealer Value: " + dealerValue );
								errMsg.append( "SPLIT INFO", "Target Total: " + total );
								errMsg.append( "SPLIT INFO", "Deck: " + deck.toString() );
								
								if( Sweeps.DEBUG && !Sweeps.DEBUG_W_API ) 
								{
									throw new Error( errMsg.toString() );
								}
								else
								{
									SweepsAPI.reportError( errMsg );
								}
								
								results[i] = RESULT_LOSE;
								i--;
								break;
							}							
						}
						tmpPile.popCardsToPile( hand.drawCards );						
						break;
				}
				
				ret.playerValues.push( total );
				logger.debug( ret.playerHands[i].playCards.toString() + " - " + ret.playerHands[i].drawCards.toString() );
			}
			
			// Clear Context
			logger.popContext();			
			return ret;
		}
		
		/**
		 * Returns a player hand, which has been modified to satisfy the merge of it's current result plus the new targetResult.
		 * 
		 * @param dealerValue The value the dealer's hand will equal once it's been played
		 * @param playerHand The player's <code>Hand</code> which has been doubled.
		 * @param currentResult The current intended result ('win', 'lose', 'push', 'blackjack') of <code>playerHand</code>.
		 * @param targetResult The target result ('win', 'lose', 'push', 'blackjack') to be merged into the current result.
		 * @return A <code>Hand</code> which is intended to replace <code>playerHand</code>.
		 */
		public static function satisfyDouble( dealerValue:int, playerHand:Hand, targetResult:String ):Hand
		{
			// Log Activity
			logger.pushContext( "satisfyDouble", arguments );
			
			var card:Card;
			var total:int;
			var j:int;
			
			// Determine the player values
			var playerValue:int = playerHand.playCards.getFaceValue( GAME_TYPE );
			
			// Put the rest of our player's undrawn cards back in the deck
			for( var i:int = 0; i <= playerHand.drawCards.cardCount; i++ )
			{
				deck.addCard( playerHand.drawCards.drawCard() );
			}

			// Draw the last card
			card = null;
			while( card == null )
			{			
				// Determine what card to give our player
				switch( targetResult )
				{
					case RESULT_BLACKJACK: // You can't really get BJ on a double because you've already been shown your two cards
					case RESULT_WIN:
						// If the dealer busted, target the player for 17 or more
						// If the dealer didn't bust, target the play for at least 1 more than the dealer
						total = dealerValue > 21 ? 17 + MathHelper.randomNumber( 0, 4 ) : dealerValue + 1 + MathHelper.randomNumber( 0, 21 - ( dealerValue + 1 ) );
						break;
					
					case RESULT_LOSE:
						// Target the user for less than what the dealer received.
						// We can't target for a bust as 'double' can only be executed on 9/10/11
						// and there is no way to bust a player with 1 card with any of those values
						var possibleValues:Array = [];
						for( j = playerValue + 2; j < dealerValue; j++ )
						{
							possibleValues.push( j );
						}
						total = possibleValues[MathHelper.randomNumber( 0, possibleValues.length - 1 )];					
						break;
					
					case RESULT_PUSH:
						// Target the user for the same thing the dealer got (use dealerResult and not dealerValue so we'll properly PUSH blackjacks)
						total = dealerValue == -1 ? 21 : dealerValue;						
						break;
				}
				
				card = deck.getCardByFaceValue( GAME_TYPE, deck.getMaxFaceValue( GAME_TYPE, total - playerValue ), "" );
			}
			playerHand.drawCards.addCard( card );
			
			// Log the modified hand
			logger.debug( "Return: " + playerHand.playCards.toString() + " - " + playerHand.drawCards.toString() );
			
			// Clear Context
			logger.popContext();			
			return playerHand;
		}
		
		/**
		 *  Returns an object, filled with 1 dealer hand and n user hands to satisfy the results requested.
		 * 
		 * @param results An array of results ('win', 'lose' 'push', 'blackjack'), 1 for each player hand, to be satisfied.
		 * @return An <code>Object</code> with a <code>dealerHand</code> key, which contains a <code>Hand</code> and a
		 * <code>playerHands</code> key which contains an <code>Array</code> of <code>Hand</code>.
		 */	
		public static function satisfyResults( results:Array ):Object 
		{
			// Log Activity
			logger.pushContext( "satisfyResults", arguments );
			var ret:Object = { dealerHand: null, dealerValue: 0, playerHands: [], playerValues: [] };
			var hand:Hand;
			var dealerPoss:Array = [17, 18, 19, 20, 21, 22, 23, 24, 25, 26, -1];
			var dealerWght:Array = [1,   2,  3,  4,  3,  4,  4,  3,  2,  1, 1];
			var dealerPossWeighted:Array = [];
			var dealerResult:int;
			var dealerValue:int;
			var gameType:int = GAME_TYPE;
			var i:int;
			var j:int;
			var avoidSplitAndDouble:Boolean = false;
			var tmpPile:Pile;
			
			// Copy the dealerPoss array into a new one, we need to preserve the original for doing the weighting
			var tmpPoss:Array = dealerPoss.slice(0);
			
			// Create and shuffle the decks
			deck = new Deck();
			deck.shuffle();
			discardDeck = new Deck( 0 );
			
			// Remove possible results for the deal based on what the user is supposed to win
			if( results.indexOf( RESULT_WIN ) >= 0 )
			{
				// If the user is supposed to win, we have to take away BlackJack and 21 from the dealer
				tmpPoss.splice( tmpPoss.indexOf( -1 ), 1 );
				tmpPoss.splice( tmpPoss.indexOf( 21 ), 1 );
			}
			
			if( results.indexOf( RESULT_LOSE ) >= 0 || results.indexOf( RESULT_PUSH ) >= 0 )
			{
				// If the user is supposed to push or lose, the dealer can't bust
				tmpPoss.splice( tmpPoss.indexOf( 26 ), 1 );
				tmpPoss.splice( tmpPoss.indexOf( 25 ), 1 );
				tmpPoss.splice( tmpPoss.indexOf( 24 ), 1 );
				tmpPoss.splice( tmpPoss.indexOf( 23 ), 1 );
				tmpPoss.splice( tmpPoss.indexOf( 22 ), 1 );
			}
			
			if( results.indexOf( RESULT_BLACKJACK) >= 0 )
			{
				// If the user is supposed to get BlackJack, the dealer can't get BlackJack
				if( tmpPoss.indexOf( -1 ) >= 0 )
				{
					tmpPoss.splice( tmpPoss.indexOf( -1 ), 1 );
				}
				
				// Also make sure to remove enough Aces from the deck to satisfy the User's Blackjacks later
				var blackjackCount:int = 0;
				for( i = 0; i < results.length; i++ )
				{
					if( results[i] == RESULT_BLACKJACK ) {
						discardDeck.addCard( deck.getCard( 1, "" ), false );		
					}
				}
			}
			
			// Copy the possible dealer hands in a new array, weighting them as we go
			for( i = 0; i < tmpPoss.length; i++ )
			{
				for( j = 0; j < dealerWght[dealerPoss.indexOf( tmpPoss[i] )]; j++ )
				{
					dealerPossWeighted.push( tmpPoss[i] );
				}
			}
			
			// Grab a random hand to see what the dealer is going to end up with
			dealerResult = dealerPossWeighted[MathHelper.randomNumber( 0, dealerPossWeighted.length - 1) ];
			ret.dealerValue = dealerValue = dealerResult == -1 ? 21 : dealerResult;
			avoidSplitAndDouble = dealerValue > 21;
			
			// Satisfy the dealer's hand
			hand = new Hand();
			tmpPile = null;
			while( tmpPile == null )
			{
				tmpPile = satisfyHand( dealerResult, gameType );
			}
			tmpPile.popCardsToPile( hand.drawCards );
			hand.playCards.addCard( hand.drawCards.drawCard() );
			hand.playCards.addCard( hand.drawCards.drawCard() );			
			ret.dealerHand = hand;
			
			// See what type of hand we should produce for this result
			for( i = 0; i < results.length; i++ )
			{
				hand = new Hand();
				ret.playerHands.push( hand );
				var total:int = 0;
				
				switch( results[i] )
				{
					case RESULT_WIN:
						// If the dealer busted, target the player for 17 or more
						// If the dealer didn't bust, target the play for at least 1 more than the dealer
						tmpPile = null;
						while( tmpPile == null )
						{
							total = dealerValue > 21 ? 17 + MathHelper.randomNumber( 0, 4 ) : dealerValue + 1 + MathHelper.randomNumber( 0, 21 - ( dealerValue + 1 ) );
							tmpPile = satisfyHand( total, gameType, avoidSplitAndDouble );
						}
						tmpPile.popCardsToPile( hand.drawCards );
						
						hand.playCards.addCard( hand.drawCards.drawCard() );
						hand.playCards.addCard( hand.drawCards.drawCard() );
						break;
					
					case RESULT_LOSE:
						// Target the user for a bust or for less than what the dealer received.
						var possibleValues:Array = [];
						for( j = 17; j <= 26; j++ )
						{
							if( j < dealerValue || j > 21 )
							{
								possibleValues.push( j );
								
								// Weight values less than the dealer more heavily so the player busts less often
								if( j < dealerValue )
								{
									possibleValues.push( j );
									possibleValues.push( j );
								}
							}
						}
						
						tmpPile = null;
						while( tmpPile == null )
						{
							total = possibleValues[MathHelper.randomNumber( 0, possibleValues.length - 1 )];
							tmpPile = satisfyHand( total, gameType, avoidSplitAndDouble );
						}
						tmpPile.popCardsToPile( hand.drawCards );
						
						hand.playCards.addCard( hand.drawCards.drawCard() );
						hand.playCards.addCard( hand.drawCards.drawCard() );						
						break;
					
					case RESULT_PUSH:
						// Target the user for the same thing the dealer got (use dealerResult and not dealerValue so we'll properly PUSH blackjacks)
						tmpPile = null;
						while( tmpPile == null )
						{
							total = dealerResult;
							tmpPile = satisfyHand( total, gameType, avoidSplitAndDouble );
						}
						tmpPile.popCardsToPile( hand.drawCards );
						
						hand.playCards.addCard( hand.drawCards.drawCard() );
						hand.playCards.addCard( hand.drawCards.drawCard() );						
						break;
					
					case RESULT_BLACKJACK:
						// This case is simple enough, just give them a 10 value card and a 1/11 value (ACE) card
						total = -1;
						
						hand.playCards.addCard( deck.getCardByFaceValue( gameType, 10, "" ) );
						hand.playCards.addCard( discardDeck.getTopCard() ); // We set aside our aces before in a discard deck, so grab one
						hand.playCards.shuffle();
						break;
				}
				
				ret.playerValues.push( total );
				logger.debug( "Return: " + ret.playerHands[i].playCards.toString() + " - " + ret.playerHands[i].drawCards.toString() );
			}
			
			// Push 3 empty spots of split hands and values
			ret.playerValues.push( null );
			ret.playerValues.push( null );
			ret.playerValues.push( null );
			ret.playerHands.push( null );
			ret.playerHands.push( null );
			ret.playerHands.push( null );
			
			// Clear Context
			logger.popContext();			
			return ret;
		}
		
		/**
		 * Returns a random number of cards between <code>minCards (inclusive)</code> and <code>maxCards (inclusive)</code>
		 * with a higher emphasis towards <code>minCards</code> based on weighting.
		 * 
		 * @param minCards the minimum amount of cards to be returned.
		 * @param maxCards the maximum amount of cards to be returned.
		 * @return An <code>int</code> representing a number of cards.
		 */
		private static function getWeightedCardCount( minCards:int, maxCards:int ):int
		{
			var weightedCounts:Array = [];
			var doubler:int = 2;
			
			for( var i:int = maxCards; i >= minCards; i-- )
			{
				for( var j:int = 0; j < doubler; j++ )
				{
					weightedCounts.push( i );
				}
				
				doubler *= 2;
			}
			
			return weightedCounts[ MathHelper.randomNumber( 0, weightedCounts.length - 1 ) ];
		}
	}
}