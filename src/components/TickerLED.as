package components
{
	import flash.display.Sprite;
	
	import interfaces.IDisposable;
	
	import spark.filters.BevelFilter;
	import spark.filters.GradientGlowFilter;
	
	public class TickerLED extends Sprite implements IDisposable
	{
		private var _x:Number;
		private var _y:Number;
		private var _color:uint;
		private var _diameter:uint;
		private var _isOn:Boolean = false;
		
		private var _sprOn:Sprite;
		private var _sprOff:Sprite;
		
		public function set color( value:uint ):void
		{
			_color = value;
			generateSprites();
		}
		
		public function set diameter( value:Number ):void
		{
			_diameter = value;
			generateSprites();
		}
		
		public function TickerLED( color:uint, diameter:Number )
		{
			_color = color;
			_diameter = diameter;
			
			generateSprites();
		}
		
		public function toggle( isOn:Boolean ):void
		{
			_isOn = isOn;
			_sprOn.visible = _isOn;
			_sprOff.visible = !_isOn;
		}
		
		private function generateSprites():void
		{
			if( _sprOn != null ) { removeChild( _sprOn ); _sprOn = null; }
			_sprOn = new Sprite();
			_sprOn.graphics.lineStyle( 1, _color, 0.75 );
			_sprOn.graphics.beginFill( _color );
			_sprOn.graphics.drawCircle( 0, 0, _diameter >> 1 );
			_sprOn.graphics.endFill();
			//_sprOn.filters = [new GradientGlowFilter( 0, 45,[0x000000, _color], [0, 1],[0, 255], _diameter >> 1, _diameter >> 1 )];
			_sprOn.visible = _isOn;
			addChild( _sprOn );
			
			if( _sprOff != null ) { removeChild( _sprOff ); _sprOff = null; }
			_sprOff = new Sprite();
			_sprOff.graphics.lineStyle( 1, 0x222222, 0.75 );
			_sprOff.graphics.beginFill( 0x000000 );
			_sprOff.graphics.drawCircle( 0, 0, _diameter >> 1 );
			_sprOff.graphics.endFill();
			//_sprOff.filters = [new BevelFilter( 2, 0, 0x999999, 0.7, 0x999999, 0.7, _diameter, _diameter, 2 )];
			_sprOff.visible = !_isOn;
			addChild( _sprOff );
		}
		
		public function dispose():void
		{
			if( _sprOn != null )
			{
				removeChild( _sprOn );
				_sprOn = null;
			}
			
			if( _sprOn != null )
			{
				removeChild( _sprOn );
				_sprOn = null;
			}
		}
	}
}