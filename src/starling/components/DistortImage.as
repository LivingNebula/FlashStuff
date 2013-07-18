package starling.components
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class DistortImage extends Image
	{
		public function DistortImage( texture:Texture )
		{
			super( texture );
		}
		
		public function distort( p1:Point, p2:Point, p3:Point, p4:Point ):void
		{
			mVertexData.setPosition(0, p1.x, p1.y);
			mVertexData.setPosition(1, p2.x, p2.y);
			mVertexData.setPosition(2, p4.x, p4.y);
			mVertexData.setPosition(3, p3.x, p3.y);
			
			onVertexDataChanged();
		}
	}
}