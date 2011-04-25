package ws.tink.spark.layouts
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import mx.core.FlexGlobals;
	import mx.core.ILayoutElement;
	import mx.core.IVisualElement;
	
	import spark.components.Scroller;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	import spark.layouts.supportClasses.LayoutBase;
	
	import ws.tink.spark.layouts.supportClasses.AnimationNavigatorLayoutBase;
	import ws.tink.spark.layouts.supportClasses.PerspectiveAnimationNavigatorLayoutBase;
	import ws.tink.spark.layouts.supportClasses.PerspectiveNavigatorLayoutBase;

	/**
	 * Flex 4 Time Machine Layout
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
			super( AnimationNavigatorLayoutBase.INDIRECT );
			
			_transformCalculator = new TransformValues( this );
			_horizontalIndicesInView = new IndicesInView( this );
			_verticalIndicesInView = new IndicesInView( this );
		}

		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _transformCalculator		: TransformValues;
		
		public var _horizontalIndicesInView	: IndicesInView;
		private var _verticalIndicesInView		: IndicesInView;
		private var _indicesInView				: IndicesInView;
		private var _indicesInViewChanged		: Boolean;
//		private var _sizeChanged				: Boolean;
		
		private var _horizontalAlignChange		: Boolean = true;
		private var _verticalAlignChange		: Boolean = true;
		
		private var _horizontalCenterMultiplier	: Number;
		private var _verticalCenterMultiplier	: Number;
		
		private var _elementHorizontalAlignChange	: Boolean = true;
		private var _elementVerticalAlignChange		: Boolean = true;
		
		private var _elementHorizontalCenterMultiplier	: Number;
		private var _elementVerticalCenterMultiplier	: Number;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  horizontalAlign
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for horizontalAlign.
		 */
		private var _horizontalAlign:String = HorizontalAlign.CENTER;
		
		[Inspectable(category="General", enumeration="left,right,center", defaultValue="center")]
		/**
		 *  horizontalAlign
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
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
		
		[Inspectable(category="General", enumeration="top,bottom,middle", defaultValue="middle")]
		/**
		 *  verticalAlign
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
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
		 *  horizontalAlignOffset
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
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
			_indicesInViewChanged = true;
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
		 *  verticalAlignOffset
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
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
			_indicesInViewChanged = true;
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
		 *  horizontalAlignOffsetPercent
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
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
			_indicesInViewChanged = true;
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
		 *  verticalAlignOffsetPercent
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
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
			_indicesInViewChanged = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  buttonRotation
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for elementHorizontalAlign.
		 */
		private var _elementHorizontalAlign:String = HorizontalAlign.CENTER;
		
		[Inspectable(category="General", enumeration="left,right,center", defaultValue="center")]
		/**
		 *  elementHorizontalAlign
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
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
		
		[Inspectable(category="General", enumeration="top,bottom,middle", defaultValue="middle")]
		/**
		 *  elementVerticalAlign
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
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
			_indicesInViewChanged = true;
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
			_indicesInViewChanged = true;
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
			_indicesInViewChanged = true;
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
			_indicesInViewChanged = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  rotationX
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for rotationX.
		 */
		private var _rotationX		: Number = 0;
		
		[Inspectable(category="General", defaultValue="0")]
		/**
		 *  rotationX
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get rotationX():Number
		{
			return _rotationX;
		}
		/**
		 *  @private
		 */
		public function set rotationX( value:Number ):void
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
		private var _rotationY		: Number = 45;
		
		[Inspectable(category="General", defaultValue="45")]
		/**
		 *  rotationY
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
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
			if( _rotationY == value ) return;
			
			_rotationY = value;
			invalidateTargetDisplayList();
		}
		
		
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
			_indicesInViewChanged = true;
			invalidateTargetDisplayList();
		}
		

		
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
				_indicesInViewChanged = true;
				
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
				_indicesInViewChanged = true;
				
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
				_indicesInViewChanged = true;
				
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
				_indicesInViewChanged = true;
				
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
				_indicesInViewChanged = true;
				
				if( !isNaN( _horizontalAlignOffsetPercent ) ) _horizontalAlignOffset = unscaledHeight * ( _horizontalAlignOffsetPercent / 100 );
				if( !isNaN( _verticalAlignOffsetPercent ) ) _verticalAlignOffset = unscaledHeight * ( _verticalAlignOffsetPercent / 100 );
			}

			//TODO Done in animation class
//			if( _indicesInViewChanged )
//			{
//				_indicesInViewChanged = false;
//				_indicesInView = calculateIndicesInView( unscaledWidth, unscaledHeight );
//				updateIndicesInView();
//			}
			
			_transformCalculator.updateForLayoutPass( _horizontalCenterMultiplier, _verticalCenterMultiplier );
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
			
			const animationIndex:int = Math.round( animationValue );
			
			var index:int;
			var element:IVisualElement;
			for( var i:int = firstIndexInView; i <= lastIndexInView; i++ )
			{
				index = indicesInLayout[ i ];
				element = target.getVirtualElementAt( index );
				if( !element ) continue;
				_transformCalculator.updateForIndex( index );
				element.depth = ( i > animationIndex ) ? -i : i;
				setElementLayoutBoundsSize( element, false );
				elementTransformAround( element, _transformCalculator );
			}
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
			
			const animationIndex:int = Math.round( animationValue );
			
			var index:int;
			var element:IVisualElement;
			for( var i:int = 0; i < numElementsInLayout; i++ )
			{
				index = indicesInLayout[ i ];
				element = target.getElementAt( index );
				if( !element ) continue;
				_transformCalculator.updateForIndex( index );
				element.depth = ( i > animationIndex ) ? -i : i;
				setElementLayoutBoundsSize( element, false );
				elementTransformAround( element, _transformCalculator );
			}
		}

		private function elementTransformAround( element:IVisualElement, values:TransformValues ):void
		{
			var halfWidth:Number = element.width / 2;
			var halfHeight:Number = element.height / 2;
			var offsetX:Number = halfWidth * ( _elementHorizontalCenterMultiplier - 0.5 ) * 2;
			var offsetY:Number = halfHeight * ( _elementVerticalCenterMultiplier - 0.5 ) * 2;
			element.transformAround( new Vector3D( element.width / 2, element.height / 2, 0 ),
				null,
				null,
				new Vector3D( values.x - offsetX, values.y - offsetY, values.z ),
				null, new Vector3D( values.rotationX, values.rotationY, 0 ),
				new Vector3D( values.x - offsetX, values.y - offsetY, values.z ),
				true );
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
			
			if( _indicesInView )
			{
//				var start:int = Math.max( selectedIndex - _indicesInView.numItemsLeft, 0 );
//				var end:int = Math.min( selectedIndex + _indicesInView.numItemsRight, target.numElements - 1 );
				const animationIndex:int = Math.round( animationValue );
				const start:int = Math.max( animationIndex - _indicesInView.numItemsLeft, 0 );
				const end:int = Math.min( animationIndex + _indicesInView.numItemsRight, target.numElements - 1 );
				indicesInView( start, end - start + 1 );
			}
			else
			{
				indicesInView( selectedIndex, 1 );
			}
		}
		
		/**
		 *  @private
		 */
		private function calculateIndicesInView( unscaledWidth:Number, unscaledHeight:Number ):IndicesInView
		{
			_horizontalIndicesInView.update( unscaledWidth,
				_horizontalCenterMultiplier,
				_horizontalDisplacement,
				_selectedHorizontalDisplacement,
				_horizontalAlignOffset );
			
			_verticalIndicesInView.update( unscaledHeight,
				_verticalCenterMultiplier,
				_verticalDisplacement,
				_selectedVerticalDisplacement,
				_verticalAlignOffset );
			
			if( _horizontalIndicesInView.valid && _verticalIndicesInView.valid )
			{
				if( _horizontalIndicesInView.numItems < _verticalIndicesInView.numItems )
				{
					return _horizontalIndicesInView;
				}
				else
				{
					return _verticalIndicesInView;
				}
			}
			else if( _horizontalIndicesInView.valid )
			{
				return _horizontalIndicesInView;
			}
			else if( _verticalIndicesInView.valid )
			{
				return _verticalIndicesInView;
			}
			
			return null;
		}
		
	
		
		
		
		
		
	}
}
import spark.layouts.HorizontalAlign;
import spark.layouts.VerticalAlign;

