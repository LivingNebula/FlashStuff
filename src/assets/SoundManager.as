package assets
{
	import assets.SimpleDataTimer;
	
	import components.SoundPitchShift;
	
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	
	import utils.DebugHelper;
	
	public class SoundManager
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( SoundManager );
		
		public static const DEFAULT_VOLUME:Number = 100;
		public static const MUTE_VOLUME:Number = 0;
		
		public static var volume:Number;
		
		/**
		 * Toggles the provided sound class on and of, optionally fading it.
		 * 
		 * @param sound The sound or sound class to play.
		 * @param soundChannel The <code>SoundChannel</code> to stop playing.
		 * @param play If <code>true</code>, plays the sound, otherwise stops the sound.
		 * @param fade If <code>true</code>, fades the sound.
		 * @param startTime How far into the sound to start playing.
		 * @param loop How many times to loop the sound.
		 * @param delay How long to wait before playing or stopping the sound.
		 * @param volume The volume to play the sound at.
		 * @return Returns a <code>SoundChannel</code>
		 * @see flash.media.SoundChannel
		 */		
		public static function toggleSound( sound:*, soundChannel:SoundChannel, play:Boolean = true, fade:Boolean = true, startTime:Number = 0, loops:int = int.MAX_VALUE, delay:int = 100, volume:Number = 100 ):SoundChannel
		{
			// Log Activity
			logger.pushContext( "toggleSound", arguments );
			
			if( !play )
			{
				if( soundChannel != null )
				{
					if( fade )
					{
						SoundManager.fadeSound( soundChannel, "OUT", delay, 0 );
					}
					else
					{
						soundChannel.stop();
					}
					soundChannel = null;
				}
			}
			else
			{
				if( soundChannel == null )
				{
					soundChannel = SoundManager.playSound( sound, startTime, loops );
					
					if( soundChannel != null && fade )
					{
						SoundManager.fadeSound( soundChannel, "IN", delay, volume );
					}
				}
			}
			
			// Clear Context
			logger.popContext();			
			
			return soundChannel;
		}	
		
		/**
		 * Plays the provided sound class.
		 * 
		 * @param sound The sound or sound class to play.
		 * @param startTime How far into the sound to start playing.
		 * @param loop How many times to loop the sound.
		 * @return Returns a <code>SoundChannel</code>
		 * @see flash.media.SoundChannel
		 */
		public static function playSound( sound:*, startTime:Number, loops:int ):SoundChannel
		{
			// Log Activity
			logger.pushContext( "playSound", arguments );
			
			if( sound != null )
			{
				var snd:Sound = sound is Sound ? sound : new sound() as Sound;
				if( snd != null )
				{
					// Clear Context
					logger.popContext();
					
					return snd.play( startTime, loops );
				}
				else
				{
					logger.error( "'sound' could not be cast into Sound object." );
				}
			}
			else
			{
				logger.error( "'sound' is null." );
			}
			
			// Clear Context
			logger.popContext();
			
			return null;
		}
		
		/**
		 * Plays the provided sound class and allow you to adjust the sounds pitch on the fly.
		 * 
		 * @param sound The sound or sound class to play.
		 * @param startTime How far into the sound to start playing.
		 * @param loop How many times to loop the sound.
		 * @param pitchShiftFactor the factor to shift the pitch by
		 * @return Returns a <code>SoundPitchShift</code>
		 * @see components.SoundPitchShift
		 */		
		public static function playShiftPitchSound( sound:*, startTime:Number, loops:int, pitchShiftFactor:Number = 1.0 ):SoundPitchShift
		{
			// Log Activity
			logger.pushContext( "playShiftPitchSound", arguments );
			
			if( sound != null )
			{
				var snd:Sound = sound is Sound ? sound : new sound() as Sound;
				if( snd != null )
				{				
					var pitchShift:SoundPitchShift = new SoundPitchShift();
					pitchShift.play( snd, startTime, loops, pitchShiftFactor );
					
					// Clear Context
					logger.popContext();
					
					return pitchShift;
				}
				else
				{
					logger.error( "'sound' could not be cast into Sound object." );
				}				
			}
			else
			{
				logger.error( "'sound' is null." );
			}
			
			// Clear Context
			logger.popContext();			
			
			return null;			
		}
		
		/**
		 * Fades a provided <code>SoundChannel</code> in or out.
		 * 
		 * @param soundChannel The <code>SoundChannel</code> to fade.
		 * @param direction The direction to fade the sound, either "IN" or "OUT".
		 * @param delay How long to wait before fading the sound.
		 * @param soundVolume The volume to fade the sound to.
		 */		
		public static function fadeSound( soundChannel:SoundChannel, direction:String, delay:Number, soundVolume:Number = -1 ):void
		{
			// Log Activity
			logger.pushContext( "fadeSound", arguments );
			
			var vol:Number;
			var fadeListener:Function;
			
			if( direction.toUpperCase() == "IN" )
			{
				vol = MUTE_VOLUME;
				fadeListener = soundFadeIn;
			}
			else //( direction.toUpperCase() == "OUT" )
			{
				vol = soundChannel.soundTransform.volume;
				fadeListener = soundFadeOut;
			}
					
			var soundTransform:SoundTransform = new SoundTransform( vol );
			soundChannel.soundTransform = soundTransform;
			
			var soundTimer:SimpleDataTimer = new SimpleDataTimer( delay );
			soundTimer.data = { SoundChannel:soundChannel, SoundTransform:soundTransform, SoundVolume:soundVolume }; 
			soundTimer.addEventListener( TimerEvent.TIMER, fadeListener );
			soundTimer.start();
			
			// Clear Context
			logger.popContext();			
		}
		
		/** Handles the "Fade In" event of the sound */
		private static function soundFadeIn( event:TimerEvent ):void
		{			
			var sDataTimer:SimpleDataTimer = event.currentTarget as SimpleDataTimer;			
			var sChannel:SoundChannel = sDataTimer.data.SoundChannel as SoundChannel;
			var sTransform:SoundTransform = sDataTimer.data.SoundTransform as SoundTransform;
			var sVolume:Number = sDataTimer.data.SoundVolume as Number;
			
			if( (sTransform.volume + 0.1) < (sVolume * 0.01) )
			{
				sTransform.volume += 0.1;
				sChannel.soundTransform = sTransform;
			}
			else
			{
				sTransform.volume = sVolume * 0.01;
				sChannel.soundTransform = sTransform;
				
				sDataTimer.removeEventListener( TimerEvent.TIMER, soundFadeIn );
				sDataTimer.stop();
				sDataTimer = null;
			}
		}
		
		/** Handles the "Fade Out" event of the sound */
		private static function soundFadeOut( event:TimerEvent ):void
		{			
			var sDataTimer:SimpleDataTimer = event.currentTarget as SimpleDataTimer;			
			var sChannel:SoundChannel = sDataTimer.data.SoundChannel as SoundChannel;
			var sTransform:SoundTransform = sDataTimer.data.SoundTransform as SoundTransform;
			var sVolume:Number = sDataTimer.data.SoundVolume as Number;
			var stopSound:Boolean = sDataTimer.data.StopSound as Boolean;
			
			if( (sTransform.volume - 0.1) > ( sVolume * 0.01 ) )
			{
				sTransform.volume -= 0.1;
				sChannel.soundTransform = sTransform;
			}
			else
			{
				sTransform.volume = sVolume * 0.01;
				sChannel.soundTransform = sTransform;
				
				if( sChannel.soundTransform.volume <= 0 )
				{
					sChannel.stop();
				}
				
				sDataTimer.removeEventListener( TimerEvent.TIMER, soundFadeOut );
				sDataTimer.stop();
				sDataTimer = null;
			}
		}
		
		/**
		 * Adjusts the global volume of the application.
		 * @param vol The volume to set the global application to.
		 */
		public static function setVolume( vol:Number ):void
		{
			volume = vol;
			SoundMixer.soundTransform = new SoundTransform( 0.1 * ( volume / 10 ) );			
		}
		
		public function SoundManager()
		{
			volume = DEFAULT_VOLUME; // Default the volume
		}
	}
}