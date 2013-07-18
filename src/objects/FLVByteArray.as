package objects
{
	import flash.utils.ByteArray;

	/**
	 * Wraps a ByteArray which contains data that represents an FLV file and exposes
	 * commands to manipulate the ByteArray while maintaining a proper FLV file format.
	 */
	public class FLVByteArray
	{
		private var _bytes:ByteArray;
		private var _signature:String;
		private var _version:uint;
		private var _flags:uint;
		private var _offset:uint;
		private var _tags:Vector.<FLVByteArrayTag>;

		public function FLVByteArray( bytes:ByteArray )
		{
			_bytes = bytes;
			readHeader();
			readTags();
		}

		/**
		 * Adjusts the timestamps in each of the FLV tags.
		 *
		 * @param timeToAdd How much time to add to each timestamp.
		 */
		public function shiftTimeStamps( timeToAdd:int ):FLVByteArray
		{
			for( var i:int = 0; i < _tags.length; i++ )
			{
				_tags[i].timeStamp += timeToAdd;
				writeTag( _tags[i] );
			}

			return this;
		}

		/**
		 * Creates a copy of the underlying ByteArray and then instances a new FLVByteArray on top of it.
		 */
		public function clone():FLVByteArray
		{
			return new FLVByteArray( getBytesCopy() );
		}

		/**
		 * Creates a copy of the underlying ByteArray.
		 *
		 * @param includeHeader Indicates wheter or not to include the header in the ByteArray.
		 */
		public function getBytesCopy( includeHeader:Boolean = true ):ByteArray
		{
			var ret:ByteArray = new ByteArray();
			ret.writeBytes( _bytes, includeHeader ? 0 : 13 );
			_bytes.position = 0;

			return ret;
		}

		/**
		 * Returns the duration of the FLV file by way of the timestamp on the last FLV tag.
		 */
		public function getDuration():int
		{
			return _tags[_tags.length - 1].timeStamp;
		}

		/**
		 * Extracts the FLV header from the underlying ByteArray.
		 */
		protected function readHeader():void
		{
			_bytes.position = 0;
			_signature = _bytes.readUTFBytes(3);
			_version = _bytes.readUnsignedByte();
			_flags = _bytes.readUnsignedByte();
			_offset = _bytes.readUnsignedInt();

			// Reset the byteArray position
			_bytes.position = 0;
		}

		/**
		 * Iterates through the underlying ByteArray and extracts each FLV tag.
		 */
		protected function readTags():void
		{
			_tags = new Vector.<FLVByteArrayTag>();
			_bytes.position = 13;

			// Read all the FLV tags
			while( _bytes.bytesAvailable > 0 )
			{
				var offset:uint = _bytes.position;
				var tagType:uint = _bytes.readByte();
				var bodyLength:uint = ( _bytes.readUnsignedShort() << 8) | _bytes.readUnsignedByte();
				var timeStamp:uint = ( _bytes.readUnsignedShort() << 8) | _bytes.readUnsignedByte();
				var timeStampExtended:uint = _bytes.readUnsignedByte();
				var streamID:uint = ( _bytes.readUnsignedShort() << 8) | _bytes.readUnsignedByte();
				var fb:uint = _bytes.readByte();
				var end:uint = _bytes.position + bodyLength + 3;
				var tagLength:uint = end - offset;

				_tags.push( new FLVByteArrayTag( this, offset, tagType, bodyLength, timeStamp, timeStampExtended, streamID ) );
				_bytes.position = end;
			}

			// Reset the byteArray position
			_bytes.position = 0;
		}

		/**
		 * Updates the underlying ByteArray with information from the provided FLV tag.
		 */
		protected function writeTag( tag:FLVByteArrayTag ):void
		{
			_bytes.position = tag.offset;
			_bytes.writeByte( tag.type );
			_bytes.writeShort( tag.bodyLength >> 8 );
			_bytes.writeByte( tag.bodyLength & 0xFF );
			_bytes.writeShort( tag.timeStamp >> 8 );
			_bytes.writeByte( tag.timeStamp & 0xFF );
			_bytes.writeShort( tag.streamID >> 8 );
			_bytes.writeByte( tag.streamID & 0xFF );

			_bytes.position = 0;
		}

		/**
		 * Clears the contents of the byte array and resets the length and position properties to 0.
		 * Calling this method explicitly frees up the memory used by the ByteArray instance.
		 */
		public function clear():void
		{
			if( _bytes != null )
			{
				_bytes.clear();
				_bytes = null;
			}

			if( _tags != null )
			{
				_tags.length = 0;
				_tags = null;
			}
		}
	}
}