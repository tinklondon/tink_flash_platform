package ws.tink.mx.containers
{
	import flash.display.DisplayObject;
	
	import mx.core.FlexVersion;
	import mx.events.ChildExistenceChangedEvent;
	import mx.styles.StyleProxy;
	
	import ws.tink.mx.controls.AlertTabBar;
	import ws.tink.mx.events.AlertEvent;
	
	public class AlertTabNavigator extends PositionedTabNavigator
	{
		
		public function AlertTabNavigator()
		{
			addEventListener( ChildExistenceChangedEvent.CHILD_ADD, onChildAdd );
			addEventListener( ChildExistenceChangedEvent.CHILD_REMOVE, onChildRemove );
		}
		
		/**
	     *  @private
	     */
	    override protected function createChildren():void
	    {
	       	super.createChildren();
	
	        if( !( tabBar is AlertTabBar ) )
	        {
	        	rawChildren.removeChild( tabBar );
	        	tabBar = null;
	        	
	            tabBar = new AlertTabBar();
	            tabBar.name = "tabBar";
	            tabBar.focusEnabled = false;
	            tabBar.styleName = new StyleProxy( this, tabBarStyleFilters );
	            rawChildren.addChild( tabBar );
	            
	            if( FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0 )
	            {
	            	tabBar.setStyle( "paddingTop", 0 );
	            	tabBar.setStyle( "paddingBottom", 0 );
					tabBar.setStyle( "borderStyle", "none" );         	
	            }
	        }
	    }
	    
		private function onChildAdd( event:ChildExistenceChangedEvent ):void
		{
			var child:DisplayObject = event.relatedObject;
			
			child.addEventListener( AlertEvent.ALERT, onChildAlert );
			child.addEventListener( AlertEvent.DISMISS, onChildDismiss );
		}
		
		private function onChildRemove( event:ChildExistenceChangedEvent ):void
		{
			var child:DisplayObject = event.relatedObject;
			
			child.removeEventListener( AlertEvent.ALERT, onChildAlert );
			child.removeEventListener( AlertEvent.DISMISS, onChildDismiss );
		}
		
		
		private function onChildAlert( event:AlertEvent ):void
		{
			var child:DisplayObject = DisplayObject( event.currentTarget );
			var index:int = getChildIndex( child );
			
			AlertTabBar( tabBar ).alertAt( index );
		}
		
		
		private function onChildDismiss( event:AlertEvent ):void
		{
			var child:DisplayObject = DisplayObject( event.currentTarget );
			var index:int = getChildIndex( child );
			
			AlertTabBar( tabBar ).dismissAlertAt( index );
		}
		
	}
}