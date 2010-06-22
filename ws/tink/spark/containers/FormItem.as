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
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.ValidationResultEvent;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.SkinnableContainer;
	import spark.components.SkinnableDataContainer;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.ElementExistenceEvent;
	
	use namespace mx_internal;
	
	[Event(name="validChange", type="flash.events.Event")]
	[Event(name="labelChanged", type="flash.events.Event")]
	
	public class FormItem extends SkinnableContainer
	{
		
		
		
		
		[SkinPart( required="false" )]
		
		/**
		 *  A skin part that defines the label of the form item. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var labelDisplay	: Label;
		
		[SkinPart( required="false" )]
		
		/**
		 *  A skin part that defines the error label of the form item. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var errorDisplay	: Label;
		
		
		private var _errorStrings	: Vector.<String> = new Vector.<String>();
		
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function FormItem()
		{
			super();
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );
		}
		
		
		//----------------------------------
		//  enabled
		//----------------------------------
		
		private var _enabledChanged:Boolean = false;
		/**
		 *  @private
		 */
		override public function set enabled(value:Boolean):void
		{
			if( enabled != value )
			{
				_enabledChanged = true;
				invalidateProperties();
			}
			
			super.enabled = value;
		}
		
		
		
		private var _valid:Boolean = true;
		
		[Bindable( event="validChange" )]
		public function get valid():Boolean
		{
			return _valid;
		}
		
		
		private var _validator:Validator;
		public function get validator():Validator
		{
			return _validator;
		}
		public function set validator( value:Validator ):void
		{
			if( _validator == value ) return;
			
			_validator = value;
		}
		
		
		private var _labelChange:Boolean;
		private var _label	: String;
		public function get label():String
		{
			return _label;
		}
		public function set label( value:String ):void
		{
			if( _label == value ) return;
			
			_labelChange = true;
			_label = value;
			
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			
			// Changing the label could affect the overall form label width
			// so we need to invalidate our parent's size here too
			if( owner is Form ) Form( parent ).invalidateLabelWidth();
			
			dispatchEvent(new Event("labelChanged"));
		}
		
		
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if( labelDisplay ) labelDisplay.width = calculateLabelWidth();
		}
		
		override protected function getCurrentSkinState():String
		{
			var state:String = super.getCurrentSkinState();
			
			if( _errorStrings.length ) return "error" + state.substr( 0, 1 ).toUpperCase() + state.substr( 1 );
			
			return state;
		}
		
		
		
		/**
		 *  @private
		 */
		internal function getPreferredLabelWidth():Number
		{
			if (!label || label == "" || !labelDisplay)
				return 0;
			
			if (isNaN(labelDisplay.measuredWidth))
				labelDisplay.validateSize();
			
			var labelWidth:Number = labelDisplay.measuredWidth;
			
			if (isNaN(labelWidth))
				return 0;
			
			return labelWidth;
		}
		
		
		/**
		 *  @private
		 */
		private function calculateLabelWidth():Number
		{
			var labelWidth:Number = getStyle("labelWidth");
			
			// labelWidth of 0 is the same as NaN
			if (labelWidth == 0)
				labelWidth = NaN;
			
			if (isNaN(labelWidth) && owner is Form)
				labelWidth = Form(owner).calculateLabelWidth();
			
			if (isNaN(labelWidth))
				labelWidth = getPreferredLabelWidth();
			
			return labelWidth;
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			if( instance == contentGroup )
			{
				contentGroup.addEventListener(
					ElementExistenceEvent.ELEMENT_ADD, onCenterGroupElementAdd, false, 0, true );
				contentGroup.addEventListener(
					ElementExistenceEvent.ELEMENT_REMOVE, onCenterGroupElementRemove, false, 0, true );
			}
			super.partAdded( partName, instance );
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if( instance == contentGroup )
			{
				contentGroup.removeEventListener(
					ElementExistenceEvent.ELEMENT_ADD, onCenterGroupElementAdd, false );
				contentGroup.removeEventListener(
					ElementExistenceEvent.ELEMENT_REMOVE, onCenterGroupElementRemove, false );
			}
			
			super.partRemoved( partName, instance );
		}
		
		/**
		 *  @private
		 */
		private function onCenterGroupElementAdd( event:ElementExistenceEvent ):void
		{
			if( event.element is UIComponent )
			{
				var element:UIComponent = UIComponent( event.element );
				element.enabled = false;
				element.addEventListener( "errorStringChanged", onElementErrorStringChange, false, 0, true );
			}
		}
		
		/**
		 *  @private
		 */
		private function onCenterGroupElementRemove( event:ElementExistenceEvent ):void
		{
			if( event.element is UIComponent )
			{
				event.element.removeEventListener( "errorStringChanged", onElementErrorStringChange, false );
			}
		}
		
		/**
		 *  @private
		 */
		private function onAddedToStage( event:Event ):void
		{
			if( owner is Form ) Form( owner ).invalidateLabelWidth();
		}
		
		private var _validChanged	: Boolean;
		private function onElementErrorStringChange( event:Event ):void
		{
			_validChanged = true;
			invalidateProperties();
			// Hack to get around commitProperties not getting called due to it
			// being ran when the component was disabled.
			if( !enabled ) callLater( invalidateProperties );
		}
			
		override protected function commitProperties():void
		{
			if( _validChanged )
			{
				commitValidity();
				invalidateSkinState();
			}
			
			super.commitProperties();
			
			if( _labelChange && labelDisplay )
			{
				labelDisplay.text = label;
				labelDisplay.validateSize();
				_labelChange = false;
			}
			
			if( _validChanged )
			{
				_validChanged = false;
				if( errorDisplay ) errorDisplay.text = _errorStrings.join();
			}
			
			if( _enabledChanged )
			{
				_enabledChanged = false;
				if( contentGroup )
				{
					var element:IVisualElement;
					var numItems:int = contentGroup.numElements;
					for( var i:int = 0; i < numItems; i++ )
					{
						element = contentGroup.getElementAt( i );
						if( element is UIComponent )
						{
							UIComponent( element ).enabled = enabled;
						}
					}
				}
			}
		}
		
		protected function commitValidity():void
		{
			var newValid:Boolean = true;
			
			_errorStrings = new Vector.<String>;
			
			var element:IVisualElement;
			var n:int = numElements;
			for( var i:int = 0; i < n; i++ )
			{
				element = getElementAt( i );
				if( element is UIComponent )
				{
					if( UIComponent( element ).errorString )
					{
						_errorStrings.push( UIComponent( element ).errorString );
						newValid = false;
						break;
					}
				}
			}
			
			if( _valid != newValid )
			{
				_valid = newValid;
				dispatchEvent( new FlexEvent( _valid ? FlexEvent.VALID : FlexEvent.INVALID ) );
				dispatchEvent( new Event( "validChange" ) );
			}
			
			
		}
		
	}
}