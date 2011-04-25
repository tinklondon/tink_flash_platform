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
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.mx_internal;
	
	import spark.components.supportClasses.ItemRenderer;
	import spark.components.supportClasses.TextBase;
	
	use namespace mx_internal;
	
	/**
	 *  The PropertyItemRenderer class is the base class for PropertyList item renderers.
	 * 
	 *  @mxml
	 *
	 *  <p>The <code>&lt;st:PropertyItemRenderer&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:PropertyItemRenderer
	 *    <strong>Properties</strong>
	 *  /&gt;
	 *  </pre>
	 *  
	 *  @see ws.tink.spark.controls.PropertyList
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class PropertyItemRenderer extends ItemRenderer implements IPropertyItemRenderer
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
		public function PropertyItemRenderer()
		{
			super();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  propertyDisplay
		//----------------------------------
		
		/**
		 *  Optional item renderer label component. 
		 *  This component is used to determine the value of the 
		 *  <code>baselinePosition</code> property in the host component of 
		 *  the item renderer. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var propertyDisplay:TextBase;
		
		
		//----------------------------------
		//  valueDisplay
		//----------------------------------
		
		/**
		 *  Optional item renderer label component. 
		 *  This component is used to determine the value of the 
		 *  <code>baselinePosition</code> property in the host component of 
		 *  the item renderer. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var valueDisplay:TextBase;
		
		
		//----------------------------------
		//  property
		//----------------------------------
		
		/**
		 *  @private 
		 *  Storage var for property
		 */ 
		private var _property:String = "";
		
		[Bindable("propertyChanged")]
		
		/**
		 *  @inheritDoc 
		 *
		 *  @default ""    
		 */
		public function get property():String
		{
			return _property;
		}
		/**
		 *  @private
		 */
		public function set property(value:String):void
		{
			if( _property == value ) return;
			
			_property = value;
			
			if( propertyDisplay ) propertyDisplay.text = _property;
			dispatchEvent( new Event( "propertyChanged" ) );
		}
		
		
		//----------------------------------
		//  value
		//----------------------------------
		
		/**
		 *  @private 
		 *  Storage var for value
		 */ 
		private var _value:String = "";
		
		[Bindable("valueChanged")]
		
		/**
		 *  @inheritDoc 
		 *
		 *  @default ""    
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
			
			if( valueDisplay ) valueDisplay.text = _value;
			dispatchEvent( new Event( "valueChanged" ) );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function get baselinePosition():Number
		{
			if( !validateBaselinePosition() ) return super.baselinePosition;
			
			var lb:Number = super.baselinePosition;
			var p:Point;
			
			if( propertyDisplay )
			{
				p = globalToLocal( propertyDisplay.parent.localToGlobal( new Point( propertyDisplay.x, propertyDisplay.y ) ) );
				lb = Math.min( p.y + propertyDisplay.baselinePosition, lb );
			}
			
			if( valueDisplay )
			{
				p = globalToLocal( valueDisplay.parent.localToGlobal( new Point( valueDisplay.x, valueDisplay.y ) ) );
				lb = Math.min( p.y + valueDisplay.baselinePosition, lb );
			}
			
			return lb;
		}
	}
}