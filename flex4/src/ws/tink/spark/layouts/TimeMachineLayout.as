package ws.tink.spark.layouts
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.describeType;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.validators.EmailValidator;
	
	import spark.components.Scroller;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	import spark.layouts.supportClasses.LayoutBase;
	import spark.primitives.supportClasses.GraphicElement;
	
	import ws.tink.spark.layouts.supportClasses.PerspectiveNavigatorLayoutBase;

	/**
	 * Flex 4 Time Machine Layout
	 */
	public class TimeMachineLayout extends PerspectiveNavigatorLayoutBase
	{

		private var _maximumZ 		: Number = 300;
		
		private var _zDelta : Number;
		private var _colorDelta : Number;
		
		private var _zChanged			: Boolean;
		private var _numVisibleElements		: int;
		
		private var _visibleElements	: Vector.<IVisualElement>;
		private var _colorTransform	: ColorTransform;
		private var _depthColor		: int = -1;
		
		public function TimeMachineLayout()
		{
			super();
			
			_zChanged = true;
			useVirtualLayout = true
			_numVisibleElements = 3;
			_colorTransform = new ColorTransform();
			_depthColor = -1;
		}
		
		
//		public function get numIndicesInView():int
//		{
//			return _numIndicesInView;
//		}
//		
		public function get numVisibleElements():int
		{
			return _numVisibleElements;
		}
		public function set numVisibleElements( value:int ) : void
		{
			if( _numVisibleElements == value ) return;
			
			_numVisibleElements = value;
			invalidateTargetDisplayList();
		}
		
		public function get depthColor():int
		{
			return _depthColor;
		}
		public function set depthColor( value:int ) : void
		{
			if( _depthColor == value ) return;
			
			_depthColor = value;
			invalidateTargetDisplayList();
		}
		
		
		private var _verticalAlign:String = VerticalAlign.MIDDLE;
		[Inspectable(category="General", enumeration="top,bottom,middle", defaultValue="middle")]
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		public function set verticalAlign(value:String):void
		{
			if( value == _verticalAlign ) return;
			
			_verticalAlign = value;
			
			invalidateTargetDisplayList();
		}
		
		
		private var _horizontalAlign:String = HorizontalAlign.CENTER;
		[Inspectable(category="General", enumeration="left,right,center", defaultValue="center")]
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		public function set horizontalAlign(value:String):void
		{
			if( value == _horizontalAlign ) return;
			
			_horizontalAlign = value;
			
			invalidateTargetDisplayList();
		}
		
		
		private var _horizontalAlignOffset:Number = 0;
		[Inspectable(category="General", defaultValue="0")]
		public function get horizontalOffset():Number
		{
			return _horizontalAlignOffset;
		}
		public function set horizontalOffset(value:Number):void
		{
			if( _horizontalAlignOffset == value ) return;
			
			_horizontalAlignOffset = value;
			invalidateTargetDisplayList();
		}    
		
		private var _verticalAlignOffset:Number = 0;
		[Inspectable(category="General", defaultValue="0")]
		public function get verticalOffset():Number
		{
			return _verticalAlignOffset;
		}
		public function set verticalOffset(value:Number):void
		{
			if( _verticalAlignOffset == value ) return;
			
			_verticalAlignOffset = value;
			invalidateTargetDisplayList();
		}    

		
		/**
		 * Distance between each item
		 */
		[Inspectable(category="General", defaultValue="300")]
		public function get maximumZ() : Number
		{
			return _maximumZ;
		}

		public function set maximumZ( value : Number ) : void
		{
			if( _maximumZ == value ) return;
			
			_zChanged = true;
			_maximumZ = value;
			invalidateTargetDisplayList();
		}
		
		private var _horizontalDisplacement:Number = 0;
		[Inspectable(category="General")]
		public function get horizontalDisplacement() : Number
		{
			return _horizontalDisplacement;
		}

		public function set horizontalDisplacement( value : Number ) : void
		{
			if ( _horizontalDisplacement != value )
			{
				_horizontalDisplacement = value;
				invalidateTargetDisplayList();
			}
		}

		
		private var _verticalDisplacement:Number = 0;
		[Inspectable(category="General")]
		public function get verticalDisplacement() : Number
		{
			return _verticalDisplacement;
		}

		public function set verticalDisplacement( value : Number ) : void
		{
			if ( _verticalDisplacement != value )
			{
				_verticalDisplacement = value;
				invalidateTargetDisplayList();
			}
		}

		override public function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			if( _zChanged )
			{
				_zChanged = false;
				
				_zDelta = _maximumZ / ( _numVisibleElements + 1 );
				_colorDelta = 1 / ( _numVisibleElements );
			}
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
		}
		
		override protected function updateDisplayListVirtual():void
		{
			super.updateDisplayListVirtual();
			
			var prevVirtualElements:Vector.<IVisualElement> = ( _visibleElements ) ? _visibleElements.concat() : new Vector.<IVisualElement>();
			_visibleElements = new Vector.<IVisualElement>();
			
			const firstIndexInViewOffsetPercent:Number = ( selectedIndexOffset < 0 ) ? 1 + selectedIndexOffset : selectedIndexOffset;
			const zDeltaOffset:Number = _zDelta * firstIndexInViewOffsetPercent;
			const alphaDeltaOffset:Number = _colorDelta * firstIndexInViewOffsetPercent;
			
			var i:int;
			var element:IVisualElement;
			
			// Manage first item outside the loop as its slightly different
			element = target.getVirtualElementAt( firstIndexInView );
			if( element )
			{
				updateFirstElementInView( element, firstIndexInViewOffsetPercent );
				updateVisibleElements( element, prevVirtualElements );
			}
			
			for( i = 1; i < numIndicesInView; i++ )
			{
				element = target.getVirtualElementAt( firstIndexInView + i );
				if( !element ) continue;
				updateElementInView( element, i, firstIndexInViewOffsetPercent, alphaDeltaOffset, zDeltaOffset );
				updateVisibleElements( element, prevVirtualElements );
			}
			
			var numPrev:int = prevVirtualElements.length;
			for( i = 0; i < numPrev; i++ )
			{
				IVisualElement( prevVirtualElements[ i ] ).visible = false;
			}
		}
		
		override protected function updateDisplayListReal():void
		{
			super.updateDisplayListReal();
			
			var prevVirtualElements:Vector.<IVisualElement> = ( _visibleElements ) ? _visibleElements.concat() : new Vector.<IVisualElement>();
			_visibleElements = new Vector.<IVisualElement>();
			
			const firstIndexInViewOffsetPercent:Number = ( selectedIndexOffset < 0 ) ? 1 + selectedIndexOffset : selectedIndexOffset;
			const zDeltaOffset:Number = _zDelta * firstIndexInViewOffsetPercent;
			const alphaDeltaOffset:Number = _colorDelta * firstIndexInViewOffsetPercent;
			
			var element:IVisualElement;
			var numElements:int = target.numElements;
			for( var i:int = 0; i < numElements; i++ )
			{
//				if( i < firstIndexInView || i > lastIndexInView )
//				{
//					element = target.getElementAt( i );
//					element.visible = false;
//				}
//				else if( i == firstIndexInView )
//				{
//					element = target.getElementAt( i );
//					updateFirstElementInView( element, firstIndexInViewOffsetPercent );
//					updateVisibleElements( element, prevVirtualElements );
//				}
//				else
//				{
//					element = target.getElementAt( firstIndexInView + i );
//					updateElementInView( element, i, firstIndexInViewOffsetPercent, alphaDeltaOffset, zDeltaOffset );
//					updateVisibleElements( element, prevVirtualElements );
//				}
			}
		}
		
		protected function updateFirstElementInView( element:IVisualElement, firstIndexInViewOffsetPercent:Number ):void
		{
			setElementLayoutBoundsSize( element, false );
			element.depth = numIndicesInView;
			_colorTransform.redMultiplier = _colorTransform.greenMultiplier = _colorTransform.blueMultiplier = 1;
			_colorTransform.alphaMultiplier = 1 - firstIndexInViewOffsetPercent;
			_colorTransform.redOffset = _colorTransform.greenOffset = _colorTransform.blueOffset = _colorTransform.alphaOffset = 0;
			applyColorTransformToElement( element, _colorTransform );
			
			var matrix:Matrix3D = new Matrix3D();
			matrix.appendTranslation( 
				getTimeMachineElementX( unscaledWidth, element.getLayoutBoundsWidth( false ), 0 , firstIndexInViewOffsetPercent ),
				getTimeMachineElementY( unscaledHeight, element.getLayoutBoundsHeight( false ), 0 , firstIndexInViewOffsetPercent ),
				-_zDelta * firstIndexInViewOffsetPercent
			);
			element.setLayoutMatrix3D( matrix, false );
			element.visible = true;
		}
		
		protected function updateElementInView( element:IVisualElement, viewIndex:int, firstIndexInViewOffsetPercent:Number, alphaDeltaOffset:Number, zDeltaOffset:Number ):void
		{
			var colorValue:Number = ( ( _colorDelta * viewIndex ) - alphaDeltaOffset );
			setElementLayoutBoundsSize( element, false );
			element.depth = numIndicesInView - viewIndex;
			
			if( _depthColor > -1 )
			{
				_colorTransform.color = _depthColor;
				_colorTransform.redOffset *= colorValue;
				_colorTransform.greenOffset *= colorValue;
				_colorTransform.blueOffset *= colorValue;
				_colorTransform.alphaMultiplier = ( colorValue == 1 ) ? 0 : 1;
				_colorTransform.redMultiplier = _colorTransform.greenMultiplier = _colorTransform.blueMultiplier = 1 - colorValue;
			}
			else
			{
				_colorTransform.alphaMultiplier = _colorTransform.redMultiplier = _colorTransform.greenMultiplier = _colorTransform.blueMultiplier = 1;
				_colorTransform.redOffset = _colorTransform.greenOffset = _colorTransform.blueOffset = _colorTransform.alphaOffset = 0;
			}
			
			applyColorTransformToElement( element, _colorTransform );
			
			var matrix:Matrix3D = new Matrix3D();
			matrix.appendTranslation( getTimeMachineElementX( unscaledWidth, element.getLayoutBoundsWidth( false ), viewIndex, firstIndexInViewOffsetPercent ),
				getTimeMachineElementY( unscaledHeight, element.getLayoutBoundsHeight( false ), viewIndex, firstIndexInViewOffsetPercent ),
				( _zDelta * viewIndex ) - zDeltaOffset );
			element.setLayoutMatrix3D( matrix, false );
			element.visible = true;
		}
		
		private function updateVisibleElements( element:IVisualElement, prevElements:Vector.<IVisualElement> ):void
		{
			_visibleElements.push( element );
			var prevIndex:int = prevElements.indexOf( element );
			if( prevIndex >= 0 ) prevElements.splice( prevIndex, 1 );
		}
		
		protected function getElementX( unscaledWidth:Number, elementWidth:Number ):Number
		{
			switch( horizontalAlign )
			{
				case HorizontalAlign.LEFT :
				{
					return Math.round( horizontalOffset );
				}
				case HorizontalAlign.RIGHT :
				{
					return Math.round( unscaledWidth - elementWidth + horizontalOffset );
				}
				default :
				{
					return Math.round( ( ( unscaledWidth - elementWidth ) / 2 )  + horizontalOffset );
				}
			}
			return 1;
		}
		
		protected function getElementY( unscaledHeight:Number, elementHeight:Number ):Number
		{
			switch( verticalAlign )
			{
				case VerticalAlign.TOP :
				{
					return Math.round( verticalOffset );
				}
				case VerticalAlign.BOTTOM :
				{
					return Math.round( unscaledHeight - elementHeight + verticalOffset );
				}
				default :
				{
					return Math.round( ( ( unscaledHeight - elementHeight ) / 2 )  + verticalOffset );
				}
			}
		}
		
		protected function getTimeMachineElementX( unscaledWidth:Number, elementWidth:Number, i:int, offset:Number ):Number
		{
			return getElementX( unscaledWidth, elementWidth ) + ( ( _horizontalDisplacement * i ) - ( _horizontalDisplacement * offset ) );
		}
		
		protected function getTimeMachineElementY( unscaledHeight:Number, elementHeight:Number, i:int, offset:Number ):Number
		{
			return getElementY( unscaledHeight, elementHeight ) + ( ( _verticalDisplacement * i ) - ( _verticalDisplacement * offset ) );
		}
		
		
		override protected function selectedIndexChange():void
		{
			super.selectedIndexChange();
			
			var firstIndexInView:int;
			
			if( selectedIndexOffset < 0 )
			{
				firstIndexInView = selectedIndex - 1;
			}
			else
			{
				firstIndexInView = selectedIndex;
			}
			
			indicesInView( firstIndexInView, Math.min( _numVisibleElements + 1, target.numElements - firstIndexInView ) );
		}

	}
}