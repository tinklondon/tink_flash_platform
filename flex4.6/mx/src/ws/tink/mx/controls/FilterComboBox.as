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

package ws.tink.mx.controls
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.collections.CursorBookmark;
	import mx.collections.ICollectionView;
	import mx.collections.ListCollectionView;
	import mx.controls.ComboBase;
	import mx.controls.List;
	import mx.controls.TextInput;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListBase;
	import mx.controls.listClasses.ListData;
	import mx.controls.listClasses.ListItemRenderer;
	import mx.core.ClassFactory;
	import mx.core.EdgeMetrics;
	import mx.core.FlexVersion;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.IUITextField;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.core.UIComponentGlobals;
	import mx.core.mx_internal;
	import mx.effects.Tween;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.events.InterManagerRequest;
	import mx.events.ListEvent;
	import mx.events.SandboxMouseEvent;
	import mx.events.ScrollEvent;
	import mx.events.ScrollEventDetail;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the ComboBox contents changes as a result of user
	 *  interaction, when the <code>selectedIndex</code> or
	 *  <code>selectedItem</code> property changes, and, if the ComboBox control
	 *  is editable, each time a keystroke is entered in the box.
	 *
	 *  @eventType mx.events.ListEvent.CHANGE
	 */
	[Event(name="change", type="mx.events.ListEvent")]
	
	/**
	 *  Dispatched when the drop-down list is dismissed for any reason such when 
	 *  the user:
	 *  <ul>
	 *      <li>selects an item in the drop-down list</li>
	 *      <li>clicks outside of the drop-down list</li>
	 *      <li>clicks the drop-down button while the drop-down list is 
	 *  displayed</li>
	 *      <li>presses the ESC key while the drop-down list is displayed</li>
	 *  </ul>
	 *
	 *  @eventType mx.events.DropdownEvent.CLOSE
	 */
	[Event(name="close", type="mx.events.DropdownEvent")]
	
	/**
	 *  Dispatched when the <code>data</code> property changes.
	 *
	 *  <p>When you use a component as an item renderer,
	 *  the <code>data</code> property contains an item from the
	 *  dataProvider.
	 *  You can listen for this event and update the component
	 *  when the <code>data</code> property changes.</p>
	 * 
	 *  @eventType mx.events.FlexEvent.DATA_CHANGE
	 */
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	/**
	 *  Dispatched if the <code>editable</code> property
	 *  is set to <code>true</code> and the user presses the Enter key
	 *  while typing in the editable text field.
	 *
	 *  @eventType mx.events.FlexEvent.ENTER
	 */
	[Event(name="enter", type="mx.events.FlexEvent")]
	
	/**
	 *  Dispatched when user rolls the mouse out of a drop-down list item.
	 *  The event object's <code>target</code> property contains a reference
	 *  to the ComboBox and not the drop-down list.
	 *
	 *  @eventType mx.events.ListEvent.ITEM_ROLL_OUT
	 */
	[Event(name="itemRollOut", type="mx.events.ListEvent")]
	
	/**
	 *  Dispatched when the user rolls the mouse over a drop-down list item.
	 *  The event object's <code>target</code> property contains a reference
	 *  to the ComboBox and not the drop-down list.
	 *
	 *  @eventType mx.events.ListEvent.ITEM_ROLL_OVER
	 */
	[Event(name="itemRollOver", type="mx.events.ListEvent")]
	
	/**
	 *  Dispatched when the user clicks the drop-down button
	 *  to display the drop-down list.  It is also dispatched if the user
	 *  uses the keyboard and types Ctrl-Down to open the drop-down.
	 *
	 *  @eventType mx.events.DropdownEvent.OPEN
	 */
	[Event(name="open", type="mx.events.DropdownEvent")]
	
	/**
	 *  Dispatched when the user scrolls the ComboBox control's drop-down list.
	 *
	 *  @eventType mx.events.ScrollEvent.SCROLL
	 */
	[Event(name="scroll", type="mx.events.ScrollEvent")]
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
//	include "../styles/metadata/FocusStyles.as"
//	include "../styles/metadata/IconColorStyles.as"
//	include "../styles/metadata/LeadingStyle.as"
//	include "../styles/metadata/PaddingStyles.as"
//	include "../styles/metadata/SkinStyles.as"
//	include "../styles/metadata/TextStyles.as"
	
	/**
	 *  The set of BackgroundColors for drop-down list rows in an alternating
	 *  pattern.
	 *  Value can be an Array of two of more colors.
	 *  If <code>undefined</code> then the rows will use the drop-down list's 
	 *  backgroundColor style.
	 *
	 *  @default undefined
	 */
	[Style(name="alternatingItemColors", type="Array", arrayType="uint", format="Color", inherit="yes")]
	
	/**
	 *  Width of the arrow button in pixels.
	 *  @default 22
	 */
	[Style(name="arrowButtonWidth", type="Number", format="Length", inherit="no")]
	
	/**
	 *  The thickness of the border of the drop-down list, in pixels. 
	 *  This value is overridden if you define 
	 *  <code>borderThickness</code> when setting the 
	 *  <code>dropdownStyleName</code> CSSStyleDeclaration. 
	 *
	 *  @default 1
	 */
	[Style(name="borderThickness", type="Number", format="Length", inherit="no")]
	
	/**
	 *  The length of the transition when the drop-down list closes, in milliseconds.
	 *  The default transition has the drop-down slide up into the ComboBox.
	 *
	 *  @default 250
	 */
	[Style(name="closeDuration", type="Number", format="Time", inherit="no")]
	
	/**
	 *  An easing function to control the close transition.  Easing functions can
	 *  be used to control the acceleration and deceleration of the transition.
	 *
	 *  @default undefined
	 */
	[Style(name="closeEasingFunction", type="Function", inherit="no")]
	
	/**
	 *  The color of the border of the ComboBox.  If <code>undefined</code>
	 *  the drop-down list will use its normal borderColor style.  This style
	 *  is used by the validators to show the ComboBox in an error state.
	 * 
	 *  @default undefined
	 */
	[Style(name="dropdownBorderColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  The name of a CSSStyleDeclaration to be used by the drop-down list.  This
	 *  allows you to control the appearance of the drop-down list or its item
	 *  renderers.
	 * 
	 * [deprecated]
	 *
	 *  @default "comboDropDown"
	 */
	[Style(name="dropDownStyleName", type="String", inherit="no", deprecatedReplacement="dropdownStyleName")]
	
	/**
	 *  The name of a CSSStyleDeclaration to be used by the drop-down list.  This
	 *  allows you to control the appearance of the drop-down list or its item
	 *  renderers.
	 *
	 *  @default "comboDropdown"
	 */
	[Style(name="dropdownStyleName", type="String", inherit="no")]
	
	/**
	 *  Length of the transition when the drop-down list opens, in milliseconds.
	 *  The default transition has the drop-down slide down from the ComboBox.
	 *
	 *  @default 250
	 */
	[Style(name="openDuration", type="Number", format="Time", inherit="no")]
	
	/**
	 *  An easing function to control the open transition.  Easing functions can
	 *  be used to control the acceleration and deceleration of the transition.
	 *
	 *  @default undefined
	 */
	[Style(name="openEasingFunction", type="Function", inherit="no")]
	
	/**
	 *  Number of pixels between the control's bottom border
	 *  and the bottom of its content area.
	 *  When the <code>editable</code> property is <code>true</code>, 
	 *  <code>paddingTop</code> and <code>paddingBottom</code> affect the size 
	 *  of the ComboBox control, but do not affect the position of the editable text field.
	 *  
	 *  @default 0 
	 */
	[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between the control's top border
	 *  and the top of its content area.
	 *  When the <code>editable</code> property is <code>true</code>, 
	 *  <code>paddingTop</code> and <code>paddingBottom</code> affect the size 
	 *  of the ComboBox control, but do not affect the position of the editable text field.
	 *  
	 *  @default 0
	 */
	[Style(name="paddingTop", type="Number", format="Length", inherit="no")]
	
	/**
	 *  The rollOverColor of the drop-down list.
	 
	 *  @see mx.controls.List
	 */
	[Style(name="rollOverColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  The selectionColor of the drop-down list.
	 
	 *  @see mx.controls.List
	 */
	[Style(name="selectionColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  The selectionDuration of the drop-down list.
	 * 
	 *  @default 250
	 * 
	 *  @see mx.controls.List
	 */
	[Style(name="selectionDuration", type="uint", format="Time", inherit="no")]
	
	/**
	 *  The selectionEasingFunction of the drop-down list.
	 * 
	 *  @default undefined
	 * 
	 *  @see mx.controls.List
	 */
	[Style(name="selectionEasingFunction", type="Function", inherit="no")]
	
	/**
	 *  The textRollOverColor of the drop-down list.
	 * 
	 *  @default #2B333C
	 *  
	 *  @see mx.controls.List
	 */
	[Style(name="textRollOverColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  The textSelectedColor of the drop-down list.
	 * 
	 *  @default #2B333C
	 *  @see mx.controls.List
	 */
	[Style(name="textSelectedColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  Specifies the alpha transparency value of the focus skin.
	 *  
	 *  @default 0.4
	 */
	[Style(name="focusAlpha", type="Number", inherit="no")]
	
	/**
	 *  Specifies which corners of the focus rectangle should be rounded.
	 *  This value is a space-separated String that can contain any
	 *  combination of <code>"tl"</code>, <code>"tr"</code>, <code>"bl"</code>
	 *  and <code>"br"</code>.
	 *  For example, to specify that the right side corners should be rounded,
	 *  but the left side corners should be square, use <code>"tr br"</code>.
	 *  The <code>cornerRadius</code> style property specifies
	 *  the radius of the rounded corners.
	 *  The default value depends on the component class; if not overridden for
	 *  the class, default value is <code>"tl tr bl br"</code>.
	 */
	[Style(name="focusRoundedCorners", type="String", inherit="no")]
	
	/**
	 *  The color for the icon in a skin. 
	 *  For example, this style is used by the CheckBoxIcon skin class 
	 *  to draw the check mark for a CheckBox control, 
	 *  by the ComboBoxSkin class to draw the down arrow of the ComboBox control, 
	 *  and by the DateChooserMonthArrowSkin skin class to draw the month arrow 
	 *  for the DateChooser control. 
	 * 
	 *  The default value depends on the component class;
	 *  if it is not overridden by the class, the default value is <code>0x111111</code>.
	 */
	[Style(name="iconColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  The color for the icon in a disabled skin. 
	 *  For example, this style is used by the CheckBoxIcon skin class 
	 *  to draw the check mark for a disabled CheckBox control, 
	 *  by the ComboBoxSkin class to draw the down arrow of a disabled ComboBox control, 
	 *  and by the DateChooserMonthArrowSkin skin class to draw the month arrow 
	 *  for a disabled DateChooser control. 
	 * 
	 *  The default value depends on the component class;
	 *  if it is not overridden by the class, the default value is <code>0x999999</code>.
	 */
	[Style(name="disabledIconColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  Additional vertical space between lines of text.
	 *
	 *  <p>The default value is 2.</p>
	 *  <p>The default value for the ComboBox control is 0.</p>
	 */
	[Style(name="leading", type="Number", format="Length", inherit="yes")]
	
	/**
	 *  Number of pixels between the component's left border
	 *  and the left edge of its content area.
	 *  <p>The default value is 0.</p>
	 *  <p>The default value for a Button control is 10.</p>
	 *  <p>The default value for the ComboBox control is 5.</p>
	 *  <p>The default value for the Form container is 16.</p>
	 *  <p>The default value for the Tree control is 2.</p>
	 */
	[Style(name="paddingLeft", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between the component's right border
	 *  and the right edge of its content area.
	 *  <p>The default value is 0.</p>
	 *  <p>The default value for a Button control is 10.</p>
	 *  <p>The default value for the ComboBox control is 5.</p>
	 *  <p>The default value for the Form container is 16.</p>
	 */
	[Style(name="paddingRight", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Color of the border.
	 *  The following controls support this style: Button, CheckBox,
	 *  ComboBox, MenuBar,
	 *  NumericStepper, ProgressBar, RadioButton, ScrollBar, Slider, and any
	 *  components that support the <code>borderStyle</code> style.
	 *  The default value depends on the component class;
	 *  if not overriden for the class, the default value is <code>0xB7BABC</code>.
	 */
	[Style(name="borderColor", type="uint", format="Color", inherit="no")]
	
	/**
	 *  Radius of component corners.
	 *  The following components support this style: Alert, Button, ComboBox,  
	 *  LinkButton, MenuBar, NumericStepper, Panel, ScrollBar, Tab, TitleWindow, 
	 *  and any component
	 *  that supports a <code>borderStyle</code> property set to <code>"solid"</code>.
	 *  The default value depends on the component class;
	 *  if not overriden for the class, the default value is <code>0</code>.
	 */
	[Style(name="cornerRadius", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Alphas used for the background fill of controls. Use [1, 1] to make the control background
	 *  opaque.
	 *  
	 *  @default [ 0.6, 0.4 ]
	 */
	[Style(name="fillAlphas", type="Array", arrayType="Number", inherit="no")]
	
	/**
	 *  Colors used to tint the background of the control.
	 *  Pass the same color for both values for a flat-looking control.
	 *  
	 *  @default [ 0xFFFFFF, 0xCCCCCC ]
	 */
	[Style(name="fillColors", type="Array", arrayType="uint", format="Color", inherit="no")]
	
	/**
	 *  Alpha transparencies used for the highlight fill of controls.
	 *  The first value specifies the transparency of the top of the highlight and the second value specifies the transparency 
	 *  of the bottom of the highlight. The highlight covers the top half of the skin.
	 *  
	 *  @default [ 0.3, 0.0 ]
	 */
	[Style(name="highlightAlphas", type="Array", arrayType="Number", inherit="no")]
	
	/**
	 *  Color of text in the component, including the component label.
	 *
	 *  @default 0x0B333C
	 */
	[Style(name="color", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  Color of text in the component if it is disabled.
	 *
	 *  @default 0xAAB3B3
	 */
	[Style(name="disabledColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  Sets the <code>antiAliasType</code> property of internal TextFields. The possible values are 
	 *  <code>"normal"</code> (<code>flash.text.AntiAliasType.NORMAL</code>) 
	 *  and <code>"advanced"</code> (<code>flash.text.AntiAliasType.ADVANCED</code>). 
	 *  
	 *  <p>The default value is <code>"advanced"</code>, which enables advanced anti-aliasing for the font.
	 *  Set to <code>"normal"</code> to disable the advanced anti-aliasing.</p>
	 *  
	 *  <p>This style has no effect for system fonts.</p>
	 *  
	 *  <p>This style applies to all the text in a TextField subcontrol; 
	 *  you cannot apply it to some characters and not others.</p>
	 
	 *  @default "advanced"
	 * 
	 *  @see flash.text.TextField
	 *  @see flash.text.AntiAliasType
	 */
	[Style(name="fontAntiAliasType", type="String", enumeration="normal,advanced", inherit="yes")]
	
	/**
	 *  Name of the font to use.
	 *  Unlike in a full CSS implementation,
	 *  comma-separated lists are not supported.
	 *  You can use any font family name.
	 *  If you specify a generic font name,
	 *  it is converted to an appropriate device font.
	 * 
	 *  @default "Verdana"
	 */
	[Style(name="fontFamily", type="String", inherit="yes")]
	
	/**
	 *  Sets the <code>gridFitType</code> property of internal TextFields that represent text in Flex controls.
	 *  The possible values are <code>"none"</code> (<code>flash.text.GridFitType.NONE</code>), 
	 *  <code>"pixel"</code> (<code>flash.text.GridFitType.PIXEL</code>),
	 *  and <code>"subpixel"</code> (<code>flash.text.GridFitType.SUBPIXEL</code>). 
	 *  
	 *  <p>This property only applies when you are using an embedded font 
	 *  and the <code>fontAntiAliasType</code> property 
	 *  is set to <code>"advanced"</code>.</p>
	 *  
	 *  <p>This style has no effect for system fonts.</p>
	 * 
	 *  <p>This style applies to all the text in a TextField subcontrol; 
	 *  you can't apply it to some characters and not others.</p>
	 * 
	 *  @default "pixel"
	 *  
	 *  @see flash.text.TextField
	 *  @see flash.text.GridFitType
	 */
	[Style(name="fontGridFitType", type="String", enumeration="none,pixel,subpixel", inherit="yes")]
	
	/**
	 *  Sets the <code>sharpness</code> property of internal TextFields that represent text in Flex controls.
	 *  This property specifies the sharpness of the glyph edges. The possible values are Numbers 
	 *  from -400 through 400. 
	 *  
	 *  <p>This property only applies when you are using an embedded font 
	 *  and the <code>fontAntiAliasType</code> property 
	 *  is set to <code>"advanced"</code>.</p>
	 *  
	 *  <p>This style has no effect for system fonts.</p>
	 * 
	 *  <p>This style applies to all the text in a TextField subcontrol; 
	 *  you can't apply it to some characters and not others.</p>
	 *  
	 *  @default 0
	 *  
	 *  @see flash.text.TextField
	 */
	[Style(name="fontSharpness", type="Number", inherit="yes")]
	
	/**
	 *  Height of the text, in pixels.
	 *
	 *  The default value is 10 for all controls except the ColorPicker control. 
	 *  For the ColorPicker control, the default value is 11. 
	 */
	[Style(name="fontSize", type="Number", format="Length", inherit="yes")]
	
	/**
	 *  Determines whether the text is italic font.
	 *  Recognized values are <code>"normal"</code> and <code>"italic"</code>.
	 * 
	 *  @default "normal"
	 */
	[Style(name="fontStyle", type="String", enumeration="normal,italic", inherit="yes")]
	
	/**
	 *  Sets the <code>thickness</code> property of internal TextFields that represent text in Flex controls.
	 *  This property specifies the thickness of the glyph edges.
	 *  The possible values are Numbers from -200 to 200. 
	 *  
	 *  <p>This property only applies when you are using an embedded font 
	 *  and the <code>fontAntiAliasType</code> property 
	 *  is set to <code>"advanced"</code>.</p>
	 *  
	 *  <p>This style has no effect on system fonts.</p>
	 * 
	 *  <p>This style applies to all the text in a TextField subcontrol; 
	 *  you can't apply it to some characters and not others.</p>
	 *  
	 *  @default 0
	 *  
	 *  @see flash.text.TextField
	 */
	[Style(name="fontThickness", type="Number", inherit="yes")]
	
	/**
	 *  Determines whether the text is boldface.
	 *  Recognized values are <code>normal</code> and <code>bold</code>.
	 *  The default value for Button controls is <code>bold</code>. 
	 *  The default value for all other controls is <code>normal</code>.
	 */
	[Style(name="fontWeight", type="String", enumeration="normal,bold", inherit="yes")]
	
	/**
	 *  A Boolean value that indicates whether kerning
	 *  is enabled (<code>true</code>) or disabled (<code>false</code>).
	 *  Kerning adjusts the gap between certain character pairs
	 *  to improve readability, and should be used only when necessary,
	 *  such as with headings in large fonts.
	 *  Kerning is supported for embedded fonts only. 
	 *  Certain fonts, such as Verdana, and monospaced fonts,
	 *  such as Courier New, do not support kerning.
	 *
	 *  @default false
	 */
	[Style(name="kerning", type="Boolean", inherit="yes")]
	
	/**
	 *  The number of additional pixels to appear between each character.
	 *  A positive value increases the character spacing beyond the normal spacing,
	 *  while a negative value decreases it.
	 * 
	 *  @default 0
	 */
	[Style(name="letterSpacing", type="Number", inherit="yes")]
	
	/**
	 *  Alignment of text within a container.
	 *  Possible values are <code>"left"</code>, <code>"right"</code>,
	 *  or <code>"center"</code>.
	 * 
	 *  <p>The default value for most components is <code>"left"</code>.
	 *  For the FormItem component,
	 *  the default value is <code>"right"</code>.
	 *  For the Button, LinkButton, and AccordionHeader components,
	 *  the default value is <code>"center"</code>, and
	 *  this property is only recognized when the
	 *  <code>labelPlacement</code> property is set to <code>"left"</code> or
	 *  <code>"right"</code>.
	 *  If <code>labelPlacement</code> is set to <code>"top"</code> or
	 *  <code>"bottom"</code>, the text and any icon are centered.</p>
	 */
	[Style(name="textAlign", type="String", enumeration="left,center,right", inherit="yes")]
	
	/**
	 *  Determines whether the text is underlined.
	 *  Possible values are <code>"none"</code> and <code>"underline"</code>.
	 * 
	 *  @default "none"
	 */
	[Style(name="textDecoration", type="String", enumeration="none,underline", inherit="yes")]
	
	/**
	 *  Offset of first line of text from the left side of the container, in pixels.
	 * 
	 *  @default 0
	 */
	[Style(name="textIndent", type="Number", format="Length", inherit="yes")]

	/**
	 *  The name of a CSS style declaration for controlling other aspects of
	 *  the appearance of the column headers.
	 *  @default "dataGridStyles"
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="matchedTextStyleName", type="String", inherit="no")]
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[AccessibilityClass(implementation="mx.accessibility.ComboBoxAccImpl")]
	
	[DataBindingInfo("acceptedTypes", "{ dataProvider: { label: &quot;String&quot; } }")]
	
	[DefaultBindingProperty(source="selectedItem", destination="dataProvider")]
	
	[DefaultProperty("dataProvider")]
	
	[DefaultTriggerEvent("change")]
	
	[IconFile("FilterComboBox.png")]
	
	/**
	 *  The ComboBox control contains a drop-down list
	 *  from which the user can select a single value.
	 *  Its functionality is very similar to that of the
	 *  SELECT form element in HTML.
	 *  The ComboBox can be editable, in which case
	 *  the user can type entries into the TextInput portion
	 *  of the ComboBox that are not in the list.
	 *
	 *  <p>The ComboBox control has the following default sizing 
	 *     characteristics:</p>
	 *     <table class="innertable">
	 *        <tr>
	 *           <th>Characteristic</th>
	 *           <th>Description</th>
	 *        </tr>
	 *        <tr>
	 *           <td>Default size</td>
	 *           <td>Wide enough to accommodate the longest entry in the 
	 *               drop-down list in the display area of the main
	 *               control, plus the drop-down button. When the 
	 *               drop-down list is not visible, the default height 
	 *               is based on the label text size. 
	 *
	 *               <p>The default drop-down list height is five rows, or 
	 *               the number of entries in the drop-down list, whichever 
	 *               is smaller. The default height of each entry in the 
	 *               drop-down list is 22 pixels.</p></td>
	 *        </tr>
	 *        <tr>
	 *           <td>Minimum size</td>
	 *           <td>0 pixels.</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Maximum size</td>
	 *           <td>5000 by 5000.</td>
	 *        </tr>
	 *        <tr>
	 *           <td>dropdownWidth</td>
	 *           <td>The width of the ComboBox control.</td>
	 *        </tr>
	 *        <tr>
	 *           <td>rowCount</td>
	 *           <td>5 rows.</td>
	 *        </tr>
	 *     </table>
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;mx:ComboBox&gt;</code> tag inherits all the tag attributes
	 *  of its superclass, and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;mx:ComboBox
	 *    <b>Properties</b>
	 *    dataProvider="null"
	 *    dropdownFactory="<i>ClassFactory that creates an mx.controls.List</i>"
	 *    dropdownWidth="<i>100 or width of the longest text in the dataProvider</i>"
	 *    itemRenderer="null"
	 *    labelField="label"
	 *    labelFunction="null"
	 *    prompt="null"
	 *    rowCount="5"
	 *    selectedIndex="-1"
	 *    selectedItem="null"
	 *    
	 *    <b>Styles</b>
	 *    alternatingItemColors="undefined"
	 *    arrowButtonWidth="22"
	 *    borderColor="0xB7BABC"
	 *    borderThickness="1"
	 *    closeDuration="250"
	 *    closeEasingFunction="undefined"
	 *    color="0x0B333C"
	 *    cornerRadius="0"
	 *    disabledColor="0xAAB3B3"
	 *    disabledIconColor="0x919999"
	 *    dropdownBorderColor="undefined"
	 *    dropdownStyleName="comboDropdown"
	 *    fillAlphas="[0.6,0.4]"
	 *    fillColors="[0xFFFFFF, 0xCCCCCC]"
	 *    focusAlpha="0.4"
	 *    focusRoundedCorners="tl tr bl br"
	 *    fontAntiAliasType="advanced|normal"
	 *    fontFamily="Verdana"
	 *    fontGridFitType="pixel|none|subpixel"
	 *    fontSharpness="0"
	 *    fontSize="10"
	 *    fontStyle="normal|italic"
	 *    fontThickness="0"
	 *    fontWeight="normal|bold"
	 *    highlightAlphas="[0.3,0.0]"
	 *    iconColor="0x111111"
	 *    leading="0"
	 *    openDuration="250"
	 *    openEasingFunction="undefined"
	 *    paddingTop="0"
	 *    paddingBottom="0"
	 *    paddingLeft="5"
	 *    paddingRight="5"
	 *    rollOverColor="<i>Depends on theme color"</i>
	 *    selectionColor="<i>Depends on theme color"</i>
	 *    selectionDuration="250"
	 *    selectionEasingFunction="undefined"
	 *    textAlign="left|center|right"
	 *    textDecoration="none|underline"
	 *    textIndent="0"
	 *    textRollOverColor="0x2B333C"
	 *    textSelectedColor="0x2B333C"
	 *    
	 *    <b>Events</b>
	 *    change="<i>No default</i>"
	 *    close="<i>No default</i>"
	 *    dataChange="<i>No default</i>"
	 *    enter="<i>No default</i>"
	 *    itemRollOut="<i>No default</i>"
	 *    itemRollOver="<i>No default</i>"
	 *    open="<i>No default</i>"
	 *    scroll="<i>No default</i>"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @includeExample examples/SimpleComboBox.mxml
	 *
	 *  @see mx.controls.List
	 *  @see mx.effects.Tween
	 *  @see mx.managers.PopUpManager
	 *
	 */
	public class FilterComboBox extends ComboBase
		implements IDataRenderer, IDropInListItemRenderer,
		IListItemRenderer
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class mixins
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Placeholder for mixin by ComboBoxAccImpl.
		 */
		mx_internal static var createAccessibilityImplementation:Function;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 */
		public function FilterComboBox()
		{
			super();
			
			prompt = "Type to filter";
			
			// It it better to start out with an empty data provider rather than
			// an undefined one. Otherwise, code in getDropdown() sets it to []
			// later, but via setDataProvider(). This API has side effects like
			// setting selectionChanged, which causes the text in an editable
			// ComboBox to be lost.
			dataProvider = new ArrayCollection();
			
			filterString = "";
			_activeFilterFunction = filterDataFunction;
			
			useFullDropdownSkin = true;
			wrapDownArrowButton = false;
			addEventListener("unload", unloadHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  A reference to the internal List that pops up to display a row
		 *  for each dataProvider item.
		 */
		private var _dropdown:ListBase;
		
		/**
		 *  @private
		 *  A int to track the oldIndex, used when the dropdown is dismissed using the ESC key.
		 */
		private var _oldIndex:int;
		
		/**
		 *  @private
		 *  The tween used for showing and hiding the drop-down list.
		 */
		private var tween:Tween = null;
		
		/**
		 *  @private
		 *  A flag to track whether the dropDown tweened up or down. 
		 */
		private var tweenUp:Boolean = false;
		
		
		/**
		 *  @private
		 */
		private var preferredDropdownWidth:Number;
		
		/**
		 *  @private
		 */
		private var dropdownBorderStyle:String = "solid";
		
		/**
		 *  @private
		 *  Is the dropdown list currently shown?
		 */
		private var _showingDropdown:Boolean = false;
		
		/**
		 *  @private
		 */
		private var _selectedIndexOnDropdown:int = -1;
		
		/**
		 *  @private
		 */
		private var bRemoveDropdown:Boolean = false;
		
		/**
		 *  @private
		 */
		private var inTween:Boolean = false;
		
		/**
		 *  @private
		 */
		private var bInKeyDown:Boolean = false;
		
		/**
		 *  @private
		 *  Flag that will block default data/listData behavior
		 */
		private var selectedItemSet:Boolean;
		
		/**
		 *  @private
		 *  Event that is causing the dropDown to open or close.
		 */
		private var triggerEvent:Event;
		
		/**
		 *  @private
		 *  Whether the text property was explicitly set or not
		 */
		private var explicitText:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  data
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the data property.
		 */
		private var _data:Object;
		
		[Bindable("dataChange")]
		[Inspectable(environment="none")]
		
		/**
		 *  The <code>data</code> property lets you pass a value
		 *  to the component when you use it in an item renderer or item editor.
		 *  You typically use data binding to bind a field of the <code>data</code>
		 *  property to a property of this component.
		 *
		 *  <p>The ComboBox control uses the <code>listData</code> property and the
		 *  <code>data</code> property as follows. If the ComboBox is in a 
		 *  DataGrid control, it expects the <code>dataField</code> property of the 
		 *  column to map to a property in the data and sets 
		 *  <code>selectedItem</code> to that property. If the ComboBox control is 
		 *  in a List control, it expects the <code>labelField</code> of the list 
		 *  to map to a property in the data and sets <code>selectedItem</code> to 
		 *  that property. 
		 *  Otherwise, it sets <code>selectedItem</code> to the data itself.</p>
		 *
		 *  <p>You do not set this property in MXML.</p>
		 *
		 *  @see mx.core.IDataRenderer
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 *  @private
		 */
		public function set data(value:Object):void
		{
			var newSelectedItem:*;
			
			_data = value;
			
			if (_listData && _listData is DataGridListData)
				newSelectedItem = _data[DataGridListData(_listData).dataField];
			else if (_listData is ListData && ListData(_listData).labelField in _data)
				newSelectedItem = _data[ListData(_listData).labelField];
			else
				newSelectedItem = _data;
			
			if (newSelectedItem !== undefined && !selectedItemSet)
			{
				selectedItem = newSelectedItem;
				selectedItemSet = false;
			}
			
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
		
		//----------------------------------
		//  listData
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the listData property.
		 */
		private var _listData:BaseListData;
		
		[Bindable("dataChange")]
		[Inspectable(environment="none")]
		
		/**
		 *  When a component is used as a drop-in item renderer or drop-in item 
		 *  editor, Flex initializes the <code>listData</code> property of the 
		 *  component with the appropriate data from the List control. The 
		 *  component can then use the <code>listData</code> property and the 
		 *  <code>data</code> property to display the appropriate information 
		 *  as a drop-in item renderer or drop-in item editor.
		 *
		 *  <p>You do not set this property in MXML or ActionScript; Flex sets it 
		 *  when the component
		 *  is used as a drop-in item renderer or drop-in item editor.</p>
		 *
		 *  @see mx.controls.listClasses.IDropInListItemRenderer
		 */
		public function get listData():BaseListData
		{
			return _listData;
		}
		
		/**
		 *  @private
		 */
		public function set listData(value:BaseListData):void
		{
			_listData = value;
		}
		
		//----------------------------------
		//  dataProvider
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var collectionChanged:Boolean = false;
		
		[Bindable("collectionChange")]
		[Inspectable(category="Data", arrayType="Object")]
		
		/**
		 *  @inheritDoc
		 */
		override public function set dataProvider(value:Object):void
		{
			selectionChanged = true;
			
			super.dataProvider = value;
			
			destroyDropdown();
			
			_showingDropdown = false;
			
			invalidateProperties();
			invalidateSize();
		}
		
		//----------------------------------
		//  itemRenderer
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for itemRenderer property.
		 */
		private var _itemRenderer:IFactory;
		
		[Inspectable(category="Data")]
		
		/**
		 *  IFactory that generates the instances that displays the data for the
		 *  drop-down list of the control.  You can use this property to specify 
		 *  a custom item renderer for the drop-down list.
		 *
		 *  <p>The control uses a List control internally to create the drop-down
		 *  list.
		 *  The default item renderer for the List control is the ListItemRenderer
		 *  class, which draws the text associated with each item in the list, 
		 *  and an optional icon. </p>
		 *
		 *  @see mx.controls.List
		 *  @see mx.controls.listClasses.ListItemRenderer
		 */
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		
		/**
		 *  @private
		 */
		public function set itemRenderer(value:IFactory):void
		{
			_itemRenderer = value;
			
			if (_dropdown)
				_dropdown.itemRenderer = value;
			
			invalidateSize();
			invalidateDisplayList();
			
			dispatchEvent(new Event("itemRendererChanged"));
		}
		
		//----------------------------------
		//  selectedIndex
		//----------------------------------
		
		[Bindable("change")]
		[Bindable("collectionChange")]
		[Bindable("valueCommit")]
		[Inspectable(category="General", defaultValue="0")]
		
		/**
		 *  Index of the selected item in the drop-down list.
		 *  Setting this property sets the current index and displays
		 *  the associated label in the TextInput portion.
		 *  <p>The default value is -1, but it set to 0
		 *  when a <code>dataProvider</code> is assigned, unless there is a prompt.
		 *  If the control is editable, and the user types in the TextInput portion,
		 *  the value of the <code>selectedIndex</code> property becomes 
		 *  -1. If the value of the <code>selectedIndex</code> 
		 *  property is out of range, the <code>selectedIndex</code> property is set to the last
		 *  item in the <code>dataProvider</code>.</p>
		 */
		override public function set selectedIndex(value:int):void
		{
			super.selectedIndex = value;
			
			if (value >= 0)
				selectionChanged = true;
			
			implicitSelectedIndex = false;
			invalidateDisplayList();
			
			// value committed event needs the text to be set
			if( textInput && !textChanged && value >= 0 )
			{
				textInput.text = selectedLabel;
				filterString = ( _removeFilterOnSelection ) ? "" : selectedLabel;
			}
			else if( textInput && prompt && _removeInputOnFocusOut )
			{
				textInput.text = prompt;
				filterString = "";
			}
			
			// [Matt] setting the text of the textInput should take care of this now
			// Send a valueCommit event, which is used by the data model
			//dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
		}
		
		//----------------------------------
		//  selectedItem
		//----------------------------------
		
		[Bindable("change")]
		[Bindable("collectionChange")]
		[Bindable("valueCommit")]
		[Inspectable(environment="none")]
		
		/**
		 *  Contains a reference to the selected item in the
		 *  <code>dataProvider</code>.
		 *  If the data is an object or class instance, modifying
		 *  properties in the object or instance modifies the <code>dataProvider</code>
		 *  and thus its views.  Setting the selectedItem itself causes the
		 *  ComboBox to select that item (display it in the TextInput portion and set
		 *  the selectedIndex) if it exists in the dataProvider.
		 *  <p>If the ComboBox control is editable, the <code>selectedItem</code>
		 *  property is <code>null</code> if the user types any text
		 *  into the TextInput.
		 *  It has a value only if the user selects an item from the drop-down
		 *  list, or if it is set programmatically.</p>
		 */
		override public function set selectedItem(value:Object):void
		{
			selectedItemSet = true;
			
			// We do not want to apply an implicit default index in this case.
			implicitSelectedIndex = false;
			
			super.selectedItem = value;
			
			// value committed event needs the text to be set
			if( textInput && !textChanged && selectedItem )
			{
				textInput.text = selectedLabel;
				filterString = ( _removeFilterOnSelection ) ? "" : selectedLabel;
			}
			else if( textInput && prompt && _removeInputOnFocusOut )
			{
				textInput.text = prompt;
				filterString = "";
			}
		}
		
		//----------------------------------
		//  showInAutomationHierarchy
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function set showInAutomationHierarchy(value:Boolean):void
		{
			//do not allow value changes
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  dropdown
		//----------------------------------
		
		/**
		 *  A reference to the List control that acts as the drop-down in the ComboBox.
		 */
		public function get dropdown():ListBase
		{
			return getDropdown();
		}
		
		//----------------------------------
		//  dropdownFactory
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the dropdownFactory property.
		 */
		private var _dropdownFactory:IFactory = new ClassFactory( List );
		
		[Bindable("dropdownFactoryChanged")]
		
		/**
		 *  The IFactory that creates a ListBase-derived instance to use
		 *  as the drop-down.
		 *  The default value is an IFactory for List
		 *
		 */
		public function get dropdownFactory():IFactory
		{
			return _dropdownFactory;
		}
		
		/**
		 *  @private
		 */
		public function set dropdownFactory(value:IFactory):void
		{
			_dropdownFactory = value;
			
			dispatchEvent(new Event("dropdownFactoryChanged"));
		}
		
		//----------------------------------
		//  dropDownStyleFilters
		//----------------------------------
		
		/**
		 *  The set of styles to pass from the ComboBox to the dropDown.
		 *  Styles in the dropDownStyleName style will override these styles.
		 *  @see mx.styles.StyleProxy
		 *  @review
		 */
		protected function get dropDownStyleFilters():Object
		{
			return null;
		}
		
		//----------------------------------
		//  dropdownWidth
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the dropdownWidth property.
		 */
		private var _dropdownWidth:Number = 100;
		
		[Bindable("dropdownWidthChanged")]
		[Inspectable(category="Size", defaultValue="100")]
		
		/**
		 *  Width of the drop-down list, in pixels.
		 *  <p>The default value is 100 or the width of the longest text
		 *  in the <code>dataProvider</code>, whichever is greater.</p>
		 *
		 */
		public function get dropdownWidth():Number
		{
			return _dropdownWidth;
		}
		
		/**
		 *  @private
		 */
		public function set dropdownWidth(value:Number):void
		{
			_dropdownWidth = value;
			
			preferredDropdownWidth = value;
			
			if (_dropdown)
				_dropdown.setActualSize(value, _dropdown.height);
			
			dispatchEvent(new Event("dropdownWidthChanged"));
		}
		
		//----------------------------------
		//  labelField
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the labelField property.
		 */
		private var _labelField:String = "label";
		
		/**
		 *  @private
		 */
		private var labelFieldChanged:Boolean;
		
		[Bindable("labelFieldChanged")]
		[Inspectable(category="Data", defaultValue="label")]
		
		/**
		 *  Name of the field in the items in the <code>dataProvider</code>
		 *  Array to display as the label in the TextInput portion and drop-down list.
		 *  By default, the control uses a property named <code>label</code>
		 *  on each Array object and displays it.
		 *  <p>However, if the <code>dataProvider</code> items do not contain
		 *  a <code>label</code> property, you can set the <code>labelField</code>
		 *  property to use a different property.</p>
		 *
		 */
		public function get labelField():String
		{
			return _labelField;
		}
		
		/**
		 *  @private
		 */
		public function set labelField(value:String):void
		{
			_labelField = value;
			labelFieldChanged = true;
			
			invalidateDisplayList();
			
			dispatchEvent(new Event("labelFieldChanged"));
		}
		
		//----------------------------------
		//  labelFunction
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the labelFunction property.
		 */
		private var _labelFunction:Function;
		
		/**
		 *  @private
		 */
		private var labelFunctionChanged:Boolean;
		
		[Bindable("labelFunctionChanged")]
		[Inspectable(category="Data")]
		
		/**
		 *  User-supplied function to run on each item to determine its label.
		 *  By default the control uses a property named <code>label</code>
		 *  on each <code>dataProvider</code> item to determine its label.
		 *  However, some data sets do not have a <code>label</code> property,
		 *  or do not have another property that can be used for displaying
		 *  as a label.
		 *  <p>An example is a data set that has <code>lastName</code> and
		 *  <code>firstName</code> fields but you want to display full names.
		 *  You use <code>labelFunction</code> to specify a callback function
		 *  that uses the appropriate fields and return a displayable String.</p>
		 *
		 *  <p>The labelFunction takes a single argument which is the item
		 *  in the dataProvider and returns a String:</p>
		 *  <pre>
		 *  myLabelFunction(item:Object):String
		 *  </pre>
		 *
		 */
		public function get labelFunction():Function
		{
			return _labelFunction;
		}
		
		/**
		 *  @private
		 */
		public function set labelFunction(value:Function):void
		{
			_labelFunction = value;
			labelFunctionChanged = true;
			
			invalidateDisplayList();
			
			dispatchEvent(new Event("labelFunctionChanged"));
		}
		
		//----------------------------------
		//  prompt
		//----------------------------------
		
		private var promptChanged:Boolean = false;
		
		/**
		 *  @private
		 *  Storage for the prompt property.
		 */
		private var _prompt:String;
		
		[Inspectable(category="General")]
		
		/**
		 *  The prompt for the ComboBox control. A prompt is
		 *  a String that is displayed in the TextInput portion of the
		 *  ComboBox when <code>selectedIndex</code> = -1.  It is usually
		 *  a String like "Select one...".  If there is no
		 *  prompt, the ComboBox control sets <code>selectedIndex</code> to 0
		 *  and displays the first item in the <code>dataProvider</code>.
		 */
		public function get prompt():String
		{
			return _prompt;
		}
		
		/**
		 *  @private
		 */
		public function set prompt(value:String):void
		{
			_prompt = value;
			promptChanged = true;
			invalidateProperties();
		}
		
		//----------------------------------
		//  rowCount
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the rowCount property.
		 */
		private var _rowCount:int = 5;
		
		[Bindable("resize")]
		[Inspectable(category="General", defaultValue="5")]
		
		/**
		 *  Maximum number of rows visible in the ComboBox control list.
		 *  If there are fewer items in the
		 *  dataProvider, the ComboBox shows only as many items as
		 *  there are in the dataProvider.
		 *  
		 *  @default 5
		 */
		public function get rowCount():int
		{
			return Math.max(1, Math.min(_filteredCollection.length, _rowCount));
		}
		
		/**
		 *  @private
		 */
		public function set rowCount(value:int):void
		{
			_rowCount = value;
			
			if (_dropdown)
				_dropdown.rowCount = value;
		}
		
		//----------------------------------
		//  selectedLabel
		//----------------------------------
		
		/**
		 *  The String displayed in the TextInput portion of the ComboBox. It
		 *  is calculated from the data by using the <code>labelField</code> 
		 *  or <code>labelFunction</code>.
		 */
		public function get selectedLabel():String
		{
			var item:Object = selectedItem;
			
			return itemToLabel(item);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: UIComponent
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function initializeAccessibility():void
		{
			if (FilterComboBox.createAccessibilityImplementation != null)
				FilterComboBox.createAccessibilityImplementation(this);
		}
		
		/**
		 *  @private
		 */
		override public function styleChanged( styleProp:String ):void
		{
			destroyDropdown();
			
			super.styleChanged( styleProp );
			
			if( !styleProp || styleProp == "styleName" || styleProp == "matchedTextStyleName" )
			{
				var style:CSSStyleDeclaration = StyleManager.getStyleManager( moduleFactory ).getStyleDeclaration( "." + getStyle( "matchedTextStyleName" ) );
				
				if( style )
				{
					_highlightTextFormat = new TextFormat();
					if( !isNaN( style.getStyle( "color" ) ) ) _highlightTextFormat.color = style.getStyle( "color" )
					if( style.getStyle( "fontFamily" ) ) _highlightTextFormat.font = style.getStyle( "fontFamily" );
					if( style.getStyle( "fontWeight" ) ) _highlightTextFormat.bold = style.getStyle( "fontWeight" );
					if( style.getStyle( "fontSize" ) ) _highlightTextFormat.size = style.getStyle( "fontSize" );
					if( style.getStyle( "fontStyle" ) ) _highlightTextFormat.italic = style.getStyle( "fontStyle" );
					if( style.getStyle( "textDecoration" ) ) _highlightTextFormat.underline = style.getStyle( "textDecoration" );
				}
				else
				{
					_highlightTextFormat = null;
				}
			}
		}
		
		/**
		 *  Makes sure the control is at least 40 pixels wide,
		 *  and tall enough to fit one line of text
		 *  in the TextInput portion of the control but at least
		 *  22 pixels high.
		 */
		override protected function measure():void
		{
			super.measure();
			
			// Make sure we're not too small
			measuredMinWidth = Math.max(measuredWidth, DEFAULT_MEASURED_MIN_WIDTH);
			
			// Make sure we're tall enough to hold our text.
			// Text field height is text height + 4 pixels top/bottom
			var textHeight:Number = measureText("M").height + 6;
			var bm:EdgeMetrics = borderMetrics;
			measuredMinHeight = measuredHeight =
				Math.max(textHeight + bm.top + bm.bottom, DEFAULT_MEASURED_MIN_HEIGHT);
			if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)    
				measuredMinHeight = measuredHeight += getStyle("paddingTop") + getStyle("paddingBottom");
		}
		
		/**
		 *  @private
		 *  Make sure the drop-down width is the same as the rest of the ComboBox
		 */
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			downArrowButton.visible = ( getStyle("arrowButtonWidth") != 0 );
			
			// we toss the dropdown when resized
			// except if we're opening the dropdown
			// then we assume the updateDisplayList() call is spurious
			// and will not affect the dropdown size
			if (_dropdown && !inTween)
			{
				destroyDropdown();
			}
			else if (!_showingDropdown && inTween)
			{
				bRemoveDropdown = true;
			}
			
			var ddw:Number = preferredDropdownWidth;
			if (isNaN(ddw))
				ddw = _dropdownWidth = unscaledWidth;
			
			if (labelFieldChanged)
			{
				if (_dropdown)
					_dropdown.labelField = _labelField;
				
				selectionChanged = true;
				if (!explicitText) 
					textInput.text = selectedLabel;
				labelFieldChanged = false;
			}
			
			if (labelFunctionChanged)
			{
				selectionChanged = true;
				if (!explicitText)
					textInput.text = selectedLabel;
				labelFunctionChanged = false;
			}
			
			if (selectionChanged)
			{
				if (!textChanged)
				{
					if (selectedIndex == -1 && prompt )
					{
						if( _removeInputOnFocusOut ) textInput.text = prompt;
					}
					else if (!explicitText)
					{
						textInput.text = selectedLabel;
					}
				}
				
				textInput.invalidateDisplayList();
				textInput.validateNow();
				
				if (editable)
				{
					TextInput( textInput ).getTextField().setSelection(0, textInput.text.length);
					TextInput( textInput ).getTextField().scrollH = 0;
				}
				
				if (_dropdown)
					_dropdown.selectedIndex = selectedIndex;
				
				selectionChanged = false;
			}
			
			// We might need to decrease the number of rows.
			if (_dropdown && _dropdown.rowCount != rowCount)
				_dropdown.rowCount = rowCount;
		}
		
		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{
			explicitText = textChanged;
			
			super.commitProperties();
			
			if (collectionChanged)
			{
				if (selectedIndex == -1 && implicitSelectedIndex && _prompt == null)
					selectedIndex = 0;
				selectedIndexChanged = true;
				collectionChanged = false;
			}
			if (promptChanged && prompt != null && selectedIndex == -1)
			{
				promptChanged = false;
				textInput.text = prompt;
			}
			if( _filterChanged )
			{
				_filterChanged = false;
				_filteredCollection.filterFunction = _activeFilterFunction;
				_filteredCollection.refresh();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Returns a string representing the <code>item</code> parameter.
		 *  
		 *  <p>This method checks in the following order to find a value to return:</p>
		 *  
		 *  <ol>
		 *    <li>If you have specified a <code>labelFunction</code> property,
		 *  returns the result of passing the item to the function.</li>
		 *    <li>If the item is a String, Number, Boolean, or Function, returns
		 *  the item.</li>
		 *    <li>If the item has a property with the name specified by the control's
		 *  <code>labelField</code> property, returns the contents of the property.</li>
		 *    <li>If the item has a label property, returns its value.</li>
		 *  </ol>
		 * 
		 *  @param item The object that contains the value to convert to a label. If the item is null, this method returns the empty string.
		 */
		public function itemToLabel(item:Object):String
		{
			// we need to check for null explicitly otherwise
			// a numeric zero will not get properly converted to a string.
			// (do not use !item)
			if (item == null)
				return "";
			
			if (labelFunction != null)
				return labelFunction(item);
			
			if (typeof(item) == "object")
			{
				try
				{
					if (item[labelField] != null)
						item = item[labelField];
				}
				catch(e:Error)
				{
				}
			}
			else if (typeof(item) == "xml")
			{
				try
				{
					if (item[labelField].length() != 0)
						item = item[labelField];
				}
				catch(e:Error)
				{
				}
			}
			
			if (typeof(item) == "string")
				return String(item);
			
			try
			{
				return item.toString();
			}
			catch(e:Error)
			{
			}
			
			return " ";
		}
		
		/**
		 *  Displays the drop-down list.
		 */
		public function open():void
		{
			displayDropdown( true );
		}
		
		/**
		 *  Hides the drop-down list.
		 */
		public function close( trigger:Event = null ):void
		{
			if( _showingDropdown )
			{
				setSelectedIndexFromDropDown();
				
				displayDropdown( false, trigger ) ;
				
				dispatchChangeEvent( new Event("dummy"), _selectedIndexOnDropdown, selectedIndex);
			}
		}
		
		/**
		 *  @private
		 */
		mx_internal function hasDropdown():Boolean
		{
			return _dropdown != null;
		}
		
		/**
		 *  @private
		 */
		private function getDropdown():ListBase
		{
			if (!initialized)
				return null;
			
			if (!hasDropdown())
			{
				var dropDownStyleName:String = getStyle("dropDownStyleName");
				if (dropDownStyleName == null ) 
					dropDownStyleName = getStyle("dropdownStyleName");
				
				
				_dropdown = dropdownFactory.newInstance();
				_dropdown.visible = false;
				_dropdown.focusEnabled = false;
				_dropdown.owner = this;
				
				if (itemRenderer)
					_dropdown.itemRenderer = itemRenderer;
				
				if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
				{
					_dropdown.styleName = this;
				}
				
				if (dropDownStyleName)
				{
					if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
					{
						var styleDecl:CSSStyleDeclaration =
							StyleManager.getStyleManager( moduleFactory ).getStyleDeclaration("." + dropDownStyleName);
						
						if (styleDecl)
							_dropdown.styleDeclaration = styleDecl;
					}
					else
					{
						_dropdown.styleName = dropDownStyleName;
					}
				}
				else if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
				{
					_dropdown.setStyle("cornerRadius", 0);
				}
				
				PopUpManager.addPopUp(_dropdown, this);
				
				// Don't display a tween when the selection changes.
				// The dropdown menu is about to appear anyway,
				// and other processing can make the tween look choppy.
				_dropdown.setStyle("selectionDuration", 0);
				
				if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0 && dropdownBorderStyle && dropdownBorderStyle != "")
					_dropdown.setStyle("borderStyle", dropdownBorderStyle);
				
				// Set up a data provider in case one doesn't yet exist,
				// so we can share it with the dropdown listbox.
				if (!dataProvider)
					dataProvider = new ArrayCollection();
				
				_dropdown.dataProvider = filteredCollection;
				_dropdown.rowCount = rowCount;
				_dropdown.width = _dropdownWidth;
				_dropdown.selectedIndex = selectedIndex;
				_oldIndex = selectedIndex;
				_dropdown.verticalScrollPolicy = ScrollPolicy.AUTO;
				_dropdown.labelField = _labelField;
				_dropdown.labelFunction = itemToLabel;
				_dropdown.allowDragSelection = true;
				
				_dropdown.addEventListener("change", dropdown_changeHandler);
				_dropdown.addEventListener( FlexEvent.VALUE_COMMIT, dropdown_valueCommitHandler);
				_dropdown.addEventListener(ScrollEvent.SCROLL, dropdown_scrollHandler);
				_dropdown.addEventListener(ListEvent.ITEM_ROLL_OVER, dropdown_itemRollOverHandler);
				_dropdown.addEventListener(ListEvent.ITEM_ROLL_OUT, dropdown_itemRollOutHandler);
				_dropdown.addEventListener( FlexEvent.UPDATE_COMPLETE, onDropdownDataChange, false, 0, true );
				
				// the drop down should close if the user clicks on any item.
				// add a handler to detect a click in the list
				_dropdown.addEventListener(ListEvent.ITEM_CLICK, dropdown_itemClickHandler);
				
				UIComponentGlobals.layoutManager.validateClient(_dropdown, true);
				_dropdown.setActualSize(_dropdownWidth, _dropdown.getExplicitOrMeasuredHeight());
				_dropdown.validateDisplayList();
				
				_dropdown.cacheAsBitmap = true;
				
				// weak reference to stage
				systemManager.addEventListener(Event.RESIZE, stage_resizeHandler, false, 0, true);
			}
			
			_dropdown.scaleX = scaleX;
			_dropdown.scaleY = scaleY;
			
			return _dropdown;
		}
		
		/**
		 *  @private
		 */
		private function displayDropdown(show:Boolean, trigger:Event = null):void
		{
			if( !enabled ) return;
			
			if( textInput.text == prompt ) textInput.text = "";
			
			if (!initialized || show == _showingDropdown)
				return;
			
			// Subclasses may extend to do pre-processing
			// before the dropdown is displayed
			// or override to implement special display behavior
			
			// Show or hide the dropdown
			var initY:Number;
			var endY:Number;
			var duration:Number;
			var easingFunction:Function;
			
			var point:Point = new Point(0, unscaledHeight);
			point = localToGlobal(point);
			
			var sm:ISystemManager = systemManager.topLevelSystemManager;
			var sbRoot:DisplayObject = sm.getSandboxRoot();
			var screen:Rectangle;
			
			if (sm != sbRoot)
			{
				var request:InterManagerRequest = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST, 
					false, false,
					"getVisibleApplicationRect"); 
				sbRoot.dispatchEvent(request);
				screen = Rectangle(request.value);
			}
			else
				screen = sm.getVisibleApplicationRect();
			
			//opening the dropdown 
			if (show)
			{
				// Store the selectedIndex temporarily so we can tell
				// if the value changed when the dropdown is closed
				_selectedIndexOnDropdown = selectedIndex;
				
				getDropdown();
				
				_dropdown.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, dropdown_mouseOutsideHandler);
				_dropdown.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE, dropdown_mouseOutsideHandler);
				_dropdown.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, dropdown_mouseOutsideHandler);
				_dropdown.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE, dropdown_mouseOutsideHandler);
				
				if (_dropdown.parent == null)  // was popped up then closed
					PopUpManager.addPopUp(_dropdown, this);
				else
					PopUpManager.bringToFront(_dropdown);
				
				// if we donot have enough space in the bottom display the dropdown
				// at the top. But if the space there is also less than required
				// display it below.
				if (point.y + _dropdown.height > screen.bottom &&
					point.y > screen.top + _dropdown.height)
				{
					// Dropdown will go below the bottom of the stage
					// and be clipped. Instead, have it grow up.
					point.y -= (unscaledHeight + _dropdown.height);
					initY = -_dropdown.height;
					tweenUp = true;
				}
				else
				{
					initY = _dropdown.height;
					tweenUp = false;
				}
				
				point = _dropdown.parent.globalToLocal(point);
				
				var sel:int = _dropdown.selectedIndex;
				if (sel == -1)
					sel = 0;
				var pos:Number = _dropdown.verticalScrollPosition;
				
				// try to set the verticalScrollPosition one above the selected index so
				// it looks better when the dropdown is displayed
				pos = sel - 1;
				pos = Math.min(Math.max(pos, 0), _dropdown.maxVerticalScrollPosition);
				_dropdown.verticalScrollPosition = pos;
				
				if (_dropdown.x != point.x || _dropdown.y != point.y)
					_dropdown.move(point.x, point.y);
				
				
				if (!_dropdown.visible)
					_dropdown.visible = true;
				
				// Make sure we don't remove the dropdown at the end of the tween
				bRemoveDropdown = false;
				
				// Set up the tween and relevant variables. 
				_showingDropdown = show;
				duration = getStyle("openDuration");
				endY = 0;
				easingFunction = getStyle("openEasingFunction") as Function;
			}
				
				// closing the dropdown 
			else if (_dropdown)
			{
				// Set up the tween and relevant variables. 
				endY = (point.y + _dropdown.height > screen.bottom || tweenUp
					? -_dropdown.height
					: _dropdown.height);
				_showingDropdown = show;
				initY = 0;
				duration = getStyle("closeDuration");
				easingFunction = getStyle("closeEasingFunction") as Function;
				
				_dropdown.resetDragScrolling();
			}
			
			inTween = true;
			UIComponentGlobals.layoutManager.validateNow();
			
			// Block all layout, responses from web service, and other background
			// processing until the tween finishes executing.
			UIComponent.suspendBackgroundProcessing();
			
			// Disable the dropdown during the tween.
			if (_dropdown)
				_dropdown.enabled = false;
			
			duration = Math.max( 1, duration );
			tween = new Tween( this, initY, endY, duration );
			
			if( _showingDropdown && duration > 80 )
			{
				_dropdown.scrollRect = new Rectangle( 0, initY, _dropdown.width, _dropdown.height );
			}
			
			if (easingFunction != null && tween)
				tween.easingFunction = easingFunction;
			
			triggerEvent = trigger;
		}
		
		/**
		 *  @private
		 */
		private function dispatchChangeEvent(oldEvent:Event, prevValue:int,
											 newValue:int):void
		{
			if (prevValue != newValue)
			{
				var newEvent:Event = oldEvent is ListEvent ?
					oldEvent :
					new ListEvent("change");
				
				dispatchEvent(newEvent);
			}
		}
		
		/**
		 *  @private
		 */
		private function destroyDropdown():void
		{
			if (_dropdown && !_showingDropdown)
			{
				if (inTween)
				{
					tween.endTween();
				}
				else
				{
					PopUpManager.removePopUp(_dropdown);
					_dropdown = null;
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden event handlers
		//
		//--------------------------------------------------------------------------
		private var implicitSelectedIndex:Boolean = false;
		/**
		 *  @private
		 */
		override protected function collectionChangeHandler(event:Event):void
		{
			// Save a copy of the selectedIndex
			var curSelectedIndex:int = selectedIndex;
			
			super.collectionChangeHandler(event);
			
			if (event is CollectionEvent)
			{
				var ce:CollectionEvent = CollectionEvent(event);
				
				if (collection.length == 0)
				{
					// Special case: Empty dataProvider.
					if (!selectedIndexChanged && !selectedItemChanged)
					{
						if (super.selectedIndex != -1)
							super.selectedIndex = -1;
						implicitSelectedIndex = true;
						invalidateDisplayList();
					}
					// if the combobox is non-editable remove the text
					// we don't want to remove the text if it is editable as user might
					// have typed something.
					if (textInput && !editable)
						textInput.text = "";
				}
					
				else if (ce.kind == CollectionEventKind.ADD)
				{
					if (collection.length == ce.items.length)
					{
						// Special case: Adding the first item(s). Select item 0
						// if there is no prompt
						if (selectedIndex == -1 && _prompt == null)
							selectedIndex = 0;
					}
					else
					{
						// we dont want to destroy the dropdown just
						// because data got added.  Especially true
						// for paged data.
						return;
					}
				}
					
				else if (ce.kind == CollectionEventKind.UPDATE)
				{
					if (ce.location == selectedIndex ||
						ce.items[0].source == selectedItem)
						// unsorted lists don't have a valid location
						// Force an update of the text input
						selectionChanged = true;
				}
					
				else if (ce.kind == CollectionEventKind.REPLACE)
				{
					// bail on a replace, no need to change anything,
					// especially for paged data
					return;
				}
					
				else if (ce.kind == CollectionEventKind.RESET)
				{
					collectionChanged = true;
					if (!selectedIndexChanged && !selectedItemChanged)
						selectedIndex = prompt ? -1 : 0;
					invalidateProperties();
				}
				
				_filteredCollection = new ListCollectionView( ListCollectionView( collection ) );
				_filteredCollection.filterFunction = _activeFilterFunction;
				_filteredCollection.refresh();
				
				invalidateDisplayList();
				
				destroyDropdown();
				
				_showingDropdown = false;
			}
		}
		
		private function popup_moveHandler(event:Event):void
		{
			destroyDropdown();
		}
		
		/**
		 *  @private
		 */
		override protected function textInput_changeHandler(event:Event):void
		{
			super.textInput_changeHandler(event);
			
			if( !isShowingDropdown )
			{
				open();
			}
			else
			{
				dropdown.selectedIndex = -1;
			}
//			if( dropdown.selectedIndex != -1 ) dropdown.selectedIndex = -1;
			
//			_textInputChange = true;
			filterString = ( _caseSensitive ) ? textInput.text : textInput.text.toLowerCase();
			
//			_filteredCollection.refresh();
//			
//			if( !isShowingDropdown ) open();
			
			// Force a change event to be dispatched
			dispatchChangeEvent(event, -1, -2);
		}
		
		/**
		 *  @private
		 */
		override protected function downArrowButton_buttonDownHandler(
			event:FlexEvent):void
		{
			// The down arrow should always toggle the visibility of the dropdown.
			if (_showingDropdown)
			{
				close(event);
			}
			else
			{
				displayDropdown(true, event);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function dropdown_mouseOutsideHandler(event:Event):void
		{
			if (event is MouseEvent)
			{
				var mouseEvent:MouseEvent = MouseEvent(event);
				if (mouseEvent.target != _dropdown)
					// the dropdown's items can dispatch a mouseDownOutside
					// event which then bubbles up to us
					return;
				
				if (!hitTestPoint(mouseEvent.stageX, mouseEvent.stageY, true))
				{
					close(event);
				}
			}
			else if (event is SandboxMouseEvent) 
			{
				close(event);
			}
		}
		
		/**
		 *  @private
		 */
		private function dropdown_itemClickHandler(event:ListEvent):void
		{
			if (_showingDropdown)
			{
				close();
			}
		}
		
		/**
		 *  @private
		 */
		override protected function focusOutHandler(event:FocusEvent):void
		{
			// Note: event.relatedObject is the object getting focus.
			// It can be null in some cases, such as when you open
			// the dropdown and then click outside the application.
			
			// If the dropdown is open...
			if (_showingDropdown && _dropdown)
			{
				// If focus is moving outside the dropdown...
				if (!event.relatedObject ||
					!_dropdown.contains(event.relatedObject))
				{
					// Close the dropdown.
					close();
				}
			}
			
			super.focusOutHandler(event);
		}
		
		private function stage_resizeHandler(event:Event):void
		{
			if (_dropdown)
			{
				_dropdown.$visible = false;
				_showingDropdown = false;
			}
		}
		
		/**
		 *  @private
		 */
		private function dropdown_scrollHandler(event:Event):void
		{
			// TextField.scroll bubbles so you might see it here
			if (event is ScrollEvent)
			{
				var se:ScrollEvent = ScrollEvent(event);
				if (se.detail == ScrollEventDetail.THUMB_TRACK ||
					se.detail == ScrollEventDetail.THUMB_POSITION ||
					se.detail == ScrollEventDetail.LINE_UP ||
					se.detail == ScrollEventDetail.LINE_DOWN)
					dispatchEvent(se);
				
				onDropdownDataChange( new FlexEvent( FlexEvent.DATA_CHANGE ) );
			}
		}
		
		/**
		 *  @private
		 */
		private function dropdown_itemRollOverHandler(event:Event):void
		{
			dispatchEvent(event);
			
			updateHighlightedText();
		}
		
		/**
		 *  @private
		 */
		private function dropdown_itemRollOutHandler(event:Event):void
		{
			dispatchEvent(event);
			
			updateHighlightedText();
		}
		
		private function dropdown_valueCommitHandler(event:FlexEvent):void
		{
			
		}
		
		/**
		 *  @private
		 */
		private function dropdown_changeHandler(event:Event):void
		{
			var prevValue:int = selectedIndex;
			
			// This assignment will also assign the label to the text field.
			// See setSelectedIndex().
			//setSelectedIndexFromDropDown();
			
			updateHighlightedText();

			// If this was generated by the dropdown as a result of a keystroke, it is
			// likely a Page-Up or Page-Down, or Arrow-Up or Arrow-Down.
			// If the selection changes due to a keystroke,
			// we leave the dropdown displayed.
			// If it changes as a result of a mouse selection,
			// we close the dropdown.
			if (!_showingDropdown)
				dispatchChangeEvent(event, prevValue, selectedIndex);
			else if (!bInKeyDown)
			{
				// this will also send a change event if needed
				close();
			}
		}
		
		/**
		 *  @private
		 */
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			// If the combo box is disabled, don't do anything
			if(!enabled)
				return;
			
			// If a the editable field currently has focus, it is handling
			// all arrow keys. We shouldn't also scroll this selection.
			if (event.target == textInput)
				return;
			
			if (event.ctrlKey && event.keyCode == Keyboard.DOWN)
			{
				displayDropdown(true, event);
				event.stopPropagation();
			}
			else if (event.ctrlKey && event.keyCode == Keyboard.UP)
			{
				close(event);
				event.stopPropagation();
			}
			else if (event.keyCode == Keyboard.ESCAPE)
			{
				if (_showingDropdown)
				{
					if (_oldIndex != _dropdown.selectedIndex)
						selectedIndex = _oldIndex;
					
					displayDropdown(false);
					event.stopPropagation();
				}
			}
				
			else if (event.keyCode == Keyboard.ENTER)
			{
				if (_showingDropdown)
				{
					close();
					event.stopPropagation();
				}
			}
			else
			{
				if (!editable ||
					event.keyCode == Keyboard.UP ||
					event.keyCode == Keyboard.DOWN ||
					event.keyCode == Keyboard.PAGE_UP ||
					event.keyCode == Keyboard.PAGE_DOWN)
				{
					var oldIndex:int = selectedIndex;
					
					// Make sure we know we are handling a keyDown,
					// so if the dropdown sends out a "change" event
					// (like when an up-arrow or down-arrow changes
					// the selection) we know not to close the dropdown.
					bInKeyDown = _showingDropdown;
					// Redispatch the event to the dropdown
					// and let its keyDownHandler() handle it.
					
					dropdown.dispatchEvent(event.clone());
					event.stopPropagation();
					bInKeyDown = false;
					
				}
			}
		}
		
		/**
		 *  @private
		 *  This acts as the destructor.
		 */
		private function unloadHandler(event:Event):void
		{
			if (inTween)
			{
				UIComponent.resumeBackgroundProcessing();
				inTween = false;
			}
			
			if (_dropdown)
				_dropdown.parent.removeChild(_dropdown);
		}
		
		/**
		 *  @private
		 */
		private function removedFromStageHandler(event:Event):void
		{
			// Ensure we've unregistered ourselves from PopupManager, else
			// we'll be leaked.
			destroyDropdown();
		}
		
		//--------------------------------------------------------------------------
		//
		// Tween handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		mx_internal function onTweenUpdate(value:Number):void
		{
			trace( "onTweenUpdate", value );
			if (_dropdown)
			{
				_dropdown.scrollRect = new Rectangle(0, value,
					_dropdown.width, _dropdown.height);
			}
		}
		
		/**
		 *  @private
		 */
		mx_internal function onTweenEnd(value:Number):void
		{
			if (_dropdown)
			{
				// Clear the scrollRect here. This way if drop shadows are
				// assigned to the dropdown they show up correctly
				_dropdown.scrollRect = null;
				
				inTween = false;
				_dropdown.enabled = true;
				_dropdown.visible = _showingDropdown;
			}
			
			if (bRemoveDropdown)
			{
				_dropdown.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, dropdown_mouseOutsideHandler);
				_dropdown.removeEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE, dropdown_mouseOutsideHandler);
				_dropdown.removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, dropdown_mouseOutsideHandler);
				_dropdown.removeEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE, dropdown_mouseOutsideHandler);
				
				PopUpManager.removePopUp(_dropdown);
				_dropdown = null;
				bRemoveDropdown = false;
			}
			
			UIComponent.resumeBackgroundProcessing();
			var cbdEvent:DropdownEvent =
				new DropdownEvent(_showingDropdown ? DropdownEvent.OPEN : DropdownEvent.CLOSE);
			cbdEvent.triggerEvent = triggerEvent;
			dispatchEvent(cbdEvent);
		}
		
		/**
		 *  Determines default values of the height and width to use for each 
		 *  entry in the drop-down list, based on the maximum size of the label 
		 *  text in the first <code>numItems</code> items in the data provider. 
		 *
		 *  @param count The number of items to check to determine the value.
		 *  
		 *  @return An Object containing two properties: width and height.
		 */
		override protected function calculatePreferredSizeFromData(count:int):Object
		{
			var maxW:Number = 0;
			var maxH:Number = 0;
			
			var bookmark:CursorBookmark = iterator ? iterator.bookmark : null;
			
			iterator.seek(CursorBookmark.FIRST, 0);
			
			var more:Boolean = iterator != null;
			
			var lineMetrics:TextLineMetrics;
			
			for (var i:int = 0; i < count; i++)
			{
				var data:Object;
				if (more)
					data = iterator ? iterator.current : null;
				else
					data = null;
				
				var txt:String = itemToLabel(data);
				
				lineMetrics = measureText(txt);
				
				maxW = Math.max(maxW, lineMetrics.width);
				maxH = Math.max(maxH, lineMetrics.height);
				
				if (iterator)
					iterator.moveNext();
			}
			
			if (prompt)
			{
				lineMetrics = measureText(prompt);
				
				maxW = Math.max(maxW, lineMetrics.width);
				maxH = Math.max(maxH, lineMetrics.height);
			}
			
			maxW += getStyle("paddingLeft") + getStyle("paddingRight");
			
			if (iterator)
				iterator.seek(bookmark, 0);
			
			return { width: maxW, height: maxH };
		}
		
		/**
		 *  @private
		 */
		mx_internal function get isShowingDropdown():Boolean
		{
			return _showingDropdown;
		}
		
		
		
		
		private var _filterChanged				: Boolean;
		private var _filterString				: String;
		private var _filterFunction				: Function;
		private var _activeFilterFunction		: Function;
		
		private var _filteredCollection			: ICollectionView;
		
		private var _caseSensitive				: Boolean;
		private var _selectSingleMatch			: Boolean;
		private var _removeFilterOnSelection	: Boolean;
		private var _removeInputOnFocusOut		: Boolean = true;
		private var _highlightTextFormat		: TextFormat;
		
		public function get filteredCollection():ICollectionView
		{
			return _filteredCollection;
		}
		
		private function filterDataFunction( item:Object ):Boolean
		{
			var label:String = ( _caseSensitive ) ? itemToLabel( item ) : itemToLabel( item ).toLowerCase();
			return ( label.indexOf( _filterString ) != -1 );
		}
		
		public function get caseSensitive():Boolean
		{
			return _caseSensitive;
		}
		public function set caseSensitive( value:Boolean ):void
		{
			if( _caseSensitive == value ) return;
			
			_caseSensitive = value;
			if( textInput.text != _prompt ) filterString = textInput.text;
		}
		
		public function get selectSingleMatch():Boolean
		{
			return _selectSingleMatch;
		}
		public function set selectSingleMatch( value:Boolean ):void
		{
			if( _selectSingleMatch == value ) return;
			
			_selectSingleMatch = value;
			if( _filteredCollection.length == 1 && _selectSingleMatch ) dropdown.selectedIndex = 0;
		}
		
		public function get removeFilterOnSelection():Boolean
		{
			return _removeFilterOnSelection;
		}
		public function set removeFilterOnSelection( value:Boolean ):void
		{
			if( _removeFilterOnSelection == value ) return;
			
			_removeFilterOnSelection = value;
			if( !dropdown && selectedIndex > -1 ) filterString = "";
		}
		
		public function get removeInputOnFocusOut():Boolean
		{
			return _removeInputOnFocusOut;
		}
		public function set removeInputOnFocusOut( value:Boolean ):void
		{
			if( _removeInputOnFocusOut == value ) return;
			
			_removeInputOnFocusOut = value;
		}
		
		public function get filterString():String
		{
			return _filterString;
		}
		public function set filterString( value:String ):void
		{
			var newFilter:String = ( _caseSensitive ) ? value : value.toLowerCase();
			if( _filterString == newFilter ) return;
			
			_filterString = newFilter;
			_filteredCollection.refresh();
			if( _dropdown ) _dropdown.rowCount = rowCount;
		}
		
		override public function set editable( value:Boolean ):void
		{
			// do nothing
		}
		
		override protected function createChildren():void
		{
			super.editable = true;
			
			super.createChildren();
			
//			textInput.addEventListener( FocusEvent.FOCUS_IN, onTextInputFocusIn, false, 0, true );
			textInput.addEventListener( FocusEvent.FOCUS_OUT, onTextInputFocusOut, false, 0, true );
			textInput.addEventListener( MouseEvent.MOUSE_DOWN, onTextInputMouseDown, false, 0, true );
		}
		
//		private function onTextInputFocusIn( event:FocusEvent ):void
//		{
//			if( !isShowingDropdown ) open();
//		}
		
		private function onTextInputFocusOut( event:FocusEvent ):void
		{
			if( textInput.text == "" )
			{
				_filterString = "";
				_filteredCollection.refresh();
				textInput.text = prompt;
			}
		}
		
		private function onTextInputMouseDown( event:MouseEvent ):void
		{
			if( !isShowingDropdown ) open();
		}
		
		protected function onDropdownDataChange( event:FlexEvent ):void
		{
			if( _filteredCollection.length == 1 && _selectSingleMatch ) dropdown.selectedIndex = 0;
			
			if( !inTween && isShowingDropdown )
			{
				if( _dropdown.localToGlobal( new Point() ).y < localToGlobal( new Point() ).y )
				{
					var point:Point = localToGlobal(new Point() );
					_dropdown.y = point.y-_dropdown.height;
				}
			}
			updateHighlightedText();
		}
		
		private function updateHighlightedText():void
		{
			var renderer:ListItemRenderer;
			var index:int;
			var label:IUITextField;
			var labelString:String;
			var filterLength:int = _filterString.length;
			var numItems:int = dropdown.rendererArray.length;
			var i:int;
			
			if( _filterString == "" )
			{
				for( i = 0; i < numItems; i++ )
				{
					renderer = ListItemRenderer( dropdown.rendererArray[ i ][ 0 ] );
					if( renderer )
					{
						label = renderer.getLabel();
						label.setSelection( 0, 0 );
						label.setTextFormat( label.defaultTextFormat );
					}
				}
				return;
			}
			
			for( i = 0; i < numItems; i++ )
			{
				renderer = ListItemRenderer( dropdown.rendererArray[ i ][ 0 ] );
				if( renderer )
				{
					
					label = renderer.getLabel();
					label.alwaysShowSelection = true;
					labelString = ( _caseSensitive ) ? label.text : label.text.toLowerCase();
					if( _highlightTextFormat )
					{
						label.setSelection( 0, 0 );
						setHighlightTextFormatonLabel( label, labelString, 0, filterLength );
					}
					else
					{
						index = labelString.indexOf( _filterString );
						if( index != -1 ) label.setSelection( index, index + filterLength );
					}
					
					
				}
			}
		}
		
		private function setHighlightTextFormatonLabel( label:IUITextField, labelString:String, startIndex:int, length:int ):void
		{
			var index:int = labelString.indexOf( _filterString, startIndex );
			if( index != -1 )
			{
				label.setTextFormat( _highlightTextFormat, index, index + length );
				setHighlightTextFormatonLabel( label, labelString, index + length, length );
			}
		}
		
		
		private function setSelectedIndexFromDropDown():void
		{
			if( _dropdown )
			{
				if( _dropdown.selectedIndex == -1 )
				{
					selectedIndex = _dropdown.selectedIndex;
				}
				else
				{
					if( selectedItem && dropdown.selectedItem == selectedItem ) return;
					
					iterator.seek( CursorBookmark.FIRST );
					var numItems:int = collection.length;
					for( var i:int = 0; i < numItems; i++ )
					{
						if( iterator.current == _dropdown.selectedItem )
						{
							selectedIndex = i;
							break;
						}
						iterator.moveNext();
					}
				}
			}
		}
		
		
	}
	
}
