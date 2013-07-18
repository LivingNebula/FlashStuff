package components
{
	import spark.components.Button;
	
	[Style(name="imageBadge", type=*)]
	[Style(name="imageIcon", type=*)]
	[Style(name="imageSkin", type=*)]
	[Style(name="imageSkinOver", type=*)]
	[Style(name="imageSkinDown", type=*)]
	[Style(name="imageSkinDisabled", type=*)]
	[Style(name="textHorizontalCenter", type="int")]
	[Style(name="textHorizontalCenterDown", type="int")]
	[Style(name="textVerticalCenter", type="int")]
	[Style(name="textVerticalCenterDown", type="int")]
	
	public class ImageButton extends Button
	{
		public function ImageButton()
		{
			super();
			this.buttonMode = true;
		}
		
		public function set imageIcon( value:Class ):void
		{
			setStyle( "imageIcon", value );
		}
		
		public function get imageIcon():Class
		{
			return getStyle( "imageIcon" );
		}
	}
}