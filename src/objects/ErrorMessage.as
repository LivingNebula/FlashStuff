package objects
{
	import flash.utils.Dictionary;
	
	import interfaces.IDisposable;
	
	/**
	 * The ErrorMessage class is used to construct error messages to send to the API
	 * that are consistently formed.
	 */
	public class ErrorMessage implements IDisposable
	{
		private var _title:String;
		private var _sections:Dictionary;
		private var _sectionSeparator:String = "\n------------------------------\n";
		
		/**
		 * Constructs a new error message.
		 * 
		 * @param title The title of the error.
		 * @param type A text description of the error type.
		 * @param message The error message.
		 * @param stackTrace The error's stacktrace.
		 */
		public function ErrorMessage( title:String, type:String, message:String, stackTrace:String = "" )
		{
			_title = title;			
			_sections = new Dictionary();
			
			append( "ERROR DETAILS", "Type: " + type );
			append( "ERROR DETAILS", "Message: " + message );
			append( "ERROR DETAILS", "Stacktrace: " + stackTrace );
		}
		
		/**
		 * Appends new line to an error message, in the given section.
		 * 
		 * @param section The section to appened the line. If the section doesn't exist,
		 * it will be created for you.
		 */
		public function append( section:String, text:String ):ErrorMessage
		{
			section = section.toUpperCase();
			
			if( !_sections[section] )
			{
				_sections[section] = "";
			}
				
			_sections[section] += text + "\n";
			
			return this;
		}
		
		/**
		 * Returns a formatted string representation of the error message.
		 */
		public function toString():String
		{
			var str:String = "";
			var keys:Array;
			var key:String;
			var i:int;
			
			str += _title;
			str += "\n";
			
			keys = [];
			for( key in _sections )
			{
				keys.push( key.toString() );
			}
			keys.sort();
			
			for( i = 0; i < keys.length; i++ )
			{
				key = keys[i];
				str += _sectionSeparator;
				str += key.toString();
				str += _sectionSeparator;
				str += _sections[key];
				str += "\n\t\n\t\n";
			}
			
			return str;
		}
		
		public function dispose():void
		{
			for( var key:Object in _sections )
			{
				delete _sections[key];
			}
			
			_title = null;
			_sections = null;
		}
	}
}