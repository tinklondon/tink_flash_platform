////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2007 Tink Ltd | http://www.tink.ws
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
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	
	import mx.containers.ViewStack;
	import mx.controls.Button;
	import mx.controls.TabBar;
	import mx.core.Container;
	import mx.core.EdgeMetrics;
	import mx.core.FlexVersion;
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.core.mx_internal;
	import mx.managers.IFocusManagerComponent;
	import mx.skins.ProgrammaticSkin;
	import mx.styles.StyleProxy;
	
	import ws.tink.mx.controls.PositionedTabBar;
	
	use namespace mx_internal;
	
	[IconFile("PositionedTabNavigator.png")]
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	// The fill related styles are applied to the children
	// of the TabNavigator, ie: the TabBar
	//include "../styles/metadata/FillStyles.as"
	
	// The focus styles are applied to the TabNavigator itself.
	//include "../styles/metadata/FocusStyles.as"
	
	/**
	 *  Name of CSS style declaration that specifies styles for the first tab.
	 *  If this is unspecified, the default value
	 *  of the <code>tabStyleName</code> style property is used.
	 */
	[Style(name="firstTabStyleName", type="String", inherit="no")]
	
	/**
	 *  Positioning of tabs in this TabNavigator container.
	 *  The possible values are <code>"topLeft"</code>, <code>"topCenter"</code>, <code>"topRight"</code>,
	 *  and <code>"rightTop"</code>, <code>"rightCenter"</code>, <code>"rightBottom"</code>,
	 *  and <code>"bottomRight"</code>, <code>"bottomCenter"</code>, <code>"bottomLeft"</code>,
	 *  and <code>"leftBottom"</code>, <code>"leftCenter"</code>, <code>"leftTop"</code>.
	 *  The default value is <code>"leftTop"</code>.
	 *
	 *  <p>If the value is <code>"topLeft"</code>, the left edge of the first tab
	 *  is aligned with the left edge, at the top of the TabNavigator container.
	 *  If the value is <code>"topCenter"</code>, the tabs are horizontally centered
	 *  at the top of the TabNavigator container.
	 *  If the value is <code>"topRight"</code>, the right edge of the last tab
	 *  is aligned with the right edge, at the top of the TabNavigator container.
	 * 
	 *  If the value is <code>"rightTop"</code>, the top edge of the first tab
	 *  is aligned with the top edge, on the right of the TabNavigator container.
	 *  If the value is <code>"rightCenter"</code>, the tabs are vertically centered
	 *  on the right of the TabNavigator container.
	 *  If the value is <code>"rightBottom"</code>, the bottom edge of the last tab
	 *  is aligned with the bottom edge, on the right of the TabNavigator container.
	 * 
	 * 	If the value is <code>"bottomRight"</code>, the right edge of the first tab
	 *  is aligned with the right edge, at the bottom of the TabNavigator container.
	 *  If the value is <code>"bottomCenter"</code>, the tabs are horizontally centered
	 *  at the bottom of the TabNavigator container.
	 *  If the value is <code>"bottomLeft"</code>, the left edge of the last tab
	 *  is aligned with the left edge , at the bottom of the TabNavigator container.
	 * 
	 * 	If the value is <code>"leftBottom"</code>, the bottom edge of the last tab
	 *  is aligned with the bottom edge, on the left of the TabNavigator container.
	 *  If the value is <code>"leftCenter"</code>, the tabs are vertically centered
	 *  on the left of the TabNavigator container.
	 *  If the value is <code>"leftTop"</code>, the top edge of the first tab
	 *  is aligned with the top edge, on the left of the TabNavigator container.</p>
	 */
	[Style(name="tabPosition", type="String", enumeration="topLeft,topCenter,topRight,rightTop,rightMiddle,rightBottom,bottomCenter,bottomRight,bottomLeft,leftBottom,leftMiddle,leftTop", inherit="no")]
	
	/**
	 *  Separation between tabs, in pixels.
	 *  The default value is -1, so that the borders of adjacent tabs overlap.
	 */
	[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Name of CSS style declaration that specifies styles for the last tab.
	 *  If this is unspecified, the default value
	 *  of the <code>tabStyleName</code> style property is used.
	 */
	[Style(name="lastTabStyleName", type="String", inherit="no")]
	
	/**
	 *  Name of CSS style declaration that specifies styles for the text
	 *  of the selected tab.
	 */
	[Style(name="selectedTabTextStyleName", type="String", inherit="no")]
	
	/**
	 *  Height of each tab, in pixels.
	 *  The default value is <code>undefined</code>.
	 *  When this property is <code>undefined</code>, the height of each tab is
	 *  determined by the font styles applied to this TabNavigator container.
	 *  If you set this property, the specified value overrides this calculation.
	 */
	[Style(name="tabHeight", type="Number", format="Length", inherit="no")]
	
	/**
	 *  Name of CSS style declaration that specifies styles for the tabs.
	 *  
	 *  @default undefined
	 */
	[Style(name="tabStyleName", type="String", inherit="no")]
	
	/**
	 *  Width of each tab, in pixels.
	 *  The default value is <code>undefined</code>.
	 *  When this property is <code>undefined</code>, the width of each tab is
	 *  determined by the width of its label text, using the font styles applied
	 *  to this TabNavigator container.
	 *  If the total width of the tabs would be greater than the width of the
	 *  TabNavigator container, the calculated tab width is decreased, but
	 *  only to a minimum of 30 pixels.
	 *  If you set this property, the specified value overrides this calculation.
	 *
	 *  <p>The label text on a tab is truncated if it does not fit in the tab.
	 *  If a tab label is truncated, a tooltip with the full label text is
	 *  displayed when a user rolls the mouse over the tab.</p>
	 */
	[Style(name="tabWidth", type="Number", format="Length", inherit="no")]
	
	/**
	 *  The horizontal offset, in pixels, of the tab bar from the left edge 
	 *  of the TabNavigator container. 
	 *  A positive value moves the tab bar to the right. A negative
	 *  value move the tab bar to the left. 
	 * 
	 *  @default 0 
	 */
	[Style(name="tabOffset", type="Number", format="Length", inherit="no")]
	
	//--------------------------------------
	//  Excluded APIs
	//--------------------------------------
	
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
	
	[Exclude(name="fillAlphas", kind="style")]
	[Exclude(name="fillColors", kind="style")]
	[Exclude(name="horizontalScrollBarStyleName", kind="style")]
	[Exclude(name="verticalScrollBarStyleName", kind="style")]
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	//[IconFile("TabNavigator.png")]
	
	/**
	 *  The TabNavigator container extends the ViewStack container by including
	 *  a TabBar container for navigating between its child containers.
	 *
	 *  <p>Like a ViewStack container, a TabNavigator container has a collection
	 *  of child containers, in which only one child at a time is visible.
	 *  Flex automatically creates a TabBar container at the top of the
	 *  TabNavigator container, with a tab corresponding to each child container.
	 *  Each tab can have its own label and icon.
	 *  When the user clicks a tab, the corresponding child container becomes
	 *  visible as the selected child of the TabNavigator container.</p>
	 *
	 *  <p>When you change the currently visible child container,
	 *  you can use the <code>hideEffect</code> property of the container being
	 *  hidden and the <code>showEffect</code> property of the newly visible child
	 *  container to apply an effect to the child containers.
	 *  The TabNavigator container waits for the <code>hideEffect</code> of the
	 *  child container being hidden to complete before it reveals the new child
	 *  container.
	 *  You can interrupt a currently playing effect if you change the
	 *  <code>selectedIndex</code> property of the TabNavigator container
	 *  while an effect is playing. </p>
	 *  
	 *  <p>To define the appearance of tabs in a TabNavigator, you can define style properties in a 
	 *  Tab type selector, as the following example shows:</p>
	 *  <PRE>
	 *  &lt;mx:Style&gt;
	 *    Tab {
	 *       fillColors: #006699, #cccc66;
	 *       upSkin: ClassReference("CustomSkinClass");
	 *       overSkin: ClassReference("CustomSkinClass");
	 *       downSkin: ClassReference("CustomSkinClass");
	 *    }  
	 *  &lt;/mx:Style&gt;
	 *  </PRE>
	 * 
	 *  <p>The Tab type selector defines values on the hidden mx.controls.tabBarClasses.Tab 
	 *  class. The default values for the Tab type selector are defined in the 
	 *  defaults.css file.</p>
	 * 
	 *  <p>You can also define the styles in a class selector that you specify using 
	 *  the <code>tabStyleName</code> style property; for example:</p>
	 *  <PRE>
	 *  &lt;mx:Style&gt;
	 *    TabNavigator {
	 *       tabStyleName:myTabStyle;
	 *    }
	 *
	 *    .myTabStyle {
	 *       fillColors: #006699, #cccc66;
	 *       upSkin: ClassReference("CustomSkinClass");
	 *       overSkin: ClassReference("CustomSkinClass");
	 *       downSkin: ClassReference("CustomSkinClass");
	 *    }
	 *  &lt;/mx:Style&gt;
	 *  </PRE>
	 *
	 *  <p>A TabNavigator container has the following default sizing characteristics:</p>
	 *     <table class="innertable">
	 *        <tr>
	 *           <th>Characteristic</th>
	 *           <th>Description</th>
	 *        </tr>
	 *        <tr>
	 *           <td>Default size</td>
	 *           <td>The default or explicit width and height of the first active child 
	 *               plus the tabs, at their default or explicit heights and widths. 
	 *               Default tab height is determined by the font, style, and skin applied 
	 *               to the TabNavigator container.</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Container resizing rules</td>
	 *           <td>By default, TabNavigator containers are only sized once to fit the size 
	 *               of the first child container. They do not resize when you navigate to 
	 *               other child containers. To force TabNavigator containers to resize when 
	 *               you navigate to a different child container, set the resizeToContent 
	 *               property to true.</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Child layout rules</td>
	 *           <td>If the child is larger than the TabNavigator container, it is clipped. If 
	 *               the child is smaller than the TabNavigator container, it is aligned to 
	 *               the upper-left corner of the TabNavigator container.</td>
	 *        </tr>
	 *        <tr>
	 *           <td>Default padding</td>
	 *           <td>0 pixels for the top, bottom, left, and right values.</td>
	 *        </tr>
	 *     </table>
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;mx:TabNavigator&gt;</code> tag inherits all of the
	 *  tag attributes of its superclass,
	 *  and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;mx:TabNavigator
	 *    <b>Styles</b>
	 *    fillAlphas="[0.60, 0.40, 0.75, 0.65]"
	 *    fillColors="[0xFFFFFF, 0xCCCCCC, 0xFFFFFF, 0xEEEEEE]"
	 *    firstTabStyleName="<i>Value of the</i> <code>tabStyleName</code> <i>property</i>"
	 *    focusAlpha="0.4"
	 *    focusRoundedCorners="tl tr bl br"
	 *    horizontalAlign="left|center|right"
	 *    horizontalGap="-1"
	 *    lastTabStyleName="<i>Value of the</i> <code>tabStyleName</code> <i>property</i>"
	 *    selectedTabTextStyleName="undefined"
	 *    tabHeight="undefined"
	 *    tabOffset="0"
	 *    tabStyleName="<i>Name of CSS style declaration that specifies styles for the tabs</i>"
	 *    tabWidth="undefined"
	 *    &gt;
	 *      ...
	 *      <i>child tags</i>
	 *      ...
	 *  &lt;/mx:TabNavigator&gt;
	 *  </pre>
	 *
	 *  @includeExample examples/TabNavigatorExample.mxml
	 *
	 *  @see mx.containers.ViewStack
	 *  @see mx.controls.TabBar
	 */
	public class PositionedTabNavigator extends ViewStack implements IFocusManagerComponent
	{
	
	    //--------------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  @private
	     */
	    private static const MIN_TAB_WIDTH:Number = 30;
	    private static const MIN_TAB_HEIGHT:Number = 20;
	
		//--------------------------------------------------------------------------
	    //
	    //  Variables
	    //
	    //--------------------------------------------------------------------------
    	
    	/**
	     *  A reference to the TabBar inside this TabNavigator.
	     */
	    protected var tabBar				: PositionedTabBar;
	    
		private var _tabPositionChanged		: Boolean;
	

	    //--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  Constructor.
	     */
	    public function PositionedTabNavigator()
	    {
	        super();
	
	        // Most views can't take focus, but a TabNavigator can.
	        // Container.init() has set tabEnabled false, so we
	        // have to set it back to true.
	        tabEnabled = true;
	
	        _historyManagementEnabled = true;
	    }

		
	    //--------------------------------------------------------------------------
	    //
	    //  Overridden properties
	    //
	    //--------------------------------------------------------------------------
		
		override public function styleChanged( styleProp:String ):void
		{
			super.styleChanged( styleProp );
			
			if( !styleProp || styleProp == "tabPosition" ) _tabPositionChanged = true;
		}
		
		
		
	    //----------------------------------
	    //  baselinePosition
	    //----------------------------------
	
	    /**
	     *  @private
	     *  The baselinePosition of a TabNavigator is calculated
		 *  for the label of the first tab.
	  	 *  If there are no children, a child is temporarily added
	  	 *  to do the computation.
	     */
	    override public function get baselinePosition():Number
	    {
	    	if( FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0 ) return super.baselinePosition;
		    
			if( !validateBaselinePosition() ) return NaN;
	
		    var isEmpty:Boolean = numChildren == 0;
		    if( isEmpty )
		    {
		    	var child0:Container = new Container();
		    	addChild(child0);
		    	validateNow();
		    }
		    
		    var tab0:Button = getTabAt( 0 );
		    var result:Number = tabBar.y + tab0.y + tab0.baselinePosition;
		    
		    if( isEmpty )
		    {
		   		removeChildAt( 0 );
		   		validateNow();
		    }
		    
		    return result;
	    }
	
	
	
		//----------------------------------
	    //  contentWidth
	    //----------------------------------
	    
	    /**
	     *  @private
	     */
	    override protected function get contentWidth():Number
	    {
	        var vm:EdgeMetrics = viewMetricsAndPadding;
	
	        var vmLeft:Number = vm.left;
	        var vmRight:Number = vm.right;
	
	        if ( isNaN( vmLeft ) ) vmLeft = 0;
	        if ( isNaN( vmRight ) ) vmRight = 0;
		
			var tabBarAllowance:Number = 0;
			var pos:String = getStyle( "tabPosition" ).substr( 0, 1 );
			if( pos == "l" || pos == "r" ) tabBarAllowance = tabBarWidth;
			
			return unscaledWidth - tabBarAllowance - vmLeft - vmRight;
	    }
	    
	    
	    
	    //----------------------------------
	    //  contentHeight
	    //----------------------------------
	    
	    /**
	     *  @private
	     */
	    override protected function get contentHeight():Number
	    {
	        var vm:EdgeMetrics = viewMetricsAndPadding;
	
	        var vmTop:Number = vm.top;
	        var vmBottom:Number = vm.bottom;
	
	        if ( isNaN( vmTop ) ) vmTop = 0;
	        if ( isNaN( vmBottom ) ) vmBottom = 0;
			
			var tabBarAllowance:Number = 0;
			var pos:String = getStyle( "tabPosition" ).substr( 0, 1 );
			if( pos == "t" || pos == "b" ) tabBarAllowance = tabBarHeight;

	        return unscaledHeight - tabBarAllowance - vmTop - vmBottom;
	    }
	    
	    
	
		//----------------------------------
	    //  contentX
	    //----------------------------------
	
	    /**
	     *  @private
	     */
	    override protected function get contentX():Number
	    {   
	        var pos:String = getStyle( "tabPosition" ).substr( 0, 1 );
	    	var tabBarAllowance:Number = ( pos == "l" && !isNaN( tabBarWidth ) ) ? tabBarWidth : 0;
	    	
	    	var padding:Number = getStyle( "paddingLeft" );
	        if( isNaN( padding ) ) padding = 0;
			
	        return tabBarAllowance + padding;
	    }
	    
	    
	    
	    //----------------------------------
	    //  contentY
	    //----------------------------------
	
	    /**
	     *  @private
	     */
	    override protected function get contentY():Number
	    {
	    	var pos:String = getStyle( "tabPosition" ).substr( 0, 1 );
	    	var tabBarAllowance:Number = ( pos == "t" && !isNaN( tabBarHeight ) ) ? tabBarHeight : 0;
	    	
	    	var padding:Number = getStyle( "paddingTop" );
	        if( isNaN( padding ) ) padding = 0;
		
	        return tabBarAllowance + padding;
	    }
	    
	    
	
	    //--------------------------------------------------------------------------
	    //
	    //  Properties
	    //
	    //--------------------------------------------------------------------------	    
	
	    //----------------------------------
	    //  tabBarWidth
	    //----------------------------------
	
	    /**
	     *  @private
	     *  Width of the tabBar.
	     */
	    final protected function get tabBarWidth():Number
	    {
	    	var position:String = getStyle( "tabPosition" ).substr( 0, 1 );
	    	if( position == "t" || position == "b" ) return tabBar.getExplicitOrMeasuredWidth();
	    	
	        var tabWidth:Number = getStyle( "tabWidth" );
	        if( isNaN( tabWidth ) ) tabWidth = tabBar.getExplicitOrMeasuredWidth();
			
			var bm:Number = ( position == "l" ) ? borderMetrics.left : borderMetrics.right;
			
	        return tabWidth - bm;
	    }
	    
	    
	    
	    //----------------------------------
	    //  tabBarHeight
	    //----------------------------------
	    
	    /**
	     *  @private
	     *  Height of the tabBar.
	     */
	    final protected function get tabBarHeight():Number
	    {
	    	var position:String = getStyle( "tabPosition" ).substr( 0, 1 );
	    	if( position == "l" || position == "r" ) return tabBar.getExplicitOrMeasuredHeight();
	    	
	        var tabHeight:Number = getStyle( "tabHeight" );
	        if( isNaN( tabHeight ) ) tabHeight = tabBar.getExplicitOrMeasuredHeight();
	
			var bm:Number = ( position == "t" ) ? borderMetrics.top : borderMetrics.bottom;
			
	        return tabHeight - bm;
	    }
	
	
	
		//----------------------------------
	    //  tabBarStyleFilters
	    //----------------------------------
	
	    /**
	     *  The set of styles to pass from the TabNavigator to the tabBar.
	     *  @see mx.styles.StyleProxy
	     *  @review
	     */
	    protected function get tabBarStyleFilters():Object
	    {
	    	return _tabBarStyleFilters;
	    }
	    
	    private static var _tabBarStyleFilters:Object =
	    {
	    	"firstTabStyleName" : "firstTabStyleName",
	    	"lastTabStyleName" : "lastTabStyleName",
	    	"selectedTabTextStyleName" : "selectedTabTextStyleName",
	    	"tabStyleName" : "tabStyleName",
	    	"horizontalGap" : "horizontalGap",
	    	"verticalGap" : "verticalGap",
	    	"tabWidth" : "tabWidth",
	    	"tabHeight" : "tabHeight",
	    	"position" : "position"
	    }; 
	
	
	
	    //--------------------------------------------------------------------------
	    //
	    //  Overridden methods: UIComponent
	    //
	    //--------------------------------------------------------------------------
		
	    /**
	     *  @private
	     */
	    override protected function createChildren():void
	    {
	        super.createChildren();
	
	        if( !tabBar )
	        {
	            tabBar = new PositionedTabBar();
	            tabBar.name = "tabBar";
	            tabBar.focusEnabled = false;
	            tabBar.styleName = new StyleProxy( this, tabBarStyleFilters );
	            rawChildren.addChild( tabBar );
	            
	            if( FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0 )
	            {
	            	tabBar.setStyle( "paddingTop", 0 );
	            	tabBar.setStyle( "paddingBottom", 0 );
					tabBar.setStyle( "borderStyle", "none" );         	
	            }

	            _tabPositionChanged = true;
	        }
	    }
	
	
	
	    /**
	     *  @private
	     */
	    override protected function commitProperties():void
	    {
	        super.commitProperties();
	
	        // Things get a bit tricky here... we need to
	        // wait until our children have been instantiated
	        // before we can attach the tab bar to us.
	        if( tabBar && tabBar.dataProvider != this && numChildren > 0 && getChildAt( 0 ) ) tabBar.dataProvider = this;
	    }
	
	
	
	    /**
	     *  Calculates the default sizes and mininum and maximum values of this
	     *  TabNavigator container.
	     *  See the <code>UIComponent.measure()</code> method for more information
	     *  about the <code>measure()</code> method.
	     *
	     *  <p>The TabNavigator container uses the same measurement logic as the
	     *  <code>ViewStack</code> container, with two modifications:
	     *  First, it increases the value of the
	     *  <code>measuredHeight</code> and
	     *  <code>measuredMinHeight</code> properties to accomodate the tabs.
	     *  Second, it increases the value of the
	     *  <code>measuredWidth</code> property if necessary
	     *  to ensure that each tab can be at least 30 pixels wide.</p>
	     * 
	     *  @see mx.core.UIComponent#measure()
	     *  @see mx.containers.ViewStack#measure()
	     */
	    override protected function measure():void
	    {
	        // Only measure once. Thereafter, we'll just use cached values.
	        // We need to copy the cached values into the measured fields
	        // again to handle the case where scaleX or scaleY is not 1.0.
	        // When the TabNavigator is zoomed, code in UIComponent.measureSizes
	        // scales the measuredWidth/Height values every time that
	        // measureSizes is called.  (bug 100749)
	
	        // This must be done before the call to super.measure(), otherwise
	        // we don't get the first measurement correct.
	        if( vsPreferredWidth && !resizeToContent )
	        {
	            measuredMinWidth = vsMinWidth;
	            measuredMinHeight = vsMinHeight;
	            measuredWidth = vsPreferredWidth;
	            measuredHeight = vsPreferredHeight;
	            return;
	        }
	
	        super.measure();
			
			 // Add view metrics.
	        var vm:EdgeMetrics = viewMetrics;
	        
			var added:Number;
			var tabPosition:String = getStyle( "tabPosition" ).substr( 0, 1 );
			if( tabPosition == "l" || tabPosition == "r" )
			{
				added = tabBarWidth;
	       		//measuredMinWidth += added;
	        	//measuredWidth += added;
	        	
	        	// Make sure there is at least enough room
		        // to draw all tabs at their minimum size.
		        var tabHeight:Number = getStyle( "tabHeight" );
		        if( isNaN( tabHeight ) ) tabHeight = 0;
		
		        var minTabBarHeight:Number = numChildren * Math.max( tabHeight, MIN_TAB_HEIGHT );
		
		        // Add view metrics.
		        //var vm:EdgeMetrics = viewMetrics;
		        minTabBarHeight += ( vm.top + vm.bottom );
		
		        // Add horizontal gaps.
		        if( numChildren > 1 ) minTabBarHeight += ( getStyle( "verticalGap" ) * ( numChildren - 1 ) );
		
		        if( measuredHeight < minTabBarHeight ) measuredHeight = minTabBarHeight;
			}
			else
			{
				added = tabBarHeight;
	       		measuredMinHeight += added;
	        	measuredHeight += added;
	        	
	        	// Make sure there is at least enough room
		        // to draw all tabs at their minimum size.
		        var tabWidth:Number = getStyle( "tabWidth" );
		        if( isNaN( tabWidth ) ) tabWidth = 0;
		
		        var minTabBarWidth:Number = numChildren * Math.max( tabWidth, MIN_TAB_WIDTH );
		
		        // Add view metrics.
		        //var vm:EdgeMetrics = viewMetrics;
		        minTabBarWidth += ( vm.left + vm.right );
		
		        // Add horizontal gaps.
		        if( numChildren > 1 ) minTabBarWidth += ( getStyle( "horizontalGap" ) * ( numChildren - 1 ) );
		
		        if( measuredWidth < minTabBarWidth ) measuredWidth = minTabBarWidth;
			}
	
	        // If we're called before instantiateSelectedChild, then bail.
	        // We'll be called again later (instantiateSelectedChild calls
	        // invalidateSize), and we don't want to load values into the
	        // cache until we're fully initialized.  (bug 102639)
	        if( selectedChild && Container( selectedChild ).numChildrenCreated == -1 ) return;
	
	        // Don't remember sizes if we don't have any children
	        if( numChildren == 0 ) return;
	
	        vsMinWidth = measuredMinWidth;
	        vsMinHeight = measuredMinHeight;
	        vsPreferredWidth = measuredWidth;
	        vsPreferredHeight = measuredHeight;
	    }
	
	
	
	    /**
	     *  Responds to size changes by setting the positions and sizes
	     *  of this container's tabs and children.
	     *
	     *  For more information about the <code>updateDisplayList()</code> method,
	     *  see the <code>UIComponent.updateDisplayList()</code> method.
	     *
	     *  <p>A TabNavigator container positions its TabBar container at the top.
	     *  The width of the TabBar is set to the width of the
	     *  TabNavigator, and the height of the TabBar is set
	     *  based on the <code>tabHeight</code> property.</p>
	     *
	     *  <p>A TabNavigator container positions and sizes its child containers
	     *  underneath the TabBar, using the same logic as in
	     *  ViewStack container.</p>
	     *
	     *  @param unscaledWidth Specifies the width of the component, in pixels,
	     *  in the component's coordinates, regardless of the value of the
	     *  <code>scaleX</code> property of the component.
	     *
	     *  @param unscaledHeight Specifies the height of the component, in pixels,
	     *  in the component's coordinates, regardless of the value of the
	     *  <code>scaleY</code> property of the component.
	     * 
	     *  @see mx.core.UIComponent#updateDisplayList()
	     */
	    override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
	    {
	        super.updateDisplayList( unscaledWidth, unscaledHeight );
			
	        var bm:EdgeMetrics = borderMetrics;
	        var vm:EdgeMetrics = viewMetrics;
	        var w:Number = unscaledWidth - vm.left - vm.right;
			var h:Number = unscaledHeight - vm.top - vm.bottom;
			
	        var th:Number;
	        var tw:Number;
	        var position:String;
	        	
        	var tabPosition:String = getStyle( "tabPosition" );
			switch( tabPosition.substr( 0, 1 ) )
			{
				case "r" :
				{
					tw = tabBarWidth + bm.right;
					th = tabBar.getExplicitOrMeasuredHeight();
					position = "right";
					break;
				}
				case "l" :
				{
					tw = tabBarWidth + bm.left;
					th = tabBar.getExplicitOrMeasuredHeight();
					position = "left";
					break;
				}
				case "t" :
				{
					tw = tabBar.getExplicitOrMeasuredWidth();
					th = tabBarHeight + bm.top;
					position = "top";
					break;
				}
				case "b" :
				{
					tw = tabBar.getExplicitOrMeasuredWidth();
					th = tabBarHeight + bm.bottom;
					position = "bottom";
					break;
				}
			}
	        
	        if( _tabPositionChanged )
	        {
	        	_tabPositionChanged = false;
	        	tabBar.setStyle( "position", position );
	        	invalidateDisplayList();
	        }

	        tabBar.setActualSize( Math.min( w, tw ), Math.min( h, th ) );
	        positionTabBar();
	    }
	
	
	
		protected function positionTabBar():void
		{
			var tabOffset:Number = getStyle( "tabOffset" );
			tabOffset = ( tabOffset ) ? tabOffset : 0;
			
			switch( getStyle( "tabPosition" ) )
	        {
	        	case "topLeft":
	        	{
		            tabBar.move( tabOffset, 0 );
		            break;
		        }
		        case "topCenter":
		        {
		        	tabBar.move( Math.round( ( unscaledWidth - tabBar.width ) / 2 + tabOffset ), 0 );
		            break;
		        }
		        case "topRight":
		        {
		        	tabBar.move( ( unscaledWidth - tabBar.width ) - tabOffset, 0 );
		        	break;
		        }
		        case "rightTop":
	        	{
	        		tabBar.move( unscaledWidth - tabBar.width, tabOffset );
		            break;
		        }
		        case "rightMiddle":
		        {
		            tabBar.move( unscaledWidth - tabBar.width, Math.round( ( unscaledHeight - tabBar.height ) / 2 + tabOffset ) );
		            break;
		        }
		        case "rightBottom":
		        {
		            tabBar.move( unscaledWidth - tabBar.width, unscaledHeight -  tabBar.height - tabOffset );
		            break;
		        }
		        case "bottomLeft":
	        	{
		            tabBar.move( tabOffset, unscaledHeight - tabBar.height  );
		            break;
		        }
		        case "bottomCenter":
		        {
		        	tabBar.move( Math.round( ( unscaledWidth - tabBar.width ) / 2 + tabOffset ), unscaledHeight - tabBar.height );
		            break;
		        }
		        case "bottomRight":
		        {
		            tabBar.move( unscaledWidth - tabBar.width - tabOffset, unscaledHeight - tabBar.height );
		            break;
		        }
		        case "leftTop" :
	        	{
		            tabBar.move( 0, tabOffset );
		            break;
		        }
		        case "leftMiddle" :
		        {
		            tabBar.move( 0, Math.round( ( unscaledHeight - tabBar.height ) / 2 + tabOffset ) );
		            break;
		        }
		        case "leftBottom" :
		        {
		            tabBar.move( 0, unscaledHeight -  tabBar.height - tabOffset );
		            break;
		        }
	        }
		}
		
		
			
	    /**
	     *  @private
	     */
	    override public function drawFocus( isFocused:Boolean ):void
	    {
	        // Superclass sets up standard focus glow.
	        super.drawFocus( isFocused );
	
	        if( !parent ) return;
	            
	        // Clip the glow so it doesn't include the tabs
	        var focusObj:DisplayObject = IUIComponent( parent ).focusPane;
	        if( isFocused && !isEffectStarted )
	        {
	            // Normally the focus skin is in front of the object. For TabNavigator
	            // we want it behind.
	            if( focusObj )
	            {
	                if( parent is Container )
	                {
	                    var n:int = Container( parent ).rawChildren.numChildren;
	                    var fci:int = Container( parent ).firstChildIndex;
	                    // make sure we don't set it past the last index.  This happens
	                    // if all content children are in a contentpane
	                    Container( parent ).rawChildren.setChildIndex( focusObj, Math.max( 0, ( fci == n ) ? n - 1 : fci ) );
	                }
	                else
	                {
	                    parent.setChildIndex( focusObj, 0 );
	                }
	            }
	        }
	        else
	        {
	            if( focusObj )
	            {
	                // Move the focus skin back in front of the children, where it
	                // was before we drew focus.
	                if( parent is Container )
	                {
	                    Container( parent ).rawChildren.setChildIndex( focusObj, Container( parent ).rawChildren.numChildren - 1 );
	                }
	                else
	                {
	                    parent.setChildIndex( focusObj, parent.numChildren - 1 );
	                }
	            }
	        }
	
	        tabBar.drawFocus( isFocused );
	    }
	
	    /**
	     *  @private
	     */
	    override protected function adjustFocusRect(  object:DisplayObject = null ):void
	    {
	        // Superclass does most of the work
	        super.adjustFocusRect( object );
	
	        // Adjust the focus rect so it is below the tabs
	        var focusObj:IFlexDisplayObject = IFlexDisplayObject( getFocusObject() );
	
	        if( focusObj )
	        {
	            focusObj.setActualSize( focusObj.width, focusObj.height - tabBarHeight );
	            focusObj.move( focusObj.x, focusObj.y + tabBarHeight );
	
	            if( focusObj is IInvalidating )
	                IInvalidating( focusObj ).validateNow();
	
	            else if( focusObj is ProgrammaticSkin )
	                ProgrammaticSkin( focusObj ).validateNow();
	        }
	    }
	
	    //--------------------------------------------------------------------------
	    //
	    //  Overridden methods: Container
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  @private
	     */
	    override protected function layoutChrome( unscaledWidth:Number, unscaledHeight:Number ):void
	    {
	        super.layoutChrome( unscaledWidth, unscaledHeight );
	
	        // Move our border so it leaves room for the tabs
	        if( border )
	        {
	            var borderOffset:Number;
	            var borderPosition:Number;
	            switch( getStyle( "tabPosition" ).substr( 0, 1 ) )
	            {
	            	case "t" :
	            	{
		            	border.move( 0, tabBarHeight );
		            	border.setActualSize( unscaledWidth, unscaledHeight - tabBarHeight );
	            		break;
	            	}
	            	case "b" :
	            	{
	            		border.move( 0, 0 );
	            		border.setActualSize( unscaledWidth, unscaledHeight - tabBarHeight );
	            		break;
	            	}
	            	case "l" :
	            	{
	            		border.move( tabBarWidth, 0 );
		            	border.setActualSize( unscaledWidth - tabBarWidth, unscaledHeight );
	            		break;
	            	}
	            	case "r" :
	            	{
	            		border.move( 0, 0 );
		            	border.setActualSize( unscaledWidth - tabBarWidth, unscaledHeight );
	            		break;
	            	}
	            }
	        }
	    }
	
	    //--------------------------------------------------------------------------
	    //
	    //  Methods
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  Returns the tab of the navigator's TabBar control at the specified
	     *  index.
	     *
	     *  @param index Index in the navigator's TabBar control.
	     *
	     *  @return The tab at the specified index.
	     */
	    public function getTabAt( index:int ):Button
	    {
	        return Button( tabBar.getChildAt( index ) );
	    }
	
	    //--------------------------------------------------------------------------
	    //
	    //  Overridden event handlers: UIComponent
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  @private
	     */
	    override protected function focusInHandler( event:FocusEvent ):void
	    {
	        super.focusInHandler( event );
	        
	        // When the TabNavigator has focus, the Focus Manager
	        // should not treat the Enter key as a click on
	        // the default pushbutton.
	        if( event.target == this ) focusManager.defaultButtonEnabled = false;
	    }
	
	    /**
	     *  @private
	     */
	    override protected function focusOutHandler( event:FocusEvent ):void
	    {
	        super.focusOutHandler( event );
	
	        if( focusManager && event.target == this ) focusManager.defaultButtonEnabled = true;
	    }
	
	    import flash.ui.Keyboard;
	    
	    /**
	     *  @private
	     */
	    override protected function keyDownHandler( event:KeyboardEvent ):void
	    {
	        if( focusManager.getFocus() == this )
	        {
	            // Redispatch the event from the TabBar so that it can handle it.
	            tabBar.dispatchEvent( event );
	        }
	    }
	
	    /**
	     *  @private
	     */
	    mx_internal function getTabBar():TabBar
	    {
	        return tabBar;
	    }
	    
	
	}

}
