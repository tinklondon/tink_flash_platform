package ws.tink.spark.slides
{
	import spark.components.SkinnableContainer;
	import spark.primitives.BitmapImage;
	
	public class Slide extends SkinnableContainer implements ISlide
	{
		
		[SkinPart(required="true")]
		public var bitmapImage:BitmapImage;
		
		public function Slide()
		{
			super();
		}
		
		private var _notes:Object;
		public function get notes():Object
		{
			return _notes;
		}
		public function set notes( value:Object ):void
		{
			_notes = value;
		}
		
		private var _label:String;
		public function get label():String
		{
			return _label;
		}
		public function set label( value:String ):void
		{
			_label = value;
		}
		
		private var _backgroundSource:Object;
		public function set backgroundSource( value:Object ):void
		{
			_backgroundSource = value;
			
			if( bitmapImage ) bitmapImage.source = _backgroundSource;
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == bitmapImage ) bitmapImage.source = _backgroundSource;
		}
	}
}