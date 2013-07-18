package objects
{
	public class Hand
	{
		public var cardsOrdered:Pile = new Pile();
		
		public var playCards:Pile = new Pile();
		public var drawCards:Pile = new Pile();
		public var tempCards:Pile = new Pile();
		
		public var antiScaleUsed:int = 0;
		public var highCard:Card;
		public var highCard2:Card;		
		
		public function Hand()
		{
		
		}
		
		public function toString():String
		{
			var str:String = "";
			str += "\tPlay Cards: " + playCards.toString();
			str += "\n";
			str += "\tDraw Cards: " + drawCards.toString();
			str += "\n";	
			str += "\tTemp Cards: " + tempCards.toString();
			str += "\n";		
			str += "\tAntiScale Used: " + antiScaleUsed.toString();
			str += "\n";
			if( highCard !=  null )
			{
				str += "\tHigh Card 2: " + highCard.toString();
				str += "\n";
			}
			if( highCard2 != null )
			{
				str += "\tHigh Card 2: " + highCard2.toString();
				str += "\n";
			}
			
			return str;
		}
	}
}