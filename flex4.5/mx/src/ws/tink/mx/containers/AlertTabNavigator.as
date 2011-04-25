////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2008 Tink Ltd | http://www.tink.ws
//	
//	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//	documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
//	the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//	to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//	
//	The above copyright notice and this permission notice shall be included in all copies or substantial portions
//	of the Software.
//	
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
//	THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
//	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

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