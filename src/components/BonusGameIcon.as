package components
{
	import assets.AnimationManager;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import interfaces.IDisposable;
	
	import mx.controls.Image;
	import mx.controls.SWFLoader;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	import spark.effects.Fade;
	import spark.effects.Move;
	import spark.effects.easing.Bounce;
	
	public class BonusGameIcon extends Group implements IDisposable
	{
		protected var lblWinAmount:GradientLabel;
		protected var aniWinAmountMV:Move;
		protected var aniWinAmountFD:Fade;
		protected var easBounce:Bounce;
		protected var fontFamily:String;
		protected var fontSize:Number;
		protected var winAmount:int;
		
		protected var colors:Array = [];
		protected var isExit:Boolean = false;
		
		private var onSelectedCallback:Function;
		private var onRevealCallback:Function;
		
		public function set onSelected( value:Function ):void
		{
			onSelectedCallback = value;
		}
		
		public function get onSelected():Function
		{
			return onSelectedCallback;
		}
		
		public function set onReveal( value:Function ):void
		{
			onRevealCallback = value;
		}
		
		public function get onReveal():Function
		{
			return onRevealCallback;
		}		
		
		public function BonusGameIcon( newFontFamily:String, newFontSize:Number )
		{
			super();	
			fontFamily = newFontFamily;
			fontSize = newFontSize;
		}
		
		// Handles the 'click' event on the 'Icons' MovieClip
		protected function onClick( event:MouseEvent ):void
		{
			if( onSelectedCallback != null )
			{
				onSelectedCallback( this );
			}
		}
		
		// Starts the reveal animation and sets the winning amount to be displayed
		public function revealWin( func:String, display:String, amount:int = 0 ):void
		{		
			if( func == "+" )
			{
				colors = [0xFF003C, 0xBB0010];
			}
			else if( func == "*" )
			{
				colors = [0xFFFF4B, 0xFFBD00];
			}
			else if( func == "/" )
			{
				colors = [0x8CF2FE, 0x00D5A9];
			}
			else
			{
				isExit = true;
				display = "";
			}
			
			winAmount = amount;
					
			if( !isExit )
			{
				lblWinAmount = new GradientLabel(
					"",
					150,
					200,
					display,
					fontFamily,
					fontSize,
					"center",
					colors
				);
				lblWinAmount.horizontalCenter = 0;
				lblWinAmount.y = 0;		
				lblWinAmount.alpha = 0;
				addElement( lblWinAmount );			
				
				easBounce = new Bounce();
				aniWinAmountMV = AnimationManager.getMoveAnimation( lblWinAmount, 0, -20, 0, 10, 500, 0, 1, 0, easBounce );			
				aniWinAmountFD = AnimationManager.getFadeAnimation( lblWinAmount, 0, 1, 500, 0, 1, 0, null );
				
				aniWinAmountMV.play();
				aniWinAmountFD.play();
			}	
		}
		
		// Fades out the icon and displays what the user might've won had they clicked on this icon
		public function revealPossible( func:String, display:String ):void
		{
			if( func == "+" )
			{
				colors = [0xFF003C, 0xBB0010];
			}
			else if( func == "*" )
			{
				colors = [0xFFFF4B, 0xFFBD00];
			}
			else if( func == "/" )
			{
				colors = [0x8CF2FE, 0x00D5A9];
			}
			
			lblWinAmount = new GradientLabel(
				"",
				150,
				200,
				display,
				fontFamily,
				fontSize,
				"center",
				colors
			);
			lblWinAmount.horizontalCenter = 0;
			lblWinAmount.y = 20;		
			lblWinAmount.alpha = 0;
			addElement( lblWinAmount );	
			
			var fadeIn:Fade = AnimationManager.getFadeAnimation( lblWinAmount, 0, 1, 2000, 0, 1, 0, null );
			fadeIn.play();
		}
		
		public function dispose():void
		{
			
		}
	}
}