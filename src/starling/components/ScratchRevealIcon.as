package starling.components
{
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;

	import mx.formatters.NumberBase;

	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.text.TextField;
	import starling.textures.Texture;

	import utils.DebugHelper;

	public class ScratchRevealIcon extends Sprite
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( ScratchRevealIcon );

		// Statics
		private static var dsFilter:DropShadowFilter = new DropShadowFilter( 1, 45, 0x000000 );

		// UI Components
		private var _txtAmount:TextField;
		private var _icon:Button;
		private var _revealClip:MovieClip;

		// Gamestate variables
		private var _revealAmount:int;
		private var _onRevealCallback:Function;
		private var _isRevealed:Boolean;

		public function get fontName():String
		{
			return _txtAmount.fontName;
		}

		public function set fontName( value:String ):void
		{
			_txtAmount.fontName = value;
		}

		public function get fontSize():Number
		{
			return _txtAmount.fontSize;
		}

		public function set fontSize( value:Number ):void
		{
			_txtAmount.fontSize = value;
		}

		public function get color():uint
		{
			return _txtAmount.color;
		}

		public function set color( value:uint ):void
		{
			_txtAmount.color = value;
		}

		public function get enabled():Boolean
		{
			return _icon.enabled;
		}

		public function set enabled( value:Boolean ):void
		{
			_icon.enabled = value;
		}

		public function get isRevealed():Boolean
		{
			return _isRevealed;
		}

		public function ScratchRevealIcon( icon:Texture, revealClip:MovieClip )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );

			super();

			_txtAmount = new TextField( icon.width, icon.height, "" );
			_txtAmount.nativeFilters = [dsFilter];
			_txtAmount.visible = false;
			addChild( _txtAmount );

			_icon = new Button( icon, "", icon );
			_icon.alphaWhenDisabled = 1;
			addChild( _icon );

			_revealClip = revealClip;
			_revealClip.visible = false;
			_revealClip.x = ( _icon.width - revealClip.width ) >> 1;
			_revealClip.y = ( _icon.height - revealClip.height ) >> 1;
			addChild( _revealClip );

			// Clear Context
			logger.popContext();
		}

		public function reveal( revealAmount:int, onRevealCallback:Function ):void
		{
			// Log Activity
			logger.pushContext( "reveal", arguments );

			_isRevealed = true;
			_revealAmount = revealAmount;
			_onRevealCallback = onRevealCallback;

			_txtAmount.visible = true;
			_txtAmount.text = "x" + revealAmount;
			_icon.visible = false;

			_revealClip.visible = true;
			_revealClip.play();
			_revealClip.addEventListener( Event.COMPLETE, onRevealComplete );
			Starling.juggler.add( _revealClip );

			// Clear Context
			logger.popContext();
		}

		protected function onRevealComplete( event:Event ):void
		{
			// Log Activity
			logger.pushContext( "onRevealComplete", arguments );

			Starling.juggler.remove( _revealClip );
			_revealClip.removeEventListener( Event.COMPLETE, onRevealComplete );
			_revealClip.stop();
			_revealClip.visible = false;

			if( _onRevealCallback  !== null )
			{
				_onRevealCallback( this, _revealAmount );
			}

			// Clear Context
			logger.popContext();
		}

		override public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );

			_onRevealCallback = null;

			if( _revealClip.isPlaying )
			{
				Starling.juggler.remove( _revealClip );
				_revealClip.removeEventListener( Event.COMPLETE, onRevealComplete );
				_revealClip.stop();
			}

			super.dispose();

			// Clear Context
			logger.popContext();
		}
	}
}