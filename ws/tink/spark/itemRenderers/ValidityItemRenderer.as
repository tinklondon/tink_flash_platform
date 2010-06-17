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
	
	import mx.containers.Form;
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
		private var _scale		: Number;
		private var _data	: Object;
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			if( _data == value ) return;
			
			var newValid:Boolean;
			if( value )
			{
				_data = value;
				if( _data.element == _element )
				{
					newValid = getValidityOfElement();
					if( newValid != _valid )
					{
						_validChanged = true;
						_valid = newValid;
						invalidateSize();
					}
					
					if( Number( _data.scale ) != _scale )
					{
						_scale = Number( _data.scale );
						invalidateSize();
					}
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
				
				_scale = Number( _data.scale );
			}
			else
			{
				_scale = 0;
			}
			
			newValid = getValidityOfElement();
			if( newValid != _valid )
			{
				_validChanged = true;
				_valid = newValid;
			}
			
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
				var h:Number = IVisualElement( _data.element ).getLayoutBoundsHeight() * _scale;
				
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
			
			if( _validChanged )
			{
				_validChanged = false;
				if( !_valid )
				{
					var errorStrings:Array = getErrorStrings();
					errorString = ( errorStrings ) ? errorStrings.join( "\n" ) : null;
				}
				else
				{
					errorString = null;
				}
			}
			
			graphics.clear();
			
			if( !_valid )
			{
				graphics.beginFill( 0xFF0000, 1 );
				graphics.drawRect( 0, 0, unscaledWidth, unscaledHeight );
				graphics.endFill();
			}
		}
		
		private function getErrorStrings():Array
		{
			var uiComponent:UIComponent;
			
			if( _element is FormItem )
			{
				var errorStrings:Array = new Array();
				
				var e:IVisualElement;
				var formItem:FormItem = FormItem( _element );
				var numItems:int = formItem.numElements;
				for( var i:int = 0; i < numItems; i++ )
				{
					e = formItem.getElementAt( i );
					if( e is UIComponent )
					{
						uiComponent = UIComponent( e );
						if( uiComponent.errorString )
						{
							if( uiComponent.errorString.length ) errorStrings.push( uiComponent.errorString )
						}
					}
				}
				
				return errorStrings.length ? errorStrings : null;;
			}
			else if( _element is UIComponent )
			{
				uiComponent = UIComponent( _element );
				if( uiComponent.errorString )
				{
					if( uiComponent.errorString.length ) return [ uiComponent.errorString ];
				}
			}
			
			return null;
		}
		
		private var _validChanged:Boolean = true;
		private var _valid:Boolean = true;
		private function onElementValidChange( event:Event ):void
		{
			var newValid:Boolean = getValidityOfElement();
			if( newValid != _valid )
			{
				_validChanged = true;
				_valid = newValid;
				invalidateSize();
			}
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