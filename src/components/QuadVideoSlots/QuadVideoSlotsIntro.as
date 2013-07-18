package components.QuadVideoSlots
{
	import assets.SkinManager;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	
	import interfaces.IDisposable;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	import utils.DebugHelper;
		
	public class QuadVideoSlotsIntro extends SkinnableContainer implements IDisposable
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( QuadVideoSlotsIntro );	
		
		private var connect_nc:NetConnection;
		private var stream_ns:NetStream;
		private var video:Video;
		
		private var animationByteArray:ByteArray;
		private var animationClass:Class;	
		private var onStop:Function;
		private var grpLayer0:Group;
		
		public function QuadVideoSlotsIntro( onStopCallback:Function )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );
			
			super();
			
			// Create the group to display the animation
			grpLayer0 = new Group();
			grpLayer0.width = 800;
			grpLayer0.height = 600;
			grpLayer0.clipAndEnableScrolling = true;
			grpLayer0.visible = false;
			addElement( grpLayer0 );
			
			// Setup our properties
			onStop = onStopCallback;
			width = 800;
			height = 600;
			useHandCursor = true;
			
			// Add the event listener so the user can click past the intro
			addEventListener( MouseEvent.CLICK, clickHandler )
			
			// Clear Context
			logger.popContext();			
		}
		
		public function play():void
		{
			// Log Activity
			logger.pushContext( "play", arguments );
			
			// Load the animation class
			animationClass = SkinManager.getSkinAsset( styleManager, "Intro_Animation" );					
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
			video = new Video( 800, 560 );
			video.attachNetStream( stream_ns );
			
			// Add the animation to the stage
			var ui:UIComponent = new UIComponent();
			ui.addChild( DisplayObject( video ) );
			grpLayer0.addElement( ui );
			grpLayer0.visible = true;
			
			// Clear Context
			logger.popContext();			
		}
		
		// Handles the 'Net Status' event of the Net Stream
		protected function netStatusHandler( event:NetStatusEvent ):void
		{
			// Log Activity
			logger.pushContext( "netStatusHandler", arguments.concat( event.info.code ) );
			
			if( event.info.code == "NetStream.Play.Stop" || event.info.code == "NetStream.Buffer.Empty" )
			{									
				stop();
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		// Removes all the event listeners and elements from the container and dispatches a stop event
		public function stop():void
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
			onStop( this );
			
			// Clear Context
			logger.popContext();			
		}
		
		protected function clickHandler( event:MouseEvent ):void
		{
			// Log Activity
			logger.pushContext( "clickHandler", arguments );
			
			stop();
			
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
			
			grpLayer0.removeAllElements();
			
			// Clear Context
			logger.popContext();			
		}
	}
}