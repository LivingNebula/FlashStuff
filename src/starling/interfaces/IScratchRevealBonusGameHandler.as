package starling.interfaces
{
	import starling.components.ScratchRevealIcon;

	public interface IScratchRevealBonusGameHandler
	{
		function onBonusIconClicked( icon:ScratchRevealIcon ):void;
		
		function onBonusIconRevealed( icon:ScratchRevealIcon ):void;
		
		function onBonusWinningsDisplay():void;
		
		function onBonusPossibleRevealed():void;
	}
}