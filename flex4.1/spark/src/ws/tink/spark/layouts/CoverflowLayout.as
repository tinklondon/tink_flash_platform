package ws.tink.spark.layouts
{
	
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	import spark.primitives.supportClasses.GraphicElement;
	
	import ws.tink.spark.layouts.supportClasses.PerspectiveAnimationNavigatorLayoutBase;
	
	/**
	 *  Flex 4 CoverflowLayout
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class CoverflowLayout extends PerspectiveAnimationNavigatorLayoutBase
	{
		
		
		
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
		public function CoverflowLayout()
		{
			super( INDIRECT );
			_transformCalculator = new TransformValues( this );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var _transformCalculator				: TransformValues;
		
		/**
		 *  @private
		 */
		//		private var _indicesInViewChanged				: Boolean;
		
		/**
		 *  @private
		 */
		private var _horizontalCenterMultiplier			: Number;
		
		/**
		 *  @private
		 */
		private var _verticalCenterMultiplier			: Number;
		
		/**
		 *  @private
		 */
		private var _elementHorizontalCenterMultiplier	: Number;
		
		/**
		 *  @private
		 */
		private var _elementVerticalCenterMultiplier	: Number;
		
		/**
		 *  @private
		 */
		private var _displayedElements					: Vector.<IVisualElement>	
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  maximumZ
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for maximumZ.
		 */
		private var _maximumZ				: Number = 100;
		
		[Inspectable(category="General", defaultValue="100")]
		/**
		 *  maximumZ
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get maximumZ() : Number
		{
			return _maximumZ;
		}
		/**
		 *  @private
		 */
		public function set maximumZ( value : Number ) : void
		{
			if( _maximumZ == value ) return;
			
			_maximumZ = value;
//			_indicesInViewChanged = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  rotationX
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for rotationX.
		 */
		private var _rotationX:Number = 0;
		
		/**
		 *	Whether rotation should be applied to the x axis of elements.
		 * 
		 *  @default true
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get rotationX():Number
		{
			return _rotationX;
		}
		/**
		 *  @private
		 */
		public function set rotationX( value:Number ) : void
		{
			if( _rotationX == value ) return;
			
			_rotationX = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  rotationY
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for rotationY.
		 */
		private var _rotationY:Number = 45;
		
		/**
		 *	Whether rotation should be applied to the y axis of elements.
		 * 
		 *  @default true
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get rotationY():Number
		{
			return _rotationY;
		}
		/**
		 *  @private
		 */
		public function set rotationY( value:Number ):void
		{
			if( value == _rotationY ) return;
			
			_rotationY = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  horizontalDisplacement
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for horizontalDisplacement.
		 */
		private var _horizontalDisplacement:Number = 100;
		
		[Inspectable(category="General", defaultValue="100")]
		/**
		 *  horizontalDisplacement
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get horizontalDisplacement() : Number
		{
			return _horizontalDisplacement;
		}
		/**
		 *  @private
		 */
		public function set horizontalDisplacement( value : Number ) : void
		{
			if( _horizontalDisplacement == value ) return
				
			_horizontalDisplacement = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  selectedHorizontalDisplacement
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for selectedHorizontalDisplacement.
		 */
		private var _selectedHorizontalDisplacement:Number = 100;
		
		[Inspectable(category="General", defaultValue="100")]
		/**
		 *  selectedHorizontalDisplacement
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get selectedHorizontalDisplacement() : Number
		{
			return _selectedHorizontalDisplacement;
		}
		/**
		 *  @private
		 */
		public function set selectedHorizontalDisplacement( value:Number ) : void
		{
			if( _selectedHorizontalDisplacement == value ) return
				
			_selectedHorizontalDisplacement = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  verticalDisplacement
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for verticalDisplacement.
		 */
		private var _verticalDisplacement:Number = 0;
		
		[Inspectable(category="General", defaultValue="0")]
		/**
		 *  verticalDisplacement
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get verticalDisplacement() : Number
		{
			return _verticalDisplacement;
		}
		/**
		 *  @private
		 */
		public function set verticalDisplacement( value:Number ):void
		{
			if( _verticalDisplacement == value ) return;
			
			_verticalDisplacement = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  selectedVerticalDisplacement
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for selectedVerticalDisplacement.
		 */
		private var _selectedVerticalDisplacement:Number = 0;
		
		[Inspectable(category="General", defaultValue="0")]
		/**
		 *  selectedVerticalDisplacement
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get selectedVerticalDisplacement() : Number
		{
			return _selectedVerticalDisplacement;
		}
		/**
		 *  @private
		 */
		public function set selectedVerticalDisplacement( value:Number ) : void
		{
			if( _selectedVerticalDisplacement == value ) return
				
				_selectedVerticalDisplacement = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  depthColor
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for depthColor.
		 */
		private var _depthColor		: int = -1;
		
		[Inspectable(category="General", defaultValue="-1")]
		/**
		 *	The color tint to apply to elements as their are moved back on the z axis.
		 * 
		 *	<p>If a valid color is added to elements are tinted as they are moved
		 *	back on the z axis taking into account the <code>depthColorAlpha</code>
		 *	specified. If a value of -1 is set for the color no tinting is applied.</p>
		 * 
		 *  @default -1
		 * 
		 * 	@see #depthColorAlpha
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get depthColor():int
		{
			return _depthColor;
		}
		/**
		 *  @private
		 */
		public function set depthColor( value:int ) : void
		{
			if( _depthColor == value ) return;
			
			_depthColor = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  depthColorAlpha
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for depthColorAlpha.
		 */
		private var _depthColorAlpha		: Number = 1;
		
		[Inspectable(category="General", defaultValue="1")]
		
		/**
		 *	The alpha to be used for the color tint that is applied to elements
		 *	as their are moved back on the z axis.
		 * 
		 *  @default 1
		 * 
		 * 	@see #depthColor
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get depthColorAlpha():Number
		{
			return _depthColorAlpha;
		}
		/**
		 *  @private
		 */
		public function set depthColorAlpha( value:Number ) : void
		{
			if( _depthColorAlpha == value ) return;
			
			_depthColorAlpha = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  numUnselectedElements
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for numUnselectedElements.
		 */
		private var _numUnselectedElements	: int = -1;
		
		[Inspectable(category="General", defaultValue="-1")]
		/**
		 *	The number of items to show either side of the selected item
		 *	are positioned around this element.
		 * 
		 *	<p>Valid values are <code>HorizontalAlign.LEFT</code>, <code>HorizontalAlign.CENTER</code>
		 *	and <code>HorizontalAlign.RIGHT</code>.</p>
		 * 
		 *  @default 2
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		
		public function get numUnselectedElements():int
		{
			return _numUnselectedElements;
		}
		/**
		 *  @private
		 */
		public function set numUnselectedElements( value:int ) : void
		{
			if( _numUnselectedElements == value ) return;
			
			_numUnselectedElements = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  horizontalAlign
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for horizontalAlign.
		 */
		private var _horizontalAlign:String = HorizontalAlign.CENTER;
		
		/**
		 *  @private
		 *  Flag to indicate the horizontalAlign property has changed.
		 */
		private var _horizontalAlignChange:Boolean = true;
		
		[Inspectable(category="General", enumeration="left,right,center", defaultValue="center")]
		/**
		 *	The horizontal position of the selected element in the viewport. All other elements
		 *	are positioned around this element.
		 * 
		 *	<p>Valid values are <code>HorizontalAlign.LEFT</code>, <code>HorizontalAlign.CENTER</code>
		 *	and <code>HorizontalAlign.RIGHT</code>.</p>
		 * 
		 *  @default "center"
		 * 
		 * 	@see #horizontalAlignOffset
		 * 	@see #horizontalAlignOffsetPercent
		 * 	@see spark.layouts.HorizontalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		/**
		 *  @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if( value == _horizontalAlign ) return;
			
			_horizontalAlign = value;
			_horizontalAlignChange = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  verticalAlign
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for verticalAlign.
		 */
		private var _verticalAlign:String = VerticalAlign.MIDDLE;
		
		/**
		 *  @private
		 *  Flag to indicate the verticalAlign property has changed.
		 */
		private var _verticalAlignChange:Boolean = true;
		
		[Inspectable(category="General", enumeration="top,bottom,middle", defaultValue="middle")]
		/**
		 *	The vertical position of the selected element in the viewport. All other elements
		 *	are positioned around this element.
		 * 
		 *	<p>Valid values are <code>VerticalAlign.TOP</code>, <code>VerticalAlign.MIDDLE</code>
		 *	and <code>VerticalAlign.BOTTOM</code>.</p>
		 * 
		 *  @default "middle"
		 * 
		 * 	@see #verticalAlignOffset
		 * 	@see #verticalAlignOffsetPercent
		 * 	@see spark.layouts.VerticalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		/**
		 *  @private
		 */
		public function set verticalAlign(value:String):void
		{
			if( value == _verticalAlign ) return;
			
			_verticalAlign = value;
			_verticalAlignChange = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  horizontalAlignOffset
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for horizontalAlignOffset.
		 */
		private var _horizontalAlignOffset:Number = 0;
		
		[Inspectable(category="General", defaultValue="0")]
		/**
		 *	The offset in pixels to be used in conjunction with <code>horizontalAlign</code>
		 *	to set the horizontal position of the selected element in the viewport. All other elements
		 *	are positioned around this element.
		 * 
		 *	<p>If <code>horizontalAlignOffsetPercent</code> is set after this property,
		 *	this property is set automatically depending on the value of <code>horizontalAlignOffsetPercent</code>.</p>
		 * 
		 *  @default 0
		 * 
		 * 	@see #horizontalAlign
		 * 	@see #horizontalAlignOffsetPercent
		 * 	@see spark.layouts.HorizontalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get horizontalAlignOffset():Number
		{
			return _horizontalAlignOffset;
		}
		/**
		 *  @private
		 */
		public function set horizontalAlignOffset(value:Number):void
		{
			if( _horizontalAlignOffset == value ) return;
			
			_horizontalAlignOffset = value;
			_horizontalAlignOffsetPercent = NaN;
			//			_indicesInViewChanged = true;
			invalidateTargetDisplayList();
		}    
		
		
		//----------------------------------
		//  verticalAlignOffset
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for verticalAlignOffset.
		 */
		private var _verticalAlignOffset:Number = 0;
		
		[Inspectable(category="General", defaultValue="0")]
		/**
		 *	The offset in pixels to be used in conjunction with <code>verticalAlign</code>
		 *	to set the vertical position of the selected element in the viewport. All other elements
		 *	are positioned around this element.
		 * 
		 *	<p>If <code>verticalAlignOffsetPercent</code> is set after this property,
		 *	this property is set automatically depending on the value of <code>verticalAlignOffsetPercent</code>.</p>
		 * 
		 *  @default 0
		 * 
		 * 	@see #verticalAlign
		 * 	@see #verticalAlignOffsetPercent
		 * 	@see spark.layouts.VerticalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get verticalAlignOffset():Number
		{
			return _verticalAlignOffset;
		}
		/**
		 *  @private
		 */
		public function set verticalAlignOffset(value:Number):void
		{
			if( _verticalAlignOffset == value ) return;
			
			_verticalAlignOffset = value;
			_verticalAlignOffsetPercent = NaN;
			//			_indicesInViewChanged = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  horizontalAlignOffsetPercent
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for horizontalAlignOffsetPercent.
		 */
		private var _horizontalAlignOffsetPercent:Number = 0;
		
		[Inspectable(category="General", defaultValue="0")]
		/**
		 *	The offset as a percentage of the unscaled width of the viewport
		 *  to be used in conjunction with <code>horizontalAlign</code> to set the horizontal
		 *	position of the selected element in the viewport. All other elements are
		 * 	positioned around this element.
		 * 
		 *	<p>Setting this property overrides any value set on <code>horizontalAlignOffset</code>.</p>
		 * 
		 *  @default 0
		 * 
		 * 	@see #horizontalAlign
		 * 	@see #horizontalAlignOffset
		 * 	@see spark.layouts.HorizontalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get horizontalAlignOffsetPercent():Number
		{
			return _horizontalAlignOffsetPercent;
		}
		/**
		 *  @private
		 */
		public function set horizontalAlignOffsetPercent(value:Number):void
		{
			if( _horizontalAlignOffsetPercent == value ) return;
			
			_horizontalAlignOffsetPercent = value;
			if( !isNaN( _horizontalAlignOffsetPercent ) ) _horizontalAlignOffset = unscaledHeight * ( _horizontalAlignOffsetPercent / 100 );
			//			_indicesInViewChanged = true;
			invalidateTargetDisplayList();
		}    
		
		
		//----------------------------------
		//  verticalAlignOffsetPercent
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for verticalAlignOffsetPercent.
		 */
		private var _verticalAlignOffsetPercent:Number = 0;
		
		[Inspectable(category="General", defaultValue="0")]
		/**
		 *	The offset as a percentage of the unscaled height of the viewport
		 *  to be used in conjunction with <code>verticalAlign</code> to set the vertical
		 *	position of the selected element in the viewport. All other elements are
		 * 	positioned around this element.
		 * 
		 *	<p>Setting this property overrides any value set on <code>verticalAlignOffset</code>.</p>
		 * 
		 *  @default 0
		 * 
		 * 	@see #verticalAlign
		 * 	@see #verticalAlignOffset
		 * 	@see spark.layouts.VerticalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get verticalAlignOffsetPercent():Number
		{
			return _verticalAlignOffsetPercent;
		}
		/**
		 *  @private
		 */
		public function set verticalAlignOffsetPercent(value:Number):void
		{
			if( _verticalAlignOffsetPercent == value ) return;
			
			_verticalAlignOffsetPercent = value;
			if( !isNaN( _verticalAlignOffsetPercent ) ) _verticalAlignOffset = unscaledHeight * ( _verticalAlignOffsetPercent / 100 );
			//			_indicesInViewChanged = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  elementHorizontalAlign
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for elementHorizontalAlign.
		 */
		private var _elementHorizontalAlign:String = HorizontalAlign.CENTER;
		
		/**
		 *  @private
		 *  Flag to indicate the elementHorizontalAlign property has changed.
		 */
		private var _elementHorizontalAlignChange		: Boolean = true;
		
		[Inspectable(category="General", enumeration="left,right,center", defaultValue="center")]
		/**
		 *	The horizontal transform point of elements.
		 * 
		 *	<p>Valid values are <code>HorizontalAlign.LEFT</code>, <code>HorizontalAlign.CENTER</code>
		 *	and <code>HorizontalAlign.RIGHT</code>.</p>
		 * 
		 *  @default "center"
		 * 
		 * 	@see spark.layouts.HorizontalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get elementHorizontalAlign():String
		{
			return _elementHorizontalAlign;
		}
		/**
		 *  @private
		 */
		public function set elementHorizontalAlign(value:String):void
		{
			if( value == _elementHorizontalAlign ) return;
			
			_elementHorizontalAlign = value;
			_elementHorizontalAlignChange = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  elementVerticalAlign
		//----------------------------------  
		
		/**
		 *  @private
		 *  Storage property for elementVerticalAlign.
		 */
		private var _elementVerticalAlign:String = VerticalAlign.MIDDLE;
		
		/**
		 *  @private
		 *  Flag to indicate the elementVerticalAlign property has changed.
		 */
		private var _elementVerticalAlignChange			: Boolean = true;
		
		[Inspectable(category="General", enumeration="top,bottom,middle", defaultValue="middle")]
		/**
		 *	The vertical transform point of elements.
		 * 
		 *	<p>Valid values are <code>VerticalAlign.TOP</code>, <code>VerticalAlign.MIDDLE</code>
		 *	and <code>VerticalAlign.BOTTOM</code>.</p>
		 * 
		 *  @default "middle"
		 * 
		 * 	@see spark.layouts.VerticalAlign
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get elementVerticalAlign():String
		{
			return _elementVerticalAlign;
		}
		/**
		 *  @private
		 */
		public function set elementVerticalAlign(value:String):void
		{
			if( value == _elementVerticalAlign ) return;
			
			_elementVerticalAlign = value;
			_elementVerticalAlignChange = true;
			invalidateTargetDisplayList();
		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	@private
		 * 
		 *	Positions, transforms and sets the size of an element
		 *  that will be visible in the layout.
		 */
		protected function updateVisibleElementAt( element:IVisualElement, index:int ):void
		{
			_displayedElements.push( element );
			
			setElementLayoutBoundsSize( element, false );
			
			_transformCalculator.updateForIndex( index, element, element.width, element.height, _elementHorizontalCenterMultiplier, _elementVerticalCenterMultiplier );
			
			//			elementTransformAround( element );
			applyColorTransformToElement( element, _transformCalculator.colorTransform );
			element.visible = true;
		}
		
		/**
		 *	@private
		 */
//		private function sortElementsByZ( a:IVisualElement, b:IVisualElement ):int
//		{
//			if( getZ( a ) > getZ( b ) )
//			{
//				return -1;
//			}
//			else if( getZ( a ) < getZ( b ) )
//			{
//				return 1;
//			}
//			
//			return 0;
//		}
//		
//		/**
//		 *	@private
//		 * 
//		 *	Util function to return the value of the z property
//		 *  on an element.
//		 */
//		private function getZ( e:IVisualElement ):Number
//		{
//			if( e is GraphicElement )
//			{
//				return GraphicElement( e ).z;
//			}
//			else
//			{
//				return UIComponent( e ).z;
//			}
//		}
		
		/**
		 *	@private
		 * 
		 *	Sets the depth of elements inlcuded in the layout at depths
		 *	to display correctly for the z position set with transformAround.
		 * 
		 *	Also sets the depth of elements that are not included in the layout.
		 *	The depth of these is dependent on whether their element index is before
		 *	or after the index of the selected element.
		 * 
		 *	- If their element index is before the selected elements index
		 *   they appear beneath all items included in the layout.
		 * 
		 *	- If their element index is after the selected elements index
		 *   they appear above all items included in the layout
		 */
		private function updateDepths( depths:Vector.<int> ):void
		{
			if( !depths || !depths.length ) return;
			
			var animationIndex:int = Math.max( 0, Math.min( Math.round( animationValue ), numElementsInLayout - 1 ) );
			
			var element:IVisualElement;
			var index:int;
			var i:int
			var numBeforeMinDepth:int = 0;
			var minDepth:int = depths[ 0 ] - 1;
			var maxDepth:int = depths[ depths.length - 1 ] + 1;
			
			const elements:Vector.<IVisualElement> = new Vector.<IVisualElement>();
			for( i = firstIndexInView; i <= lastIndexInView; i++ )
			{
				index = indicesInLayout[ i ];
				element = target.getElementAt( index );
				element.depth = ( i > animationIndex ) ? -i : i;
				if( !element ) continue;
				elements.push( element );
			}
			
//			trace( "did srt", elements.length );
			
//			elements.sort( sortElementsByZ );
//			var num:int = elements.length;
//			for( i = 0; i < num; i++ )
//			{
//				elements[ i ].depth = depths[ i ];
//			}
			
			target.validateNow();
			//			for( i = firstIndexInView; i <= lastIndexInView; i++ )
			//			{
			//				index = indicesInLayout[ i ];
			//				element = target.getElementAt( index );
			//				if( !element ) continue;
			//				if( index <  indicesInLayout[ animationIndex ] )
			//				{
			//					element.depth = _transformCalculator.radiusZ > -1 ? depths.shift() : depths.pop();
			//				}
			////				else if ( index > indicesInLayout[ animationIndex ] )
			////				{
			////					element.depth = _direction == SemiCarouselLayoutDirection.CONVEX ? depths.pop() : depths.shift();
			////				}
			//				else
			//				{
			//					element.depth = _transformCalculator.radiusZ > -1 ? depths.pop() : depths.shift();
			//				}
			//			}
			//			
			//			
			//			var numElementsNotInLayout:int = indicesNotInLayout.length;
			//			for( i = 0; i < numElementsNotInLayout; i++ )
			//			{
			//				if( indicesNotInLayout[ i ] > indicesInLayout[ animationIndex ] )
			//				{
			//					break;
			//				}
			//				else
			//				{
			//					numBeforeMinDepth++;
			//				}
			//			}
			//			
			//			minDepth -= numBeforeMinDepth - 1;
			//			for( i = 0; i < numElementsNotInLayout; i++ )
			//			{
			//				element = target.getElementAt( indicesNotInLayout[ i ] );
			//				if( !element ) continue;
			//				if( indicesNotInLayout[ i ] > indicesInLayout[ animationIndex ] )
			//				{
			//					element.depth = maxDepth;
			//					maxDepth++;
			//				}
			//				else
			//				{
			//					element.depth = minDepth;
			//					minDepth++;
			//				}
			//			}
			//			
			//			target.validateNow();
		}
		
		/**
		 *	@private
		 * 
		 *	A convenience method used to transform an element by applying
		 *  the current values if the TransforCalulator instance.
		 */
		//		private function elementTransformAround( element:IVisualElement ):void
		//		{
		//			var halfWidth:Number = element.width / 2;
		//			var halfHeight:Number = element.height / 2;
		//			var offsetX:Number = halfWidth * ( _elementHorizontalCenterMultiplier - 0.5 ) * 2;
		//			var offsetY:Number = halfHeight * ( _elementVerticalCenterMultiplier - 0.5 ) * 2;
		//			
		//			element.transformAround( new Vector3D( element.width / 2, element.height / 2, 0 ),
		//				null,
		//				null,
		//				new Vector3D( _transformCalculator.x - offsetX, _transformCalculator.y - offsetY, _transformCalculator.z ),
		//				null,
		//				new Vector3D( _transformCalculator.xRotation, _transformCalculator.yRotation, 0 ),
		//				new Vector3D( _transformCalculator.x - offsetX, _transformCalculator.y - offsetY, _transformCalculator.z ),
		//				false );
		//			
		//		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override public function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number):void
		{
			//			if( this.unscaledWidth != unscaledWidth || this.unscaledHeight != unscaledHeight ) _sizeChanged = true;
			
			if( _horizontalAlignChange )
			{
				_horizontalAlignChange = false;
				//				_indicesInViewChanged = true;
				
				switch( _horizontalAlign )
				{
					case HorizontalAlign.LEFT :
					{
						_horizontalCenterMultiplier = 0;
						break;
					}
					case HorizontalAlign.RIGHT :
					{
						_horizontalCenterMultiplier = 1;
						break;
					}
					default :
					{
						_horizontalCenterMultiplier = 0.5;
					}
				}
			}
			
			if( _verticalAlignChange )
			{
				_verticalAlignChange = false;
				//				_indicesInViewChanged = true;
				
				switch( _verticalAlign )
				{
					case VerticalAlign.TOP :
					{
						_verticalCenterMultiplier = 0;
						break;
					}
					case VerticalAlign.BOTTOM :
					{
						_verticalCenterMultiplier = 1;
						break;
					}
					default :
					{
						_verticalCenterMultiplier = 0.5;
					}
				}
			}
			
			if( _elementHorizontalAlignChange )
			{
				_elementHorizontalAlignChange = false;
				//				_indicesInViewChanged = true;
				
				switch( _elementHorizontalAlign )
				{
					case HorizontalAlign.LEFT :
					{
						_elementHorizontalCenterMultiplier = 0;
						break;
					}
					case HorizontalAlign.RIGHT :
					{
						_elementHorizontalCenterMultiplier = 1;
						break;
					}
					default :
					{
						_elementHorizontalCenterMultiplier = 0.5;
					}
				}
			}
			
			if( _elementVerticalAlignChange )
			{
				_elementVerticalAlignChange = false;
				//				_indicesInViewChanged = true;
				
				switch( _elementVerticalAlign )
				{
					case VerticalAlign.TOP :
					{
						_elementVerticalCenterMultiplier = 0;
						break;
					}
					case VerticalAlign.BOTTOM :
					{
						_elementVerticalCenterMultiplier = 1;
						break;
					}
					default :
					{
						_elementVerticalCenterMultiplier = 0.5;
					}
				}
			}
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateDisplayListBetween():void
		{
			super.updateDisplayListBetween();
			
			if( sizeChangedInLayoutPass )
			{
				//				_indicesInViewChanged = true;
				if( !isNaN( _horizontalAlignOffsetPercent ) ) _horizontalAlignOffset = unscaledHeight * ( _horizontalAlignOffsetPercent / 100 );
				if( !isNaN( _verticalAlignOffsetPercent ) ) _verticalAlignOffset = unscaledHeight * ( _verticalAlignOffsetPercent / 100 );
			}
			
			_transformCalculator.updateForLayoutPass( _horizontalCenterMultiplier, _verticalCenterMultiplier, _rotationX, _rotationY );
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateDisplayListVirtual():void
		{
			super.updateDisplayListVirtual();
			
			
			var element:IVisualElement;
			var depths:Vector.<int> = new Vector.<int>();
			
			for each( element in _displayedElements )
			{
				element.visible = false;
			}
			
			_displayedElements = new Vector.<IVisualElement>();
			for( var i:int = firstIndexInView; i <= lastIndexInView; i++ )
			{
				element = target.getVirtualElementAt( indicesInLayout[ i ] );
				depths.push( indicesInLayout[ i ] );
				updateVisibleElementAt( element, i );
			}
			
			updateDepths( depths );
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateDisplayListReal():void
		{
			super.updateDisplayListReal();
			
			var element:IVisualElement;
			var depths:Vector.<int> = new Vector.<int>();
			
			_displayedElements = new Vector.<IVisualElement>();
			
			for( var i:int = 0; i < numElementsInLayout; i++ )
			{
				element = target.getElementAt( indicesInLayout[ i ] );
				if( i >= firstIndexInView && i <= lastIndexInView )
				{
					depths.push( indicesInLayout[ i ] );
					updateVisibleElementAt( element, i);
				}
				else
				{
					element.visible = false;
				}
			}
			
			updateDepths( depths );
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function restoreElement( element:IVisualElement ):void
		{
			super.restoreElement( element );
			
			var vector:Vector3D = new Vector3D( 0, 0, 0 );
			element.visible = true;
			element.depth = 0;
			element.transformAround( vector, null, null, vector, null, null, vector, false );
			applyColorTransformToElement( element, new ColorTransform() );
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateIndicesInView():void
		{
			super.updateIndicesInView();
			
			if( _numUnselectedElements > 0 )
			{
				const ceilIndex:int = Math.ceil( animationValue );
				const floorIndex:int = Math.floor( animationValue );
				const firstIndexInView:int = Math.max( ceilIndex - _numUnselectedElements, 0 );
				
				var numIndicesInView:int = ( _numUnselectedElements * 2 ) + 1; 
				// If the number of elements on the left are less than _numUnselectedElements
				if( floorIndex < _numUnselectedElements )
				{
					numIndicesInView -= _numUnselectedElements - floorIndex;
				}
					// If we are mid transition, we don't need the last item
				else if( floorIndex != animationValue )
				{
					numIndicesInView -= 1;
				}
				
				// If we are at the end of the list of elements
				if( floorIndex + _numUnselectedElements >= numElementsInLayout )
				{
					numIndicesInView -= _numUnselectedElements - ( ( numElementsInLayout - 1 ) - floorIndex );
				}
				
				indicesInView( firstIndexInView, numIndicesInView );
			}
			else
			{
				indicesInView( 0, numElementsInLayout );
			}
		}
		
		
	}
}



import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Vector3D;

import mx.core.IVisualElement;

import ws.tink.spark.layouts.CoverflowLayout;


internal class TransformValues
{
	
	
	
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
	public function TransformValues( layout:CoverflowLayout )
	{
		_layout = layout;
		_colorTransform = new ColorTransform();
	}
	
	
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	private var _layout			: CoverflowLayout;
	
	private var _index			: int;
	private var _indexOffset	: Number;
	
	// Center
	private var _cx				: Number;
	private var _cy				: Number;
	
	// AlignOffset
	private var _ho				: Number;
	private var _vo				: Number;
	
	private var _layoutFunction				: Function;
	
	// Number of items
	private var _ni				: Number;
//	private var _an				: Number;
	
	private var _c				: int;
	private var _ca				: Number;
	
	private var _rotY				: int;
	private var _rotX				: int;
	
	private var _oy:Number;
	private var _ox:Number;
	
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  x
	//----------------------------------  
	
	/**
	 *  @private
	 *  Storage property for x.
	 */
	private var _x:Number;
	
	//	/**
	//	 *	x
	//	 * 
	//	 *  @langversion 3.0
	//	 *  @playerversion Flash 10
	//	 *  @playerversion AIR 1.5
	//	 *  @productversion Flex 4
	//	 */
	//	public function get x():Number
	//	{
	//		return _x;
	//	}
	
	
	//----------------------------------
	//  y
	//----------------------------------  
	
	/**
	 *  @private
	 *  Storage property for y.
	 */
	private var _y:Number;
	
	//	/**
	//	 *	y
	//	 * 
	//	 *  @langversion 3.0
	//	 *  @playerversion Flash 10
	//	 *  @playerversion AIR 1.5
	//	 *  @productversion Flex 4
	//	 */
	//	public function get y():Number
	//	{
	//		return _y;
	//	}
	
	
	//----------------------------------
	//  z
	//----------------------------------  
	
	/**
	 *  @private
	 *  Storage property for z.
	 */
	private var _z:Number;
	
	//	/**
	//	 *	z
	//	 * 
	//	 *  @langversion 3.0
	//	 *  @playerversion Flash 10
	//	 *  @playerversion AIR 1.5
	//	 *  @productversion Flex 4
	//	 */
	//	public function get z():Number
	//	{
	//		return _z;
	//	}
	
	
	//----------------------------------
	//  xRotation
	//----------------------------------  
	
	/**
	 *  @private
	 *  Storage property for xRotation.
	 */
	private var _xRotation:Number;
	
	//	/**
	//	 *	xRotation
	//	 * 
	//	 *  @langversion 3.0
	//	 *  @playerversion Flash 10
	//	 *  @playerversion AIR 1.5
	//	 *  @productversion Flex 4
	//	 */
	//	public function get xRotation():Number
	//	{
	//		return _xRotation;
	//	}
	
	
	//----------------------------------
	//  yRotation
	//----------------------------------  
	
	/**
	 *  @private
	 *  Storage property for yRotation.
	 */
	private var _yRotation:Number;
	
	/**
	 *	yRotation
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	//	public function get yRotation():Number
	//	{
	//		return _yRotation;
	//	}
	//	
	//	
	
	
	//----------------------------------
	//  colorTransform
	//----------------------------------  
	
	/**
	 *  @private
	 *  Storage property for colorTransform.
	 */
	private var _colorTransform:ColorTransform;
	
	/**
	 *	colorTransform
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function get colorTransform():ColorTransform
	{
		return _colorTransform;
	}
	
	
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	updateForLayoutPass
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function updateForLayoutPass( centerMultiplierX:Number, centerMultiplierY:Number, rotX:int, rotY:int ):void
	{
		_index = Math.floor( _layout.animationValue );
		_indexOffset = _layout.animationValue - _index;
		
		
		_cx = _layout.unscaledWidth * centerMultiplierX;
		_cy = _layout.unscaledHeight * centerMultiplierY;
		
		_ho = _layout.horizontalAlignOffset;
		_vo = _layout.verticalAlignOffset;
		
		_c = _layout.depthColor;
		_ca = _layout.depthColorAlpha / 100;
		
		if( _c < 0 )
		{
			_colorTransform.redMultiplier = _colorTransform.greenMultiplier = _colorTransform.blueMultiplier = 1;
			_colorTransform.redOffset = _colorTransform.greenOffset = _colorTransform.blueOffset = _colorTransform.alphaOffset = 0;
		}
		
		_rotY = rotY;
		_rotX = -rotX;
		
		const numElements:int = _layout.numUnselectedElements < 0 ? 0 : _layout.numUnselectedElements;
		//		_ni = _layout.numUnselectedElements;
		
		//		switch( _layout.layoutType )
		//		{
		//			case SemiCarouselLayoutType.CIRCULAR :
		//			{
//		_an = numElements ? _layout.angle / ( numElements * 2 ) : _layout.angle / _layout.numElementsInLayout;//360/ _layout.numElementsInLayout//_layout.numUnselectedElements ? _layout.angle / ( ( _layout.numUnselectedElements * 2 )  ) : _layout.angle;//3
		_layoutFunction = circular;
		//				break;
		//			}
		//			case SemiCarouselLayoutType.LINEAR :
		//			{
		//				_layoutFunction = linear;
		//				break;
		//			}
		//		}
	}
	
	/**
	 *	circular
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	private function circular( index:Number ):void
	{
		var o:Number = Math.max( -1, Math.min( 1, index ) );
		
		var displacement:Number;
		
		_yRotation = _rotY * o;
		_xRotation = _rotX * o;
		
		if(  Math.abs( index ) > 1 )
		{
			var dir:Number = index < 0 ? index + 1 : index - 1;
			_x = _cx + _ho + ( _layout.selectedHorizontalDisplacement * o ) + ( _layout.horizontalDisplacement * dir );
			_y = _cy + _vo + ( _layout.selectedVerticalDisplacement * o ) + ( _layout.verticalDisplacement * dir );
		}
		else
		{
			_x = _cx + _ho + ( _layout.selectedHorizontalDisplacement * index );
			_y = _cy + _vo + ( _layout.selectedVerticalDisplacement * index );
		}
//		displacement = Math.abs( index ) > 1 ? _layout.horizontalDisplacement : _layout.selectedHorizontalDisplacement;
//		_x = _cx + _ho + ( displacement * index );
//		
//		displacement = Math.abs( o ) > 1 ? _layout.verticalDisplacement : _layout.selectedVerticalDisplacement;
		
		
		_z = _layout.maximumZ * Math.abs( o );
	}
	
	
	
	/**
	 *	updateForIndex
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function updateForIndex( i:int, element:IVisualElement, width:Number, height:Number, hMultiplier:Number, vMultiplier:Number ):void
	{
		//		var halfWidth:Number = element.width / 2;
		//		var halfHeight:Number = element.height / 2;
		_ox = ( width / 2 ) * ( hMultiplier - 0.5 ) * 2;
		_oy = ( height / 2 ) * ( vMultiplier - 0.5 ) * 2;
		
		//		trace( _ox );
		
		_layoutFunction( ( i - _index ) - _indexOffset );
		
		if( _c > -1 )
		{
//			const radian:Number = ( _layout.angle / 2 ) * Math.PI / 180;
//			const maxDepth:Number = _rz - ( Math.cos( radian ) * _rz )
			const v:Number = ( _z / _layout.maximumZ ) * _ca;
//			
			_colorTransform.color = _c;
			_colorTransform.redOffset *= v;
			_colorTransform.greenOffset *= v;
			_colorTransform.blueOffset *= v;
			_colorTransform.redMultiplier = _colorTransform.greenMultiplier = _colorTransform.blueMultiplier = 1 - v;
		}
		
		element.transformAround( new Vector3D( width / 2, height / 2, 0 ),
			null,
			null,
			new Vector3D( _x - _ox, _y - _oy, _z ),
			null,
			new Vector3D( _xRotation, _yRotation, 0 ),
			new Vector3D( _x - _ox, _y - _oy, _z ),
			false );
	}
}
//package ws.tink.spark.layouts
//{
//	import flash.display.DisplayObject;
//	import flash.geom.Matrix;
//	import flash.geom.Matrix3D;
//	import flash.geom.Point;
//	import flash.geom.Rectangle;
//	import flash.geom.Vector3D;
//	
//	import mx.core.FlexGlobals;
//	import mx.core.ILayoutElement;
//	import mx.core.IVisualElement;
//	
//	import spark.components.Scroller;
//	import spark.layouts.HorizontalAlign;
//	import spark.layouts.VerticalAlign;
//	import spark.layouts.supportClasses.LayoutBase;
//	
//	import ws.tink.spark.layouts.supportClasses.AnimationNavigatorLayoutBase;
//	import ws.tink.spark.layouts.supportClasses.PerspectiveAnimationNavigatorLayoutBase;
//	import ws.tink.spark.layouts.supportClasses.PerspectiveNavigatorLayoutBase;
//
//	/**
//	 * Flex 4 Time Machine Layout
//	 */
//	public class CoverflowLayout extends PerspectiveAnimationNavigatorLayoutBase
//	{
//
//		
//		
//		
//		
//		
//		//--------------------------------------------------------------------------
//		//
//		//  Constructor
//		//
//		//--------------------------------------------------------------------------
//		
//		/**
//		 *  Constructor. 
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */  
//		public function CoverflowLayout()
//		{
//			super( AnimationNavigatorLayoutBase.INDIRECT );
//			
//			_transformCalculator = new TransformValues( this );
//			_horizontalIndicesInView = new IndicesInView( this );
//			_verticalIndicesInView = new IndicesInView( this );
//		}
//
//		
//		
//		//--------------------------------------------------------------------------
//		//
//		//  Variables
//		//
//		//--------------------------------------------------------------------------
//		
//		private var _transformCalculator		: TransformValues;
//		
//		public var _horizontalIndicesInView	: IndicesInView;
//		private var _verticalIndicesInView		: IndicesInView;
//		private var _indicesInView				: IndicesInView;
//		private var _indicesInViewChanged		: Boolean;
////		private var _sizeChanged				: Boolean;
//		
//		private var _horizontalAlignChange		: Boolean = true;
//		private var _verticalAlignChange		: Boolean = true;
//		
//		private var _horizontalCenterMultiplier	: Number;
//		private var _verticalCenterMultiplier	: Number;
//		
//		private var _elementHorizontalAlignChange	: Boolean = true;
//		private var _elementVerticalAlignChange		: Boolean = true;
//		
//		private var _elementHorizontalCenterMultiplier	: Number;
//		private var _elementVerticalCenterMultiplier	: Number;
//		
//		
//		
//		//--------------------------------------------------------------------------
//		//
//		//  Properties
//		//
//		//--------------------------------------------------------------------------
//		
//		//----------------------------------
//		//  horizontalAlign
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for horizontalAlign.
//		 */
//		private var _horizontalAlign:String = HorizontalAlign.CENTER;
//		
//		[Inspectable(category="General", enumeration="left,right,center", defaultValue="center")]
//		/**
//		 *  horizontalAlign
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get horizontalAlign():String
//		{
//			return _horizontalAlign;
//		}
//		/**
//		 *  @private
//		 */
//		public function set horizontalAlign(value:String):void
//		{
//			if( value == _horizontalAlign ) return;
//			
//			_horizontalAlign = value;
//			_horizontalAlignChange = true;
//			invalidateTargetDisplayList();
//		}
//		
//		
//		//----------------------------------
//		//  verticalAlign
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for verticalAlign.
//		 */
//		private var _verticalAlign:String = VerticalAlign.MIDDLE;
//		
//		[Inspectable(category="General", enumeration="top,bottom,middle", defaultValue="middle")]
//		/**
//		 *  verticalAlign
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get verticalAlign():String
//		{
//			return _verticalAlign;
//		}
//		/**
//		 *  @private
//		 */
//		public function set verticalAlign(value:String):void
//		{
//			if( value == _verticalAlign ) return;
//			
//			_verticalAlign = value;
//			_verticalAlignChange = true;
//			invalidateTargetDisplayList();
//		}
//		
//		
//		//----------------------------------
//		//  horizontalAlignOffset
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for horizontalAlignOffset.
//		 */
//		private var _horizontalAlignOffset:Number = 0;
//		
//		[Inspectable(category="General", defaultValue="0")]
//		/**
//		 *  horizontalAlignOffset
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get horizontalAlignOffset():Number
//		{
//			return _horizontalAlignOffset;
//		}
//		/**
//		 *  @private
//		 */
//		public function set horizontalAlignOffset(value:Number):void
//		{
//			if( _horizontalAlignOffset == value ) return;
//			
//			_horizontalAlignOffset = value;
//			_horizontalAlignOffsetPercent = NaN;
//			_indicesInViewChanged = true;
//			invalidateTargetDisplayList();
//		}    
//		
//		
//		//----------------------------------
//		//  verticalAlignOffset
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for verticalAlignOffset.
//		 */
//		private var _verticalAlignOffset:Number = 0;
//		
//		[Inspectable(category="General", defaultValue="0")]
//		
//		/**
//		 *  verticalAlignOffset
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get verticalAlignOffset():Number
//		{
//			return _verticalAlignOffset;
//		}
//		/**
//		 *  @private
//		 */
//		public function set verticalAlignOffset(value:Number):void
//		{
//			if( _verticalAlignOffset == value ) return;
//			
//			_verticalAlignOffset = value;
//			_verticalAlignOffsetPercent = NaN;
//			_indicesInViewChanged = true;
//			invalidateTargetDisplayList();
//		}
//		
//		
//		//----------------------------------
//		//  horizontalAlignOffsetPercent
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for horizontalAlignOffsetPercent.
//		 */
//		private var _horizontalAlignOffsetPercent:Number = 0;
//		
//		[Inspectable(category="General", defaultValue="0")]
//		/**
//		 *  horizontalAlignOffsetPercent
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get horizontalAlignOffsetPercent():Number
//		{
//			return _horizontalAlignOffsetPercent;
//		}
//		/**
//		 *  @private
//		 */
//		public function set horizontalAlignOffsetPercent(value:Number):void
//		{
//			if( _horizontalAlignOffsetPercent == value ) return;
//			
//			_horizontalAlignOffsetPercent = value;
//			if( !isNaN( _horizontalAlignOffsetPercent ) ) _horizontalAlignOffset = unscaledHeight * ( _horizontalAlignOffsetPercent / 100 );
//			_indicesInViewChanged = true;
//			invalidateTargetDisplayList();
//		}    
//		
//		
//		//----------------------------------
//		//  verticalAlignOffsetPercent
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for verticalAlignOffsetPercent.
//		 */
//		private var _verticalAlignOffsetPercent:Number = 0;
//		
//		[Inspectable(category="General", defaultValue="0")]
//		/**
//		 *  verticalAlignOffsetPercent
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get verticalAlignOffsetPercent():Number
//		{
//			return _verticalAlignOffsetPercent;
//		}
//		/**
//		 *  @private
//		 */
//		public function set verticalAlignOffsetPercent(value:Number):void
//		{
//			if( _verticalAlignOffsetPercent == value ) return;
//			
//			_verticalAlignOffsetPercent = value;
//			if( !isNaN( _verticalAlignOffsetPercent ) ) _verticalAlignOffset = unscaledHeight * ( _verticalAlignOffsetPercent / 100 );
//			_indicesInViewChanged = true;
//			invalidateTargetDisplayList();
//		}
//		
//		
//		//----------------------------------
//		//  buttonRotation
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for elementHorizontalAlign.
//		 */
//		private var _elementHorizontalAlign:String = HorizontalAlign.CENTER;
//		
//		[Inspectable(category="General", enumeration="left,right,center", defaultValue="center")]
//		/**
//		 *  elementHorizontalAlign
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get elementHorizontalAlign():String
//		{
//			return _elementHorizontalAlign;
//		}
//		/**
//		 *  @private
//		 */
//		public function set elementHorizontalAlign(value:String):void
//		{
//			if( value == _elementHorizontalAlign ) return;
//			
//			_elementHorizontalAlign = value;
//			_elementHorizontalAlignChange = true;
//			invalidateTargetDisplayList();
//		}
//		
//		
//		//----------------------------------
//		//  elementVerticalAlign
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for elementVerticalAlign.
//		 */
//		private var _elementVerticalAlign:String = VerticalAlign.MIDDLE;
//		
//		[Inspectable(category="General", enumeration="top,bottom,middle", defaultValue="middle")]
//		/**
//		 *  elementVerticalAlign
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get elementVerticalAlign():String
//		{
//			return _elementVerticalAlign;
//		}
//		/**
//		 *  @private
//		 */
//		public function set elementVerticalAlign(value:String):void
//		{
//			if( value == _elementVerticalAlign ) return;
//			
//			_elementVerticalAlign = value;
//			_elementVerticalAlignChange = true;
//			invalidateTargetDisplayList();
//		}
//		
//		
//		//----------------------------------
//		//  horizontalDisplacement
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for horizontalDisplacement.
//		 */
//		private var _horizontalDisplacement:Number = 100;
//		
//		[Inspectable(category="General", defaultValue="100")]
//		/**
//		 *  horizontalDisplacement
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get horizontalDisplacement() : Number
//		{
//			return _horizontalDisplacement;
//		}
//		/**
//		 *  @private
//		 */
//		public function set horizontalDisplacement( value : Number ) : void
//		{
//			if( _horizontalDisplacement == value ) return
//				
//				_horizontalDisplacement = value;
//			_indicesInViewChanged = true;
//			invalidateTargetDisplayList();
//		}
//		
//		
//		//----------------------------------
//		//  selectedHorizontalDisplacement
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for selectedHorizontalDisplacement.
//		 */
//		private var _selectedHorizontalDisplacement:Number = 100;
//		
//		[Inspectable(category="General", defaultValue="100")]
//		/**
//		 *  selectedHorizontalDisplacement
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get selectedHorizontalDisplacement() : Number
//		{
//			return _selectedHorizontalDisplacement;
//		}
//		/**
//		 *  @private
//		 */
//		public function set selectedHorizontalDisplacement( value:Number ) : void
//		{
//			if( _selectedHorizontalDisplacement == value ) return
//				
//				_selectedHorizontalDisplacement = value;
//			_indicesInViewChanged = true;
//			invalidateTargetDisplayList();
//		}
//		
//		
//		//----------------------------------
//		//  verticalDisplacement
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for verticalDisplacement.
//		 */
//		private var _verticalDisplacement:Number = 0;
//		
//		[Inspectable(category="General", defaultValue="0")]
//		/**
//		 *  verticalDisplacement
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get verticalDisplacement() : Number
//		{
//			return _verticalDisplacement;
//		}
//		/**
//		 *  @private
//		 */
//		public function set verticalDisplacement( value:Number ):void
//		{
//			if( _verticalDisplacement == value ) return;
//			
//			_verticalDisplacement = value;
//			_indicesInViewChanged = true;
//			invalidateTargetDisplayList();
//		}
//		
//		
//		//----------------------------------
//		//  selectedVerticalDisplacement
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for selectedVerticalDisplacement.
//		 */
//		private var _selectedVerticalDisplacement:Number = 0;
//		
//		[Inspectable(category="General", defaultValue="0")]
//		/**
//		 *  selectedVerticalDisplacement
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get selectedVerticalDisplacement() : Number
//		{
//			return _selectedVerticalDisplacement;
//		}
//		/**
//		 *  @private
//		 */
//		public function set selectedVerticalDisplacement( value:Number ) : void
//		{
//			if( _selectedVerticalDisplacement == value ) return
//				
//				_selectedVerticalDisplacement = value;
//			_indicesInViewChanged = true;
//			invalidateTargetDisplayList();
//		}
//		
//		
//		//----------------------------------
//		//  rotationX
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for rotationX.
//		 */
//		private var _rotationX		: Number = 0;
//		
//		[Inspectable(category="General", defaultValue="0")]
//		/**
//		 *  rotationX
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get rotationX():Number
//		{
//			return _rotationX;
//		}
//		/**
//		 *  @private
//		 */
//		public function set rotationX( value:Number ):void
//		{
//			if( _rotationX == value ) return;
//			
//			_rotationX = value;
//			invalidateTargetDisplayList();
//		}
//		
//		
//		//----------------------------------
//		//  rotationY
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for rotationY.
//		 */
//		private var _rotationY		: Number = 45;
//		
//		[Inspectable(category="General", defaultValue="45")]
//		/**
//		 *  rotationY
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get rotationY():Number
//		{
//			return _rotationY;
//		}
//		/**
//		 *  @private
//		 */
//		public function set rotationY( value:Number ):void
//		{
//			if( _rotationY == value ) return;
//			
//			_rotationY = value;
//			invalidateTargetDisplayList();
//		}
//		
//		
//		//----------------------------------
//		//  maximumZ
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for maximumZ.
//		 */
//		private var _maximumZ				: Number = 100;
//		
//		[Inspectable(category="General", defaultValue="100")]
//		/**
//		 *  maximumZ
//		 *
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get maximumZ() : Number
//		{
//			return _maximumZ;
//		}
//		/**
//		 *  @private
//		 */
//		public function set maximumZ( value : Number ) : void
//		{
//			if( _maximumZ == value ) return;
//			
//			_maximumZ = value;
//			_indicesInViewChanged = true;
//			invalidateTargetDisplayList();
//		}
//		
//
//		
//		//--------------------------------------------------------------------------
//		//
//		//  Overridden Methods
//		//
//		//--------------------------------------------------------------------------
//		
//		/**
//		 *  @inheritDoc
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		override public function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number):void
//		{
////			if( this.unscaledWidth != unscaledWidth || this.unscaledHeight != unscaledHeight ) _sizeChanged = true;
//			
//			if( _horizontalAlignChange )
//			{
//				_horizontalAlignChange = false;
//				_indicesInViewChanged = true;
//				
//				switch( _horizontalAlign )
//				{
//					case HorizontalAlign.LEFT :
//					{
//						_horizontalCenterMultiplier = 0;
//						break;
//					}
//					case HorizontalAlign.RIGHT :
//					{
//						_horizontalCenterMultiplier = 1;
//						break;
//					}
//					default :
//					{
//						_horizontalCenterMultiplier = 0.5;
//					}
//				}
//			}
//			
//			if( _verticalAlignChange )
//			{
//				_verticalAlignChange = false;
//				_indicesInViewChanged = true;
//				
//				switch( _verticalAlign )
//				{
//					case VerticalAlign.TOP :
//					{
//						_verticalCenterMultiplier = 0;
//						break;
//					}
//					case VerticalAlign.BOTTOM :
//					{
//						_verticalCenterMultiplier = 1;
//						break;
//					}
//					default :
//					{
//						_verticalCenterMultiplier = 0.5;
//					}
//				}
//			}
//			
//			if( _elementHorizontalAlignChange )
//			{
//				_elementHorizontalAlignChange = false;
//				_indicesInViewChanged = true;
//				
//				switch( _elementHorizontalAlign )
//				{
//					case HorizontalAlign.LEFT :
//					{
//						_elementHorizontalCenterMultiplier = 0;
//						break;
//					}
//					case HorizontalAlign.RIGHT :
//					{
//						_elementHorizontalCenterMultiplier = 1;
//						break;
//					}
//					default :
//					{
//						_elementHorizontalCenterMultiplier = 0.5;
//					}
//				}
//			}
//			
//			if( _elementVerticalAlignChange )
//			{
//				_elementVerticalAlignChange = false;
//				_indicesInViewChanged = true;
//				
//				switch( _elementVerticalAlign )
//				{
//					case VerticalAlign.TOP :
//					{
//						_elementVerticalCenterMultiplier = 0;
//						break;
//					}
//					case VerticalAlign.BOTTOM :
//					{
//						_elementVerticalCenterMultiplier = 1;
//						break;
//					}
//					default :
//					{
//						_elementVerticalCenterMultiplier = 0.5;
//					}
//				}
//			}
//
//			super.updateDisplayList( unscaledWidth, unscaledHeight );
//		}
//		
//		/**
//		 *  @inheritDoc
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		override protected function updateDisplayListBetween():void
//		{
//			super.updateDisplayListBetween();
//			
//			if( sizeChangedInLayoutPass )
//			{
//				_indicesInViewChanged = true;
//				
//				if( !isNaN( _horizontalAlignOffsetPercent ) ) _horizontalAlignOffset = unscaledHeight * ( _horizontalAlignOffsetPercent / 100 );
//				if( !isNaN( _verticalAlignOffsetPercent ) ) _verticalAlignOffset = unscaledHeight * ( _verticalAlignOffsetPercent / 100 );
//			}
//
//			//TODO Done in animation class
////			if( _indicesInViewChanged )
////			{
////				_indicesInViewChanged = false;
////				_indicesInView = calculateIndicesInView( unscaledWidth, unscaledHeight );
////				updateIndicesInView();
////			}
//			
//			_transformCalculator.updateForLayoutPass( _horizontalCenterMultiplier, _verticalCenterMultiplier );
//		}
//		
//		/**
//		 *  @inheritDoc
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		override protected function updateDisplayListVirtual():void
//		{
//			super.updateDisplayListVirtual();
//			
//			const animationIndex:int = Math.round( animationValue );
//			
//			var index:int;
//			var element:IVisualElement;
//			for( var i:int = firstIndexInView; i <= lastIndexInView; i++ )
//			{
//				index = indicesInLayout[ i ];
//				element = target.getVirtualElementAt( index );
//				if( !element ) continue;
//				_transformCalculator.updateForIndex( index );
//				element.depth = ( i > animationIndex ) ? -i : i;
//				setElementLayoutBoundsSize( element, false );
//				elementTransformAround( element, _transformCalculator );
//			}
//		}
//		
//		/**
//		 *  @inheritDoc
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		override protected function updateDisplayListReal():void
//		{
//			super.updateDisplayListReal();
//			
//			const animationIndex:int = Math.round( animationValue );
//			
//			var index:int;
//			var element:IVisualElement;
//			for( var i:int = 0; i < numElementsInLayout; i++ )
//			{
//				index = indicesInLayout[ i ];
//				element = target.getElementAt( index );
//				if( !element ) continue;
//				_transformCalculator.updateForIndex( index );
//				element.depth = ( i > animationIndex ) ? -i : i;
//				setElementLayoutBoundsSize( element, false );
//				elementTransformAround( element, _transformCalculator );
//			}
//		}
//
//		private function elementTransformAround( element:IVisualElement, values:TransformValues ):void
//		{
//			var halfWidth:Number = element.width / 2;
//			var halfHeight:Number = element.height / 2;
//			var offsetX:Number = halfWidth * ( _elementHorizontalCenterMultiplier - 0.5 ) * 2;
//			var offsetY:Number = halfHeight * ( _elementVerticalCenterMultiplier - 0.5 ) * 2;
//			element.transformAround( new Vector3D( element.width / 2, element.height / 2, 0 ),
//				null,
//				null,
//				new Vector3D( values.x - offsetX, values.y - offsetY, values.z ),
//				null, new Vector3D( values.rotationX, values.rotationY, 0 ),
//				new Vector3D( values.x - offsetX, values.y - offsetY, values.z ),
//				true );
//		}
//		
//		/**
//		 *  @inheritDoc
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		override protected function restoreElement( element:IVisualElement ):void
//		{
//			super.restoreElement( element );
//			
//			var vector:Vector3D = new Vector3D( 0, 0, 0 );
//			element.visible = true;
//			element.depth = 0;
//			element.transformAround( vector, null, null, vector, null, null, vector, false );
//		}
//		
//		/**
//		 *  @inheritDoc
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		override protected function updateIndicesInView():void
//		{
//			super.updateIndicesInView();
//			
//			if( _indicesInView )
//			{
////				var start:int = Math.max( selectedIndex - _indicesInView.numItemsLeft, 0 );
////				var end:int = Math.min( selectedIndex + _indicesInView.numItemsRight, target.numElements - 1 );
//				const animationIndex:int = Math.round( animationValue );
//				const start:int = Math.max( animationIndex - _indicesInView.numItemsLeft, 0 );
//				const end:int = Math.min( animationIndex + _indicesInView.numItemsRight, target.numElements - 1 );
//				indicesInView( start, end - start + 1 );
//			}
//			else
//			{
//				indicesInView( selectedIndex, 1 );
//			}
//		}
//		
//		/**
//		 *  @private
//		 */
//		private function calculateIndicesInView( unscaledWidth:Number, unscaledHeight:Number ):IndicesInView
//		{
//			_horizontalIndicesInView.update( unscaledWidth,
//				_horizontalCenterMultiplier,
//				_horizontalDisplacement,
//				_selectedHorizontalDisplacement,
//				_horizontalAlignOffset );
//			
//			_verticalIndicesInView.update( unscaledHeight,
//				_verticalCenterMultiplier,
//				_verticalDisplacement,
//				_selectedVerticalDisplacement,
//				_verticalAlignOffset );
//			
//			if( _horizontalIndicesInView.valid && _verticalIndicesInView.valid )
//			{
//				if( _horizontalIndicesInView.numItems < _verticalIndicesInView.numItems )
//				{
//					return _horizontalIndicesInView;
//				}
//				else
//				{
//					return _verticalIndicesInView;
//				}
//			}
//			else if( _horizontalIndicesInView.valid )
//			{
//				return _horizontalIndicesInView;
//			}
//			else if( _verticalIndicesInView.valid )
//			{
//				return _verticalIndicesInView;
//			}
//			
//			return null;
//		}
//		
//	
//		
//		
//		
//		
//		
//	}
//}
//import spark.layouts.HorizontalAlign;
//import spark.layouts.VerticalAlign;
//
//import ws.tink.spark.layouts.CoverflowLayout;
//
//internal class IndicesInView
//{
//	
//	public var index	: int;
//	public var num		: int;
//	public var valid	: Boolean;
//	
//	public var numItemsLeft		: int;
//	public var numItemsRight	: int;
//	public var numItems			: int;
//	private var _layout		: CoverflowLayout;
//	
//	public function IndicesInView( layout:CoverflowLayout )
//	{
//		_layout = layout;
//	}
//	
//	public function update( size:Number, centerMultiplier:Number, displacement:Number, selectedDisplacement:Number, offset:Number ):void
//	{
//		var sd:Number = Math.abs( selectedDisplacement );
//		var d:Number = Math.abs( displacement );
//		var o:Number = offset;
//		
//		var center:Number = size * centerMultiplier;
//		var left:Number;
//		var right:Number;
//		
//		var minScale:Number = _layout.focalLength / ( _layout.focalLength + _layout.maximumZ );
//		var scaledSHD:Number = sd * minScale;
//		var scaledHD:Number = d * minScale;
//		
//		if( this == _layout._horizontalIndicesInView )
//		{
//			trace( "yeah" );
//		}
//		
//		if( d == 0 )
//		{
//			valid = false;
//			return;
//		}
//		else
//		{
//			valid = true;
//			left = center - scaledSHD;
//			right = size - center - scaledSHD;
//			
//			switch( centerMultiplier )
//			{
//				case 0 :
//				{
//					numItemsLeft = Math.max( 0, Math.ceil( left / scaledHD ) + 3 );
//					numItemsRight = Math.max( 0, Math.ceil( right / scaledHD ) - 1 );
//					break;
//				}
//				case 1 :
//				{
//					numItemsLeft = Math.max( 0, Math.ceil( left / scaledHD ) - 1 );
//					numItemsRight = Math.max( 0, Math.ceil( right / scaledHD ) + 3 );
//					break;
//				}
//				default :
//				{
//					numItemsLeft = Math.max( 0, Math.ceil( left / scaledHD ) + 1 );
//					numItemsRight = Math.max( 0, Math.ceil( right / scaledHD ) + 1 );
//				}
//			}
//			
//			numItems = numItemsLeft + numItemsRight + 1;
//		}
//	}
//	
//
//}
//
//
//internal class TransformValues
//{
//	
//	private var _x			: Number;
//	private var _y			: Number;
//	private var _z			: Number;
//	private var _rotationX	: Number;
//	private var _rotationY	: Number;
//	
//	private var _layout			: CoverflowLayout;
//	
//	private var _index			: int;
//	private var _indexOffset	: Number;
//	
//	// Displacement
//	private var _hd				: Number;
//	private var _vd				: Number;
//	
//	// Selected displacement
//	private var _shd			: Number;
//	private var _svd			: Number;
//	
//	// Center
//	private var _cx				: Number;
//	private var _cy				: Number;
//	
//	// Offset percents (left/right)
//	private var _lop			: Number;
//	private var _rop			: Number;
//	
//	private var _maxZ			: Number;
//	
//	// Rotation
//	private var _rx				: Number;
//	private var _ry				: Number;
//	
//	// Rotation
//	private var _ho				: Number;
//	private var _vo				: Number;
//	
//	
//	public function TransformValues( layout:CoverflowLayout )
//	{
//		_layout = layout;
//	}
//	
//	public function get x():Number
//	{
//		return _x;
//	}
//	
//	public function get y():Number
//	{
//		return _y;
//	}
//	
//	public function get z():Number
//	{
//		return _z;
//	}
//	
//	public function get rotationX():Number
//	{
//		return _rotationX;
//	}
//	
//	public function get rotationY():Number
//	{
//		return _rotationY;
//	}
//	
//	public function updateForLayoutPass( horizontalCenterMultiplier:Number, verticalCenterMultiplier:Number ):void
//	{
//		
//			
//		_index = Math.floor( _layout.animationValue );
//		_indexOffset = _layout.animationValue - _index;
////		_index = _layout.selectedIndex;
////		_indexOffset = 0//TODO _layout.selectedIndexOffset;
//		
//		_hd = _layout.horizontalDisplacement;
//		_vd = _layout.verticalDisplacement;
//		
//		_shd = _layout.selectedHorizontalDisplacement;
//		_svd = _layout.selectedVerticalDisplacement;
//		
//		_lop = ( _indexOffset <= 0 ) ? 1 + _indexOffset : _indexOffset;
//		_rop = ( _lop == 1 ) ? 1 : 1 - _lop;
//		
//		_cx = _layout.unscaledWidth * horizontalCenterMultiplier;
//		_cy = _layout.unscaledHeight * verticalCenterMultiplier;
//		
//		_maxZ = _layout.maximumZ;
//		
//		_rx = _layout.rotationX;
//		_ry = _layout.rotationY;
//		
//		_ho = _layout.horizontalAlignOffset;
//		_vo = _layout.verticalAlignOffset;
//	}
//	
//	public function updateForIndex( i:int ):void
//	{
//		if( i < _index )
//		{
//			// The item before the selectedIndex
//			if( i == _index - 1 )
//			{
//				if( _indexOffset > 0 )
//				{
//					_x = _cx - ( _shd + ( _hd * _lop ) );
//					_y = _cy - ( _svd + ( _vd * _lop ) );
//					_z = _maxZ;
//					_rotationX = _rx;
//					_rotationY = -_ry;
//				}
//				else
//				{
//					_x = _cx - ( _shd * _lop );
//					_y = _cy - ( _svd * _lop );
//					_z = _maxZ * _lop;
//					_rotationX = _rx * _lop;
//					_rotationY = -_ry * _lop;
//				}
//			}
//			else
//			{
//				_x = _cx - ( _shd + ( _hd * ( ( _index - i - 1 ) + _indexOffset ) ) );
//				_y = _cy - ( _svd + ( _vd * ( ( _index - i - 1 ) + _indexOffset ) ) );
//				_z = _maxZ;
//				_rotationX = _rx;
//				_rotationY = -_ry;
//			}
//		}
//			// Items after the selectIndex
//		else if( i > _index )
//		{
//			// The item before the selectedIndex
//			if( i == _index + 1 )
//			{
//				if( _indexOffset < 0 )
//				{
//					_x = _cx + _shd + ( _hd * _rop );
//					_y = _cy + _svd + ( _vd * _rop );
//					_z = _maxZ;
//					_rotationX = -_rx;
//					_rotationY = _ry;
//				}
//				else
//				{
//					_x = _cx + ( _shd * _rop );
//					_y = _cy + ( _svd * _rop );
//					_z = _maxZ * _rop;
//					_rotationX = -_rx * _rop;
//					_rotationY = _ry * _rop;
//				}
//			}
//			else
//			{
//				_x = _cx + _shd - ( ( _hd * ( ( _index - i + 1 ) + _indexOffset ) ) );
//				_y = _cy + _svd - ( ( _vd * ( ( _index - i + 1 ) + _indexOffset ) ) );
//				_z = _maxZ;
//				_rotationX = -_rx;
//				_rotationY = _ry;
//			}
//		}
//			// The selectIndex
//		else
//		{
//			_x = _cx - ( _shd * _indexOffset );
//			_y = _cy - ( _svd * _indexOffset );
//			_z = Math.abs( _maxZ * _indexOffset );
//			_rotationX = _rx * _indexOffset;
//			_rotationY = -_ry * _indexOffset;
//		}
//		
//		_x += _ho;
//		_y += _vo;
//	}
//}
//
////override protected function updateDisplayListVirtual():void
////{
////	super.updateDisplayListVirtual();
////	
////	var i:int;
////	var element:IVisualElement;
////	
////	_transformCalculator.updateForLayoutPass();
////	
////	//			const leftOffsetPercent:Number = ( selectedIndexOffset <= 0 ) ? 1 + selectedIndexOffset : selectedIndexOffset;
////	//			const rightOffsetPercent:Number = ( leftOffsetPercent == 1 ) ? 1 : 1 - leftOffsetPercent;
////	//			
////	//			const centerX:Number = unscaledWidth / 2;
////	//			const centerY:Number = unscaledHeight / 2;
////	//			
////	//			var x:Number;
////	//			var y:Number;
////	//			var z:Number;
////	//			var rotX:Number;
////	//			var rotY:Number;
////	//			
////	//			var d:int = 0;
////	//			if( true )
////	//			{
////	trace( firstIndexInView, "jjj", lastIndexInView, target.numElements );
////	for( i = firstIndexInView; i < lastIndexInView; i++ )
////	{
////		_transformCalculator.updateForIndex( i );
////		element = target.getVirtualElementAt( i );
////		elementTransformAround( element, _transformCalculator );
////		element.depth = ( i > selectedIndex ) ? selectedIndex - i : i
////		setElementLayoutBoundsSize( element, false );
////	}
////	// Items before the selectIndex
////	//				if( i < selectedIndex )
////	//				{
////	//					// The item before the selectedIndex
////	//					if( i == selectedIndex - 1 )
////	//					{
////	//						if( selectedIndexOffset > 0 )
////	//						{
////	//							x = centerX - ( _selectedHorizontalDisplacement + ( _horizontalDisplacement * leftOffsetPercent ) );
////	//							y = centerY - ( _selectedVerticalDisplacement + ( _verticalDisplacement * leftOffsetPercent ) );
////	//							z = _maximumZ;
////	//							rotX = _rotationX;
////	//							rotY = -_rotationY;
////	//						}
////	//						else
////	//						{
////	//							x = centerX - ( _selectedHorizontalDisplacement * leftOffsetPercent );
////	//							y = centerY - ( _selectedVerticalDisplacement * leftOffsetPercent );
////	//							z = _maximumZ * leftOffsetPercent;
////	//							rotX = _rotationX * leftOffsetPercent;
////	//							rotY = -_rotationY * leftOffsetPercent;
////	//						}
////	//					}
////	//					else
////	//					{
////	//						x = centerX - ( _selectedHorizontalDisplacement + ( _horizontalDisplacement * ( ( selectedIndex - i - 1 ) + selectedIndexOffset ) ) );
////	//						y = centerY - ( _selectedVerticalDisplacement + ( _verticalDisplacement * ( ( selectedIndex - i - 1 ) + selectedIndexOffset ) ) );
////	//						z = _maximumZ;
////	//						rotX = _rotationX;
////	//						rotY = -_rotationY;
////	//					}
////	//				}
////	//				// Items after the selectIndex
////	//				else if( i > selectedIndex )
////	//				{
////	//					// The item before the selectedIndex
////	//					if( i == selectedIndex + 1 )
////	//					{
////	//						if( selectedIndexOffset < 0 )
////	//						{
////	//							x = centerX + _selectedHorizontalDisplacement + ( _horizontalDisplacement * rightOffsetPercent );
////	//							y = centerY + _selectedVerticalDisplacement + ( _verticalDisplacement * rightOffsetPercent );
////	//							z = _maximumZ;
////	//							rotX = -_rotationX;
////	//							rotY = _rotationY;
////	//						}
////	//						else
////	//						{
////	//							x = centerX + ( _selectedHorizontalDisplacement * rightOffsetPercent );
////	//							y = centerY + ( _selectedVerticalDisplacement * rightOffsetPercent );
////	//							z = _maximumZ * rightOffsetPercent;
////	//							rotX = -_rotationX * rightOffsetPercent;
////	//							rotY = _rotationY * rightOffsetPercent;
////	//						}
////	//					}
////	//					else
////	//					{
////	//						x = centerX + _selectedHorizontalDisplacement - ( ( _horizontalDisplacement * ( ( selectedIndex - i + 1 ) + selectedIndexOffset ) ) );
////	//						y = centerY + _selectedVerticalDisplacement - ( ( _verticalDisplacement * ( ( selectedIndex - i + 1 ) + selectedIndexOffset ) ) );
////	//						z = _maximumZ;
////	//						rotX = -_rotationX;
////	//						rotY = _rotationY;
////	//					}
////	//				}
////	//				// The selectIndex
////	//				else
////	//				{
////	//					x = centerX - ( _selectedHorizontalDisplacement * selectedIndexOffset );
////	//					y = centerY - ( _selectedVerticalDisplacement * selectedIndexOffset );
////	//					z = Math.abs( _maximumZ * selectedIndexOffset );
////	//					rotX = _rotationX * selectedIndexOffset;
////	//					rotY = -_rotationY * selectedIndexOffset;
////	//				}
////	//				
////	//				
////	//				_transformCalculator.updateForIndex( i );
////	//				element = target.getVirtualElementAt( i );
////	//				elementTransformAround( element, _transformCalculator );
////	//				setElementLayoutBoundsSize( element, false );
////	//			}
////	
////	//			}else{
////	//			if( selectedIndex > 0 )
////	//			{
////	//				element = target.getVirtualElementAt( selectedIndex - 1 );
////	//				
////	//				if( selectedIndexOffset > 0 )
////	//				{
////	//					x = centerX - ( _selectedHorizontalDisplacement + ( _horizontalDisplacement * leftOffsetPercent ) );
////	//					y = centerY - ( _selectedVerticalDisplacement + ( _verticalDisplacement * leftOffsetPercent ) );
////	//					z = _maximumZ;
////	//					rotX = _rotationX;
////	//					rotY = -_rotationY;
////	//					
////	//				}
////	//				else
////	//				{
////	//					x = centerX - ( _selectedHorizontalDisplacement * leftOffsetPercent );
////	//					y = centerY - ( _selectedVerticalDisplacement * leftOffsetPercent );
////	//					z = _maximumZ * leftOffsetPercent;
////	//					rotX = _rotationX * leftOffsetPercent;
////	//					rotY = -_rotationY * leftOffsetPercent;
////	//				}
////	//				
////	//				setElementLayoutBoundsSize( element, false );
////	//				elementTransformAround( element, x, y, z, rotX, rotY );
////	//				element.depth = d;
////	//				d--;
////	//			}
////	//			
////	//			//FIXME Items to the left
////	//			for( i = selectedIndex - 2; i > -1; i-- )
////	//			{
////	//				x = centerX - ( _selectedHorizontalDisplacement + ( _horizontalDisplacement * ( ( selectedIndex - i - 1 ) + selectedIndexOffset ) ) );
////	//				y = centerY - ( _selectedVerticalDisplacement + ( _verticalDisplacement * ( ( selectedIndex - i - 1 ) + selectedIndexOffset ) ) );
////	//				element = target.getVirtualElementAt( i );
////	//				setElementLayoutBoundsSize( element, false );
////	//				elementTransformAround( element, x, y, _maximumZ, _rotationX, -_rotationY );
////	//				element.depth = d;
////	//				d--;
////	//				
////	//				if( x + ( element.getPreferredBoundsWidth( true ) / 2 ) < 0 ) break;
////	//			}
////	//			
////	//			
////	//			
////	//			
////	//			x = centerX - ( _selectedHorizontalDisplacement * selectedIndexOffset );
////	//			y = centerY - ( _selectedVerticalDisplacement * selectedIndexOffset );
////	//			z = Math.abs( _maximumZ * selectedIndexOffset );
////	//			
////	//			rotX = _rotationX * selectedIndexOffset;
////	//			rotY = -_rotationY * selectedIndexOffset;
////	//			
////	//			element = target.getVirtualElementAt( selectedIndex );
////	//			setElementLayoutBoundsSize( element, false );
////	//			elementTransformAround( element, x, y, z, rotX, rotY );
////	//			element.depth = 1;
////	//			
////	//			
////	//			if( selectedIndex < target.numElements - 1 )
////	//			{
////	//				if( selectedIndexOffset < 0 )
////	//				{
////	//					x = centerX + _selectedHorizontalDisplacement + ( _horizontalDisplacement * rightOffsetPercent );
////	//					y = centerY + _selectedVerticalDisplacement + ( _verticalDisplacement * rightOffsetPercent );
////	//					z = _maximumZ;
////	//					rotX = -_rotationX;
////	//					rotY = _rotationY;
////	//				}
////	//				else
////	//				{
////	//					x = centerX + ( _selectedHorizontalDisplacement * rightOffsetPercent );
////	//					y = centerY + ( _selectedVerticalDisplacement * rightOffsetPercent );
////	//					z = _maximumZ * rightOffsetPercent;
////	//					rotX = -_rotationX * rightOffsetPercent;
////	//					rotY = _rotationY * rightOffsetPercent;
////	//				}
////	//				
////	////				x = ( unscaledWidth / 2 )  - ( ( _selectedHorizontalDisplacement * ( -1 + selectedIndexOffset ) ) );
////	//				element = target.getVirtualElementAt( selectedIndex + 1 );
////	//				setElementLayoutBoundsSize( element, false );
////	//				elementTransformAround( element, x, y, z, rotX, rotY );
////	//				element.depth = d;
////	//				d--;
////	//			}
////	//			
////	//			//FIXME Items to the right
////	//			for( i = selectedIndex + 2; i < target.numElements; i++ )
////	//			{
////	//				x = centerX + _selectedHorizontalDisplacement - ( ( _horizontalDisplacement * ( ( selectedIndex - i + 1 ) + selectedIndexOffset ) ) );
////	//				y = centerY + _selectedVerticalDisplacement - ( ( _verticalDisplacement * ( ( selectedIndex - i + 1 ) + selectedIndexOffset ) ) );
////	//				element = target.getVirtualElementAt( i );
////	//				setElementLayoutBoundsSize( element, false );
////	//				elementTransformAround( element, x, y, _maximumZ, -_rotationX, _rotationY );
////	//				element.depth = d;
////	//				d--;
////	//				
////	//				if( x - ( element.getPreferredBoundsWidth( true ) / 2 ) > unscaledWidth ) break;
////	//			}
////	//			}
////	
////}