import ws.tink.spark.layouts.CoverflowLayout;

internal class IndicesInView
{
	
	public var index	: int;
	public var num		: int;
	public var valid	: Boolean;
	
	public var numItemsLeft		: int;
	public var numItemsRight	: int;
	public var numItems			: int;
	private var _layout		: CoverflowLayout;
	
	public function IndicesInView( layout:CoverflowLayout )
	{
		_layout = layout;
	}
	
	public function update( size:Number, centerMultiplier:Number, displacement:Number, selectedDisplacement:Number, offset:Number ):void
	{
		var sd:Number = Math.abs( selectedDisplacement );
		var d:Number = Math.abs( displacement );
		var o:Number = offset;
		
		var center:Number = size * centerMultiplier;
		var left:Number;
		var right:Number;
		
		var minScale:Number = _layout.focalLength / ( _layout.focalLength + _layout.maximumZ );
		var scaledSHD:Number = sd * minScale;
		var scaledHD:Number = d * minScale;
		
		if( this == _layout._horizontalIndicesInView )
		{
			trace( "yeah" );
		}
		
		if( d == 0 )
		{
			valid = false;
			return;
		}
		else
		{
			valid = true;
			left = center - scaledSHD;
			right = size - center - scaledSHD;
			
			switch( centerMultiplier )
			{
				case 0 :
				{
					numItemsLeft = Math.max( 0, Math.ceil( left / scaledHD ) + 3 );
					numItemsRight = Math.max( 0, Math.ceil( right / scaledHD ) - 1 );
					break;
				}
				case 1 :
				{
					numItemsLeft = Math.max( 0, Math.ceil( left / scaledHD ) - 1 );
					numItemsRight = Math.max( 0, Math.ceil( right / scaledHD ) + 3 );
					break;
				}
				default :
				{
					numItemsLeft = Math.max( 0, Math.ceil( left / scaledHD ) + 1 );
					numItemsRight = Math.max( 0, Math.ceil( right / scaledHD ) + 1 );
				}
			}
			
			numItems = numItemsLeft + numItemsRight + 1;
		}
	}
	

}


