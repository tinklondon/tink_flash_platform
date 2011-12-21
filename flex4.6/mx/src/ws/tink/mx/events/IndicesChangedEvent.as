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

package ws.tink.mx.events
{
	import flash.events.Event;
	import flash.display.DisplayObject;

	public class IndicesChangedEvent extends Event
	{
		
		public static const CHANGE			: String = "indicesChange";
		
		private var _releatedObject		: DisplayObject;
		private var _oldIndices			: Array;
		private var _newIndices			: Array;
		private var _trigger			: Event;
		
		public function IndicesChangedEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, releatedObject:DisplayObject = null, oldIndices:Array = null, newIndices:Array = null, trigger:Event = null )
		{
			super( type, bubbles, cancelable );
			
			_releatedObject = releatedObject;
			_oldIndices = oldIndices;
			_newIndices = newIndices;
			_trigger = trigger;
		}
		
		public function get releatedObject():DisplayObject
		{
			return _releatedObject;
		}
		
		public function get oldIndices():Array
		{
			return _oldIndices;
		}
		
		public function get newIndices():Array
		{
			return _newIndices;
		}
		
		public function get trigger():Event
		{
			return _trigger;
		}
		
		public override function clone():Event
		{
			return new IndicesChangedEvent( type, bubbles, cancelable, releatedObject, oldIndices, newIndices, trigger );
		}
	}
}