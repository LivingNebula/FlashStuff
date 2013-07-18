package components
{
	import flash.display.SpreadMethod;
	
	import mx.core.IContainer;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.events.FlexEvent;
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradient;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.core.MaskType;
	import spark.filters.DropShadowFilter;
	import spark.primitives.Graphic;
	import spark.primitives.Rect;
	
	public class GradientLabel extends Group
	{	
		private var graphic:Graphic;
		public var label:Label;
		
		public function set text( value:String ):void
		{
			if(label)
				label.text = value;
		}
		
		public function GradientLabel(id:String, width:int, height:int, text:String, fontFamily:String, fontSize:int, textAlign:String, colors:Array)
		{
			super();
			
			this.id = id;
			
			// Create the label
			label = new Label();
			if(width > 0 ) label.width = width;
			if(height > 0) label.height = height;
			if(text) label.text = text;
			if(fontSize) label.setStyle( "fontSize", fontSize );
			if(fontFamily) label.setStyle(	"fontFamily", fontFamily);
			if(textAlign) label.setStyle( "textAlign", textAlign );
			this.addElement( label );
			
			
			// Create the graphic
			graphic = new Graphic();
			graphic.width = label.width;
			graphic.height = 900;
			
			var gradient:LinearGradient = new LinearGradient();
			gradient.rotation = 90;
			gradient.spreadMethod = SpreadMethod.REFLECT;
			gradient.scaleX = 20;
			
			var gradientEntries:Array = [];			
			for( var i:uint = 0; i < colors.length; i++ )
			{
				gradientEntries.push( new GradientEntry( colors[i] ) );
			}
			gradient.entries = gradientEntries;
			
			var rect:Rect = new Rect();
			rect.width = graphic.width;
			rect.height = graphic.height;
			rect.fill = gradient;
			
			var shadow:DropShadowFilter = new DropShadowFilter();
			shadow.distance = 3;
			shadow.blurX = shadow.blurY = 4.0;
			shadow.color = 0x000000;
			shadow.alpha = 0.75;
			shadow.angle = 60;
			shadow.strength = 3;
			
			graphic.addElement( rect );
			graphic.filters = [shadow];
			graphic.mask = label;
			graphic.maskType = MaskType.ALPHA;
			this.addElement( graphic );
		}
	}
}