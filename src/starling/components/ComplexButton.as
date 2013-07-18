package starling.components
{
	import flash.geom.Rectangle;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * The ComplexButton
	 * Adds additional states to the Starling BUtton class.
	 * 
	 * Based on The HoverButton Class by Tony Downey
	 */
	public class ComplexButton extends Button 
	{	
		private static const MAX_DRAG_DIST:int = 50;
		
		private var _upState:Texture;
		private var _overState:Texture;
		private var _disabledState:Texture;
		private var _isOver:Boolean;
		private var _isDown:Boolean;
		
		public function ComplexButton( upState:Texture, text:String = "", downState:Texture = null, overState:Texture = null, disabledState:Texture = null ) 
		{
			super( upState, text, downState );
			
			_upState = upState;
			_overState = overState;
			_disabledState = disabledState;
			alphaWhenDisabled = disabledState ? 1 : alphaWhenDisabled;
			
			addEventListener( TouchEvent.TOUCH, onTouch );
			addEventListener( TouchEvent.TOUCH, onTouchCheckHover );
		}
		
		protected function onTouch( e:TouchEvent ):void
		{
			var touch:Touch = e.getTouch( this );
			if( !enabled || touch == null ) { return; }
			
			if( touch.phase == starling.events.TouchPhase.BEGAN && !_isDown ) 
			{ 
				isDown = true; 
			}
			else if( touch.phase == TouchPhase.MOVED && _isDown )
			{
				// reset button when user dragged too far away after pushing
				var buttonRect:Rectangle = getBounds(stage);
				if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
					touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
					touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
					touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
				{
					isDown = false;
				}
			}
			else if ( touch.phase == TouchPhase.ENDED && _isDown )
			{
				isDown = false;
			}
		}
		
		/** Checks if there is a parent, an overState, and if the touch event is hovering; if so, it replaces the upState texture */
		protected function onTouchCheckHover( e:TouchEvent ):void 
		{
			if( parent && enabled && !_isOver && e.interactsWith( this ) ) 
			{
				removeEventListener( TouchEvent.TOUCH, onTouchCheckHover );
				parent.addEventListener( TouchEvent.TOUCH, onParentTouchCheckHoverEnd );
				isOver = true;
			}
		}
		
		/** Checks if there is a parent, an overState, and if the touch event is finished hovering; if so, it resets the upState texture */
		protected function onParentTouchCheckHoverEnd( e:TouchEvent ):void 
		{
			if( parent && enabled && _isOver && !e.interactsWith( this ) ) 
			{
				parent.removeEventListener( TouchEvent.TOUCH, onParentTouchCheckHoverEnd );
				addEventListener( TouchEvent.TOUCH, onTouchCheckHover );
				isOver = false;
			}
		}
		
		/** Checks the button states and makes sure it's displaying the appropriate texture */
		protected function updateStates():void
		{
			if( enabled )
			{
				if( _isOver )
				{
					upState = _overState;
				}
				else
				{
					upState = _upState;
				}
			}
			else
			{
				upState = _disabledState;
			}
		}
		
		/** The texture that is displayed while the button is hovered over. */
		public function get overState():Texture 
		{ 
			return _overState; 
		}
		
		public function set overState( value:Texture ):void
		{ 
			_overState = value;
		}
		
		/** The texture that is displayed while the button is disabled. */
		public function get disabledState():Texture
		{
			return _disabledState;
		}
		
		public function set disabledState( value:Texture ):void
		{
			_disabledState = value;
		}
		
		/** Whether or not the button is currently being hovered over. */		
		public function get isOver():Boolean
		{
			return _isOver;
		}
		
		public function set isOver( value:Boolean ):void
		{
			_isOver = value;
			updateStates();
		}
		
		/** Whether or not the button is currently being pressed. */		
		public function get isDown():Boolean
		{
			return _isDown;
		}
		
		public function set isDown( value:Boolean ):void
		{
			_isDown = value;
			updateStates();
		}		
		
		/** Whether or not the button is currently enabled. */
		override public function get enabled():Boolean
		{
			return super.enabled;
		}
		
		override public function set enabled( value:Boolean ):void
		{
			super.enabled = value;
			isDown = false;
			updateStates();
		}
		
		override public function dispose():void
		{
			// Cleanup event listeners
			removeEventListener( TouchEvent.TOUCH, onTouch );
			removeEventListener( TouchEvent.TOUCH, onTouchCheckHover );		
		
			// Call our super method
			super.dispose();
		}
	}
}