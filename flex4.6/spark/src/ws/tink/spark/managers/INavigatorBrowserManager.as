/*

Copyright (c) 2011 Tink Ltd - http://www.tink.ws

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

package ws.tink.spark.managers
{
	import ws.tink.spark.layouts.supportClasses.INavigatorLayout;

	/**
	 *  The interface that the shared instance of the NavigtorBrowserManager
	 *  implements, which is accessed with the <code>NavigtorBrowserManager.getInstance()</code> method.
	 * 
	 *  @see ws.tink.spark.managers.NavigtorBrowserManager
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public interface INavigatorBrowserManager
	{
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  fragmentField
		//----------------------------------
		
		/**
		 *  The portion of current URL after the '#' as it appears 
		 *  in the browser address bar, or the default fragment
		 *  used in setup() if there is nothing after the '#'.  
		 *  Use setFragment to change this value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		function get fragmentField():String
		/**
		 *  @private
		 */
		function set fragmentField( value:String ):void
		
		
		//----------------------------------
		//  fragmentFunction
		//----------------------------------
		
		/**
		 *  The portion of current URL after the '#' as it appears 
		 *  in the browser address bar, or the default fragment
		 *  used in setup() if there is nothing after the '#'.  
		 *  Use setFragment to change this value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		function get fragmentFunction():Function
		/**
		 *  @private
		 */
		function set fragmentFunction( value:Function ):void
			
			
			
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Registers a layout so that it can be managed.
		 *  
		 *  @param value The INavigatorLayout to be registered.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		function registerLayout( value:INavigatorLayout ):void
		
		/**
		 *  Unregisters a layout so that it is no longer managed.
		 *  
		 *  @param value The INavigatorLayout to be unregistered.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		function unRegisterLayout( value:INavigatorLayout ):void
	}
}