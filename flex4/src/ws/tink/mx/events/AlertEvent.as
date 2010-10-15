package ws.tink.mx.events
{
	import flash.events.Event;
	import flash.display.DisplayObject;

	public class AlertEvent extends Event
	{
		
		
		public static const ALERT			: String = "alert";
		public static const DISMISS			: String = "dismiss";

		
		public function AlertEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		public override function clone():Event
		{
			return new AlertEvent( type, bubbles, cancelable );
		}
	}
}