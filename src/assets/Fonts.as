package assets
{
	[Bindable]
	public class Fonts
	{
		// Times New Roman
		[Embed( source='/../fonts/times.ttf', fontFamily='xTimes', mimeType='application/x-font', advancedAntiAliasing='true' )] 
		public static var timesFontNormal:Class;
		
		// Times New Roman - Bold
		[Embed( source='/../fonts/timesbd.ttf', fontFamily='xTimes', fontWeight='bold', mimeType='application/x-font', advancedAntiAliasing='true' )] 
		public static var timesFontBold:Class;
		
		// Digital-7
		[Embed( source='/../fonts/digital-7.ttf', fontFamily='digital7', mimeType='application/x-font' )] 
		public static var digital7:Class;
		
		// SoopaFresh
		[Embed( source='/../fonts/soopafresh.ttf', fontFamily='Soopafresh', fontWeight='bold', mimeType='application/x-font', embedAsCFF='true' )] 
		public static var Soopafresh:Class;		
		
		// Kokila - Bold
		[Embed( source='/../fonts/kokilab.ttf', fontFamily='Kokila', fontWeight='bold', mimeType='application/x-font', embedAsCFF='true' )] 
		public static var kokilaBold:Class;
		
		// Futura Condensed - Bold
		[Embed( source='/../fonts/futura.ttf', fontFamily='FuturaBold', fontWeight='bold', mimeType='application/x-font', embedAsCFF='true' )] 
		public static var futuraBold:Class;
		
		public function Fonts()
		{
		}
	}
}