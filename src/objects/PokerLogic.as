package objects
{
	import utils.DebugHelper;
	import utils.MathHelper;
	
	public class PokerLogic
	{
		public static const HAND_ROYAL_FLUSH:String 	= "royal_flush";
		public static const HAND_STRAIGHT_FLUSH:String 	= "straight_flush";
		public static const HAND_FOUR_OF_A_KIND:String 	= "four_of_a_kind";
		public static const HAND_FULL_HOUSE:String 		= "full_house";
		public static const HAND_FLUSH:String 			= "flush";
		public static const HAND_STRAIGHT:String 		= "straight";
		public static const HAND_THREE_OF_A_KIND:String = "three_of_a_kind";
		public static const HAND_TWO_PAIR:String	 	= "two_pair";
		public static const HAND_JACKS_OR_BETTER:String	= "jacks_or_better";
		
		public static const HAND_4_OF_5_STRAIGHT_FLUSH:String 	= "4_of_5_straight_fush";
		public static const HAND_4_OF_5_FLUSH:String 		 	= "4_of_5_flush";
		public static const HAND_4_OF_5_STRAIGHT:String 		= "4_of_5_straight";
		public static const HAND_LOW_PAIR:String 				= "low_pair";
		public static const HAND_HIGH_CARD:String 				= "high_card";
		
		public static const HAND_NONE:String 					= "none";
		
		// Logging
		private static const logger:DebugHelper = new DebugHelper( PokerLogic );			
		
		public function PokerLogic()
		{
		}		
		
		/**
		 *  Returns a hand, filled with cards to satisfy the winning hand requested.
		 */	
		public static function satisfyHand( winningHand:String, tmpRandom:int ):Hand
		{
			// Log Activity
			logger.pushContext( "satisfyHand", arguments );
			
			var suitArray:Array, i:int, j:int, k:int;
			var deck:Deck = new Deck();
			var discardDeck:Deck = new Deck();
			var hand:Hand = new Hand();
			
			suitArray =
				[
					[Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS],
					[Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_HEARTS],
					[Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS],
					[Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS],
				][MathHelper.randomNumber( 0, 3 )];			
			
			switch( winningHand )
			{
				case HAND_LOW_PAIR:
					deck.removeStraight( MathHelper.randomNumber( 0, 4 ), discardDeck );
					hand.drawCards.addCard( deck.getLowCard( suitArray.pop() ) );
					hand.drawCards.addCard( deck.getCard( hand.drawCards.getCard( 0 ).value, suitArray.pop() ) );					
					deck.removeCards( hand.drawCards.getCard( 1 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 2 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 3 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 4 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 6 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 7 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 8 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 9 ).value, "", discardDeck );
					
					hand.drawCards.swap( 0, 9 );
					hand.drawCards.swap( 1, 8 );
					hand.drawCards.popCardsToPile( hand.tempCards, 5 )
					break;
				
				case HAND_4_OF_5_STRAIGHT:
					k = deck.removeStraight( MathHelper.randomNumber( 0, 4 ), discardDeck );
					k = k + 2 + MathHelper.randomNumber( 0, 1 ) * 5;
					
					hand.drawCards.addCard( deck.getCard( k + 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 0 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( k + 1, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 1 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( k + 2, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 2 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( k + 3, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 3 ).value, "", discardDeck );	
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 4 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 6 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 7 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 8 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 9 ).value, "", discardDeck );	
					
					hand.drawCards.swap( 0, 9 );
					hand.drawCards.swap( 1, 8 );
					hand.drawCards.swap( 2, 7 );
					hand.drawCards.swap( 3, 6 );
					hand.drawCards.popCardsToPile( hand.tempCards, 5 )
					break;
				
				case HAND_4_OF_5_STRAIGHT_FLUSH:
					suitArray =
					[
						[Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS],
						[Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS],
						[Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS],
						[Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES],
					][MathHelper.randomNumber( 0, 3 )];	
					
					k = deck.removeStraight( MathHelper.randomNumber( 0, 4 ), discardDeck );
					k = k + 2 + MathHelper.randomNumber( 0, 1 ) * 5;
					
					hand.drawCards.addCard( deck.getCard( k + 0, suitArray.pop()));
					deck.removeCards( hand.drawCards.getCard( 0 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( k + 1, hand.drawCards.getCard( 0 ).suit ) );
					deck.removeCards( hand.drawCards.getCard( 1 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( k + 2, hand.drawCards.getCard( 0 ).suit ) );
					deck.removeCards( hand.drawCards.getCard( 2 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( k + 3, hand.drawCards.getCard( 0 ).suit ) );
					deck.removeCards( hand.drawCards.getCard( 3 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 4 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 6 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 7 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 8 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 9 ).value, "", discardDeck );	
					
					hand.drawCards.swap( 0, 9 );
					hand.drawCards.swap( 1, 8 );
					hand.drawCards.swap( 2, 7 );
					hand.drawCards.swap( 3, 6 );
					hand.drawCards.popCardsToPile( hand.tempCards, 5 )					
					break;
				
				case HAND_4_OF_5_FLUSH:
					suitArray =
					[
						[Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS],
						[Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_CLUBS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS],
						[Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_SPADES, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS],
						[Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_HEARTS, Card.SUIT_DIAMONDS, Card.SUIT_CLUBS, Card.SUIT_SPADES],
					][MathHelper.randomNumber( 0, 3 )];		
					
					deck.removeStraight( MathHelper.randomNumber( 0, 4 ), discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 0 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, hand.drawCards.getCard( 0 ).suit ) );
					deck.removeCards( hand.drawCards.getCard( 1 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, hand.drawCards.getCard( 0 ).suit ) );
					deck.removeCards( hand.drawCards.getCard( 2 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, hand.drawCards.getCard( 0 ).suit ) );
					deck.removeCards( hand.drawCards.getCard( 3 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 4 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 6 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 7 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 8 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0 , suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 9 ).value, "", discardDeck );
					
					hand.drawCards.swap( 0, 9 );
					hand.drawCards.swap( 1, 8 );
					hand.drawCards.swap( 2, 7 );
					hand.drawCards.swap( 3, 6 );
					hand.drawCards.popCardsToPile( hand.tempCards, 5 )				
					break;
				
				case HAND_JACKS_OR_BETTER:
					hand.antiScaleUsed = deck.removeStraight( MathHelper.randomNumber( 0, 4 ), discardDeck );
					
					hand.drawCards.addCard( deck.getHighCard( suitArray.pop() ) );
					hand.drawCards.addCard( deck.getCard( hand.drawCards.getCard( 0 ).value, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 0 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 2 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, hand.drawCards.getCard( 0 ).suit ) );
					deck.removeCards( hand.drawCards.getCard( 3 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 4 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 6 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 7 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 8 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0 , suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 9 ).value, "", discardDeck );
					hand.highCard = hand.drawCards.getCard( 0 );
					
					
					if( tmpRandom == 1 )
					{
						hand.drawCards.swap( 0, 9 );
						hand.drawCards.swap( 1, 8 );						
						hand.drawCards.popCardsToPile( hand.tempCards, 5 )
						hand.drawCards.shuffle();
					}
					else
					{
						hand.drawCards.shuffle();
						hand.drawCards.popCardsToPile( hand.tempCards, 5 )
						
						j = 1;
						for( i = 0; i < 3; i++ )
						{
							if( hand.highCard.value == hand.drawCards.getCard( i ).value )
							{
								hand.drawCards.swap( i, hand.drawCards.cardCount - j );
								j++;
								i--;
							}
						}
					}
					break;
				
				case HAND_TWO_PAIR:
					hand.antiScaleUsed = deck.removeStraight( MathHelper.randomNumber( 0, 4 ), discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					hand.drawCards.addCard( deck.getCard( hand.drawCards.getCard( 0 ).value, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 0 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					hand.drawCards.addCard( deck.getCard( hand.drawCards.getCard( 2 ).value, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 3 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 4 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 6 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 7 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 8 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 9 ).value, "", discardDeck );		
					
					hand.highCard = hand.drawCards.getCard( 0 );
					hand.highCard2 = hand.drawCards.getCard( 2 );
					
					if( tmpRandom == 1 )
					{
						hand.drawCards.swap( 0, 9 );
						hand.drawCards.swap( 1, 8 );
						hand.drawCards.swap( 2, 7 );
						hand.drawCards.swap( 3, 6 );
						hand.drawCards.popCardsToPile( hand.tempCards, 5 )
						hand.drawCards.shuffle();
					}
					else
					{
						if( hand.drawCards.getCard( 0 ).isFaceCard && hand.drawCards.getCard( 2 ).isFaceCard )
						{
							k = MathHelper.randomNumber( 0, 3 );
						}
						else if( hand.drawCards.getCard( 0 ).isFaceCard || hand.drawCards.getCard( 2 ).isFaceCard )
						{
							k = MathHelper.randomNumber( 0, 2 );
						}
						else
						{
							k = MathHelper.randomNumber( 0, 1 );
						}
						
						switch( k )
						{
							case 0:
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								hand.drawCards.swap( 0, 4 );
								break;
							
							case 1:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								hand.drawCards.swap( 2, 4 );
								break;
							
							case 2:
								if( hand.drawCards.getCard( 0 ).isFaceCard && hand.drawCards.getCard( 2 ).isFaceCard )
								{
									hand.drawCards.swap( 0, 9 );
									hand.drawCards.popCardsToPile( hand.tempCards, 5 )
									hand.drawCards.swap( 1, 4 );
								}
								else
								{
									hand.drawCards.swap( 1, 9 );
									hand.drawCards.popCardsToPile( hand.tempCards, 5 )
									hand.drawCards.swap( 0, 4 );									
								}
								break;
							
							case 3:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 2, 8 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								hand.drawCards.swap( 1, 4 );								
								break;
						}
					}
					break;
				
				case HAND_THREE_OF_A_KIND:
					hand.antiScaleUsed = deck.removeStraight( MathHelper.randomNumber( 0, 4 ), discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 0 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 1 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 2 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 3 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 4 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 6 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					hand.drawCards.addCard( deck.getCard( hand.drawCards.getCard( 7 ).value, suitArray.pop() ) );
					hand.drawCards.addCard( deck.getCard( hand.drawCards.getCard( 7 ).value, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 9 ).value, "", discardDeck );
					
					if( tmpRandom == 1 )
					{
						hand.drawCards.popCardsToPile( hand.tempCards, 5 )
						hand.drawCards.shuffle();
					}
					else
					{
						if( hand.drawCards.getCard( 7 ).isFaceCard )
						{
							k = MathHelper.randomNumber( 0, 2 );
						}
						else
						{
							k = MathHelper.randomNumber( 0, 1 );
						}
						
						switch( k )
						{							
							case 0:
								hand.drawCards.swap( 9, 4 );
								hand.drawCards.swap( 8, 3 );
								hand.drawCards.swap( 7, 2 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 1:
								hand.drawCards.swap( 9, 4 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 2:
								hand.drawCards.swap( 9, 4 );
								hand.drawCards.swap( 8, 3 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
						}
					}
					break;
				
				case HAND_STRAIGHT:
					j = MathHelper.randomNumber( 1, 9 );
					
					hand.drawCards.addCard( deck.getCard( j, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 0 ).value, "", discardDeck );
					deck.addCard( discardDeck.getTopCard() );
					deck.addCard( discardDeck.getTopCard() );
					
					hand.drawCards.addCard( deck.getCard( j + 1, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 1 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( j + 2, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 2 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( j + 3, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 3 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( j + 4, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 4 ).value, "", discardDeck );	
					
					deck.shuffle();
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );					
					if( hand.drawCards.getCard( 5 ).value != hand.drawCards.getCard( 0 ).value )
					{
						deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					}
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					if( hand.drawCards.getCard( 6 ).value != hand.drawCards.getCard( 0 ).value )
					{
						deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					}
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					if( hand.drawCards.getCard( 7 ).value != hand.drawCards.getCard( 0 ).value )
					{
						deck.removeCards( hand.drawCards.getCard( 7 ).value, "", discardDeck );
					}
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					if( hand.drawCards.getCard( 8 ).value != hand.drawCards.getCard( 0 ).value )
					{
						deck.removeCards( hand.drawCards.getCard( 8 ).value, "", discardDeck );
					}
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					if( hand.drawCards.getCard( 9 ).value != hand.drawCards.getCard( 0 ).value )
					{
						deck.removeCards( hand.drawCards.getCard( 9 ).value, "", discardDeck );
					}		
					
					if( tmpRandom == 1 )
					{
						hand.drawCards.swap( 0, 9 );
						hand.drawCards.swap( 1, 8 );
						hand.drawCards.swap( 2, 7 );
						hand.drawCards.swap( 3, 6 );
						hand.drawCards.swap( 4, 5 );
						hand.drawCards.popCardsToPile( hand.tempCards, 5 )
					}
					else
					{
						k = MathHelper.randomNumber( 0, 2 );
						if( k == 0 && ( hand.drawCards.getCard( 5 ).isFaceCard || hand.drawCards.getCard( 6 ).isFaceCard || hand.drawCards.getCard( 7 ).isFaceCard || hand.drawCards.getCard( 8 ).isFaceCard || hand.drawCards.getCard( 9 ).isFaceCard ) )
						{
							k = 2;
						}
						
						switch ( k )
						{
							case 0:
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 1:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.swap( 2, 7 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )								
								break;
							
							case 2:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.swap( 2, 7 );
								hand.drawCards.swap( 3, 6 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 3:
								hand.drawCards.swap( 4, 5 );
								hand.drawCards.swap( 0, 4 )
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 4:
								hand.drawCards.swap( 3, 6 );
								hand.drawCards.swap( 4, 5 );
								hand.drawCards.swap( 0, 4 );
								hand.drawCards.swap( 1, 3 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
						}
					}
					break;
				
				case HAND_FLUSH:
					hand.antiScaleUsed = deck.removeStraight( MathHelper.randomNumber( 0, 4 ), discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					deck.removeCards( hand.drawCards.getCard( 0 ).value, "", discardDeck );
					deck.addCard( discardDeck.getTopCard() );
					deck.addCard( discardDeck.getTopCard() );
					
					hand.drawCards.addCard( deck.getCard( 0, hand.drawCards.getCard( 0 ).suit ) );
					deck.removeCards( hand.drawCards.getCard( 1 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, hand.drawCards.getCard( 0 ).suit ) );
					deck.removeCards( hand.drawCards.getCard( 2 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, hand.drawCards.getCard( 0 ).suit ) );
					deck.removeCards( hand.drawCards.getCard( 3 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, hand.drawCards.getCard( 0 ).suit ) );
					deck.removeCards( hand.drawCards.getCard( 4 ).value, "", discardDeck );	
					
					deck.shuffle();
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );					
					if( hand.drawCards.getCard( 5 ).value != hand.drawCards.getCard( 0 ).value )
					{
						deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					}
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					if( hand.drawCards.getCard( 6 ).value != hand.drawCards.getCard( 0 ).value )
					{
						deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					}
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					if( hand.drawCards.getCard( 7 ).value != hand.drawCards.getCard( 0 ).value )
					{
						deck.removeCards( hand.drawCards.getCard( 7 ).value, "", discardDeck );
					}
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					if( hand.drawCards.getCard( 8 ).value != hand.drawCards.getCard( 0 ).value )
					{
						deck.removeCards( hand.drawCards.getCard( 8 ).value, "", discardDeck );
					}
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					if( hand.drawCards.getCard( 9 ).value != hand.drawCards.getCard( 0 ).value )
					{
						deck.removeCards( hand.drawCards.getCard( 9 ).value, "", discardDeck );
					}		
					
					if( tmpRandom == 1 )
					{
						hand.drawCards.swap( 0, 9 );
						hand.drawCards.swap( 1, 8 );
						hand.drawCards.swap( 2, 7 );
						hand.drawCards.swap( 3, 6 );
						hand.drawCards.swap( 4, 5 );
						hand.drawCards.popCardsToPile( hand.tempCards, 5 )
					}
					else
					{
						k = MathHelper.randomNumber( 0, 2 );
						if( k == 0 && ( hand.drawCards.getCard( 5 ).isFaceCard || hand.drawCards.getCard( 6 ).isFaceCard || hand.drawCards.getCard( 7 ).isFaceCard || hand.drawCards.getCard( 8 ).isFaceCard || hand.drawCards.getCard( 9 ).isFaceCard ) )
						{
							k = 2;
						}
						
						switch ( k )
						{
							case 0:
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 1:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.swap( 2, 7 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )								
								break;
							
							case 2:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.swap( 2, 7 );
								hand.drawCards.swap( 3, 6 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 3:
								for( i = 0; i < 5; i++ )
								{
									if( hand.drawCards.getCard( i ).isFaceCard )
									{
										hand.drawCards.swap( i, i + 5 );
										hand.drawCards.swap( i, 0 );
									}
								}
								
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 4:
								j = 0;
								for( i = 0; i < 5; i++ )
								{
									if( hand.drawCards.getCard( i ).isFaceCard )
									{
										hand.drawCards.swap( i, i + 5 );
										hand.drawCards.swap( i, j );
										j++;
										if( j > 1 )
										{
											break;
										}
									}
								}
								
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
						}						
					}					
					break;
				
				case HAND_FULL_HOUSE:
					hand.antiScaleUsed = deck.removeStraight( MathHelper.randomNumber( 0, 4 ), discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					hand.drawCards.addCard( deck.getCard( hand.drawCards.getCard( 0 ).value, "" ) );
					hand.drawCards.addCard( deck.getCard( hand.drawCards.getCard( 0 ).value, "" ) );
					deck.removeCards( hand.drawCards.getCard( 0 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					hand.drawCards.addCard( deck.getCard( hand.drawCards.getCard( 3 ).value, "" ) );
					deck.removeCards( hand.drawCards.getCard( 4 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					deck.removeCards( hand.drawCards.getCard( 6 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					deck.removeCards( hand.drawCards.getCard( 7 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					deck.removeCards( hand.drawCards.getCard( 8 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					deck.removeCards( hand.drawCards.getCard( 9 ).value, "", discardDeck );	
					
					if( tmpRandom == 1 )
					{
						hand.drawCards.swap( 0, 9 );
						hand.drawCards.swap( 1, 8 );
						hand.drawCards.swap( 2, 7 );
						hand.drawCards.swap( 3, 6 );
						hand.drawCards.swap( 4, 5 );
						hand.drawCards.popCardsToPile( hand.tempCards, 5 )
					}
					else
					{
						if( hand.drawCards.getCard( 0 ).isFaceCard && hand.drawCards.getCard( 3 ).isFaceCard )
						{
							k = MathHelper.randomNumber( 0, 5 );
						}
						else if( hand.drawCards.getCard( 0 ).isFaceCard || hand.drawCards.getCard( 3 ).isFaceCard )
						{
							k = MathHelper.randomNumber( 0, 4 );
						}
						
						if( k == 0 && ( hand.drawCards.getCard( 5 ).isFaceCard || hand.drawCards.getCard( 6 ).isFaceCard || hand.drawCards.getCard( 7 ).isFaceCard || hand.drawCards.getCard( 8 ).isFaceCard || hand.drawCards.getCard( 9 ).isFaceCard ) )
						{
							k = 2;	
						}
						
						switch( k )
						{
							case 0:
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 1:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 2:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.swap( 3, 7 );
								hand.drawCards.swap( 4, 6 );		
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 3:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.swap( 2, 7 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 4:
								if( hand.drawCards.getCard( 0 ).isFaceCard )
								{
									hand.drawCards.swap( 0, 9 );
								}
								else
								{
									hand.drawCards.swap( 3, 9 );
									hand.drawCards.swap( 0, 3 );
								}
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 5:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 3, 8 );
								hand.drawCards.swap( 1, 3 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;							
						}
					}
					break;
				
				case HAND_FOUR_OF_A_KIND:
					hand.antiScaleUsed = deck.removeStraight( MathHelper.randomNumber( 0, 4 ), discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					hand.drawCards.addCard( deck.getCard( hand.drawCards.getCard( 0 ).value, "" ) );
					hand.drawCards.addCard( deck.getCard( hand.drawCards.getCard( 0 ).value, "" ) );
					hand.drawCards.addCard( deck.getCard( hand.drawCards.getCard( 0 ).value, "" ) );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					deck.removeCards( hand.drawCards.getCard( 4 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					deck.removeCards( hand.drawCards.getCard( 6 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					deck.removeCards( hand.drawCards.getCard( 7 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					deck.removeCards( hand.drawCards.getCard( 8 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					deck.removeCards( hand.drawCards.getCard( 9 ).value, "", discardDeck );
					
					if( tmpRandom == 1 )
					{
						hand.drawCards.swap( 0, 9 );
						hand.drawCards.swap( 1, 8 );
						hand.drawCards.swap( 2, 7 );
						hand.drawCards.swap( 3, 6 );
						hand.drawCards.popCardsToPile( hand.tempCards, 5 )
					}
					else
					{
						if( hand.drawCards.getCard( 0 ).isFaceCard )
						{
							k = MathHelper.randomNumber( 0, 3 );
						}
						else
						{
							k = MathHelper.randomNumber( 0, 2 );
						}
						
						if( k == 0 && ( hand.drawCards.getCard( 5 ).isFaceCard || hand.drawCards.getCard( 6 ).isFaceCard || hand.drawCards.getCard( 7 ).isFaceCard || hand.drawCards.getCard( 8 ).isFaceCard || hand.drawCards.getCard( 9 ).isFaceCard ) )
						{
							k = 2;	
						}
						
						switch( k )
						{
							case 0:
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break;
							
							case 1:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								hand.drawCards.swap( 2, 4 );
								hand.drawCards.swap( 3, 3 );
								break;
							
							case 2:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.swap( 2, 7 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								hand.drawCards.swap( 3, 4 );
								break;
							
							case 3:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 4 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )
								break
						}
					}
					break;		
				
				case HAND_STRAIGHT_FLUSH:
					j = MathHelper.randomNumber( 1, 9 );
					if( j != 1 )
					{
						deck.removeCards( 1, "", discardDeck );	
					}
					else
					{
						deck.removeCards( 12, "", discardDeck );
					}
					
					hand.drawCards.addCard( deck.getCard( j, "" ) );
					hand.drawCards.addCard( deck.getCard( j + 1, hand.drawCards.getCard( 0 ).suit ) );
					hand.drawCards.addCard( deck.getCard( j + 2, hand.drawCards.getCard( 0 ).suit ) );
					hand.drawCards.addCard( deck.getCard( j + 3, hand.drawCards.getCard( 0 ).suit ) );
					hand.drawCards.addCard( deck.getCard( j + 4, hand.drawCards.getCard( 0 ).suit ) );
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					
					if( tmpRandom == 1 )
					{
						hand.drawCards.swap( 0, 9 );
						hand.drawCards.swap( 1, 8 );
						hand.drawCards.swap( 2, 7 );
						hand.drawCards.swap( 3, 6 );
						hand.drawCards.swap( 4, 5 );
						hand.drawCards.popCardsToPile( hand.tempCards, 5 )
					}
					else
					{
						k = MathHelper.randomNumber( 0, 1 );
						
						switch( k )
						{
							case 0:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.swap( 2, 7 );
								hand.drawCards.swap( 3, 6 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )							
								break;
							
							case 1:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.swap( 2, 7 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )								
								break;
							
							case 2:
								hand.drawCards.swap( 3, 6 );
								hand.drawCards.swap( 4, 5 );
								hand.drawCards.swap( 0, 4 );
								hand.drawCards.swap( 1, 3 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )								
								break;
						}
					}
					break;
				
				case HAND_ROYAL_FLUSH:
					hand.drawCards.addCard( deck.getCard( 10, "" ) );
					hand.drawCards.addCard( deck.getCard( 11, hand.drawCards.getCard( 0 ).suit ) );
					hand.drawCards.addCard( deck.getCard( 12, hand.drawCards.getCard( 0 ).suit ) );
					hand.drawCards.addCard( deck.getCard( 13, hand.drawCards.getCard( 0 ).suit ) );
					hand.drawCards.addCard( deck.getCard( 1, hand.drawCards.getCard( 0 ).suit ) );
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					hand.drawCards.addCard( deck.getCard( 0, "" ) );
					
					if( tmpRandom == 1 )
					{
						hand.drawCards.swap( 0, 9 );
						hand.drawCards.swap( 1, 8 );
						hand.drawCards.swap( 2, 7 );
						hand.drawCards.swap( 3, 6 );
						hand.drawCards.swap( 4, 5 );
						hand.drawCards.popCardsToPile( hand.tempCards, 5 )						
					}
					else
					{
						k = MathHelper.randomNumber( 0, 1 );
						
						switch( k )
						{
							case 0:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.swap( 2, 7 );
								hand.drawCards.swap( 3, 6 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )								
								break;
							
							case 1:
								hand.drawCards.swap( 0, 9 );
								hand.drawCards.swap( 1, 8 );
								hand.drawCards.swap( 2, 7 );
								hand.drawCards.popCardsToPile( hand.tempCards, 5 )									
								break;
						}						
					}
					break;
				
				case HAND_NONE:
				default:
					deck.removeStraight( MathHelper.randomNumber( 0, 4 ), discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 0 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 1 ).value, "", discardDeck );					
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 2 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 3 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 4 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 5 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 6 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 7 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 8 ).value, "", discardDeck );
					
					hand.drawCards.addCard( deck.getCard( 0, suitArray.pop() ) );
					deck.removeCards( hand.drawCards.getCard( 9 ).value, "", discardDeck );	
					
					hand.drawCards.shuffle();
					hand.drawCards.popCardsToPile( hand.tempCards, 5 )
					break;
			}
			
			hand.tempCards.shuffle();
			hand.tempCards.popCardsToPile( hand.playCards, 5 );	
			
			// Clear Context
			logger.popContext();			
			return hand;
		}
		
		/**
		 *  Checks to see if the passed in hand is a winner and returns the win.
		 */			
		public static function getWinningHand( hand:Hand ):String
		{
			// Log Activity
			logger.pushContext( "getWinningHand", arguments );
			
			var winningHand:String = PokerLogic.HAND_NONE;
			
			// Check for ROYAL FLUSH
			if( isRoyalFlush( hand ) )
				winningHand = PokerLogic.HAND_ROYAL_FLUSH;
			
			// Check for STRAIGHT FLUSH
			else if( isStraightFlush( hand ) )
				winningHand = PokerLogic.HAND_STRAIGHT_FLUSH;
			
			// Check for FOUR OF A KIND
			else if( isFourOfAKind( hand ) )
				winningHand = PokerLogic.HAND_FOUR_OF_A_KIND;
			
			// Check for a FULL HOUSE
			else if( isFullHouse( hand ) )
				winningHand = PokerLogic.HAND_FULL_HOUSE;
						
			// Check for a FLUSH
			else if( isFlush( hand ) )
				winningHand = PokerLogic.HAND_FLUSH;
						
			// Check for a STRAIGHT
			else if( isStraight( hand ) )
				winningHand = PokerLogic.HAND_STRAIGHT;
						
			// Check for THREE OF A KIND
			else if( isThreeOfAKind( hand ) )
				winningHand = PokerLogic.HAND_THREE_OF_A_KIND;
						
			// Check for TWO PAIR
			else if( isTwoPair( hand ) )
				winningHand = PokerLogic.HAND_TWO_PAIR;
						
			// Check for JACKS OR BETTER
			else if( isPair( hand, true ) )
				winningHand = PokerLogic.HAND_JACKS_OR_BETTER;
			
			// Check for 4/5ths STRAIGHT FLUSH
			else if( is4Of5StraightFlush( hand ) )
				winningHand = PokerLogic.HAND_4_OF_5_STRAIGHT_FLUSH;
			
			// Check for 4/5ths FLUSH
			else if( is4Of5Flush( hand ) )
				winningHand = PokerLogic.HAND_4_OF_5_FLUSH;
			
			// Check for 4/5ths STRAIGHT
			else if( is4Of5Straight( hand ) )
				winningHand = PokerLogic.HAND_4_OF_5_STRAIGHT;
			
			// Check for LOW PAIR
			else if( isPair( hand, false ) )
				winningHand = PokerLogic.HAND_LOW_PAIR;
			
			// Check for a HIGH CARD
			else if( isHighCard( hand ) )
				winningHand = PokerLogic.HAND_HIGH_CARD;
			
			// Clear Context
			logger.popContext();			
			return winningHand;		
		}
		
		
		/**
		 * Checks to see if the supplied hand is a ROYAL FLUSH
		 */
		private static function isRoyalFlush( hand:Hand ):Boolean
		{
			var cards:Array = hand.playCards.getOrderedCopy();
			
			if( cards[0].value == 1 && cards[1].value == 10 && cards[2].value == 11 && cards[3].value == 12 && cards[4].value == 13 )
			{
				if( cards[0].suit == cards[1].suit && cards[0].suit == cards[2].suit && cards[0].suit == cards[3].suit && cards[0].suit == cards[4].suit )
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Checks to see if the supplied hand is a STRAIGHT FLUSH
		 */
		private static function isStraightFlush( hand:Hand ):Boolean
		{
			var cards:Array = hand.playCards.getOrderedCopy();
			
			if( cards[0].value == cards[1].value - 1 && cards[1].value == cards[2].value - 1 && cards[2].value == cards[3].value - 1 && cards[3].value == cards[4].value - 1 )
			{
				if( cards[0].suit == cards[1].suit && cards[0].suit == cards[2].suit && cards[0].suit == cards[3].suit && cards[0].suit == cards[4].suit )
				{
					return true;
				}
			}
			
			return false;			
		}
		
		/**
		 * Checks to see if the supplied hand is FOUR OF A KIND
		 */
		private static function isFourOfAKind( hand:Hand ):Boolean
		{
			var cards:Array = hand.playCards.getOrderedCopy();
			var arrValues:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], i:int;
			
			for( i = 0; i < cards.length; i++ )
			{
				arrValues[cards[i].value - 1] += 1;
				if( arrValues[cards[i].value - 1]  == 4 )
				{
					hand.highCard = cards[i];
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Checks to see if the supplied hand is a FULL HOUSE
		 */
		private static function isFullHouse( hand:Hand ):Boolean
		{
			var cards:Array = hand.playCards.getOrderedCopy();
			var arrValues:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], i:int, j:int;
			
			for( i = 0; i < cards.length; i++ )
			{
				arrValues[cards[i].value - 1] += 1;
			}
			
			for( i = 0; i < 13; i++ )
			{
				if( arrValues[i] == 3 )
				{
					hand.highCard = new Card( i + 1, "" );
					for( j = 0; j < 13; j++ )
					{
						if( arrValues[j] == 2 )
						{
							hand.highCard2 = new Card( j + 1, "" );
							return true;
						}
					}
				}
			}
			
			return false;
		}
		
		/**
		 * Checks to see if the supplied hand is a FLUSH
		 */
		private static function isFlush( hand:Hand ):Boolean
		{
			var cards:Array = hand.playCards.getOrderedCopy();
			
			if( cards[0].suit == cards[1].suit && cards[0].suit == cards[2].suit && cards[0].suit == cards[3].suit && cards[0].suit == cards[4].suit )
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * Checks to see if the supplied hand is a STRAIGHT
		 */
		private static function isStraight( hand:Hand ):Boolean
		{
			var cards:Array = hand.playCards.getOrderedCopy();
			
			if( cards[0].value == cards[1].value - 1 && cards[1].value == cards[2].value - 1 && cards[2].value == cards[3].value - 1 && cards[3].value == cards[4].value - 1 )
			{
				return true;
			}
			else if( cards[0].value == 1 && cards[1].value == 10 && cards[2].value == 11 && cards[3].value == 12 && cards[4].value == 13 )
			{
				return true;
			}
			
			return false;				
		}
		
		/**
		 * Checks to see if the supplied hand is THREE OF A KIND
		 */
		private static function isThreeOfAKind( hand:Hand ):Boolean
		{
			var cards:Array = hand.playCards.getOrderedCopy();
			var arrValues:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], i:int, j:int;
			
			for( i = 0; i < cards.length; i++ )
			{
				arrValues[cards[i].value - 1] += 1;
			}
			
			for( i = 0; i < 13; i++ )
			{
				if( arrValues[i] == 3 )
				{
					hand.highCard = new Card(  i + 1, "" );
					return true;
				}
			}
			
			return false;			
		}		
		
		/**
		 * Checks to see if the supplied hand is TWO PAIR
		 */
		private static function isTwoPair( hand:Hand ):Boolean
		{
			var cards:Array = hand.playCards.getOrderedCopy();
			var arrValues:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], i:int, j:int;
			
			for( i = 0; i < cards.length; i++ )
			{
				arrValues[cards[i].value - 1] += 1;
			}
			
			for( i = 0; i < 13; i++ )
			{
				if( arrValues[i] == 2 )
				{
					hand.highCard = new Card( i + 1, "" );
					for( j = i + 1; j < 13; j++ )
					{
						if( arrValues[j] == 2 )
						{
							hand.highCard2 = new Card( j + 1, "" );
							return true;
						}
					}
				}
			}
			
			return false;			
		}
		
		/**
		 * Checks to see if the supplied hand is a PAIR, optionall checking for JACKS OR BETTER
		 */
		private static function isPair( hand:Hand, highCard:Boolean = true ):Boolean
		{
			var cards:Array = hand.playCards.getOrderedCopy();
			var arrValues:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], i:int, j:int;
			
			for( i = 0; i < cards.length; i++ )
			{
				arrValues[cards[i].value - 1] += 1;
			}
			
			for( i = 0; i < 13; i++ )
			{
				if( arrValues[i] == 2 )
				{
					hand.highCard = new Card( i + 1, "" );
					if( highCard )
					{
						if( hand.highCard.isFaceCard )
						{
							return true;
						}
						else
						{
							return false;
						}
					}
					else
					{
						return true;
					}
				}
			}
			
			return false;				
		}
		
		/**
		 * Checks to see if the supplied hand is a 4/5 STRAIGHT FLUSH
		 */
		private static function is4Of5StraightFlush( hand:Hand ):Boolean
		{
			// If we have a straight
			if( is4Of5Straight( hand ) )
			{
				// Get an array of the cards in the hand
				var cards:Array = hand.playCards.getOrderedCopy();
				
				// Remove the high card (which is set in 'is4OfStraight' and is the card NOT in the straight )
				cards.splice( cards.indexOf( hand.highCard ), 1 );
				
				// If the remaining cards in the straight are the same suit, we have a Partial Straight Flush
				if( cards[0].suit == cards[1].suit && cards[0].suit == cards[2].suit && cards[0].suit == cards[3].suit )
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Checks to see if the supplied hand is a 4/5 FLUSH
		 */
		private static function is4Of5Flush( hand:Hand ):Boolean
		{
			var cards:Array = hand.playCards.getOrderedCopy();
			
			if( cards[0].suit == cards[1].suit && cards[1].suit == cards[2].suit && cards[2].suit == cards[3].suit )
			{
				hand.highCard = cards[0];
				return true;
			}
			
			if( cards[0].suit == cards[1].suit && cards[1].suit == cards[2].suit && cards[2].suit == cards[4].suit )
			{
				hand.highCard = cards[0];
				return true;
			}
			
			if( cards[0].suit == cards[1].suit && cards[1].suit == cards[3].suit && cards[3].suit == cards[4].suit )
			{
				hand.highCard = cards[0];
				return true;
			}
			
			if( cards[0].suit == cards[2].suit && cards[2].suit == cards[3].suit && cards[3].suit == cards[4].suit )
			{
				hand.highCard = cards[0];
				return true;
			}
			
			if( cards[1].suit == cards[2].suit && cards[2].suit == cards[3].suit && cards[3].suit == cards[4].suit )
			{
				hand.highCard = cards[1];
				return true;
			}	
			
			return false;
		}
		
		/**
		 * Checks to see if the supplied hand is a 4/5 SCALE
		 */
		private static function is4Of5Straight( hand:Hand ):Boolean
		{
			var cards:Array = hand.playCards.getOrderedCopy();
			
			// 4 sequential cards, 1 odd ball
			// ========================================
			// ?, 4, 5, 6, 7
			if( cards[2].value == cards[1].value + 1 && cards[3].value == cards[2].value + 1 && cards[4].value == cards[3].value + 1 )
			{
				hand.highCard = cards[0];
				return true;
			}			
			// 3, 4, 5, 6, ?
			if( cards[1].value == cards[0].value + 1 && cards[2].value == cards[1].value + 1 && cards[3].value == cards[2].value + 1 )
			{
				hand.highCard = cards[4];
				return true;
			}						
			// ?, 10, 11, 12, 13
			if( cards[1].value == 10 && cards[2].value == 11 && cards[3].value == 12 && cards[4].value == 13 )
			{
				hand.highCard = cards[0];
				return true;
			}			
			
			// 3 sequential cards, 1 card that is +1 off but still part of the straight, 1 odd ball
			// ========================================
			// ?, 4, 6, 7, 8
			if( cards[2].value == cards[1].value + 2 && cards[3].value == cards[2].value + 1 && cards[4].value == cards[3].value + 1 )
			{
				hand.highCard = cards[0];
				return true;
			}
			
			// ?, 4, 5, 7, 8
			if( cards[2].value == cards[1].value + 1 && cards[3].value == cards[2].value + 2 && cards[4].value == cards[3].value + 1 )
			{
				hand.highCard = cards[0];
				return true;
			}
			
			// ?, 4, 5, 6, 8
			if( cards[2].value == cards[1].value + 1 && cards[3].value == cards[2].value + 1 && cards[4].value == cards[3].value + 2 )
			{
				hand.highCard = cards[0];
				return true;
			}
			
			// 3, 5, 6, 7, ?
			if( cards[1].value == cards[0].value + 2 && cards[2].value == cards[1].value + 1 && cards[3].value == cards[2].value + 1 )
			{
				hand.highCard = cards[4];
				return true;
			}
			
			// 3, 4, 6, 7, ?
			if( cards[1].value == cards[0].value + 1 && cards[2].value == cards[1].value + 2 && cards[3].value == cards[2].value + 1 )
			{
				hand.highCard = cards[4];
				return true;
			}
			
			// 3, 4, 5, 7, ?
			if( cards[1].value == cards[0].value + 1 && cards[2].value == cards[1].value + 1 && cards[3].value == cards[2].value + 2 )
			{
				hand.highCard = cards[4];
				return true;
			}
			
			// 1(a), ?, 10, 11, 12
			if( cards[0].value == 1 && cards[2].value == 10 && cards[3].value == 11 && cards[4].value == 12 )
			{
				hand.highCard = cards[1];
				return true;
			}
			
			// 1(a), ?, 10, 11, 13
			if( cards[0].value == 1 && cards[2].value == 10 && cards[3].value == 11 && cards[4].value == 13 )
			{
				hand.highCard = cards[1];
				return true;
			}
			
			// 1(a), ?, 10, 12, 13
			if( cards[0].value == 1 && cards[2].value == 10 && cards[3].value == 12 && cards[4].value == 13 )
			{
				hand.highCard = cards[1];
				return true;
			}
			
			// 1(a), ?, 11, 12, 13
			if( cards[0].value == 1 && cards[2].value == 11 && cards[3].value == 12 && cards[4].value == 13 )
			{
				hand.highCard = cards[1];
				return true;
			}
			
			return false;
		}		
		
		/**
		 * Checks to see if the supplied hand is a HIGH CARD
		 */
		private static function isHighCard( hand:Hand ):Boolean
		{
			var cards:Array = hand.playCards.getOrderedCopy();
			var i:int;
			var highCard:Boolean = false;
			
			// Loop through the cards in our hand
			for( i = 0; i < cards.length; i++ )
			{
				// Determine if we have a face card
				if( cards[i].isFaceCard )
				{
					// Determine if we already have a high card
					if( hand.highCard != null )
					{
						// If our current card is of a higher value than our "high card", replace the high card
						if( ( cards[i].value > hand.highCard.value || cards[i].value == 1 ) && hand.highCard.value != 1 )
						{
							hand.highCard = cards[i];		
						}
					}
					else
					{
						hand.highCard = cards[i];
					}
					
					highCard = true;
				}
			}
			
			return highCard;
		}
	}
}