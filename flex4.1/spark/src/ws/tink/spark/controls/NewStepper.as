////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2008 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package ws.tink.spark.controls
{
	
	import flash.accessibility.Accessibility;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.SelectionEvent;
	import flashx.textLayout.operations.InsertTextOperation;
	
	import mx.collections.ArrayList;
	import mx.core.IIMESupport;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.managers.IFocusManager;
	import mx.managers.IFocusManagerComponent;
	import mx.managers.ISystemManager;
	import mx.utils.BitFlagUtil;
	
	import spark.components.DropDownList;
	import spark.components.Label;
	import spark.components.RichEditableText;
	import spark.components.Spinner;
	import spark.components.TextInput;
	import spark.components.TextSelectionHighlighting;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	
	import ws.tink.spark.skins.supportClasses.TargetSkinBase;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
//	include "../../styles/metadata/BasicNonInheritingTextStyles.as"
//	include "../../styles/metadata/BasicInheritingTextStyles.as"
//	include "../../styles/metadata/AdvancedInheritingTextStyles.as"
//	include "../../styles/metadata/SelectionFormatTextStyles.as"
	
	/**
	 *  The alpha of the border for this component.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="borderAlpha", type="Number", inherit="no", theme="spark", minValue="0.0", maxValue="1.0")]
	
	/**
	 *  The color of the border for this component.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="borderColor", type="uint", format="Color", inherit="no", theme="spark")]
	
	/**
	 *  Controls the visibility of the border for this component.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="borderVisible", type="Boolean", inherit="no", theme="spark")]
	
	/**
	 *  The alpha of the content background for this component.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="contentBackgroundAlpha", type="Number", inherit="yes", theme="spark", minValue="0.0", maxValue="1.0")]
	
	/**
	 *  @copy spark.components.supportClasses.GroupBase#contentBackgroundColor
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="contentBackgroundColor", type="uint", format="Color", inherit="yes", theme="spark")]
	
	/**
	 *  The alpha of the focus ring for this component.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="focusAlpha", type="Number", inherit="no", theme="spark", minValue="0.0", maxValue="1.0")]
	
	/**
	 *  @copy spark.components.supportClasses.GroupBase#focusColor
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */ 
	[Style(name="focusColor", type="uint", format="Color", inherit="yes", theme="spark")]
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispached after the <code>selectionAnchorPosition</code> and/or
	 *  <code>selectionActivePosition</code> properties have changed
	 *  for any reason.
	 *
	 *  @eventType mx.events.FlexEvent.SELECTION_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="selectionChange", type="mx.events.FlexEvent")]
	
	
	/**
	 *  Dispatched after a user editing operation is complete.
	 *
	 *  @eventType flash.events.Event.CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	/*[Event(name="change", type="flash.events.Event")]*/
	
	/**
	 *  The base class for skinnable components, such as the Spark TextInput
	 *  and TextArea, that include an instance of RichEditableText in their skin
	 *  to provide rich text display, scrolling, selection, and editing.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class NewStepper extends Spinner
		implements IIMESupport
	{
//		include "../../core/Version.as";
		
		
		
		private var _date:Date;
		
		override public function changeValueByStep(increase:Boolean = true):void
		{
			if( stepSize == 0 ) return;
			
			var multiplier:Number;
			var digit:Number;
			var max:Number;
			
			switch( _lastFocusedField )
			{
				case hoursDisplay :
				{
					multiplier = 60 * 60 * 1000;
					digit = hours;
					max = 24;
					break;
				}
				case minutesDisplay :
				{
					multiplier = 60 * 1000;
					digit = minutes;
					max = 60;
					break;
				}
				case secondsDisplay :
				{
					multiplier = 1000;
					digit = seconds;
					max = 60;
					break;
				}
				default :
				{
					multiplier = 1;
					digit = milliseconds;
					max = 1000;
				}
			}
			
			var baseValue:Number = value - ( digit * multiplier )
			var newValue:Number = ( increase ? digit + stepSize : digit - stepSize ) % max;
			if( newValue < 0 ) newValue = max + newValue;
			
			setValue( nearestValidValue( baseValue + ( newValue * multiplier ), snapInterval ) );
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private static const CONTENT_PROPERTY_FLAG:uint = 1 << 0;
		
		/**
		 *  @private
		 */
		private static const EDITABLE_PROPERTY_FLAG:uint = 1 << 2;
		
		/**
		 *  @private
		 */
		private static const IME_MODE_PROPERTY_FLAG:uint = 1 << 4;
		
		/**
		 *  @private
		 */
		private static const MAX_CHARS_PROPERTY_FLAG:uint = 1 << 5;
		
		/**
		 *  @private
		 */
		private static const MAX_WIDTH_PROPERTY_FLAG:uint = 1 << 6;
		
		/**
		 *  @private
		 */
		private static const SELECTABLE_PROPERTY_FLAG:uint = 1 << 8;
		
		/**
		 *  @private
		 */
		private static const SELECTION_HIGHLIGHTING_FLAG:uint = 1 << 9;
		

		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */    
		public function NewStepper()
		{
			super();
			
			_date = new Date();
			_date.fullYear = 1970;
			_date.month = 0;
			_date.date = 1;
			super.maximum = 24 * 60 * 60 * 1000;
			hasFocusableChildren = true;
		}
		
		
		private var _lastFocusedField:RichEditableText;
		private var _focusSetByUser:Boolean;
		private var _dateChanged:Boolean;
		
		public function get hours():uint
		{
			return use24HourClock ? _date.hours : _date.hours % 12;
		}
		
		public function get minutes():uint
		{
			return _date.minutes;
		}
		
		public function get seconds():uint
		{
			return _date.seconds;
		}
		
		public function get milliseconds():uint
		{
			return _date.milliseconds;
		}
		
		private var _use24HourClock:Boolean = true;
		public function set use24HourClock( value:Boolean ):void
		{
			if( _use24HourClock == value ) return;
			
			_use24HourClock = value;
			_dateChanged = true;
			invalidateProperties();
		}
		public function get use24HourClock():Boolean
		{
			return _use24HourClock;
		}
		
