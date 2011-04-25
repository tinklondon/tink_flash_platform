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
		public function ValidationItem( document:UIComponent = null )
		{
			initialized( document, null );
		}
		
		
		//----------------------------------
		//  validateDisabledTargets
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the neverValidateOnTrigger property.
		 */
		private var _neverValidateOnTrigger:Boolean = false;
		
		/**
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
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
		//  validateOnTrigger
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
		//  validateOnTriggerAfterShown
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the validateOnTriggerAfterShown property.
		 */
		private var _validateOnTriggerAfterShown:Boolean = false;
		
		/**
		 *  @copy ws.tink.mx.validators.IValidationItem#validateOnTriggerAfterEnabled
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get validateOnTriggerAfterShown():Boolean
		{
			return _validateOnTriggerAfterShown;
		}
		
		/**
		 *  @private
		 */
		public function set validateOnTriggerAfterShown( value:Boolean ):void
		{
			if( _validateOnTriggerAfterShown == value ) return;
			
			_validateOnTriggerAfterShown = value;
		}
		
		
		//----------------------------------
		//  validateOnTriggerAfterEnabled
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the validateOnTrigger property.
		 */
		private var _validateOnTriggerAfterEnabled:Boolean = false;
		
		/**
		 *  @copy ws.tink.mx.validators.IValidationItem#validateOnTriggerAfterEnabled
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get validateOnTriggerAfterEnabled():Boolean
		{
			return _validateOnTriggerAfterEnabled;
		}
		
		/**
		 *  @private
		 */
		public function set validateOnTriggerAfterEnabled( value:Boolean ):void
		{
			if( _validateOnTriggerAfterEnabled == value ) return;
			
			_validateOnTriggerAfterEnabled = value;
		}
		
		
		
		//----------------------------------
		//  validateOnTriggerAfterAddedToDisplayList
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the validateOnTrigger property.
		 */
		private var _validateOnTriggerAfterAddedToDisplayList:Boolean = false;
		
		/**
		 *  @copy ws.tink.mx.validators.IValidationItem#validateOnTriggerAfterAddedToDisplayList
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get validateOnTriggerAfterAddedToDisplayList():Boolean
		{
			return _validateOnTriggerAfterAddedToDisplayList;
		}
		
		/**
		 *  @private
		 */
		public function set validateOnTriggerAfterAddedToDisplayList( value:Boolean ):void
		{
			if( _validateOnTriggerAfterAddedToDisplayList == value ) return;
			
			_validateOnTriggerAfterAddedToDisplayList = value;
		}
		
		
		
		//----------------------------------
		//  validateDisabledTarget
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the validateDisabledTargets property.
		 */
		private var _validateDisabledTarget:Boolean = false;
		
		/** 
		 *  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get validateDisabledTarget():Boolean
		{
			return _validateDisabledTarget;
		}
		
		/**
		 *  @private
		 */
		public function set validateDisabledTarget( value:Boolean ):void
		{
			if( _validateDisabledTarget == value ) return;
			
			_validateDisabledTarget = value;
		}
		
		
		
		//----------------------------------
		//  validateNoneVisibleTarget
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the validateNoneVisibleTarget property.
		 */
		private var _validateNoneVisibleTarget:Boolean = false;
		
		/** 
		 *  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get validateNoneVisibleTarget():Boolean
		{
			return _validateNoneVisibleTarget;
		}
		
		/**
		 *  @private
		 */
		public function set validateNoneVisibleTarget( value:Boolean ):void
		{
			if( _validateNoneVisibleTarget == value ) return;
			
			_validateNoneVisibleTarget = value;
		}
		
		
		
		
		//----------------------------------
		//  validateDisabledTarget
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the validateDisabledTargets property.
		 */
		private var _validateNoneDisplayedTarget:Boolean = false;
		
		/** 
		 *  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get validateNoneDisplayedTarget():Boolean
		{
			return _validateNoneDisplayedTarget;
		}
		
		/**
		 *  @private
		 */
		public function set validateNoneDisplayedTarget( value:Boolean ):void
		{
			if( _validateNoneDisplayedTarget == value ) return;
			
			_validateNoneDisplayedTarget = value;
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
			
//			removeTriggerListener();
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
			// If value is null we let invalidation
			// take place as it may have a valid value
			// on the next frame.
			if( _target == value && value != null ) return;
			
			
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
			
//			removeTriggerListener();
			_validator = value;
			invalidate();
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
			
			if( doValidation )
			{
				var currentTarget:IEventDispatcher = target;
				if( currentTarget )
				{
					if( !_isEnabled && !_validateDisabledTarget ) doValidation = false;
					if( !_isDisplayed && !_validateNoneDisplayedTarget ) doValidation = false;
					if( !_isVisible && !_validateNoneVisibleTarget ) doValidation = false;
				}
				else
				{
					doValidation = false;
				}
			}
			
			
			if( doValidation )
			{
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
				
				results = validator.validate().results;
				
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
				
				if( results )
				{
					if( results.length > 0 )
					{
						resultEvent = new ValidationResultEvent( ValidationResultEvent.INVALID, false, false, null, results );
						dispatchEvent( resultEvent );
						return resultEvent;
					}
				}
			}
			
			resultEvent = new ValidationResultEvent( ValidationResultEvent.VALID );
			dispatchEvent( resultEvent );
			
			return resultEvent;
		}
				
		
		private var _activeTriggerEvent:String;
		private var _activeTarget:IEventDispatcher;
		private var _isDisplayed:Boolean;
		private var _isEnabled:Boolean;
		private var _isVisible:Boolean;
		
		/**
		 *  @private
		 */
		private function addTriggerListener():void
		{
			if( target )
			{
				_activeTriggerEvent = triggerEvent;
				_activeTarget = target;
				
//				if( _activeTarget is DisplayObject )
//				{
//					_isDisplayed = DisplayObject( _activeTarget ).stage != null;
//				}
//				else
//				{
//					_isDisplayed = false;
//				}
				
				_isDisplayed = isTargetDisplayed( _activeTarget );
				_isEnabled = isTargetEnabled( _activeTarget );
				_isVisible = isTargetVisible( _activeTarget );
				
				
					
				_activeTarget.addEventListener( _activeTriggerEvent, onTargetTrigger, false );
				_activeTarget.addEventListener( "enabledChanged", onTargetEnabledChange, false, 0, true );
				_activeTarget.addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true );
				_activeTarget.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );
				_activeTarget.addEventListener( FlexEvent.SHOW, onShow, false, 0, true );
				_activeTarget.addEventListener( FlexEvent.HIDE, onHide, false, 0, true );
			}
		}
		
		/**
		 *  @private
		 */
		private function removeTriggerListener():void
		{
			if( _activeTarget )
			{
				_activeTarget.removeEventListener( _activeTriggerEvent, onTargetTrigger, false );
				_activeTarget.removeEventListener( "enabledChanged", onTargetEnabledChange, false );
				_activeTarget.removeEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage, false );
				_activeTarget.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false );
				_activeTarget.removeEventListener( FlexEvent.SHOW, onShow, false );
				_activeTarget.removeEventListener( FlexEvent.HIDE, onHide, false );
				
				_activeTriggerEvent = null;
				_activeTarget = null;
			}
		}
		
		private function fakeValid():void
		{
			var currentTarget:IEventDispatcher = target;
			if( currentTarget )
			{
				var previousTarget:IEventDispatcher = IEventDispatcher( validator.source );
				var previousListener:IValidatorListener = IValidatorListener( validator.listener );
				
				validator.source = currentTarget;
				validator.listener = listener;
				validator.dispatchEvent( new ValidationResultEvent( ValidationResultEvent.VALID ) );
				
				validator.source = previousTarget;
				validator.listener = previousListener;
			}
		}
		
		/**
		 *  @private
		 */
		private function onTargetTrigger( event:Event ):void
		{
			if( _validateOnTrigger && !_neverValidateOnTrigger )
			{
				_validateRequired = true;
				invalidate();
			}
		}
		
		/**
		 *  @private
		 */
		private function onTargetEnabledChange( event:Event ):void
		{
			_isEnabled = isTargetEnabled( event.currentTarget );
			if( _isEnabled )
			{
				_validateOnTrigger = _validateOnTriggerAfterEnabled;
			}
			else
			{
				if( !_validateNoneVisibleTarget )
				{
					_fakeValidateRequired = true;
					invalidate();
				}
			}
		}
		
		private function onShow( event:FlexEvent ):void
		{
			_isVisible = true;
			_validateOnTrigger = _validateOnTriggerAfterShown;
			
		}
		
		/**
		 *  @private
		 */
		private function onHide( event:FlexEvent ):void
		{
			_isVisible = false;
			if( !_validateNoneVisibleTarget )
			{
				_fakeValidateRequired = true;
				invalidate();
			}
		}
		
		private function onAddedToStage( event:Event ):void
		{
			_isDisplayed = true;
			_validateOnTrigger = _validateOnTriggerAfterAddedToDisplayList;
		}
		
		/**
		 *  @private
		 */
		private function onRemovedFromStage( event:Event ):void
		{
			_isDisplayed = false;
			
			if( !_validateNoneDisplayedTarget )
			{
				_fakeValidateRequired = true;
				invalidate();
			}
		}
		
		private var _validateRequired		: Boolean;
		private var _fakeValidateRequired	: Boolean;
		
		/**
		 *  @private
		 */
		override protected function commit():void
		{
			super.commit();
			
			removeTriggerListener();
			addTriggerListener();
			
			if( _validateRequired )
			{
				_validateRequired = false;
				validate();
			}
			
			if( _fakeValidateRequired )
			{
				_fakeValidateRequired = false;
				fakeValid();
			}
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
		
		
		
		private function isTargetEnabled( t:Object ):Boolean
		{
			if( "enabled" in t )
			{
				return t[ "enabled" ];
			}
			
			return false;
		}
		
		private function isTargetVisible( t:Object ):Boolean
		{
			if( "visible" in t )
			{
				return t[ "visible" ];
			}
			
			return false;
		}
		
		private function isTargetDisplayed( t:Object ):Boolean
		{
			if( _activeTarget is DisplayObject )
			{
				return DisplayObject( _activeTarget ).stage != null;
			}
			
			return false;
		}
		
	}
}