package components.SuperVideoSlots
{
	import assets.AnimationManager;
	import assets.SkinManager;
	
	import components.AnimatedImage;
	import components.SpriteUIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import interfaces.IDisposable;
	
	import mx.events.EffectEvent;
	
	import spark.components.Group;
	import spark.effects.AnimateFilter;
	import spark.effects.Fade;
	import spark.filters.DropShadowFilter;
	import spark.filters.GlowFilter;
	
	public class WinningIconGraphic extends Group implements IDisposable
	{		
		private var bgSprite:Sprite;
		
		private var iconAnimation:SpriteUIComponent;
		private var iaDelay:Number = 100;
		private var iaRepeatCount:int = 0;
		private var iaRepeatDelay:Number = 2000;
		private var iaReverse:Boolean = true;
				
		public function WinningIconGraphic( winIcon:String, width:int, height:int, isVertical:Boolean = false, isWin:Boolean = true )
		{
			super();
			this.width = width;
			this.height = height;
			clipAndEnableScrolling = false;
			
			// Create the background white sprite to block out the icons underneath
			bgSprite = new Sprite();
			bgSprite.graphics.beginFill( 0xFFFFFF, 1.0 );
			bgSprite.graphics.drawRect( 3, 3, width - 6, height - 6 );
			bgSprite.graphics.endFill();	
			addElement( new SpriteUIComponent( bgSprite ) );					
			
			// Check if the vertical animation is displayed
			if( isVertical )
			{
				if( !isWin )
				{
					// Customize the icon animation
					iaDelay = 20;
					iaRepeatCount = 1;
					iaRepeatDelay = 0;
					iaReverse = false;
				}
			}
						
			// Create the actual icon animation
			iconAnimation = AnimationManager.getAnimatedImage( styleManager, Sweeps.GameID, winIcon, iaDelay, iaRepeatCount, iaRepeatDelay, iaReverse );
			addElement( iconAnimation );					
			
			// Stop the animations from playing by default
			stopAnimations();
		}
		
		// Restarts the icon's animations
		public function restartAnimations( callback:Function = null, delayCallback:Boolean = false ):void
		{			
			if( iconAnimation != null ) { ( iconAnimation.getChildAt( 0 ) as AnimatedImage ).restart_loop( callback, delayCallback ); }
		}
		
		// Stops the icon from animating
		public function stopAnimations():void
		{
			if( iconAnimation != null ) { ( iconAnimation.getChildAt( 0 ) as AnimatedImage ).stop_loop(); }			
		}
		
		public function dispose():void
		{
			if( iconAnimation != null ) { iconAnimation.dispose(); }			
		}
	}
}