package components
{
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import mx.events.*;
	import mx.preloaders.DownloadProgressBar;

	public class Preloader extends DownloadProgressBar
	{
		private var _BackgroundBitmap : Bitmap; // Background bitmap
		
		[Embed(source="/../assets/images/Preloader.jpg")]
		[Bindable]
		private var _BackgroundImage : Class; // Background image		
		
		[Embed(source="/../assets/images/Preloader_skilltopia.jpg")]
		[Bindable]
		private var _BackgroundImage_Skilltopia : Class; // Background image - Skilltopia
		
		[Embed(source="/../assets/images/messageBox.png")]
		[Bindable]
		private var _ProgressBackgroundImage  : Class; 	// Background image for progress bar
		private var _ProgressBackgroundBitmap : Bitmap;	// Background bitmap for progress bar			
		
		private var _BackgroundSize  	: String = "100%"; 					// Background size
		private var _DownloadingLabel 	: String = "Loading games...";		// String to display while in the downloading phase
		private var _InitializingLabel 	: String = "Initializing games...";	// String to display while in the initializing phase
		private var _MinimumDisplayTime : uint 	 = 0;						// Minimum number of milliseconds that the display should appear visible
		private var _DownloadPercentage : uint 	 = 90;						// Percentage of the progress bar that the downloading phase fills when the SWF file is fully downloaded
		
		private var skilltopiaEnabled	:String  = "";
		private const SKILLTOPIA_ENABLED:Boolean = false;

		public function Preloader()
		{
			super();
					
			// Set the download label
			downloadingLabel = _DownloadingLabel;
				
			// Set the initialization label
			initializingLabel = _InitializingLabel;
			
			// Set the minimum display time
			MINIMUM_DISPLAY_TIME = _MinimumDisplayTime;
			
			// Set the download percentage
			DOWNLOAD_PERCENTAGE = _DownloadPercentage;					
		}
		
		// Determines if Skilltopia is enabled
		private function get SkilltopiaEnabled():Boolean
		{
			var isSkilltopEnabled:Boolean = SKILLTOPIA_ENABLED;
			if( skilltopiaEnabled != "" )
			{
				try
				{
					skilltopiaEnabled = skilltopiaEnabled.toLowerCase();
					isSkilltopEnabled = (skilltopiaEnabled == "true" || skilltopiaEnabled == "1");
				}
				catch( e:* )
				{
					// Do nothing
				}					
			}
			
			return isSkilltopEnabled;
		}
		
		// Retrieves the flash variables
		private function getFlashVars():Object
		{			
			var flash_Vars:Object = new Object();
			try
			{
				flash_Vars = LoaderInfo(loaderInfo).parameters;
			} 
			catch( e:* )
			{
				// Do nothing
			}
			
			return flash_Vars;
		}
		
		// Checks the flash initialization variables
		protected function checkFlashVars():void
		{			
			// Retrieve & store the initalization variables	
			var flashVars:Object = getFlashVars();
			if( flashVars.skilltopiaEnabled != null && flashVars.skilltopiaEnabled != "" ) { skilltopiaEnabled = flashVars.skilltopiaEnabled; }		
		}

		// Override the initialize method
		override public function initialize():void 
		{
			super.initialize();
			
			// Check the initialization variables
			checkFlashVars();
			
			// Add a background image
			if( SkilltopiaEnabled )
			{
				_BackgroundBitmap = new _BackgroundImage_Skilltopia as Bitmap;			
			}
			else
			{
				_BackgroundBitmap = new _BackgroundImage as Bitmap;
			}
			addChild( _BackgroundBitmap );
			
			// Add the progress background image
			_ProgressBackgroundBitmap = new _ProgressBackgroundImage as Bitmap;
			_ProgressBackgroundBitmap.alpha = 0.75;
			_ProgressBackgroundBitmap.width = 200;
			_ProgressBackgroundBitmap.height = 75;
			_ProgressBackgroundBitmap.x = width / 2 - _ProgressBackgroundBitmap.width / 2;
			_ProgressBackgroundBitmap.y = height / 2 - _ProgressBackgroundBitmap.height / 2;
			addChild( _ProgressBackgroundBitmap );
		}
		
		// Override the progress handler to customize the display label
		override protected function progressHandler( event:ProgressEvent ):void
        {
			super.progressHandler( event );
			
            var loaded:uint = event.bytesLoaded;
            var total:uint = event.bytesTotal;
			var progress:Number = Math.round(loaded/total * 100);
			label = downloadingLabel + " " + progress + "%";
		}
		
		// Override to set the label format
		override protected function get labelFormat():TextFormat
		{
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
			format.color = 0xFFFFFF;
			format.size = 10;
			format.bold = true;
			
			return format;
		}
		
		// Override to set the label rectangle
		override protected function get labelRect():Rectangle
		{
			return new Rectangle(14, 17, 150, 16);
		}
		
		// Override to set the size of the background image
		override public function get backgroundSize():String
		{
			return _BackgroundSize;
		}
		
		// Override to return true so progress bar appears during initialization       
		override protected function showDisplayForInit( elapsedTime:int, count:int ):Boolean 
		{
			return true;
		}
		
		// Override to return true so progress bar appears during download     
		override protected function showDisplayForDownloading( elapsedTime:int, event:ProgressEvent ):Boolean 
		{
			return true;
		}
	}
}