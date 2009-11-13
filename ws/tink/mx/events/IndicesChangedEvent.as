package ws.tink.mx.events
{
	import flash.events.Event;
	import flash.display.DisplayObject;

	public class IndicesChangedEvent extends Event
	{
		
		public static const CHANGE			: String = "indicesChange";
		
		private var _releatedObject		: DisplayObject;
		private var _oldIndices			: Array;
		private var _newIndices			: Array;
		private var _trigger			: Event;
		
		public function IndicesChangedEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, releatedObject:DisplayObject = null, oldIndices:Array = null, newIndices:Array = null, trigger:Event = null )
		{
			super( type, bubbles, cancelable );
			
			_releatedObject = releatedObject;
			_oldIndices = oldIndices;
			_newIndices = newIndices;
			_trigger = trigger;
		}
		
		public function get releatedObject():DisplayObject
		{
			return _releatedObject;
		}
		
		public function get oldIndices():Array
		{
			return _oldIndices;
		}
		
		public function get newIndices():Array
		{
			return _newIndices;
		}
		
		public function get trigger():Event
		{
			return _trigger;
		}
		
		public override function clone():Event
		{
			return new IndicesChangedEvent( type, bubbles, cancelable, releatedObject, oldIndices, newIndices, trigger );
		}
	}
}