internal class TransformValues
{
	
	private var _x			: Number;
	private var _y			: Number;
	private var _z			: Number;
	private var _rotationX	: Number;
	private var _rotationY	: Number;
	
	private var _layout			: CoverflowLayout;
	
	private var _index			: int;
	private var _indexOffset	: Number;
	
	// Displacement
	private var _hd				: Number;
	private var _vd				: Number;
	
	// Selected displacement
	private var _shd			: Number;
	private var _svd			: Number;
	
	// Center
	private var _cx				: Number;
	private var _cy				: Number;
	
	// Offset percents (left/right)
	private var _lop			: Number;
	private var _rop			: Number;
	
	private var _maxZ			: Number;
	
	// Rotation
	private var _rx				: Number;
	private var _ry				: Number;
	
	// Rotation
	private var _ho				: Number;
	private var _vo				: Number;
	
	
	public function TransformValues( layout:CoverflowLayout )
	{
		_layout = layout;
	}
	
	public function get x():Number
	{
		return _x;
	}
	
	public function get y():Number
	{
		return _y;
	}
	
	public function get z():Number
	{
		return _z;
	}
	
	public function get rotationX():Number
	{
		return _rotationX;
	}
	
	public function get rotationY():Number
	{
		return _rotationY;
	}
	
	public function updateForLayoutPass( horizontalCenterMultiplier:Number, verticalCenterMultiplier:Number ):void
	{
		
			
		_index = Math.floor( _layout.animationValue );
		_indexOffset = _layout.animationValue - _index;
//		_index = _layout.selectedIndex;
//		_indexOffset = 0//TODO _layout.selectedIndexOffset;
		
		_hd = _layout.horizontalDisplacement;
		_vd = _layout.verticalDisplacement;
		
		_shd = _layout.selectedHorizontalDisplacement;
		_svd = _layout.selectedVerticalDisplacement;
		
		_lop = ( _indexOffset <= 0 ) ? 1 + _indexOffset : _indexOffset;
		_rop = ( _lop == 1 ) ? 1 : 1 - _lop;
		
		_cx = _layout.unscaledWidth * horizontalCenterMultiplier;
		_cy = _layout.unscaledHeight * verticalCenterMultiplier;
		
		_maxZ = _layout.maximumZ;
		
		_rx = _layout.rotationX;
		_ry = _layout.rotationY;
		
		_ho = _layout.horizontalAlignOffset;
		_vo = _layout.verticalAlignOffset;
	}
	
