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

package ws.tink.mx.validators
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.IMXMLObject;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ValidationResultEvent;
	import mx.validators.IValidatorListener;
	import mx.validators.Validator;
	
	import ws.tink.mx.core.MXMLObjectDispatcher;

	/**
	 * 
	 * @author downste
	 */
	public class ValidationItem extends MXMLObjectDispatcher implements IValidationItem
	{
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 3
		 */
		public function ValidationItem()
		{
		}
		
		
		//----------------------------------
		//  validateDisabledTargets
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the neverValidateOnTrigger property.
		 */
		private var _neverValidateOnTrigger:Boolean = false;
		public function get neverValidateOnTrigger():Boolean
		{
			return _neverValidateOnTrigger;
		}
		
		/**
		 *  @private
		 */
		public function set neverValidateOnTrigger( value:Boolean ):void
		{
			if( _neverValidateOnTrigger == value ) return;
			
			_neverValidateOnTrigger = value;
		}
		
		
		
		//----------------------------------
		//  validateDisabledTargets
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the validateOnTrigger property.
		 */
		private var _validateOnTrigger:Boolean = true;
		
		/**
		 *  @copy ws.tink.mx.validators.IValidationItem#validateOnTrigger
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get validateOnTrigger():Boolean
		{
			return _validateOnTrigger;
		}
		
		/**
		 *  @private
		 */
		public function set validateOnTrigger( value:Boolean ):void
		{
			if( _validateOnTrigger == value ) return;
			
			_validateOnTrigger = value;
		}
		
		
		
		//----------------------------------
		//  validateDisabledTargets
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the validateDisabledTargets property.
		 */
		private var _validateDisabledTargets:Boolean = false;
		
		/** 
		 *  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get validateDisabledTargets():Boolean
		{
			return _validateDisabledTargets;
		}
		
		/**
		 *  @private
		 */
		public function set validateDisabledTargets( value:Boolean ):void
		{
			if( _validateOnTrigger == value ) return;
			
			_validateDisabledTargets = value;
		}
		
		
		
		//----------------------------------
		//  enabled
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the enabled property.
		 */
		private var _enabled:Boolean = true;
		
		/** 
		 *  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 *  @private
		 */
		public function set enabled( value:Boolean ):void
		{
			if( _enabled == value ) return;
			
			_enabled = value;
		}
		
		
		
		//----------------------------------
		//  triggerEvent
		//----------------------------------
		private var _triggerEvent:String;
		
		/** 
		 *  @copy mx.effects.IEffect#target
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get triggerEvent():String
		{
			return ( _triggerEvent ) ? _triggerEvent : ( validator ) ? validator.triggerEvent : _triggerEvent;
		}
		
		/**
		 *  @private
		 */
		public function set triggerEvent( value:String ):void
		{
			if( _triggerEvent == value ) return;
			
			removeTriggerListener();
			_triggerEvent = value
			invalidate();
		}
		
		
		
		
		
		
		//----------------------------------
		//  property
		//----------------------------------
		private var _property	: String;
		/** 
		 *  @copy mx.effects.IEffect#target
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get property():String
		{
			return ( _property ) ? _property : ( validator ) ? validator.property : _property;
		}
		
		/**
		 *  @private
		 */
		public function set property( value:String ):void
		{
			_property = value;
		}
		
		
		//----------------------------------
		//  target
		//----------------------------------
		private var _target		: IEventDispatcher;
		
		/** 
		 *  @copy mx.effects.IEffect#target
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get target():IEventDispatcher
		{
			return ( _target ) ? _target : ( validator ) ? IEventDispatcher( validator.source ) : _target;
		}
		
		/**
		 *  @private
		 */
		public function set target( value:IEventDispatcher ):void
		{
			if( _target == value ) return;
			
			removeTriggerListener();
			_target = value
			invalidate();
		}
		
				
		
		//----------------------------------
		//  listener
		//----------------------------------
		private var _listener	: IValidatorListener;
		/** 
		 *  @copy mx.effects.IEffect#target
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get listener():IValidatorListener
		{
			return ( _listener ) ? _listener : IValidatorListener( target );
		}
		
		/**
		 *  @private
		 */
		public function set listener( value:IValidatorListener ):void
		{
			_listener = value;
		}
		
		
		
		
		//----------------------------------
		//  validator
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the validator property.
		 */
		private var _validator:Validator;
		
		/**
		 *  @copy mx.effects.IEffect#targets
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get validator():Validator
		{
			return _validator;
		}
		
		/**
		 *  @private
		 */
		public function set validator( value:Validator ):void
		{
			if( _validator == value ) return;
			
			_validator = value;
		}
		
		
		
		
		
		/**
		 *  @copy ws.tink.mx.validators.IValidationItem#validate
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function validate():ValidationResultEvent
		{
			var doValidation:Boolean = true;
			
			if( !_enabled || !target || !validator ) doValidation = false;
			
			var resultEvent:ValidationResultEvent;
			var results:Array = new Array();
//			var r:Array;
			
			if( doValidation )
			{
				var currentTarget:IEventDispatcher = target;
				if( currentTarget )
				{
					var fakeValidated:Boolean;
					
					if( "enabled" in currentTarget && !_validateDisabledTargets )
					{
						fakeValidated = !currentTarget[ "enabled" ];
					}
					
					if( currentTarget is DisplayObject && _validateDisabledTargets )
					{
						fakeValidated = DisplayObject( currentTarget ).stage == null;
					}
					
					var previousTarget:IEventDispatcher = IEventDispatcher( validator.source );
					
					var currentListener:IValidatorListener = listener;
					var previousListener:IValidatorListener = IValidatorListener( validator.listener );
					
					var currentProperty:String = property;
					var previousProperty:String = validator.property;
					
					var errorSet:Object;
					var previousErrorSet:Object = new Object();
					
					var prop:String;
					for( prop in _errorSet )
					{
						try
						{
							previousErrorSet[ prop ] = validator[ prop ];
							validator[ prop ] = _errorSet[ prop ];
						}
						catch( e:Error )
						{
							
						}
						
					}
					
					validator.property = currentProperty;
					validator.listener = currentListener;
					validator.source = currentTarget;
					
					// fake a validation result to make sure the target is valid
					// because we don't want disabled targets staying invalid when disabled
					// if _validateDisabledTargets is false
					if( fakeValidated )
					{
						validator.dispatchEvent( new ValidationResultEvent( ValidationResultEvent.VALID ) );
					}
						// Carry out the proper validation
					else
					{
						results = validator.validate().results;
					}
					
					for( prop in previousErrorSet )
					{
						try
						{
							validator[ prop ] = previousErrorSet[ prop ];
						}
						catch( e:Error )
						{
							
						}
						
					}
					validator.source = previousTarget;
					validator.property = previousProperty;
					validator.listener = previousListener;
					
					if( currentTarget is UIComponent ) UIComponent( currentTarget ).callLater( UIComponent( currentTarget ).invalidateProperties );
					
					if( results.length > 0 )
					{
						resultEvent = new ValidationResultEvent( ValidationResultEvent.INVALID, false, false, null, results );
					}
					else
					{
						resultEvent = new ValidationResultEvent( ValidationResultEvent.VALID );
					}
					
					dispatchEvent( resultEvent );
					return resultEvent;
				}
			}
			
			resultEvent = new ValidationResultEvent( ValidationResultEvent.VALID );
			dispatchEvent( resultEvent );
			return resultEvent;
		}
		
//		protected function validateIndex( i:int, surpressEvents:Boolean = false ):Array
//		{
//			var t:IEventDispatcher = getTargetByIndex( i, _targets );
//			
//			var results:Array;
//			
//			
//			if( t )
//			{
//				if( "enabled" in t && !_validateDisabledTargets )
//				{
//					if( !t[ "enabled" ] ) return null;
//				}
//				
//				var listener:IValidatorListener;
//				var errorSet:Object;
//				var previousErrorSet:Object = new Object();
//				
//				var prop:String;
//				errorSet = getErrorSetByIndex( i );
//				for( prop in errorSet )
//				{
//					try
//					{
//						previousErrorSet[ prop ] = validator[ prop ];
//						validator[ prop ] = errorSet[ prop ];
//					}
//					catch( e:Error )
//					{
//						
//					}
//					
//				}
//				
//				listener = getListenerByIndex( i );
//				validator.property = getPropertyByIndex( i );
//				validator.listener = ( listener ) ? listener : t;
//				validator.source = t;
//				results = validator.validate().results;
//				
//				for( prop in previousErrorSet )
//				{
//					try
//					{
//						validator[ prop ] = previousErrorSet[ prop ];
//					}
//					catch( e:Error )
//					{
//						
//					}
//					
//				}
//				validator.source = null;
//				validator.property = null;
//				validator.listener = null;
//				
//				if( t is UIComponent ) UIComponent( t ).callLater( UIComponent( t ).invalidateProperties );
//				
//				if( !surpressEvents )
//				{
//					var resultEvent:ValidationResultEvent;
//					
//					if( results )
//					{
//						if( results.length > 0 )
//						{
//							dispatchEvent( new ValidationResultEvent( ValidationResultEvent.INVALID, false, false, null, results ) );
//							return results;
//						}
//					}
//					
//					dispatchEvent( new ValidationResultEvent( ValidationResultEvent.VALID ) );
//				}
//			}
//			
//			
//			return results;
//		}
	
		
		
		private var _activeTriggerEvent:String;
		private var _activeTarget:IEventDispatcher;
		
		/**
		 *  @private
		 */
		private function addTriggerListener():void
		{
			if( target )
			{
				_activeTriggerEvent = triggerEvent;
				_activeTarget = target;
					
				_activeTarget.addEventListener( _activeTriggerEvent, onSourceTrigger, false );
			}
		}
		
		/**
		 *  @private
		 */
		private function removeTriggerListener():void
		{
			if( _activeTarget )
			{
				_activeTarget.removeEventListener( _activeTriggerEvent, onSourceTrigger, false );
				_activeTriggerEvent = null;
				_activeTarget = null;
			}
		}
		
		/**
		 *  @private
		 */
		private function onSourceTrigger( event:Event ):void
		{
			if( _enabled && _validateOnTrigger && !_neverValidateOnTrigger )
			{
				validate();
			}
		}
		
		/**
		 *  @private
		 */
//		private function getPropertyByIndex( i:int ):String
//		{
//			if( _properties )
//			{
//				if( _properties.length > 0 )
//				{
//					if( _properties.length >= i + 1 )
//					{
//						return String( _properties[ i ] ? _properties[ i ] : _properties[ 0 ] );
//					}
//					else
//					{
//						return String( _properties[ 0 ] );
//					}
//				}
//			}
//			
//			return null;
//		}
//		
//		/**
//		 *  @private
//		 */
//		private function getListenerByIndex( i:int ):IValidatorListener
//		{
//			if( _listeners )
//			{
//				if( _listeners.length > 0 )
//				{
//					if( _listeners.length >= i + 1 )
//					{
//						return IValidatorListener( _listeners[ i ] ? _listeners[ i ] : _listeners[ 0 ] );
//					}
//					else
//					{
//						return IValidatorListener( _listeners[ 0 ] );
//					}
//				}
//			}
//			
//			return null;
//		}
//		
//		/**
//		 *  @private
//		 */
//		private function getErrorSetByIndex( i:int ):Object
//		{
//			if( _errorSets )
//			{
//				if( _errorSets.length > 0 )
//				{
//					if( _errorSets.length >= i + 1 )
//					{
//						if( _errorSets[ i ] ) return _errorSets[ i ];
//					}
//				}
//			}
//			
//			return null;
//		}
//		
//		/**
//		 *  @private
//		 */
//		private function getTriggerEventByIndex( i:int, items:Array ):String
//		{
//			if( items )
//			{
//				if( items.length > 0 )
//				{
//					if( items.length >= i + 1 )
//					{
//						return String( items[ i ] ? items[ i ] : items[ 0 ] );
//					}
//					else
//					{
//						return String( items[ 0 ] );
//					}
//				}
//			}
//			
//			return FlexEvent.VALUE_COMMIT;
//		}
//		
//		/**
//		 *  @private
//		 */
//		private function getTargetByIndex( i:int, items:Array ):IEventDispatcher
//		{
//			if( i < 0 || i > items.length - 1 ) return null;
//			return IEventDispatcher( items[ i ] );
//		}
//		
//		/**
//		 *  @private
//		 */
//		private function getIndexByTarget( t:IEventDispatcher ):int
//		{
//			var numTargets:int = _targets.length;
//			for ( var i:int = 0; i < numTargets; i++ )
//			{
//				if( IEventDispatcher( _targets[ i ] ) == t ) return i;
//			}
//			
//			return -1;
//		}
		
		/**
		 *  @private
		 */
		override protected function commit():void
		{
			if( !_activeTarget ) addTriggerListener();
		}
		
		
		
		
		
		//----------------------------------
		//  errorSet
		//----------------------------------
		private var _errorSet	: Object;
		/** 
		 *  @copy mx.effects.IEffect#target
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get errorSet():Object
		{
			return _errorSet;
		}
		
		/**
		 *  @private
		 */
		public function set errorSet( value:Object ):void
		{
			_errorSet = value;
		}
		
		
	}
}