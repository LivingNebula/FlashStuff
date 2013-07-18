package components.VideoSlots
{
	import assets.SkinManager;
	
	import flash.display.DisplayObject;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	
	import interfaces.IDisposable;
	
	import mx.core.UIComponent;
	
	import spark.components.Group;
	
	import utils.DebugHelper;

	public class WinningIconAnimation extends Group implements IDisposable
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( WinningIconAnimation );	
		
		private var connect_nc:NetConnection;
		private var stream_ns:NetStream;
		private var video:Video;
		
		private var animationByteArray:ByteArray;
		private var animationClass:Class;	
		private var onStop:Function;
		private var animationName:String;
		private var repeatCount:int;
		private var currentCount:int;
		
		public function WinningIconAnimation( winIcon:String, onStopCallback:Function = null, width:int = 800, height:int = 560 )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );
			
			super();
			
			onStop = onStopCallback;
			animationName = winIcon;
			this.width = width;
			this.height = height;
			this.currentCount = 0;
			
			// Clear Context
			logger.popContext();
		}
		
		public function play( repeatCount:int = 1 ):void
		{
			// Log Activity
			logger.pushContext( "play", arguments );
			
			// Set the repeat count
			this.repeatCount = repeatCount;
			this.currentCount++;
			
			// Load the animation class
			animationClass = SkinManager.getSkinAsset( styleManager, animationName );					
			animationByteArray = new animationClass();
			
			// Initialize the net connection
			connect_nc = new NetConnection();
			connect_nc.connect( null );
			
			// Initialize the net stream
			stream_ns = new NetStream( connect_nc );
			stream_ns.client = this;
			stream_ns.client = { onMetaData:function( obj:Object ):void{} }
			stream_ns.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			stream_ns.play( null );
			stream_ns.appendBytes( animationByteArray );
			
			// Initialize the animation
			video = new Video( width, height );
			video.attachNetStream( stream_ns );
			
			// Add the animation to the stage
			var ui:UIComponent = new UIComponent();
			ui.addChild( DisplayObject( video ) );
			addElement( ui );
			
			// Clear Context
			logger.popContext();			
		}
		
		// Handles the 'Net Status' event of the Net Stream
		protected function netStatusHandler( event:NetStatusEvent ):void
		{
			if( event.info.code == "NetStream.Play.Stop" || event.info.code == "NetStream.Buffer.Empty" )
			{									
				stop( false );
			}		
		}
		
		// Removes all the event listeners and elements from the container and dispatches a stop event
		public function stop( forceStop:Boolean = true ):void
		{
			// Log Activity
			logger.pushContext( "stop", arguments );
			
			if( stream_ns != null )
			{
				stream_ns.removeEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
				stream_ns.close();
				stream_ns = null;
			}
			
			if( connect_nc != null )
			{
				connect_nc.close();
				connect_nc = null;
			}
			
			removeAllElements();
			
			if( !forceStop && ( repeatCount > currentCount || repeatCount == 0 ) )
			{
				play( repeatCount );
			}
			else if( onStop != null )
			{
				onStop( this );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		// Disposes of the component
		public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );
			
			if( stream_ns != null )
			{
				stream_ns.removeEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
				stream_ns.close();
				stream_ns = null;
			}
			
			if( connect_nc != null )
			{
				connect_nc.close();
				connect_nc = null;
			}
			
			removeAllElements();
			
			// Clear Context
			logger.popContext();			
		}		
	}
}