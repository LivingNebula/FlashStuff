package assets
{
	import components.AnimatedImage;
	import components.SpriteUIComponent;
	
	import mx.styles.IStyleManager2;
	
	import spark.effects.Animate;
	import spark.effects.Fade;
	import spark.effects.Move;
	import spark.effects.Scale;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.IEaser;
	
	public class AnimationManager
	{			
		/**
		 * Gets a list of image names that represent a given animation.
		 * @param manager The style manager to load the images from.
		 * @param gameID The id of the game we want to use the images for.
		 * @param animation The name of the animation we want to load.
		 * @return An array of image names that make up the given animation.
		 */
		public static function getAnimationImages( manager:IStyleManager2, gameID:int, animation:String ):Array
		{
			var arrImageNames:Array = new Array();
			
			switch( animation )
			{
				case "Sprite_A":
					arrImageNames.push( "Sprite_A" );
					arrImageNames.push( "Sprite_A_1" );
					break;
				
				case "Sprite_C":
					switch( gameID )
					{
						case 23: // Lucky Ducky
						case 25: // Medusa's Treasure
						case 26: // Shark Attack
						case 28: // Mummy's Money
						case 30: // Atlantis
							arrImageNames.push( "Sprite_C" );
							arrImageNames.push( "Sprite_C_1" );
							arrImageNames.push( "Sprite_C_2" );
							arrImageNames.push( "Sprite_C_3" );
							arrImageNames.push( "Sprite_C_4" );
							arrImageNames.push( "Sprite_C_5" );
							arrImageNames.push( "Sprite_C_6" );
							arrImageNames.push( "Sprite_C_5" );
							arrImageNames.push( "Sprite_C_4" );
							arrImageNames.push( "Sprite_C_3" );
							arrImageNames.push( "Sprite_C_2" );
							arrImageNames.push( "Sprite_C_1" );
							arrImageNames.push( "Sprite_C" );
							break;
						
						case 29: // Emerald Eruption
							arrImageNames.push( "Sprite_C_1" );
							arrImageNames.push( "Sprite_C_2" );
							arrImageNames.push( "Sprite_C_3" );
							arrImageNames.push( "Sprite_C_4" );
							arrImageNames.push( "Sprite_C_5" );
							arrImageNames.push( "Sprite_C_6" );
							arrImageNames.push( "Sprite_C_7" );
							arrImageNames.push( "Sprite_C_8" );
							arrImageNames.push( "Sprite_C_9" );
							arrImageNames.push( "Sprite_C_1" );
							arrImageNames.push( "Sprite_C_2" );
							arrImageNames.push( "Sprite_C_3" );
							arrImageNames.push( "Sprite_C_4" );
							arrImageNames.push( "Sprite_C_5" );
							arrImageNames.push( "Sprite_C_6" );
							arrImageNames.push( "Sprite_C_7" );
							arrImageNames.push( "Sprite_C_8" );
							arrImageNames.push( "Sprite_C_9" );
							arrImageNames.push( "Sprite_C_1" );
							arrImageNames.push( "Sprite_C_2" );
							arrImageNames.push( "Sprite_C_3" );
							arrImageNames.push( "Sprite_C_4" );
							arrImageNames.push( "Sprite_C_5" );
							arrImageNames.push( "Sprite_C_6" );
							arrImageNames.push( "Sprite_C_7" );
							arrImageNames.push( "Sprite_C_8" );
							arrImageNames.push( "Sprite_C_9" );
							arrImageNames.push( "Sprite_C_1" );
							arrImageNames.push( "Sprite_C_2" );
							arrImageNames.push( "Sprite_C_3" );
							arrImageNames.push( "Sprite_C_4" );
							arrImageNames.push( "Sprite_C_5" );
							arrImageNames.push( "Sprite_C_6" );
							arrImageNames.push( "Sprite_C_7" );
							arrImageNames.push( "Sprite_C_8" );
							arrImageNames.push( "Sprite_C_9" );
							break;
						
						default:
							arrImageNames.push( "Sprite_C" );
							arrImageNames.push( "Sprite_C" );
							arrImageNames.push( "Sprite_C_1" );
							arrImageNames.push( "Sprite_C_1" );
							arrImageNames.push( "Sprite_C_2" );
							arrImageNames.push( "Sprite_C_2" );
							arrImageNames.push( "Sprite_C_3" );	
							arrImageNames.push( "Sprite_C_2" );
							arrImageNames.push( "Sprite_C_2" );
							arrImageNames.push( "Sprite_C_1" );
							arrImageNames.push( "Sprite_C_1" );
							arrImageNames.push( "Sprite_C" );
							arrImageNames.push( "Sprite_C" );
							break;
					}
					break;
				
				case "Sprite_D":
					switch( gameID )
					{
						case 29: // Emerald Eruption
							arrImageNames.push( "Transparent" );
							break
						
						default:
							arrImageNames.push( "Sprite_D_1" );
							arrImageNames.push( "Sprite_D_2" );
							arrImageNames.push( "Sprite_D_3" );
							arrImageNames.push( "Sprite_D_4" );
							arrImageNames.push( "Sprite_D_5" );
							arrImageNames.push( "Sprite_D_6" );
							arrImageNames.push( "Sprite_D_7" );
							arrImageNames.push( "Sprite_D_8" );
							arrImageNames.push( "Sprite_D_1" );
							arrImageNames.push( "Transparent" );							
							break;
					}
					break;
				
				case "Sprite_E":
					switch( gameID )
					{
						case 23: // Lucky Ducky
						case 25: // Medusa's Treasure
						case 26: // Shark Attack
						case 30: // Atlantis
							arrImageNames.push( "Sprite_E" );
							arrImageNames.push( "Sprite_E_1" );
							arrImageNames.push( "Sprite_E_2" );
							arrImageNames.push( "Sprite_E_3" );
							arrImageNames.push( "Sprite_E_4" );
							arrImageNames.push( "Sprite_E_5" );
							arrImageNames.push( "Sprite_E_6" );
							arrImageNames.push( "Sprite_E_5" );
							arrImageNames.push( "Sprite_E_4" );
							arrImageNames.push( "Sprite_E_3" );
							arrImageNames.push( "Sprite_E_2" );
							arrImageNames.push( "Sprite_E_1" );
							arrImageNames.push( "Sprite_E" );
							break;
						
						case 1: // Pirate's Booty
						case 4: // Haunted Mansion
						case 5: // Wild West
						case 6: // Flmaing 7's
						case 7: // Rock Star
						case 12: // Tiki Treasure
						case 13: // Golden Horshoe
						case 14: // Neptune's Trident
						case 22: // Oil Tycoon
							arrImageNames.push( "Sprite_E" );
							arrImageNames.push( "Sprite_E_1" );
							arrImageNames.push( "Sprite_E_2" );
							arrImageNames.push( "Sprite_E_3" );	
							arrImageNames.push( "Sprite_E_3" );
							arrImageNames.push( "Sprite_E_2" );
							arrImageNames.push( "Sprite_E_1" );
							arrImageNames.push( "Sprite_E" );							
							break;
						
						case 29: // Emerald Eruption
							arrImageNames.push( "Sprite_E_1" );
							arrImageNames.push( "Sprite_E_2" );
							arrImageNames.push( "Sprite_E_3" );
							arrImageNames.push( "Sprite_E_4" );
							arrImageNames.push( "Sprite_E_5" );
							arrImageNames.push( "Sprite_E_6" );
							arrImageNames.push( "Sprite_E_7" );
							arrImageNames.push( "Sprite_E_8" );
							arrImageNames.push( "Sprite_E_9" );
							arrImageNames.push( "Sprite_E_10" );
							arrImageNames.push( "Sprite_E_11" );
							arrImageNames.push( "Sprite_E_12" );
							arrImageNames.push( "Sprite_E_13" );
							arrImageNames.push( "Sprite_E_14" );
							arrImageNames.push( "Sprite_E_15" );
							break;
							
						default:
							arrImageNames.push( "Sprite_E" );
							arrImageNames.push( "Sprite_E" );
							arrImageNames.push( "Sprite_E_1" );
							arrImageNames.push( "Sprite_E_1" );
							arrImageNames.push( "Sprite_E_2" );
							arrImageNames.push( "Sprite_E_2" );
							arrImageNames.push( "Sprite_E_3" );	
							arrImageNames.push( "Sprite_E_2" );
							arrImageNames.push( "Sprite_E_2" );
							arrImageNames.push( "Sprite_E_1" );
							arrImageNames.push( "Sprite_E_1" );
							arrImageNames.push( "Sprite_E" );
							arrImageNames.push( "Sprite_E" );
							break;
					}
					break;	
				
				case "ReelIcon_A":
					switch( gameID )
					{
						case 22: // Oil Tycoon
						case 23: // Lucky Ducky
							arrImageNames.push( "ReelIcon_A_1" );
							arrImageNames.push( "ReelIcon_A_2" );
							arrImageNames.push( "ReelIcon_A_3" );
							arrImageNames.push( "ReelIcon_A_4" );
							arrImageNames.push( "ReelIcon_A_5" );
							arrImageNames.push( "ReelIcon_A_6" );
							arrImageNames.push( "ReelIcon_A_7" );
							arrImageNames.push( "ReelIcon_A_8" );						
							break;
						
						case 26: // Shark Attack
							arrImageNames.push( "ReelIcon_A" );
							arrImageNames.push( "ReelIcon_A_1" );
							arrImageNames.push( "ReelIcon_A_2" );
							arrImageNames.push( "ReelIcon_A_3" );
							arrImageNames.push( "ReelIcon_A_4" );
							arrImageNames.push( "ReelIcon_A_5" );
							arrImageNames.push( "ReelIcon_A_6" );
							arrImageNames.push( "ReelIcon_A_7" );
							arrImageNames.push( "ReelIcon_A_8" );
							arrImageNames.push( "ReelIcon_A_9" );
							arrImageNames.push( "ReelIcon_A_10" );
							arrImageNames.push( "ReelIcon_A_11" );
							break;
						
						case 27: // Mayan Money
							arrImageNames.push( "ReelIcon_A" );
							arrImageNames.push( "ReelIcon_A_1" );
							arrImageNames.push( "ReelIcon_A_2" );
							arrImageNames.push( "ReelIcon_A_3" );
							arrImageNames.push( "ReelIcon_A_4" );
							arrImageNames.push( "ReelIcon_A_5" );
							arrImageNames.push( "ReelIcon_A_6" );
							break;
						
						case 28: // Mummy's Money
						case 30: // Atlantis							
							arrImageNames.push( "ReelIcon_A" );
							break;
						
						default:
							arrImageNames.push( "ReelIcon_A" );
							arrImageNames.push( "ReelIcon_A_1" );
							arrImageNames.push( "ReelIcon_A_2" );
							arrImageNames.push( "ReelIcon_A_3" );
							arrImageNames.push( "ReelIcon_A_4" );
							arrImageNames.push( "ReelIcon_A_5" );
							arrImageNames.push( "ReelIcon_A_6" );
							arrImageNames.push( "ReelIcon_A_7" );
							arrImageNames.push( "ReelIcon_A_8" );
							arrImageNames.push( "ReelIcon_A_9" );
							arrImageNames.push( "ReelIcon_A_10" );
							arrImageNames.push( "ReelIcon_A_11" );
							arrImageNames.push( "ReelIcon_A_12" );							
							break;
					}
					break;
				
				case "ReelIcon_A1":
				case "ReelIcon_A2":
				case "ReelIcon_A3":
				case "ReelIcon_A4":
					switch( gameID )
					{
						case 28: // Mummy's Money
							arrImageNames.push( animation );
					}
					break;
				
				case "ReelIcon_A_Vertical":
					switch( gameID )
					{
						case 23: // Lucky Ducky
							arrImageNames.push( "ReelIcon_A_Vertical" );
							arrImageNames.push( "ReelIcon_A_Vertical_1" );
							arrImageNames.push( "ReelIcon_A_Vertical_2" );
							arrImageNames.push( "ReelIcon_A_Vertical_3" );
							arrImageNames.push( "ReelIcon_A_Vertical_4" );
							arrImageNames.push( "ReelIcon_A_Vertical_5" );
							arrImageNames.push( "ReelIcon_A_Vertical_6" );
							arrImageNames.push( "ReelIcon_A_Vertical_7" );
							break;
						
						default:
							arrImageNames.push( "ReelIcon_A_Vertical" );
							arrImageNames.push( "ReelIcon_A_Vertical_1" );
							arrImageNames.push( "ReelIcon_A_Vertical_2" );
							arrImageNames.push( "ReelIcon_A_Vertical_3" );
							arrImageNames.push( "ReelIcon_A_Vertical_4" );
							arrImageNames.push( "ReelIcon_A_Vertical_5" );
							arrImageNames.push( "ReelIcon_A_Vertical_6" );
							arrImageNames.push( "ReelIcon_A_Vertical_7" );
							arrImageNames.push( "ReelIcon_A_Vertical_8" );
							arrImageNames.push( "ReelIcon_A_Vertical_9" );
							arrImageNames.push( "ReelIcon_A_Vertical_10" );
							arrImageNames.push( "ReelIcon_A_Vertical_11" );
							arrImageNames.push( "ReelIcon_A_Vertical_12" );
							break;
					}
					break;
				
				case "ReelIcon_A_Vertical_NonWin_Top":
					switch( gameID )
					{
						case 23: // Lucky Ducky
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top_1" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top_2" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top_3" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top_4" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top_5" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top_6" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top_7" );
							break;						
						
						case 26: // Shark Attack
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_1" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_2" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_3" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_4" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_5" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_6" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_7" );							
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_8" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_9" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_10" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_11" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_12" );
							break;	
						
						default:
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top_1" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top_2" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top_3" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top_4" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Top_5" );
							break;
					}
					break;
				
				case "ReelIcon_A_Vertical_NonWin":
					switch( gameID )
					{
						case 23: // Lucky Ducky
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_1" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_2" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_3" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_4" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_5" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_6" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_7" );
							break;
						
						case 26: // Shark Attack
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_1" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_2" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_3" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_4" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_5" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_6" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_7" );							
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_8" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_9" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_10" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_11" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_12" );
							break;						
						
						default:
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_1" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_2" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_3" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_4" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_5" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_6" );
							break;
					}
					break;
				
				case "ReelIcon_A_Vertical_NonWin_Bottom":
					switch( gameID )
					{
						case 23: // Lucky Ducky
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom_1" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom_2" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom_3" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom_4" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom_5" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom_6" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom_7" );
							break;
						
						case 26: // Shark Attack
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_1" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_2" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_3" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_4" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_5" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_6" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_7" );							
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_8" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_9" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_10" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_11" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_12" );
							break;	
						
						default:
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom_1" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom_2" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom_3" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom_4" );
							arrImageNames.push( "ReelIcon_A_Vertical_NonWin_Bottom_5" );
							break;
					}
					break;
				
				case "ReelIcon_B":
					switch( gameID )
					{
						case 21: // Cherry Bomb
						case 23: // Lucky Ducky
						case 25: // Medusa's Treasure
						case 26: // Shark Attack
						case 29: // Emerald Eruption
							arrImageNames.push( "ReelIcon_B" );
							arrImageNames.push( "ReelIcon_B_1" );
							arrImageNames.push( "ReelIcon_B_2" );
							arrImageNames.push( "ReelIcon_B_3" );
							arrImageNames.push( "ReelIcon_B_4" );
							arrImageNames.push( "ReelIcon_B_5" );
							arrImageNames.push( "ReelIcon_B_6" );
							arrImageNames.push( "ReelIcon_B_7" );
							arrImageNames.push( "ReelIcon_B_8" );
							arrImageNames.push( "ReelIcon_B_9" );
							arrImageNames.push( "ReelIcon_B_10" );
							arrImageNames.push( "ReelIcon_B_11" );
							arrImageNames.push( "ReelIcon_B_12" );
							break;
						
						case 27: // Mayan Money	
							arrImageNames.push( "ReelIcon_B" );
							arrImageNames.push( "ReelIcon_B_1" );
							arrImageNames.push( "ReelIcon_B_2" );
							arrImageNames.push( "ReelIcon_B_3" );
							arrImageNames.push( "ReelIcon_B_4" );
							arrImageNames.push( "ReelIcon_B_5" );
							arrImageNames.push( "ReelIcon_B_6" );
							break;
						
						case 28: // Mummy's Money
						case 30: // Atlantis							
							arrImageNames.push( "ReelIcon_B" );
							break;						
						
						case 22: // Oil Tycoon
							arrImageNames.push( "ReelIcon_B_1" );
							arrImageNames.push( "ReelIcon_B_2" );
							arrImageNames.push( "ReelIcon_B_3" );
							arrImageNames.push( "ReelIcon_B_4" );
							arrImageNames.push( "ReelIcon_B_5" );
							arrImageNames.push( "ReelIcon_B_6" );
							arrImageNames.push( "ReelIcon_B_7" );
							arrImageNames.push( "ReelIcon_B_8" );
							arrImageNames.push( "ReelIcon_B_9" );	
							break;						
						
						default:
							arrImageNames.push( "ReelIcon_B" );
							arrImageNames.push( "ReelIcon_B_1" );
							arrImageNames.push( "ReelIcon_B_2" );
							arrImageNames.push( "ReelIcon_B_3" );
							arrImageNames.push( "ReelIcon_B_4" );
							arrImageNames.push( "ReelIcon_B_5" );
							arrImageNames.push( "ReelIcon_B_6" );
							arrImageNames.push( "ReelIcon_B_7" );
							arrImageNames.push( "ReelIcon_B_8" );								
							break;
					}				
					break;
				
				case "ReelIcon_C":
					switch( gameID )
					{
						case 21: // Cherry Bomb
						case 23: // Lucky Ducky
						case 25: // Medusa's Treasure
						case 26: // Shark Attack
						case 29: // Emerald Eruption
							arrImageNames.push( "ReelIcon_C" );
							arrImageNames.push( "ReelIcon_C_1" );
							arrImageNames.push( "ReelIcon_C_2" );
							arrImageNames.push( "ReelIcon_C_3" );
							arrImageNames.push( "ReelIcon_C_4" );
							arrImageNames.push( "ReelIcon_C_5" );
							arrImageNames.push( "ReelIcon_C_6" );
							arrImageNames.push( "ReelIcon_C_7" );
							arrImageNames.push( "ReelIcon_C_8" );	
							arrImageNames.push( "ReelIcon_C_9" );
							arrImageNames.push( "ReelIcon_C_10" );
							arrImageNames.push( "ReelIcon_C_11" );
							arrImageNames.push( "ReelIcon_C_12" );
							break;
						
						case 27: // Mayan Money	
							arrImageNames.push( "ReelIcon_C" );
							arrImageNames.push( "ReelIcon_C_1" );
							arrImageNames.push( "ReelIcon_C_2" );
							arrImageNames.push( "ReelIcon_C_3" );
							arrImageNames.push( "ReelIcon_C_4" );
							arrImageNames.push( "ReelIcon_C_5" );
							arrImageNames.push( "ReelIcon_C_6" );
							break;	
						
						case 28: // Mummy's Money
						case 30: // Atlantis							
							arrImageNames.push( "ReelIcon_C" );
							break;						
						
						case 22: // Oil Tycoon
							arrImageNames.push( "ReelIcon_C_1" );
							arrImageNames.push( "ReelIcon_C_2" );
							arrImageNames.push( "ReelIcon_C_3" );
							arrImageNames.push( "ReelIcon_C_4" );
							arrImageNames.push( "ReelIcon_C_5" );
							arrImageNames.push( "ReelIcon_C_6" );
							arrImageNames.push( "ReelIcon_C_7" );
							arrImageNames.push( "ReelIcon_C_8" );						
							break;						
						
						default:
							arrImageNames.push( "ReelIcon_C" );
							arrImageNames.push( "ReelIcon_C_1" );
							arrImageNames.push( "ReelIcon_C_2" );
							arrImageNames.push( "ReelIcon_C_3" );
							arrImageNames.push( "ReelIcon_C_4" );
							arrImageNames.push( "ReelIcon_C_5" );
							arrImageNames.push( "ReelIcon_C_6" );
							arrImageNames.push( "ReelIcon_C_7" );
							arrImageNames.push( "ReelIcon_C_8" );								
							break;
					}									
					break;
				
				case "ReelIcon_D":
					switch( gameID )
					{
						case 21: // Cherry Bomb
							arrImageNames.push( "ReelIcon_D" );
							arrImageNames.push( "ReelIcon_D_1" );
							arrImageNames.push( "ReelIcon_D_2" );
							arrImageNames.push( "ReelIcon_D_3" );
							arrImageNames.push( "ReelIcon_D_4" );
							arrImageNames.push( "ReelIcon_D_5" );
							arrImageNames.push( "ReelIcon_D_5" );
							arrImageNames.push( "ReelIcon_D_5" );
							break;
						
						case 22: // Oil Tycoon
							arrImageNames.push( "ReelIcon_D_1" );
							arrImageNames.push( "ReelIcon_D_2" );
							arrImageNames.push( "ReelIcon_D_3" );
							arrImageNames.push( "ReelIcon_D_4" );
							arrImageNames.push( "ReelIcon_D_5" );
							arrImageNames.push( "ReelIcon_D_6" );
							arrImageNames.push( "ReelIcon_D_7" );
							arrImageNames.push( "ReelIcon_D_8" );						
							break;						
						
						case 23: // Lucky Ducky
						case 25: // Medusa's Treasure
							arrImageNames.push( "ReelIcon_D" );
							arrImageNames.push( "ReelIcon_D_1" );
							arrImageNames.push( "ReelIcon_D_2" );
							arrImageNames.push( "ReelIcon_D_3" );
							arrImageNames.push( "ReelIcon_D_4" );
							arrImageNames.push( "ReelIcon_D_5" );
							arrImageNames.push( "ReelIcon_D_6" );
							arrImageNames.push( "ReelIcon_D_7" );
							arrImageNames.push( "ReelIcon_D_8" );
							arrImageNames.push( "ReelIcon_D_9" );
							arrImageNames.push( "ReelIcon_D_10" );
							arrImageNames.push( "ReelIcon_D_11" );
							arrImageNames.push( "ReelIcon_D_12" );
							arrImageNames.push( "ReelIcon_D" );
							break;
						
						case 26: // Shark Attack
						case 29: // Emerald Eruption
							arrImageNames.push( "ReelIcon_D" );
							arrImageNames.push( "ReelIcon_D_1" );
							arrImageNames.push( "ReelIcon_D_2" );
							arrImageNames.push( "ReelIcon_D_3" );
							arrImageNames.push( "ReelIcon_D_4" );
							arrImageNames.push( "ReelIcon_D_5" );
							arrImageNames.push( "ReelIcon_D_6" );
							arrImageNames.push( "ReelIcon_D_7" );
							arrImageNames.push( "ReelIcon_D_8" );
							arrImageNames.push( "ReelIcon_D_9" );
							arrImageNames.push( "ReelIcon_D_10" );
							arrImageNames.push( "ReelIcon_D_11" );
							arrImageNames.push( "ReelIcon_D_12" );
							break;
						
						case 27: // Mayan Money	
							arrImageNames.push( "ReelIcon_D" );
							arrImageNames.push( "ReelIcon_D_1" );
							arrImageNames.push( "ReelIcon_D_2" );
							arrImageNames.push( "ReelIcon_D_3" );
							arrImageNames.push( "ReelIcon_D_4" );
							arrImageNames.push( "ReelIcon_D_5" );
							arrImageNames.push( "ReelIcon_D_6" );
							break;
						
						case 28: // Mummy's Money
						case 30: // Atlantis							
							arrImageNames.push( "ReelIcon_D" );
							break;						
						
						default:
							arrImageNames.push( "ReelIcon_D" );
							arrImageNames.push( "ReelIcon_D_1" );
							arrImageNames.push( "ReelIcon_D_2" );
							arrImageNames.push( "ReelIcon_D_3" );
							arrImageNames.push( "ReelIcon_D_4" );								
							break;
					}								
					break;
				
				case "ReelIcon_E":
					switch( gameID )
					{
						case 21: // Cherry Bomb
							arrImageNames.push( "ReelIcon_E" );
							arrImageNames.push( "ReelIcon_E_1" );
							arrImageNames.push( "ReelIcon_E_2" );
							arrImageNames.push( "ReelIcon_E_3" );
							arrImageNames.push( "ReelIcon_E_4" );
							arrImageNames.push( "ReelIcon_E_5" );
							arrImageNames.push( "ReelIcon_E_6" );
							arrImageNames.push( "ReelIcon_E_6" );
							arrImageNames.push( "ReelIcon_E_6" );
							break;
						
						case 22: // Oil Tycoon
							arrImageNames.push( "ReelIcon_E_1" );
							arrImageNames.push( "ReelIcon_E_2" );
							arrImageNames.push( "ReelIcon_E_3" );
							arrImageNames.push( "ReelIcon_E_4" );
							arrImageNames.push( "ReelIcon_E_5" );
							arrImageNames.push( "ReelIcon_E_6" );
							arrImageNames.push( "ReelIcon_E_7" );
							arrImageNames.push( "ReelIcon_E_8" );						
							break;						
						
						case 23: // Lucky Ducky
						case 25: // Medusa's Treasure
							arrImageNames.push( "ReelIcon_E" );
							arrImageNames.push( "ReelIcon_E_1" );
							arrImageNames.push( "ReelIcon_E_2" );
							arrImageNames.push( "ReelIcon_E_3" );
							arrImageNames.push( "ReelIcon_E_4" );
							arrImageNames.push( "ReelIcon_E_5" );
							arrImageNames.push( "ReelIcon_E_6" );
							arrImageNames.push( "ReelIcon_E_7" );
							arrImageNames.push( "ReelIcon_E_8" );
							arrImageNames.push( "ReelIcon_E_9" );
							arrImageNames.push( "ReelIcon_E_10" );
							arrImageNames.push( "ReelIcon_E_11" );
							arrImageNames.push( "ReelIcon_E_12" );
							arrImageNames.push( "ReelIcon_E" );
							break;
						
						case 26: // Shark Attack
						case 29: // Emerald Eruption
							arrImageNames.push( "ReelIcon_E" );
							arrImageNames.push( "ReelIcon_E_1" );
							arrImageNames.push( "ReelIcon_E_2" );
							arrImageNames.push( "ReelIcon_E_3" );
							arrImageNames.push( "ReelIcon_E_4" );
							arrImageNames.push( "ReelIcon_E_5" );
							arrImageNames.push( "ReelIcon_E_6" );
							arrImageNames.push( "ReelIcon_E_7" );
							arrImageNames.push( "ReelIcon_E_8" );
							arrImageNames.push( "ReelIcon_E_9" );
							arrImageNames.push( "ReelIcon_E_10" );
							arrImageNames.push( "ReelIcon_E_11" );
							arrImageNames.push( "ReelIcon_E_12" );
							break;
						
						case 27: // Mayan Money	
							arrImageNames.push( "ReelIcon_E" );
							arrImageNames.push( "ReelIcon_E_1" );
							arrImageNames.push( "ReelIcon_E_2" );
							arrImageNames.push( "ReelIcon_E_3" );
							arrImageNames.push( "ReelIcon_E_4" );
							arrImageNames.push( "ReelIcon_E_5" );
							arrImageNames.push( "ReelIcon_E_6" );
							break;	
						
						case 28: // Mummy's Money
						case 30: // Atlantis							
							arrImageNames.push( "ReelIcon_E" );
							break;						
						
						default:
							arrImageNames.push( "ReelIcon_E" );
							arrImageNames.push( "ReelIcon_E_1" );
							arrImageNames.push( "ReelIcon_E_2" );
							arrImageNames.push( "ReelIcon_E_3" );
							arrImageNames.push( "ReelIcon_E_4" );									
							break;
					}							
					break;
				
				case "ReelIcon_F":
					switch( gameID )
					{
						case 21: // Cherry Bomb
							arrImageNames.push( "ReelIcon_F" );
							arrImageNames.push( "ReelIcon_F_1" );
							arrImageNames.push( "ReelIcon_F_2" );
							arrImageNames.push( "ReelIcon_F_3" );
							arrImageNames.push( "ReelIcon_F_4" );
							arrImageNames.push( "ReelIcon_F_5" );	
							arrImageNames.push( "ReelIcon_F_6" );	
							arrImageNames.push( "ReelIcon_F_6" );	
							arrImageNames.push( "ReelIcon_F_6" );	
							break;
						
						case 22: // Oil Tycoon
							arrImageNames.push( "ReelIcon_F_1" );
							arrImageNames.push( "ReelIcon_F_2" );
							arrImageNames.push( "ReelIcon_F_3" );
							arrImageNames.push( "ReelIcon_F_4" );
							arrImageNames.push( "ReelIcon_F_5" );
							arrImageNames.push( "ReelIcon_F_6" );
							arrImageNames.push( "ReelIcon_F_7" );
							arrImageNames.push( "ReelIcon_F_8" );						
							break;						
						
						case 23: // Lucky Ducky
						case 25: // Medusa's Treasure
							arrImageNames.push( "ReelIcon_F" );
							arrImageNames.push( "ReelIcon_F_1" );
							arrImageNames.push( "ReelIcon_F_2" );
							arrImageNames.push( "ReelIcon_F_3" );
							arrImageNames.push( "ReelIcon_F_4" );
							arrImageNames.push( "ReelIcon_F_5" );	
							arrImageNames.push( "ReelIcon_F_6" );	
							arrImageNames.push( "ReelIcon_F_7" );	
							arrImageNames.push( "ReelIcon_F_8" );
							arrImageNames.push( "ReelIcon_F_9" );
							arrImageNames.push( "ReelIcon_F_10" );
							arrImageNames.push( "ReelIcon_F_11" );
							arrImageNames.push( "ReelIcon_F_12" );
							arrImageNames.push( "ReelIcon_F" );
							break;
						
						case 26: // Shark Attack
						case 29: // Emerald Eruption
							arrImageNames.push( "ReelIcon_F" );
							arrImageNames.push( "ReelIcon_F_1" );
							arrImageNames.push( "ReelIcon_F_2" );
							arrImageNames.push( "ReelIcon_F_3" );
							arrImageNames.push( "ReelIcon_F_4" );
							arrImageNames.push( "ReelIcon_F_5" );	
							arrImageNames.push( "ReelIcon_F_6" );	
							arrImageNames.push( "ReelIcon_F_7" );	
							arrImageNames.push( "ReelIcon_F_8" );
							arrImageNames.push( "ReelIcon_F_9" );
							arrImageNames.push( "ReelIcon_F_10" );
							arrImageNames.push( "ReelIcon_F_11" );
							arrImageNames.push( "ReelIcon_F_12" );
							break;
						
						case 27: // Mayan Money	
							arrImageNames.push( "ReelIcon_F" );
							arrImageNames.push( "ReelIcon_F_1" );
							arrImageNames.push( "ReelIcon_F_2" );
							arrImageNames.push( "ReelIcon_F_3" );
							arrImageNames.push( "ReelIcon_F_4" );
							arrImageNames.push( "ReelIcon_F_5" );	
							arrImageNames.push( "ReelIcon_F_6" );	
							break;
						
						case 28: // Mummy's Money
						case 30: // Atlantis							
							arrImageNames.push( "ReelIcon_F" );
							break;						
						
						default:
							arrImageNames.push( "ReelIcon_F" );
							arrImageNames.push( "ReelIcon_F_1" );
							arrImageNames.push( "ReelIcon_F_2" );
							arrImageNames.push( "ReelIcon_F_3" );
							arrImageNames.push( "ReelIcon_F_4" );							
							break;
					}									
					break;
				
				case "ReelIcon_G":
					switch( gameID )
					{
						case 21: // Cherry Bomb
							arrImageNames.push( "ReelIcon_G" );
							arrImageNames.push( "ReelIcon_G_1" );
							arrImageNames.push( "ReelIcon_G_2" );
							arrImageNames.push( "ReelIcon_G_3" );
							arrImageNames.push( "ReelIcon_G_4" );
							arrImageNames.push( "ReelIcon_G_5" );
							arrImageNames.push( "ReelIcon_G_6" );
							arrImageNames.push( "ReelIcon_G_6" );
							arrImageNames.push( "ReelIcon_G_6" );
							break;
						
						case 22: // Oil Tycoon
							arrImageNames.push( "ReelIcon_G_1" );
							arrImageNames.push( "ReelIcon_G_2" );
							arrImageNames.push( "ReelIcon_G_3" );
							arrImageNames.push( "ReelIcon_G_4" );
							arrImageNames.push( "ReelIcon_G_5" );
							arrImageNames.push( "ReelIcon_G_6" );
							arrImageNames.push( "ReelIcon_G_7" );
							arrImageNames.push( "ReelIcon_G_8" );						
							break;						
						
						case 23: // Lucky Ducky
						case 25: // Medusa's Treasure
							arrImageNames.push( "ReelIcon_G" );
							arrImageNames.push( "ReelIcon_G_1" );
							arrImageNames.push( "ReelIcon_G_2" );
							arrImageNames.push( "ReelIcon_G_3" );
							arrImageNames.push( "ReelIcon_G_4" );
							arrImageNames.push( "ReelIcon_G_5" );
							arrImageNames.push( "ReelIcon_G_6" );
							arrImageNames.push( "ReelIcon_G_7" );
							arrImageNames.push( "ReelIcon_G_8" );
							arrImageNames.push( "ReelIcon_G_9" );
							arrImageNames.push( "ReelIcon_G_10" );
							arrImageNames.push( "ReelIcon_G_11" );
							arrImageNames.push( "ReelIcon_G_12" );
							arrImageNames.push( "ReelIcon_G" );
							break;
						
						case 26: // Shark Attack
						case 29: // Emerald Eruption
							arrImageNames.push( "ReelIcon_G" );
							arrImageNames.push( "ReelIcon_G_1" );
							arrImageNames.push( "ReelIcon_G_2" );
							arrImageNames.push( "ReelIcon_G_3" );
							arrImageNames.push( "ReelIcon_G_4" );
							arrImageNames.push( "ReelIcon_G_5" );
							arrImageNames.push( "ReelIcon_G_6" );
							arrImageNames.push( "ReelIcon_G_7" );
							arrImageNames.push( "ReelIcon_G_8" );
							arrImageNames.push( "ReelIcon_G_9" );
							arrImageNames.push( "ReelIcon_G_10" );
							arrImageNames.push( "ReelIcon_G_11" );
							arrImageNames.push( "ReelIcon_G_12" );
							break;
						
						case 27: // Mayan Money	
							arrImageNames.push( "ReelIcon_G" );
							arrImageNames.push( "ReelIcon_G_1" );
							arrImageNames.push( "ReelIcon_G_2" );
							arrImageNames.push( "ReelIcon_G_3" );
							arrImageNames.push( "ReelIcon_G_4" );
							arrImageNames.push( "ReelIcon_G_5" );
							arrImageNames.push( "ReelIcon_G_6" );
							break;
						
						case 28: // Mummy's Money
						case 30: // Atlantis							
							arrImageNames.push( "ReelIcon_G" );
							break;						
						
						default:
							arrImageNames.push( "ReelIcon_G" );
							arrImageNames.push( "ReelIcon_G_1" );
							arrImageNames.push( "ReelIcon_G_2" );
							arrImageNames.push( "ReelIcon_G_3" );
							arrImageNames.push( "ReelIcon_G_4" );							
							break;
					}														
					break;
				
				case "ReelIcon_H":
					switch( gameID )
					{
						case 21: // Cherry Bomb
						case 23: // Lucky Ducky
						case 25: // Medusa's Treasure
							arrImageNames.push( "ReelIcon_H" );
							arrImageNames.push( "ReelIcon_H_1" );
							arrImageNames.push( "ReelIcon_H_2" );
							arrImageNames.push( "ReelIcon_H_3" );
							arrImageNames.push( "ReelIcon_H_4" );
							arrImageNames.push( "ReelIcon_H_5" );
							arrImageNames.push( "ReelIcon_H_6" );
							arrImageNames.push( "ReelIcon_H_7" );
							arrImageNames.push( "ReelIcon_H_8" );
							break;
						
						case 26: // Shark Attack
						case 29: // Emerald Eruption
							arrImageNames.push( "ReelIcon_H" );
							arrImageNames.push( "ReelIcon_H_1" );
							arrImageNames.push( "ReelIcon_H_2" );
							arrImageNames.push( "ReelIcon_H_3" );
							arrImageNames.push( "ReelIcon_H_4" );
							arrImageNames.push( "ReelIcon_H_5" );
							arrImageNames.push( "ReelIcon_H_6" );
							arrImageNames.push( "ReelIcon_H_7" );
							arrImageNames.push( "ReelIcon_H_8" );							
							arrImageNames.push( "ReelIcon_H_9" );
							arrImageNames.push( "ReelIcon_H_10" );
							arrImageNames.push( "ReelIcon_H_11" );
							arrImageNames.push( "ReelIcon_H_12" );
							break;
						
						case 27: // Mayan Money	
							arrImageNames.push( "ReelIcon_H" );
							arrImageNames.push( "ReelIcon_H_1" );
							arrImageNames.push( "ReelIcon_H_2" );
							arrImageNames.push( "ReelIcon_H_3" );
							arrImageNames.push( "ReelIcon_H_4" );
							arrImageNames.push( "ReelIcon_H_5" );
							arrImageNames.push( "ReelIcon_H_6" );
							break;	
						
						case 28: // Mummy's Money
						case 30: // Atlantis							
							arrImageNames.push( "ReelIcon_H" );
							break;						
						
						default:
							arrImageNames.push( "ReelIcon_H" );
							arrImageNames.push( "ReelIcon_H_1" );
							arrImageNames.push( "ReelIcon_H_2" );
							arrImageNames.push( "ReelIcon_H_3" );
							arrImageNames.push( "ReelIcon_H_4" );							
							break;
					}								
					break;
				
				case "ReelIcon_I":
					switch( gameID )
					{
						case 21: // Cherry Bomb
							arrImageNames.push( "ReelIcon_I" );
							arrImageNames.push( "ReelIcon_I_1" );
							arrImageNames.push( "ReelIcon_I_2" );
							arrImageNames.push( "ReelIcon_I_3" );
							arrImageNames.push( "ReelIcon_I_4" );	
							arrImageNames.push( "ReelIcon_I_5" );
							arrImageNames.push( "ReelIcon_I_6" );
							arrImageNames.push( "ReelIcon_I_7" );						
							break;
						
						case 23: // Lucky Ducky
						case 25: // Medusa's Treasure
							arrImageNames.push( "ReelIcon_I" );
							arrImageNames.push( "ReelIcon_I_1" );
							arrImageNames.push( "ReelIcon_I_2" );
							arrImageNames.push( "ReelIcon_I_3" );
							arrImageNames.push( "ReelIcon_I_4" );	
							arrImageNames.push( "ReelIcon_I_5" );
							arrImageNames.push( "ReelIcon_I_6" );
							arrImageNames.push( "ReelIcon_I_7" );
							arrImageNames.push( "ReelIcon_I_8" );
							break;
						
						case 26: // Shark Attack
						case 29: // Emerald Eruption
							arrImageNames.push( "ReelIcon_I" );
							arrImageNames.push( "ReelIcon_I_1" );
							arrImageNames.push( "ReelIcon_I_2" );
							arrImageNames.push( "ReelIcon_I_3" );
							arrImageNames.push( "ReelIcon_I_4" );	
							arrImageNames.push( "ReelIcon_I_5" );
							arrImageNames.push( "ReelIcon_I_6" );
							arrImageNames.push( "ReelIcon_I_7" );
							arrImageNames.push( "ReelIcon_I_8" );
							arrImageNames.push( "ReelIcon_I_9" );
							arrImageNames.push( "ReelIcon_I_10" );
							arrImageNames.push( "ReelIcon_I_11" );
							arrImageNames.push( "ReelIcon_I_12" );
							break;
						
						case 27: // Mayan Money	
							arrImageNames.push( "ReelIcon_I" );
							arrImageNames.push( "ReelIcon_I_1" );
							arrImageNames.push( "ReelIcon_I_2" );
							arrImageNames.push( "ReelIcon_I_3" );
							arrImageNames.push( "ReelIcon_I_4" );	
							arrImageNames.push( "ReelIcon_I_5" );
							arrImageNames.push( "ReelIcon_I_6" );
							break;
						
						case 28: // Mummy's Money
						case 30: // Atlantis							
							arrImageNames.push( "ReelIcon_I" );
							break;						
						
						default:
							arrImageNames.push( "ReelIcon_I" );
							arrImageNames.push( "ReelIcon_I_1" );
							arrImageNames.push( "ReelIcon_I_2" );
							arrImageNames.push( "ReelIcon_I_3" );
							arrImageNames.push( "ReelIcon_I_4" );								
							break;
					}														
					break;
				
				case "ReelIcon_J":
					switch( gameID )
					{
						case 21: // Cherry Bomb
							arrImageNames.push( "ReelIcon_J" );
							arrImageNames.push( "ReelIcon_J_1" );
							arrImageNames.push( "ReelIcon_J_2" );
							arrImageNames.push( "ReelIcon_J_3" );
							arrImageNames.push( "ReelIcon_J_2" );
							arrImageNames.push( "ReelIcon_J_1" );
							arrImageNames.push( "ReelIcon_J_2" );
							arrImageNames.push( "ReelIcon_J_1" );
							arrImageNames.push( "ReelIcon_J_2" );							
							arrImageNames.push( "ReelIcon_J_3" );
							arrImageNames.push( "ReelIcon_J_4" );								
							break;
						
						case 23: // Lucky Ducky
						case 25: // Medusa's Treasure
							arrImageNames.push( "ReelIcon_J" );
							arrImageNames.push( "ReelIcon_J_1" );
							arrImageNames.push( "ReelIcon_J_2" );
							arrImageNames.push( "ReelIcon_J_3" );
							arrImageNames.push( "ReelIcon_J_4" );	
							arrImageNames.push( "ReelIcon_J_5" );
							arrImageNames.push( "ReelIcon_J_6" );
							arrImageNames.push( "ReelIcon_J_7" );
							arrImageNames.push( "ReelIcon_J_8" );
							break;
						
						case 26: // Shark Attack
						case 29: // Emerald Eruption
							arrImageNames.push( "ReelIcon_J" );
							arrImageNames.push( "ReelIcon_J_1" );
							arrImageNames.push( "ReelIcon_J_2" );
							arrImageNames.push( "ReelIcon_J_3" );
							arrImageNames.push( "ReelIcon_J_4" );	
							arrImageNames.push( "ReelIcon_J_5" );
							arrImageNames.push( "ReelIcon_J_6" );
							arrImageNames.push( "ReelIcon_J_7" );
							arrImageNames.push( "ReelIcon_J_8" );
							arrImageNames.push( "ReelIcon_J_9" );
							arrImageNames.push( "ReelIcon_J_10" );
							arrImageNames.push( "ReelIcon_J_11" );
							arrImageNames.push( "ReelIcon_J_12" );
							break;
						
						case 27: // Mayan Money	
							arrImageNames.push( "ReelIcon_J" );
							arrImageNames.push( "ReelIcon_J_1" );
							arrImageNames.push( "ReelIcon_J_2" );
							arrImageNames.push( "ReelIcon_J_3" );
							arrImageNames.push( "ReelIcon_J_4" );	
							arrImageNames.push( "ReelIcon_J_5" );
							arrImageNames.push( "ReelIcon_J_6" );
							break;	
						
						case 28: // Mummy's Money
						case 30: // Atlantis							
							arrImageNames.push( "ReelIcon_J" );
							break;						
						
						default:
							arrImageNames.push( "ReelIcon_J" );
							arrImageNames.push( "ReelIcon_J_1" );
							arrImageNames.push( "ReelIcon_J_2" );
							arrImageNames.push( "ReelIcon_J_3" );
							arrImageNames.push( "ReelIcon_J_4" );								
							break;
					}														
					break;
				
				case "ReelIcon_K":
					switch( gameID )
					{
						case 27: // Mayan Money	
							arrImageNames.push( "ReelIcon_K" );
							arrImageNames.push( "ReelIcon_K_1" );
							arrImageNames.push( "ReelIcon_K_2" );
							arrImageNames.push( "ReelIcon_K_3" );
							arrImageNames.push( "ReelIcon_K_4" );
							arrImageNames.push( "ReelIcon_K_5" );
							arrImageNames.push( "ReelIcon_K_6" );
							break;	
						
						case 28: // Mummy's Money
						case 30: // Atlantis
							arrImageNames.push( "ReelIcon_K" );
							break;						
						
						default:
							arrImageNames.push( "ReelIcon_K" );
							arrImageNames.push( "ReelIcon_K_1" );
							arrImageNames.push( "ReelIcon_K_2" );
							arrImageNames.push( "ReelIcon_K_3" );
							arrImageNames.push( "ReelIcon_K_4" );
							arrImageNames.push( "ReelIcon_K_5" );
							arrImageNames.push( "ReelIcon_K_6" );
							arrImageNames.push( "ReelIcon_K_7" );
							arrImageNames.push( "ReelIcon_K_8" );
							arrImageNames.push( "ReelIcon_K_9" );
							arrImageNames.push( "ReelIcon_K_10" );
							arrImageNames.push( "ReelIcon_K_11" );
							arrImageNames.push( "ReelIcon_K_12" );
							break;
					}
					break;
				
				case "ReelIcon_K1":
				case "ReelIcon_K2":
				case "ReelIcon_K3":
				case "ReelIcon_K4":
					switch( gameID )
					{
						case 28: // Mummy's Money
							arrImageNames.push( animation );
							break;
					}
					break;		
				
				case "ReelIcon_x1":
				case "ReelIcon_x2":
				case "ReelIcon_x3":
				case "ReelIcon_x4":
				case "ReelIcon_x5":
				case "ReelIcon_x6":
				case "ReelIcon_x10":
				case "ReelIcon_x25":
				case "ReelIcon_x50":
				case "ReelIcon_x100":
				case "ReelIcon_50":
				case "ReelIcon_100":
				case "ReelIcon_200":
				case "ReelIcon_250":
				case "ReelIcon_400":
				case "ReelIcon_500":
				case "ReelIcon_800":
				case "ReelIcon_1000":
				case "ReelIcon_2000":
				case "ReelIcon_4000":
					switch( gameID )
					{
						case 29: // Emerald Eruption
							arrImageNames.push( animation );
							break;
					}
					break;
				
				case "VideoKenoHit":
					arrImageNames.push( "Hit_1" );
					arrImageNames.push( "Hit_2" );
			}
			
			return arrImageNames;
		}
		
		/**
		 * Constructs an animated image from an array of image names.
		 * @param manager The style manager to load the images from.
		 * @param assetList An array of image names to load.
		 * @param delay How long to wait before starting the animation sequence. 
		 * @param repeatCount How many time to repeat the animation.
		 * @param repeatDelay How long to wait before repeating the animation sequence.
		 * @param reverse If <code>true</code>, plays the animation forward and then backward on each repetition.
		 * @return A ui component containing the animation.
		 */
		public static function getAnimatedImageFromArray( manager:IStyleManager2, assetList:Array, delay:Number, repeatCount:int, repeatDelay:Number = 0, reverse:Boolean = false ):SpriteUIComponent
		{
			var imageArray:Array = new Array();
			
			for( var i:int = 0; i < assetList.length; i++ )
			{
				if( manager != null )
				{
					imageArray.push( SkinManager.getSkinAsset( manager, assetList[i] ) );
				}
				else
				{
					imageArray.push( assetList[i] );
				}
			}
			
			var animatedImage:AnimatedImage = new AnimatedImage( imageArray );			
			animatedImage.start_loop( delay, repeatCount, repeatDelay, reverse );
			
			return new SpriteUIComponent( animatedImage );				
		}
		
		/**
		 * Constructs an animated image.
		 * @param manager The style manager to load the images from.
		 * @param gameID The id of the game we want to load the animation for.
		 * @param animation The name of the animate we want to load.
		 * @param delay How long to wait before starting the animation sequence. 
		 * @param repeatCount How many time to repeat the animation.
		 * @param repeatDelay How long to wait before repeating the animation sequence.
		 * @param reverse If <code>true</code>, plays the animation forward and then backward on each repetition.
		 * @return A ui component containing the animation.
		 */
		public static function getAnimatedImage( manager:IStyleManager2, gameID:int, animation:String, delay:Number, repeatCount:int, repeatDelay:Number = 0, reverse:Boolean = false ):SpriteUIComponent
		{			
			return getAnimatedImageFromArray( manager, getAnimationImages( manager, gameID, animation ), delay, repeatCount, repeatDelay, reverse );
		}			
		
		/**
		 * Constructs an animation targeting a specific item.
		 * @param target The item to animate.
		 * @param property The name of the property on the item to animate.
		 * @param duration How long each repetition of the animation should last.
		 * @param repeatCount How many times to repeat the animation.
		 * @param valueFrom The starting value of the property to animate from.
		 * @param ValueTo The ending value of the property to animate to. 
		 * @param easer An <code>IEaser</code> which controls the animation's easing.
		 * @return An <code>Animation</code>.
		 * @see spark.effects.Animate
		 */
		public static function getAnimatedItem( target:Object, property:String, duration:int, repeatCount:int, valueFrom:int, valueTo:int, easer:IEaser = null ):Animate
		{														
			// Create the motion path
			var simpleMotionPath:SimpleMotionPath = new SimpleMotionPath();
			simpleMotionPath.property = property;
			simpleMotionPath.valueFrom = valueFrom;
			simpleMotionPath.valueTo = valueTo;
			
			// Add the motion path to a Vector
			var vector:Vector.<MotionPath> = new Vector.<MotionPath>();
			vector.push( simpleMotionPath );
			
			// Create the animation
			var animate:Animate = new Animate();
			animate.easer = easer;
			animate.target = target;
			animate.duration = duration;
			animate.repeatCount = repeatCount;
			animate.motionPaths = vector;
			
			return animate;
		}
		
		/**
		 * Constructs a move animation targeting a specific item.
		 * @param target The item to move.
		 * @param xFrom The starting x position of the target to animate from.
		 * @param yFrom The starting y position of the target to animate from.
		 * @param xTo The ending x position of the target to animate to.
		 * @param yTo The ending y position of the target to animate to.
		 * @param duration How long each repetition of the animation should last.
		 * @param startDelay How long to wait before starting the animation.
		 * @param repeatCount How many times to repeat the animation.
		 * @param repeatDelay How long to wait before repeating the animation.
		 * @param easer An <code>IEaser</code> which controls the animation's easing.
		 * @return A <code>Move</code> animation.
		 * @see spark.effects.Move
		 */
		public static function getMoveAnimation( target:Object, xFrom:Number, yFrom:Number, xTo:Number, yTo:Number, duration:Number, startDelay:int, repeatCount:int, repeatDelay:int, easer:IEaser = null ):Move
		{
			var move:Move = new Move();
			move.xFrom = xFrom;
			move.yFrom = yFrom;
			move.xTo = xTo;
			move.yTo = yTo;
			move.duration = duration;
			move.startDelay = startDelay;
			move.repeatCount = repeatCount;
			move.repeatDelay = repeatDelay;	
			move.target = target;
			move.easer = easer;
			
			return move;
		}
		
		/**
		 * Constructs a scale animation targeting a specific item.
		 * @param target The item to scale.
		 * @param xFrom The starting x position of the target to scale from.
		 * @param yFrom The starting y position of the target to scale from.
		 * @param xTo The ending x position of the target to scale to.
		 * @param yTo The ending y position of the target to scale to.
		 * @param duration How long each repetition of the animation should last.
		 * @param startDelay How long to wait before starting the animation.
		 * @param repeatCount How many times to repeat the animation.
		 * @param repeatDelay How long to wait before repeating the animation.
		 * @param easer An <code>IEaser</code> which controls the animation's easing.
		 * @return A <code>Scale</code> animation.
		 * @see spark.effects.Scale
		 */
		public static function getScaleAnimation( target:Object, xFrom:Number, yFrom:Number, xTo:Number, yTo:Number, duration:Number, startDelay:int, repeatCount:int, repeatDelay:int, easer:IEaser = null ):Scale
		{
			var scale:Scale = new Scale();
			scale.scaleXFrom = xFrom;
			scale.scaleYFrom = yFrom;
			scale.scaleXTo = xTo;
			scale.scaleYTo = yTo;
			scale.duration = duration;
			scale.repeatCount = repeatCount;
			scale.repeatDelay = repeatDelay;
			scale.target = target;
			scale.easer = easer;
			
			return scale;
		}
		
		/**
		 * Constructs a fade animation targeting a specific item.
		 * @param target The item to fade.
		 * @param alphaFrom The starting alpha value of the target to fade from.
		 * @param alphaTo The ending alpha value of the target to fade to.
		 * @param duration How long each repetition of the animation should last.
		 * @param startDelay How long to wait before starting the animation.
		 * @param repeatCount How many times to repeat the animation.
		 * @param repeatDelay How long to wait before repeating the animation.
		 * @param easer An <code>IEaser</code> which controls the animation's easing.
		 * @return A <code>Fade</code> animation.
		 * @see spark.effects.Fade
		 */
		public static function getFadeAnimation( target:Object, alphaFrom:Number, alphaTo:Number, duration:Number, startDelay:int = 0, repeatCount:int = 0, repeatDelay:int = 0, easer:IEaser = null ):Fade
		{
			var fade:Fade = new Fade();
			fade.alphaFrom = alphaFrom;
			fade.alphaTo = alphaTo;			
			fade.duration = duration;
			fade.startDelay = startDelay;
			fade.repeatCount = repeatCount;
			fade.repeatDelay = repeatDelay;
			fade.target = target;
			fade.easer = easer;
			
			return fade;
		}
		
		// Constructor
		public function AnimationManager()
		{
		}
	}
}