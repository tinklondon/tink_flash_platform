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

package ws.tink.spark.containers
{
	
	public class ValidationFormItem extends FormItem
	{
		
		private var _validationItemsChanged	: Boolean;
		private var _validationItems	: Array;
		
		[ArrayElementType("ws.tink.mx.validators.IValidationItem")]
		public function get validationItems():Array
		{
			return _validationItems;
		}
		
		public function set validationItems( value:Array ):void
		{
			if( _validationItems == value ) return
				
			_validationItems = value;
			_validationItemsChanged = true;
			invalidateProperties();
		}
		
		
		
		
		
			
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if( _validationItemsChanged && owner is ValidationForm )
			{
				_validationItemsChanged = false;
				ValidationForm( owner ).invalidateValidationItems();
			}
		}
		
	}
}