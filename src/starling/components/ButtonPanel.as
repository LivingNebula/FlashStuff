package starling.components
{
	import assets.Images;
	import assets.SoundManager;
	import assets.Sounds;
	
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import interfaces.IDisposable;
	
	import objects.AchievementReward;
	
	import starling.assets.AssetManager;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.interfaces.IButtonPanelHandler;
	import starling.text.TextField;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import utils.DebugHelper;
	import utils.FormatHelper;
	
	public class ButtonPanel extends Sprite
	{
		// Logging
		private static const logger:DebugHelper = new DebugHelper( ButtonPanel );	
		
		// Constants
		public static const MENU_TYPE_SINGLELINE_SLOTS:String  = "SingleLine";
		public static const MENU_TYPE_VIDEO_SLOTS:String 	   = "VideoSlots";
		public static const MENU_TYPE_VIDEO_POKER:String 	   = "VideoPoker";
		public static const MENU_TYPE_VIDEO_KENO:String  	   = "VideoKeno";
		public static const MENU_TYPE_VIDEO_KENO_QP:String	   = "VideoKenoQP";
		public static const MENU_TYPE_VIDEO_BLACKJACK:String   = "VideoBlackjack";
		public static const MENU_TYPE_SUPER_VIDEO_SLOTS:String = "SuperVideoSlots";
		public static const MENU_TYPE_QUAD_VIDEO_SLOTS:String  = "QuadVideoSlots";
		
		// UI Components
		private var btn1:ButtonPanelButton;
		private var btn2:ButtonPanelButton;
		private var btn3:ButtonPanelButton;
		private var btn4:ButtonPanelButton;
		private var btn5:ButtonPanelButton;
		private var btn6:ButtonPanelButton;
		
		private var btnBetSub:ComplexButton;
		private var grpBetWheel:Sprite;
		private var imgBetPanel:Image;
		private var imgBetWheel:Image;
		private var lblBetWheelImage:DistortImage;
		private var lblBetWheelTexture:RenderTexture;
		private var lblBetWheel:TextField;
		private var btnBetAdd:ComplexButton;
		
		private var btnNudgeLeft:ComplexButton;
		private var grpNudgeTimer:Sprite;
		private var imgNudgeTimer:ComplexButton;
		private var lblNudgeTimer:TextField;
		private var btnNudgeRight:ComplexButton;
		
		private var imgQuickPickPad:Image;
		private var btnQuickPick:ButtonPanelButton;
		private var btnQuickPickUp:ButtonPanelButton;
		private var btnQuickPickDown:ButtonPanelButton;
		private var btnQuickPickDisplay:ButtonPanelButton;
		
		// Objects and Managers
		private var _blinkTimer:Timer;
		private var _assetManager:AssetManager;
		private var _customAssetManager:AssetManager;
		private var _timer:Timer;
		
		// Gamestate Variables
		private var _menuType:String;
		private var _defaultBetAmount:int;
		private var _defaultBetLines:int;
		private var _betAmount:int;
		private var _quickPickAmount:int;
		
		private var _repeatCount:int;
		private var _isEnabled:Boolean = true;
		private var _isAutoPlaying:Boolean = false;
		private var _isDealt:Boolean = false;
		
		private var _handler:IButtonPanelHandler;	
		
		/**
		 * A Button Panel with Auto Play, Reveal and Bet buttons to faciliate interacting with a game.
		 * 
		 * @param menuType The type of game this button panel should support.
		 * @param handler The IButtonPanelHandler for this button panel, for the purpose of callbacks.
		 * @param customAssetManager An AssetManager to be used for this button panel's textures. Any textures
		 * not found will default to internal textures supplied by the Button Panel itself.
		 * @param defaultBetAmount The default bet amount.
		 * @param defaultBetLines The default bet lines.
		 * @param betAmount The current bet amount.
		 */
		public function ButtonPanel( menuType:String, handler:IButtonPanelHandler, customAssetManager:AssetManager = null, defaultBetAmount:int = 0, defaultBetLines:int = 1, betAmount:int = 0 )
		{
			// Log Activity
			logger.pushContext( "constructor", arguments );
			
			super();
			width = 800;
			height = 65;
			
			_menuType = menuType;
			_handler = handler;
			_customAssetManager = customAssetManager;
			_defaultBetAmount = defaultBetAmount;
			_defaultBetLines = defaultBetLines;
			_betAmount = betAmount;
			
			_assetManager = new AssetManager( "", null );
			_assetManager.addLocalTexture( "btn1", assets.Images.btn1 );
			_assetManager.addLocalTexture( "btn1_Down", assets.Images.btn1_Down );
			_assetManager.addLocalTexture( "btn1_Disabled", assets.Images.btn1_Disabled );
			
			_assetManager.addLocalTexture( "btn2", assets.Images.btn2 );
			_assetManager.addLocalTexture( "btn2_Down", assets.Images.btn2_Down );
			_assetManager.addLocalTexture( "btn2_Disabled", assets.Images.btn2_Disabled );
			
			_assetManager.addLocalTexture( "btn3", assets.Images.btn3 );
			_assetManager.addLocalTexture( "btn3_Down", assets.Images.btn3_Down );
			_assetManager.addLocalTexture( "btn3_Disabled", assets.Images.btn3_Disabled );
			
			_assetManager.addLocalTexture( "btn4", assets.Images.btn4 );
			_assetManager.addLocalTexture( "btn4_Down", assets.Images.btn4_Down );
			_assetManager.addLocalTexture( "btn4_Disabled", assets.Images.btn4_Disabled );
			
			_assetManager.addLocalTexture( "btn5", assets.Images.btn5 );
			_assetManager.addLocalTexture( "btn5_Down", assets.Images.btn5_Down );
			_assetManager.addLocalTexture( "btn5_Disabled", assets.Images.btn5_Disabled );
			
			_assetManager.addLocalTexture( "btn6", assets.Images.btn6 );
			_assetManager.addLocalTexture( "btn6_Down", assets.Images.btn6_Down );
			_assetManager.addLocalTexture( "btn6_Disabled", assets.Images.btn6_Disabled );
			
			_assetManager.addLocalTexture( "btnBetSub", assets.Images.btnBetSub );
			_assetManager.addLocalTexture( "btnBetSub_Down", assets.Images.btnBetSub_Down );
			_assetManager.addLocalTexture( "btnBetSub_Disabled", assets.Images.btnBetSub_Disabled );	
			
			_assetManager.addLocalTexture( "btnBetAdd", assets.Images.btnBetAdd );
			_assetManager.addLocalTexture( "btnBetAdd_Down", assets.Images.btnBetAdd_Down );
			_assetManager.addLocalTexture( "btnBetAdd_Disabled", assets.Images.btnBetAdd_Disabled );	
			
			_assetManager.addLocalTexture( "btnNudgeLeft", assets.Images.btnNudgeLeft );
			_assetManager.addLocalTexture( "btnNudgeLeft_Down", assets.Images.btnNudgeLeft_Down );
			_assetManager.addLocalTexture( "btnNudgeLeft_Disabled", assets.Images.btnNudgeLeft_Disabled );
			
			_assetManager.addLocalTexture( "btnNudgeRight", assets.Images.btnNudgeRight );
			_assetManager.addLocalTexture( "btnNudgeRight_Down", assets.Images.btnNudgeRight_Down );
			_assetManager.addLocalTexture( "btnNudgeRight_Disabled", assets.Images.btnNudgeRight_Disabled );
			
			_assetManager.addLocalTexture( "imgBetWheel", assets.Images.imgBetWheel );
			_assetManager.addLocalTexture( "imgBetWheel_Disabled", assets.Images.imgBetWheel_Disabled );
			_assetManager.addLocalTexture( "imgBetWheel_Spin1", assets.Images.imgBetWheel_Spin1 );
			_assetManager.addLocalTexture( "imgBetWheel_Spin2", assets.Images.imgBetWheel_Spin2 );
			_assetManager.addLocalTexture( "imgBetWheel_Spin3", assets.Images.imgBetWheel_Spin3 );
			
			_assetManager.addLocalTexture( "imgNudgeTimer", assets.Images.imgNudgeTimer );
			_assetManager.addLocalTexture( "imgNudgeTimer_Disabled", assets.Images.imgNudgeTimer_Disabled );
			
			btn1 = new ButtonPanelButton( 
				getTexture( "btn1" ),
				"",
				getTexture( "btn1_Down" ),
				getTexture( "btn1" ),
				getTexture( "btn1_Disabled" ) );
			btn1.x = 10;
			btn1.y = 7;
			btn1.distortLabel( new Point( -3, -15 ), new Point( btn1.width + 22, -15 ), new Point( btn1.width + 7, btn1.height -15 ), new Point( -27, btn1.height -15 ) );			
			btn1.addEventListener( Event.TRIGGERED, btn1_clickHandler );
			addChild( btn1 );
			
			btn2 = new ButtonPanelButton( 
				getTexture( "btn2" ),
				"",
				getTexture( "btn2_Down" ),
				getTexture( "btn2" ),
				getTexture( "btn2_Disabled" ) );
			btn2.x = 145;
			btn2.y = 7;
			//TODO Distort Label
			btn2.addEventListener( Event.TRIGGERED, btn2_clickHandler );
			addChild( btn2 );
			
			btn3 = new ButtonPanelButton( 
				getTexture( "btn3" ),
				"",
				getTexture( "btn3_Down" ),
				getTexture( "btn3" ),
				getTexture( "btn3_Disabled" ) );
			btn3.x = 276;
			btn3.y = 7;
			//TODO Distort Label
			btn3.addEventListener( Event.TRIGGERED, btn3_clickHandler );
			addChild( btn3 );
			
			btn4 = new ButtonPanelButton( 
				getTexture( "btn4" ),
				"",
				getTexture( "btn4_Down" ),
				getTexture( "btn4" ),
				getTexture( "btn4_Disabled" ) );
			btn4.x = 407;
			btn4.y = 7;
			btn4.distortLabel( new Point( 0, -10 ), new Point( btn4.width - 5, -10 ), new Point( btn4.width, btn4.height -10 ), new Point( 0, btn4.height -10 ) );
			btn4.addEventListener( Event.TRIGGERED, btn4_clickHandler );
			addChild( btn4 );
			
			btn5 = new ButtonPanelButton( 
				getTexture( "btn5" ),
				"",
				getTexture( "btn5_Down" ),
				getTexture( "btn5" ),
				getTexture( "btn5_Disabled" ) );
			btn5.x = 540;
			btn5.y = 7;
			btn5.distortLabel( new Point( -5, -10 ), new Point( btn5.width - 5, -10 ), new Point( btn5.width + 10, btn5.height -10 ), new Point( 7, btn5.height -10 ) );
			btn5.addEventListener( Event.TRIGGERED, btn5_clickHandler );
			addChild( btn5 );
			
			btn6 = new ButtonPanelButton( 
				getTexture( "btn6" ),
				"",
				getTexture( "btn6_Down" ),
				getTexture( "btn6" ),
				getTexture( "btn6_Disabled" ) );
			btn6.x = 664;
			btn6.y = 7;
			btn6.distortLabel( new Point( -23, -15 ), new Point( btn6.width + 2, -15 ), new Point( btn6.width + 23, btn6.height -15 ), new Point( 6, btn6.height -15 ) );
			btn6.addEventListener( Event.TRIGGERED, btn6_clickHandler );
			addChild( btn6 );
			
			btnBetSub = new ComplexButton(
				getTexture( "btnBetSub" ),
				"",
				getTexture( "btnBetSub_Down" ),
				getTexture( "btnBetSub" ),
				getTexture( "btnBetSub_Disabled" ) );
			btnBetSub.x = 127;
			btnBetSub.y = 7;
			btnBetSub.addEventListener( Event.TRIGGERED, btnBetSub_clickHandler );
			addChild( btnBetSub );
			
			grpBetWheel = new Sprite();
			grpBetWheel.width = 118;
			grpBetWheel.height = 68;
			grpBetWheel.x = 183;
			grpBetWheel.y = 7;
			addChild( grpBetWheel );
			
			imgBetPanel = new Image( getTexture( "imgBetWheel" ) );
			grpBetWheel.addChild( imgBetPanel );
			
			imgBetWheel = new Image( getTexture( "imgBetWheel_Spin1" ) );
			imgBetWheel.visible = false;
			grpBetWheel.addChild( imgBetWheel );
			
			_assetManager.addRenderTexture( "lblBetWheelTexture", new RenderTexture( 118, 68, false ) );			
			lblBetWheel = new TextField( 118, 68, "0.00", "xTimes", 22, 0, true );
			lblBetWheelTexture = _assetManager.getRenderTexture( "lblBetWheelTexture" );
			lblBetWheelTexture.draw( lblBetWheel );
			lblBetWheelImage = new DistortImage( lblBetWheelTexture );
			lblBetWheelImage.distort( new Point( 3, -10 ), new Point( 121, -10 ), new Point( 111, 58 ), new Point( -7, 58 ) );
			grpBetWheel.addChild( lblBetWheelImage );
			
			btnBetAdd = new ComplexButton(
				getTexture( "btnBetAdd" ),
				"",
				getTexture( "btnBetAdd_Down" ),
				getTexture( "btnBetAdd" ),
				getTexture( "btnBetAdd_Disabled" ) );
			btnBetAdd.x = 301;
			btnBetAdd.y = 7;
			btnBetAdd.addEventListener( Event.TRIGGERED, btnBetAdd_clickHandler );
			addChild( btnBetAdd );
			
			btnNudgeLeft = new ComplexButton(
				getTexture( "btnNudgeLeft" ),
				"",
				getTexture( "btnNudgeLeft_Down" ),
				getTexture( "btnNudgeLeft" ),
				getTexture( "btnNudgeLeft_Disabled" ) );
			btnNudgeLeft.x = 441;
			btnNudgeLeft.y = 7;
			btnNudgeLeft.addEventListener( Event.TRIGGERED, btnNudgeLeft_clickHandler );
			addChild( btnNudgeLeft );
			
			grpNudgeTimer = new Sprite();
			grpNudgeTimer.width = 118;
			grpNudgeTimer.height = 68;
			grpNudgeTimer.x = 499;
			grpNudgeTimer.y = 7;
			addChild( grpNudgeTimer );
			
			imgNudgeTimer = new ComplexButton(
				getTexture( "imgNudgeTimer" ),
				"",
				getTexture( "imgNudgeTimer" ),
				getTexture( "imgNudgeTimer" ),
				getTexture( "imgNudgeTimer_Disabled" ) );
			imgNudgeTimer.useHandCursor = false;
			grpNudgeTimer.addChild( imgNudgeTimer );
			
			lblNudgeTimer = new TextField( 118, 68, "0.00", "xTimes", 22, 0, true );
			grpNudgeTimer.addChild( lblNudgeTimer );			
			
			btnNudgeRight = new ComplexButton(
				getTexture( "btnNudgeRight" ),
				"",
				getTexture( "btnNudgeRight_Down" ),
				getTexture( "btnNudgeRight" ),
				getTexture( "btnNudgeRight_Disabled" ) );
			btnNudgeRight.x = 608;
			btnNudgeRight.y = 7;
			btnNudgeRight.addEventListener( Event.TRIGGERED, btnNudgeRight_clickHandler );
			addChild( btnNudgeRight );
			
			// VIDEO KENO QP specific buttons
			if( _menuType == MENU_TYPE_VIDEO_KENO_QP )
			{
				imgQuickPickPad = new Image( getTexture( "Button_Pad" ) );
				imgQuickPickPad.x = 415;
				imgQuickPickPad.y = 8;
				addChild( imgQuickPickPad );
				
				btnQuickPick = new ButtonPanelButton(
					getTexture( "btn_QP" ),
					"",
					getTexture( "btn_QP_Down" ),
					getTexture( "btn_QP" ),
					getTexture( "btn_QP_Disabled" ) );
				btnQuickPick.x = 430;
				btnQuickPick.y = 12;
				btnQuickPick.addEventListener( Event.TRIGGERED, btnQuickPick_clickHandler );
				addChild( btnQuickPick );				
				
				btnQuickPickDisplay = new ButtonPanelButton(
					getTexture( "btn_10" ),
					"",
					getTexture( "btn_10_Down" ),
					getTexture( "btn_10" ),
					getTexture( "btn_10_Disabled" ) );
				btnQuickPickDisplay.fontSize = 30;
				btnQuickPickDisplay.x = 510;
				btnQuickPickDisplay.y = 12;
				btnQuickPickDisplay.touchable = false;
				btnQuickPickDisplay.distortLabel( new Point( -5, -7 ), new Point( btnQuickPickDisplay.width - 5, -7 ), new Point( btnQuickPickDisplay.width + 5, btnQuickPickDisplay.height -7 ), new Point( 2, btnQuickPickDisplay.height -7 ) );				
				addChild( btnQuickPickDisplay );
				
				btnQuickPickUp = new ButtonPanelButton(
					getTexture( "Btn_Arw_Up" ),
					"",
					getTexture( "Btn_Arw_Up_Down" ),
					getTexture( "Btn_Arw_Up" ),
					getTexture( "Btn_Arw_Up_Disabled" ) );
				btnQuickPickUp.x = 595;
				btnQuickPickUp.y = 5;
				btnQuickPickUp.addEventListener( Event.TRIGGERED, btnQuickPickUp_clickHandler );
				addChild( btnQuickPickUp );
				
				btnQuickPickDown = new ButtonPanelButton(
					getTexture( "Btn_Arw_Dn" ),
					"",
					getTexture( "Btn_Arw_Dn_Down" ),
					getTexture( "Btn_Arw_Dn" ),
					getTexture( "Btn_Arw_Dn_Disabled" ) );
				btnQuickPickDown.x = 599;
				btnQuickPickDown.y = 32;
				btnQuickPickDown.addEventListener( Event.TRIGGERED, btnQuickPickDown_clickHandler );
				addChild( btnQuickPickDown );
			}
			
			configureButtonPanel();
			
			// Clear Context
			logger.popContext();
		}
		
		private function configureButtonPanel():void
		{
			// Log Activity
			logger.pushContext( "configureButtonPanel", arguments );
			
			// Display the correct buttons based on the menu type
			if( _menuType == MENU_TYPE_SINGLELINE_SLOTS )
			{
				btn1.visible = !Sweeps.SkilltopiaEnabled;					
				
				btn2.visible = false;
				btn3.visible = false;		
				btn4.visible = !Sweeps.SkilltopiaEnabled && Sweeps.hasReward( AchievementReward.REWARD_NUDGE );
				btn4.enabled = false;
				btn5.visible = !Sweeps.SkilltopiaEnabled;
				
				btnBetSub.visible = true;
				grpBetWheel.visible = true;
				btnBetAdd.visible = true;	
				lblBetWheel.text = FormatHelper.formatEntriesAndWinnings( _defaultBetAmount );
				lblBetWheelTexture.draw( lblBetWheel );
				
				btnNudgeLeft.visible = Sweeps.SkilltopiaEnabled;
				btnNudgeRight.visible = Sweeps.SkilltopiaEnabled;	
				grpNudgeTimer.visible = Sweeps.SkilltopiaEnabled;
				
				btnNudgeLeft.enabled = false;
				btnNudgeRight.enabled = false;
				imgNudgeTimer.upState = imgNudgeTimer.disabledState;
				
				btn1.text = "AUTO\nPLAY";
				btn4.text = "NUDGE";
				btn5.text = "ENTRIES\nMAX";
				btn6.text = "REVEAL";
			}
			else if( _menuType == MENU_TYPE_VIDEO_SLOTS )
			{
				btn1.visible = !Sweeps.SkilltopiaEnabled;
				btn2.visible = true;
				btn3.visible = true;	
				
				btnBetSub.visible = false;
				grpBetWheel.visible = false;
				btnBetAdd.visible = false;	
				btn5.visible = false;
				
				btnNudgeLeft.visible = Sweeps.SkilltopiaEnabled;
				btnNudgeRight.visible = Sweeps.SkilltopiaEnabled;	
				grpNudgeTimer.visible = Sweeps.SkilltopiaEnabled;
				
				btnNudgeLeft.enabled = false;
				btnNudgeRight.enabled = false;
				imgNudgeTimer.upState = imgNudgeTimer.disabledState;
				
				btn1.text = "AUTO\nPLAY";
				btn2.text = "INFO";
				btn3.text = "ENTRIES\n" + FormatHelper.formatEntriesAndWinnings( _defaultBetAmount );
				btn4.text = "LINES\n" + _defaultBetLines.toString(10);
				btn6.text = "REVEAL";			
			}
			else if( _menuType == MENU_TYPE_QUAD_VIDEO_SLOTS )
			{
				btn1.visible = !Sweeps.SkilltopiaEnabled;
				btn2.visible = true;
				btn3.visible = Sweeps.SkilltopiaEnabled;
				btn4.visible = !Sweeps.SkilltopiaEnabled;
				
				btnBetSub.visible = false;
				grpBetWheel.visible = false;
				btnBetAdd.visible = false;	
				btn5.visible = false;
				
				btnNudgeLeft.visible = Sweeps.SkilltopiaEnabled;
				btnNudgeRight.visible = Sweeps.SkilltopiaEnabled;	
				grpNudgeTimer.visible = Sweeps.SkilltopiaEnabled;
				
				btnNudgeLeft.enabled = false;
				btnNudgeRight.enabled = false;
				imgNudgeTimer.upState = imgNudgeTimer.disabledState;
				
				btn1.text = "AUTO\nPLAY";
				btn2.text = "INFO";
				btn3.text = "LINES\n" + _defaultBetLines.toString(10); // Skilltopia mode
				btn4.text = "LINES\n" + _defaultBetLines.toString(10); // Regular mode
				btn6.text = "REVEAL";						
			}
			else if( _menuType == MENU_TYPE_SUPER_VIDEO_SLOTS )
			{
				btn1.visible = !Sweeps.SkilltopiaEnabled;
				btn2.visible = true;
				btn3.visible = true;	
				
				btnBetSub.visible = false;
				grpBetWheel.visible = false;
				btnBetAdd.visible = false;	
				btn4.visible = false;
				btn5.visible = false;
				
				btnNudgeLeft.visible = Sweeps.SkilltopiaEnabled;
				btnNudgeRight.visible = Sweeps.SkilltopiaEnabled;
				grpNudgeTimer.visible = Sweeps.SkilltopiaEnabled;
				
				btnNudgeLeft.enabled = false;
				btnNudgeRight.enabled = false;
				imgNudgeTimer.upState = imgNudgeTimer.disabledState;
				
				btn1.text = "AUTO\nPLAY";
				btn2.text = "INFO";
				btn3.text = "ENTRIES\n" + FormatHelper.formatEntriesAndWinnings( _defaultBetAmount );
				btn6.text = "REVEAL";						
			}
			else if( _menuType == MENU_TYPE_VIDEO_POKER )
			{
				btn2.visible = false;
				btn3.visible = false;		
				
				btnBetSub.visible = true;
				grpBetWheel.visible = true;
				btnBetAdd.visible = true;	
				lblBetWheel.text = FormatHelper.formatEntriesAndWinnings( _defaultBetAmount );
				lblBetWheelTexture.draw( lblBetWheel );
				
				btnNudgeLeft.visible = false;
				btnNudgeRight.visible = false;
				grpNudgeTimer.visible = false;
				
				btn1.text = "AUTO\nPLAY";
				btn4.text = "ENTRIES\nMIN";
				btn5.text = "ENTRIES\nMAX";
				btn6.text = "REVEAL";
			}
			else if( _menuType == MENU_TYPE_VIDEO_KENO )
			{
				btn2.visible = false;
				btn3.visible = false;		
				
				btnBetSub.visible = true;
				grpBetWheel.visible = true;
				btnBetAdd.visible = true;	
				lblBetWheel.text = FormatHelper.formatEntriesAndWinnings( _defaultBetAmount );
				lblBetWheelTexture.draw( lblBetWheel );
				
				btnNudgeLeft.visible = false;
				btnNudgeRight.visible = false;
				grpNudgeTimer.visible = false;
				
				btn1.text = "AUTO\nPLAY";
				btn4.text = "ENTRIES\nMIN";
				btn5.text = "ENTRIES\nMAX";
				btn6.text = "REVEAL";					
			}
			else if( _menuType == MENU_TYPE_VIDEO_KENO_QP )
			{
				btn2.visible = false;
				btn3.visible = false;
				btn4.visible = false;
				btn5.visible = false;
				
				btnBetSub.visible = true;
				grpBetWheel.visible = true;
				btnBetAdd.visible = true;	
				lblBetWheel.text = FormatHelper.formatEntriesAndWinnings( _defaultBetAmount );
				lblBetWheelTexture.draw( lblBetWheel );
				
				btnNudgeLeft.visible = false;
				btnNudgeRight.visible = false;
				grpNudgeTimer.visible = false;
				
				btn1.text = "AUTO\nPLAY";
				btn6.text = "REVEAL";					
			}
			else if( _menuType == MENU_TYPE_VIDEO_BLACKJACK )
			{
				btn1.visible = false;
				btn2.visible = false;
				btn3.visible = false;	
				btn5.visible = false;
				
				btnBetSub.visible = true;
				grpBetWheel.visible = true;
				btnBetAdd.visible = true;		
				lblBetWheel.text = FormatHelper.formatEntriesAndWinnings( _defaultBetAmount );
				lblBetWheelTexture.draw( lblBetWheel );
				
				btnNudgeLeft.visible = false;
				btnNudgeRight.visible = false;
				grpNudgeTimer.visible = false;
				
				btn4.text = "HANDS\n" + _defaultBetLines.toString(10);
				btn6.text = "REVEAL";					
			}
			
			// Clear Context
			logger.popContext();			
		}
		
		public function set betAmount( value:int ):void
		{
			_betAmount = value;
		}
		
		public function set quickPickAmount( value:int ):void
		{
			_quickPickAmount = value;
		}
		
		/** True if the dealt button has been pressed */
		public function get isDealt():Boolean
		{
			return _isDealt;
		}
		
		public function set isDealt( value:Boolean ):void
		{
			_isDealt = value;			
		}
		
		/**
		 * Toggles the enabled state of all the buttons except Auto Play/Stop
		 * @param includeAutoPlay includes Auto Play button
		 * @param includeGamePlay includes Game Play button
		 */
		public function toggleEnabled( enabled:Boolean, includeAutoPlay:Boolean = false, includeGamePlay:Boolean = true ):void
		{
			_isEnabled = enabled;
			
			// Set the enabled status of the appropriate buttons
			btn1.enabled = includeAutoPlay ? _isEnabled : true;
			btn2.enabled = _isEnabled;
			btn3.enabled = _isEnabled;
			btn4.enabled = _menuType == MENU_TYPE_SINGLELINE_SLOTS ? false : _isEnabled;
			btn5.enabled = _isEnabled && ( _menuType == MENU_TYPE_SINGLELINE_SLOTS || _menuType == MENU_TYPE_VIDEO_POKER || _menuType == MENU_TYPE_VIDEO_KENO );
			btn6.enabled = includeGamePlay ? _isEnabled : true;
			btnBetAdd.enabled = _isEnabled;
			btnBetSub.enabled = _isEnabled;
			imgBetPanel.texture = getTexture( _isEnabled ? "imgBetWheel" : "imgBetWheel_Disabled" );
			
			if( _menuType == MENU_TYPE_VIDEO_KENO_QP )
			{
				btnQuickPick.enabled = _isEnabled;
				btnQuickPickUp.enabled = _isEnabled;
				btnQuickPickDown.enabled = _isEnabled;
				btnQuickPickDisplay.enabled = _isEnabled;
			}
		} 
		
		/** Toggles the enabled state of the AUTO PLAY button */
		public function toggleAutoPlayEnabled( value:Boolean ):void
		{								
			btn1.enabled = value && _isEnabled;
		}
		
		/** Toggles the enabled state of the NUDGE button, disregards isEnabled */
		public function toggleNudgeEnabled( value:Boolean ):void
		{
			if( _menuType == MENU_TYPE_SINGLELINE_SLOTS && btn4.visible )
			{
				if( value == true )
				{
					btn4.enabled = true;
					
					_blinkTimer = new Timer( 500 );
					_blinkTimer.addEventListener( TimerEvent.TIMER, blinkTimerStarted );
					_blinkTimer.start();						
				}
				else
				{
					btn4.enabled = false;
					btn4.upState = getTexture( "btn4" );
					
					_blinkTimer.removeEventListener( TimerEvent.TIMER, blinkTimerStarted );
					_blinkTimer.stop();
					_blinkTimer = null;
				}
			}
			else if( ( _menuType == MENU_TYPE_SINGLELINE_SLOTS || _menuType == MENU_TYPE_VIDEO_SLOTS || _menuType == MENU_TYPE_SUPER_VIDEO_SLOTS || _menuType == MENU_TYPE_QUAD_VIDEO_SLOTS ) && btnNudgeLeft.visible && btnNudgeRight.visible )
			{
				if( value == true )
				{
					btnNudgeLeft.enabled = true;
					btnNudgeLeft.upState = btnNudgeLeft.overState;
					
					btnNudgeRight.enabled = true;
					btnNudgeRight.upState = btnNudgeLeft.overState;
					
					imgNudgeTimer.upState = imgNudgeTimer.overState;
					
					_blinkTimer = new Timer( 500 );
					_blinkTimer.addEventListener( TimerEvent.TIMER, blinkTimerStarted );
					_blinkTimer.start();							
				}
				else
				{
					btnNudgeLeft.enabled = false;
					btnNudgeLeft.upState = btnNudgeLeft.disabledState;
					
					btnNudgeRight.enabled = false;
					btnNudgeRight.upState = btnNudgeLeft.disabledState;
					
					imgNudgeTimer.upState = imgNudgeTimer.disabledState;
					
					if( _blinkTimer )
					{
						_blinkTimer.removeEventListener( TimerEvent.TIMER, blinkTimerStarted );
						_blinkTimer.stop();
						_blinkTimer = null;
					}
				}
			}
		}
		
		/**
		 * Handles the timer event of the 'Blink' timer
		 */
		private function blinkTimerStarted( event:TimerEvent ):void
		{
			if( _menuType == MENU_TYPE_SINGLELINE_SLOTS && btn4.visible )
			{
				if( btn4.upState == getTexture( "btn4" ) )
				{
					btn4.upState = getTexture( "btn4_Disabled" );
				}
				else
				{
					btn4.upState = getTexture( "btn4" )
				}
			}
			else if( MENU_TYPE_SINGLELINE_SLOTS || _menuType == MENU_TYPE_VIDEO_SLOTS || _menuType == MENU_TYPE_SUPER_VIDEO_SLOTS || _menuType == MENU_TYPE_QUAD_VIDEO_SLOTS )
			{
				if( btnNudgeLeft.upState == btnNudgeLeft.overState )
				{
					btnNudgeLeft.upState = btnNudgeLeft.disabledState;
					btnNudgeRight.upState = btnNudgeRight.disabledState;
					imgNudgeTimer.upState = imgNudgeTimer.disabledState;
				}
				else
				{
					btnNudgeLeft.upState = btnNudgeLeft.overState;
					btnNudgeRight.upState = btnNudgeRight.overState;
					imgNudgeTimer.upState = imgNudgeTimer.overState;
				}					
			}
		}
		
		/**
		 * Toggles the enabled state of the PLAY button
		 */
		public function togglePlayEnabled( value:Boolean ):void
		{				
			btn6.enabled = value && _isEnabled;
		}
		
		/**
		 *  Toggles the enabled state of the PLAY STOP button
		 */
		public function togglePlayStopEnabled( value:Boolean ):void
		{
			if( _menuType == ButtonPanel.MENU_TYPE_SINGLELINE_SLOTS || _menuType == ButtonPanel.MENU_TYPE_VIDEO_SLOTS || _menuType == MENU_TYPE_SUPER_VIDEO_SLOTS ) 
			{
				btn6.text = value == true ? "STOP" : "REVEAL";
				btn6.enabled = value;
			}
		}
		
		/**
		 *  Displays the amount of time left to nudge
		 */
		public function displayNudgeTime( time:int ):void
		{
			if( ( _menuType == MENU_TYPE_SINGLELINE_SLOTS || _menuType == MENU_TYPE_VIDEO_SLOTS || _menuType == MENU_TYPE_SUPER_VIDEO_SLOTS || _menuType == MENU_TYPE_QUAD_VIDEO_SLOTS ) && grpNudgeTimer.visible )
			{
				lblNudgeTimer.text = time >= 0 ? time.toString() : "";
			}
		}
		
		/**
		 *  Displays the number of bet lines selected
		 */
		public function displayBetLines( betLines:int ):void
		{
			if( _menuType == ButtonPanel.MENU_TYPE_VIDEO_SLOTS )
			{
				btn4.text = "LINES\n" + betLines.toString();
			}
			else if(_menuType == MENU_TYPE_QUAD_VIDEO_SLOTS )
			{
				if( Sweeps.SkilltopiaEnabled )
				{
					btn3.text = "LINES\n" + betLines.toString();	
				}
				else
				{
					btn4.text = "LINES\n" + betLines.toString();
				}
			}
			else if ( _menuType == ButtonPanel.MENU_TYPE_VIDEO_BLACKJACK )
			{
				btn4.text = "HANDS\n" + betLines.toString();
			}
		}
		
		/**
		 *  Updates the bet amount on the bet wheel, using an animation
		 */
		public function displayBetAmount():void
		{							
			if( _menuType == ButtonPanel.MENU_TYPE_SINGLELINE_SLOTS )
			{
				SoundManager.playSound( assets.Sounds["changeBet"], 0, 0 ); // Play the change bet sound
				
				imgBetWheel.visible = true;
				lblBetWheelImage.visible = false;
				
				_timer = new Timer( 25, 4 );
				_timer.addEventListener( TimerEvent.TIMER, timerStarted );
				_timer.addEventListener( TimerEvent.TIMER_COMPLETE, timerEnded );
				_timer.start();
			}
			else if( _menuType == ButtonPanel.MENU_TYPE_VIDEO_SLOTS )
			{
				btn3.text = "ENTRIES\n" + FormatHelper.formatEntriesAndWinnings( _betAmount );
			}
			else if( _menuType == ButtonPanel.MENU_TYPE_SUPER_VIDEO_SLOTS )
			{
				btn3.text = "ENTRIES\n" + FormatHelper.formatEntriesAndWinnings( _betAmount );
			}
			else if( _menuType == ButtonPanel.MENU_TYPE_VIDEO_POKER )
			{
				SoundManager.playSound( assets.Sounds["changeBet"], 0, 0 ); // Play the change bet sound
				
				imgBetWheel.visible = true;
				lblBetWheelImage.visible = false;
				
				_timer = new Timer( 25, 4 );
				_timer.addEventListener( TimerEvent.TIMER, timerStarted );
				_timer.addEventListener( TimerEvent.TIMER_COMPLETE, timerEnded );
				_timer.start();
			}
			else if( _menuType == ButtonPanel.MENU_TYPE_VIDEO_KENO || _menuType == ButtonPanel.MENU_TYPE_VIDEO_KENO_QP )
			{
				SoundManager.playSound( assets.Sounds["changeBet"], 0, 0 ); // Play the change bet sound
				
				imgBetWheel.visible = true;
				lblBetWheelImage.visible = false;
				
				_timer = new Timer( 25, 4 );
				_timer.addEventListener( TimerEvent.TIMER, timerStarted );
				_timer.addEventListener( TimerEvent.TIMER_COMPLETE, timerEnded );
				_timer.start();					
			}
			else if( _menuType == ButtonPanel.MENU_TYPE_VIDEO_BLACKJACK )
			{
				SoundManager.playSound( assets.Sounds["changeBet"], 0, 0 ); // Play the change bet sound
				
				imgBetWheel.visible = true;
				lblBetWheelImage.visible = false;
				
				_timer = new Timer( 25, 4 );
				_timer.addEventListener( TimerEvent.TIMER, timerStarted );
				_timer.addEventListener( TimerEvent.TIMER_COMPLETE, timerEnded );
				_timer.start();			
			}
		}
		
		/** Updates the quick pick amount. */
		public function displayQuickPickAmount():void
		{
			if( _menuType == ButtonPanel.MENU_TYPE_VIDEO_KENO_QP )
			{
				if( btnQuickPickDisplay )
				{
					btnQuickPickDisplay.text = _quickPickAmount.toString();
				}
			}
		}
		
		/**
		 * Stops auto play
		 */
		public function stopAutoPlay():void
		{
			_isAutoPlaying = false;
			btn1.text = "AUTO\nPLAY";
		}
		
		/**
		 *  Handles the timer started event of the bet wheel
		 */
		protected function timerStarted( event:TimerEvent ):void
		{						
			_repeatCount++;
			
			if( _repeatCount > 3 ){ _repeatCount = 1; }
			
			if( _repeatCount == 1 ) { imgBetWheel.texture = getTexture( "imgBetWheel_Spin1" ); }
			if( _repeatCount == 2 ) { imgBetWheel.texture = getTexture( "imgBetWheel_Spin2" ); }
			if( _repeatCount == 3 ) { imgBetWheel.texture = getTexture( "imgBetWheel_Spin3" ); }
		}
		
		/**
		 *  Handles the timer ended event of the bet wheel
		 */
		protected function timerEnded( event:TimerEvent ):void
		{
			_timer.removeEventListener( TimerEvent.TIMER, timerStarted );
			_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, timerEnded );
			
			imgBetWheel.visible = false;
			lblBetWheel.text = FormatHelper.formatEntriesAndWinnings( _betAmount );
			lblBetWheelTexture.draw( lblBetWheel );
			lblBetWheelImage.visible = true;
		}
		
		/**
		 *  Handles the btn1 click event
		 */
		protected function btn1_clickHandler( event:Event ):void
		{
			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 ); // Play the button click sound
			
			// AUTO PLAY
			_isAutoPlaying = !_isAutoPlaying;
			if( _isAutoPlaying )
			{
				btn1.text = "STOP";					
				if( _menuType == MENU_TYPE_VIDEO_POKER )
				{
					if( isDealt ) { btn6.text = "DRAW"; } else { btn6.text = "REVEAL"; }
				}
				
				_handler.onAutoPlay();
			}
			else
			{
				btn1.text = "AUTO\nPLAY";				
				if( _menuType == MENU_TYPE_VIDEO_POKER )
				{
					if( isDealt ) { btn6.text = "DRAW"; } else { btn6.text = "REVEAL"; }
				}
				
				_handler.onStop();
			}
		}
		
		/**
		 *  Handles the btnSub click event
		 */
		protected function btnBetSub_clickHandler( event:Event ):void
		{
			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 ); // Play the button click sound
			
			_handler.onBetSub(); // BET SUBTRACT
		}
		
		/**
		 *  Handles the btnAdd click event
		 */
		protected function btnBetAdd_clickHandler( event:Event ):void
		{
			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 ); // Play the button click sound
			
			_handler.onBetAdd(); // BET ADD				
		}
		
		/**
		 * Handles the btn2 click event
		 */
		protected function btn2_clickHandler( event:Event ):void
		{
			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 ); // Play the button click sound
			
			// INFO
			if( _menuType == MENU_TYPE_VIDEO_SLOTS  || _menuType == MENU_TYPE_SUPER_VIDEO_SLOTS || _menuType == MENU_TYPE_QUAD_VIDEO_SLOTS )
			{
				_handler.onInfo();
			}
		}
		
		/**
		 * Handles the btn3 click event
		 */
		protected function btn3_clickHandler( event:Event ):void
		{
			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 ); // Play the button click sound
			
			if( _menuType == MENU_TYPE_QUAD_VIDEO_SLOTS && Sweeps.SkilltopiaEnabled )
			{
				_handler.onLineAdd();	
			}
			else
			{
				_handler.onBetAdd(); // BET STEP
			}
		}
		
		/**
		 *  Handles the btn4 click event
		 */
		protected function btn4_clickHandler( event:Event ):void
		{
			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 ); // Play the button click sound
			
			if( _menuType == MENU_TYPE_SINGLELINE_SLOTS ) // NUDGE
			{
				_handler.onNudge();	
			}				
			else if( _menuType == MENU_TYPE_VIDEO_SLOTS ) // LINES
			{
				_handler.onLineAdd();
			}
			else if( _menuType == MENU_TYPE_QUAD_VIDEO_SLOTS && !Sweeps.SkilltopiaEnabled  ) // LINE
			{
				_handler.onLineAdd();	
			}
			else if( _menuType == MENU_TYPE_SUPER_VIDEO_SLOTS ) // LINES
			{
				_handler.onLineAdd();
			}
			else if( _menuType == MENU_TYPE_VIDEO_POKER ) // BET ONE
			{
				_handler.onBetOne();	
			}
			else if( _menuType == MENU_TYPE_VIDEO_KENO ) // BET ONE
			{
				_handler.onBetOne();
			}
			else if( _menuType == MENU_TYPE_VIDEO_BLACKJACK ) // BET ONE
			{
				_handler.onLineAdd();
			}
		}
		
		/**
		 *  Handles the btn5 click event
		 */
		protected function btn5_clickHandler( event:Event ):void
		{
			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 ); // Play the button click sound
			
			if( _menuType == MENU_TYPE_SINGLELINE_SLOTS ) // BET MAX
			{
				_handler.onBetMax();				
			}				
			else if( _menuType == MENU_TYPE_VIDEO_POKER ) // BET MAX
			{
				_handler.onBetMax();					
			}
			else if( _menuType == MENU_TYPE_VIDEO_KENO ) // BET MAX
			{
				_handler.onBetMax();		
			}
		}
		
		/**
		 *  Handles the btn6 click event
		 */
		protected function btn6_clickHandler( event:Event ):void
		{
			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 ); // Play the button click sound
			
			if( _menuType == MENU_TYPE_VIDEO_POKER )
			{
				// DEAL
				isDealt = !isDealt;
				if( isDealt )
				{
					btn6.text = "DRAW";
					_handler.onDeal();
				}
				else
				{
					btn6.text = "REVEAL";
					_handler.onDraw();
				}
			}
			else if( _menuType == MENU_TYPE_VIDEO_BLACKJACK )
			{
				_handler.onDeal();
			}
			else if( _menuType == MENU_TYPE_VIDEO_SLOTS || _menuType == MENU_TYPE_SINGLELINE_SLOTS || _menuType == MENU_TYPE_SUPER_VIDEO_SLOTS || _menuType == MENU_TYPE_QUAD_VIDEO_SLOTS )
			{
				if( btn6.text == "REVEAL" ) 
				{
					_handler.onSpin(); // SPIN
				}
				else
				{
					_handler.onSpinStop(); // SPIN STOP
				}
			}
			else
			{
				_handler.onSpin(); // SPIN
			}											
		}
		
		/**
		 *  Handles the btnNudgeLeft click event
		 */
		protected function btnNudgeLeft_clickHandler( event:Event ):void
		{
			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 ); // Play the button click sound
			
			if( _menuType == MENU_TYPE_SINGLELINE_SLOTS || _menuType == MENU_TYPE_VIDEO_SLOTS || _menuType == MENU_TYPE_SUPER_VIDEO_SLOTS || _menuType == MENU_TYPE_QUAD_VIDEO_SLOTS )
			{
				_handler.onNudge( "RIGHT" );
			}
		}
		
		/**
		 *  Handles the btnNudgeRight click event
		 */
		protected function btnNudgeRight_clickHandler( event:Event ):void
		{
			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 ); // Play the button click sound
			
			if(  _menuType == MENU_TYPE_SINGLELINE_SLOTS || _menuType == MENU_TYPE_VIDEO_SLOTS || _menuType == MENU_TYPE_SUPER_VIDEO_SLOTS || _menuType == MENU_TYPE_QUAD_VIDEO_SLOTS )
			{
				_handler.onNudge( "LEFT" );
			}				
		}
		
		/**
		 * Handles the btnQuickPickUp click event
		 */
		protected function btnQuickPickUp_clickHandler( event:Event ):void
		{
			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 ); // Play the button click sound
			
			if( _menuType == MENU_TYPE_VIDEO_KENO_QP )
			{
				_handler.onQuickPickUp();
			}
		}		
		
		/**
		 * Handles the btnQuickPickDown click event
		 */
		protected function btnQuickPickDown_clickHandler( event:Event ):void
		{
			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 ); // Play the button click sound
			
			if( _menuType == MENU_TYPE_VIDEO_KENO_QP )
			{
				_handler.onQuickPickDown();
			}
		}
		
		/**
		 * Handles the btnQuickPick click event
		 */
		protected function btnQuickPick_clickHandler( event:Event ):void
		{
			SoundManager.playSound( assets.Sounds["buttonClick"], 0, 0 ); // Play the button click sound
			
			if( _menuType == MENU_TYPE_VIDEO_KENO_QP )
			{
				_handler.onQuickPick();
			}
		}			
		
		override public function dispose():void
		{
			// Log Activity
			logger.pushContext( "dispose", arguments );
			
			// Clear our handler
			_handler = null;
			
			// Clear any starling components that are not part of the display list (were not added using addChild)
			lblBetWheelImage.dispose();
			lblBetWheel.dispose();			
			lblBetWheelTexture.clear();
			lblBetWheelTexture.dispose();
			
			// Dispose of the texture manager to release our textures from the GPU
			if( _assetManager != null )
			{
				_assetManager.dispose();
				_assetManager = null;
			}			
			
			// Call our super method
			super.dispose();
			
			// Clear Context
			logger.popContext();			
		}
		
		/**
		 * Attempts to load the texture off of a custom asset manager, if one exists.
		 * Otherwise, falls back to the internal asset manager.
		 */
		private function getTexture( name:String ):Texture
		{
			var texture:Texture = null;
			
			// Try to load our texture off our custom asset manager first
			if( _customAssetManager )
			{
				texture = _customAssetManager.getTexture( name );
			}
			
			// If the texture isn't present, load off our internal asset manager
			if( !texture )
			{
				texture = _assetManager.getTexture( name );
			}
			
			return texture;
		}
	}
}