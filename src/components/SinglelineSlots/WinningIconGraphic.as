package components.SinglelineSlots
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
		private var shd:DropShadowFilter;
		
		public function WinningIconGraphic( winIcon:String )
		{
			super();
			width = 122;
			height = 114;
			clipAndEnableScrolling = false;
			
			// Create the background white sprite to block out the icons underneath
			bgSprite = new Sprite();
			bgSprite.graphics.beginFill( 0xFFFFFF, 1.0 );
			bgSprite.graphics.drawRect( 3, 3, 116, 108 );
			bgSprite.graphics.endFill();	
			
			// Create the actual icon animation
			iconAnimation = AnimationManager.getAnimatedImage( styleManager, Sweeps.GameID, winIcon, 100, 0, 2000, true );
			
			// Add both elements
			addElement( new SpriteUIComponent( bgSprite ) );			
			addElement( iconAnimation );	
			
			// Stop the animations from playing by default
			stopAnimations();
		}
		
		// Restarts the icon's animations
		public function retartAnimations():void
		{
			( iconAnimation.getChildAt( 0 ) as AnimatedImage ).restart_loop();		
		}
		
		// Stops the icon from animating
		public function stopAnimations():void
		{
			( iconAnimation.getChildAt( 0 ) as AnimatedImage ).stop_loop();
		}
		
		public function dispose():void
		{
			iconAnimation.dispose();			
		}
	}
}