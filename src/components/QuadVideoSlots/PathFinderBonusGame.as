package components.QuadVideoSlots
{
	import assets.AnimationManager;
	import assets.Images;
	import assets.SkinManager;
	
	import components.Actor;
	import components.BonusGameIconIMG;
	import components.DigitDisplay;
	
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import interfaces.IDebuggable;
	import interfaces.IDisposable;
	
	import mx.controls.Image;
	import mx.events.EffectEvent;
	import mx.graphics.SolidColorStroke;
	import mx.states.SetProperty;
	import mx.states.State;
	import mx.states.Transition;
	
	import objects.Route;
	
	import spark.components.Group;
	import spark.effects.Animate;
	import spark.effects.AnimateTransitionShader;
	import spark.effects.animation.Keyframe;
	import spark.effects.animation.MotionPath;
	import spark.primitives.Path;
	
	import utils.DebugHelper;
	import utils.MathHelper;
	
	public class PathFinderBonusGame extends Group implements IDisposable, IDebuggable
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( PathFinderBonusGame );	
		
		protected var gameCompleted:Boolean;
		protected var revealInProgress:Boolean = false;
		protected var betAmount:int;
		protected var bonusWin:int;
		protected var winAmount:int;
		protected var startingAmount:int;
		protected var revealWinnings:Vector.<Route>		
		protected var _onStop:Function;		
		
		protected var screens:Array = [];
		protected var paths:Array = [];
		protected var curScreenIndex:int = 0;
		protected var lastPathTaken:PathFinderPath;
		protected var lastActionTaken:String;
		
		protected var imgBackground:Image;         // The themed background image
		protected var imgPathsAll:Image;           // All possible paths
		protected var imgPathChoices:Image;        // Current path choices
		protected var imgPathsTaken:Image;         // Previous path choices
		protected var imgSceneIcon:Image;          // The themed starting icon
		protected var imgBonusWin:Image;           // Current bonus winnings background
		protected var grpPathChoices:Group;        // Mask for current path choices
		protected var grpPathsTaken:Group;         // Mask for previous path choices
		protected var grpWalkedPaths:Group;        // Group for displaying red "walked" line
		protected var grpIcons:Group;              // Group for path choice icons
		protected var actAvatar:Actor;             // Our avatar
		protected var actWammy:Actor;              // Our wammy
		protected var ddBonusWin:DigitDisplay;     // Current bonus winnings display
		protected var ddWinAmountExit:DigitDisplay // Ending bonus winnings display
				
		protected var pathChoice1:Path;
		protected var pathChoice2:Path;
		protected var pathChoiceTimer:Timer;
		protected var walkPath:Path;
		protected var walkPathPoints:Vector.<Point>;
		protected var transition:Transition;
		protected var transitionAnimation:AnimateTransitionShader;
				
		public function set onStop( value:Function ):void
		{
			_onStop = value;
		}		
		
		public function PathFinderBonusGame()
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );
			
			// Create our background image
			imgBackground = new Image();
			imgBackground.width = 800;
			imgBackground.height = 560;
			imgBackground.x = 0;
			imgBackground.y = 0;			
			addElement( imgBackground );
			
			// Create our bonus win image and digit dosplay
			imgBonusWin = new Image();
			imgBonusWin.x = 25;
			imgBonusWin.y = 25;
			imgBonusWin.source = SkinManager.getSkinAsset( styleManager, "BonusWin" );
			addElement( imgBonusWin );
			
			ddBonusWin = new DigitDisplay();
			ddBonusWin.width = 51;
			ddBonusWin.height = 16;
			ddBonusWin.x = 75;
			ddBonusWin.y = 148;
			ddBonusWin.setStyle( "fontSize", 18 );
			ddBonusWin.displayAmount = 0;
			addElement( ddBonusWin );
			
			// TODO: Move some of this stuff into the subclasses
			ddWinAmountExit = new DigitDisplay();
			ddWinAmountExit.depth = 999			
			ddWinAmountExit.width = 260;
			ddWinAmountExit.height = 73;
			ddWinAmountExit.x = 271;
			ddWinAmountExit.y = 191;
			ddWinAmountExit.setStyle( "color", 0xFFFFFF );
			ddWinAmountExit.setStyle( "fontSize", 90 );
			ddWinAmountExit.displayAmount = 0;
			ddWinAmountExit.visible = false;;
			addElement( ddWinAmountExit );			
			
			// Create the image for our possible paths
			imgPathsAll = new Image();
			imgPathsAll.alpha = 0.5;
			imgPathsAll.width = 800;
			imgPathsAll.height = 560;
			imgPathsAll.x = 0;
			imgPathsAll.y = 0;
			addElement( imgPathsAll );
			
			// Create the mask and mask for our path choices
			imgPathChoices = new Image();
			imgPathChoices.width = 800;
			imgPathChoices.height = 560;
			imgPathChoices.x = 0;
			imgPathChoices.y = 0;
			addElement( imgPathChoices );
			
			grpPathChoices = new Group();
			grpPathChoices.width = 800;
			grpPathChoices.height = 560;
			grpPathChoices.x = 0;
			grpPathChoices.y = 0;			
			addElement( grpPathChoices );
			imgPathChoices.mask = grpPathChoices;			
						
			// Create the image and mask for our chosen paths
			imgPathsTaken = new Image();
			imgPathsTaken.width = 800;
			imgPathsTaken.height = 560;
			imgPathsTaken.x = 0;
			imgPathsTaken.y = 0;
			addElement( imgPathsTaken );
			
			grpPathsTaken = new Group();
			grpPathsTaken.width = 800;
			grpPathsTaken.height = 560;
			grpPathsTaken.x = 0;
			grpPathsTaken.y = 0;			
			addElement( grpPathsTaken );
			imgPathsTaken.mask = grpPathsTaken;
			
			// Create the starting scene icon
			imgSceneIcon = new Image();
			imgSceneIcon.width = 200;
			imgSceneIcon.height = 120;
			addElement( imgSceneIcon );
			
			// Create the group for our red "walked" paths line
			grpWalkedPaths = new Group();
			grpWalkedPaths.width = 800;
			grpWalkedPaths.height = 560;
			grpWalkedPaths.x = 0;
			grpWalkedPaths.y = 0;			
			addElement( grpWalkedPaths );
			
			// Create the group for our choice icons and set it's depth higher than anything else so we can click on them
			grpIcons = new Group();
			grpIcons.depth = 100;
			grpIcons.width = 800;
			grpIcons.height = 560;
			grpIcons.x = 0;
			grpIcons.y = 0;			
			addElement( grpIcons );
			
			// Create the avatar actor
			actAvatar = new Actor( 200, 200 );
			actAvatar.id = "actAvatar";
			actAvatar.onAnimationFinished = onActorAnimationFinished;
			actAvatar.addStaticImage( SkinManager.getSkinAsset( styleManager, "BonusCharacter_Static" ) );
			actAvatar.addAnimation( "walk", SkinManager.getSkinAsset( styleManager, "BonusCharacter_Walk" ) );
			actAvatar.addAnimation( "run", SkinManager.getSkinAsset( styleManager, "BonusCharacter_Run" ) );
			actAvatar.addAnimation( "search1", SkinManager.getSkinAsset( styleManager, "BonusCharacter_Search1" ) );
			actAvatar.addAnimation( "search2", SkinManager.getSkinAsset( styleManager, "BonusCharacter_Search2" ) );
			actAvatar.addAnimation( "search3", SkinManager.getSkinAsset( styleManager, "BonusCharacter_Search3" ) );
			actAvatar.addAnimation( "find1", SkinManager.getSkinAsset( styleManager, "BonusCharacter_Find1" ) );
			actAvatar.addAnimation( "find2", SkinManager.getSkinAsset( styleManager, "BonusCharacter_Find2" ) );
			actAvatar.addAnimation( "find3", SkinManager.getSkinAsset( styleManager, "BonusCharacter_Find3" ) );
			addElement( actAvatar );
			
			// Create the wammy actor
			actWammy = new Actor( 150, 150 );
			actWammy.id = "actWammy";
			actWammy.visible = false;
			actWammy.onAnimationFinished = onActorAnimationFinished;
			actWammy.addAnimation( "scene1", SkinManager.getSkinAsset( styleManager, "BonusWammy_1" ) );
			actWammy.addAnimation( "scene2", SkinManager.getSkinAsset( styleManager, "BonusWammy_2" ) );
			actWammy.addAnimation( "scene3", SkinManager.getSkinAsset( styleManager, "BonusWammy_3" ) );
			actWammy.addAnimation( "scene4", SkinManager.getSkinAsset( styleManager, "BonusWammy_4" ) );
			addElement( actWammy );
			
			// Create the state transition animation
			transitionAnimation = new AnimateTransitionShader( this );
			transitionAnimation.shaderByteCode = assets.Images.HexShaderByteCode;
			transitionAnimation.duration = 2000;			
			transition = new Transition();
			transition.effect = transitionAnimation;
			this.transitions = [transition];
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Called when an actor has finished its animation.
		 * 
		 * @param The actor calling this callback.
		 * @param The name of the animation that was just finished.
		 */
		protected function onActorAnimationFinished( actor:Actor, lastPlayed:String ):void
		{
			// Log Activity
			logger.pushContext( "onActorAnimationFinished", arguments );
			
			if( actor == actAvatar )
			{
				switch( lastPlayed )
				{
					case "run":
						actAvatar.visible = false;
						break;
					
					case "walk":
						if( screens[curScreenIndex].isOverview )
						{
							loadNextPaths();
						}
						else
						{
							actAvatar.playAnimation( lastActionTaken, 2 );
						}
						break;
					
					case "search1":
					case "search2":
					case "search3":
						if( revealWinnings.length == 0 )
						{
							wammyAttack();
						}
						else
						{
							var route:Route = revealWinnings.shift();							
							var bonusIcon:BonusGameIconIMG = new BonusGameIconIMG( SkinManager.getSkinAsset( styleManager, "BonusIcon_" + MathHelper.randomNumber( 1, 15 ) ),  "bradyBunch", 36 );
							bonusIcon.x = actor.x + actor.width / 2;
							bonusIcon.y = actor.y + actor.height / 2;
							bonusIcon.onReveal = function( bonusIcon:BonusGameIconIMG, winAmount:int ):void {
								ddBonusWin.displayAmount = route.TotalEndValue;
								actAvatar.playAnimation( "find" + MathHelper.randomNumber( 1, 3 ), 1 );								
							};
							
							grpIcons.addElement( bonusIcon );
							bonusIcon.revealWin( route.Func, route.Display, route.BaseEndValue );
						}
						break;
					
					case "find1":
					case "find2":
					case "find3":
						loadNextPaths();
						break;
				}
			}
			else if( actor == actWammy )
			{
				actAvatar.stop();
				playExit( ddBonusWin.displayAmount, ddBonusWin.isCurrency, curScreenIndex == screens.length - 1 );
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		// Causes the wammy to become visible and go after the player
		protected function wammyAttack():void
		{
			actWammy.visible = true;
			actWammy.x = actAvatar.x + 150;
			actWammy.y = actAvatar.y;
			actWammy.playAnimation( "scene" + ( Math.ceil( curScreenIndex / 2 ) ).toString(), 1 );
			
			var ani:Animate = assets.AnimationManager.getMoveAnimation( actWammy, actWammy.x, actWammy.y, actAvatar.x, actAvatar.y, 3000, 0, 1, 0 );
			ani.addEventListener( EffectEvent.EFFECT_END, function aniEffectEnd( event:EffectEvent ):void {
				ani.removeEventListener( EffectEvent.EFFECT_END, aniEffectEnd );
				actWammy.visible = false;
				actWammy.stop();
			});
			ani.play();
			
			actAvatar.flip( -1 );
			lastPathTaken = new PathFinderPath( "M " + ( actAvatar.x + actAvatar.width / 2 ) + " " + ( actAvatar.y + actAvatar.height / 2 ) + " L 0 " + ( actAvatar.y + actAvatar.height / 2 ) );
			walkThePath( 1500 * ( ( ( actAvatar.x + actAvatar.width / 2 ) - 0 ) / 800 ) );
		}
		
		public function addScreen( screenImage:String, isOverview:Boolean = false ):int
		{
			// Log Activity
			logger.pushContext( "addScreen", arguments );
						
			// Create a screen and state object
			var screen:Object = { screenImage:screenImage, pathImage:screenImage + "_Paths", screenIcon:screenImage + "_Icon", isOverview:isOverview };			
			var state:State =  new State( { name: "state" + ( paths.length ), overrides: [] } );
			
			// Push a new overrdie for this state to change the background image
			state.overrides.push( new mx.states.SetProperty( imgBackground, "source", SkinManager.getSkinAsset( styleManager, screenImage ) ) );
			
			// Push new overrides to hide some components for our overview screen or show them on non-overview screens
			if( isOverview )
			{
				state.overrides.push( new mx.states.SetProperty( imgPathsAll, "visible", false ) );
				state.overrides.push( new mx.states.SetProperty( imgPathChoices, "visible", false ) );
				state.overrides.push( new mx.states.SetProperty( imgPathsTaken, "visible", false ) );
				state.overrides.push( new mx.states.SetProperty( imgSceneIcon, "visible", false ) );
			}
			else
			{
				state.overrides.push( new mx.states.SetProperty( imgPathsAll, "visible", true ) );
				state.overrides.push( new mx.states.SetProperty( imgPathsAll, "source", SkinManager.getSkinAsset( styleManager, screen.pathImage )) );
				state.overrides.push( new mx.states.SetProperty( imgPathChoices, "visible", true ) );
				state.overrides.push( new mx.states.SetProperty( imgPathChoices, "source", SkinManager.getSkinAsset( styleManager, screen.pathImage )) );				
				state.overrides.push( new mx.states.SetProperty( imgPathsTaken, "visible", true ) );
				state.overrides.push( new mx.states.SetProperty( imgPathsTaken, "source", SkinManager.getSkinAsset( styleManager, screen.pathImage )) );
				state.overrides.push( new mx.states.SetProperty( imgSceneIcon, "visible", true ) );
				state.overrides.push( new mx.states.SetProperty( imgSceneIcon, "source", SkinManager.getSkinAsset( styleManager, screen.screenIcon )) );
			}			
			
			// Add our screen, paths and state
			screens.push( screen );
			paths.push([]);			
			states.push( state );
			
			// Clear Context
			logger.popContext();			
			
			return screens.length - 1;
		}
		
		public function addPath( screenIndex:int, path:PathFinderPath ):PathFinderBonusGame
		{
			// Log Activity
			logger.pushContext( "addPath", arguments );
						
			paths[screenIndex].push( path );
			State(states[screenIndex]).overrides.push( new mx.states.SetProperty( actAvatar, "x", path.getPathPoints()[0].x - ( actAvatar.width * 0.5 ) ) );
			State(states[screenIndex]).overrides.push( new mx.states.SetProperty( actAvatar, "y", path.getPathPoints()[0].y - ( actAvatar.height * 0.5 ) ) );
			
			State(states[screenIndex]).overrides.push( new mx.states.SetProperty( imgSceneIcon, "x", path.getPathPoints()[0].x - ( imgSceneIcon.width * 0.5 ) ) );
			State(states[screenIndex]).overrides.push( new mx.states.SetProperty( imgSceneIcon, "y", path.getPathPoints()[0].y - ( imgSceneIcon.height * 0.5 ) ) );
			
			// Clear Context
			logger.popContext();
			
			return this;
		}
		
		protected function loadNextScreen():void
		{
			// Log Activity
			logger.pushContext( "loadNextScreen", arguments );
						
			if( curScreenIndex < screens.length )
			{
				clearPaths( true, true, true );
				this.setCurrentState( "state" + curScreenIndex, curScreenIndex != 0 );				
				
				var scr:Object = screens[curScreenIndex];
				if( scr.isOverview )
				{
					lastPathTaken = paths[curScreenIndex][0];
					flash.utils.setTimeout( walkThePath, 2000 );
				}
				else
				{
					loadNextPaths();
				}
			}
			else
			{
				// We have no more screens, thus we won!
				playExit( ddBonusWin.displayAmount, ddBonusWin.isCurrency, true );				
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		protected function loadNextPaths():void
		{			
			// Log Activity
			logger.pushContext( "loadNextPaths", arguments );
						
			var nextPaths:Array = lastPathTaken == null ? paths[curScreenIndex] : lastPathTaken.children;
			clearPaths( true, false, false );
			
			// TODO: Remove this after debugging
			if( nextPaths == null || nextPaths.length == 0 )
			{
				lastPathTaken = null;
				curScreenIndex++
				loadNextScreen();
				
				// Clear Context
				logger.popContext();				
				return;
			}
			
			for( var i:int = 0; i < nextPaths.length; i++ )
			{				
				// Create the path choice
				var walkPath:Path = new Path();
				walkPath.alpha = 1;
				walkPath.stroke = new SolidColorStroke( 0xFFFFFF, 16, 1, true, "normal", flash.display.CapsStyle.NONE, flash.display.JointStyle.MITER  );				
				walkPath.data = constructPath( nextPaths[i].getPathPoints() );
				walkPath.x = 0;
				walkPath.y = 0;
				
				if(i == 0)
				{
					pathChoice1 = walkPath;
				}
				else
				{
					pathChoice2 = walkPath;
				}
				
				// Create the search choices
				var pt:Point = nextPaths[i].getLastPoint();
				var img:Image = new Image();
				img.id = "BonusChoice_" + MathHelper.randomNumber(1, 3);
				img.source = SkinManager.getSkinAsset( styleManager, img.id );
				img.x = pt.x - 25;
				img.y = pt.y - 25;
				img.alpha = 0;
				img.buttonMode = true;
				img.addEventListener( MouseEvent.MOUSE_OVER, onChoiceOver );
				img.addEventListener( MouseEvent.MOUSE_OUT, onChoiceOut );
				img.addEventListener( MouseEvent.CLICK, onChoiceClick );
				
				grpIcons.addElement( img );
			}
			
			// Start the timer
			pathChoiceTimer = new Timer( 1000, 0 );
			pathChoiceTimer.addEventListener( TimerEvent.TIMER, pathChoiceTimer_TIMER );			
			pathChoiceTimer.reset();
			pathChoiceTimer.start();
			
			// Clear Context
			logger.popContext();			
		}		
		
		/**
		 * Constructs a data string suitable for a PATH object, from a vector of POINTS
		 */
		protected function constructPath( pathPoints:Vector.<Point>, isDashed:Boolean = false ):String
		{
			var ds:String = "M " + pathPoints[0].x + " " + pathPoints[0].y;
			for( var i:int = 0; i < pathPoints.length; i +=  isDashed ? 4 : 1 )
			{
				ds += ( i % 8 == 0 && isDashed ? " Z M " : " L " ) + pathPoints[i].x + " " + pathPoints[i].y;
			}
			
			return ds;
		}		
		
		/**
		 * Constructs an animation for our avatar to follow based on a PATH object.
		 */
		protected function walkThePath( speed:int = 3000 ):void
		{
			// Log Activity
			logger.pushContext( "walkThePath", arguments );
						
			var path:PathFinderPath = lastPathTaken;
			var pathPoints:Vector.<Point> = path.getPathPoints();
			
			var ani:Animate = new Animate();
			var motPaths:Vector.<MotionPath> = new Vector.<MotionPath>();
			var motPathX:MotionPath = new MotionPath("x");
			var motPathY:MotionPath = new MotionPath("y");
			var timeScale:Number = 0;
			var totalDistance:Number = 0;
			var i:int;
			
			// Calculat the total distance we need to walk along this path
			for( i = 1; i < pathPoints.length; i++ )
			{
				totalDistance += MathHelper.getDistance( pathPoints[i], pathPoints[i-1] );
			}
			
			// For each section of the path, calculate how long we should take to walk it based on the length of the path, total distance and time
			for( i = 0; i < pathPoints.length; i++ )
			{
				if( i == 0 )
				{
					motPathX.keyframes = new Vector.<Keyframe>();
					motPathY.keyframes = new Vector.<Keyframe>();
				}
				
				timeScale += ( i == 0 ? 0 : speed * ( totalDistance / 200 ) * ( MathHelper.getDistance( pathPoints[i], pathPoints[i-1] ) / totalDistance ) );
				
				motPathX.keyframes.push( new Keyframe( timeScale, pathPoints[i].x - ( actAvatar.width * 0.5 )  ) );
				motPathY.keyframes.push( new Keyframe( timeScale, pathPoints[i].y - ( actAvatar.height * 0.5 ) ) );
			}
			
			// Create the animation's motion paths and add event listeners
			motPaths.push( motPathX );
			motPaths.push( motPathY );
			ani.motionPaths = motPaths;
			ani.addEventListener( EffectEvent.EFFECT_START, walkPathStarted );
			ani.addEventListener( EffectEvent.EFFECT_UPDATE, walkPathUpdated );
			ani.addEventListener( EffectEvent.EFFECT_END, walkPathEnded );
			
			// Play the animatiom and play our avatar's walk cycle
			ani.play( [actAvatar] );
			actAvatar.playAnimation( speed < 3000 ? "run" : "walk", 0 );
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Handles the 'START' event of the walking animation
		 */
		protected function walkPathStarted( event:EffectEvent ):void
		{
			// Log Activity
			logger.pushContext( "walkPathStarted", arguments );
			
			walkPath = new Path();
			walkPathPoints = new <Point>[ new Point( actAvatar.x + ( actAvatar.width * 0.5 ), actAvatar.y + ( actAvatar.height * 0.5 ) ) ];
			
			walkPath.alpha = 1;
			walkPath.stroke = new SolidColorStroke( 0xFF0000, 8, 1, true, "normal", flash.display.CapsStyle.NONE, flash.display.JointStyle.MITER  );
			grpWalkedPaths.addElement( walkPath );
			
			walkPath.data = constructPath( walkPathPoints, true );
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Handles the 'UPDATE' event of the walking animation
		 */ 
		protected function walkPathUpdated( event:EffectEvent ):void
		{
			// Every time our avatar's position is updated from the walking animation, recreate the walkPath data
			walkPathPoints.push( new Point( actAvatar.x + ( actAvatar.width * 0.5 ), actAvatar.y + ( actAvatar.height * 0.5 ) ) );
			walkPath.data = constructPath( walkPathPoints, true );
			
			// Make sure we're facing the right direction
			var pathLen:int = walkPathPoints.length;
			if( pathLen > 1 )
			{
				if( walkPathPoints[pathLen - 1].x >= walkPathPoints[pathLen - 2].x )
				{
					if( actAvatar.direction != 1 ){ actAvatar.flip( 1 ); }
				}
				else
				{
					if( actAvatar.direction != -1 ){ actAvatar.flip( -1 ); }
				}
			}
		}
		
		/**
		 * Handles the 'ENDED' event of the walking animation
		 */
		protected function walkPathEnded( event:EffectEvent ):void
		{
			// Log Activity
			logger.pushContext( "walkPathEnded", arguments );
						
			var ani:Animate = event.target as Animate;
			if( ani )
			{
				ani.removeEventListener( EffectEvent.EFFECT_END, walkPathEnded );
				ani = null;
			}
			
			actAvatar.flip( 1 );
			actAvatar.stop();
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Clears any existing paths.
		 * 
		 * @param icons <code>true</code> to clear the choice icons.
		 * @param taken <code>true</code> to clear the previously chosen and current path choices.
		 * @param walked <code>true</code> to clear the "walked" paths.
		 */
		protected function clearPaths( icons:Boolean = true, choices:Boolean = true, walked:Boolean = true ):void
		{
			// Log Activity
			logger.pushContext( "clearPaths", arguments );;
						
			if( icons )
			{
				grpIcons.removeAllElements();
			}
			
			if( choices ) 
			{
				grpPathsTaken.removeAllElements();
				grpPathChoices.removeAllElements();
			}
			
			if( walked )
			{
				grpWalkedPaths.removeAllElements();	
			}
			
			// Clear Context
			logger.popContext();			
		}	
		
		/**
		 * Handles the 'MOUSEOVER' event of the bonus choice icon(s)
		 */ 		
		protected function onChoiceOver( event:MouseEvent ):void
		{
			var img:Image = event.target as Image;
			if( img )
			{
				img.alpha = 1;
				grpIcons.getElementAt( grpIcons.getElementIndex( img ) == 1 ? 0 : 1 ).alpha = 0;
				pathChoiceTimer.stop();
				grpPathChoices.removeAllElements();
				
				grpPathChoices.addElement( grpIcons.getElementAt( 0 ) == img ? pathChoice1 : pathChoice2 );
			}			
		}
		
		/**
		 * Handles the 'MOUSEOUT' event of the bonus choice icon(s)
		 */ 		
		protected function onChoiceOut( event:MouseEvent ):void
		{
			var img:Image = event.target as Image;
			if( img && !actAvatar.isPlaying )
			{
				pathChoiceTimer.start();
			}				
		}
		
		/**
		 * Handles the 'CLICK' event of the bonus choice icon(s)
		 */ 
		protected function onChoiceClick( event:MouseEvent ):void
		{
			// Log Activity
			logger.pushContext( "onChoiceClick", arguments );
						
			var nextPaths:Array = lastPathTaken == null ? paths[curScreenIndex] : lastPathTaken.children;
			var img:Image = event.target as Image;
			if( img )
			{
				lastActionTaken = img.id.replace( "BonusChoice_", "search" );
				
				var pt:Point = new Point( img.x + 25, img.y + 25 );
				for( var i:int = 0; i < nextPaths.length; i++ )
				{
					if( pt.equals( nextPaths[i].getLastPoint() ) )
					{
						lastPathTaken = nextPaths[i];
						break;
					}
				}
				
				grpPathChoices.removeAllElements();
				grpPathsTaken.addElement( grpIcons.getElementAt( 0 ) == img ? pathChoice1 : pathChoice2 );
				
				pathChoiceTimer.stop();
				clearPaths( true, false, false );
				walkThePath();
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Handles the 'TIMER' event of the path choice timer.
		 */
		protected function pathChoiceTimer_TIMER( event:TimerEvent ):void
		{
			if( pathChoiceTimer.currentCount % 2 == 0 )
			{
				pathChoice1.parent == grpPathChoices && grpPathChoices.removeElement( pathChoice1 );
				pathChoice2.parent != grpPathChoices && grpPathChoices.addElement( pathChoice2 );
				
				if( grpIcons.numElements > 0 ) 
				{
					grpIcons.getElementAt( 0 ).alpha = 0;
					grpIcons.getElementAt( 1 ).alpha = 1;
				}
			}
			else
			{
				pathChoice2.parent == grpPathChoices && grpPathChoices.removeElement( pathChoice2 );
				pathChoice1.parent != grpPathChoices && grpPathChoices.addElement( pathChoice1 );
				
				if( grpIcons.numElements > 0 ) 
				{
					grpIcons.getElementAt( 0 ).alpha = 1;
					grpIcons.getElementAt( 1 ).alpha = 0;
				}			
			}
		}		
		
		public function setParameters( betAmount:int, bonusWin:int, winAmount:int, startingAmount:int = 0 ):void
		{
			// Log Activity
			logger.pushContext( "setParameters", arguments );
			
			this.betAmount = betAmount;
			this.bonusWin = bonusWin;
			this.winAmount = winAmount;
			this.startingAmount = startingAmount;
			
			// Clear Context
			logger.popContext();			
		}		
		
		protected function calculateRevealWinnings( minSteps:int, maxSteps:int, displayAsCurrency:Boolean = true, routeType:int = MathHelper.ROUTE_TYPE_NORMAL ):void
		{
			// Log Activity
			logger.pushContext( "calculateRevealWinnings", arguments );
			
			// Constructs an array of possible step amounts, duplicating the lower step amounts more often
			// and higher step amounts less frequently.
			var steps:Array = [];
			
			for( var i:int = minSteps; i <= maxSteps; i++ )
			{
				for( var j:int = maxSteps - i; j >= 0; j-- )
				{
					steps.push( i );
				}
			}			
			
			// Use calculateRoute to determine what amounts and how many clicks a user will see to reveal their bonus win
			do
			{
				revealWinnings = MathHelper.calculateRoute( routeType, betAmount, bonusWin, steps[MathHelper.randomNumber( 0, steps.length - 1 )], maxSteps, displayAsCurrency, startingAmount );
			} 
			while ( revealWinnings == null || revealWinnings.length == 0 );
			
			// Clear Context
			logger.popContext();			
		}
		
		public function resetAndPlay():void
		{			
			// Log Activity
			logger.pushContext( "resetAndPlay", arguments );
			
			// Reset game completed
			actAvatar.visible = true;
			actAvatar.flip( 1 );
			ddBonusWin.displayAmount = 0;
			ddWinAmountExit.displayAmount = 0;
			ddWinAmountExit.visible = false;
			gameCompleted = false;
			revealInProgress = false;
			
			// Clear Context
			logger.popContext();			
		}
		
		protected function startPathFinder():void
		{
			// Log Activity
			logger.pushContext( "startPathFinder", arguments );
			
			clearPaths( true, true, true );
			curScreenIndex = 0;
			loadNextScreen();
			
			// Clear Context
			logger.popContext();			
		}
		
		protected function playExit( winAmount:int, isCurrency:Boolean = true, didWin:Boolean = false ):void
		{
			// Log Activity
			logger.pushContext( "playExit", arguments );
			
			// Clear Context
			logger.popContext();			
		}		
		
		protected function GameFinished():void
		{
			// Log Activity
			logger.pushContext( "GameFinished", arguments );
			
			// Dispatch our event so the game knows we're done with the bonus game
			_onStop( this );
			
			// Clear Context
			logger.popContext();			
		}		
				
		
		public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );
			
			// Clear Context
			logger.popContext();			
		}
		
		public function getDebugInfo():String
		{
			return null;
		}
	}
}