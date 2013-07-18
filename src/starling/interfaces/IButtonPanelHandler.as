package starling.interfaces
{
	public interface IButtonPanelHandler
	{
		/** Called when auto play is started. */
		function onAutoPlay():void;
		
		/** Called when auto play is stopped. */
		function onStop():void;
		
		/** Called when the info button is clicked. */
		function onInfo():void;
		
		/** 
		 * Called when the nudge button is clicked. 
		 * @param direction the direction to nudge.
		 */
		function onNudge( direction:String = "" ):void;
		
		/** Called when bet one is clicked. */
		function onBetOne():void;
		
		/** Called when bet max is clicked. */
		function onBetMax():void;
		
		/** Called when bet sub is clicked. */
		function onBetSub():void;
		
		/** Called when bet add is clicked. */
		function onBetAdd():void;
		
		/** Called when line add is clicked. */
		function onLineAdd():void;
		
		/** Called when spin is clicked. */
		function onSpin():void;
		
		/** Called when spin stop is clicked. */
		function onSpinStop():void;
		
		/** Called when deal is clicked. */
		function onDeal():void;
		
		/** Called when draw is clicked. */
		function onDraw():void;		
		
		/** Called when quicpick up is clicked. */
		function onQuickPickUp():void;
		
		/** Called when quicpick down is clicked. */
		function onQuickPickDown():void;		
		
		/** Called when quickpick is clicked. */
		function onQuickPick():void;
	}
}