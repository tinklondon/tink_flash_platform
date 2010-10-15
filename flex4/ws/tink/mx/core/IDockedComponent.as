package ws.tink.mx.core
{
	import mx.core.IUIComponent;

	public interface IDockedComponent extends IUIComponent
	{
		function get dockPosition():String
		function get dock():Boolean
	}
}