	public function updateForIndex( i:int ):void
	{
		if( i < _index )
		{
			// The item before the selectedIndex
			if( i == _index - 1 )
			{
				if( _indexOffset > 0 )
				{
					_x = _cx - ( _shd + ( _hd * _lop ) );
					_y = _cy - ( _svd + ( _vd * _lop ) );
					_z = _maxZ;
					_rotationX = _rx;
					_rotationY = -_ry;
				}
				else
				{
					_x = _cx - ( _shd * _lop );
					_y = _cy - ( _svd * _lop );
					_z = _maxZ * _lop;
					_rotationX = _rx * _lop;
					_rotationY = -_ry * _lop;
				}
			}
			else
			{
				_x = _cx - ( _shd + ( _hd * ( ( _index - i - 1 ) + _indexOffset ) ) );
				_y = _cy - ( _svd + ( _vd * ( ( _index - i - 1 ) + _indexOffset ) ) );
				_z = _maxZ;
				_rotationX = _rx;
				_rotationY = -_ry;
			}
		}
			// Items after the selectIndex
		else if( i > _index )
		{
			// The item before the selectedIndex
			if( i == _index + 1 )
			{
				if( _indexOffset < 0 )
				{
					_x = _cx + _shd + ( _hd * _rop );
					_y = _cy + _svd + ( _vd * _rop );
					_z = _maxZ;
					_rotationX = -_rx;
					_rotationY = _ry;
				}
				else
				{
					_x = _cx + ( _shd * _rop );
					_y = _cy + ( _svd * _rop );
					_z = _maxZ * _rop;
					_rotationX = -_rx * _rop;
					_rotationY = _ry * _rop;
				}
			}
			else
			{
				_x = _cx + _shd - ( ( _hd * ( ( _index - i + 1 ) + _indexOffset ) ) );
				_y = _cy + _svd - ( ( _vd * ( ( _index - i + 1 ) + _indexOffset ) ) );
				_z = _maxZ;
				_rotationX = -_rx;
				_rotationY = _ry;
			}
		}
			// The selectIndex
		else
		{
			_x = _cx - ( _shd * _indexOffset );
			_y = _cy - ( _svd * _indexOffset );
			_z = Math.abs( _maxZ * _indexOffset );
			_rotationX = _rx * _indexOffset;
			_rotationY = -_ry * _indexOffset;
		}
		
		_x += _ho;
		_y += _vo;
	}
}

