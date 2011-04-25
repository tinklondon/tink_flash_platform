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

package ws.tink.spark.itemRenderers
{
	
	import spark.components.Label;
	import spark.components.RichText;
	import spark.components.supportClasses.TextBase;
	import spark.skins.spark.DefaultItemRenderer;
	
	/**
	 *  The DefaultPropertyItemRenderer class defines the default item renderer
	 *  for a PropertyList control. 
	 *  The default item renderer just draws the name and value of the property associated
	 *  with each item in the list.
	 *
	 *  <p>You can override the default item renderer
	 *  by creating a custom item renderer.</p>
	 *
	 *  @see ws.tink.spark.components.PropertyList
	 *  @see mx.core.IDataRenderer
	 *  @see ws.tink.spark.itemRenderers.IPropertyItemRenderer
	 *  @see ws.tink.spark.itemRenderers.PropertyItemRenderer
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class DefaultPropertyItemRenderer extends DefaultItemRenderer implements IPropertyItemRenderer
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
		public function DefaultPropertyItemRenderer()
		{
			super();
		}
		
		private var _valueDisplay:TextBase;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties 
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  property
		//----------------------------------
		
		/**
		 *  @private 
		 *  Storage var for property.
		 */ 
		private var _property:String;
		
		/**
		 *  @inheritDoc
		 */
		public function get property():String
		{
			return _property;
		}
		/**
		 *  @private
		 */
		public function set property( value:String ):void
		{
			if( _property == value ) return;
			
			_property = value;
		}
		
		
		//----------------------------------
		//  value
		//----------------------------------
		
		/**
		 *  @private 
		 *  Storage var for value.
		 */ 
		private var _value:String;
		
		/**
		 *  @inheritDoc
		 */
		public function get value():String
		{
			return _value;
		}
		/**
		 *  @private
		 */
		public function set value( v:String ):void
		{
			if( _value == v ) return;
			
			_value = v;
			// Push the property down into the propertyDisplay, if it exists
			if( _valueDisplay ) _valueDisplay.text = _value;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Override this method to return the desired TextBase.
		 *  
		 *  @default s:Label
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		protected function createValueDisplay():TextBase
		{
			return new Label();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (!_valueDisplay)
			{
				_valueDisplay = createValueDisplay();
				addChild( _valueDisplay );
				if( _property != "" ) _valueDisplay.text = _value;
			}
		}
		
		/**
		 *  @private
		 */
		override protected function measure():void
		{
			super.measure();
			
			// label has padding of 3 on left and right and padding of 5 on top and bottom.
			measuredWidth = labelDisplay.getPreferredBoundsWidth() + _valueDisplay.getPreferredBoundsWidth() + 10;
			measuredHeight = Math.max( labelDisplay.getPreferredBoundsHeight() + 10, _valueDisplay.getPreferredBoundsHeight() + 10 );
			
			measuredMinWidth = labelDisplay.getMinBoundsWidth()  + _valueDisplay.getMinBoundsWidth() + 10;
			measuredMinHeight = Math.max( labelDisplay.getMinBoundsHeight() + 10, _valueDisplay.getMinBoundsHeight() + 10 );
		}
		
		/**
		 *  @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var availableHeight:Number = unscaledHeight - 10;
			var childHeight:Number;
			
			
			var labelDisplayWidth:Number = Math.max( labelDisplay.getMinBoundsWidth(), labelDisplay.getPreferredBoundsWidth() );
			
			var availableWidth:Number = Math.floor( ( unscaledWidth - labelDisplayWidth - 10 ) / 2 );
			
			var propertyDisplayWidth:Number = Math.max( _valueDisplay.getMinBoundsWidth(), Math.min( _valueDisplay.getMaxBoundsWidth(), availableWidth ) );
		
			childHeight = Math.max( labelDisplay.getMinBoundsHeight(), Math.min( labelDisplay.getMaxBoundsHeight(), availableHeight ) );
			labelDisplay.setLayoutBoundsSize( labelDisplayWidth, childHeight );
			labelDisplay.setLayoutBoundsPosition( 3, int( ( unscaledHeight - childHeight ) / 2 ) );

			childHeight = Math.max( _valueDisplay.getMinBoundsHeight(), Math.min( _valueDisplay.getMaxBoundsHeight(), availableHeight ) );
			_valueDisplay.setLayoutBoundsSize( propertyDisplayWidth, childHeight );
			_valueDisplay.setLayoutBoundsPosition( Math.max( labelDisplayWidth + 6, unscaledWidth / 2 ), int( ( unscaledHeight - childHeight ) / 2 ) );
		}
		
	}
}