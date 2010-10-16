package ws.tink.spark.layouts
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.ILayoutElement;
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.effects.EffectInstance;
	import mx.effects.IEffect;
	import mx.effects.IEffectInstance;
	import mx.events.EffectEvent;
	
	import spark.components.supportClasses.GroupBase;
	import spark.effects.Fade;
	import spark.effects.Move;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	import spark.layouts.supportClasses.LayoutBase;
	import spark.utils.BitmapUtil;
	
	import ws.tink.spark.layouts.supportClasses.NavigatorLayoutBase;

	use namespace mx_internal;
	
	/**
	 * Flex 4 Time Machine Layout
	 */
	public class StackLayout extends NavigatorLayoutBase
	{
		
		private var _bitmapFrom		: BitmapData;
		private var _bitmapTo		: BitmapData
		
		private var _stackIndex		: int = -2;
		
//		private var _numVirtualItems	: int = 1;
		
		public var effect			: IEffect;
		private var _effectInstance		: EffectInstance;
		private var _selectedElement		: IVisualElement;
		
		private var _elementMaxDimensions		: ElementMaxDimensions;
		
//		private var _targetChanged				: Boolean;
		
		private var _numElementsInLayout		: int;
		private var _numElementsNotInLayout		: int;
		
		

		private var _verticalAlign:String = VerticalAlign.TOP;
		[Inspectable(category="General", enumeration="top,bottom,middle,justify,contentJustify", defaultValue="top")]
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
		
		
		
		private var _horizontalAlign:String = HorizontalAlign.JUSTIFY;
		[Inspectable(category="General", enumeration="left,right,center,justify,contentJustify", defaultValue="left")]
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
		
		override public function set target(value:GroupBase):void
		{
			if( target == value ) return;
			
			super.target = value;
			
			_elementMaxDimensions = new ElementMaxDimensions();
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if( _effectInstance ) _effectInstance.end();
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			var i:int;
			
			if( !renderingData )
			{
				if( _numElementsInLayout != numElementsInLayout )
				{
					_numElementsInLayout = numElementsInLayout;
					for( i = 0; i < _numElementsInLayout; i++ )
					{
						elements[ indicesInLayout[ i ] ].visible = ( i == selectedIndex );
					}
				}
				
				if( _numElementsNotInLayout != numElementsNotInLayout )
				{
					_numElementsNotInLayout = numElementsNotInLayout;
					for( i = 0; i < _numElementsNotInLayout; i++ )
					{
						elements[ indicesInLayout[ i ] ].visible = true;
					}
				}
			}
			
			if( _stackIndex != selectedIndex )
			{
				if( effect && _stackIndex >= 0 )
				{
					target.validateNow();
					
					_bitmapTo = BitmapUtil.getSnapshot(IUIComponent(target));
					
					Object( effect ).bitmapTo = _bitmapTo;
					Object( effect ).bitmapFrom = _bitmapFrom;
					_effectInstance = EffectInstance( effect.play( [ target ] )[ 0 ] );
					_effectInstance.addEventListener( EffectEvent.EFFECT_END, onEffectEnd, false, 0, true );
					
					Object( effect ).bitmapTo = null;
					Object( effect ).bitmapFrom = null;
				}
				
				_stackIndex = selectedIndex;
			}
		}
		
		/**
		 *  @inheritDoc
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateDisplayListVirtual():void
		{
			super.updateDisplayListVirtual();
			
			if( _selectedElement ) _selectedElement.visible = false;
			
			if( target.numElements == 0 ) return;
			
			var eltWidth:Number = ( horizontalAlign == HorizontalAlign.JUSTIFY ) ?
				Math.max( 0, unscaledWidth ) : NaN;
			var eltHeight:Number = ( verticalAlign == VerticalAlign.JUSTIFY ) ?
				Math.max( 0, unscaledHeight ) : NaN;;
			
			_selectedElement = target.getVirtualElementAt( indicesInLayout[
				firstIndexInView ], eltWidth, eltHeight );
			
			if( !_selectedElement ) return;
			
			_elementMaxDimensions.update( _selectedElement );
			
			updateSelectedElementSizeAndPosition( _selectedElement );
			_selectedElement.visible = true;
			
			updateDepths( null );
		}
		
		
		/**
		 *  @inheritDoc
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateDisplayListReal():void
		{
			super.updateDisplayListReal();
			
			if( _selectedElement ) _selectedElement.visible = false;
			
			if( target.numElements == 0 ) return;
			
			var i:int;
			var element:IVisualElement;
			for( i = 0; i < numElementsInLayout; i++ )
			{
				element = target.getElementAt( indicesInLayout[ i ] );
				element.visible = false;
				if( i == firstIndexInView ) _selectedElement = element;
				
				_elementMaxDimensions.update( element );
			}
			
			for( i = 0; i < numElementsInLayout; i++ )
			{
				element = target.getElementAt( indicesInLayout[ i ] );
				updateSelectedElementSizeAndPosition( element );
			}
			
			if( _selectedElement ) _selectedElement.visible = true;
			
			updateDepths( null );
		}
		
		
		private function updateSelectedElementSizeAndPosition( element:IVisualElement ):void
		{
			var w:Number = calculateElementWidth( element, unscaledWidth, _elementMaxDimensions.width );
			var h:Number = calculateElementHeight( element, unscaledHeight, _elementMaxDimensions.height );
			
			element.setLayoutBoundsSize( w, h );
			element.setLayoutBoundsPosition( calculateElementX( w ), calculateElementY( h ) );
		}
		
		/**
		 *	@private
		 * 
		 *	Sets the depth of elements inlcuded in the layout at depths
		 *	to display correctly for the z position set with transformAround.
		 * 
		 *	Also sets the depth of elements that are not included in the layout.
		 *	The depth of these is dependent on whether their element index is before
		 *	or after the index of the selected element.
		 */
		private function updateDepths( depths:Vector.<int> ):void
		{
			var element:IVisualElement;
			var i:int;
			var numElementsNotInLayout:int = indicesNotInLayout.length;
			for( i = 0; i < numElementsNotInLayout; i++ )
			{
				element = target.getElementAt( indicesNotInLayout[ i ] );
				element.depth = indicesNotInLayout[ i ];
			}
			
			//FIXME tink, -1 to allow for bug
			_selectedElement.depth = ( indicesInLayout[ selectedIndex ] == 0 ) ? -1 : indicesInLayout[ selectedIndex ];
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
			
			element.visible = true;
		}
		
		/**
		 *  @private
		 * 
		 *  Used only for virtual layout.
		 */
		private function calculateElementWidth( element:ILayoutElement, targetWidth:Number, containerWidth:Number ):Number
		{
			// If percentWidth is specified then the element's width is the percentage
			// of targetWidth clipped to min/maxWidth and to (upper limit) targetWidth.
			var percentWidth:Number = element.percentWidth;
			if( !isNaN( percentWidth ) )
			{
				var width:Number = percentWidth * 0.01 * targetWidth;
				return Math.min( targetWidth, Math.min( element.getMaxBoundsWidth(), Math.max( element.getMinBoundsWidth(), width ) ) );
			}
			switch( horizontalAlign )
			{
				case HorizontalAlign.JUSTIFY :
				{
					return targetWidth;
				}
				case HorizontalAlign.CONTENT_JUSTIFY : 
				{
					return Math.max( element.getPreferredBoundsWidth(), containerWidth );
				}
			}
			return element.getPreferredBoundsWidth();  // not constrained
		}
		
		/**
		 *  @private
		 * 
		 *  Used only for virtual layout.
		 */
		private function calculateElementHeight( element:ILayoutElement, targetHeight:Number, containerHeight:Number):Number
		{
			// If percentWidth is specified then the element's width is the percentage
			// of targetWidth clipped to min/maxWidth and to (upper limit) targetWidth.
			var percentHeight:Number = element.percentHeight;
			if( !isNaN( percentHeight ) )
			{
				var height:Number = percentHeight * 0.01 * targetHeight;
				return Math.min( targetHeight, Math.min( element.getMaxBoundsHeight(), Math.max( element.getMinBoundsHeight(), height ) ) );
			}
			switch( verticalAlign )
			{
				case VerticalAlign.JUSTIFY :
				{
					return targetHeight;
				}
				case VerticalAlign.CONTENT_JUSTIFY : 
				{
					return Math.max( element.getPreferredBoundsHeight(), containerHeight );
				}
			}
			return element.getPreferredBoundsHeight();  // not constrained
		}
		
		
		/**
		 *  @private
		 */
		private function calculateElementX( w:Number ):Number
		{
			switch( horizontalAlign )
			{
				case HorizontalAlign.RIGHT :
				{
					return unscaledWidth - w;
				}
				case HorizontalAlign.CENTER :
				{
					return ( unscaledWidth - w ) / 2;
				}
				default :
				{
					return 0;
				}
			}
		}
		
		/**
		 *  @private
		 */
		private function calculateElementY( h:Number ):Number
		{
			switch( verticalAlign )
			{
				case VerticalAlign.BOTTOM :
				{
					return unscaledHeight - h;
				}
				case VerticalAlign.MIDDLE :
				{
					return ( unscaledHeight - h ) / 2;
				}
				default :
				{
					return 0;
				}
			}
		}
		
		
		protected function onEffectEnd( event:EffectEvent ):void
		{
			_effectInstance.removeEventListener( EffectEvent.EFFECT_END, onEffectEnd, false );
			_effectInstance = null;
			
			_bitmapTo.dispose();
			_bitmapFrom.dispose();
		}
		
//		override protected function scrollPositionChanged() : void
//		{
//			super.scrollPositionChanged();
//			
//			if( !target ) return;
//			
//			
//		}
		
		override protected function updateSelectedIndex( index:int, offset:Number ):void
		{
			if( selectedIndex == index ) return;
			
			if( effect && selectedIndex >= 0 )
			{
				try
				{
					_bitmapFrom = BitmapUtil.getSnapshot(IUIComponent(target));
				}
				catch( e:Error )
				{
					_bitmapFrom = new BitmapData( 30, 30, false, 0x000000 );
					
				}
			}
			
			super.updateSelectedIndex( index, offset );
			
			var firstIndexInView:int;
			
			if( selectedIndexOffset < 0 )
			{
				firstIndexInView = selectedIndex - 1;
			}
			else
			{
				firstIndexInView = selectedIndex;
			}
			
			indicesInView( firstIndexInView, 1 );
		}
		
	}
}
import mx.core.ILayoutElement;

class ElementMaxDimensions
{
	
	private var _width	: Number;
	private var _height	: Number;
	
	public function ElementMaxDimensions()
	{
		
	}
	
	public function update( element:ILayoutElement ):void
	{
		var w:Number = Math.min( element.getPreferredBoundsWidth(), element.getLayoutBoundsWidth() );
		var h:Number = Math.min( element.getPreferredBoundsHeight(), element.getLayoutBoundsHeight() );
		if( w > _width ) w = _width;
		if( h > _height ) w = _height;
	}
	
	public function get width():Number
	{
		return _width;
	}
	
	public function get height():Number
	{
		return _height;
	}
	

}