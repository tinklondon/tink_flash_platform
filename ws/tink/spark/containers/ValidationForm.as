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

package ws.tink.spark.containers
{
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	import mx.validators.Validator;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	import ws.tink.mx.validators.ValidationGroup;
	import ws.tink.mx.validators.ValidationItem;
	
	[DefaultProperty("mxmlContentFactory")]
	
	public class ValidationForm extends Form
	{
		
		
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function ValidationForm()
		{
			super();
			
		}
		
		public function get lastResults():Array
		{
			return ( _validationGroup ) ? _validationGroup.lastResults : null;
		}
		
		public function get lastValidResults():Array
		{
			return ( _validationGroup ) ? _validationGroup.lastValidResults : null;
		}
		
		public function get lastInvalidResults():Array
		{
			return ( _validationGroup ) ? _validationGroup.lastInvalidResults : null;
		}
		
		public function get valid():Boolean
		{
			return ( _validationGroup ) ? _validationGroup.valid : true;
		}
		
		public function validate():Boolean
		{
			return ( _validationGroup ) ? _validationGroup.validate() : true;
		}
		
		//----------------------------------
		//  validationGroup
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the validationGroup property.
		 */
		private var _validationGroup:ValidationGroup;
		
		/**
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get validationGroup():ValidationGroup
		{
			return _validationGroup;
		}
		
		/**
		 *  @private
		 */
		public function set validationGroup( value:ValidationGroup ):void
		{
			if( _validationGroup == value ) return;
			
			_validationGroup = value;
			_validationGroup.initialized( this, null );
			invalidateValidationItems();
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if( !_validationGroup ) validationGroup = new ValidationGroup();
		}
		
		
		private var _validationItemsChange:Boolean;
		public function invalidateValidationItems():void
		{
			_validationItemsChange = true;
			invalidateProperties();
		}
		
		override public function addElement(element:IVisualElement):IVisualElement
		{
			invalidateValidationItems();
			return super.addElement( element );
		}
		
		override public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			invalidateValidationItems();
			return super.addElementAt( element, index );
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if( _validationItemsChange )
			{
				_validationItemsChange = false;
				
				if( !_validationGroup ) return;
				
				var validationItems:Array = new Array();
				var n:int = numElements;
				for (var i:int = 0; i < n; i++)
				{
					var child:IVisualElement = getElementAt(i);
					
					if (child is ValidationFormItem && child.includeInLayout)
					{
						validationItems = validationItems.concat( ValidationFormItem( child ).validationItems );
					}
				}
				
				for each( var v:ValidationItem in validationItems )
				{
					v.initialized( this, null );
				}
				
				_validationGroup.validationItems = validationItems;
			}
		}
		
	}
}