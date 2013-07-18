package objects
{
	/**
	 * Represents an FLV tag.
	 */ 
	public class FLVByteArrayTag
	{
		private var _parent:FLVByteArray;
		private var _offset:uint;
		private var _type:uint;
		private var _bodyLength:uint;
		private var _timeStamp:uint;
		private var _timeStampExtended:uint;
		private var _streamID:uint;
		
		public function get parent():FLVByteArray
		{
			return _parent;
		}
		
		public function set parent( value:FLVByteArray ):void
		{
			_parent = value;
		}		
		
		public function get offset():uint
		{
			return _offset;
		}
		
		public function set offset( value:uint ):void
		{
			_offset = value;
		}		
		
		public function get type():uint
		{
			return _type;
		}
		
		public function set type( value:uint ):void
		{
			_type = value;
		}		
		
		public function get bodyLength():uint
		{
			return _bodyLength;
		}
		
		public function set bodyLength( value:uint ):void
		{
			_bodyLength = value;
		}		
		
		public function get timeStamp():uint
		{
			return _timeStamp;
		}
		
		public function set timeStamp( value:uint ):void
		{
			_timeStamp = value;
		}
		
		public function get timeStampExtended():uint
		{
			return _timeStampExtended;
		}
		
		public function set timeStampExtended( value:uint ):void
		{
			_timeStampExtended = value;
		}		
		
		public function get streamID():uint
		{
			return _streamID;
		}
		
		public function set streamID( value:uint ):void
		{
			_streamID = value;
		}		
		
		public function FLVByteArrayTag( parent:FLVByteArray, offset:uint, type:uint, bodyLength:uint, timeStamp:uint, timeStampExtend:uint, streamID:uint )
		{
			_parent = parent;
			_offset = offset;
			_type = type;
			_bodyLength = bodyLength;
			_timeStamp = timeStamp;
			_timeStampExtended = timeStampExtended;
			_streamID = streamID;
		}
	}
}