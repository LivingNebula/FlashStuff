package components
{
	import flash.display.Sprite;
	
	import mx.core.UIComponent;

	public class SpriteUIComponent extends UIComponent
	{
		public function SpriteUIComponent( sprite:Sprite )
		{
			super();
			
			explicitHeight = sprite.height;
			explicitWidth = sprite.width;
			
			addChild( sprite );
		}
		
		public function setProperties(			
			_x:Number = 0, _y:Number = 0, _z:Number = 0, 
			_scaleX:Number = 1.0, _scaleY:Number = 1.0, _scaleZ:Number = 1.0, 
			_rotationX:Number = 0, _rotationY:Number = 0, _rotationZ:Number = 0,
			_alpha:Number = 1.0, _depth:Number = 0, _visible:Boolean = true ):void
		{
			x = _x;
			y = _y;
			z = _z;
			scaleX = _scaleX;
			scaleY = _scaleY;
			scaleZ = _scaleZ;
			rotationX = _rotationX;
			rotationY = _rotationY;
			rotationZ = _rotationZ;
			alpha = _alpha;
			depth = _depth;
			visible = _visible;
		}
		
		public function dispose():void
		{
			if( this.numChildren > 0 )
			{
				var ai:AnimatedImage = this.getChildAt( 0 ) as AnimatedImage;
				if( ai != null )
				{
					ai.dispose();
					this.removeChildAt( 0 );
				}
			}
		}
	}
}