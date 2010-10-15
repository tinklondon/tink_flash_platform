package ws.tink.spark.layouts
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.IVisualElement;
	
	import spark.components.Scroller;
	import spark.layouts.supportClasses.LayoutBase;

	/**
	 * Flex 4 Time Machine Layout
	 */
	public class CoverflowLayout extends LayoutBase
	{

		private var _depth 		: Number = 300;
		
		private var _depthDelta : Number;
		private var _alphaDelta : Number;
		
		private var _horizontalDisplacement : Number = -.2;
		private var _verticalDisplacement : Number = -.2;
//		private var _totalHeight : Number;
//		private var _layoutHeight : Number;
		
		private var _numVisibleItems	: int = 3;
		
		private var _zChanged			: Boolean;

		/**
		 * Index of centered item
		 */
//		[Bindable]
//		public function get index() : Number
//		{
//			return _index;
//		}
//
//		public function set index( value : Number ) : void
//		{
//			if ( _index != value )
//			{
//				_index = value;
//				invalidateTarget();
//			}
//		}

		
		/**
		 * Distance between each item
		 */
		public function get depth() : Number
		{
			return _depth;
		}

		public function set depth( value : Number ) : void
		{
			if( _depth == _depth ) return;
			
			_zChanged = true;
			_depth = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		public function get numVisibleItems() : Number
		{
			return _numVisibleItems;
		}
		
		public function set numVisibleItems( value : Number ) : void
		{
			if( _numVisibleItems == value ) return;
			
			_zChanged = true;
			_numVisibleItems = value;
			invalidateTargetSizeAndDisplayList();
		}

		public function get horizontalDisplacement() : Number
		{
			return _horizontalDisplacement;
		}

		public function set horizontalDisplacement( value : Number ) : void
		{
			if ( _horizontalDisplacement != value )
			{
				_horizontalDisplacement = value * .01;
				invalidateTargetSizeAndDisplayList();
			}
		}

		public function get verticalDisplacement() : Number
		{
			return _verticalDisplacement;
		}

		public function set verticalDisplacement( value : Number ) : void
		{
			if ( _verticalDisplacement != value )
			{
				_verticalDisplacement = value * .01;
				invalidateTargetSizeAndDisplayList();
			}
		}

		public function CoverflowLayout()
		{
			super();
			
			_zChanged = true;
			useVirtualLayout = true;
			_numVisibleItems = 2;
		}


		override public function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if( _zChanged )
			{
				_zChanged = false;
				
				_depthDelta = _depth / _numVisibleItems;
				_alphaDelta = 1 / ( _numVisibleItems );
			}

			trace( "jjjjjjjjjjjjjj", target.verticalScrollPosition, Scroller( target.parent.parent ).verticalScrollBar );
			target.setContentSize( unscaledWidth, unscaledHeight * target.numElements );
			
			
			
			var d:Number = ( unscaledHeight * (target.numElements - 1) )/ ( target.numElements - 1 );
			
			//trace( d, "jkjkjkjkj", getScrollPositionDeltaToElement( i ) );
			
			const indexPercent:Number = ( target.verticalScrollPosition % d ) / d;
			
			const zDeltaOffset:Number = _depthDelta * indexPercent;
			const alphaDeltaOffset:Number = _alphaDelta * indexPercent;
			
			const firstIndex:int = Math.floor( ( target.numElements - 1 ) * ( target.verticalScrollPosition / ( unscaledHeight * ( target.numElements - 1 ) ) ) );
			const numVirtualItems:int = Math.min( _numVisibleItems + 1, ( target.numElements ) - firstIndex );
			
			var element:IVisualElement;
			var matrix : Matrix3D;
			var z:Number;
			
			
			// Manage first item outside the loop as its slightly different
			element = target.getVirtualElementAt( firstIndex );
			element.setLayoutBoundsSize( NaN, NaN, false ); // reset size
			element.depth = numVirtualItems;
			element.alpha = 1 - indexPercent;
			
			z = -_depthDelta * indexPercent;
			
			matrix = new Matrix3D();
			matrix.appendTranslation( 0, 0, z );
			////				matrix.appendTranslation( unscaledWidth * .5 - ( element.getPreferredBoundsWidth() * .5 ), unscaledHeight * .5 - ( element.getPreferredBoundsHeight() * .5 ), 0 ); // center element in container
			element.setLayoutMatrix3D( matrix, false );
			
			
			
			for( var i:int = 1; i < numVirtualItems; i++ )
			{
				z = ( _depthDelta * i ) - zDeltaOffset;
				
				matrix = new Matrix3D();
				matrix.appendTranslation( 0, 0, z );
				
				element = target.getVirtualElementAt( firstIndex + i )
				element.setLayoutBoundsSize( NaN, NaN, false ); // reset size
				element.depth = numVirtualItems - i;
				element.alpha = 1 - ( ( _alphaDelta * i ) - alphaDeltaOffset );
				element.setLayoutMatrix3D( matrix, false );
			}
		}

		override protected function scrollPositionChanged() : void
		{
			if( !target ) return;
			
			target.invalidateDisplayList();
		}

		override public function getScrollPositionDeltaToElement( index:int ):Point
		{
			return new Point( 0, ( target.scrollRect.height * (target.numElements - 1) )/ ( target.numElements - 1 ) * index );
		}
		
		override public function updateScrollRect( w:Number, h:Number ) : void
		{
			if( !target ) return;

			if( clipAndEnableScrolling )
			{
				// Since scroll position is reflected in our 3D calculations,
				// always set the top-left of the srcollRect to (0,0).
				target.scrollRect = new Rectangle( 0, 0, w, h );
			}
			else
			{
				target.scrollRect = null;
			}
		}

		private function invalidateTargetSizeAndDisplayList() : void
		{
			if( !target ) return;
			
			target.invalidateSize();
			target.invalidateDisplayList();
		}
	}
}