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
	import flash.events.IEventDispatcher;
	
	import mx.core.IMXMLObject;
	import mx.events.ValidationResultEvent;

	public interface IValidationItem extends IMXMLObject, IEventDispatcher
	{
		
		/**
		 *  Performs validation on all targets and notifies
		 *  the listeners of the result. 
		 *
		 *  @return A ValidationResultEvent object
		 *  containing the results of the validation. 
		 *  For a successful validation, the
		 *  <code>ValidationResultEvent.results</code> Array property is empty. 
		 *  For a validation failure, the
		 *  <code>ValidationResultEvent.results</code> Array property contains
		 *  one ValidationResult object for each field checked by the validator, 
		 *  both for fields that failed the validation and for fields that passed. 
		 *  Examine the <code>ValidationResult.isError</code>
		 *  property to determine if the field passed or failed the validation. 
		 *
		 *  @see mx.events.ValidationResultEvent
		 *  @see mx.validators.ValidationResult
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		function validate():ValidationResultEvent
			
		/**
		 *  Boolean to determin whether validation should take 
		 *  place when a triggerEvent is dispatched from a target
		 * 
		 *  @default true
		 */
		function set validateOnTrigger( value:Boolean ):void
	}
}