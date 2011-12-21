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

package ws.tink.spark.itemRenderers
{
	
	import spark.components.CheckBox;
	import spark.components.IItemRenderer;
	import spark.components.RadioButton;
	
	/**
	 *  The RadioButtonItemRenderer component extends RadioButton
	 *  inheriting its look and functionality and also implements IItemRenderer
	 *  so that it can be used as a itemRenderer for list based controls.
	 *
	 *  <p>No RadioButton group is required if multipleSelection isn't allowed.</p>
	 *
	 *  <p>The RadioButtonItemRenderer component has the following default characteristics:</p>
	 *     <table class="innertable">
	 *        <tr>
	 *           <th>Characteristic</th>
	 *           <th>Description</th>
	 *        </tr>
	 *        <tr>
	 *           <td>Default size</td>
	 *           <td>Wide enough to display the text label of the component</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Minimum size</td>
	 *           <td>18 pixels wide and 18 pixels high</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Maximum size</td>
	 *           <td>10000 pixels wide and 10000 pixels high</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Default skin class</td>
	 *           <td>spark.skins.spark.RadioButtonSkin</td>
	 *        </tr>
	 *     </table>
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;st:RadioButtonItemRenderer&gt;</code> tag inherits all of the tag
	 *  attributes of its superclass, and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;st:RadioButtonItemRenderer
	 *    <strong>Properties</strong>
	 *    dragging="false"
	 *    itemIndex="0"
	 *    showsCaret="false"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class RadioButtonItemRenderer extends RadioButton implements IItemRenderer
	{
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function RadioButtonItemRenderer()
		{
			super();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties 
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  itemIndex
		//----------------------------------
		
		/**
		 *  @private
		 *  storage for the itemIndex property 
		 */    
		private var _itemIndex:int;
		
		/**
		 *  @inheritDoc 
		 *
		 *  @default 0
		 */    
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		/**
		 *  @private
		 */    
		public function set itemIndex(value:int):void
		{
			if (value == _itemIndex)
				return;
			
			_itemIndex = value;
			invalidateDisplayList();
		}
		
		
		//----------------------------------
		//  showsCaret
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the showsCaret property 
		 */
		private var _showsCaret:Boolean = false;
		
		/**
		 *  @inheritDoc 
		 *
		 *  @default false  
		 */    
		public function get showsCaret():Boolean
		{
			return _showsCaret;
		}
		
		/**
		 *  @private
		 */    
		public function set showsCaret(value:Boolean):void
		{
			if (value == _showsCaret)
				return;
			
			_showsCaret = value;
			invalidateDisplayList();
		}
		
		
		//----------------------------------
		//  dragging
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the dragging property. 
		 */
		private var _dragging:Boolean = false;
		
		/**
		 *  @inheritDoc  
		 */
		public function get dragging():Boolean
		{
			return _dragging;
		}
		
		/**
		 *  @private  
		 */
		public function set dragging(value:Boolean):void
		{
			if (value == _dragging)
				return;
			
			_dragging = value;
		}
		
		
		//----------------------------------
		//  data
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the data property. 
		 */
		private var _data:Object = false;
		
		/**
		 *  @inheritDoc  
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 *  @private  
		 */
		public function set data( value:Object ):void
		{
			if( value == _data ) return;
			
			_data = value;
		}
		
	}
}