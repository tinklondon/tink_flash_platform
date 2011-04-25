////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2010 Tink Ltd | http://www.tink.ws
//	
//	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//	documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
//	the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//	to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//	
//	The above copyright notice and this permission notice shall be included in all copies or substantial portions
//	of the Software.
//	
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
//	THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
//	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

package ws.tink.mx.validators
{
	import mx.core.UIComponent;
	import mx.events.ValidationResultEvent;
	
	import ws.tink.mx.core.MXMLObject;
	

	public class ValidationGroup extends MXMLObject
	{
		
		private var _lastResults		: Array;
		private var _lastValidResults	: Array;
		private var _lastInvalidResults	: Array;
		private var _valid					: Boolean = true;
		
		public function ValidationGroup( document:UIComponent = null )
		{
			initialized( document, null );
		}
		
		public function get lastResults():Array
		{
			return _lastResults;
		}
		
		public function get lastValidResults():Array
		{
			return _lastValidResults;
		}
		
		public function get lastInvalidResults():Array
		{
			return _lastInvalidResults;
		}
		
		public function get valid():Boolean
		{
			return _valid;
		}
		
		
		
		
//		private var _document:Object;
//		/**
//		 *  Called automatically by the MXML compiler when the Validator
//		 *  is created using an MXML tag.  
//		 *
//		 *  @param document The MXML document containing this Validator.
//		 *
//		 *  @param id Ignored.
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 9
//		 *  @playerversion AIR 1.1
//		 *  @productversion Flex 3
//		 */
//		public function initialized(document:Object, id:String):void
//		{
//			_document = document;
//		}
		
		private var _validateOnTriggerAfterValidate:Boolean = true;
		public function get validateOnTriggerAfterValidate():Boolean
		{
			return _validateOnTriggerAfterValidate;
		}
		public function set validateOnTriggerAfterValidate( value:Boolean ):void
		{
			_validateOnTriggerAfterValidate = value;
		}
		
		
		private var _validateOnTrigger:Boolean = false;
		public function get validateOnTrigger():Boolean
		{
			return _validateOnTrigger;
		}
		public function set validateOnTrigger( value:Boolean ):void
		{
			_validateOnTrigger = value;
			invalidate();
		}
		
		private var _validators:Array;
		[ArrayElementType("ws.tink.mx.validators.IValidationItem")]
		public function get validationItems():Array
		{
			return _validators;
		}
		public function set validationItems( value:Array ):void
		{
			if( _validators == value )return;
			
			_validators = value;
			invalidate();
		}
		
		
		
		
		private var _enabled:Boolean = true;
		public function get enabled():Boolean
		{
			return _enabled;
		}
		public function set enabled( value:Boolean ):void
		{
			if( _enabled == value ) return;
			
			_enabled = value;
		}
		
		
		public function validate():Boolean
		{
			
			_lastValidResults = new Array();
			_lastResults = new Array();
			_lastInvalidResults = new Array();
			
			if( !_validators || !_enabled )
			{
				_valid = true;
				return _valid;
			}
			
			_valid = false;
			
			var e:ValidationResultEvent;
			for each( var v:IValidationItem in _validators )
			{
				v.addEventListener( ValidationResultEvent.INVALID, onValidationItemResult, false, 0, true );
				v.addEventListener( ValidationResultEvent.VALID, onValidationItemResult, false, 0, true );
				v.validate();
				v.removeEventListener( ValidationResultEvent.INVALID, onValidationItemResult, false );
				v.removeEventListener( ValidationResultEvent.VALID, onValidationItemResult, false );
//				e.target = v;
//				trace( e.target = v );
			}
			
			if( _validateOnTriggerAfterValidate ) validateOnTrigger = true;
			
			_valid = _lastInvalidResults.length == 0;
			
			return _valid;
		}
		
		override protected function commit():void
		{
			super.commit();
			
			for each( var validatorItem:IValidationItem in _validators )
			{
				validatorItem.validateOnTrigger = _validateOnTrigger;
			} 
		}
		
		private function onValidationItemResult( event:ValidationResultEvent ):void
		{
			_lastResults.push( event );
			
			switch( event.type )
			{
				case ValidationResultEvent.INVALID :
				{
					_lastInvalidResults.push( event );
					break;
				}
				case ValidationResultEvent.VALID :
				{
					_lastValidResults.push( event );
					break;
				}
			}
		}
	}
}