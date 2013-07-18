package starling.components
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.controls.Text;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import utils.DebugHelper;
	import utils.MathHelper;
	
	public class Actor extends Sprite
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
		private var videoTexture:RenderTexture;
		
		private var animationByteArray:ByteArray;
		private var repeatTimer:Timer;
		private var loader:Loader;
		private var video:MovieClip;
		private var videoImage:Image;
		private var videoBitmapData:BitmapData;
		private var id:String;
		
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
			logger.pushContext( "consturctor", arguments );
			
			super();
			
			this.id = "Genie";
			this.width = width;
			this.height = height;
			
			staticImage = new Image( starling.textures.Texture.empty( width, height ) );
			staticImage.width = width;
			staticImage.height = height;
			staticImage.visible = false;
//			staticImage.transform.matrix = new Matrix( 1, 0, 0, 1,  facingDirection == 1 ? 0 : width, 0 );
			addChild( staticImage );
			
			// Clear Context
			logger.popContext();
		}
		
		public function addStaticImage( texture:Texture ):void
		{
			// Log Activity
			logger.pushContext( "addStaticImage", arguments );
			staticImage.texture = texture;
			
			// Clear Context
			logger.popContext();
		}
		
		public function addAnimation( name:String, bytes:ByteArray ):void
		{
			// Log Activity
			logger.pushContext( "addAnimation", arguments );
			animations[name] = bytes;
			
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
				animationByteArray = new ByteArray();
				animationByteArray.writeBytes( animations[name] );
				animations[name].position = 0;
				
				// Create the loader
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener( flash.events.Event.COMPLETE, loaderCompleteHandler );
				loader.loadBytes( animationByteArray );
			}
			
			// Clear Context
			logger.popContext();
		}
		
		private function loaderCompleteHandler( event:flash.events.Event ):void
		{
			// Log Activity
			logger.pushContext( "loaderCompleteHandler", arguments );
			loader.contentLoaderInfo.removeEventListener( flash.events.Event.COMPLETE, loaderCompleteHandler );
			video = loader.content as MovieClip;
			video.addEventListener( Event.ENTER_FRAME, videoOnEnterFrame );
			video.gotoAndPlay( 1 );
			
			if( playing && !hasEventListener( Event.ENTER_FRAME ) )
			{
				// Add an event listener for the frame event so we can copy the video data to an image
				addEventListener( Event.ENTER_FRAME, onEnterFrame );	
			}
			
			// Clear Context
			logger.popContext();
		}
		
		private function videoOnEnterFrame( event:flash.events.Event ):void
		{
			if( video.currentFrame == 1 )
			{
				currentRepetitions++;
				if( currentRepetitions >= repetitions && repetitions != 0 )
				{
					video.gotoAndStop( 1 );
					stop();
				}
			}
		}
		
		private function onEnterFrame( event:Event ):void
		{
			if( !videoImage || !videoBitmapData )
			{				
				videoBitmapData = new BitmapData( width, height, true, 0x000000 );				
				videoImage = new Image( Texture.fromBitmapData( videoBitmapData ) );
				addChild( videoImage );				
			}
			
			videoBitmapData.fillRect( new Rectangle( 0, 0, width, height ), 0 );
			videoBitmapData.draw( video );
			videoImage.texture.dispose();
			videoImage.texture = Texture.fromBitmapData( videoBitmapData );
		}
		
		public function flip( facingDirection:int ):void
		{
//			staticImage.transform.matrix = new Matrix( 1, 0, 0, 1,  facingDirection == 1 ? 0 : width, 0 );
//			staticImage.scaleX = this.facingDirection = facingDirection;
//			if( video != null )
//			{ 
//				video.transform.matrix = new Matrix( 1, 0, 0, 1,  facingDirection == 1 ? 0 : width, 0 );
//				video.scaleX = facingDirection; 
//			}
		}
		
		public function stop( triggerCallback:Boolean = true ):void
		{
			// Log Activity
			logger.pushContext( "stop", arguments );
			removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			
			staticImage.visible = true;
			playing = false;
			
			if( video != null )
			{
				video.removeEventListener( flash.events.Event.ENTER_FRAME, videoOnEnterFrame );
				video = null;
			}			
			
			if( loader != null )
			{
				loader.contentLoaderInfo.removeEventListener( flash.events.Event.COMPLETE, loaderCompleteHandler );
				loader.unload();
				loader = null;
			}
			
			if( animationByteArray != null )
			{
				animationByteArray.clear();
				animationByteArray = null;	
			}			

			if( videoImage != null )
			{
				removeChild( videoImage );
				videoImage.dispose();
				videoImage = null;
			}
			
			if( triggerCallback && animationFinishedCallback != null )
			{
				animationFinishedCallback( this, lastPlayed );
			}
			
			// Clear Context
			logger.popContext();
		}
		
		override public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );
			// Stop the currently playing animation, without triggering the callback
			stop( false );
			
			// Call our super method
			super.dispose();
			
			// Clear Context
			logger.popContext();			
		}
	}
}