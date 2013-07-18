package components.QuadVideoSlots
{
	import assets.SkinManager;
	import assets.SoundManager;
	
	import components.QuadVideoSlots.PathFinderPath;
	
	import flash.display.DisplayObject;
	import flash.events.NetStatusEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.core.UIComponent;
	
	import utils.DebugHelper;
	import utils.MathHelper;

	public class MummysMoneyBonusGame extends PathFinderBonusGame
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( MummysMoneyBonusGame );	
		
		private var animationByteArray:ByteArray;
		private var animationClass:Class;
		
		private var connect_nc:NetConnection;
		private var stream_ns:NetStream;
		private var video:Video;
		private var videoContainer:UIComponent;
		
		private var ambienceSound:SoundChannel;
		
		public function MummysMoneyBonusGame()
		{
			// Log Activity
			logger.pushContext( "MummysMoneyBonusGame", arguments );
			
			super();
			
			// Create the screens and paths
			addScreen( "Overview_Map", true );
			addPath( 0, new PathFinderPath( "M 288 243 L 417 154" ) );
			
			addScreen( "Desert_Map" );			
			addPath( 1, 
				new PathFinderPath( "M 117 236 L 212 242 L 258 226 L 291 209 L 321 184 L 344 172" )
				.addChild( new PathFinderPath( "M 344 172 L 383 154 L 429 146 L 458 147 L 499 146" )
					.addChild( new PathFinderPath( "M 499 146 L 525 127 L 534 94 L 524 73 L 504 58 L 486 50 L 458 50 L 425 61" ) )
					.addChild( new PathFinderPath( "M 499 146 L 538 164 L 584 167 L 627 155 L 651 138 L 667 108 L 667 91 L 649 70 L 626 57" ) )
				)
				.addChild( new PathFinderPath( "M 344 172 L 387 174 L 416 189 L 439 213 L 462 228 L 477 228 L 506 222 L 543 211" ) 
					.addChild( new PathFinderPath( "M 543 211 L 585 209 L 641 211 L 667 204 L 691 190 L 712 159" ) )
					.addChild( new PathFinderPath( "M 543 211 L 580 220 L 609 228 L 644 239 L 656 250 L 678 265" ) )
				)
			)
			.addPath( 1,
				new PathFinderPath( "M 117 236 L 211 241 L 251 250 L 286 262 L 313 274" )
				.addChild( new PathFinderPath( "M 313 274 L 340 250 L 357 247 L 371 248 L 385 266 L 411 286 L 441 289 L 493 288" )
					.addChild( new PathFinderPath( "M 493 288 L 542 289 L 586 297 L 611 307 L 651 327 L 683 354" ) )
					.addChild( new PathFinderPath( "M 493 288 L 503 312 L 519 339 L 528 358 L 551 371 L 575 384 L 613 400" ) )
				)
				.addChild( new PathFinderPath( "M 313 274 L 339 312 L 369 330" )
					.addChild( new PathFinderPath( "M 369 330 L 380 336 L 401 349 L 412 365 L 430 385 L 448 396 L 476 402" ) )
					.addChild( new PathFinderPath( "M 369 330 L 360 376 L 336 399 L 314 406 L 299 404 L 274 392 L 253 381" ) )							
				)
			);
			
			addScreen( "Overview_Map", true );
			addPath( 2, new PathFinderPath( "M 417 154 L 584 240" ) );
			
			addScreen( "Nile_Map" );
			addPath( 3, 
				new PathFinderPath( "M 121 230 L 202 234 L 232 236 L 281 218 L 311 203 L 352 163" )
				.addChild( new PathFinderPath( "M 352 163 L 432 141 L 482 137 L 533 131" )
					.addChild( new PathFinderPath( "M 533 131 L 569 110 L 587 85 L 641 72" ) )
					.addChild( new PathFinderPath( "M 533 131 L 565 151 L 613 151 L 658 148 L 709 132" ) )
				)
				.addChild( new PathFinderPath( "M 352 163 L 412 166 L 446 189 L 488 220 L 518 217 L 563 205" )
					.addChild( new PathFinderPath( "M 563 205 L 627 195 L 668 198 L 711 215" ) )
					.addChild( new PathFinderPath( "M 563 205 L 601 221 L 625 241 L 660 251" ) )
				)
			)
			.addPath( 3,
				new PathFinderPath( "M 121 230 L 202 234 L 232 234 L 285 245 L 326 265 L 361 298" )
				.addChild( new PathFinderPath( "M 361 298 L 410 305 L 444 298 L 479 276 L 517 271 L 548 278 L 577 292" )
					.addChild( new PathFinderPath( "M 577 292 L 630 286 L 668 296 L 705 316" ) )
					.addChild( new PathFinderPath( "M 577 292 L 584 318 L 597 342 L 618 354 L 651 359" ) )
				)
				.addChild( new PathFinderPath( "M 361 298 L 404 327 L 461 334 L 508 338 L 532 352" )
					.addChild( new PathFinderPath( "M 532 352 L 570 375 L 606 406 L 681 426" ) )
					.addChild( new PathFinderPath( "M 532 352 L 522 398 L 491 417 L 449 421 L 399 400 L 331 345 L 305 327 L 266 319 L 214 317" ) )							
				)
			);
			
			addScreen( "Overview_Map", true );
			addPath( 4, new PathFinderPath( "M 584 240 L 409 289" ) );
			
			addScreen( "Pyramid_Map" );
			addPath( 5, 
				new PathFinderPath( "M 141 210 L 239 214 L 294 194 L 332 167 L 381 132" )
				.addChild( new PathFinderPath( "M 381 132 L 431 119 L 469 115 L 531 112" )
					.addChild( new PathFinderPath( "M 531 112 L 582 101 L 605 84 L 609 55 L 581 46 L 523 37 L 471 38 L 416 56" ) )
					.addChild( new PathFinderPath( "M 531 112 L 586 124 L 625 124 L 672 110 L 704 89" ) )
				)
				.addChild( new PathFinderPath( "M 381 132 L 422 144 L 451 163 L 484 194 L 516 198 L 564 184" )
					.addChild( new PathFinderPath( "M 564 184 L 609 164 L 633 160 L 666 161" ) )
					.addChild( new PathFinderPath( "M 564 184 L 600 199 L 619 216 L 650 228 L 675 226 L 716 216" ) )
				)
			)
			.addPath( 5,
				new PathFinderPath( "M 141 210 L 239 214 L 279 222 L 309 226 L 342 249" )
				.addChild( new PathFinderPath( "M 342 249 L 383 216 L 396 217 L 417 234 L 442 251 L 478 252 L 507 245 L 550 262" )
					.addChild( new PathFinderPath( "M 550 262 L 620 255 L 664 259 L 698 274 L 720 307" ) )
					.addChild( new PathFinderPath( "M 550 262 L 582 308 L 612 327 L 640 331" ) )
				)
				.addChild( new PathFinderPath( "M 342 249 L 381 292 L 428 310 L 474 317" )
					.addChild( new PathFinderPath( "M 474 317 L 528 322 L 553 347 L 580 391 L 586 401" ) )
					.addChild( new PathFinderPath( "M 474 317 L 487 354 L 478 377 L 458 394 L 419 402" ) )							
				)
			);
			
			addScreen( "Overview_Map", true );
			addPath( 6, new PathFinderPath( "M 409 289 L 571 354" ) );
			
			addScreen( "Tomb_Map" );
			addPath( 7, 
				new PathFinderPath( "M 115 237 L 205 240 L 238 230 L 279 211 L 313 185 L 337 167" )
				.addChild( new PathFinderPath( "M 337 167 L 391 149 L 440 144 L 473 143 L 522 132" )
					.addChild( new PathFinderPath( "M 522 132 L 529 98 L 519 70 L 490 52 L 462 48 L 416 63" ) )
					.addChild( new PathFinderPath( "M 522 132 L 559 130 L 594 117 L 622 103 L 651 94 L 675 92 L 693 94 L 711 104" ) )
				)
				.addChild( new PathFinderPath( "M 337 167 L 375 169 L 403 180 L 428 204 L 446 221 L 476 224 L 502 216 L 529 212" )
					.addChild( new PathFinderPath( "M 529 212 L 556 193 L 609 185 L 635 184" ) )
					.addChild( new PathFinderPath( "M 529 212 L 552 222 L 575 237 L 600 251 L 635 250 L 656 247 L 692 244" ) )
				)
			)
			.addPath( 7,
				new PathFinderPath( "M 115 237 L 201 239 L 261 250 L 308 275" )
				.addChild( new PathFinderPath( "M 308 275 L 340 247 L 376 239 L 413 245 L 441 269 L 470 295 L 505 297 L 541 296" )
					.addChild( new PathFinderPath( "M 541 296 L 575 295 L 605 295 L 627 299 L 642 305 L 660 316 L 679 334 L 695 367" ) )
					.addChild( new PathFinderPath( "M 541 296 L 564 313 L 573 325 L 579 345 L 584 361 L 583 388" ) )
				)
				.addChild( new PathFinderPath( "M 308 275 L 320 293 L 339 302 L 358 312 L 396 321" )
					.addChild( new PathFinderPath( "M 396 321 L 435 334 L 448 343 L 463 360 L 468 397" ) )
					.addChild( new PathFinderPath( "M 396 321 L 405 349 L 408 368 L 400 384 L 383 394 L 353 394 L 309 382" ) )							
				)
			);
			
			// Clear Context
			logger.popContext();			
		}
				
		override public function setParameters( betAmount:int, bonusWin:int, winAmount:int, startingAmount:int = 0 ):void
		{
			// Log Activity
			logger.pushContext( "setParameters", arguments );
			
			// Call super method
			super.setParameters( betAmount, bonusWin, winAmount, startingAmount );
			
			var screenTargets:Array = [0, 5000, 10000, 20000];
			var screenTarget:int = screenTargets.filter( function( target:int, index:int, arr:Array ):Boolean {
				return ( betAmount * bonusWin ) >= target && ( index == arr.length - 1 || ( betAmount * bonusWin ) < arr[index + 1] );
			})[0];
			var screenCount:int = screenTargets.indexOf( screenTarget ) + 1;
			var minSteps:int = screenCount * 3 - 2;
			var maxSteps:int = screenCount * 3;
			
			calculateRevealWinnings( minSteps, maxSteps, true, MathHelper.ROUTE_TYPE_PLUS_ONLY_HIGH_YIELD );
			
			// Clear Context
			logger.popContext();			
		}	
		
		override public function resetAndPlay():void
		{
			// Log Activity
			logger.pushContext( "resetAndPlay", arguments );	
			
			// Call the super
			super.resetAndPlay();
			
			// Calculate the winnings and play the intro
			playIntro();
			
			// Clear Context
			logger.popContext();			
		}
		
		// Handles playing the intro
		private function playIntro():void
		{				
			// Log Activity
			logger.pushContext( "playIntro", arguments );
			
			// Load the animation class
			animationClass = SkinManager.getSkinAsset( styleManager, "BonusGameIntro_Animation" );					
			animationByteArray = new animationClass();
			
			// Initialize the net connection
			connect_nc = new NetConnection();
			connect_nc.connect( null );
			
			// Initialize the net stream
			stream_ns = new NetStream( connect_nc );
			stream_ns.client = this;
			stream_ns.client = { onMetaData:function( obj:Object ):void{} }
			stream_ns.addEventListener( NetStatusEvent.NET_STATUS, introNetStatusHandler );
			stream_ns.play( null );
			stream_ns.appendBytes( animationByteArray );
			
			// Initialize the animation
			video = new Video( 800, 560 );
			video.attachNetStream( stream_ns );
			
			// Add the animation to the stage
			videoContainer = new UIComponent();
			videoContainer.addChild( DisplayObject( video ) );
			addElement( videoContainer );
			
			// Clear Context
			logger.popContext();			
		}
		
		// Handles the 'Net Status' event of the Net Stream
		protected function introNetStatusHandler( event:NetStatusEvent ):void
		{
			// Log Activity
			logger.pushContext( "introNetStatusHandler", arguments.concat( event.info.code ) );
			
			if( event.info.code == "NetStream.Play.Stop" || event.info.code == "NetStream.Buffer.Empty" )
			{									
				stopIntro();
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		// Removes all the event listeners and elements from the container and dispatches a stop event
		public function stopIntro():void
		{
			// Log Activity
			logger.pushContext( "stopIntro", arguments );
			
			if( stream_ns != null )
			{
				stream_ns.removeEventListener( NetStatusEvent.NET_STATUS, introNetStatusHandler );
				stream_ns.close();
				stream_ns = null;
			}
			
			if( connect_nc != null )
			{
				connect_nc.close();
				connect_nc = null;
			}
						
			if( videoContainer != null )
			{
				videoContainer.removeChild( video );
				removeElement( videoContainer);
				videoContainer = null;
				video = null;
			}
			
			// Play the bonus audio
			ambienceSound = SoundManager.playSound( SkinManager.getSkinAsset( styleManager, "Background_Audio" ), 50, int.MAX_VALUE );
			if( ambienceSound != null )
			{
				var soundTransform:SoundTransform = new SoundTransform( 0.25 );
				ambienceSound.soundTransform = soundTransform;
			}
			
			// Start the bonus game			
			startPathFinder();
			
			// Clear Context
			logger.popContext();			
		}
		
		override protected function playExit( winAmount:int, isCurrency:Boolean = true, didWin:Boolean = false ):void
		{
			// Log Activity
			logger.pushContext( "playExit", arguments );;
			
			// Call the super method
			super.playExit( winAmount, isCurrency, didWin );
			
			// Stop the ambience sound
			if( ambienceSound != null )
			{
				ambienceSound.stop();
				ambienceSound = null;
			}
			
			// Load the animation class
			animationClass = SkinManager.getSkinAsset( styleManager, didWin ? "BonusGameWon_Animation" : "BonusGameExit_Animation" );					
			animationByteArray = new animationClass();
			
			// Initialize the net connection
			connect_nc = new NetConnection();
			connect_nc.connect( null );
			
			// Initialize the net stream
			stream_ns = new NetStream( connect_nc );
			stream_ns.client = this;
			stream_ns.client = { onMetaData:function( obj:Object ):void{} }
			stream_ns.addEventListener( NetStatusEvent.NET_STATUS, exitNetStatusHandler );
			stream_ns.play( null );
			stream_ns.appendBytes( animationByteArray );
			
			// Initialize the animation
			video = new Video( 800, 560 );
			video.attachNetStream( stream_ns );		
			
			videoContainer = new UIComponent();
			videoContainer.addChild( DisplayObject( video ) );
			addElement( videoContainer );
			
			// Set the exit win amount
			ddWinAmountExit.displayAmount = winAmount;
			ddWinAmountExit.isCurrency = isCurrency;	
			ddWinAmountExit.visible = false;
			setTimeout( function():void{ ddWinAmountExit.visible = true; }, 1500 );
			
			// Clear Context
			logger.popContext();			
		}
		
		// Handles the 'Net Status' event of the Net Stream
		protected function exitNetStatusHandler( event:NetStatusEvent ):void
		{
			// Log Activity
			logger.pushContext( "exitNetStatusHandler", arguments.concat( event.info.code ) );
			
			if( event.info.code == "NetStream.Play.Stop" || event.info.code == "NetStream.Buffer.Empty" )
			{
				stopExit();
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		// Removes all the event listeners and elements from the container and dispatches a stop event
		public function stopExit():void
		{
			// Log Activity
			logger.pushContext( "stopExit", arguments );
			
			if( stream_ns != null )
			{
				stream_ns.removeEventListener( NetStatusEvent.NET_STATUS, exitNetStatusHandler );
				stream_ns.close();
				stream_ns = null;
			}
			
			if( connect_nc != null )
			{
				connect_nc.close();
				connect_nc = null;
			}
			
			if( videoContainer != null )
			{
				videoContainer.removeChild( video );
				removeElement( videoContainer);
				videoContainer = null;
				video = null;
			}
			
			// Call the game finished event
			GameFinished();
			
			// Clear Context
			logger.popContext();			
		}
	}
}