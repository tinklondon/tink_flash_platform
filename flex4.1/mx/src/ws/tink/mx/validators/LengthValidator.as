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
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class LengthValidator extends Validator
	{
		public function LengthValidator()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Convenience method for calling a validator.
		 *  Each of the standard Flex validators has a similar convenience method.
		 *
		 *  @param validator The StringValidator instance.
		 *
		 *  @param value A field to validate.
		 *
		 *  @param baseField Text representation of the subfield
		 *  specified in the <code>value</code> parameter.
		 *  For example, if the <code>value</code> parameter specifies
		 *  value.mystring, the <code>baseField</code> value
		 *  is <code>"mystring"</code>.
		 *
		 *  @return An Array of ValidationResult objects, with one
		 *  ValidationResult  object for each field examined by the validator. 
		 *
		 *  @see mx.validators.ValidationResult
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function validateArrayLength(validator:LengthValidator,
											  value:Object,
											  baseField:String = null):Array
		{
			var results:Array = [];
			
			var maxLength:Number = Number(validator.maxLength);
			var minLength:Number = Number(validator.minLength);
			
			var length:int = value.length;
			
			if (!isNaN(maxLength) && length > maxLength)
			{
				results.push(new ValidationResult(
					true, baseField, "tooLong",
					StringUtil.substitute(validator.tooLongError, maxLength)));
				return results;
			}
			
			if (!isNaN(minLength) && length < minLength)
			{
				results.push(new ValidationResult(
					true, baseField, "tooShort",
					StringUtil.substitute(validator.tooShortError, minLength)));
				return results;
			}
			
			return results;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  maxLength
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the maxLength property.
		 */
		private var _maxLength:Object;
		
		/**
		 *  @private
		 */
		private var maxLengthOverride:Object;
		
		[Inspectable(category="General", defaultValue="null")]
		
		/** 
		 *  Maximum length for a valid String. 
		 *  A value of NaN means this property is ignored.
		 *
		 *  @default NaN
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get maxLength():Object
		{
			return _maxLength;
		}
		
		/**
		 *  @private
		 */
		public function set maxLength(value:Object):void
		{
			maxLengthOverride = value;
			
			_maxLength = value != null ?
				Number(value) :
				resourceManager.getNumber(
					"validators", "maxLength");
		}
		
		//----------------------------------
		//  minLength
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the minLength property.
		 */
		private var _minLength:Object;
		
		/**
		 *  @private
		 */
		private var minLengthOverride:Object;
		
		[Inspectable(category="General", defaultValue="null")]
		
		/** 
		 *  Minimum length for a valid String.
		 *  A value of NaN means this property is ignored.
		 *
		 *  @default NaN
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get minLength():Object
		{
			return _minLength;
		}
		
		/**
		 *  @private
		 */
		public function set minLength(value:Object):void
		{
			minLengthOverride = value;
			
			_minLength = value != null ?
				Number(value) :
				resourceManager.getNumber(
					"validators", "minLength");
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties: Errors
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  tooLongError
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the tooLongError property.
		 */
		private var _tooLongError:String;
		
		/**
		 *  @private
		 */
		private var tooLongErrorOverride:String;
		
		[Inspectable(category="Errors", defaultValue="null")]
		
		/** 
		 *  Error message when the String is longer
		 *  than the <code>maxLength</code> property.
		 *
		 *  @default "This string is longer than the maximum allowed length. This must be less than {0} characters long."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get tooLongError():String 
		{
			return _tooLongError;
		}
		
		/**
		 *  @private
		 */
		public function set tooLongError(value:String):void
		{
			tooLongErrorOverride = value;
			
			_tooLongError = value != null ?
				value :
				"This length is longer than the maximum allowed length. This must be less than {0} characters long."
		}
		
		//----------------------------------
		//  tooShortError
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the tooShortError property.
		 */
		private var _tooShortError:String;
		
		/**
		 *  @private
		 */
		private var tooShortErrorOverride:String;
		
		[Inspectable(category="Errors", defaultValue="null")]
		
		/** 
		 *  Error message when the string is shorter
		 *  than the <code>minLength</code> property.
		 *
		 *  @default "This string is shorter than the minimum allowed length. This must be at least {0} characters long."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get tooShortError():String 
		{
			return _tooShortError;
		}
		
		/**
		 *  @private
		 */
		public function set tooShortError(value:String):void
		{
			tooShortErrorOverride = value;
			
			_tooShortError = value != null ?
				value :
				"This length is shorter than the minimum allowed length. This must be at least {0} characters long."
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private    
		 */
		override protected function resourcesChanged():void
		{
			super.resourcesChanged();
			
			maxLength = maxLengthOverride;
			minLength = minLengthOverride;
			
			tooLongError = tooLongErrorOverride;
			tooShortError = tooShortErrorOverride;
		}
		
		
		
		/**
		 *  Override of the base class <code>doValidation()</code> method
		 *  to validate a String.
		 *
		 *  <p>You do not call this method directly;
		 *  Flex calls it as part of performing a validation.
		 *  If you create a custom Validator class, you must implement this method.</p>
		 *
		 *  @param value Object to validate.
		 *
		 *  @return An Array of ValidationResult objects, with one ValidationResult 
		 *  object for each field examined by the validator. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override protected function doValidation(value:Object):Array
		{
			
			var results:Array = super.doValidation(value);
			
			if( results.length > 0 || !required )
			{
				return results;
			}
			else
			{
				return LengthValidator.validateArrayLength(this, value, null);
			}
				
		}
		
		
	}
}