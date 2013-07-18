package objects
{
	import assets.Config;
	
	import utils.ArrayHelper;

	public class Pile
	{
		private var _cards:Array = [];
		
		public function get cardCount():int
		{
			return _cards.length;
		}
		
		/**
		 * Creates a new pile.
		 */
		public function Pile()
		{
			
		}	
		
		/**
		 * Adds a card to the top of the pile.
		 * 
		 * @param card The <code>Card</code> to add.
		 */				
		public function addCard( card:Card ):void
		{
			_cards.push( card );
		}
		
		/**
		 * Adds a card to the pile at a given index, optionally replacing the existing card at that index.
		 * 		 
		 * @param card The <code>Card</code> to add.
		 * @param index Where in the pile to place the card.
		 * @param replace If <code>true</code>, will replace the card at the given index.
		 */		
		public function addCardAt( card:Card, index:int, replace:Boolean = true ):void
		{
			_cards.splice( index, replace ? 1 : 0, card );
		}
		
		/**
		 * Removes and returns a card from the top of the pile.
		 * 
		 * @return The top <code>Card</code> from the pile.
		 */		
		public function drawCard():Card
		{
			return _cards.pop();
		}
		
		/**
		 * Returns a reference to the card at the given index in the pile, but does not remove that card from the pile.
		 * 
		 * @return A <code>Card</code> reference for the card at the given <code>index</code>.
		 */		
		public function getCard( index:int ):Card
		{
			return _cards[index];
		}
		
		/**
		 * Returns the total face value of all cards in the pile.
		 * 
		 * @param gameType The game type to use when determining the face value of the cards.
		 * @return An <code>int</code>, which is the sum of face values for all cards in the pile.
		 */
		public function getFaceValue( gameType:int ):int
		{
			var val:int = 0;
			var aceCount:int = 0;
			var reducedAceCount:int = 0;
			
			_cards.forEach( function( card:Card, index:int, arr:Array ):void {
				aceCount += card.value == 1 ? 1 : 0;
				val += card.getFaceValue( gameType );
			});
			
			// If we're getting values for Blackjack and the face value is over 21, see if any of our aces can be counted as 1
			if( gameType == Config.GAME_TYPE_VIDEO_BLACKJACK && val > 21 )
			{
				
				while( val > 21 && reducedAceCount < aceCount )
				{
					val -= 10;
					reducedAceCount++;
				}
			}
			
			return val;
		}
		
		/**
		 * Returns an array of references to cards in this pile, ordered by value.
		 * Does not modify the cards in the current pile.
		 * 
		 * @return An <code>Array</code> of <code>Card</code>.
		 */		
		public function getOrderedCopy():Array
		{
			var arr:Array = ArrayHelper.copy( _cards );
			arr.sort( function sortCards( a:Card, b: Card ):int {
				if( a.value < b.value )
				{
					return -1;
				}
				else if( a.value > b.value )
				{
					return 1;
				}
				else
				{
					return 0;
				}
			});
			
			return arr;
		}
		
		/**
		 *  Moves cards from this pile to the supplied pile. By default, all cards are moved, however a count can be supplied.
		 * 
		 * @param pile The <code>Pile</code> to the move this pile's card to.
		 * @param count How many cards to move, starting at the top of the pile and working down.
		 */		
		public function popCardsToPile( pile:Pile, count:int = -1 ):void
		{
			count = count == -1 ? _cards.length : count;
			for( var i:int = 0; i < count; i++ )
			{
				pile.addCard( _cards.pop() );
			}
		}
		
		/**
		 * Reverses the order of cards in the pile.
		 */
		public function reverse():void
		{
			_cards.reverse();
		}
		
		/**
		 *  Shuffles the cards in the pile.
		 */		
		public function shuffle():void
		{
			ArrayHelper.randomize( _cards );
		}
		
		/**
		 *  Sorts the cards in the pile by value.
		 */		
		public function sort():void
		{
			_cards.sort( function sortCards( a:Card, b: Card ):int {
				if( a.value < b.value )
				{
					return -1;
				}
				else if( a.value > b.value )
				{
					return 1;
				}
				else
				{
					return 0;
				}
			});
		}
		
		/**
		 *  Swaps two cards in the pile.
		 * 
		 * @param a The first position to swap.
		 * @param b The second position to swap.
		 */		
		public function swap( a:int, b:int ):void
		{
			ArrayHelper.swap( _cards, a, b );
		}
		
		/**
		 * Returns a string representation of all the cards in the pile.
		 * 
		 * @return A <code>String</code>, concatenating each card's string represenation.
		 */
		public function toString():String
		{
			return _cards.toString();
		}
	}
}