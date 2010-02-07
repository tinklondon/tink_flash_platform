package ws.tink.mx.controls
{
	import mx.core.ClassFactory;
	import mx.core.mx_internal;
	
	import ws.tink.mx.controls.alertTabBarClasses.AlertTab;
	
	use namespace mx_internal;
	
	[IconFile("AlertTabBar.png")]
	
	public class AlertTabBar extends PositionedTabBar
	{
		
		public function AlertTabBar()
		{
			super();
			
			navItemFactory = new ClassFactory( AlertTab );
		}
		
		public function alertAt( index:int ):void
		{
			AlertTab( getChildAt( index ) ).setStyle( "alerted", true );
		}
		
		public function dismissAlertAt( index:int ):void
		{
			AlertTab( getChildAt( index ) ).setStyle( "alerted", false );
		}
	}
}