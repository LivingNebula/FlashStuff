package components
{
	import flash.display.DisplayObject;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import interfaces.IDebuggable;
	import interfaces.IDisposable;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	
	import objects.FLVByteArray;
	
	import utils.DebugHelper;
	import utils.MathHelper;
	
	public class Actor extends UIComponent implements IDisposable, IDebuggable
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( Actor );	
		
		private var animations:Object = new Object;
		private var animationFinishedCallback:Function;
		private var playing:Boolean = false;
		private var lastPlayed:String = "";
		private var currentRepetitions:int = 0;
		private var shiftCount:int = 0;
		private var repetitions:int = 0;
		private var facingDirection:int = 1;
		private var staticImage:Image;
		
		private var animationByteArray:FLVByteArray;
		private var animationByteArrayClone:FLVByteArray;
		private var connect_nc:NetConnection;
		private var stream_ns:NetStream;
		private var repeatTimer:Timer;
		private var video:Video;
		
		public function get animationList():Array
		{
			var ani:Array = [];
			for(var name:String in animations)
			{
				if(animations.hasOwnProperty(name)){
					ani.push(name);
				}
			}
			
			return ani;
		}
		
		public function get direction():int
		{
			return facingDirection;
		}
		
		public function set onAnimationFinished( value:Function ):void
		{
			animationFinishedCallback = value;
		}
		
		public function get isPlaying():Boolean
		{
			return playing;
		}
		
		public function Actor( width:int, height:int )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );
			
			super();
			
			this.width = width;
			this.height = height;
			
			staticImage = new Image();
			staticImage.width = width;
			staticImage.height = height;
			staticImage.visible = false;
			staticImage.transform.matrix = new Matrix( 1, 0, 0, 1,  facingDirection == 1 ? 0 : width, 0 );
			addChild( staticImage );
			
			// Clear Context
			logger.popContext();			
		}
		
		public function addStaticImage( image:Class ):void
		{
			// Log Activity
			logger.pushContext( "addStaticImage", arguments );
			staticImage.source = image;
			staticImage.visible = true;
			
			// Clear Context
			logger.popContext();			
		}
		
		public function addAnimation( name:String, animationClass:Class ):void
		{
			// Log Activity
			logger.pushContext( "addAnimation", arguments );
			animations[name] = animationClass;
			
			// Clear Context
			logger.popContext();			
		}
		
		public function playRandomAnimation( repeatCount:int = 0 ):void
		{
			// Log Activity
			logger.pushContext( "playRandomAnimation", arguments );
			playAnimation( animationList[MathHelper.randomNumber( 0, animationList.length -1 )], repeatCount );
			
			// Clear Context
			logger.popContext();			
		}
		
		public function replay():void
		{
			// Log Activity
			logger.pushContext( "replay", arguments );
			playAnimation( lastPlayed, repetitions );
			
			// Clear Context
			logger.popContext();			
		}
		
		public function playAnimation( name:String, repeatCount:int = 0 ):void
		{
			// Log Activity
			logger.pushContext( "playAnimation", arguments );
			
			if( playing )
			{
				// Clear Context
				logger.popContext();				
				return; 
			}
			currentRepetitions = 0;
			repetitions = repeatCount;
			
			if( animations[name] )
			{
				playing = true;
				lastPlayed = name;
				animationByteArray = new FLVByteArray( new animations[name]() );
				
				// Initialize the net connection
				connect_nc = new NetConnection();
				connect_nc.connect( null );
				
				// Initialize the net stream
				stream_ns = new NetStream( connect_nc );
				stream_ns.client = { onMetaData:function( obj:Object ):void{} }
				stream_ns.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
				stream_ns.play( null );
				stream_ns.appendBytes( animationByteArray.getBytesCopy() );
				
				// Initialize the repeatTimer
				shiftCount = 0;
				repeatTimer = new Timer( animationByteArray.getDuration() * 0.95, 0 );
				repeatTimer.addEventListener( TimerEvent.TIMER, repeatTimer_TIMER );
				repeatTimer.start();
				
				// Initialize the animation
				video = new Video( width, height );
				video.transform.matrix = new Matrix( 1, 0, 0, 1, facingDirection == 1 ? 0 : width, 0 );
				video.scaleX = facingDirection;
				video.attachNetStream( stream_ns );
				
				// Add the animation to the stage
				addChild( video );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		private function netStatusHandler( event:NetStatusEvent ):void
		{
			switch( event.info.code )
			{
				case "NetStream.Buffer.Full":
					if( playing && staticImage.visible )
					{						
						// Hide the default static image
						staticImage.visible = false;
					}
					break;
				
				case "NetStream.Buffer.Empty":
					if( playing && !repeatTimer.running )
					{
						playing = false;
						stop();
					}					
					break;
			}
		}
		
		private function repeatTimer_TIMER( event:TimerEvent ):void
		{
			currentRepetitions++;
			
			if( currentRepetitions == repetitions && repetitions !== 0 )
			{
				repeatTimer.stop();
				repeatTimer.reset();				
			}
			else
			{
				// Check to make sure we have enough data in the buffer to perform another loop
				if( stream_ns.bufferLength < ( animationByteArray.getDuration() / 1000 ) )
				{
					// Increment how many times we've appended so we can properly shift our timestamps
					shiftCount++;
					
					// Clone the original byte array, update the timestamps, strip off the header and then append it to the netSteam.
					animationByteArrayClone = animationByteArray.clone();					
					animationByteArrayClone.shiftTimeStamps( shiftCount * animationByteArrayClone.getDuration() );										
					stream_ns.appendBytes( animationByteArrayClone.getBytesCopy( false ) );
					animationByteArrayClone = null;
				}
			}
		}
		
		public function flip( facingDirection:int ):void
		{
			// Log Activity
			logger.pushContext( "flip", arguments );
			staticImage.transform.matrix = new Matrix( 1, 0, 0, 1,  facingDirection == 1 ? 0 : width, 0 );
			staticImage.scaleX = this.facingDirection = facingDirection;
			if( video != null )
			{ 
				video.transform.matrix = new Matrix( 1, 0, 0, 1,  facingDirection == 1 ? 0 : width, 0 );
				video.scaleX = facingDirection; 
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		public function stop( triggerCallback:Boolean = true ):void
		{
			// Log Activity
			logger.pushContext( "stop", arguments );
			
			staticImage.visible = true;
			playing = false;
			
			if( repeatTimer != null )
			{
				repeatTimer.removeEventListener( TimerEvent.TIMER, repeatTimer_TIMER );
				repeatTimer.stop();
				repeatTimer.reset();
				repeatTimer = null;
			}
			
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
			
			if( video != null )
			{
				this.removeChild( video );
				video = null;
			}
			
			if( animationByteArray != null )
			{
				animationByteArray.clear();
				animationByteArray = null;	
			}
			
			if( animationByteArrayClone != null )
			{
				animationByteArrayClone.clear();
				animationByteArrayClone  = null;
			}
			
			// THIS MUST BE THE LAST CALL in "STOP". Place any new items above this.
			if( triggerCallback && animationFinishedCallback != null )
			{
				animationFinishedCallback( this, lastPlayed );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );
						
			// Stop the currently playing animation, without triggering the callback
			stop( false );
			
			// Clear Context
			logger.popContext();			
		}
		
		public function getDebugInfo():String
		{
			return null;
		}
	}
}