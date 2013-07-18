package objects
{
	public class Achievement
	{
		private var id:String;
		private var name:String; 
		private var displayName:String; 
		private var imageClass:Class;
		private var imageClassEmpty:Class;
		private var imageClassMedium:Class;
		private var imageClassEmptyMedium:Class;
		private var imageClassSmall:Class;
		private var imageClassEmptySmall:Class;
		private var description:String;
		private var popupDescription:String;
		
		public function get ID():String
		{
			return this.id;
		}
		
		public function set ID( _id:String ):void
		{
			this.id = _id;
		}
		
		public function get Name():String
		{
			return this.name;
		}
		
		public function set Name( _name:String ):void
		{
			this.name = _name;
		}
		
		public function get DisplayName():String
		{
			return this.displayName;
		}
		
		public function set DisplayName( _displayName:String ):void
		{
			this.displayName = _displayName;
		}
		
		public function get ImageClass():Class
		{
			return this.imageClass;
		}
		
		public function set ImageClass( _imageClass:Class ):void
		{
			this.imageClass = _imageClass;
		}
		
		public function get ImageClassEmpty():Class
		{
			return this.imageClassEmpty;
		}
		
		public function set ImageClassEmpty( _imageClassEmpty:Class ):void
		{
			this.imageClassEmpty = _imageClassEmpty;
		}
		
		public function get ImageClassMedium():Class
		{
			return this.imageClassMedium;
		}
		
		public function set ImageClassMedium( _imageClassMedium:Class ):void
		{
			this.imageClassMedium = _imageClassMedium;
		}
		
		public function get ImageClassEmptyMedium():Class
		{
			return this.imageClassEmptyMedium;
		}
		
		public function set ImageClassEmptyMedium( _imageClassEmptyMedium:Class ):void
		{
			this.imageClassEmptyMedium = _imageClassEmptyMedium;
		}

		public function get ImageClassSmall():Class
		{
			return this.imageClassSmall;
		}
		
		public function set ImageClassSmall( _imageClassSmall:Class ):void
		{
			this.imageClassSmall = _imageClassSmall;
		}
		
		public function get ImageClassEmptySmall():Class
		{
			return this.imageClassEmptySmall;
		}
		
		public function set ImageClassEmptySmall( _imageClassEmptySmall:Class ):void
		{
			this.imageClassEmptySmall = _imageClassEmptySmall;
		}
		
		public function get Description():String
		{
			return this.description;
		}
		
		public function set Description( _description:String ):void
		{
			this.description = _description;
		}
		
		public function get PopupDescription():String
		{
			return this.popupDescription;
		}
		
		public function set PopupDescription( _popupDescription:String ):void
		{
			this.popupDescription = _popupDescription;
		}
		
		public function Achievement()
		{
		}
	}
}