//		public function get time():uint
//		{
//			return _date.time;
//		}
//		/**
//		 *  @private
//		 */
//		public function set time( value:uint ):void
//		{
//			if( _date.time == value ) return;
//			
//			_date.time = value;
//			_dateChanged = true;
//			invalidateProperties();
//		}
		
		override protected function setValue(v:Number):void
		{
//			trace( v, "mmmm" );
			
			if( value != v || _dateChanged )
			{
				
			_dateChanged = false;
			
			_date.time = v;
			
			if( hoursDisplay ) hoursDisplay.text = padValue( hours, 2 );
			if( minutesDisplay ) minutesDisplay.text = padValue( minutes, 2 );
			if( secondsDisplay ) secondsDisplay.text = padValue( seconds, 2 );
			if( millisecondsDisplay ) millisecondsDisplay.text = padValue( milliseconds, 4 );
			
			if( meridiemDropDown )
			{
				meridiemDropDown.enabled = !_use24HourClock;
				meridiemDropDown.selectedIndex = ( _date.time > new Date( 1970, 0, 1, 12 ).time ) ? 1 : 0;
			}
			super.setValue( v );
			}
		}
		
		private function padValue( v:Number, length:uint ):String
		{
			var padding:String = "";
			var num:uint = length - v.toString().length;
			for( var i:int = 0; i < num; i++ )
			{
				padding += "0";
			}
//			if( v.toString().l
//			if( v < 10 ) return "0" + v.toString();
			return padding + v.toString();
		}
		
		override public function get maximum():Number
		{
			return 24 * 60 * 60 * 1000;
		}
		
		override public function set maximum(value:Number):void
		{
			throw new Error ("maximum cannot be set" );
		}
		
		override public function get minimum():Number
		{
			return 0;
		}
		
		override public function set minimum(value:Number):void
		{
			throw new Error ("minimum cannot be set" );
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skin parts
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  textDisplay
		//----------------------------------
		
		[SkinPart(required="false")]
		
		/**
		 *  The RichEditableText that may be present
		 *  in any skin assigned to this component.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var hoursDisplay:RichEditableText;
		
		[SkinPart(required="false")]
		
		/**
		 *  The RichEditableText that may be present
		 *  in any skin assigned to this component.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var minutesDisplay:RichEditableText;
		
		[SkinPart(required="false")]
		
		/**
		 *  The RichEditableText that may be present
		 *  in any skin assigned to this component.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var secondsDisplay:RichEditableText;
		
		[SkinPart(required="false")]
		
		/**
		 *  The RichEditableText that may be present
		 *  in any skin assigned to this component.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var millisecondsDisplay:RichEditableText;
		
		[SkinPart(required="false")]
		
		/**
		 *  The RichEditableText that may be present
		 *  in any skin assigned to this component.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var meridiemDropDown:DropDownList;
		
		/**
		 *  @private
		 *  Several properties are proxied to hoursDisplay.  However, when 
		 *  hoursDisplay is not around, we need to store values set on 
		 *  SkinnableTextBase.  This object stores those values.  If hoursDisplay is 
		 *  around, the values are  stored  on the hoursDisplay directly.  However, 
		 *  we need to know what values have been set by the developer on 
		 *  TextInput/TextArea (versus set on the hoursDisplay or defaults of the 
		 *  hoursDisplay) as those are values we want to carry around if the 
		 *  hoursDisplay changes (via a new skin). In order to store this info 
		 *  efficiently, textDisplayProperties becomes a uint to store a series of 
		 *  BitFlags.  These bits represent whether a property has been explicitly 
		 *  set on this SkinnableTextBase.  When the  hoursDisplay is not around, 
		 *  textDisplayProperties is a typeless object to store these proxied 
		 *  properties.  When hoursDisplay is around, textDisplayProperties stores 
		 *  booleans as to whether these properties have been explicitly set or not.
		 */
		private var textDisplayProperties:Object = {};
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties: UIComponent
		//
		//--------------------------------------------------------------------------
		
		/*
		
		Note:
		
		SkinnableTextBase does not have an accessibilityImplementation
		because, if it does, the Flash Player doesn't support text-selection
		accessibility. The selectionAnchorIndex and selectionActiveIndex
		getters of the acc impl don't get called, probably because Player 10.1
		doesn't like the fact that stage.focus is the texDisplay:RichEditableText
		part instead of the SinnableTextBase component (i.e., the TextInput
		or TextArea).
		
		Instead, we rely on the RichEditableTextAccImpl of the hoursDisplay
		to provide accessibility.
		
		However, developers expect to be able to control accessibility by setting
		accessibilityProperties, accessibilityName, accessibilityDescription,
		tabIndex, etc. on the component itself.
		
		In order to make these settings usable by RichEditableTextAccImpl,
		we push them down into the accessibilityProperties of the RichEditableText,
		using the invalidateProperties() / commitProperties() pattern.
		
		*/
		
		//----------------------------------
		//  accessibilityEnabled
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function set accessibilityEnabled(value:Boolean):void
		{
			if (!Capabilities.hasAccessibility)
				return;
			
			if (!accessibilityProperties)
				accessibilityProperties = new AccessibilityProperties();
			
			accessibilityProperties.silent = !value;
			accessibilityPropertiesChanged = true;
			
			invalidateProperties();
		}
		
		//----------------------------------
		//  accessibilityDescription
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function set accessibilityDescription(value:String):void
		{
			if (!Capabilities.hasAccessibility)
				return;
			
			if (!accessibilityProperties)
				accessibilityProperties = new AccessibilityProperties();
			
			accessibilityProperties.description = value;
			accessibilityPropertiesChanged = true;
			
			invalidateProperties();
		}
		
		//----------------------------------
		//  accessibilityName
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function set accessibilityName(value:String):void 
		{
			if (!Capabilities.hasAccessibility)
				return;
			
			if (!accessibilityProperties)
				accessibilityProperties = new AccessibilityProperties();
			
			accessibilityProperties.name = value;
			accessibilityPropertiesChanged = true;
			
			invalidateProperties();
		}
		
		//----------------------------------
		//  accessibilityProperties
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the accessibilityProperties property.
		 */
		private var _accessibilityProperties:AccessibilityProperties = null;
		
		/**
		 *  @private
		 */
		private var accessibilityPropertiesChanged:Boolean = false;
		
		/**
		 *  @private
		 */
		override public function get accessibilityProperties():AccessibilityProperties
		{
			return _accessibilityProperties;
		}
		
		/**
		 *  @private
		 */
		override public function set accessibilityProperties(
			value:AccessibilityProperties):void
		{
			_accessibilityProperties = value;
			accessibilityPropertiesChanged = true;
			
			invalidateProperties();
		}
		
		//----------------------------------
		//  accessibilityShortcut
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function set accessibilityShortcut(value:String):void
		{
			if (!Capabilities.hasAccessibility)
				return;		
			
			if (!accessibilityProperties)
				accessibilityProperties = new AccessibilityProperties();
			
			accessibilityProperties.shortcut = value;
			accessibilityPropertiesChanged = true;
			
			invalidateProperties();
		}
		
		//----------------------------------
		//  baselinePosition
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get baselinePosition():Number
		{
			return getBaselinePositionForPart(hoursDisplay);
		}
		
		//----------------------------------
		//  maxWidth
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get maxWidth():Number
		{
			if (hoursDisplay)
				return hoursDisplay.maxWidth;
			
			// want the default to be default max width for UIComponent
			var v:* = textDisplayProperties.maxWidth;
			return (v === undefined) ? super.maxWidth : v;        
		}
		
		/**
		 *  @private
		 */
		override public function set maxWidth(value:Number):void
		{
			if (hoursDisplay)
			{
				hoursDisplay.maxWidth = value;
				textDisplayProperties = BitFlagUtil.update(
					uint(textDisplayProperties), MAX_WIDTH_PROPERTY_FLAG, true);
			}
			else
			{
				textDisplayProperties.maxWidth = value;
			}
			
			// Generate an UPDATE_COMPLETE event.
			invalidateProperties();                    
		}
		
		//----------------------------------
		//  tabIndex
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the tabIndex property.
		 */
		private var _tabIndex:int = -1;
		
		/**
		 *  @private
		 */
		override public function get tabIndex():int
		{
			return _tabIndex;
		}
		
		/**
		 *  @private
		 */
		override public function set tabIndex(
			value:int):void
		{
			_tabIndex = value;
			accessibilityPropertiesChanged = true;
			
			invalidateProperties();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties proxied to hoursDisplay
		//
		//--------------------------------------------------------------------------
		
		
		//----------------------------------
		//  editable
		//----------------------------------
		
		/**
		 *  @copy spark.components.RichEditableText#editable
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get editable():Boolean
		{
			if (hoursDisplay)
				return hoursDisplay.editable;
			
			// want the default to be true
			var v:* = textDisplayProperties.editable;
			return (v === undefined) ? true : v;
		}
		
		/**
		 *  @private
		 */
		public function set editable(value:Boolean):void
		{
			if (hoursDisplay)
			{
				hoursDisplay.editable = value;
				textDisplayProperties = BitFlagUtil.update(
					uint(textDisplayProperties), EDITABLE_PROPERTY_FLAG, true);
			}
			else
			{
				textDisplayProperties.editable = value;
			}
			
			// Generate an UPDATE_COMPLETE event.
			invalidateProperties();                    
		}
		
		//----------------------------------
		//  enableIME
		//----------------------------------
		
		/**
		 *  @copy spark.components.RichEditableText#enableIME
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get enableIME():Boolean
		{
			return editable;
		}
		
		//----------------------------------
		//  imeMode
		//----------------------------------
		
		/**
		 *  @copy spark.components.RichEditableText#imeMode
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get imeMode():String
		{
			if (hoursDisplay)        
				return hoursDisplay.imeMode;
			
			// want the default to be null
			var v:* = textDisplayProperties.imeMode;
			return (v === undefined) ? null : v;
		}
		
		/**
		 *  @private
		 */
		public function set imeMode(value:String):void
		{
			if (hoursDisplay)
			{
				hoursDisplay.imeMode = value;
				textDisplayProperties = BitFlagUtil.update(
					uint(textDisplayProperties), IME_MODE_PROPERTY_FLAG, true);
			}
			else
			{
				textDisplayProperties.imeMode = value;
			}
			
			// Generate an UPDATE_COMPLETE event.
			invalidateProperties();                    
		}
		
		
		
		//----------------------------------
		//  selectable
		//----------------------------------
		
		/**
		 *  @copy spark.components.RichEditableText#selectable
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get selectable():Boolean
		{
			if (hoursDisplay)
				return hoursDisplay.selectable;
			
			// want the default to be true
			var v:* = textDisplayProperties.selectable;
			return (v === undefined) ? true : v;
		}
		
		/**
		 *  @private
		 */
		public function set selectable(value:Boolean):void
		{
			if (hoursDisplay)
			{
				hoursDisplay.selectable = value;
				textDisplayProperties = BitFlagUtil.update(
					uint(textDisplayProperties), SELECTABLE_PROPERTY_FLAG, true);
			}
			else
			{
				textDisplayProperties.selectable = value;
			}
			
			// Generate an UPDATE_COMPLETE event.
			invalidateProperties();                    
		}
		
		//----------------------------------
		//  selectionActivePosition
		//----------------------------------
		
		/**
		 *  @private
		 */
		[Bindable("selectionChange")]
		
		/**
		 *  @copy spark.components.RichEditableText#selectionActivePosition
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get selectionActivePosition():int
		{
			return hoursDisplay ? hoursDisplay.selectionActivePosition : -1;
		}
		
		//----------------------------------
		//  selectionAnchorPosition
		//----------------------------------
		
		/**
		 *  @private
		 */
		[Bindable("selectionChange")]
		
		/**
		 *  @copy spark.components.RichEditableText#selectionAnchorPosition
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get selectionAnchorPosition():int
		{
			return hoursDisplay ? hoursDisplay.selectionAnchorPosition : -1;
		}
		
		//----------------------------------
		//  selectionHighlighting
		//----------------------------------
		
		/**
		 *  @copy spark.components.RichEditableText#selectionHighlighting
		 *  
		 *  @default TextSelectionHighlighting.WHEN_FOCUSED
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get selectionHighlighting():String 
		{
			if (hoursDisplay)
				return hoursDisplay.selectionHighlighting;
			
			// want the default to be "when focused"
			var v:* = textDisplayProperties.selectionHighlighting;
			return (v === undefined) ? TextSelectionHighlighting.WHEN_FOCUSED : v;
		}
		
		/**
		 *  @private
		 */
		public function set selectionHighlighting(value:String):void
		{
			if (hoursDisplay)
			{
				hoursDisplay.selectionHighlighting = value;
				textDisplayProperties = BitFlagUtil.update(
					uint(textDisplayProperties), 
					SELECTION_HIGHLIGHTING_FLAG, true);
			}
			else
			{
				textDisplayProperties.selectionHighlighting = value;
			}
			
			// Generate an UPDATE_COMPLETE event.
			invalidateProperties();                    
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (accessibilityPropertiesChanged)
			{
				if (hoursDisplay)
				{
					hoursDisplay.accessibilityProperties = _accessibilityProperties;
					hoursDisplay.tabIndex = _tabIndex;             
					
					// Note: Calling updateProperties() on players that don't
					// support accessibility will throw an RTE.
					if (Capabilities.hasAccessibility)
						Accessibility.updateProperties();
				}
				
				accessibilityPropertiesChanged = false;
			}
			
			if( _dateChanged )
			{
				setValue( _date.time );
			}
		}
		
		
		protected function setDefaultLastFocusedField( instance:RichEditableText, added:Boolean ):void
		{
			// if a new part has been added and the focus hasn't been set by the user
			if( added && !_focusSetByUser )
			{
				
				if( hoursDisplay )
				{
					_lastFocusedField = hoursDisplay;
					return;
				}
				
				if( minutesDisplay )
				{
					_lastFocusedField = minutesDisplay;
					return;
				}
				
				if( secondsDisplay )
				{
					_lastFocusedField = secondsDisplay;
					return;
				}
				
				if( millisecondsDisplay )
				{
					_lastFocusedField = millisecondsDisplay;
					return;
				}
				
			}
			// if the last focused field has been removed, find the next default field
			else if( _lastFocusedField == instance )
			{
				if( hoursDisplay )
				{
					_lastFocusedField = hoursDisplay;
					return;
				}
				
				if( minutesDisplay )
				{
					_lastFocusedField = minutesDisplay;
					return;
				}
				
				if( secondsDisplay )
				{
					_lastFocusedField = secondsDisplay;
					return;
				}
				
				if( millisecondsDisplay )
				{
					_lastFocusedField = millisecondsDisplay;
					return;
				}
				
				_lastFocusedField = null;
			}
		}
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			switch( instance )
			{
				case hoursDisplay :
				case minutesDisplay :
				case secondsDisplay :
				case millisecondsDisplay :
				{
					var textDisplay:RichEditableText = RichEditableText( instance );
					textDisplay.setStyle( "focusSkin", TargetSkinBase );
					
					textDisplayAdded( textDisplay );            
					
					
					// Start listening for various events from the RichEditableText.
					
					textDisplay.addEventListener(SelectionEvent.SELECTION_CHANGE,
						textDisplay_selectionChangeHandler);
					
					textDisplay.addEventListener(TextOperationEvent.CHANGING, 
						textDisplay_changingHandler);
					
					textDisplay.addEventListener(TextOperationEvent.CHANGE,
						textDisplay_changeHandler);

					textDisplay.addEventListener(FlexEvent.VALUE_COMMIT,
						textDisplay_valueCommitHandler);
					
					textDisplay.addEventListener(FocusEvent.FOCUS_IN,
						textDisplay_focusInHandler);
					
					setDefaultLastFocusedField( textDisplay, true );
					
					_dateChanged = true;
					invalidateProperties();
					break;
				}
				case meridiemDropDown :
				{
					meridiemDropDown.dataProvider = new ArrayList( [ "AM", "PM" ] );
					meridiemDropDown.addEventListener( IndexChangeEvent.CHANGE, onMeridiemChange, false, 0, true );
					_dateChanged = true;
					invalidateProperties();
					break;
				}
			}
		}
		
		/**
		 *  @private
		 */
		override protected function partRemoved(partName:String, 
												instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			switch( instance )
			{
				case hoursDisplay :
				case minutesDisplay :
				case secondsDisplay :
				case millisecondsDisplay :
				{
					var textDisplay:RichEditableText = RichEditableText( instance );
					
					// Copy proxied values from hoursDisplay (if explicitly set) to 
					// textDisplayProperties.                        
					textDisplayRemoved( textDisplay );            
					
					// Stop listening for various events from the RichEditableText.
					
					textDisplay.removeEventListener(SelectionEvent.SELECTION_CHANGE,
						textDisplay_selectionChangeHandler);
					
					textDisplay.removeEventListener(TextOperationEvent.CHANGING,
						textDisplay_changingHandler);
					
					textDisplay.removeEventListener(TextOperationEvent.CHANGE,
						textDisplay_changeHandler);
					
					textDisplay.removeEventListener(FlexEvent.VALUE_COMMIT,
						textDisplay_valueCommitHandler);
					
					setDefaultLastFocusedField( textDisplay, true );
					break;
				}
			}
		}
		
		/**
		 *  @private
		 */
		override protected function getCurrentSkinState():String
		{
			return enabled ? "normal" : "disabled";
		}
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
		
		
		
		/**
		 *  @private
		 *  Copy values stored locally into hoursDisplay now that hoursDisplay 
		 *  has been added.
		 */
		private function textDisplayAdded( textDisplay:RichEditableText ):void
		{        
			var newTextDisplayProperties:uint = 0;
			
			textDisplay.heightInLines = 1;
			textDisplay.restrict = "0123456789";
			textDisplay.text = "00";
			textDisplay.widthInChars = 2;
			
			// Switch from storing properties to bit mask of stored properties.
			textDisplayProperties = newTextDisplayProperties;    
			
		}
		
		/**
		 *  @private
		 *  Copy values stored in hoursDisplay back to local storage since 
		 *  hoursDisplay is about to be removed.
		 */
		private function textDisplayRemoved( textDisplay:RichEditableText ):void
		{        
			var newTextDisplayProperties:Object = {};
			
			
			if (BitFlagUtil.isSet(uint(textDisplayProperties), 
				EDITABLE_PROPERTY_FLAG))
			{
				newTextDisplayProperties.editable = textDisplay.editable;
			}
			
			if (BitFlagUtil.isSet(uint(textDisplayProperties), 
				IME_MODE_PROPERTY_FLAG))
			{
				newTextDisplayProperties.imeMode = textDisplay.imeMode;
			}
			
			if (BitFlagUtil.isSet(uint(textDisplayProperties), 
				MAX_CHARS_PROPERTY_FLAG))
			{
				newTextDisplayProperties.maxChars = textDisplay.maxChars;
			}
			
			if (BitFlagUtil.isSet(uint(textDisplayProperties), 
				MAX_WIDTH_PROPERTY_FLAG))
			{
				newTextDisplayProperties.maxWidth = textDisplay.maxWidth;
			}
			
			if (BitFlagUtil.isSet(uint(textDisplayProperties), 
				SELECTABLE_PROPERTY_FLAG))
			{
				newTextDisplayProperties.selectable = textDisplay.selectable;
			}
			
			if (BitFlagUtil.isSet(uint(textDisplayProperties), 
				SELECTION_HIGHLIGHTING_FLAG))
			{
				newTextDisplayProperties.selectionHighlighting = 
					textDisplay.selectionHighlighting;
			}
			
			// Switch from storing bit mask to storing properties.
			textDisplayProperties = newTextDisplayProperties;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden event handlers
		//
		//--------------------------------------------------------------------------
		override public function initialize():void
		{
			super.initialize();
			addEventListener(Event.ADDED_TO_STAGE, addedToStage );
		}
		
		private function addedToStage( event:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage );
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage );
			stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, onFocusReason, false, 1 );
			stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onFocusReason, false, 1);
		}
		
		private function removedFromStage( event:Event ):void
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage );
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage );
			stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, onFocusReason, false );
			stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, onFocusReason, false);
		}
		
		private var _focusReason:String;
		private function onFocusReason( event:FocusEvent ):void
		{
			_focusReason = event.type;
		}
		
		/**
		 *  @private
		 *  Focus should always be on the internal RichEditableText.
		 */
		override public function setFocus():void
		{
			if( stage )
			{
				if( _focusReason == FocusEvent.KEY_FOCUS_CHANGE || !_lastFocusedField ) _lastFocusedField = hoursDisplay;
					
				stage.focus = _lastFocusedField;
				
				// Since the API ignores the visual editable and selectable 
				// properties make sure the selection should be set first.
				if( _lastFocusedField && ( _lastFocusedField.editable || _lastFocusedField.selectable ) )
				{
					_lastFocusedField.selectAll();
				}
			}
		}
		
		/**
		 *  @private
		 */
		override protected function isOurFocus(target:DisplayObject):Boolean
		{
			return target == hoursDisplay || target == minutesDisplay || target == secondsDisplay || super.isOurFocus(target);
		}
		
		/**
		 *  @private
		 */
		override protected function focusInHandler(event:FocusEvent):void
		{
			if (event.target == this)
			{
				// call setFocus on ourselves to pass focus to the
				// hoursDisplay.  This situation occurs when the
				// player occasionally takes over the first TAB
				// on a newly activated Window with nothing currently
				// in focus
				setFocus();
				return;
			}
			
			// Only editable text should have a focus ring.
			if (enabled && editable && focusManager)
				focusManager.showFocusIndicator = true;
			
			super.focusInHandler(event);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private var _selectAllInvoked:Boolean;
		/**
		 *  @private
		 *  Called when the RichEditableText dispatches a 'selectionChange' event.
		 */
		private function textDisplay_selectionChangeHandler(event:Event):void
		{
			var textDisplay:RichEditableText = RichEditableText( event.currentTarget );
			
			if( !_selectAllInvoked )
			{
				_selectAllInvoked = true;
				textDisplay.selectAll();
			}
			else if( textDisplay.selectionAnchorPosition == 0 && textDisplay.selectionActivePosition == 2 )
			{
				_selectAllInvoked = false;
			}
		}
		
		
		/**
		 *  Called when the RichEditableText dispatches a 'change' event
		 *  after an editing operation.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		private function textDisplay_changeHandler(event:TextOperationEvent):void
		{        
			trace( "textDisplay_changeHandler" );
//			_date.hours = uint( hoursDisplay.text );
//			_date.minutes = uint( mi.text );
//			_date.hours = uint( hoursDisplay.text );
//			trace( "textDisplay_changeHandler", hoursDisplay.text, _date.hours );
			//trace(id, "textDisplay_changeHandler", hoursDisplay.text);
//			var input:RichEditableText = RichEditableText( event.currentTarget );
//			input.text = "00";
//			if( Number( input.text ) < 10 )
//			{
//				input.text = padValue( Number( input.text ) );
//			}
//			trace( minutesDisplay.text );
			
			// The text component has changed.  Generate an UPDATE_COMPLETE event.
			invalidateDisplayList();
			
			// Redispatch the event that came from the RichEditableText.
			//dispatchEvent(event);
		}
		
		/**
		 *  @private
		 *  Called when the RichEditableText dispatches a 'changing' event
		 *  before an editing operation.
		 */
		private function textDisplay_changingHandler(event:TextOperationEvent):void
		{
			var input:RichEditableText = RichEditableText( event.currentTarget );
			if( event.operation is InsertTextOperation )
			{
				var v:uint;
				var maxFigs:int;
				var max:uint;
				var multiplier:uint;
				var otherValues:uint;
				switch( input )
				{
					case hoursDisplay :
					{
						maxFigs = 10;
						v = hours;
						max = 24;
						multiplier = 60 * 60 * 1000;
						otherValues = ( minutes * 60 * 1000 ) + ( seconds * 1000 );
						break;
					}
					case minutesDisplay :
					{
						maxFigs = 10;
						v = minutes;
						max = 60;
						multiplier = 60 * 1000;
						otherValues = ( hours * 60 * 60 * 1000 ) + ( seconds * 1000 );
						break;
					}
					case secondsDisplay :
					{
						maxFigs = 10;
						v = seconds;
						max = 60;
						multiplier = 1000;
						otherValues = ( hours * 60 * 60 * 1000 ) + ( minutes * 60 * 1000 );
						break;
					}
					case millisecondsDisplay :
					{
						maxFigs = 1000;
						v = milliseconds;
						max = 1000;
						multiplier = 1;
						otherValues = ( hours * 60 * 60 * 1000 ) + ( minutes * 60 * 1000 );
						break;
					}
				}
				
				if( v < maxFigs )
				{
					if( uint( v.toString() + InsertTextOperation( event.operation ).text ) < max )
					{
						setValue( v + uint( v.toString() + InsertTextOperation( event.operation ).text ) * multiplier );
					}
					else if( v != uint( InsertTextOperation( event.operation ).text ) )
					{
						setValue( v + uint( InsertTextOperation( event.operation ).text ) * multiplier );
					}
					else
					{
						trace( "noooo" );
					}
				}
				else
				{
					setValue( v + uint( InsertTextOperation( event.operation ).text ) * multiplier );
					
				}
			}
			
			event.preventDefault();
		}
		
		/**
		 *  @private
		 *  Called when the RichEditableText dispatches an 'enter' event
		 *  in response to the Enter key.
		 */
//		private function textDisplay_enterHandler(event:Event):void
//		{
//			// Redispatch the event that came from the RichEditableText.
//			dispatchEvent(event);
//		}
		
		/**
		 *  @private
		 *  Called when the RichEditableText dispatches an 'valueCommit' event
		 *  when values are changed programmatically or by user interaction.
		 *  Before the hoursDisplay part is loaded, any properties set are held
		 *  in textDisplayProperties.  We don't want to dispatch 'valueCommit' when 
		 *  there isn't a hoursDisplay since since the event will be dispatched by 
		 *  RET when the hoursDisplay part is added.
		 */
		private function textDisplay_valueCommitHandler(event:Event):void
		{
			var t:RichEditableText = RichEditableText( event.currentTarget );
			t.selectAll();
		}
		
		
		private function textDisplay_focusInHandler( event:FocusEvent ):void
		{
			_lastFocusedField = RichEditableText( event.currentTarget );
			_lastFocusedField.drawFocus( false );
			// Since the API ignores the visual editable and selectable 
			// properties make sure the selection should be set first.
			if( _lastFocusedField && ( _lastFocusedField.editable || _lastFocusedField.selectable ) )
			{
				_lastFocusedField.selectAll();
			}
			
			drawFocusAnyway = true;
			drawFocus(true);
		}
		
		
		private function onMeridiemChange( event:IndexChangeEvent ):void
		{
			var twelveHours:Number = 12 * 60 * 60 * 1000;
			_dateChanged = true;
			setValue( event.newIndex == 0 ? value - twelveHours : value + twelveHours );
		}
	}
	
}
