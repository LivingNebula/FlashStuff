package components.QuadVideoSlots
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
	
	import utils.DebugHelper;
	
	public class WinningIconGraphic extends Group implements IDisposable
	{		
		// Logging
		private static const logger:DebugHelper = new DebugHelper( WinningIconGraphic );
		
		private var bgSprite:Sprite;
		
		private var iconAnimation:SpriteUIComponent;
		private var iaDelay:Number = 100;
		private var iaRepeatCount:int = 0;
		private var iaRepeatDelay:Number = 2000;
		private var iaReverse:Boolean = true;
		
		private var brdAnimation:SpriteUIComponent;
		private var shd:DropShadowFilter;
		private var sprkAnimation:SpriteUIComponent;
				
		public function WinningIconGraphic( winIcon:String, isVertical:Boolean = false, isWin:Boolean = true, doReverse:Boolean = true )
		{
			// Log Activity
			logger.pushContext( "WinningIconGraphic", arguments );
			
			super();
			width = 61;
			height = 57;
			clipAndEnableScrolling = false;
			
			// Create the background white sprite to block out the icons underneath
			if( !isVertical )
			{
				bgSprite = new Sprite();
				bgSprite.graphics.beginFill( 0xFFFFFF, 1.0 );
				bgSprite.graphics.drawRect( 0, 0, 61, 57 );
				bgSprite.graphics.endFill();	
				addElement( new SpriteUIComponent( bgSprite ) );
			}
			
			// Check if the vertical animation is displayed
			if( isVertical )
			{
				// Check if to display the win indicator
				if( isWin )
				{					
					// Create the red border animation and throw on a drop shadow
					shd = new DropShadowFilter( 4, 45, 0x000000, 0.75, 4.0, 4.0, 1.0 );			
					brdAnimation = AnimationManager.getAnimatedImage( styleManager, Sweeps.GameID, "Sprite_E", 40, 0, 0, doReverse );
					brdAnimation.x = ( 61 - 65 ) / 2;
					brdAnimation.y = ( 57 - 60 ) / 2;
					brdAnimation.filters = [shd];
				}
				else
				{
					// Customize the actual icon animation
					iaDelay = 50;
					iaRepeatCount = 1;
					iaRepeatDelay = 0;
					iaReverse = false;
				}
			}
			else
			{				
				// Create the red border animation and throw on a drop shadow
				shd = new DropShadowFilter( 4, 45, 0x000000, 0.75, 4.0, 4.0, 1.0 );			
				brdAnimation = AnimationManager.getAnimatedImage( styleManager, Sweeps.GameID, "Sprite_C", 40, 0, 0, true );	
				brdAnimation.x = ( 61 - 65 ) / 2;
				brdAnimation.y = ( 57 - 60 ) / 2;
				brdAnimation.filters = [shd];		
				
				// Create the sparkle animation
				sprkAnimation = AnimationManager.getAnimatedImage( styleManager, Sweeps.GameID, "Sprite_D", 50, 0, 2000, false );
				sprkAnimation.x = ( 61 - 80 ) / 2;
				sprkAnimation.y = ( 57 - 75 ) / 2;
			}
						
			// Create the actual icon animation
			iconAnimation = AnimationManager.getAnimatedImage( styleManager, Sweeps.GameID, winIcon, iaDelay, iaRepeatCount, iaRepeatDelay, iaReverse );
			iconAnimation.scaleX = iconAnimation.scaleY = 0.5;
			addElement( iconAnimation );
			
			// Add the supplemental animations
			if( brdAnimation != null ) { addElement( brdAnimation ); }
			if( sprkAnimation != null ) { addElement( sprkAnimation ); }
			
			// Stop the animations from playing by default
			stopAnimations();
			
			// Clear Context
			logger.popContext();			
		}
		
		// Restarts the icon's animations
		public function restartAnimations( callback:Function = null, delayCallback:Boolean = false ):void
		{			
			// Log Activity
			logger.pushContext( "restartAnimations", arguments );
			
			if( iconAnimation != null ) { ( iconAnimation.getChildAt( 0 ) as AnimatedImage ).restart_loop( callback, delayCallback ); }
			if( brdAnimation != null ) { ( brdAnimation.getChildAt( 0 ) as AnimatedImage ).restart_loop(); }
			if( sprkAnimation != null ) { ( sprkAnimation.getChildAt( 0 ) as AnimatedImage ).restart_loop(); }
			
			// Clear Context
			logger.popContext();			
		}			
		
		// Stops the icon from animating
		public function stopAnimations():void
		{
			// Log Activity
			logger.pushContext( "stopAnimations", arguments );
			
			if( iconAnimation != null ) { ( iconAnimation.getChildAt( 0 ) as AnimatedImage ).stop_loop(); }
			if( brdAnimation != null ) { ( brdAnimation.getChildAt( 0 ) as AnimatedImage ).stop_loop(); }
			if( sprkAnimation != null ) { ( sprkAnimation.getChildAt( 0 ) as AnimatedImage ).stop_loop(); }
			
			// Clear Context
			logger.popContext();			
		}
		
		public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );
			
			if( iconAnimation != null ) { iconAnimation.dispose(); }
			if( brdAnimation != null ) { brdAnimation.dispose(); }
			if( sprkAnimation != null ) { sprkAnimation.dispose(); }
			
			// Clear Context
			logger.popContext();			
		}
	}
}