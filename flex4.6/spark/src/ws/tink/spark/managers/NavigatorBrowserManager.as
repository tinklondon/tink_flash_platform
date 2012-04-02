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
	
	import mx.core.Singleton;
	
	/**
	 *  @private
	 *  The NavigatorBrowserManager is a Singleton manager that acts as
	 *  a proxy between the BrowserManager and INavigatorLayout instances
	 *  added to it.
	 * 
	 *  <p>It updates the <code>fragment</code> property of the IBrowserManager
	 *  when a registered INavigatorLayout changes its <code>selectedindex</code>,
	 *  and also sets the <code>selectedIndex</code> of registered INavigatorLayout instances
	 *  when the <code>fragment</code> property of the IBrowserManager changes.
	 *
	 *  @see ws.tink.spark.managers.INavigatorBrowserManager
	 *  @see ws.tink.spark.layouts.supportClasses.INavigatorLayout
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class NavigatorBrowserManager
	{

		
		
		//--------------------------------------------------------------------------
		//
		//  Class Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Linker dependency on implementation class.
		 */
		private static var implClassDependency:NavigatorBrowserManagerImpl;
		
		/**
		 *  @private
		 */
		private static var instance:INavigatorBrowserManager;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Returns the sole instance of this Singleton class;
		 *  creates it if it does not already exist.
		 *
		 *  @return Returns the sole instance of this Singleton class;
		 *  creates it if it does not already exist.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function getInstance():INavigatorBrowserManager
		{
			if( !instance ) instance = INavigatorBrowserManager( Singleton.getInstance( "ws.tink.spark.managers::INavigatorBrowserManager" ) );
			return instance;
		}
	}
	
}
