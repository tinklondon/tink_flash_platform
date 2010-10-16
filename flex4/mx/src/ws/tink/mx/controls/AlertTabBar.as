////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2009 Tink Ltd | http://www.tink.ws
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