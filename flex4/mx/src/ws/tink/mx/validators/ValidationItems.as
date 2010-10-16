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
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.UIComponent;
	import mx.events.ValidationResultEvent;
	import mx.validators.IValidatorListener;
	import mx.validators.Validator;
	
	import ws.tink.mx.core.MXMLObjectDispatcher;

	/**
	 * 
	 * @author downste
	 */
	public class ValidationItems extends MXMLObjectDispatcher implements IValidationItem
	{
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 3
		 */
		public function ValidationItems()
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
//		private var _defaultTriggerEvent:String;
//		/** 
//		 *  @copy mx.effects.IEffect#target
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 9
//		 *  @playerversion AIR 1.1
//		 *  @productversion Flex 3
//		 */
//		public function get defaultTriggerEvent():String
//		{
//			return _defaultTriggerEvent;
//		}
//		
//		/**
//		 *  @private
//		 */
//		public function set triggerEvent( value:String ):void
//		{
//			removeTriggerListeners();
//			_defaultTriggerEvent = value;
//			invalidate();
//		}
		
		
		
		//----------------------------------
		//  triggerEvents
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the targets property.
		 */
		private var _triggerEvents:Array = [];
		
		[Inspectable(arrayType="String")]
		[ArrayElementType("String")]
		
		/**
		 *  @copy mx.effects.IEffect#targets
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get triggerEvents():Array
		{
			return _triggerEvents;
		}
		
		/**
		 *  @private
		 */
		public function set triggerEvents( value:Array ):void
		{
			removeTriggerListeners();
			_triggerEvents = value;
			invalidate();
		}
		
		
		
		
		
		
		//----------------------------------
		//  properties
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the targets property.
		 */
		private var _properties:Array = [];
		
		[Inspectable(arrayType="String")]
		[ArrayElementType("String")]
		
		/**
		 *  @copy mx.effects.IEffect#targets
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get properties():Array
		{
			return _properties;
		}
		
		/**
		 *  @private
		 */
		public function set properties( value:Array ):void
		{
			_properties = value;
		}
		
		
		//----------------------------------
		//  targets
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the targets property.
		 */
		private var _targets:Array = [];
		
		[Inspectable(arrayType="IEventDispatcher")]
		[ArrayElementType("flash.events.IEventDispatcher")]
		
		/**
		 *  @copy mx.effects.IEffect#targets
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get targets():Array
		{
			return _targets;
		}
		
		/**
		 *  @private
		 */
		public function set targets( value:Array ):void
		{
			trace( "hjhjhjh", value );
			removeTriggerListeners();
			
			_targets = value;
			invalidate();
		}
		
		
		
		//----------------------------------
		//  listener
		//----------------------------------
		
//		/** 
//		 *  @copy mx.effects.IEffect#target
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 9
//		 *  @playerversion AIR 1.1
//		 *  @productversion Flex 3
//		 */
//		public function get listener():IValidatorListener
//		{
//			if( _listeners.length > 0 ) return IValidatorListener( _listeners[ 0 ] ); 
//			
//			return null;
//		}
//		
//		/**
//		 *  @private
//		 */
//		public function set listener( value:IValidatorListener ):void
//		{
//			listeners = [ value ];
//		}
		
		
		
		//----------------------------------
		//  listeners
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the listeners property.
		 */
		private var _listeners:Array = [];
		
		[Inspectable(arrayType="IValidatorListener")]
		[ArrayElementType("mx.validators.IValidatorListener")]
		
		/**
		 *  @copy mx.effects.IEffect#targets
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get listeners():Array
		{
			return _listeners;
		}
		
		/**
		 *  @private
		 */
		public function set listeners( value:Array ):void
		{
			_listeners = value;
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
			
			removeTriggerListeners();
			
			_validator = value;
			invalidate();
		}
		
		
		private var _targetsToString:String;
		
		
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
			
			if( !_enabled || !_targets || !validator ) doValidation = false;
			
			var results:Array = new Array();
			var r:Array;
			
			
			if( doValidation )
			{
				var numTargets:int = _targets.length;
				for ( var i:int = 0; i < numTargets; i++ )
				{
					r = validateIndex( i, true );
					if( r ) results.concat( r );
				}
			}
			
			var resultEvent:ValidationResultEvent;
			
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
		
		protected function validateIndex( i:int, surpressEvents:Boolean = false ):Array
		{
			var t:IEventDispatcher = getTargetByIndex( i, _targets );
			
			var results:Array;
			
			if( t )
			{
				var fakeValidated:Boolean;
				if( "enabled" in t && !_validateDisabledTargets )
				{
					// We now have to make sure its valid.
					// We dont want it to remain invalid if it has just been disabled
					fakeValidated = !t[ "enabled" ];
//					{
//						validator.
//						return null;
//					}
				}
				
				if( t is DisplayObject && _validateDisabledTargets )
				{
					fakeValidated = DisplayObject( t ).stage == null;
				}
				
				
				
				var errorSet:Object;
				var previousErrorSet:Object = new Object();
				
				var prop:String;
				errorSet = getErrorSetByIndex( i );
				for( prop in errorSet )
				{
					try
					{
						previousErrorSet[ prop ] = validator[ prop ];
						validator[ prop ] = errorSet[ prop ];
					}
					catch( e:Error )
					{
						
					}
				}
				
				var previousProperty:String = validator.property;
				var previousListener:Object = validator.listener;
				var previousTarget:Object = validator.source;
				
				validator.property = getPropertyByIndex( i );
				validator.listener = getListenerByIndex( i );
				validator.source = t;
				
				// fake a validation result to make sure the target is valid
				// because we don't want disabled targets staying invalid when disabled
				// if _validateDisabledTargets is false
				if( fakeValidated )
				{
//					trace( "fakeValidated" );
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
				
				if( t is UIComponent ) UIComponent( t ).callLater( UIComponent( t ).invalidateProperties );
				
				if( !surpressEvents )
				{
					var resultEvent:ValidationResultEvent;
					
					if( results )
					{
						if( results.length > 0 )
						{
							dispatchEvent( new ValidationResultEvent( ValidationResultEvent.INVALID, false, false, null, results ) );
							return results;
						}
					}
					
					dispatchEvent( new ValidationResultEvent( ValidationResultEvent.VALID ) );
				}
			}
			
			
			return results;
		}
	
		
		
		private var _activeTriggerEvents:Array;
		private var _activeTargets:Array;
		
		/**
		 *  @private
		 */
		private function addTriggerListeners():void
		{
			
			if( _targets && validator )
			{
				_activeTriggerEvents = _triggerEvents.concat();
				_activeTargets = _targets.concat();
					
				var target:IEventDispatcher;
				var numTargets:int = _activeTargets.length;
				for ( var i:int = 0; i < numTargets; i++ )
				{
					target = getTargetByIndex( i, _activeTargets );
					if( target )
					{
						target.addEventListener( getTriggerEventByIndex( i, _activeTriggerEvents ), onSourceTrigger, false );
						target.addEventListener( "enabledChanged", onTargetEnabledChange, false, 0, true );
						target.addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true );
						trace( "target", target, _targets );
					}
				}
			}
		}
		
		/**
		 *  @private
		 */
		private function removeTriggerListeners():void
		{
			if( _activeTargets )
			{
				var target:IEventDispatcher;
				var numTargets:int = _activeTargets.length;
				for ( var i:int = 0; i < numTargets; i++ )
				{
					target = getTargetByIndex( i, _activeTargets );
					if( target )
					{
						target.removeEventListener( getTriggerEventByIndex( i, _activeTriggerEvents ), onSourceTrigger, false );
						target.removeEventListener( "enabledChanged", onTargetEnabledChange, false );
						target.removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage, false );
					}
				}
				
				_activeTriggerEvents = null;
				_activeTargets = null;
			}
		}
		
		/**
		 *  @private
		 */
		private function onSourceTrigger( event:Event ):void
		{
			if( _enabled && _validateOnTrigger && !_neverValidateOnTrigger )
			{
				validateIndex( getIndexByTarget( IEventDispatcher( event.currentTarget ) ) );
			}
		}
		
		/**
		 *  @private
		 */
		private function onTargetEnabledChange( event:Event ):void
		{
			if( _enabled )
			{
				if( "enabled" in event.currentTarget )
				{
					if( !event.currentTarget[ "enabled" ] ) validateIndex( getIndexByTarget( IEventDispatcher( event.currentTarget ) ) );
				}
			}
		}
		
		private function onRemovedFromStage( event:Event ):void
		{
			trace( "onRemovedFromStage" );
			validateIndex( getIndexByTarget( IEventDispatcher( event.currentTarget ) ) );
		}
		
		
		/**
		 *  @private
		 */
		private function getPropertyByIndex( i:int ):String
		{
			if( _properties )
			{
				if( _properties.length > 0 )
				{
					if( _properties.length >= i + 1 )
					{
						if( _properties[ i ] is String ) return _properties[ i ].toString();
					}
				}
			}
			
			return validator.property;
		}
		
		/**
		 *  @private
		 */
		private function getListenerByIndex( i:int ):IValidatorListener
		{
			if( _listeners )
			{
				if( _listeners.length > 0 )
				{
					if( _listeners.length >= i + 1 )
					{
						if( _listeners[ i ] is IValidatorListener ) return IValidatorListener( _listeners[ i ] );
					}
				}
			}
			
			return IValidatorListener( validator.listener );
		}
		
		/**
		 *  @private
		 */
		private function getErrorSetByIndex( i:int ):Object
		{
			if( _errorSets )
			{
				if( _errorSets.length > 0 )
				{
					if( _errorSets.length >= i + 1 )
					{
						if( _errorSets[ i ] ) return _errorSets[ i ];
					}
				}
			}
			
			return null
		}
		
		/**
		 *  @private
		 */
		private function getTriggerEventByIndex( i:int, items:Array ):String
		{
			if( items )
			{
				if( items.length > 0 )
				{
					if( items.length >= i + 1 )
					{
						if( items[ i ] is String ) return items[ i ].toString();
					}
				}
			}
			
			return validator.triggerEvent;
		}
		
		/**
		 *  @private
		 */
		private function getTargetByIndex( i:int, items:Array ):IEventDispatcher
		{
			if( i < 0 || i > items.length - 1 ) return null;
			return IEventDispatcher( items[ i ] );
		}
		
		/**
		 *  @private
		 */
		private function getIndexByTarget( t:IEventDispatcher ):int
		{
			var numTargets:int = _targets.length;
			for ( var i:int = 0; i < numTargets; i++ )
			{
				if( IEventDispatcher( _targets[ i ] ) == t ) return i;
			}
			
			return -1;
		}
		
		/**
		 *  @private
		 */
		override protected function commit():void
		{
			if( !_activeTargets ) addTriggerListeners();
		}
		
		
		
		
		
		
		
		//----------------------------------
		//  errorSets
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the targets property.
		 */
		private var _errorSets:Array = [];
		
		[Inspectable(arrayType="Object")]
		[ArrayElementType("Object")]
		
		/**
		 *  @copy mx.effects.IEffect#targets
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get errorSets():Array
		{
			return _errorSets;
		}
		
		/**
		 *  @private
		 */
		public function set errorSets( value:Array ):void
		{
			_errorSets = value;
		}
	
	}
}