//override protected function updateDisplayListVirtual():void
//{
//	super.updateDisplayListVirtual();
//	
//	var i:int;
//	var element:IVisualElement;
//	
//	_transformCalculator.updateForLayoutPass();
//	
//	//			const leftOffsetPercent:Number = ( selectedIndexOffset <= 0 ) ? 1 + selectedIndexOffset : selectedIndexOffset;
//	//			const rightOffsetPercent:Number = ( leftOffsetPercent == 1 ) ? 1 : 1 - leftOffsetPercent;
//	//			
//	//			const centerX:Number = unscaledWidth / 2;
//	//			const centerY:Number = unscaledHeight / 2;
//	//			
//	//			var x:Number;
//	//			var y:Number;
//	//			var z:Number;
//	//			var rotX:Number;
//	//			var rotY:Number;
//	//			
//	//			var d:int = 0;
//	//			if( true )
//	//			{
//	trace( firstIndexInView, "jjj", lastIndexInView, target.numElements );
//	for( i = firstIndexInView; i < lastIndexInView; i++ )
//	{
//		_transformCalculator.updateForIndex( i );
//		element = target.getVirtualElementAt( i );
//		elementTransformAround( element, _transformCalculator );
//		element.depth = ( i > selectedIndex ) ? selectedIndex - i : i
//		setElementLayoutBoundsSize( element, false );
//	}
//	// Items before the selectIndex
//	//				if( i < selectedIndex )
//	//				{
//	//					// The item before the selectedIndex
//	//					if( i == selectedIndex - 1 )
//	//					{
//	//						if( selectedIndexOffset > 0 )
//	//						{
//	//							x = centerX - ( _selectedHorizontalDisplacement + ( _horizontalDisplacement * leftOffsetPercent ) );
//	//							y = centerY - ( _selectedVerticalDisplacement + ( _verticalDisplacement * leftOffsetPercent ) );
//	//							z = _maximumZ;
//	//							rotX = _rotationX;
//	//							rotY = -_rotationY;
//	//						}
//	//						else
//	//						{
//	//							x = centerX - ( _selectedHorizontalDisplacement * leftOffsetPercent );
//	//							y = centerY - ( _selectedVerticalDisplacement * leftOffsetPercent );
//	//							z = _maximumZ * leftOffsetPercent;
//	//							rotX = _rotationX * leftOffsetPercent;
//	//							rotY = -_rotationY * leftOffsetPercent;
//	//						}
//	//					}
//	//					else
//	//					{
//	//						x = centerX - ( _selectedHorizontalDisplacement + ( _horizontalDisplacement * ( ( selectedIndex - i - 1 ) + selectedIndexOffset ) ) );
//	//						y = centerY - ( _selectedVerticalDisplacement + ( _verticalDisplacement * ( ( selectedIndex - i - 1 ) + selectedIndexOffset ) ) );
//	//						z = _maximumZ;
//	//						rotX = _rotationX;
//	//						rotY = -_rotationY;
//	//					}
//	//				}
//	//				// Items after the selectIndex
//	//				else if( i > selectedIndex )
//	//				{
//	//					// The item before the selectedIndex
//	//					if( i == selectedIndex + 1 )
//	//					{
//	//						if( selectedIndexOffset < 0 )
//	//						{
//	//							x = centerX + _selectedHorizontalDisplacement + ( _horizontalDisplacement * rightOffsetPercent );
//	//							y = centerY + _selectedVerticalDisplacement + ( _verticalDisplacement * rightOffsetPercent );
//	//							z = _maximumZ;
//	//							rotX = -_rotationX;
//	//							rotY = _rotationY;
//	//						}
//	//						else
//	//						{
//	//							x = centerX + ( _selectedHorizontalDisplacement * rightOffsetPercent );
//	//							y = centerY + ( _selectedVerticalDisplacement * rightOffsetPercent );
//	//							z = _maximumZ * rightOffsetPercent;
//	//							rotX = -_rotationX * rightOffsetPercent;
//	//							rotY = _rotationY * rightOffsetPercent;
//	//						}
//	//					}
//	//					else
//	//					{
//	//						x = centerX + _selectedHorizontalDisplacement - ( ( _horizontalDisplacement * ( ( selectedIndex - i + 1 ) + selectedIndexOffset ) ) );
//	//						y = centerY + _selectedVerticalDisplacement - ( ( _verticalDisplacement * ( ( selectedIndex - i + 1 ) + selectedIndexOffset ) ) );
//	//						z = _maximumZ;
//	//						rotX = -_rotationX;
//	//						rotY = _rotationY;
//	//					}
//	//				}
//	//				// The selectIndex
//	//				else
//	//				{
//	//					x = centerX - ( _selectedHorizontalDisplacement * selectedIndexOffset );
//	//					y = centerY - ( _selectedVerticalDisplacement * selectedIndexOffset );
//	//					z = Math.abs( _maximumZ * selectedIndexOffset );
//	//					rotX = _rotationX * selectedIndexOffset;
//	//					rotY = -_rotationY * selectedIndexOffset;
//	//				}
//	//				
//	//				
//	//				_transformCalculator.updateForIndex( i );
//	//				element = target.getVirtualElementAt( i );
//	//				elementTransformAround( element, _transformCalculator );
//	//				setElementLayoutBoundsSize( element, false );
//	//			}
//	
//	//			}else{
//	//			if( selectedIndex > 0 )
//	//			{
//	//				element = target.getVirtualElementAt( selectedIndex - 1 );
//	//				
//	//				if( selectedIndexOffset > 0 )
//	//				{
//	//					x = centerX - ( _selectedHorizontalDisplacement + ( _horizontalDisplacement * leftOffsetPercent ) );
//	//					y = centerY - ( _selectedVerticalDisplacement + ( _verticalDisplacement * leftOffsetPercent ) );
//	//					z = _maximumZ;
//	//					rotX = _rotationX;
//	//					rotY = -_rotationY;
//	//					
//	//				}
//	//				else
//	//				{
//	//					x = centerX - ( _selectedHorizontalDisplacement * leftOffsetPercent );
//	//					y = centerY - ( _selectedVerticalDisplacement * leftOffsetPercent );
//	//					z = _maximumZ * leftOffsetPercent;
//	//					rotX = _rotationX * leftOffsetPercent;
//	//					rotY = -_rotationY * leftOffsetPercent;
//	//				}
//	//				
//	//				setElementLayoutBoundsSize( element, false );
//	//				elementTransformAround( element, x, y, z, rotX, rotY );
//	//				element.depth = d;
//	//				d--;
//	//			}
//	//			
//	//			//FIXME Items to the left
//	//			for( i = selectedIndex - 2; i > -1; i-- )
//	//			{
//	//				x = centerX - ( _selectedHorizontalDisplacement + ( _horizontalDisplacement * ( ( selectedIndex - i - 1 ) + selectedIndexOffset ) ) );
//	//				y = centerY - ( _selectedVerticalDisplacement + ( _verticalDisplacement * ( ( selectedIndex - i - 1 ) + selectedIndexOffset ) ) );
//	//				element = target.getVirtualElementAt( i );
//	//				setElementLayoutBoundsSize( element, false );
//	//				elementTransformAround( element, x, y, _maximumZ, _rotationX, -_rotationY );
//	//				element.depth = d;
//	//				d--;
//	//				
//	//				if( x + ( element.getPreferredBoundsWidth( true ) / 2 ) < 0 ) break;
//	//			}
//	//			
//	//			
//	//			
//	//			
//	//			x = centerX - ( _selectedHorizontalDisplacement * selectedIndexOffset );
//	//			y = centerY - ( _selectedVerticalDisplacement * selectedIndexOffset );
//	//			z = Math.abs( _maximumZ * selectedIndexOffset );
//	//			
//	//			rotX = _rotationX * selectedIndexOffset;
//	//			rotY = -_rotationY * selectedIndexOffset;
//	//			
//	//			element = target.getVirtualElementAt( selectedIndex );
//	//			setElementLayoutBoundsSize( element, false );
//	//			elementTransformAround( element, x, y, z, rotX, rotY );
//	//			element.depth = 1;
//	//			
//	//			
//	//			if( selectedIndex < target.numElements - 1 )
//	//			{
//	//				if( selectedIndexOffset < 0 )
//	//				{
//	//					x = centerX + _selectedHorizontalDisplacement + ( _horizontalDisplacement * rightOffsetPercent );
//	//					y = centerY + _selectedVerticalDisplacement + ( _verticalDisplacement * rightOffsetPercent );
//	//					z = _maximumZ;
//	//					rotX = -_rotationX;
//	//					rotY = _rotationY;
//	//				}
//	//				else
//	//				{
//	//					x = centerX + ( _selectedHorizontalDisplacement * rightOffsetPercent );
//	//					y = centerY + ( _selectedVerticalDisplacement * rightOffsetPercent );
//	//					z = _maximumZ * rightOffsetPercent;
//	//					rotX = -_rotationX * rightOffsetPercent;
//	//					rotY = _rotationY * rightOffsetPercent;
//	//				}
//	//				
//	////				x = ( unscaledWidth / 2 )  - ( ( _selectedHorizontalDisplacement * ( -1 + selectedIndexOffset ) ) );
//	//				element = target.getVirtualElementAt( selectedIndex + 1 );
//	//				setElementLayoutBoundsSize( element, false );
//	//				elementTransformAround( element, x, y, z, rotX, rotY );
//	//				element.depth = d;
//	//				d--;
//	//			}
//	//			
//	//			//FIXME Items to the right
//	//			for( i = selectedIndex + 2; i < target.numElements; i++ )
//	//			{
//	//				x = centerX + _selectedHorizontalDisplacement - ( ( _horizontalDisplacement * ( ( selectedIndex - i + 1 ) + selectedIndexOffset ) ) );
//	//				y = centerY + _selectedVerticalDisplacement - ( ( _verticalDisplacement * ( ( selectedIndex - i + 1 ) + selectedIndexOffset ) ) );
//	//				element = target.getVirtualElementAt( i );
//	//				setElementLayoutBoundsSize( element, false );
//	//				elementTransformAround( element, x, y, _maximumZ, -_rotationX, _rotationY );
//	//				element.depth = d;
//	//				d--;
//	//				
//	//				if( x - ( element.getPreferredBoundsWidth( true ) / 2 ) > unscaledWidth ) break;
//	//			}
//	//			}
//	
//}