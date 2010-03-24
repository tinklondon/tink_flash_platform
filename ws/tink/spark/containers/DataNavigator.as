////////////////////////////////////////////////////////////////////////////////
//
//      Copyright (c) 2010 Tink Ltd | http://www.tink.ws
//      
//      Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//      documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
//      the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//      to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//      
//      The above copyright notice and this permission notice shall be included in all copies or substantial portions
//      of the Software.
//      
//      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
//      THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//      AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
//      TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//      SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

package ws.tink.spark.components
{
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.ISelectableList;
	import mx.core.IVisualElement;
	import mx.effects.IEffect;
	
	import spark.components.DataGroup;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.supportClasses.LayoutBase;
	
	import ws.tink.spark.layouts.StackLayout;
	import ws.tink.spark.layouts.supportClasses.INavigatorLayout;
	import ws.tink.spark.layouts.supportClasses.NavigatorLayoutBaseOLD;
	

	public class DataNavigator extends DataGroup implements ISelectableList
	{
		
		/**
		 *  Constructor. 
		 * 
		 *  @see ws.tink.spark.layouts.StackLayout
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */  
		public function DataNavigator()
		{
			super();
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  <p>If the layout object has not been set yet, 
		 *  createChildren() assigns this container a 
		 *  default layout object, BasicLayout.</p>
		 */ 
		override protected function createChildren():void
		{
			if( !layout ) layout = new StackLayout();
			
			super.createChildren();
		}
		
		//----------------------------------
		//  layout
		//----------------------------------    
		
		/**
		 *  @private
		 */
		override public function set layout( value:LayoutBase ):void
		{
			if( layout == value ) return;
			
			if( value is INavigatorLayout )
			{
				super.layout = value;
			}
			else
			{
				throw new Error( "Layout must implement INavigatorLayout" );
			}
			
		}
		
		
		/**
		 *  @copy ws.tink.spark.layouts.StackLayout#verticalAlign
		 *  
		 *  @default "justify"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
//		[Inspectable(category="General", enumeration="top,bottom,middle,justify,contentJustify", defaultValue="top")]
//		public function get verticalAlign():String
//		{
//			return stackLayout.verticalAlign;
//		}
//		public function set verticalAlign( value:String ):void
//		{
//			stackLayout.verticalAlign = value;
//		}
		
		/**
		 *  @copy ws.tink.spark.layouts.StackLayout#horizontalAlign
		 *  
		 *  @default "justify"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
//		[Inspectable(category="General", enumeration="left,right,center,justify,contentJustify", defaultValue="left")]
//		public function get horizontalAlign():String
//		{
//			return stackLayout.horizontalAlign;
//		}
//		public function set horizontalAlign( value:String ):void
//		{
//			stackLayout.horizontalAlign = value;
//		}
		
		
		/**
		 *  @private
		 *  IList implementation of selectedIndex sets
		 *  StackLayout( layout ).focusedIndex
		 */
		public function set selectedIndex( value:int ):void
		{
			INavigatorLayout( layout ).selectedIndex = value;
		}
		
		/**
		 *  @private
		 *  IList implementation of selectedIndex returns
		 *  StackLayout( layout ).focusedIndex
		 */
		public function get selectedIndex():int
		{
			return INavigatorLayout( layout ).selectedIndex;
		}
		
		/**
		 *  @private
		 *  IList implementation of length returns numChildren
		 */
		public function get length():int
		{
			return numElements;
		}
		
		/**
		 *  @private
		 *  IList implementation of addItem calls addChild
		 */
		public function addItem( item:Object ):void
		{
			addItemAt( item, length );
		}
		
		/**
		 *  @private
		 *  IList implementation of addItemAt calls addChildAt
		 */
		public function addItemAt( item:Object, index:int ):void
		{
			var dp:IList = ( !dataProvider ) ? new ArrayList() : dataProvider;
			dp.addItemAt( item, index );
		}
		
		/**
		 *  @private
		 *  IList implementation of getItemAt calls getVirtualElementAt
		 */
		public function getItemAt( index:int, prefetch:int = 0 ):Object
		{
			if( length <= index ) return null;
			return  dataProvider.getItemAt( index );
		}
		
		/**
		 *  @private
		 *  IList implementation of getItemIndex calls getElementIndex
		 */
		public function getItemIndex( item:Object ):int
		{
			if( !dataProvider ) return -1;
			return dataProvider.getItemIndex( item );
		}
		
		/**
		 *  @private
		 *  IList implementation of itemUpdated doesn't do anything
		 */
		public function itemUpdated( item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null ):void
		{
		}
		
		/**
		 *  @private
		 *  IList implementation of removeAll calls removeAllElements
		 */
		public function removeAll():void
		{
			if( !dataProvider ) return;
			dataProvider.removeAll();
		}
		
		/**
		 *  @private
		 *  IList implementation of removeItemAt calls removeElementAt
		 */
		public function removeItemAt( index:int ):Object
		{
			if( !dataProvider || index >= numElements ) return null;
			return dataProvider.removeItemAt( index );
		}
		
		/**
		 *  @private
		 *  IList implementation of setItemAt calls removeElementAt
		 *  to remove the old child and removeElementAt to add the
		 *  new one.
		 */
		public function setItemAt(item:Object, index:int):Object
		{
			if( !dataProvider || index > numElements ) return null;
			return dataProvider.setItemAt( item, index );
		}
		
		/**
		 *  @private
		 *  IList implementation of toArray returns array of children
		 */
		public function toArray():Array
		{
			return ( !dataProvider ) ? null : dataProvider.toArray();
		}
	}
}