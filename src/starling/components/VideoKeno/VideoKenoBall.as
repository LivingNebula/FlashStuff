package starling.components.VideoKeno
{
	import flash.filters.DropShadowFilter;

	import interfaces.IDisposable;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class VideoKenoBall extends Sprite implements IDisposable
	{
		// UI Components
		private var _rotContainer:Sprite;
		private var _image:Image;
		private var _highlightImage:Image;
		private var _txtNumber:TextField;

		// Gamestate Variables
		private var _value:int;
		private var _isBonusBall:Boolean = false;

		public function VideoKenoBall( texture:Texture, value:int, fontSize:int = 11, highlightTexture:Texture = null )
		{
			super();
			_value = value;

			_rotContainer = new Sprite();
			addChild( _rotContainer );

			_image = new Image( texture );
			_rotContainer.addChild( _image );

			_txtNumber = new TextField( _image.width, _image.height, value.toString(), "Verdana", fontSize, 0x000000 );
			_txtNumber.nativeFilters = [new DropShadowFilter( 1, 25, 0x000000 )];
			_rotContainer.addChild( _txtNumber );

			if( highlightTexture != null )
			{
				_highlightImage = new Image( highlightTexture );
				_highlightImage.alpha = 0.5;
				addChild( _highlightImage );
			}

			width = _image.width;
			height = _image.height;
			pivotX = _image.width >> 1;
			pivotY = _image.height >> 1;

			_rotContainer.pivotX = _rotContainer.width >> 1;
			_rotContainer.pivotY = _rotContainer.height >> 1;
			_rotContainer.x = _image.width >> 1;
			_rotContainer.y = _image.height >> 1;
		}

		override public function set rotation( value:Number ):void
		{
			_rotContainer.rotation = value;
		}

		public function get isBonusBall():Boolean
		{
			return _isBonusBall;
		}

		public function set isBonusBall( value:Boolean ) :void
		{
			_isBonusBall = value;
		}

		public function get value():int
		{
			return _value;
		}

		public function set value( value:int ):void
		{
			_value = value;
		}

		public function toggleLabel( visible:Boolean ):void
		{
			_txtNumber.visible = visible;
		}
	}
}