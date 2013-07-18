package starling.components
{
	import flash.geom.Point;
	
	import starling.components.DistortImage;
	import starling.core.Starling;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	import utils.DebugHelper;
	
	public class ButtonPanelButton extends ComplexButton
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( ButtonPanel );	
		
		private var _text:String;
		private var _label:TextField;		
		private var _labelImage:DistortImage;
		private var _renderTexture:RenderTexture;
		
		public function ButtonPanelButton(upState:Texture, text:String="", downState:Texture=null, overState:Texture=null, disabledState:Texture=null)
		{
			super(upState, "", downState, overState, disabledState);
			
			_text = text;
			_label = new TextField( upState.width, upState.height, text, "xTimes", 15, 0x000000, true );
			_renderTexture = new RenderTexture( upState.width, upState.height, false );
			_renderTexture.draw( _label );
			_labelImage = new DistortImage( _renderTexture );
			_labelImage.filter = new starling.filters.BlurFilter( 0.25, 0.25 );
			
			addChild( _labelImage );
		}
		
		override public function set text( value:String ):void
		{
			_text = value;
			_label.text = value;
			
			_renderTexture.clear();
			_renderTexture.draw( _label );
		}
		
		override public function get text():String
		{
			return _text;
		}
		
		override public function set fontSize( value:Number ):void
		{
			_label.fontSize = value;
		}
		
		override public function get fontSize():Number
		{
			return _label.fontSize;
		}
		
		public function distortLabel( pt1:Point, pt2:Point, pt3:Point, pt4:Point ):void
		{
			_labelImage.distort( pt1, pt2, pt3, pt4 );
		}
		
		override public function set isDown( value:Boolean ):void
		{
			super.isDown = value;
			
			if( isDown )
			{
				_labelImage.y = 5;
			}
			else
			{
				_labelImage.y = 0;
			}
		}
		
		override public function dispose():void
		{
			logger.info("dispose >" );
			
			// Cleanup our render textures and components
			_labelImage.dispose();
			_label.dispose();
			_renderTexture.clear();
			_renderTexture.dispose();
			
			// Call our super method
			super.dispose();			
		}
	}
}