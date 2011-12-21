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

package ws.tink.spark.layouts.supportClasses
{
	import flash.events.IEventDispatcher;
	
	import mx.core.ISelectableList;
	import mx.core.IVisualElement;

	/**
	 *  The INavigatorLayout interface indicates that the implementor
	 * 	is an LayoutBase that supports a <code>selectedIndex</code> property.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public interface INavigatorLayout extends IEventDispatcher
	{
		
		function get selectedElement():IVisualElement;
		
		//----------------------------------
		//  selectedIndex
		//----------------------------------
		
		/**
		 *  The index of the selected INavigatorLayout item.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		function get selectedIndex():int;
		/**
		 *  @private
		 */
		function set selectedIndex( value:int ):void;
		
		
		//----------------------------------
		//  useVirtualLayout
		//----------------------------------
		
		/**
		 *  Comment.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		function get useVirtualLayout():Boolean
		/**
		 *  @private
		 */
		function set useVirtualLayout( value:Boolean ):void
			
			
		//----------------------------------
		//  firstIndexInView
		//----------------------------------
		
		/**
		 *  Comment.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		function get firstIndexInView():int
			
			
		//----------------------------------
		//  lastIndexInView
		//----------------------------------
		
		/**
		 *  Comment.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		function get lastIndexInView():int

	}
}