package components.VideoSlots
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
		
		private var iaDelay:Number = 100;
		private var iaRepeatCount:int = 0;
		private var iaRepeatDelay:Number = 2000;
		private var iaReverse:Boolean = true;
		private var isHighQuality:Boolean = false;
		
		private var iconAnimation:SpriteUIComponent;
		private var hqAnimation:WinningIconAnimation;
		private var brdAnimation:SpriteUIComponent;
		private var sprkAnimation:SpriteUIComponent;
		private var shd:DropShadowFilter;		
				
		public function WinningIconGraphic(  winIcon:String, isVertical:Boolean = false, isWin:Boolean = true, doReverse:Boolean = true, doHQ:Boolean = false )
		{
			// Log Activity
			logger.pushContext( "WinningIconGraphic", arguments );
			
			super();
			width = 122;
			height = 114;
			clipAndEnableScrolling = false;
			isHighQuality = doHQ;
			
			// Create the background white sprite to block out the icons underneath
			if( !isVertical )
			{
				bgSprite = new Sprite();
				bgSprite.graphics.beginFill( 0xFFFFFF, 1.0 );
				bgSprite.graphics.drawRect( 3, 3, 116, 108 );
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
					brdAnimation.x = -8;
					brdAnimation.y = -8;
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
				brdAnimation.x = -4;
				brdAnimation.y = -3;
				brdAnimation.filters = [shd];		
				
				// Create the sparkle animation
				sprkAnimation = AnimationManager.getAnimatedImage( styleManager, Sweeps.GameID, "Sprite_D", 50, 0, 2000, false );
				sprkAnimation.x = -19;
				sprkAnimation.y = -13;	
			}
						
			// Create the actual icon animation
			if( !isHighQuality )
			{
				iconAnimation = AnimationManager.getAnimatedImage( styleManager, Sweeps.GameID, winIcon, iaDelay, iaRepeatCount, iaRepeatDelay, iaReverse );
				addElement( iconAnimation );
			}
			else
			{
				hqAnimation = new WinningIconAnimation( winIcon + "_Animation", null, width, height );
				addElement( hqAnimation );
			}
			
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
			if( hqAnimation != null ){ hqAnimation.play( 0 ); };
			
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
			if( hqAnimation != null ){ hqAnimation.stop(); };
			
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
			if( hqAnimation != null ){ hqAnimation.dispose(); };
			
			// Clear Context
			logger.popContext();			
		}
	}
}