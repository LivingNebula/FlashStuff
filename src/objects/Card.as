package objects
{
	import assets.Config;
	
	public class Card
	{		
		public static const SUIT_HEARTS:String 	 = "Hearts";
		public static const SUIT_DIAMONDS:String = "Diamonds";
		public static const SUIT_CLUBS:String 	 = "Clubs";
		public static const SUIT_SPADES:String 	 = "Spades";
		
		public static const VALUE_A:int  = 1;
		public static const VALUE_2:int  = 2;
		public static const VALUE_3:int  = 3;
		public static const VALUE_4:int  = 4;
		public static const VALUE_5:int  = 5;
		public static const VALUE_6:int  = 6;
		public static const VALUE_7:int  = 7;
		public static const VALUE_8:int  = 8;
		public static const VALUE_9:int  = 9;
		public static const VALUE_10:int = 10;
		public static const VALUE_J:int  = 11;
		public static const VALUE_Q:int  = 12;
		public static const VALUE_K:int  = 13;
		
		private var _suit:String = "";
		private var _value:int = 0;
		
		public function get suit():String
		{
			return _suit;
		}
		
		public function get value():int
		{
			return _value;
		}
		
		public function get isFaceCard():Boolean
		{
			return _value == 1 || _value > 10;
		}
		
		public function Card( value:int, suit:String )
		{
			_value = value;			
			_suit = suit;
		}
		
		/**
		 * Returns the value of the card based on a specific game type.
		 */			
		public function getFaceValue( gameType:int ):int
		{
			// For BlackJack Aces are worth 11 and any other face cards are worth 10
			if( gameType == Config.GAME_TYPE_VIDEO_BLACKJACK )
			{
				return _value > 10 ? 10 : _value == 1 ? 11 : value;
			}
			else
			{
				return _value;
			}
		}		

		/**
		 *  Returns an string representation of this card which is %SUIT%_%VALUE%.
		 */		
		public function toString():String
		{
			return _suit + "_" + _value.toString();
		}
		
		/**
		 *  Returns an array of available card suits.
		 */
		public static function getSuits():Array
		{
			var suits:Array = [];
			suits.push( Card.SUIT_HEARTS );
			suits.push( Card.SUIT_DIAMONDS );
			suits.push( Card.SUIT_CLUBS );
			suits.push( Card.SUIT_SPADES );
			
			return suits;
		}
		
		/**
		 *  Returns an array of available card values.
		 */
		public static function getValues():Array
		{
			var values:Array = [];
			values.push( Card.VALUE_A );			
			values.push( Card.VALUE_2 );
			values.push( Card.VALUE_3 );
			values.push( Card.VALUE_4 );
			values.push( Card.VALUE_5 );
			values.push( Card.VALUE_6 );
			values.push( Card.VALUE_7 );
			values.push( Card.VALUE_8 );
			values.push( Card.VALUE_9 );
			values.push( Card.VALUE_10 );
			values.push( Card.VALUE_J );
			values.push( Card.VALUE_Q );
			values.push( Card.VALUE_K );
			
			return values;			
		}			
	}
}