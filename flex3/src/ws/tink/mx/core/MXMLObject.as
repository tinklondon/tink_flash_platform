////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2010 Tink Ltd | http://www.tink.ws
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

package ws.tink.mx.core
{
	import mx.core.IMXMLObject;
	import mx.core.UIComponent;
	
	public class MXMLObject implements IMXMLObject
	{
		public function MXMLObject()
		{
		}
		
		private var _document:UIComponent;
		public function get document():UIComponent
		{
			return _document;
		}
		
		private var _id:String;
		public function get id():String
		{
			return _id;
		}
		
		/**
		 *  @copy mx.core.IMXMLObject#initialized
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		final public function initialized( document:Object, id:String ):void
		{
			_document = UIComponent( document );
			_id = id;
			
			create();
			invalidate();
		}
		
		protected function create():void
		{
			
		}
		
		protected function commit():void
		{
			
		}
		
		private var _invalidateFlag:Boolean;
		final protected function invalidate():void
		{
			if( _document && !_invalidateFlag )
			{
				_invalidateFlag = true;
				_document.callLater( commitValidation );
			}
		}
		
		private function commitValidation():void
		{
			_invalidateFlag = false;
			commit();
		}
		
		
	}
}