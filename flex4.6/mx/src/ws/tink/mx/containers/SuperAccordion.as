////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2008 Tink Ltd | http://www.tink.ws
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

package ws.tink.mx.containers
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.automation.IAutomationObject;
	import mx.core.ClassFactory;
	import mx.core.ComponentDescriptor;
	import mx.core.Container;
	import mx.core.ContainerCreationPolicy;
	import mx.core.EdgeMetrics;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.effects.Effect;
	import mx.effects.Tween;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.FlexEvent;
	import mx.geom.RoundedRectangle;
	import mx.managers.HistoryManager;
	import mx.managers.IFocusManagerComponent;
	import mx.managers.IHistoryManagerClient;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	import ws.tink.mx.containers.superAccordion.SuperAccordionHeader;
	import ws.tink.mx.events.IndicesChangedEvent;
	
	use namespace mx_internal;
	
	[RequiresDataBinding(true)]
	
	[IconFile("SuperAccordion.png")]
	
	/**
	 *  Dispatched when the selected child container changes.
	 *
	 *  @eventType mx.events.IndicesChangedEvent.CHANGE
	 */
	[Event(name="indicesChange", type="ws.tink.mx.events.IndicesChangedEvent")]
	
	// The fill related styles are applied to the children of the Accordion, ie: the AccordionHeaders
	//include "../styles/metadata/FillStyles.as"
	//include "../styles/metadata/SelectedFillColorsStyle.as"
	
	// The focus styles are applied to the Accordion itself
	//include "../styles/metadata/FocusStyles.as"
	
	/**
	 *  Name of CSS style declaration that specifies styles for the accordion
	 *  headers (tabs).
	 */
	[Style(name="headerStyleName", type="String", inherit="no")]
	
	/**
	 *  Number of pixels between the container's top border and its content area.
	 *  The default value is -1, so the top border of the first header
	 *  overlaps the Accordion container's top border.
	 */
	[Style(name="paddingTop", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between the container's bottom border and its content area.
	 *  The default value is -1, so the bottom border of the last header
	 *  overlaps the Accordion container's bottom border.
	 */
	[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between children in the horizontal direction.
	 *  The default value is 8.
	 */
	[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Number of pixels between children in the vertical direction.
	 *  The default value is -1, so the top and bottom borders
	 *  of adjacent headers overlap.
	 */
	[Style(name="verticalGap", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Horizontal positioning of children in the SuperAccordian container.
	 *  The possible values are <code>"top"</code>, <code>"midde"</code>,
	 *  and <code>"bottom"</code>.
	 *  The default value is <code>"top"</code>.
	 * 
	 *  <p>To see a difference between the alignments,
	 *  the property closable had to be set to true.
	 *  The default value of closable is false.</p>
	 */
	[Style(name="verticalAlign", type="String", enumeration="top,middle,bottom", inherit="no" )]
	
	/**
	 *  Number of pixels to offset the verticalAlign position of children in the SuperAccordian container.
	 *  The possible values are <code>"top"</code>, <code>"midde"</code>,
	 *  and <code>"bottom"</code>.
	 *  The default value is 0.
	 * 
	 *  <p>To see a difference between the alignments,
	 *  the property closable had to be set to true.
	 *  The default value of closable is false.</p>
	 */
	[Style(name="verticalAlignOffset", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Height of each accordion header, in pixels.
	 *  The default value is automatically calculated based on the font styles for
	 *  the header.
	 */
	[Style(name="headerHeight", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Duration, in milliseconds, of the animation from one child to another.
	 *  The default value is 250.
	 */
	[Style(name="openDuration", type="Number", format="Time", inherit="no")]
	
	/**
	 *  Tweening function used by the animation from one child to another.
	 */
	[Style(name="openEasingFunction", type="Function", inherit="no")]
	
	/**
	 *  Color of header text when rolled over.
	 *  The default value is 0x2B333C.
	 */
	[Style(name="textRollOverColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  Color of selected text.
	 *  The default value is 0x2B333C.
	 */
	[Style(name="textSelectedColor", type="uint", format="Color", inherit="yes")]
	
	//--------------------------------------
	//  Excluded APIs
	//--------------------------------------
	
	[Exclude(name="autoLayout", kind="property")]
	[Exclude(name="clipContent", kind="property")]
	[Exclude(name="defaultButton", kind="property")]
	[Exclude(name="horizontalLineScrollSize", kind="property")]
	[Exclude(name="horizontalPageScrollSize", kind="property")]
	[Exclude(name="horizontalScrollBar", kind="property")]
	[Exclude(name="horizontalScrollPolicy", kind="property")]
	[Exclude(name="horizontalScrollPosition", kind="property")]
	[Exclude(name="maxHorizontalScrollPosition", kind="property")]
	[Exclude(name="maxVerticalScrollPosition", kind="property")]
	[Exclude(name="verticalLineScrollSize", kind="property")]
	[Exclude(name="verticalPageScrollSize", kind="property")]
	[Exclude(name="verticalScrollBar", kind="property")]
	[Exclude(name="verticalScrollPolicy", kind="property")]
	[Exclude(name="verticalScrollPosition", kind="property")]
	
	[Exclude(name="scroll", kind="event")]
	
	[Exclude(name="horizontalScrollBarStyleName", kind="style")]
	[Exclude(name="verticalScrollBarStyleName", kind="style")]
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	[DefaultBindingProperty(source="selectedIndex", destination="selectedIndex")]
	
	[DefaultTriggerEvent("change")]
	
	/**
	 *  An Accordion navigator container has a collection of child containers,
	 *  but only one of them at a time is visible.
	 *  It creates and manages navigator buttons (accordion headers), which you use
	 *  to navigate between the children.
	 *  There is one navigator button associated with each child container,
	 *  and each navigator button belongs to the Accordion container, not to the child.
	 *  When the user clicks a navigator button, the associated child container
	 *  is displayed.
	 *  The transition to the new child uses an animation to make it clear to
	 *  the user that one child is disappearing and a different one is appearing.
	 *
	 *  <p>The Accordion container does not extend the ViewStack container,
	 *  but it implements all the properties, methods, styles, and events
	 *  of the ViewStack container, such as <code>selectedIndex</code>
	 *  and <code>selectedChild</code>.</p>
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;mx:Accordion&gt;</code> tag inherits all of the
	 *  tag attributes of its superclass, with the exception of scrolling-related
	 *  attributes, and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;mx:Accordion
	 *    <strong>Properties</strong>
	 *    headerRenderer="<i>IFactory</i>"
	 *    historyManagementEnabled="true|false"
	 *    resizeToContent="false|true"
	 *    selectedIndex="undefined"
	 *  
	 *    <strong>Styles</strong>
	 *    fillAlphas="[0.60, 0.40, 0.75, 0.65]"
	 *    fillColors="[0xFFFFFF, 0xCCCCCC, 0xFFFFFF, 0xEEEEEE]"
	 *    focusAlpha="0.5"
	 *    focusRoundedCorners="tl tr bl br"
	 *    headerHeight="depends on header font styles"
	 *    headerStyleName="<i>No default</i>"
	 *    horizontalGap="8"
	 *    openDuration="250"
	 *    openEasingFunction="undefined"
	 *    paddingBottom="-1"
	 *    paddingTop="-1"
	 *    selectedFillColors="undefined"
	 *    textRollOverColor="0xB333C"
	 *    textSelectedColor="0xB333C"
	 *    verticalGap="-1"
	 *  
	 *    <strong>Events</strong>
	 *    change="<i>No default</i>"
	 *    &gt;
	 *      ...
	 *      <i>child tags</i>
	 *      ...
	 *  &lt;/mx:Accordion&gt;
	 *  </pre>
	 *
	 *  @includeExample examples/AccordionExample.mxml
	 *
	 *  @see mx.containers.accordionClasses.AccordionHeader
	 *
	 *  @tiptext Accordion allows for navigation between different child views
	 *  @helpid 3013
	 */
	public class SuperAccordion extends Container implements IHistoryManagerClient, IFocusManagerComponent
	{
	   // include "../core/Version.as";
	
	    //--------------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  @private
	     *  Base for all header names (_header0 - _headerN).
	     */
	    private static const HEADER_NAME_BASE:String = "_header";
	
	    //--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  Constructor.
	     */
	    public function SuperAccordion()
	    {
	        super();
	
	        headerRenderer = new ClassFactory( SuperAccordionHeader );
	 
	        // Most views can't take focus, but an accordion can.
	        // However, it draws its own focus indicator on the
	        // header for the currently selected child view.
	        // Container() has set tabEnabled false, so we
	        // have to set it back to true.
	        tabEnabled = true;
	
	        // Accordion always clips content, it just handles it by itself
	        super.clipContent = false;
	
	        addEventListener( ChildExistenceChangedEvent.CHILD_ADD, onChildAdd );
	        addEventListener( ChildExistenceChangedEvent.CHILD_REMOVE, onChildRemove );
	
			showInAutomationHierarchy = true;
	    }
	
	    //--------------------------------------------------------------------------
	    //
	    //  Variables
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  @private
	     *  Is the accordian currently sliding between views?
	     */
	    private var bSliding:Boolean = false;
	
	    /**
	     *  @private
	     */
	    private var initialSelectedIndices:Array = [ -1 ];
	
	    /**
	     *  @private
	     *  If true, call HistoryManager.save() when setting currentIndex.
	     */
	    private var bSaveState:Boolean = false;
	
	    /**
	     *  @private
	     */
	    private var bInLoadState:Boolean = false;
	
		/**
		 *  @private
		 */
		private var firstTime:Boolean = true;
		
	    /**
	     *  @private
	     */
	    private var showFocusIndicator:Boolean = false;
	
	    /**
	     *  @private
	     *  Cached tween properties to speed up tweening calculations.
	     */
	    private var tweenViewMetrics:EdgeMetrics;
	    private var tweenContentWidth:Number;
	    private var tweenContentHeight:Number;
	    
	    private var tweenWidthDifferences:Array;
	    private var tweenHeightDifferences:Array;
	    private var tweenWidthStarts:Array;
	    private var tweenHeightStarts:Array;
	    
	    private var tweenOldSelectedIndices:Array;
	    private var tweenNewSelectedIndices:Array;
	    private var tween:Tween;
	
	    /**
	     *  @private
	     *  We'll measure ourselves once and then store the results here
	     *  for the lifetime of the ViewStack.
	     */
	    private var accMinWidth:Number;
	    private var accMinHeight:Number;
	    private var accPreferredWidth:Number;
	    private var accPreferredHeight:Number;
	
	    /**
	     *  @private
	     *  Remember which child has an overlay mask, if any.
	     */
	    private var overlayChildren:Array;
	
	    /**
	     *  @private
	     *  Keep track of the overlay's targetArea
	     */
	    private var overlayTargetArea:RoundedRectangle;
	
	    /**
	     *  @private
	     */
	    private var layoutStyleChanged:Boolean = false;
	
	    /**
	     *  @private
	     */
	    private var currentDissolveEffect:Effect;
	    
	    /**
	     *  @private
	     */
	    private var _closable: Boolean;;
	
	    //--------------------------------------------------------------------------
	    //
	    //  Overridden properties
	    //
	    //--------------------------------------------------------------------------
	
	    //----------------------------------
	    //  autoLayout
	    //----------------------------------
	
	    // Don't allow user to set autoLayout because
	    // there are problems if deferred instantiation
	    // runs at the same time as an effect. (Bug 79174)
	
	    [Inspectable(environment="none")]
	
	    /**
	     *  @private
	     */
	    override public function get autoLayout():Boolean
	    {
	        return true;
	    }
	
	    /**
	     *  @private
	     */
	    override public function set autoLayout(value:Boolean):void
	    {
	    }
	
	    //----------------------------------
	    //  clipContent
	    //----------------------------------
	
	    // We still need to ensure the clip mask is *never* created for an
	    // Accordion.
	
	    [Inspectable(environment="none")]
	
	    /**
	     *  @private
	     */
	    override public function get clipContent():Boolean
	    {
	        return true; // Accordion does clip, it just does it itself
	    }
	
	    /**
	     *  @private
	     */
	    override public function set clipContent(value:Boolean):void
	    {
	    }
	
	    //----------------------------------
	    //  horizontalScrollPolicy
	    //----------------------------------
	
	    [Inspectable(environment="none")]
	
	    /**
	     *  @private
	     */
	    override public function get horizontalScrollPolicy():String
	    {
	        return ScrollPolicy.OFF;
	    }
	
	    /**
	     *  @private
	     */
	    override public function set horizontalScrollPolicy(value:String):void
	    {
	    }
	
	    //----------------------------------
	    //  verticalScrollPolicy
	    //----------------------------------
	
	    [Inspectable(environment="none")]
	
	    /**
	     *  @private
	     */
	    override public function get verticalScrollPolicy():String
	    {
	        return ScrollPolicy.OFF;
	    }
	
	    /**
	     *  @private
	     */
	    override public function set verticalScrollPolicy(value:String):void
	    {
	    }
	
	    //--------------------------------------------------------------------------
	    //
	    // Public properties
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  @private
	     */
	    private var _focusedIndex:int = -1;
	
	    /**
	     *  @private
	     */
	    mx_internal function get focusedIndex():int
	    {
	        return _focusedIndex;
	    }
	
	    //----------------------------------
	    //  contentHeight
	    //----------------------------------
	
	    /**
	     *  The height of the area, in pixels, in which content is displayed.
	     *  You can override this getter if your content
	     *  does not occupy the entire area of the container.
	     */
	    protected function get contentHeight():Number
	    {
	        // Start with the height of the entire accordion.
	        var contentHeight:Number = unscaledHeight;
	
	        // Subtract the heights of the top and bottom borders.
	        var vm:EdgeMetrics = viewMetricsAndPadding;
	        contentHeight -= vm.top + vm.bottom;
	
	        // Subtract the header heights.
	        var verticalGap:Number = getStyle("verticalGap");
	        var n:int = numChildren;
	        for( var i:int = 0; i < n; i++ )
	        {
	            contentHeight -= getHeaderAt(i).height;
	
	            if( i > 0 ) contentHeight -= verticalGap;
	        }
	        
	        return contentHeight;
	    }
	
	    //----------------------------------
	    //  contentWidth
	    //----------------------------------
	
	    /**
	     *  The width of the area, in pixels, in which content is displayed.
	     *  You can override this getter if your content
	     *  does not occupy the entire area of the container.
	     */
	    protected function get contentWidth():Number
	    {
	        // Start with the width of the entire accordion.
	        var contentWidth:Number = unscaledWidth;
	
	        // Subtract the widths of the left and right borders.
	        var vm:EdgeMetrics = viewMetricsAndPadding;
	        contentWidth -= vm.left + vm.right;
	
	        contentWidth -= getStyle("paddingLeft") +
	                        getStyle("paddingRight");
	
	        return contentWidth;
	    }
	
	    //----------------------------------
	    //  headerRenderer
	    //----------------------------------
	
	    /**
	     *  @private
	     *  Storage for the headerRenderer property.
	     */
	    private var _headerRenderer:IFactory;
	
	    [Bindable("headerRendererChanged")]
	
	    /**
	     *  A factory used to create the navigation buttons for each child.
	     *  The default value is a factory which creates a
	     *  <code>mx.containers.accordionClasses.AccordionHeader</code>. The
	     *  created object must be a subclass of Button and implement the
	     *  <code>mx.core.IDataRenderer</code> interface. The <code>data</code>
	     *  property is set to the content associated with the header.
	     *
	     *  @see mx.containers.accordionClasses.AccordionHeader
	     */
	    public function get headerRenderer():IFactory
	    {
	        return _headerRenderer;
	    }
	
	    /**
	     *  @private
	     */
	    public function set headerRenderer(value:IFactory):void
	    {
	        _headerRenderer = value;
	
	        dispatchEvent(new Event("headerRendererChanged"));
	    }
	
	    //----------------------------------
	    //  historyManagementEnabled
	    //----------------------------------
	
	    /**
	     *  @private
	     *  Storage for historyManagementEnabled property.
	     */
	    private var _historyManagementEnabled:Boolean = true;
	
	    /**
	     *  @private
	     */
	    private var historyManagementEnabledChanged:Boolean = false;
	
	    [Inspectable(defaultValue="true")]
	
	    /**
	     *  If set to <code>true</code>, this property enables history management
	     *  within this Accordion container.
	     *  As the user navigates from one child to another,
	     *  the browser remembers which children were visited.
	     *  The user can then click the browser's Back and Forward buttons
	     *  to move through this navigation history.
	     *
	     *  @default true
	     *
	     *  @see mx.managers.HistoryManager
	     */
	    public function get historyManagementEnabled():Boolean
	    {
	        return _historyManagementEnabled;
	    }
	
	    /**
	     *  @private
	     */
	    public function set historyManagementEnabled(value:Boolean):void
	    {
	        if (value != _historyManagementEnabled)
	        {
	            _historyManagementEnabled = value;
	            historyManagementEnabledChanged = true;
	
	            invalidateProperties();
	        }
	    }
	
	    //----------------------------------
	    //  resizeToContent
	    //----------------------------------
	
	    /**
	     *  @private
	     *  Storage for the resizeToContent property.
	     */
	    private var _resizeToContent:Boolean = false;
	
	    [Inspectable(defaultValue="false")]
	
	    /**
	     *  If set to <code>true</code>, this Accordion automatically resizes to
	     *  the size of its current child.
	     * 
	     *  @default false
	     */
	    public function get resizeToContent():Boolean
	    {
	        return _resizeToContent;
	    }
	
	    /**
	     *  @private
	     */
	    public function set resizeToContent(value:Boolean):void
	    {
	        if (value != _resizeToContent)
	        {
	            _resizeToContent = value;
	
	            if (value)
	                invalidateSize();
	        }
	    }
	
		
		public function get closable():Boolean
	    {
	    	return _closable;
	    }
	    
	    public function set closable( value:Boolean ):void
	    {
	    	if( _closable == value ) return;
	    	
	    	_closable = value;
	    	if( !proposedSelectedIndices ) proposedSelectedIndices = _selectedIndices.concat();
	    	invalidateProperties();
	    }
	    
	    
	    //----------------------------------
	    //  selectedChild
	    //----------------------------------
	
	    [Bindable("valueCommit")]
	
	    /**
	     *  A reference to the currently visible child container.
	     *  The default value is a reference to the first child.
	     *  If there are no children, this property is <code>null</code>.
	     *
	     *  <p><b>Note:</b> You can only set this property in an ActionScript statement, 
	     *  not in MXML.</p>
	     *
	     *  @tiptext Specifies the child view that is currently displayed
	     *  @helpid 3401
	     */
	    public function get selectedChildren():Array
	    {
	        var indexes:Array = ( proposedSelectedIndices ) ? proposedSelectedIndices : _selectedIndices;
			if( !indexes.length ) return null;
			
			var sc:Array = new Array();
			
			var numSelectedIndices:int = indexes.length;
			for( var i:int = 0; i < numSelectedIndices; i++ )
			{
				if( indexes[ i ] != -1 ) sc.push( Container( getChildAt( indexes[ i ] ) ) );
			}
			
	        return sc;
	    }
	
	    /**
	     *  @private
	     */
	    public function set selectedChildren( value:Array ):void
	    {
	    	// Bail if new indexes don't contain more than one index.
	        if( !value.length ) return;
	      	        
	        var newIndices:Array = new Array();
	        
	        var child:Container;
	        var numItems:int = value.length;
	        for( var i:int = 0; i < numItems; i++ )
	        {
	        	child = Container( value[ i ] );
	        	if( contains( child ) ) newIndices.push( getChildIndex( child ) );
	        }
	        
	        selectedIndices = newIndices;
	    }
	
	
		public function selectChild( value:Container ):void
		{
			if( !contains( value ) ) return;
			
			selectIndex( getChildIndex( value ) );
		}
		
		public function deselectChild( value:Container ):void
		{
			if( !contains( value ) ) return;
			
			deselectIndex( getChildIndex( value ) );
		}
		
		
	    //----------------------------------
	    //  selectedIndex
	    //----------------------------------
	
	    /**
	     *  @private
	     *  Storage for the selectedIndex and selectedChild properties.
	     */
	    private var _selectedIndices:Array;
	
	    /**
	     *  @private
	     */
	    private var proposedSelectedIndices:Array;
	
		public function isSelectedIndex( value:int ):Boolean
		{
			return arrayContains( _selectedIndices, value );
		}
		public function isSelectedChild( value:Container ):Boolean
		{
			if( !contains( value ) ) return false
			return arrayContains( _selectedIndices, getChildIndex( value ) );
		}
		
		
		public function selectIndex( value:int ):void
		{
			// If the value i out of range then bail.
			if( value < 0 || value > numChildren - 1 ) return;
			
			// If the index is already selected bail.
			if( proposedSelectedIndices )
			{
				if( arrayContains( proposedSelectedIndices, value ) ) return;
			}
			else if( arrayContains( _selectedIndices, value ) )
			{
				return;
			}

			proposedSelectedIndices = ( _selectedIndices ) ? _selectedIndices.concat() : new Array();
			proposedSelectedIndices.push( value );
			proposedSelectedIndices.sort( Array.NUMERIC );
			
			if( _closable )
			{
				if( proposedSelectedIndices.length > 1 )
				{
					var numProposedIndices:int = proposedSelectedIndices.length;
					for( var i:int = 0; i < numProposedIndices; i++ )
					{
						if( proposedSelectedIndices[ i ] == -1 )
						{
							proposedSelectedIndices.splice( i, 1 );
						}
					}
				}
			}
			
			invalidateProperties();
	
	        // Set a flag which will cause the History Manager to save state
	        // the next time measure() is called.
	        if( historyManagementEnabled && _selectedIndices && !bInLoadState ) bSaveState = true;
	        
	        dispatchEvent( new FlexEvent( FlexEvent.VALUE_COMMIT ) );
		}
		
		
		public function deselectIndex( value:int ):void
		{
			if( _closable )
			{
				if( value < 0 || value > numChildren - 1 ) return;
				if( _selectedIndices.length == 1 )
				{
					proposedSelectedIndices = ( _selectedIndices ) ? _selectedIndices.concat() : new Array();
					proposedSelectedIndices.push( -1 );
					proposedSelectedIndices.sort( Array.NUMERIC );
				}
			}
			else
			{
				// If the value is out of range then bail.
				if( value < 0 || value > numChildren - 1 || _selectedIndices.length == 1 ) return;
			}
			
			// If the index isn't already selected bail.
			if( proposedSelectedIndices )
			{
				if( !arrayContains( proposedSelectedIndices, value ) ) return;
			}
			else if( !arrayContains( _selectedIndices, value ) )
			{
				return;
			}
			
			// IF there are no proposed indices use selected indices
			if( !proposedSelectedIndices ) proposedSelectedIndices = _selectedIndices.concat();
			
			//var valueChanged:Boolean = false;
			var numItems:int = proposedSelectedIndices.length;
			for( var i:int = 0; i < numItems; i++ )
			{
				if( proposedSelectedIndices[ i ] == value )
				{
					proposedSelectedIndices.splice( i, 1 );
					//valueChanged = true;
					break;
				}
			}
			
			//if( !valueChanged ) return;

			invalidateProperties();

	        // Set a flag which will cause the History Manager to save state
	        // the next time measure() is called.
	        if( historyManagementEnabled && _selectedIndices && !bInLoadState ) bSaveState = true;
	        
	        dispatchEvent( new FlexEvent( FlexEvent.VALUE_COMMIT ) );
		}
		
	    [Bindable("valueCommit")]
	    [Inspectable(category="General", defaultValue="0")]
	
	    /**
	     *  The zero-based index of the currently visible child container.
	     *  Child indexes are in the range 0, 1, 2, ... , n - 1, where n is the number
	     *  of children.
	     *  The default value is 0, corresponding to the first child.
	     *  If there are no children, this property is <code>-1</code>.
	     *
	     *  @default 0
	     *
	     *  @tiptext Specifies the index of the child view that is currently displayed
	     *  @helpid 3402
	     */
	    public function get selectedIndices():Array
	    {
	        if( proposedSelectedIndices ) return proposedSelectedIndices;
	
	        return _selectedIndices;
	    }
	
	    /**
	     *  @private
	     */
	    public function set selectedIndices( value:Array ):void
	    {
	        // Bail if new indexes don't contain more than one index.
	        if( !value.length ) return;
			
			// Bail if the indexes aren't changing.
			
			value = arrayStripDuplicates( value );
			value.sort( Array.NUMERIC );
	        
	        var numIndices:int = value.length;
	        
	        if( _selectedIndices )
	        {
	        	if( _selectedIndices.length == numIndices )
	        	{
			        var valueChanged:Boolean = false;
			        var i:int
			       
					for( i = 0; i < numIndices; i++ )
					{
						if( value[ i ] != _selectedIndices[ i ] )
						{
							valueChanged = true;
							break;
						}
					}
					
			        if( !valueChanged ) return;
			    }
		    }
		
			var newIndices:Array = new Array();
			
			var index:int;
			for( i = 0; i < numIndices; i++ )
			{
				index = int( value[ i ] );
	        	if( index >= 0 || index < numChildren ) newIndices.push( index );
			}
			
			
			if( !newIndices.length ) return;
			
	        // Propose the specified value as the new value for selectedIndex.
	        // It gets applied later when commitProperties() calls commitSelectedIndex().
	        // The proposed value can be "out of range", because the children
	        // may not have been created yet, so the range check is handled
	        // in commitSelectedIndex(), not here. Other calls to this setter
	        // can change the proposed index before it is committed. Also,
	        // childAddHandler() proposes a value of 0 when it creates the first
	        // child, if no value has yet been proposed.
	        proposedSelectedIndices = newIndices;
	        invalidateProperties();
	
	        // Set a flag which will cause the History Manager to save state
	        // the next time measure() is called.
	        if (historyManagementEnabled && _selectedIndices.length && !bInLoadState) bSaveState = true;
		
	        dispatchEvent(new FlexEvent( FlexEvent.VALUE_COMMIT ) );
	    }
	
	    //--------------------------------------------------------------------------
	    //
	    //  Overridden methods
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  @private
	     */
	    override public function createComponentsFromDescriptors(
	                                    recurse:Boolean = true):void
	    {
	        // The easiest way to handle the ContainerCreationPolicy.ALL policy is to let
	        // Container's implementation of createComponents handle it.
	        if (actualCreationPolicy == ContainerCreationPolicy.ALL)
	        {
	            super.createComponentsFromDescriptors();
	            return;
	        }
	
	        // If the policy is ContainerCreationPolicy.AUTO, Accordion instantiates its children
	        // immediately, but not any grandchildren. The children of
	        // the selected child will get created in instantiateSelectedChild().
	        // Why not create the grandchildren of the selected child by calling
	        //    createComponentFromDescriptor(childDescriptors[i], i == selectedIndex);
	        // in the loop below? Because one of this Accordion's childDescriptors
	        // may be for a Repeater, in which case the following loop over the
	        // childDescriptors is not the same as a loop over the children.
	        // In particular, selectedIndex is supposed to specify the nth
	        // child, not the nth childDescriptor, and the 2nd parameter of
	        // createComponentFromDescriptor() should make the recursion happen
	        // on the nth child, not the nth childDescriptor.
	        var numChildrenBefore:int = numChildren;
	
	        if (childDescriptors)
	        {
	            var n:int = childDescriptors.length;
	            for (var i:int = 0; i < n; i++)
	            {
	                var descriptor:ComponentDescriptor =
	                    ComponentDescriptor(childDescriptors[i]);
	
	                createComponentFromDescriptor(descriptor, false);
	            }
	        }
	
	        numChildrenCreated = numChildren - numChildrenBefore;
	
	        processedDescriptors = true;
	    }
	
	    /**
	     *  @private
	     */
	    override public function setChildIndex(child:DisplayObject,
	                                           newIndex:int):void
	    {
	        var oldIndex:int = getChildIndex(child);
	
	        // Check boundary conditions first
	        if ( oldIndex == -1 || newIndex < 0 ) return;
	
	        var nChildren:int = numChildren;
	        if ( newIndex >= nChildren ) newIndex = nChildren - 1;
	
	        // Next, check for no move
	        if( newIndex == oldIndex )  return;
	
			var i:int;
			var numSelectedIndices:int = selectedIndices.length;
			
	        // De-select the old selected index header
        	for( i = 0; i < numSelectedIndices; i++ )
        	{
        		var oldSelectedHeader:SuperAccordionHeader = getHeaderAt( selectedIndices[ i ] );
		        if (oldSelectedHeader)
		        {
		            oldSelectedHeader.selected = false;
		            drawHeaderFocus(_focusedIndex, false);
		        }
        	}
	        
	
	        // Adjust the depths and _childN references of the affected children.
	        super.setChildIndex( child, newIndex );
	
	        // Shuffle the headers
	        shuffleHeaders( oldIndex, newIndex );
	
	        // Select the new selected index header
        	for( i = 0; i < numSelectedIndices; i++ )
        	{
		        var newSelectedHeader:SuperAccordionHeader = getHeaderAt( selectedIndices[ i ] );
		        if( newSelectedHeader )
		        {
		        	//tink
		           // newSelectedHeader.selected = true;
		            drawHeaderFocus(_focusedIndex, showFocusIndicator);
		        }
			}
	
	        // Make sure the new selected child is instantiated
	        instantiateSelectedChildren();
	    }
	
	    /**
	     *  @private
	     */
	    private function shuffleHeaders(oldIndex:int, newIndex:int):void
	    {
	        var i:int;
	
	        // Adjust the _headerN references of the affected headers.
	        // Note: Algorithm is the same as Container.setChildIndex().
	        
	        var header:SuperAccordionHeader = getHeaderAt( oldIndex );
	        if (newIndex < oldIndex)
	        {
	            for (i = oldIndex; i > newIndex; i--)
	            {
	                getHeaderAt(i - 1).name = HEADER_NAME_BASE + i;
	            }
	        }
	        else
	        {
	            for (i = oldIndex; i < newIndex; i++)
	            {
	                getHeaderAt(i + 1).name = HEADER_NAME_BASE + i;
	            }
	        }
	        
	        header.name = HEADER_NAME_BASE + newIndex;
	    }
	
	    /**
	     *  @private
	     */
	    override protected function commitProperties():void
	    {
	        super.commitProperties();
	
	        if( historyManagementEnabledChanged )
	        {
	            if( historyManagementEnabled )
	            {
	                HistoryManager.register( this );
	            }
	            else
	            {
	                HistoryManager.unregister( this );
	            }
	
	            historyManagementEnabledChanged = false;
	        }
	
	        commitSelectedIndices();
	       
			if( firstTime )
			{
				firstTime = false;
				
				// Add "added" and "removed" listeners to the system manager so we can
				// register/un-register from the history manager when this component is
				// added or removed from the display list.
				systemManager.addEventListener( Event.ADDED, systemManager_addedHandler, false, 0, true );
				systemManager.addEventListener( Event.REMOVED, systemManager_removedHandler, false, 0, true );
			}
	    }
	
	    /**
	     *  @private
	     */
	    override protected function measure():void
	    {
	        super.measure();
	
	        var minWidth:Number = 0;
	        var minHeight:Number = 0;
	        var preferredWidth:Number = 0;
	        var preferredHeight:Number = 0;
	
	        var paddingLeft:Number = getStyle("paddingLeft");
	        var paddingRight:Number = getStyle("paddingRight");
	        var headerHeight:Number = getHeaderHeight();
	
	        // Only measure once, unless resizeToContent='true'
	        // Thereafter, we'll just use cached values.
	        // (However, if a layout style like headerHeight changes,
	        // we have to re-measure.)
	        //
	        // We need to copy the cached values into the measured fields
	        // again to handle the case where scaleX or scaleY is not 1.0.
	        // When the Accordion is zoomed, code in UIComponent.measureSizes
	        // scales the measuredWidth/Height values every time that
	        // measureSizes is called.  (bug 100749)
	        if (accPreferredWidth && !_resizeToContent && !layoutStyleChanged)
	        {
	            measuredMinWidth = accMinWidth;
	            measuredMinHeight = accMinHeight;
	            measuredWidth = accPreferredWidth;
	            measuredHeight = accPreferredHeight;
	            return;
	        }
	
	        layoutStyleChanged = false;
	
			var i:int
			
	        for( i = 0; i < numChildren; i++)
	        {
	            var button:SuperAccordionHeader = getHeaderAt( i );
	            var child:IUIComponent = IUIComponent( getChildAt( i ) );
	
	            minWidth = Math.max(minWidth, button.minWidth);
	            minHeight += headerHeight;
	            preferredWidth = Math.max(preferredWidth, minWidth);
	            preferredHeight += headerHeight;
	
	            // The headers preferredWidth is messing up the accordion measurement. This may not
	            // be needed anyway because we're still using the headers minWidth to determine our overall
	            // minWidth.
	
	           /** if (i == selectedIndex)
	            {
	                preferredWidth = Math.max(preferredWidth, child.getExplicitOrMeasuredWidth());
	                preferredHeight += child.getExplicitOrMeasuredHeight();
	
	                minWidth = Math.max(minWidth, child.minWidth);
	                minHeight += child.minHeight;
	            }**/
	
	        }
	
	        // Add space for borders and margins
	        var vm:EdgeMetrics = viewMetricsAndPadding;
	        var widthPadding:Number = vm.left + vm.right;
	        var heightPadding:Number = vm.top + vm.bottom;
	
	        // Need to adjust the widthPadding if paddingLeft and paddingRight are negative numbers
	        // (see explanation in updateDisplayList())
	        if (paddingLeft < 0)
	            widthPadding -= paddingLeft;
	
	        if (paddingRight < 0)
	            widthPadding -= paddingRight;
	
	        minWidth += widthPadding;
	        preferredWidth += widthPadding;
	        minHeight += heightPadding;
	        preferredHeight += heightPadding;
	
	        measuredMinWidth = minWidth;
	        measuredMinHeight = minHeight;
	        measuredWidth = preferredWidth;
	        measuredHeight = preferredHeight;
	
	        // If we're called before instantiateSelectedChild, then bail.
	        // We'll be called again later (instantiateSelectedChild calls
	        // invalidateSize), and we don't want to load values into the
	        // cache until we're fully initialized.  (bug 102639)
	        // This check was moved from the beginning of this function to
	        // here to fix bugs 103665/104213.
	        var selectedChild:Container;
	        var numSelectedIndices:int = selectedIndices.length;
        	for( i = 0; i < numSelectedIndices; i++ )
        	{
        		selectedChild = Container( getChildAt( selectedIndices[ i ] ) );
        		if( selectedChild && selectedChild.numChildrenCreated == -1 ) return;
        	}

	        // Don't remember sizes if we don't have any children
	        if( numChildren == 0 ) return;
	
	        accMinWidth = minWidth;
	        accMinHeight = minHeight;
	        accPreferredWidth = preferredWidth;
	        accPreferredHeight = preferredHeight;
	    }
	
	    /**
	     *  @private
	     *  Arranges the layout of the accordion contents.
	     *
	     *  @tiptext Arranges the layout of the Accordion's contents
	     *  @helpid 3017
	     */
	    override protected function updateDisplayList(unscaledWidth:Number,
	                                                  unscaledHeight:Number):void
	    {
	        super.updateDisplayList(unscaledWidth, unscaledHeight);

	        // Don't do layout if we're tweening because the tweening
	        // code is handling it.
	        if (tween)
	            return;
	
	        // Measure the border.
	        var bm:EdgeMetrics = borderMetrics;
	        var paddingLeft:Number = getStyle("paddingLeft");
	        var paddingRight:Number = getStyle("paddingRight");
	        var paddingTop:Number = getStyle("paddingTop");
	        var verticalGap:Number = getStyle("verticalGap");
	
	        // Determine the width and height of the content area.
	        var localContentWidth:Number = calcContentWidth();
	        var localContentHeight:Number = calcContentHeight( _selectedIndices.length );
	
	        // Arrange the headers, the content clips,
	        // based on selectedIndex.
	        var x:Number = bm.left + paddingLeft;
	        
	        var n:int;
	        var i:int;
	        var y:Number;
	        if( _closable )
	        {
	        	var verticalAlignOffset:Number = getStyle( "verticalAlignOffset" )
	        	
		        var topAlign:Number = bm.top + paddingTop;
		        var bottomAlign:Number = unscaledHeight;
	        	n = numChildren;
	        	for ( i = 0; i < n; i++)
	        	{
	        		header = getHeaderAt( i );
	        		bottomAlign -= header.height;
	        	}
	        	
	        	n = _selectedIndices.length;
	        	for ( i = 0; i < n; i++)
	        	{
	        		if( _selectedIndices[ i ] != -1 ) bottomAlign -= localContentHeight;
	        	}
        	
	        	switch( getStyle( "verticalAlign" ) )
	        	{
	        		case "middle" :
	        		{
	        			var contentHeight:Number = 0;
			        	n = numChildren;
			        	for ( i = 0; i < n; i++)
			        	{
			        		header = getHeaderAt( i );
			        		contentHeight += header.height;
			        	}
			        	
			        	n = _selectedIndices.length;
			        	for ( i = 0; i < n; i++)
			        	{
			        		if( _selectedIndices[ i ] != -1 ) contentHeight += localContentHeight;
			        	}
			        	
			        	y = Math.round( ( unscaledHeight - contentHeight ) / 2 );
			        	y += verticalAlignOffset;
	        			break;
	        		}
	        		case "bottom" :
	        		{
	        			y = bottomAlign + verticalAlignOffset;
	        			break;
	        		}
	        		default :
	        		{
	        			y = topAlign + verticalAlignOffset;
	        		}
	        				
	        	}
	        	
	        	if( y < topAlign ) y = topAlign;
			    if( y > bottomAlign ) y = bottomAlign;
	        }
	        else
	        {
	        	y = bm.top + paddingTop;	
	        }
	
	        // Adjustments. These are required since the default halo
	        // appearance has verticalGap and all margins set to -1
	        // so the edges of the headers overlap each other and the
	        // border of the accordion. These overlaps cause problems with
	        // the content area clipping, so we adjust for them here.
	        var contentX:Number = x;
	        var adjContentWidth:Number = localContentWidth;
	        var headerHeight:Number = getHeaderHeight();
	
	        if (paddingLeft < 0)
	        {
	            contentX -= paddingLeft;
	            adjContentWidth += paddingLeft;
	        }
	
	        if (paddingRight < 0)
	            adjContentWidth += paddingRight;
			
	        n = numChildren;
	        for ( i = 0; i < n; i++)
	        {
	            var header:SuperAccordionHeader = getHeaderAt( i );
	            var content:IUIComponent = IUIComponent( getChildAt( i ) );
	
	           	header.move( x, y );
	            header.setActualSize( localContentWidth, headerHeight );
	            y += headerHeight;
				
				var contentW:Number = adjContentWidth;
				if ( !isNaN( content.percentWidth ) )
                {
                    if( contentW > content.maxWidth ) contentW = content.maxWidth;
                }
                else
                {
                    if( contentW > content.getExplicitOrMeasuredWidth() ) contentW = content.getExplicitOrMeasuredWidth();
                }
				
	            if( arrayContains( selectedIndices, i ) )
	            {
	                content.move( contentX, y );
	                content.visible = true;
	
	                var contentH:Number = localContentHeight;
	
	                if( !isNaN( content.percentHeight ) )
	                {
	                    if( contentH > content.maxHeight ) contentH = content.maxHeight;
	                }
	                else
	                {
	                   	if( contentH > content.getExplicitOrMeasuredHeight() ) contentH = content.getExplicitOrMeasuredHeight();
	                }

	                if( content.width != contentW || content.height != contentH ) content.setActualSize( contentW, contentH );

	                y += localContentHeight;
	            }
	            else
	            {
	            	content.setActualSize( contentW, 0 );
	               	content.visible = false;
	            }
	
	            y += verticalGap;
	        }
	
	        // Make sure blocker is in front
	        if( blocker ) rawChildren.setChildIndex( blocker, numChildren - 1 );
	
	        // refresh the focus rect, the dimensions might have changed.
	        drawHeaderFocus(_focusedIndex, showFocusIndicator);
	    }
	
	    /**
	     *  @private
	     */
	    override mx_internal function setActualCreationPolicies(policy:String):void
	    {
	        super.setActualCreationPolicies(policy);
	
	        // If the creation policy is switched to ContainerCreationPolicy.ALL and our createComponents
	        // function has already been called (we've created our children but not
	        // all our grandchildren), then create all our grandchildren now (bug 99160).
	        if (policy == ContainerCreationPolicy.ALL && numChildren > 0)
	        {
	            var n:int = numChildren;
	            for (var i:int = 0; i < n; i++)
	            {
	                Container(getChildAt(i)).createComponentsFromDescriptors();
	            }
	        }
	    }
	
	    /**
	     *  @private
	     */
	    override protected function focusInHandler(event:FocusEvent):void
	    {
	        super.focusInHandler(event);
	        
	        showFocusIndicator = focusManager.showFocusIndicator;
	        // When the accordion has focus, the Focus Manager
	        // should not treat the Enter key as a click on
	        // the default pushbutton.
	        if (event.target == this)
	            focusManager.defaultButtonEnabled = false;
	    }
	
	    /**
	     *  @private
	     */
	    override protected function focusOutHandler(event:FocusEvent):void
	    {
	        super.focusOutHandler(event);
	        
	        showFocusIndicator = false;
	        if (focusManager && event.target == this)
	            focusManager.defaultButtonEnabled = true;
	    }
	
	    /**
	     *  @private
	     */
	    override public function drawFocus(isFocused:Boolean):void
	    {
	        drawHeaderFocus(_focusedIndex, isFocused);
	    }
	
	    /**
	     *  @private
	     */
	    override public function styleChanged(styleProp:String):void
	    {
	        super.styleChanged(styleProp);
	
	        if (!styleProp ||
	            styleProp == "headerStyleName" ||
	            styleProp == "styleName")
	        {
	            var headerStyleName:Object = getStyle("headerStyleName");
	            if (headerStyleName)
	            {
	                var headerStyleDecl:CSSStyleDeclaration = 
						StyleManager.getStyleManager( moduleFactory ).getStyleDeclaration("." + headerStyleName);
	                if (headerStyleDecl)
	                {
	                    // Need to reset the header style declaration and 
	                    // regenerate their style cache
	                    for (var i:int = 0; i < numChildren; i++)
	                    {
	                        var header:SuperAccordionHeader = getHeaderAt(i);
	                        if( header )
	                        {
	                            header.styleDeclaration = headerStyleDecl;
	                            header.regenerateStyleCache(true);
	                            header.styleChanged(null);
	                        }
	                    }
	                }
	            }
	        }
	        else if (StyleManager.getStyleManager( moduleFactory ).isSizeInvalidatingStyle(styleProp))
	        {
	            layoutStyleChanged = true;
	        }
	    }
	
	    /**
	     *  @private
	     *  When asked to create an overlay mask, create it on the selected child
	     *  instead.  That way, the chrome around the edge of the Accordion (e.g. the
	     *  header buttons) is not occluded by the overlay mask (bug 99029).
	     */
	    override mx_internal function addOverlay(color:uint, targetArea:RoundedRectangle = null):void
	    {
	        // As we're switching the currently-selected child, don't
	        // allow two children to both have an overlay at the same time.
	        // This is done because it makes accounting a headache.  If there's
	        // a legitimate reason why two children both need overlays, this
	        // restriction could be relaxed.
	        if( overlayChildren.length ) removeOverlays();
	
			if( !selectedChildren.length ) return;
	        // Remember which child has an overlay, so that we don't inadvertently
	        // create an overlay on one child and later try to remove the overlay
	        // of another child. (bug 100731)
	        overlayChildren = new Array();
	        var selectedChild:Container;
	        var init:Boolean = true;
	        var numSelectedChildren:int = selectedChildren.length;
	        for( var i:int = 0; i < numSelectedChildren; i++ )
	        {
	        	selectedChild = Container( selectedChildren[ i ] );
	        	overlayChildren.push( selectedChild );
	        	
	        	if(selectedChild && selectedChild.numChildrenCreated == -1) // No children have been created
		        {
		            // Wait for the childrenCreated event before creating the overlay
		            selectedChild.addEventListener( FlexEvent.INITIALIZE, initializeHandler );
		            init = false;
		        }
	        }	        
	
			effectOverlayColor = color;
	        overlayTargetArea = targetArea;
	
	        if( init ) initializeHandler( null );
	    }
	
	    /**
	     *  @private
	     *  Called when we are running a Dissolve effect
	     *  and the initialize event has been dispatched
	     *  or the children already exist
	     */
	    private function initializeHandler(event:FlexEvent):void
	    {
	       /** UIComponent(overlayChild).addOverlay(overlayColor, overlayTargetArea);**/
	       UIComponent( event.currentTarget ).addOverlay( effectOverlayColor, overlayTargetArea );
	    }
	
	    /**
	     *  @private
	     *  Handle key down events
	     */
	    private function removeOverlays():void
	    {
	    	var numOverlayChildren:int = overlayChildren.length;
	        for( var i:int = 0; i < numOverlayChildren; i++ )
	        {
	            UIComponent( overlayChildren[ i ] ).removeOverlay();
	        }
	        
	        overlayChildren = null;
	    }
	
	    // -------------------------------------------------------------------------
	    // StateInterface
	    // -------------------------------------------------------------------------
	
	    /**
	     *  @copy mx.managers.IHistoryManagerClient#saveState()
	     */
	    public function saveState():Object
	    {
	        var indexes:Array = ( !_selectedIndices.length ) ? null : _selectedIndices;
	        return { selectedIndices: indexes };
	    }
	
	    /**
	     *  @copy mx.managers.IHistoryManagerClient#loadState()
	     */
	    public function loadState(state:Object):void
	    {
	        var newIndices:Array = state ? state.selectedIndices.toString().split( "%2C" ) : null;
	
	        if( !newIndices ) newIndices = initialSelectedIndices;
	
	        //if( newIndex == -1 ) newIndex = 0;
			var valueChanged:Boolean = ( newIndices.length != _selectedIndices.length );
			
			if( !valueChanged )
			{
				newIndices.sort( Array.NUMERIC );
		        var numIndices:int = newIndices.length;
				for( var i:int = 0; i < numIndices; i++ )
				{
					if( newIndices[ i ] != _selectedIndices[ i ] )
					{
						valueChanged = true;
						break;
					}
				}
			}

	        if( valueChanged )
	        {
	            // When loading a new state, we don't want to
	            // save our current state in the history stack.
	            bInLoadState = true;
	            selectedIndices = newIndices;
	            bInLoadState = false;
	        }
	    }
	
	    //--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  Returns a reference to the navigator button for a child container.
	     *
	     *  @param index Zero-based index of the child.
	     *
	     *  @return Button object representing the navigator button.
	     */
	    public function getHeaderAt(index:int):SuperAccordionHeader
	    {
	        return SuperAccordionHeader( rawChildren.getChildByName( HEADER_NAME_BASE + index ) );
	    }
	
	    /**
	     *  @private
	     *  Returns the height of the header control. All header controls are the same
	     *  height.
	     */
	    private function getHeaderHeight():Number
	    {
	        var headerHeight:Number = getStyle("headerHeight");
	        
	        if (isNaN(headerHeight))
	        {
	            headerHeight = 0;
	            
	            if (numChildren > 0)
	                headerHeight = getHeaderAt(0).measuredHeight;
	        }
	        
	        return headerHeight;
	    }
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  @private
	     *  Utility method to create the segment header
	     */
	    private function createHeader(content:DisplayObject, index:int):void
	    {
	    	var i:int;
	    	
	        // Before creating the header, un-select the currently selected
	        // header. We will be selecting the correct header below.
	        var header:SuperAccordionHeader;
	        if( selectedIndices )
	        {
		        var numSelectedIndices:int = selectedIndices.length;
		        for( i = 0; i < numSelectedIndices; i++ )
		        {
		            header = getHeaderAt( selectedIndices[ i ] );
		            if( header ) header.selected = false;
		        }
			}
	
	        // Create the header.
	        // Notes:
	        // 1) An accordion maintains a reference to
	        // the header for its Nth child as _headerN. These references are
	        // juggled when children and their headers are re-indexed or
	        // removed, to ensure that _headerN is always a reference the
	        // header for the Nth child.
	        // 2) Always create the header with the index of the last item.
	        // If needed, the headers will be shuffled below.
	        header = SuperAccordionHeader( headerRenderer.newInstance() );
	        header.name = HEADER_NAME_BASE + ( numChildren - 1 );
	        
	        var headerStyleName:String = getStyle("headerStyleName");
	        if (headerStyleName)
	        {
	            var headerStyleDecl:CSSStyleDeclaration = StyleManager.getStyleManager( moduleFactory ).
	                        getStyleDeclaration("." + headerStyleName);
	                        
	            if (headerStyleDecl)
	                header.styleDeclaration = headerStyleDecl;
	        }
	
	        header.addEventListener( MouseEvent.CLICK, headerClickHandler );
	
			IDataRenderer( header ).data = content;
	
	        if( content is Container )
	        {
	            var contentContainer:Container = Container( content );
	
	            header.label = contentContainer.label;
	            if( contentContainer.icon ) header.setStyle( "icon", contentContainer.icon );
	
	            // If the child has a toolTip, transfer it to the header.
	            var toolTip:String = contentContainer.toolTip;
	            if( toolTip && toolTip != "" )
	            {
	                header.toolTip = toolTip;
	                contentContainer.toolTip = null;
	            }
	        }
	
	        rawChildren.addChild( header );

	        // If the newly added child isn't at the end of our child list, shuffle
	        // the headers accordingly.
	        if( index != numChildren - 1 ) shuffleHeaders(numChildren - 1, index);
	
	        // Make sure the correct headers are selected
	        if( selectedIndices )
	        {
		        for( i = 0; i < numSelectedIndices; i++ )
		        {
		        	header = getHeaderAt( selectedIndices[ i ] );
		        	//header.selected = true;
		        }
			}
	            
	    }
	
	    /**
	     *  @private
	     */
	    private function calcContentWidth():Number
	    {
	        // Start with the width of the entire accordion.
	        var contentWidth:Number = unscaledWidth;
	
	        // Subtract the widths of the left and right borders.
	        var vm:EdgeMetrics = viewMetricsAndPadding;
	        contentWidth -= vm.left + vm.right;
	
	        return contentWidth;
	    }
	
	    /**
	     *  @private
	     */
	    private function calcContentHeight( numSelectedIndices:int ):Number
	    {
	        // Start with the height of the entire accordion.
	        var contentHeight:Number = unscaledHeight;
	
	        // Subtract the heights of the top and bottom borders.
	        var vm:EdgeMetrics = viewMetricsAndPadding;
	        contentHeight -= vm.top + vm.bottom;
	
	        // Subtract the header heights.
	        var verticalGap:Number = getStyle( "verticalGap" );
	        var headerHeight:Number = getHeaderHeight();
	
	        var n:int = numChildren;
	        for (var i:int = 0; i < n; i++)
	        {
	            contentHeight -= headerHeight;
	
	            if( i > 0 ) contentHeight -= verticalGap;
	        }
	
	        return ( numSelectedIndices ) ? contentHeight / numSelectedIndices : contentHeight;
	    }
	
	    /**
	     *  @private
	     */
	    private function drawHeaderFocus(headerIndex:int, isFocused:Boolean):void
	    {
	        if (headerIndex != -1)
	            getHeaderAt(headerIndex).drawFocus(isFocused);
	    }
	
	    /**
	     *  @private
	     */
	    private function headerClickHandler( event:Event ):void
	    {
	        var header:SuperAccordionHeader = SuperAccordionHeader( event.currentTarget );
	        var prevIndices:Array = ( proposedSelectedIndices ) ? proposedSelectedIndices : selectedIndices;
	        
	        var selectedChildIndex:int = getChildIndex( Container( IDataRenderer( header ).data ) );
	       
			var wasSelected:Boolean = false;
	        var numPreviousIndices:int = prevIndices.length;
	        for( var i:int = 0; i < numPreviousIndices; i++ )
	        {
	        	// If this index was previously selected
	        	if( prevIndices[ i ] == selectedChildIndex )
	        	{
	        		deselectIndex( selectedChildIndex );
	        		wasSelected = true;
	        		break;
	        	}
	        }
	        
	        // If this index wasn't previously selected
	        if( !wasSelected ) selectIndex( selectedChildIndex );

			dispatchChangeEvent( prevIndices, selectedIndices, event );
	    }
	
	    /**
	     *  @private
	     */
	    private function commitSelectedIndices():void
	    {
	        if( !proposedSelectedIndices ) return;

	        // The selectedIndex must be undefined if there are no children,
	        // even if a selectedIndex has been proposed.
	        if( numChildren == 0 )
	        {
	            _selectedIndices = null;
	            return;
	        }
	
			
			var i:int;
			var numNewIndices:int;
			var newIndices:Array = arrayStripDuplicates( proposedSelectedIndices );
			// Strip invalid indices
			newIndices = arrayStripBoundaries( newIndices );
			newIndices.sort( Array.NUMERIC );
			// Make sure we have at least one valid index
			if( !newIndices.length ) newIndices.push( ( closable ) ? -1 : 0 );
			
	        proposedSelectedIndices = null;
			
			if( _closable )
			{
		        
		 	}
		 	else
		 	{
		 		
		        if( newIndices[ 0 ] < 0 ) newIndices[ 0 ] = 0;
		 	}
		 	
	        if( newIndices[ newIndices.length - 1 ] > numChildren - 1 ) newIndices[ newIndices.length - 1 ] = numChildren - 1;
	
	        // Store the previous indices
	        var prevIndices:Array = ( _selectedIndices ) ? _selectedIndices : new Array();
			
			var oldIndices:Array;
			var numSelectedIndices:int 
			var n:int;
			var matchFound:Boolean;
			var selectedIndex:int;
			if( _closable )
			{
		        oldIndices = new Array();
				numSelectedIndices = ( _selectedIndices ) ? _selectedIndices.length : 0;
				numNewIndices = newIndices.length;
				for( i = 0; i < numSelectedIndices; i++ )
				{
					matchFound = false;
					selectedIndex = int( _selectedIndices[ i ] );
					for( n = 0; n < numNewIndices; n++ )
					{
						if( int( newIndices[ n ] ) == selectedIndex )
						{
							matchFound = true;
							break;
						}
					}
					
					if( !matchFound )
					{
						if( selectedIndex != -1 )
						{
							oldIndices.push( selectedIndex );
							getHeaderAt( selectedIndex ).selected = false;
						}
					}
				}
		 	}
		 	else
		 	{
				oldIndices = new Array();
				numSelectedIndices = ( _selectedIndices ) ? _selectedIndices.length : 0;
				numNewIndices = newIndices.length;
				if( numNewIndices < numSelectedIndices )
				{
					for( i = 0; i < numSelectedIndices; i++ )
					{
						matchFound = false;
						selectedIndex = int( _selectedIndices[ i ] );
						for( n = 0; n < numNewIndices; n++ )
						{
							if( int( newIndices[ n ] ) == selectedIndex )
							{
								matchFound = true;
								break;
							}
						}
						
						if( !matchFound )
						{
							oldIndices.push( selectedIndex );
							getHeaderAt( selectedIndex ).selected = false;
						}
					}
				}
		 	}
			
			
	        // If we are currently playing a Dissolve effect, end it and restart it again
	        currentDissolveEffect = null;
	
	        if( isEffectStarted )
	        {
	            var dissolveInstanceClass:Class = Class( systemManager.getDefinitionByName( "mx.effects.effectClasses.DissolveInstance" ) );
	        
	            for ( i = 0; i < _effectsStarted.length; i++)
	            {
	                // Avoid referencing the DissolveInstance class directly, so that
	                // we don't create an unwanted linker dependency.
	                if( dissolveInstanceClass && _effectsStarted[ i ] is dissolveInstanceClass )
	                {
	                    // If we find the dissolve, save a pointer to the parent effect and end the instance
	                    currentDissolveEffect = _effectsStarted[ i ].effect;
	                    _effectsStarted[ i ].end();
	                    break;
	                }
	            }
	        }
	
	        // Unfocus the old header.
	        if( arrayContains( newIndices, _focusedIndex ) ) drawHeaderFocus( _focusedIndex, false );

	        // Commit the new indices.
	        _selectedIndices = newIndices;
	
	        // Remember our initial selected indices so we can
	        // restore to our default state when the history
	        // manager requests it.
	        if( initialSelectedIndices[ 0 ] == -1 ) initialSelectedIndices = _selectedIndices;
	
	        // Select the new headers.
			numNewIndices = newIndices.length;
	        for( i = 0; i < numNewIndices; i++ )
	        {
	        	if( newIndices[ i ] >= 0 ) 	getHeaderAt( newIndices[ i ] ).selected = true;
	        }
	        
	        if( !arrayContains( newIndices, _focusedIndex ) )
	        {
	            // Focus the new header.
	            _focusedIndex = newIndices[ 0 ];
	            drawHeaderFocus( _focusedIndex, showFocusIndicator );
	        }
	
	        if (bSaveState)
	        {
	            HistoryManager.save();
	            bSaveState = false;
	        }

			// If this is the very first time commitProperties has been invoked.
	        if( getStyle("openDuration") == 0 || !prevIndices.length )
	        {
		        for( i = 0; i < numNewIndices; i++ )
		        {
		            // Need to set the new index to be visible here
		            // in order for effects to work.
		            Container( getChildAt( newIndices[ i ] ) ).setVisible( true );
		
		            // Now that the effects have been triggered, we can hide the
		            // current view until it is properly sized and positioned below.
		            Container( getChildAt( newIndices[ i ] ) ).setVisible( false, true );
		        }
		        
		        instantiateSelectedChildren();
	        }
	        else
	        {
	        	if( tween ) tween.endTween();
				startTween( oldIndices, prevIndices, newIndices );
	        }
	    }
	
	    /**
	     *  @private
	     */
	    private function instantiateSelectedChildren():void
	    {
	        // fix for bug#137430
	        // when the selectedChild index is -1 (invalid value due to any reason)
	        // selectedContainer will not be valid. Before we proceed
	        // we need to make sure of its validity.
	        if( !selectedChildren.length ) return;
	
			/*var selectedChild:Container;
			var numItems:int = selectedChildren.length;
	        for( var i:int = 0; i < numItems; i++ )
	        {
	        	selectedChild = Container( selectedChildren[ i ] );
	        	
	        	// Performance optimization: don't call createComponents if we know
	        	// that createComponents has already been called.
	        	if( selectedChild && selectedChild.numChildrenCreated == -1 ) selectedChild.createComponentsFromDescriptors();
	        	if(selectedChild is IInvalidating) IInvalidating( selectedChild ).invalidateSize();
	        }*/
	
			var content:Container;
			var numItems:int = numChildren;
	        for( var i:int = 0; i < numItems; i++ )
	        {
	        	content = Container( getChildAt( i ) );
	        	
	        	// Performance optimization: don't call createComponents if we know
	        	// that createComponents has already been called.
	        	if( content && content.numChildrenCreated == -1 )
	        	{
	        		content.createComponentsFromDescriptors();
	        	}
	        	if( content is IInvalidating ) IInvalidating( content ).invalidateSize();
	        }
			
			
	        // Do the initial measurement/layout pass for the newly-instantiated
	        // descendants.
	        invalidateSize();
	        invalidateDisplayList();
	    }
	
	    /**
	     *  @private
	     */
	    private function dispatchChangeEvent( oldIndices:Array, newIndices:Array, cause:Event = null ):void
	    {
	        var relatedObject:DisplayObject = DisplayObject( IDataRenderer( cause.currentTarget ).data );

	        dispatchEvent( new IndicesChangedEvent( IndicesChangedEvent.CHANGE, false, false, relatedObject, oldIndices, newIndices, cause ) );
	    }
	
	    /**
	     *  @private
	     */
	    private function startTween( oldSelectedIndices:Array, prevSelectedIndices:Array, newSelectedIndices:Array ):void
	    {
	    	
	        bSliding = true;
	        
	        var prevHeight:Number = calcContentHeight( prevSelectedIndices.length );
			var contentHeight:Number;
			
	        // To improve the animation performance, we set up some invariants
	        // used in onTweenUpdate. (Some of these, like contentHeight, are
	        // too slow to recalculate at every tween step.)
	        tweenViewMetrics = viewMetricsAndPadding;
	        tweenContentWidth = calcContentWidth();
	        tweenContentHeight = calcContentHeight( _selectedIndices.length );
	        tweenOldSelectedIndices = oldSelectedIndices;
	        tweenNewSelectedIndices = newSelectedIndices;

	        // A single instance of Tween drives the animation.
	        var openDuration:Number = getStyle( "openDuration" );
	        tween = new Tween( this, 0, 1, openDuration );
	
	        var easingFunction:Function = getStyle("openEasingFunction") as Function;
	        if( easingFunction != null ) tween.easingFunction = easingFunction;
	        
	        tweenHeightStarts = new Array();
	        tweenHeightDifferences = new Array();
	        
	        var content:Container;
	        var numItems:int = numChildren;
	        for( var i:int = 0; i < numItems; i++ )
	        {
	        	content = Container( getChildAt( i ) );
	        	
	        	if( arrayContains( newSelectedIndices, getChildIndex( content ) ) )
	        	{
	        		// Tell the EffectManager that we're tweening.
	        		content.tweeningProperties = ["x", "y", "width", "height"];
	        		
	        		contentHeight = ( arrayContains( prevSelectedIndices, getChildIndex( content ) ) ) ? prevHeight : 0;
		        	tweenHeightStarts.push( contentHeight );
		        	tweenHeightDifferences.push( tweenContentHeight - contentHeight );
	        		
	        		// If its the first time the item has been shown.
	        		if( content.numChildren == 0 )
			        {
						var paddingLeft:Number = getStyle("paddingLeft");
						var contentX:Number = borderMetrics.left + (paddingLeft > 0 ? paddingLeft : 0);
			
						//content.move( contentX, content.y );
			        }
					
					// If this index is opening.
					if( tweenContentHeight > content.height )
					{
						content.setActualSize( tweenContentWidth, tweenContentHeight );
						content.scrollRect = new Rectangle( 0, 0, tweenContentWidth, tweenHeightStarts[ i ] );
					}
	        	}
	        	else if( arrayContains( oldSelectedIndices, i ) )
	        	{
	        		// Tell the EffectManager that we're tweening.
	        		content.tweeningProperties = ["x", "y", "width", "height"];
	        		
	        		tweenHeightStarts.push( prevHeight );
	        		tweenHeightDifferences.push( -prevHeight );					
	        	}
	        	else
	        	{
	        		tweenHeightStarts.push( 0 );
	        		tweenHeightDifferences.push( 0 );
	        	}
	        	
	        }
	        
	        UIComponent.suspendBackgroundProcessing();	
	    }
	
	    /**
	     *  @private
	     */
	    mx_internal function onTweenUpdate( value:Number ):void
	    {
	        var header:SuperAccordionHeader;
	        var content:Container;
	        var targetContentHeight:Number;
	        
	        var n:int;
	        var i:int;
	        var childrenY:Number;
	        if( _closable )
	        {
	        	var verticalAlignOffset:Number = getStyle( "verticalAlignOffset" )
	        	if( _selectedIndices[ 0 ] == -1 )
	        	{
	        		verticalAlignOffset = verticalAlignOffset * value;
	        	}
	        	else
	        	{
	        		verticalAlignOffset = verticalAlignOffset * Math.abs( value - 1 );
	        	}
	        	
		        var topAlign:Number = tweenViewMetrics.top;
		        var bottomAlign:Number = height;
	        	n = numChildren;
	        	for ( i = 0; i < n; i++)
	        	{
	        		header = getHeaderAt( i );
	        		bottomAlign -= header.height;
	        		bottomAlign -= tweenHeightStarts[ i ] + ( tweenHeightDifferences[ i ] * value )
	        	}
			        	
	        	switch( getStyle( "verticalAlign" ) )
	        	{
	        		case "middle" :
	        		{
	        			var contentHeight:Number = 0;
			        	n = numChildren;
			        	for ( i = 0; i < n; i++)
			        	{
			        		header = getHeaderAt( i );
			        		contentHeight += header.height;
			        		contentHeight += tweenHeightStarts[ i ] + ( tweenHeightDifferences[ i ] * value )
			        	}
			        	
			        	childrenY = ( ( unscaledHeight - contentHeight ) / 2 ) + verticalAlignOffset;
	        			break;
	        		}
	        		case "bottom" :
	        		{
	        			childrenY = bottomAlign + verticalAlignOffset;
	        			break;
	        		}
	        		default :
	        		{
	        			childrenY = topAlign + verticalAlignOffset;
	        		}
	        	}
	        	
	        	if( childrenY < topAlign ) childrenY = topAlign;
			    if( childrenY > bottomAlign ) childrenY = bottomAlign;
	        }
	        else
	        {
	        	childrenY = tweenViewMetrics.top;
	        }
	        
	        
	        var verticalGap:Number = getStyle("verticalGap");
	        n = numChildren;
	        for ( i = 0; i < n; i++)
	        {
	            header = getHeaderAt( i );
	            header.$y = childrenY;
	            childrenY += header.height;
				
				if( arrayContains( tweenNewSelectedIndices, i ) || arrayContains( tweenOldSelectedIndices, i ) )
				{
					content = Container( getChildAt( i ) );
					content.scrollRect = new Rectangle( 0, 0, tweenContentWidth, tweenHeightStarts[ i ] + ( tweenHeightDifferences[ i ] * value ) );
					content.visible = true;
					content.y = childrenY;
					
					childrenY += tweenHeightStarts[ i ] + ( tweenHeightDifferences[ i ] * value );
				}
				
	            
	
	            childrenY += verticalGap;
	        }
	    }
	
	    /**
	     *  @private
	     */
	    mx_internal function onTweenEnd(value:Number):void
	    {
	        bSliding = false;

	        var verticalGap:Number = getStyle("verticalGap");
	        var headerHeight:Number = getHeaderHeight();

	        var n:int;
	        var i:int;
	        var childrenY:Number;
	        if( _closable )
	        {
	        	var verticalAlignOffset:Number = getStyle( "verticalAlignOffset" )
	        	if( _selectedIndices[ 0 ] == -1 )
	        	{
	        		verticalAlignOffset = verticalAlignOffset * value;
	        	}
	        	else
	        	{
	        		verticalAlignOffset = verticalAlignOffset * Math.abs( value - 1 );
	        	}
	        	
	        	var topAlign:Number = tweenViewMetrics.top;
		        var bottomAlign:Number = height;
	        	n = numChildren;
	        	for ( i = 0; i < n; i++)
	        	{
	        		header = getHeaderAt( i );
	        		bottomAlign -= header.height;
	        		bottomAlign -= tweenHeightStarts[ i ] + ( tweenHeightDifferences[ i ] * value )
	        	}
	        	switch( getStyle( "verticalAlign" ) )
	        	{
	        		case "middle" :
	        		{
	        			var contentHeight:Number = 0;
			        	n = numChildren;
			        	for ( i = 0; i < n; i++)
			        	{
			        		header = getHeaderAt( i );
			        		contentHeight += header.height;
			        		contentHeight += tweenHeightStarts[ i ] + ( tweenHeightDifferences[ i ] * value )
			        	}
			        	
			        	childrenY = ( ( unscaledHeight - contentHeight ) / 2 ) + verticalAlignOffset;
	        			break;
	        		}
	        		case "bottom" :
	        		{
	        			childrenY = bottomAlign + verticalAlignOffset;
	        			break;
	        		}
	        		default :
	        		{
	        			childrenY = topAlign + verticalAlignOffset;
	        		}
	        	}
	        	
	        	if( childrenY < topAlign ) childrenY = topAlign;
			    if( childrenY > bottomAlign ) childrenY = bottomAlign;
	        }
	        else
	        {
	        	childrenY = tweenViewMetrics.top;
	        }
	        
	        var content:Container;
	
			var header:SuperAccordionHeader;
	        n = numChildren;
	        for ( i = 0; i < n; i++)
	        {
	           	header = getHeaderAt( i );
	            header.$y = childrenY;
	            childrenY += header.height;
				
				if( arrayContains( tweenNewSelectedIndices, i ) )
				{
					content = Container( getChildAt( i ) );
	                content.cacheAsBitmap = false;
	                content.height = tweenContentHeight;
	                content.scrollRect = null;
	                content.visible = true;
	                content.tweeningProperties = null;
	                childrenY += tweenHeightStarts[ i ] + tweenHeightDifferences[ i ];
				}
				
				if( arrayContains( tweenOldSelectedIndices, i ) )
				{
					content = Container( getChildAt( i ) );
		            content.cacheAsBitmap = false;
		            content.height = 0;
		            content.scrollRect = null;
		            content.visible = false;
		            content.tweeningProperties = null;
				}
	
	            childrenY += verticalGap;
	        }
	
	        // Delete the temporary tween invariants we set up in startTween.
	        tweenViewMetrics = null;
	        tweenContentWidth = NaN;
	        tweenContentHeight = NaN;
	        tweenOldSelectedIndices = null;
	        tweenNewSelectedIndices = null;
	
	        tween = null;
	
	       	UIComponent.resumeBackgroundProcessing();

	        // If we interrupted a Dissolve effect, restart it here
	        if (currentDissolveEffect)
	        {
	            if (currentDissolveEffect.target != null)
	            {
	                currentDissolveEffect.play();
	            }
	            else
	            {
	                currentDissolveEffect.play([this]);
	            }
	        }
	
	        // Let the screen render the last frame of the animation before
	        // we begin instantiating the new child.
	        callLater( instantiateSelectedChildren );
	    }
	
	    //--------------------------------------------------------------------------
	    //
	    //  Overridden event handlers
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  @private
	     *  Handles "keyDown" event.
	     */
	    override protected function keyDownHandler(event:KeyboardEvent):void
	    {
	        // Only listen for events that have come from the accordion itself.
	       /* if (event.target != this)
	            return;
	
	        var prevValue:int = selectedIndex;
	
	        switch (event.keyCode)
	        {
	            case Keyboard.PAGE_DOWN:
	            {
	                drawHeaderFocus(_focusedIndex, false);
	                _focusedIndex = selectedIndex = (selectedIndex < numChildren - 1
	                                 ? selectedIndex + 1
	                                 : 0);
	                drawHeaderFocus(_focusedIndex, true);
	                event.stopPropagation();
	                dispatchChangeEvent(prevValue, selectedIndex, event);
	                break;
	            }
	
	            case Keyboard.PAGE_UP:
	            {
	                drawHeaderFocus(_focusedIndex, false);
	                _focusedIndex = selectedIndex = (selectedIndex > 0
	                                 ? selectedIndex - 1
	                                 : numChildren - 1);
	                drawHeaderFocus(_focusedIndex, true);
	                event.stopPropagation();
	                dispatchChangeEvent(prevValue, selectedIndex, event);
	                break;
	            }
	
	            case Keyboard.HOME:
	            {
	                drawHeaderFocus(_focusedIndex, false);
	                _focusedIndex = selectedIndex = 0;
	                drawHeaderFocus(_focusedIndex, true);
	                event.stopPropagation();
	                dispatchChangeEvent(prevValue, selectedIndex, event);
	                break;
	            }
	
	            case Keyboard.END:
	            {
	                drawHeaderFocus(_focusedIndex, false);
	                _focusedIndex = selectedIndex = numChildren - 1;
	                drawHeaderFocus(_focusedIndex, true);
	                event.stopPropagation();
	                dispatchChangeEvent(prevValue, selectedIndex, event);
	                break;
	            }
	
	            case Keyboard.DOWN:
	            case Keyboard.RIGHT:
	            {
	                drawHeaderFocus(_focusedIndex, false);
	                _focusedIndex = (_focusedIndex < numChildren - 1
	                                 ? _focusedIndex + 1
	                                 : 0);
	                drawHeaderFocus(_focusedIndex, true);
	                event.stopPropagation();
	                break;
	            }
	
	            case Keyboard.UP:
	            case Keyboard.LEFT:
	            {
	                drawHeaderFocus(_focusedIndex, false);
	                _focusedIndex = (_focusedIndex > 0
	                                 ? _focusedIndex - 1
	                                 : numChildren - 1);
	                drawHeaderFocus(_focusedIndex, true);
	                event.stopPropagation();
	                break;
	            }
	
	            case Keyboard.SPACE:
	            case Keyboard.ENTER:
	            {
	                event.stopPropagation();
	                if (_focusedIndex != selectedIndex)
	                {
	                    selectedIndex = _focusedIndex;
	                    dispatchChangeEvent(prevValue, selectedIndex, event);
	                }
	                break;
	            }
	        }*/
	    }
	
	    //--------------------------------------------------------------------------
	    //
	    //  Event handlers
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Handles "added" event from system manager
		 */
		private function systemManager_addedHandler(event:Event):void
		{
			if (event.target is DisplayObjectContainer &&
					DisplayObjectContainer(event.target).contains(this))
				HistoryManager.register(this);
		}
		
		/**
		 *  @private
		 *  Handles "removed" event from system manager
		 */
		private function systemManager_removedHandler(event:Event):void
		{
			if (event.target is DisplayObjectContainer &&
					DisplayObjectContainer(event.target).contains(this))
				HistoryManager.unregister(this);
		}
	    
	    /**
	     *  @private
	     */
	    private function onChildAdd( event:ChildExistenceChangedEvent ):void
	    {
	        var child:DisplayObject = event.relatedObject;
	        
	        // Accordion creates all of its children initially invisible.
	        // They are made as they become the selected child.
	        child.visible = false;
	
	        // Create the header associated with this child.
	        createHeader( child, getChildIndex( child ) );
			
	        // If the child's label or icon changes, Accordion needs to know so that
	        // the header label can be updated. This event is handled by
	        // labelChanged().
	       /* if( child is ViewStack )
			{
				var viewStack:ViewStack = ViewStack( child );
				var viewStackChild:DisplayObject;
				var numViewStackChildren:int = viewStack.numChildren;
				for( var i:int = 0; i < numViewStackChildren; i++ )
				{
					viewStackChild = viewStack.getChildAt( i );
					viewStackChild.addEventListener( "labelChanged", labelChangedHandler, false, 0, true );
	        		viewStackChild.addEventListener( "iconChanged", iconChangedHandler, false, 0, true );
				}
			}
			else
			{
				child.addEventListener( "labelChanged", labelChangedHandler, false, 0, true );
	        	child.addEventListener( "iconChanged", iconChangedHandler, false, 0, true );
			}*/

	        // If we just created the first child and no selected index has
	        // been proposed, then propose this child to be selected.
	        if( numChildren == 1 && !proposedSelectedIndices )
	        {
	            selectIndex( 0 );
	
	            // Select the new header.
	            var newHeader:SuperAccordionHeader = getHeaderAt( 0 );
	            newHeader.selected = true;
	
	            // Focus the new header.
	            _focusedIndex = 0;
	            drawHeaderFocus( _focusedIndex, showFocusIndicator );
	        }
	        
			if( child as IAutomationObject ) IAutomationObject(child).showInAutomationHierarchy = true;
	    }
	
	    /**
	     *  @private
	     */
	    private function onChildRemove(event:ChildExistenceChangedEvent):void
	    {
	        if( numChildren == 0 ) return;
	
			var i:int;
	        var child:DisplayObject = event.relatedObject;
	        
	       /* if( child is ViewStack )
			{
				var viewStack:ViewStack = ViewStack( child );
				var viewStackChild:DisplayObject;
				var numViewStackChildren:int = viewStack.numChildren;
				for( i = 0; i < numViewStackChildren; i++ )
				{
					viewStackChild = viewStack.getChildAt( i );
					viewStackChild.removeEventListener( "labelChanged", labelChangedHandler );
	        		viewStackChild.removeEventListener( "iconChanged", iconChangedHandler );
				}
			}
			else
			{
				child.removeEventListener( "labelChanged", labelChangedHandler );
	        	child.removeEventListener( "iconChanged", iconChangedHandler );
			}*/
			
	       	var oldIndices:Array = selectedIndices;
	        var newIndices:Array;
	        var index:int = getChildIndex( child );
	        
	        var nChildren:int = numChildren - 1;
	            // number of children remaining after child has been removed
	
	        rawChildren.removeChild( getHeaderAt( index ) );
	
	        // Shuffle all higher numbered headers down.
	        for( i = index; i < nChildren; i++)
	        {
	            getHeaderAt(i + 1).name = HEADER_NAME_BASE + i;
	        }
	
	        // If we just deleted the only child, the accordion is now empty,
	        // and no child is now selected.
	        if( nChildren == 0 )
	        {
	            // There's no need to go through all of commitSelectedIndex(),
	            // and it wouldn't do the right thing, anyway, because
	            // it bails immediately if numChildren is 0.
	            newIndices = new Array();
	            newIndices[ 0 ] = _focusedIndex = -1;
	        }
	
	        else if( index > selectedIndices[ selectedIndices.length - 1 ] )
	        {
	            return;
	        }
	
	        // If we deleted a child before the selected child, the
	        // index of that selected child is now 1 less than it was,
	        // but the selected child itself hasn't changed.
	       /* else if (index < selectedIndices[ selectedIndices.length - 1 ] )
	        {
	        	newIndices = new Array();
	        	var numSelectedIndices:int = selectedIndices.length;
	        	for( var i:int = 0; i < numSelectedIndices; i++ )
	        	{
	        		if( index < selectedIndices[ i ] )
	        		{
	        			newIndices.push( selectedIndices[ i ] );
	        		}
	        		else if( index > selectedIndices[ i ] )
	        		{
	        			newIndices.push( selectedIndices[ i ] - 1 );
	        		}
	        	}
	        }*/
	
	        // Now handle the case that we deleted the selected child
	        // and it was the only selected child therefore we must select another child.
	        else if( selectedIndices.length == 1 && selectedIndices[ 0 ] == index )
	        {
	        	// If it was the last child, select the previous one.
	            // Otherwise, select the next one. This next child now
	            // has the same index as the one we just deleted,
	            newIndices = new Array();
	            if (index == nChildren)
	                newIndices.push( oldIndices[ 0 ] - 1 );
	            else
	                newIndices.push( oldIndices[ 0 ] );
	
	            // Select the new selected index header.
	            var newHeader:SuperAccordionHeader = getHeaderAt( newIndices[ 0 ] );
	            newHeader.selected = true;
	        }
	        // newIndices remains the same or the index is just removed from the newIndices
	        else
	        {
	        	newIndices = new Array();
	        	var numSelectedIndices:int = selectedIndices.length;
	        	for( i = 0; i < numSelectedIndices; i++ )
	        	{
	        		if( index < selectedIndices[ i ] )
	        		{
	        			newIndices.push( selectedIndices[ i ] );
	        		}
	        		else if( index > selectedIndices[ i ] )
	        		{
	        			newIndices.push( selectedIndices[ i ] - 1 );
	        		}
	        	}
	        }
	
	        if (_focusedIndex > index)
	        {
	            _focusedIndex--;
	            drawHeaderFocus(_focusedIndex, showFocusIndicator);
	        }
	        else if (_focusedIndex == index)
	        {
	            if (index == nChildren)
	                _focusedIndex--;
	            drawHeaderFocus(_focusedIndex, showFocusIndicator);
	        }
	
	        _selectedIndices = newIndices;
	
	        instantiateSelectedChildren();
	
	        dispatchEvent( new FlexEvent( FlexEvent.VALUE_COMMIT ) );
	
	    }
	
	    /**
	     *  @private
	     *  Handles "labelChanged" event.
	     */
	   /* private function labelChangedHandler(event:Event):void
	    {
	        var child:DisplayObject = DisplayObject(event.target);
	        var childIndex:int = getChildIndex(child);
	        var header:SuperAccordionHeader = getHeaderAt(childIndex);
	        header.label = Container(event.target).label;
	    }*/
	
	    /**
	     *  @private
	     *  Handles "iconChanged" event.
	     */
	   /* private function iconChangedHandler(event:Event):void
	    {
	        var child:DisplayObject = DisplayObject(event.target);
	        var childIndex:int = getChildIndex(child);
	        var header:Button = getHeaderAt(childIndex);
	        header.setStyle("icon", Container(event.target).icon);
	        //header.icon = Container(event.target).icon;
	    }*/
	    
	    
	    private function arrayContains( array:Array, value:Object ):Boolean
	    {
	    	if( !array ) return false;
	    	
	    	var numItems:int = array.length;
	    	for( var i:int = 0; i < numItems; i++ )
	    	{
	    		if( array[ i ] == value ) return true;
	    	}
	    	
	    	return false;
	    }
	    
	    private function arrayStripDuplicates( array:Array ):Array
	    {
	    	var stripedArray:Array = new Array();
	    	
	    	var duplicateFound:Boolean;
	    	var numItems:int = array.length;
	    	var numStripedItems:int;
	    	var si:int;
	    	for( var i:int = 0; i < numItems; i++ )
	    	{
	    		duplicateFound = false;
	    		numStripedItems = stripedArray.length;
	    		for( si = 0; si < numStripedItems; si++ )
	    		{
	    			if( stripedArray[ si ] == int( array[ i ] ) )
	    			{
	    				duplicateFound = true;
	    				break;
	    			}
	    		}
	    		
	    		if( !duplicateFound ) stripedArray.push( int( array[ i ] ) );
	    		
	    	}
	    	
	    	return stripedArray;
	    }
	    
	    private function arrayStripBoundaries( array:Array ):Array
	    {
	    	var returnArray:Array = array.concat();
	    	
	    	var numItems:int = returnArray.length;
			for( var i:int = 0; i < numItems; i++ )
	    	{
				if( returnArray[ i ] < 0 ) returnArray.splice( 0, 1 );
				if( returnArray[ i ] >= numChildren ) returnArray.splice( 0, 1 );
			}
			
			return returnArray;
	    }
	    
	}

}
