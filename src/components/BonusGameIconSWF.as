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
		
	public class BonusGameIconSWF extends BonusGameIcon
	{
		private var mc:MovieClip;
		private var iconVariant:int;
		private var loader:Loader;
		private var exitIcon:Class;
		
		private var animationsStarted:Boolean = false;
		private var eventDispatched:Boolean = false;
		
		private var lastFrame:int = 0;
		
		private var revealFunc:String;
		private var revealDisplay:String;
		private var revealAmount:int;
		
		public function BonusGameIconSWF( iconClass:Class, exitIconClass:Class, variant:int, newFontFamily:String, newFontSize:Number )
		{
			super( newFontFamily, newFontSize );
			buttonMode = true;
			width = 90;
			height = 90;
			clipAndEnableScrolling = false;	
			iconVariant = variant;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loaderComplete );
			loader.loadBytes( new iconClass() );		
			
			var ui:UIComponent = new UIComponent();
			ui.addChild( DisplayObject( loader ) );
			addElement( ui );
			
			exitIcon = exitIconClass;			
		}		
		
		// Handles the 'complete' event on the loader
		private function loaderComplete( event:Event ):void
		{
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, loaderComplete );
			mc = loader.content as MovieClip;	
			mc.gotoAndStop( 1 );
			mc.Icons.gotoAndStop( "Icon" + iconVariant );		
			mc.Icons.addEventListener( MouseEvent.CLICK, onClick );
			
			// Add skin-specific calls
			if( Sweeps.GameID == 21 ) // Cherry Bomb
			{
				mc.Icons.Effect1.gotoAndStop( 1 );
			}
		}	
		
		override public function revealWin( func:String, display:String, amount:int = 0 ):void
		{
			revealFunc = func;
			revealDisplay = display;
			revealAmount = amount;
			
			mc.gotoAndPlay( 2 );
			mc.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			
			// Add skin-specific calls
			if( Sweeps.GameID == 21 ) // Cherry Bomb
			{
				mc.Icons.Effect1.gotoAndPlay( 2 );
			}					
		}
		
		override public function revealPossible( func:String, display:String ):void
		{
			super.revealPossible( func, display );
			
			var fadeOut:Fade = AnimationManager.getFadeAnimation( mc.Icons, 1, 0, 2000, 0, 1, 0, null );
			fadeOut.play();
		}		
		
		private function onEnterFrame( event:Event ):void 
		{			
			if( mc.currentFrame >= 28 && !animationsStarted )
			{
				animationsStarted = true;
				
				// Play the winning amount animation
				super.revealWin( revealFunc, revealDisplay, revealAmount );				
				
				if( isExit )
				{
					var img:Image = new Image();
					img.source = exitIcon;
					img.x = -30;
					img.y = -45;
					addElement( img );
				}
			}
			
			if( ( mc.currentFrame >= 46 || lastFrame > mc.currentFrame ) && !eventDispatched )
			{
				eventDispatched = true;
				
				// Remove our event listener
				mc.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
				
				// Dispatch the onReveal event, notifying listeners we've display our winning amount
				onReveal( this, winAmount );
			}
			
			lastFrame = mc.currentFrame;			
		}
				
	}
}