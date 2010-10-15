/*

Copyright (c) 2010 Tink Ltd - http://www.tink.ws

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

package ws.tink.spark.controls
{
	import flash.events.Event;

	
	[Event(name="change", type="flash.events.Event")]
	
	
	public class PageStepper extends Stepper
	{
		public function PageStepper()
		{
			super();
		}
		
		public function get verticalSelectedPage():int
		{
			return VPageStep( verticalScrollBar ).selectedPage;
		}
		
		public function get horizontalSelectedPage():int
		{
			return HPageStep( horizontalScrollBar ).selectedPage;
		}
		public function set horizontalSelectedPage( value:int ):void
		{
			if( horizontalScrollBar )
			{
				HPageStep( horizontalScrollBar ).selectedPage = value;
			}
		}
		
		public function get verticalNumPages():int
		{
			return VPageStep( verticalScrollBar ).numPages;
		}
		
		public function get horizontalNumPages():int
		{
			return HPageStep( horizontalScrollBar ).numPages;
		}
		
		protected function onScrollBarChange( event:Event ):void
		{
			dispatchEvent( event );
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			switch( instance )
			{
				case horizontalScrollBar :
				{
					horizontalScrollBar.addEventListener( Event.CHANGE, onScrollBarChange, false, 0, true );
					break;
				}
				case verticalScrollBar :
				{
					verticalScrollBar.addEventListener( Event.CHANGE, onScrollBarChange, false, 0, true );
					break;
				}
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved( partName, instance );
			
			switch( instance )
			{
				case horizontalScrollBar :
				{
					horizontalScrollBar.removeEventListener( Event.CHANGE, onScrollBarChange, false );
					break;
				}
				case verticalScrollBar :
				{
					verticalScrollBar.removeEventListener( Event.CHANGE, onScrollBarChange, false );
					break;
				}
			}
		}
	}
}