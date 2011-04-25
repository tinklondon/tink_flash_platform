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
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	public class HMouseOverStep extends HStep
	{
		public function HMouseOverStep()
		{
			super();
		}
		
		override protected function partAdded( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );
			
			if( instance == decrementButton )
			{
				decrementButton.addEventListener( MouseEvent.ROLL_OVER, onButtonRollOver, false, 0, true );
				decrementButton.addEventListener( MouseEvent.ROLL_OUT, onButtonRollOut, false, 0, true );
			}
			else if( instance == incrementButton )
			{
				incrementButton.addEventListener( MouseEvent.ROLL_OVER, onButtonRollOver, false, 0, true );
				incrementButton.addEventListener( MouseEvent.ROLL_OUT, onButtonRollOut, false, 0, true );
			}
		}
		
		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partRemoved( partName, instance );
			
			if( instance == decrementButton )
			{
				decrementButton.removeEventListener( MouseEvent.ROLL_OVER, onButtonRollOver, false );
				decrementButton.removeEventListener( MouseEvent.ROLL_OUT, onButtonRollOut, false );
			}
			else if( instance == incrementButton )
			{
				incrementButton.removeEventListener( MouseEvent.ROLL_OVER, onButtonRollOver, false );
				incrementButton.removeEventListener( MouseEvent.ROLL_OUT, onButtonRollOut, false );
			}
		}
		
		override protected function button_buttonDownHandler(event:Event):void
		{
			
		}
		
		protected function onButtonRollOver( event:MouseEvent ):void
		{
			var increment:Boolean = (event.target == incrementButton);
			dispatchEvent( new FlexEvent( FlexEvent.CHANGE_START ) );
			
			animateStepping( increment ? maximum : minimum, Math.max( pageSize / 10, stepSize ) );
		}
		
		protected function onButtonRollOut( event:MouseEvent ):void
		{
			button_buttonUpHandler( event );
		}
	}
}