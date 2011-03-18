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

package ws.tink.spark.controls
{
	
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventPhase;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.core.IFlexModule;
	import mx.core.IFlexModuleFactory;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.IActiveWindowManager;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Panel;
	import spark.components.supportClasses.TextBase;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 *  Name of the CSS style declaration that specifies 
	 *  styles for the Alert buttons. 
	 * 
	 *  @default "alertButtonStyle"
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="buttonStyleName", type="String", inherit="no")]
	
	/**
	 *  Name of the CSS style declaration that specifies
	 *  styles for the Alert message text. 
	 *
	 *  <p>You only set this style by using a type selector, which sets the style 
	 *  for all Alert controls in your application.  
	 *  If you set it on a specific instance of the Alert control, it can cause the control to 
	 *  size itself incorrectly.</p>
	 * 
	 *  @default undefined
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="messageStyleName", type="String", inherit="no")]
	
	/**
	 *  Name of the CSS style declaration that specifies styles
	 *  for the Alert title text. 
	 *
	 *  <p>You only set this style by using a type selector, which sets the style 
	 *  for all Alert controls in your application.  
	 *  If you set it on a specific instance of the Alert control, it can cause the control to 
	 *  size itself incorrectly.</p>
	 * 
	 *  @default "windowStyles" 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="titleStyleName", type="String", inherit="no")]
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[AccessibilityClass(implementation="mx.accessibility.AlertAccImpl")]
	
	[RequiresDataBinding(true)]
	
	[ResourceBundle("controls")]
	
	/**
	 *  The Alert control is a pop-up dialog box that can contain a message,
	 *  a title, buttons (any combination of OK, Cancel, Yes, and No) and an icon. 
	 *  The Alert control is modal, which means it will retain focus until the user closes it.
	 *
	 *  <p>Import the mx.controls.Alert class into your application, 
	 *  and then call the static <code>show()</code> method in ActionScript to display
	 *  an Alert control. You cannot create an Alert control in MXML.</p>
	 *
	 *  <p>The Alert control closes when you select a button in the control, 
	 *  or press the Escape key.</p>
	 *
	 *  @includeExample examples/SimpleAlert.mxml
	 *
	 *  @see mx.managers.SystemManager
	 *  @see mx.managers.PopUpManager
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	
	
	public class Alert extends Panel
	{
//		include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class mixins
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Placeholder for mixin by AlertAccImpl.
		 */
		mx_internal static var createAccessibilityImplementation:Function;
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Class properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  buttonHeight
		//----------------------------------
		
		[Inspectable(category="Size")]
		
		/**
		 *  Height of each Alert button, in pixels.
		 *  All buttons must be the same height.
		 *
		 *  @default 22
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static var buttonHeight:Number = 21;
		
		//----------------------------------
		//  buttonWidth
		//----------------------------------
		
		[Inspectable(category="Size")]
		
		/**
		 *  Width of each Alert button, in pixels.
		 *  All buttons must be the same width.
		 *
		 *  @default 60
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static var buttonWidth:Number = 65;
		
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Static method that pops up the Alert control. The Alert control 
		 *  closes when you select a button in the control, or press the Escape key.
		 * 
		 *  @param text Text string that appears in the Alert control. 
		 *  This text is centered in the alert dialog box.
		 *
		 *  @param title Text string that appears in the title bar. 
		 *  This text is left justified.
		 *
		 *  @param flags Which buttons to place in the Alert control.
		 *  Valid values are <code>Alert.OK</code>, <code>Alert.CANCEL</code>,
		 *  <code>Alert.YES</code>, and <code>Alert.NO</code>.
		 *  The default value is <code>Alert.OK</code>.
		 *  Use the bitwise OR operator to display more than one button. 
		 *  For example, passing <code>(Alert.YES | Alert.NO)</code>
		 *  displays Yes and No buttons.
		 *  Regardless of the order that you specify buttons,
		 *  they always appear in the following order from left to right:
		 *  OK, Yes, No, Cancel.
		 *
		 *  @param parent Object upon which the Alert control centers itself.
		 *
		 *  @param closeHandler Event handler that is called when any button
		 *  on the Alert control is pressed.
		 *  The event object passed to this handler is an instance of CloseEvent;
		 *  the <code>detail</code> property of this object contains the value
		 *  <code>Alert.OK</code>, <code>Alert.CANCEL</code>,
		 *  <code>Alert.YES</code>, or <code>Alert.NO</code>.
		 *
		 *  @param iconClass Class of the icon that is placed to the left
		 *  of the text in the Alert control.
		 *
		 *  @param defaultButtonFlag A bitflag that specifies the default button.
		 *  You can specify one and only one of
		 *  <code>Alert.OK</code>, <code>Alert.CANCEL</code>,
		 *  <code>Alert.YES</code>, or <code>Alert.NO</code>.
		 *  The default value is <code>Alert.OK</code>.
		 *  Pressing the Enter key triggers the default button
		 *  just as if you clicked it. Pressing Escape triggers the Cancel
		 *  or No button just as if you selected it.
		 *
		 *  @param moduleFactory The moduleFactory where this Alert should look for
		 *  its embedded fonts and style manager.
		 * 
		 *  @return A reference to the Alert control. 
		 *
		 *  @see mx.events.CloseEvent
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function show(message:String = "", title:String = "",
									buttonLabels:Vector.<String> = null /* Alert.OK */, 
									parent:Sprite = null, 
									closeHandler:Function = null, 
									iconClass:Class = null, 
									defaultButtonIndex:uint = 0 /* Alert.OK */,
									modal:Boolean = true,
									moduleFactory:IFlexModuleFactory = null):Alert
		{
//			var modal:Boolean = (flags & Alert.NONMODAL) ? false : true;
			
			if (!parent)
			{
				var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
				// no types so no dependencies
				var mp:Object = sm.getImplementation("mx.managers.IMarshallPlanSystemManager");
				if (mp && mp.useSWFBridge())
					parent = Sprite(sm.getSandboxRoot());
				else
					parent = Sprite(FlexGlobals.topLevelApplication);
			}
			
			var alert:Alert = new Alert();
			alert.buttonLabels = ( buttonLabels ) ? buttonLabels : Vector.<String>( [ "OK" ] );
			alert.defaultButtonIndex = defaultButtonIndex;
			
			alert.message = message;
			alert.title = title;
			alert.iconClass = iconClass;
			
			if (closeHandler != null)
				alert.addEventListener(CloseEvent.CLOSE, closeHandler);
			
			// Setting a module factory allows the correct embedded font to be found.
			if (moduleFactory)
				alert.moduleFactory = moduleFactory;    
			else if (parent is IFlexModule)
				alert.moduleFactory = IFlexModule(parent).moduleFactory;
			else
			{
				if (parent is IFlexModuleFactory)
					alert.moduleFactory = IFlexModuleFactory(parent);
				else                
					alert.moduleFactory = FlexGlobals.topLevelApplication.moduleFactory;
				
				// also set document if parent isn't a UIComponent
				if (!parent is UIComponent)
					alert.document = FlexGlobals.topLevelApplication.document;
			}
			
			alert.addEventListener(FlexEvent.CREATION_COMPLETE, static_creationCompleteHandler);
			PopUpManager.addPopUp(alert, parent, modal);
			
			return alert;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Class event handlers
		//
		//--------------------------------------------------------------------------
		
		
		
		/**
		 *  @private
		 */
		private static function static_creationCompleteHandler(event:FlexEvent):void
		{
			if (event.target is IFlexDisplayObject && event.eventPhase == EventPhase.AT_TARGET)
			{
				var alert:Alert = Alert(event.target);
				alert.removeEventListener(FlexEvent.CREATION_COMPLETE, static_creationCompleteHandler);
				
				alert.setActualSize(alert.getExplicitOrMeasuredWidth(),
					alert.getExplicitOrMeasuredHeight());
				PopUpManager.centerPopUp( alert );
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function Alert()
		{
			super();
			trace( "alert" );
			// Panel properties.
			title = "";
			message = "";
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  alertForm
		//----------------------------------
		
		/**
		 *  @private
		 *  The internal AlertForm object that contains the text, icon, and buttons
		 *  of the Alert control.
		 */
//		mx_internal var alertForm:AlertForm;
		
		//----------------------------------
		//  buttonFlags
		//----------------------------------
		
		/**
		 *  A bitmask that contains <code>Alert.OK</code>, <code>Alert.CANCEL</code>, 
		 *  <code>Alert.YES</code>, and/or <code>Alert.NO</code> indicating
		 *  the buttons available in the Alert control.
		 *
		 *  @default Alert.OK
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected var _buttonLabelsChanged:Boolean;
		protected var _buttonLabels:Vector.<String>;
		public function get buttonLabels():Vector.<String>
		{
			return _buttonLabels;
		}
		public function set buttonLabels( value:Vector.<String> ):void
		{
			if( _buttonLabels == value ) return;
			
			_buttonLabels = value;
			_buttonLabelsChanged = true;
			
			invalidateProperties();
		}
		
		//----------------------------------
		//  defaultButtonFlag
		//----------------------------------
		
		[Inspectable(category="General")]
		
		/**
		 *  A bitflag that contains either <code>Alert.OK</code>, 
		 *  <code>Alert.CANCEL</code>, <code>Alert.YES</code>, 
		 *  or <code>Alert.NO</code> to specify the default button.
		 *
		 *  @default Alert.OK
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var _defaultButtonIndex:uint = 0;
		private var _defaultButtonChanged:Boolean;
		public function get defaultButtonIndex():int
		{
			return _defaultButtonIndex;
		}
		public function set defaultButtonIndex( value:int ):void
		{
			if( _defaultButtonIndex == value ) return;
			
			_defaultButtonIndex = value;
			_defaultButtonChanged = true;
			
			invalidateProperties();
		}
		
		//----------------------------------
		//  iconClass
		//----------------------------------
		
		[Inspectable(category="Other")]
		
		/**
		 *  The class of the icon to display.
		 *  You typically embed an asset, such as a JPEG or GIF file,
		 *  and then use the variable associated with the embedded asset 
		 *  to specify the value of this property.
		 *
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected var _iconClassChanged:Boolean;
		private var _iconClass:Class;
		
		public function get iconClass():Class
		{
			return _iconClass;
		}
		public function set iconClass( value:Class ):void
		{
			if( _iconClass == value ) return;
			
			_iconClass = value;
			_iconClassChanged = true;
			
			invalidateProperties();
		}
		
		//----------------------------------
		//  text
		//----------------------------------
		
		[Inspectable(category="General")]
		
		/**
		 *  The text to display in this alert dialog box.
		 *
		 *  @default ""
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected var _message:String;
		
		public function get message():String
		{
			return _message;
		}
		public function set message( value:String ):void
		{
			if( _message == value ) return;
			
			_message = value
			if( messageDisplay ) messageDisplay.text = _message;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function initializeAccessibility():void
		{
			if (Alert.createAccessibilityImplementation != null)
				Alert.createAccessibilityImplementation(this);
		}
		
		
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			var all:Boolean = ( !styleProp || styleProp == "styleName" )
			if( ( all || styleProp == "buttonStyleName" ) && _buttons )
			{
				var buttonStyleName:String = getStyle("buttonStyleName");
				
				var n:int = _buttons.length;
				for (var i:int = 0; i < n; i++)
				{
					_buttons[ i ].styleName = buttonStyleName;
				}
			}
			
			if( ( all || styleProp == "messageStyleName" ) && messageDisplay )
			{
				var messageStyleName:String = getStyle("messageStyleName");
				messageDisplay.styleName = messageStyleName;
			}
		}
		
		override protected function partAdded( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );
			
			if( partName == "buttonGroup" ) createButtons( Group( instance ) );
			if( partName == "messageDisplay" )
			{
				messageDisplay.text = message;
				messageDisplay.styleName = getStyle("messageStyleName");
			}
			if( partName == "iconDisplay" ) createIcon( Group( instance ) );
		}
		
		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );
			if( partName == "buttonGroup" ) destroyButtons( Group( instance ) );
			if( partName == "iconDisplay" ) destroyIcon( Group( instance ) );
		}
		
		protected function createIcon( container:Group ):void
		{
			if( !container || !_icon ) return;
			
			container.addElement( _icon );
		}
		
		protected function destroyIcon( container:Group ):void
		{
			if( !container || !_icon ) return;
			
			if( _icon.parent == container ) container.removeElement( _icon );
			_icon = null;
		}
		
		private var _buttons:Vector.<Button>;
		
		protected function createButtons( container:Group ):void
		{
			_buttonLabelsChanged = false;
//			_defaultButtonChanged = false;
			
			if( !container || !buttonLabels ) return;
				
			_buttons = new Vector.<Button>();
			var buttonStyleName:String = getStyle("buttonStyleName");
			
			var button:Button;
			var numButtons:int = buttonLabels.length;
			for( var i:int = 0; i < numButtons; i++ )
			{
				button = new Button();
				if( buttonStyleName ) button.styleName = buttonStyleName;
				button.label = buttonLabels[ i ];
				button.width = buttonWidth;
				button.height = buttonHeight;
				button.addEventListener( MouseEvent.CLICK, onButtonClick, false, 0, true );
				button.addEventListener( KeyboardEvent.KEY_DOWN, onButtonKeyDown, false, 0, true );
				
				container.addElement( button );
//				button.setActualSize(Alert.buttonWidth, Alert.buttonHeight);
				_buttons.push( button );
			}
			
			setButtonFocus();
		}
		
		protected function destroyButtons( container:Group ):void
		{
			var button:Button;
			var numButtons:int = _buttons.length;
			for( var i:int = 0; i < numButtons; i++ )
			{
				button = _buttons[ i ];
				button.removeEventListener( MouseEvent.CLICK, onButtonClick, false );
				button.removeEventListener( KeyboardEvent.KEY_DOWN, onButtonKeyDown, false );
				if( container ) container.removeElement( button );
			}
			
			_buttons = null;
		}
		
		override public function set initialized(value:Boolean):void
		{
			super.initialized = value;
			
			setButtonFocus();
		}
		
		protected function onButtonClick( event:MouseEvent ):void
		{
			removeAlert( buttonGroup.getElementIndex( Button( event.currentTarget ) ) );
		}
		
		protected function onButtonKeyDown( event:KeyboardEvent ):void
		{
			if( event.keyCode == Keyboard.ENTER ) removeAlert( _buttons.indexOf( event.currentTarget ) );
		}
		
		private function removeAlert( index:int ):void
		{
			visible = false;
			dispatchEvent( new CloseEvent( CloseEvent.CLOSE, false, false, index ) );
			
			mx.managers.PopUpManager.removePopUp( this );
			
			if( _buttons ) destroyButtons( buttonGroup );
		}
		
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if( _buttonLabelsChanged )
			{
				destroyButtons( buttonGroup );
				createButtons( buttonGroup );
			}
			
			if( _iconClassChanged )
			{
				_iconClassChanged = false;
				
				destroyIcon( iconGroup );
				
				var icon:DisplayObject = new iconClass();
				_icon = new UIComponent();
				_icon.addChild( icon );
				_icon.width = icon.width
				_icon.height = icon.height;
				
				createIcon( iconGroup );
			}
			
			if( _defaultButtonChanged ) setButtonFocus();
		}
		
		private function setButtonFocus():void
		{
			if( !initialized ) return;
			
			var sm:ISystemManager = systemManager;
			var awm:IActiveWindowManager = IActiveWindowManager(sm.getImplementation("mx.managers::IActiveWindowManager"));
			if (awm) awm.activate( this );
			
			_defaultButtonChanged = false;
			if( _buttons )
			{
				if( _defaultButtonIndex >= 0 && _defaultButtonIndex < _buttons.length - 1 )
				{
					_buttons[ _defaultButtonIndex ].setFocus();
					_buttons[ _defaultButtonIndex ].drawFocus( true );
				}
			}
		}
		
		
		[SkinPart(required="false")]
		public var messageDisplay	: TextBase;
		
		[SkinPart(required="false")]
		public var buttonGroup:Group;
		
		[SkinPart(required="false")]
		public var iconGroup:Group;
		
		
		private var _icon	: UIComponent;

	}
	
}
