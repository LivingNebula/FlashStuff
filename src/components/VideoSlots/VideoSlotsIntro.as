package components.VideoSlots
{
	import assets.SkinManager;
	import assets.SoundManager;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundChannel;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	
	import interfaces.IDisposable;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import objects.ErrorMessage;
	
	import services.SweepsAPI;
	
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	import utils.DebugHelper;
		
	public class VideoSlotsIntro extends SkinnableContainer implements IDisposable
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( VideoSlotsIntro );	
		
		private var animationByteArray:ByteArray;
		private var animationClass:Class;
		private var useFLVAnimation:Boolean;
		private var introLoader:Loader;
		private var mcIntro:MovieClip;
		private var lastFrame:int = 0;
		private var soundChannelIntro:SoundChannel;		
		private var onStop:Function;
		private var grpLayer0:Group;
		private var eventListeners:Object = {};		
		
		private var ui:UIComponent;
		private var connect_nc:NetConnection;
		private var stream_ns:NetStream;
		private var video:Video;
		
		public function set FLV_Animation( useFLV:Boolean ):void
		{
			useFLVAnimation = useFLV;
		}
		
		public function get FLV_Animation():Boolean
		{
			return useFLVAnimation;
		}
		
		public function VideoSlotsIntro( onStopCallback:Function )
		{
			// Log Activity
			logger.pushContext( "Constructor", arguments );			
			
			super();
			
			// Create the group to display the SWF animation
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
			
			// Load the skin image and sound classes
			animationClass = SkinManager.getSkinAsset( styleManager, "Intro_Animation" );	
			
			// Check if animation is in FLV format
			if( FLV_Animation )
			{
				// Convert the animation to a byte array
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
				ui = new UIComponent();
				ui.addChild( DisplayObject( video ) );
				grpLayer0.addElement( ui );
				grpLayer0.visible = true;
			}
			else
			{
				// Load the intro animation
				introLoader = new Loader();
				introLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, introLoader_completeHandler );
				introLoader.loadBytes( new animationClass() );
				
				// Add the animation to the stage
				ui = new UIComponent();
				ui.addChild( DisplayObject( introLoader ) );
				grpLayer0.addElement( ui );
			}
			
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
				stream_ns.removeEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
				stream_ns.close();
				stream_ns = null;
				
				connect_nc.close();
				connect_nc = null;
				
				stop();
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		// Handles the 'complete' event when loading the intro animation
		protected function introLoader_completeHandler( event:Event ):void
		{
			// Log Activity
			logger.pushContext( "introLoader_completeHandler", arguments );
			
			// Cleanup the event listener, play our intro sound and show the intro
			introLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, introLoader_completeHandler );
			
			// Play the intro sound
			soundChannelIntro = SoundManager.playSound( SkinManager.getSkinAsset( styleManager, "Intro_Audio" ), 0, 1 );
			grpLayer0.visible = true;
			
			// Cast the loader.content in our movie clip and listen for the enter frame event				
			mcIntro = introLoader.content as MovieClip;
			if ( mcIntro != null && mcIntro is MovieClip )
			{
				mcIntro.addEventListener( Event.ENTER_FRAME, enterFrame );	
				
				// Start the intro
				mcIntro.gotoAndPlay( 2 );
			}
			else
			{	
				var errMsg:ErrorMessage = new ErrorMessage( "VIDEOSLOTS:Intro Loader Complete handler fired, but intro Movie Clip is not available.", "", "", "" );
				if( Sweeps.DEBUG && !Sweeps.DEBUG_W_API ) 
				{
					throw new Error( errMsg.toString() );
				}
				else
				{
					SweepsAPI.reportError( errMsg );
					stop();
				}	
			}
			
			// Clear Context
			logger.popContext();			
		}	
		
		// Handles the 'enter frame' event when playing the intro animation
		protected function enterFrame( event:Event ):void
		{			
			if( mcIntro.currentFrame == mcIntro.totalFrames || lastFrame > mcIntro.currentFrame )
			{					
				// Log Activity
				logger.pushContext( "enterFrame", arguments );
				logger.debug( "Intro is complete, stopping and unloading." );
				
				mcIntro.removeEventListener( Event.ENTER_FRAME, enterFrame );
				introLoader.unloadAndStop( true );
				stop();
				
				// Clear Context
				logger.popContext();				
			}
			else
			{				
				lastFrame = mcIntro.currentFrame;
			}
		}
		
		// Removes all the event listeners and elements from the container and dispatches a stop event
		public function stop():void
		{
			// Log Activity
			logger.pushContext( "stop", arguments );
			
			// Remove the event listener
			removeEventListener( MouseEvent.CLICK, clickHandler );
			
			// Remove elements
			removeAllElements();
			
			// Execute callback
			onStop( this );

			// Clear Context
			logger.popContext();		
		}
		
		protected function clickHandler( event:MouseEvent ):void
		{
			// Log Activity
			logger.pushContext( "clickHandler", arguments );
			
			// Remove the event listener
			removeEventListener( MouseEvent.CLICK, clickHandler );
			
			// Fast Forward the Intro to the end
			if( mcIntro != null && mcIntro is MovieClip )
			{
				mcIntro.gotoAndPlay( mcIntro.totalFrames );
			}
			
			// Stop our intor sound if it's playing
			if( soundChannelIntro != null )
			{
				soundChannelIntro.stop();
				soundChannelIntro = null;
			}
			
			// Close our stream
			if( stream_ns != null )
			{
				stream_ns.removeEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
				stream_ns.close();
				stream_ns = null;
			}
			
			// Clouse our netconnection
			if( connect_nc != null )
			{
				connect_nc.close();
				connect_nc = null;
			}
			
			// Stop the intro
			stop();
			
			// Clear Context
			logger.popContext();			
		}
		
		// Diposes of the component
		public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );
			
			// Remove the event listener
			removeEventListener( MouseEvent.CLICK, clickHandler );
			
			// Cleanup the intro
			if( mcIntro != null )
			{
				mcIntro.removeEventListener( Event.ENTER_FRAME, enterFrame );	
				mcIntro.stop();
				mcIntro = null;
			}
			
			// Cleanup the stream
			if( stream_ns != null )
			{
				stream_ns.removeEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
				stream_ns.close();
				stream_ns = null;
			}			
			
			// Cleanup the netconnection
			if( connect_nc != null )
			{
				connect_nc.close();
				connect_nc = null;
			}			
			
			// Cleanup our loader
			if( introLoader != null )
			{
				try
				{
					introLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, introLoader_completeHandler );
					introLoader.close(); // Throws an error if the loader hasn't started yet
				}
				catch( ex:Error ){}
				
				introLoader = null;
			}
			
			// Remove all the elements
			grpLayer0.removeAllElements();
			
			// Clear Context
			logger.popContext();			
		}
	}
}