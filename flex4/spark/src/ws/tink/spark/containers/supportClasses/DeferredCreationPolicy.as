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
package ws.tink.spark.containers.supportClasses
{
	import mx.containers.ViewStack;

	/**
	 *  The DeferredCreationPolicy class defines the constant values
	 *  for the <code>creationPolicy</code> property of the DeferedGroup class.
	 *
	 *  @see ws.tink.spark.containers.DeferredGroup#creationPolicy
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class DeferredCreationPolicy
	{
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Immediately create all descendants.
		 *
		 *  <p>Avoid using this <code>creationPolicy</code> because
		 *  it increases the startup time of your application.
		 *  There is usually no good reason to create components at startup
		 *  which the user cannot see.
		 *  If you are using this policy so that you can "push" data into
		 *  hidden components at startup, you should instead design your
		 *  application so that the data is stored in data variables
		 *  and components which are created later "pull" in this data,
		 *  via databinding or an <code>initialize</code> handler.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const ALL:String = "all";
		
		/**
		 *  Construct all decendants immediately but only inialize those
		 *  that are visible.
		 *  
		 *  <p>This is useful if you using the container as a dataProvider
		 *  to a MenuBar, as the MenuBar requires all the children to be created
		 *  to get the correct dataProvider to drive its content.</p>
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const CONSTRUCT:String = "construct";
		
		/**
		 *  Only construct the immediate descendants and initialize
		 *  those that are visible.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const VISIBLE:String = "visible";
		
		/**
		 *  Do not create any children.
		 *
		 *  <p>With this <code>creationPolicy</code>, it is the developer's
		 *  responsibility to programmatically create the children 
		 *  from the UIComponentDescriptors by calling
		 *  <code>createComponentsFromDescriptors()</code>
		 *  on the parent container.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const NONE:String = "none";
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function DeferredCreationPolicy()
		{
			
		}
	}
}