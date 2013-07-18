package components
{
	import assets.AnimationManager;
	
	import mx.controls.Image;
	import mx.effects.Parallel;
	import mx.effects.Sequence;
	import mx.events.EffectEvent;
	
	import spark.effects.Animate;
	import spark.effects.Fade;
	import spark.effects.Move;
	import spark.effects.Scale;
	import spark.effects.animation.RepeatBehavior;
	import spark.filters.GlowFilter;
	
	import utils.DebugHelper;

	public class BonusGameIconIMG extends BonusGameIcon
	{		
		
		// Logging
		private static const logger:DebugHelper = new DebugHelper( BonusGameIconIMG );	
		
		private var revealFunc:String;
		private var revealDisplay:String;
		private var revealAmount:int;
		
		private var imgIcon:Image;
		private var aniScale:Scale;
		private var aniMove:Move;
		private var aniFadeIn:Fade;
		private var aniFadeOut:Fade;
		private var aniSeq:Sequence;
		private var glowFilter:GlowFilter;
		
		public function BonusGameIconIMG( imageClass:Class, newFontFamily:String, newFontSize:Number )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );
			
			super( newFontFamily, newFontSize );
			buttonMode = false;
			clipAndEnableScrolling = false;	
			width = 100;
			height = 100;
			
			glowFilter = new GlowFilter( 0xF7F030, 1 );
			
			imgIcon = new Image();
			imgIcon.filters = [ glowFilter ];
			imgIcon.width = 100;
			imgIcon.height = 100;
			imgIcon.alpha = 1;
			imgIcon.horizontalCenter = 0;
			imgIcon.source = imageClass;			
			addElement( imgIcon );
			
			// Clear Context
			logger.popContext();			
		}
		
		override public function revealWin( func:String, display:String, amount:int = 0 ):void
		{
			// Log Activity
			logger.pushContext( "revealWin", arguments );
			
			revealFunc = func;
			revealDisplay = display;
			revealAmount = amount;
			
			aniScale = assets.AnimationManager.getScaleAnimation( imgIcon, 1, 1, -1, 1, 250, 0, 16, 0 );
			aniScale.repeatBehavior = RepeatBehavior.REVERSE;
			aniMove = assets.AnimationManager.getMoveAnimation( imgIcon, 0, 0, 0, -50, 2000, 0, 1, 0 );
			aniFadeIn = assets.AnimationManager.getFadeAnimation( imgIcon, 0, 1, 2000, 0, 1, 0  );
			aniFadeOut = assets.AnimationManager.getFadeAnimation( imgIcon, 1, 0, 2000, 2000, 1, 0  );
			
			aniSeq = new Sequence();
			aniSeq.children = [aniFadeIn, aniFadeOut];
			
			aniScale.addEventListener( EffectEvent.EFFECT_END, aniPar_ended );
			aniFadeOut.addEventListener( EffectEvent.EFFECT_END, aniPar_ended );
			aniScale.play();
			aniMove.play();
			aniSeq.play();
			
			// Clear Context
			logger.popContext();			
		}
		
		private function aniPar_ended( event:EffectEvent ):void
		{
			// Log Activity
			logger.pushContext( "aniPar_ended", arguments );
						
			if( event.target is Scale )
			{
				aniScale.removeEventListener( EffectEvent.EFFECT_END, aniPar_ended );
				super.revealWin( revealFunc, revealDisplay, revealAmount );
			}
			else if( event.target is Fade )
			{
				aniFadeOut.removeEventListener( EffectEvent.EFFECT_END, aniPar_ended );
				aniScale = null;
				aniMove = null;
				aniFadeIn = null;
				aniFadeOut = null;
								
				onReveal( this, winAmount );				
			}
			
			// Clear Context
			logger.popContext();			
		}
	}
}