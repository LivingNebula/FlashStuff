package objects
{
	import utils.ArrayHelper;
	import utils.MathHelper;

	public class Deck
	{
		private var _cards:Array = [];
		
		/**
		 *  Returns the number of cards in the deck.
		 */			
		public function get cardCount():int
		{
			return _cards.length;
		}
		
		/**
		 *  Generates one or more decks of cards.
		 * 
		 * @param numberOfDeck How many sequences of 52 cards you wish to use for this deck.
		 */				
		public function Deck( numberOfDecks:int = 1 )
		{
			// Clear the inner cards array
			_cards = [];
			
			for( var i:int = 0; i < numberOfDecks; i++ )
			{
				// Get a list of suits and card values
				var suits:Array = Card.getSuits();
				var values:Array = Card.getValues();
				
				// Fill the inner cards array with one card of each suit/value combination
				for( var s:int = 0; s < suits.length; s++ )
				{
					for( var v:int = 0; v < values.length; v++ )
					{
						_cards.push( new Card( values[v], suits[s] ) );
					}
				}
			}
		}
		
		/**
		 * Checks to see if a given card exists in the deck based on the given value and suit.
		 * 
		 * @param value The value of the card you want to search for.
		 * @param suit The suit of the card you want to search for.
	     * @return An <code>Boolean</code> indicating whether or not the card exists in deck. 
		 */	
		public function checkCard( value:int, suit:String ):Boolean
		{
			for( var i:int = 0; i < _cards.length; i++ )
			{
				if( _cards[i].value == value && _cards[i].suit == suit )
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Checks to see how many cards exist in the deck of the given suit and/or value.
		 * 
		 * @param value The value of the cards you want to count.
		 * @param suit The suit of the cards you want to count.
	     * @return An <code>int</code> representing the number of cards found in the deck.
		 */
		public function getCardCount( value:int, suit:String ):int
		{
			if( value <= 0 && suit == "" ) 
			{
				return _cards.length;
			}
			else
			{
				return _cards.filter( function( card:Card, index:int, arr:Array ):Boolean {
					return ( card.value == value || value == 0 ) && ( card.suit == suit || suit == "" );
				}).length;			
			}
		}
		
		/**
		 * Checks to see how many cards exist in the deck of the given suit and/or facevalue.
		 * 
		 * @param gameType The game type to be used to determine the card facevalues.
		 * @param faceValue The facevalue of the cards you want to count.
		 * @param suit The suit of the cards you want to count.
		 * @return An <code>int</code> representing the number of cards found in the deck.
		 */
		public function getCardCountByFaceValue( gameType:int, facevalue:int, suit:String ):int
		{
			if( facevalue <= 0 && suit == "" ) 
			{
				return _cards.length;
			}
			else
			{
				return _cards.filter( function( card:Card, index:int, arr:Array ):Boolean {
					return ( card.getFaceValue( gameType ) == facevalue || facevalue == 0 ) && ( card.suit == suit || suit == "" );
				}).length;
			}
		}		
		
		/**
		 * Finds the minum face value of all cards in the deck.
		 * 
		 * @param gameType The game type to be used to determine the card facevalues.
		 * @param limitTo A lower facevalue limit you don't wish to exceed. If you pass in 4, for example,
		 * this method will only return the lowest facevalue in the deck that is 4 or higher.
		 * @return An <code>int</code> representing a facevalue.
		 */		
		public function getMinFaceValue( gameType:int, limitTo:int = 0 ):int
		{
			var minValue:int = -1;
			var curValue:int = -1;
			
			for( var i:int = 0; i < _cards.length; i++ )
			{
				curValue = _cards[i].getFaceValue( gameType );				
				if( ( curValue < minValue || minValue == -1 ) && curValue >= limitTo ) {
					minValue = curValue;
				}
			}
			
			return minValue;
		}
		
		/**
		 * Finds the maximum face value of all cards in the deck.
		 * 
		 * @param gameType The game type to be used to determine the card facevalues.
		 * @param limitTo An upper facevalue limit you don't wish to exceed. If you pass in 10, for example,
		 * this method will only return the highest facevalue in the deck that is 10 or under.
		 * @return An <code>int</code> representing a facevalue.
		 */		
		public function getMaxFaceValue( gameType:int, limitTo:int = 100 ):int
		{
			var maxValue:int = -1;
			var curValue:int = -1;
			
			for( var i:int = 0; i < _cards.length; i++ )
			{
				curValue = _cards[i].getFaceValue( gameType );
				if( ( curValue > maxValue || maxValue == -1 ) && curValue <= limitTo ) {
					maxValue = curValue;
				}
			}
			
			return maxValue;
		}		
		
		/**
		 *  Removes all occurances of cards in the deck based on the given value and/or suit and places them in the discard deck.
		 * 
		 * @param value The value of the card(s) you want to remove.
		 * @param suit The suit of the card(s) you want to remove.
		 * @param discardDeck A <code>Deck</Code> where all the removed cards will be placed.
		 */	
		public function removeCards( value:int, suit:String, discardDeck:Deck ):void
		{
			// Make sure to wrap values that are too high (sometimes passed in by PokerLogic.satisfyHand )
			if( value > Card.VALUE_K )
			{
				value = value - Card.VALUE_K;
			}
			
			for( var i:int = 0; i < _cards.length; i++ )
			{
				if( ( _cards[i].value == value || value == 0 ) && ( _cards[i].suit == suit || suit == "" ) )
				{
					swap( i, _cards.length - 1 );
					discardDeck.addCard( _cards.pop() );
					i--;
				}
			}
		}
		
		/**
		 *  Returns and removes a card in the deck based on the given value and/or suit.
		 * 
		 * @param value The value of the card you want to retrieve.
		 * @param suit The suit of the card you want to retrieve.
		 * @return A <code>Card</code> of the given facevalue and/or suit. 
		 */	
		public function getCard( value:int, suit:String ):Card
		{
			// Make sure to wrap values that are too high (sometimes passed in by PokerLogic.satisfyHand )
			if( value > Card.VALUE_K )
			{
				value = value - Card.VALUE_K;
			}
			
			for( var i:int = 0; i < _cards.length; i++ )
			{
				if( ( _cards[i].value == value || value == 0 ) && ( _cards[i].suit == suit || suit == "" ) )
				{
					swap( i, _cards.length - 1 );
					return _cards.pop();
				}
			}
			
			return null;
		}
		
		/**
		 *  Returns and removes a card in the deck based on the given facevalue and/or suit.
		 * 
		 * @param gameType The game type to use when determining the card values.
		 * @param value The face value of the card you want to retrieve.
		 * @param suit The suit of the card you want to retrieve.
		 * @return A <code>Card</code> of the given facevalue and/or suit.
		 */			
		public function getCardByFaceValue( gameType:int, value:int, suit:String ):Card
		{
			for( var i:int = 0; i < _cards.length; i++ )
			{
				if( ( _cards[i].getFaceValue( gameType ) == value || value == 0 ) && ( _cards[i].suit == suit || suit == "" ) )
				{
					swap( i, _cards.length - 1 );
					return _cards.pop();
				}
			}	
			
			return null;
		}
		
		/**
		 *  Returns and removes the top card in the deck.
		 * 
		 * @return A <code>Card</code>.
		 */	
		public function getTopCard():Card
		{
			return _cards.pop();
		}
		
		/**
		 *  Removes a card that doesn't match the given value and/or suit from the deck and returns it.
		 * 
		 * @param value The value of the card you wish to return.
		 * @param suit The suit of the card you wish to return.
		 * @return A <code>Card</code> matching the given value and/or suit.
		 */	
		public function getDifferentCard( value:int, suit:String ):Card
		{
			for( var i:int = 0; i < _cards.length; i++ )
			{
				if( ( _cards[i].value != value || value == 0 ) && ( _cards[i].suit != suit || suit == "" ) )
				{
					swap( i, _cards.length - 1 );
					return _cards.pop();
				}
			}
			
			return null;
		}
		
		/**
		 *  Removes a random Face Card of the given suit from the deck and returns it.
		 * 
		 * @param suit The suit of card you wish to return.
		 * @return A <code>Card</code> with the given suit.
		 */		
		public function getHighCard( suit:String ):Card
		{
			for( var i:int = 0; i < _cards.length; i++ )
			{
				if( ( _cards[i].value == 1 || _cards[i].value > 10 ) && ( _cards[i].suit == suit || suit == "" ) )
				{
					swap( i, _cards.length - 1 );
					return _cards.pop();
				}
			}
			
			return null;			
		}
		
		/**
		 *  Removes a random Number Card of the given suit from the deck and returns it.
		 * 
		 * @param suit The suit of card you wish to return.
		 * @return A <code>Card</code> with the given suit.
		 */		
		public function getLowCard( suit:String ):Card
		{
			for( var i:int = 0; i < _cards.length; i++ )
			{
				if( _cards[i].value > 1 && _cards[i].value < 11 && ( _cards[i].suit == suit || suit == "" ) )
				{
					swap( i, _cards.length - 1 );
					return _cards.pop();
				}
			}
			
			return null;			
		}		
		
		/**
		 *  Adds a card to the deck, optionally randomizing where the card is placed.
		 * 
		 * @param card The <code>Card</code> to be added to the deck.
		 * @param randomize If <code>true</code> will place the card in a random spot within the deck.
		 */		
		public function addCard( card:Card, randomize:Boolean = false ):void
		{
			_cards.push( card );
			if( randomize )
			{
				swap( MathHelper.randomNumber( 0, _cards.length - 1 ), _cards.length - 1 );
			}
		}
		
		/**
		 * Adds cards back into the deck, optionally shuffling afterwards.
		 * 
		 * @param pile The <code>Pile</code> to add into this deck.
		 * @param shuffle Optionally shuffle the deck afterwards, defaults to <code>true</code>
		 */
		public function addPile( pile:Pile, shuffle:Boolean = true ):void
		{
			for( var i:int = 0; i < pile.cardCount; i++ )
			{
				_cards.push( pile.drawCard() );
			}
			
			if( shuffle )
			{
				this.shuffle();
			}
		}
		
		/**
		 *  Removes the possibility of a straight by removing key cards in the deck and returns the method used.
		 * 
		 * @param rnd - A random number between 0 and 4 which varies which cards a removed.
		 * @param discardDeck A <code>Deck</code> where the removed cards will be placed so they can be accessed later.
		 * @return An integer representing the method used to remove the straight.
		 */		
		public function removeStraight( rnd:int, discardDeck:Deck ):int
		{
			var values:Array = [];
			
			switch( rnd )
			{
				case 0:
					values.push( Card.VALUE_A );
					values.push( Card.VALUE_6 );
					values.push( Card.VALUE_J );
					break;
				
				case 1:
					values.push( Card.VALUE_2 );
					values.push( Card.VALUE_7 );
					values.push( Card.VALUE_Q );					
					break;
				
				case 2:
					values.push( Card.VALUE_3 );
					values.push( Card.VALUE_8 );
					values.push( Card.VALUE_K );					
					break;
				
				case 3:
					values.push( Card.VALUE_4 );
					values.push( Card.VALUE_9 );
					values.push( Card.VALUE_A );					
					break;
				
				case 4:
					values.push( Card.VALUE_5 );
					values.push( Card.VALUE_10 );					
					break;
			}
			
			for( var i:int = 0; i < values.length; i++ )
			{
				removeCards( values[i], "", discardDeck );
			}
			
			return rnd;
		}		
		
		/**
		 *  Shuffles the cards in the deck.
		 */		
		public function shuffle():void
		{
			ArrayHelper.randomize( _cards );
		}
		
		/**
		 *  Swaps two cards in the deck.
		 * 
		 * @param a The first position to swap.
		 * @param b The second position to swap.
		 */		
		public function swap( a:int, b:int ):void
		{
			ArrayHelper.swap( _cards, a, b );
		}
		
		/**
		 * Returns a string representation of every card in the deck.
		 */
		public function toString():String
		{
			var str:String = "";
			
			for( var i:int = 0; i < _cards.length; i++ )
			{
				str += _cards[i].toString() + "\n";
			}
			
			return str;
		}
	}
}