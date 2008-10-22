package ws.tink.flex.events
{
	import flash.events.Event;
	import flash.display.DisplayObject;

	public class IndexesChangedEvent extends Event
	{
		
		
		public static const CHANGE			: String = "indexesChange";
		
		private var _releatedObject		: DisplayObject;
		private var _oldIndexes			: Array;
		private var _newIndexes			: Array;
		private var _trigger			: Event;
		
		public function IndexesChangedEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, releatedObject:DisplayObject = null, oldIndexes:Array = null, newIndexes:Array = null, trigger:Event = null )
		{
			super( type, bubbles, cancelable );
			
			_releatedObject = releatedObject;
			_oldIndexes = oldIndexes;
			_newIndexes = newIndexes;
			_trigger = trigger;
		}
		
		public function get releatedObject():DisplayObject
		{
			return _releatedObject;
		}
		
		public function get oldIndexes():Array
		{
			return _oldIndexes;
		}
		
		public function get newIndexes():Array
		{
			return _newIndexes;
		}
		
		public function get trigger():Event
		{
			return _trigger;
		}
		
		public override function clone():Event
		{
			return new IndexesChangedEvent( type, bubbles, cancelable, releatedObject, oldIndexes, newIndexes, trigger );
		}
	}
}