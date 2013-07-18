package starling.components.VideoKeno
{
	import flash.filters.BitmapFilter;
	
	import interfaces.IDisposable;
	
	import mx.formatters.NumberBase;
	
	import starling.components.ComplexButton;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class VideoKenoNumber extends ComplexButton implements IDisposable
	{
		// UI Components
		private var _label:TextField;
		
		// Gamestate Variables
		private var _isUserSelected:Boolean = false;
		private var _isGameSelected:Boolean = false;
		private var _value:int = 0;
		
		private var _upState:Texture;
		private var _overState:Texture;
		private var _userSelectedState:Texture;
		private var _gameSelectedState:Texture;
		private var _hitState:Texture;

		public function VideoKenoNumber( upState:Texture, value:int, downState:Texture = null, overState:Texture = null, disabledState:Texture = null, userSelectedState:Texture = null, gameSelectedState:Texture = null, hitState:Texture = null )
		{
			super( upState, "", downState, overState, disabledState );
			
			_value = value;
			_userSelectedState = userSelectedState;
			_gameSelectedState = gameSelectedState;
			_hitState = hitState;
			
			_label = new TextField( upState.width, upState.height, value.toString(), "Verdana", 18, 0xFFFFFF );
			_label.nativeFilters = [new flash.filters.DropShadowFilter(1, 45, 0x000000)];
			addChild( _label );
		}
		
		override protected function updateStates():void
		{
			super.updateStates();
			
			if( isHit && _hitState != null )
			{
				upState = _hitState;
			}
			else if( _isUserSelected && _userSelectedState != null )
			{
				upState = _userSelectedState;
			}
			else if( _isGameSelected  && _gameSelectedState != null)
			{
				upState = _gameSelectedState;
			}
			
			if( _isUserSelected || _isGameSelected )
			{
				_label.color = 0x000000;
			}
			else
			{
				_label.color = 0xFFFFFF;
			}
		}
		
		/** The texture that is displayed when the user has selected the button. */
		public function get userSelectedState():Texture 
		{ 
			return _userSelectedState; 
		}
		
		public function set userSelectedState( value:Texture ):void
		{ 
			_userSelectedState = value;
		}
		
		/** The texture that is displayed when the game has selected the button. */
		public function get gameSelectedState():Texture 
		{ 
			return _gameSelectedState; 
		}
		
		public function set gameSelectedState( value:Texture ):void
		{ 
			_gameSelectedState = value;
		}		
		
		/** Whether or not the game has selected this button. */
		public function get isGameSelected():Boolean
		{
			return _isGameSelected;
		}
		
		public function set isGameSelected( value:Boolean ):void
		{
			_isGameSelected = value;
			updateStates();
		}
		
		/** Whether or not the user has selected this button. */
		public function get isUserSelected():Boolean
		{
			return _isUserSelected;
		}
		
		public function set isUserSelected( value:Boolean ):void
		{
			_isUserSelected = value;
			updateStates();
		}
		
		/** The numeric value for this button. */
		public function get value():int
		{
			return _value;
		}
		
		public function set value( value:int ):void
		{
			_value = value;
		}
		
		/** Whether or not both the game and user have selected this button. */
		public function get isHit():Boolean
		{
			return _isGameSelected && _isUserSelected;
		}	
		
		override public function get fontSize():Number
		{
			return _label.fontSize;
		}
		
		override public function set fontSize( value:Number ):void
		{
			_label.fontSize = value;
		}
	}
}