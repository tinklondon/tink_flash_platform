package ws.tink.spark.slides
{
	import mx.core.IVisualElement;
	
	public interface ISlide extends IVisualElement
	{
		function get notes():Object;
		function set notes( value:Object ):void;
		function get label():String;
		function set label( value:String ):void;
	}
}