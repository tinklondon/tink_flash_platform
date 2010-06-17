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
	
	import mx.core.IDataRenderer;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.IItemRenderer;
	
	import ws.tink.spark.containers.FormItem;
	
	public class ValidityItemRenderer extends UIComponent implements IItemRenderer
	{
		public function ValidityItemRenderer()
		{
			super();
			
			useHandCursor = buttonMode = true;
		}
		
		private var _element	: UIComponent;
		private var _data	: Object;
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			if( _data == value ) return;
			
			if( value )
			{
				_data = value;
				if( _data.element == _element )
				{
					_valid = getValidityOfElement();
					invalidateSize();
					return;
				}
			}
			
			// If we have got to here the element must have been changed
			if( _element )
			{
				_element.removeEventListener( "validChange", onElementValidChange, false );
			}
			
			_element = null;
			_data = value;
			
			if( _data )
			{
				if( _data.element is UIComponent )
				{
					_element = UIComponent( _data.element );
					_element.addEventListener( "validChange", onElementValidChange, false, 0, true );
				}
			}
			
			_valid = getValidityOfElement();
			
			errorString = "yeah this could work";
			invalidateSize();
			
		}
		
		protected function getValidityOfElement():Boolean
		{
			if( !_element ) return true;
			
			if( _element is FormItem )
			{
				return FormItem( _element ).valid;
			}
			else if( _element is UIComponent )
			{
				return UIComponent( _element ).errorString as Boolean;
			}
			else if( "valid" in _element )
			{
				return _element[ "valid" ];
			}
			
			return true;
		}
		
		override protected function measure():void
		{
			if( _data )
			{
				var h:Number = IVisualElement( _data.element ).getLayoutBoundsHeight() * Number( _data.scale );
				measuredHeight = h;
				measuredWidth = 10;
				measuredMinHeight = h;
				measuredMinWidth = 10;
			}
			else
			{
				measuredHeight = 10;
				measuredWidth = 10;
				measuredMinHeight = 10;
				measuredMinWidth = 10;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			graphics.clear();
			
			
			if( !_valid )
			{
				trace( "invalidating", _valid, unscaledWidth, unscaledHeight, _data.scale );
				graphics.beginFill( 0xFF0000, 1 );
				graphics.drawRect( 0, 0, unscaledWidth, unscaledHeight );
				graphics.endFill();
			}
		}
		
		private var _valid:Boolean = true;
		private function onElementValidChange( event:Event ):void
		{
			_valid = getValidityOfElement();
			invalidateDisplayList();
		}
		
		private var _itemIndex	: int;
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		public function set itemIndex(value:int):void
		{
			if( _itemIndex == value ) return;
			
			_itemIndex = value;
			invalidateDisplayList();
		}
		
		public function get dragging():Boolean
		{
			return false;
		}
		
		public function set dragging(value:Boolean):void
		{
		}
		
		public function get label():String
		{
			return null;
		}
		
		public function set label(value:String):void
		{
		}
		
		public function get selected():Boolean
		{
			return false;
		}
		
		public function set selected(value:Boolean):void
		{
		}
		
		public function get showsCaret():Boolean
		{
			return false;
		}
		
		public function set showsCaret(value:Boolean):void
		{
		}
	}
}