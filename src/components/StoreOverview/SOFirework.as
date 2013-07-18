package components.StoreOverview
{
	import assets.AnimationManager;
	import assets.Images;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;

	import interfaces.IDisposable;

	import mx.core.UIComponent;
	import mx.events.EffectEvent;

	import spark.components.Group;
	import spark.effects.Move;

	import utils.MathHelper;

	public class SOFirework extends Group implements IDisposable
	{
		private var mc:MovieClip;
		private var loader:Loader;
		private var mv:Move;

		public function SOFirework()
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loaderComplete );
			loader.loadBytes( new assets.Images.ProgressiveFirework );

			var ui:UIComponent = new UIComponent();
			ui.addChild( DisplayObject( loader ) );
			addElement( ui );
		}

		// Handles the 'complete' event on the loader
		private function loaderComplete( event:Event ):void
		{
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, loaderComplete );
			mc = loader.content as MovieClip;
			endFirework();
		}

		public function launch( xFrom:Number, yFrom:Number, xTo:Number, yTo:Number ):void
		{
			if( mc == null )
			{
				return;
			}

			var angle:Number = Math.atan2( yFrom - yTo, xFrom - xTo ) * 180 / Math.PI;
			var dx:Number = xFrom - xTo;
			var dy:Number = yFrom - yTo;
			var dist:Number = Math.abs( Math.round( Math.sqrt( dx*dx + dy*dy ) ) );

			this.x = xFrom;
			this.y = yFrom;
			this.visible = true;
			this.rotationZ = angle - 90;

			mc.visible = true;
			mc.gotoAndStop( 1 );

			mc.mcSparkle.visible = true;
			mc.mcSparkle.gotoAndPlay( 1 );

			mc.mcFirework.visible = false;
			mc.mcFirework.gotoAndStop( 1 );

			mv = assets.AnimationManager.getMoveAnimation( this, xFrom, yFrom, xTo, yTo, dist * ( MathHelper.randomNumber( 50, 150 ) / 100 ), 0, 1, 0 );
			mv.addEventListener( EffectEvent.EFFECT_END, move_EffectEnd );
			mv.play();
		}

		private function move_EffectEnd( event:EffectEvent ):void
		{
			mv.removeEventListener( EffectEvent.EFFECT_END, move_EffectEnd );
			mv = null;

			mc.visible = true;
			mc.gotoAndPlay( 1 );

			mc.mcSparkle.visible = false;
			mc.mcFirework.gotoAndStop( 1 );

			mc.mcFirework.visible = true;
			mc.mcFirework.gotoAndPlay( 1 );

			setTimeout( endFirework, 2000 );
		}

		private function endFirework():void
		{
			mc.visible = false;
			mc.gotoAndStop( 1 );

			mc.mcSparkle.visible = false;
			mc.mcSparkle.gotoAndStop( 1 );

			mc.mcFirework.visible = false;
			mc.mcFirework.gotoAndStop( 1 );
		}

		public function dispose():void
		{

		}
	}
}