package ws.tink.spark.layouts.supportClasses
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.controls.scrollClasses.ScrollBar;
	import mx.controls.scrollClasses.ScrollBarDirection;
	import mx.core.ISelectableList;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.InvalidateRequestData;
	import mx.utils.OnDemandEventDispatcher;
	
	import spark.components.Scroller;
	import spark.components.supportClasses.GroupBase;
	import spark.components.supportClasses.ScrollBarBase;
	import spark.core.NavigationUnit;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	import spark.layouts.supportClasses.LayoutBase;
	
	use namespace mx_internal;
	
	public class NavigatorLayoutBase extends LayoutBase implements INavigatorLayout
	{
		
		
		private var _scrollBarDirection		: String;
		
		private var _selectedIndexOffset	: Number = 0;
		private var _selectedIndex			: int = -1;
		
		
		private var _firstIndexInView		: int;
		private var _lastIndexInView		: int;
		private var _numIndicesInView		: int;
		
//		private var _stepScrollBar			: Boolean = true;
		
		
		private var _targetChanged					: Boolean;
		private var _useScrollBarForNavigation			: Boolean;
		
		public function get lastIndexInView():int
		{
			return _lastIndexInView;
		}
		public function get firstIndexInView():int
		{
			return _firstIndexInView;
		}
		public function get numIndicesInView():int
		{
			return _numIndicesInView;
		}
		
		
		
		public function NavigatorLayoutBase()
		{
			super();
			trace( "NavigatorLayoutBase " );
			useVirtualLayout = true;
			useScrollBarForNavigation = true;
			
			_scrollBarDirection = ScrollBarDirection.VERTICAL;
		}	
		
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		public function get useScrollBarForNavigation():Boolean
		{
			return _useScrollBarForNavigation;
		}
		public function set useScrollBarForNavigation(value:Boolean):void
		{
			if( value == _useScrollBarForNavigation ) return;
			
			_useScrollBarForNavigation = value;
			
			invalidateTargetDisplayList();
		}
		
//		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
//		public function get stepScrollBar():Boolean
//		{
//			return _stepScrollBar;
//		}
//		public function set stepScrollBar(value:Boolean):void
//		{
//			if( value == _stepScrollBar ) return;
//			
//			_stepScrollBar = value;
//			
//			invalidateTargetDisplayList();
//		}
		
		override public function set target(value:GroupBase):void
		{
			if( target == value ) return;
			
			super.target = value;
			
			_targetChanged = true;
		}
		
		
		
		public function get selectedIndexOffset():Number
		{
			return _selectedIndexOffset;
		}
		public function set selectedIndexOffset( value:Number ):void
		{
			if( _useScrollBarForNavigation )
			{
				updateScrollBar( _selectedIndex, value );
			}
			else
			{
				updateSelectedIndex( _selectedIndex, value );
			}
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		public function set selectedIndex( value:int ):void
		{
			if( _useScrollBarForNavigation && getScroller() )
			{
//				updateScrollBar( value, ( value == -1 ) ? 0 : _selectedIndexOffset );
				updateScrollBar( value, 0 );
			}
			else
			{
//				updateSelectedIndex( value, ( value == -1 ) ? 0 : _selectedIndexOffset );
				updateSelectedIndex( value, 0 );
			}
		}
		
		[Inspectable(category="General", enumeration="horizontal,vertical", defaultValue="vertical")]
		public function get scrollBarDirection():String
		{
			return _scrollBarDirection;
		}
		public function set scrollBarDirection( value:String ) : void
		{
			if( _scrollBarDirection == value ) return;
			
			switch( value )
			{
				case ScrollBarDirection.HORIZONTAL :
				case ScrollBarDirection.VERTICAL :
				{
					_scrollBarDirection = value;
					if( target ) scrollPositionChanged();
					break;
				}
				default :
				{
					
				}
			}
		}
		
		
		
		
		public function get unscaledWidth():Number
		{
			return _unscaledWidth;
		}
		
		public function get unscaledHeight():Number
		{
			return _unscaledHeight;
		}
		
		
		private var _unscaledWidth	: Number;
		private var _unscaledHeight	: Number;
		
		override public function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			_unscaledWidth = unscaledWidth;
			_unscaledHeight = unscaledHeight;
			
			if( target.numElements == 0 )
			{
				selectedIndex = -1;
			}
			else if( selectedIndex == -1 )
			{
				selectedIndex = 0;
			}
			
			if( _targetChanged )
			{
				_targetChanged = false;
				scrollPositionChanged();
			}
			
			if( _useScrollBarForNavigation )
			{
				updateScrollerForNavigation();
			}
			else
			{
				updateScrollerForContent();
			}
			
			if( useVirtualLayout )
			{
				updateDisplayListVirtual();
			}
			else
			{
				updateDisplayListReal();
			}
		}
		
		protected function updateScrollerForNavigation():void
		{
			var scroller:Scroller = getScroller();
			switch( scrollBarDirection )
			{
				case ScrollBarDirection.HORIZONTAL :
				{
					target.setContentSize( unscaledWidth * target.numElements, unscaledHeight );
					if( scroller ) scroller.horizontalScrollBar.stepSize = unscaledWidth;
					break;
				}
				case ScrollBarDirection.VERTICAL :
				{
					target.setContentSize( unscaledWidth, unscaledHeight * target.numElements );
					if( scroller ) scroller.verticalScrollBar.stepSize = unscaledHeight;
					break;
				}
			}
		}
		
		protected function updateScrollerForContent():void
		{
			target.setContentSize( unscaledWidth, unscaledHeight );
		}
		
		protected function updateDisplayListVirtual():void
		{
		}
		
		protected function updateDisplayListReal():void
		{
		}
		
		protected function setElementLayoutBoundsSize( element:IVisualElement, postLayoutTransform:Boolean = true ):void
		{
			element.setLayoutBoundsSize(
				( isNaN( element.percentWidth ) ) ? element.getPreferredBoundsWidth() : unscaledWidth * ( element.percentWidth / 100 ),
				( isNaN( element.percentHeight ) ) ? element.getPreferredBoundsHeight() : unscaledHeight * ( element.percentHeight / 100 ),
				postLayoutTransform );
		}
		
		override protected function scrollPositionChanged() : void
		{
			if( !target || !_useScrollBarForNavigation ) return;
			
			var scrollPosition:Number;
			var indexMaxScroll:Number;
			switch( scrollBarDirection )
			{
				
				case ScrollBarDirection.HORIZONTAL :
				{
					scrollPosition = horizontalScrollPosition;
					indexMaxScroll = ( _unscaledWidth * target.numElements ) / target.numElements;
					break;
				}
				case ScrollBarDirection.VERTICAL :
				{
					scrollPosition = verticalScrollPosition;
					indexMaxScroll = ( _unscaledHeight * target.numElements ) / target.numElements;
					break;
				}
			}
			
			updateSelectedIndex( Math.round( scrollPosition / indexMaxScroll ),
								( scrollPosition % indexMaxScroll > indexMaxScroll / 2 ) ? -( 1 - ( scrollPosition % indexMaxScroll ) / indexMaxScroll ) : ( scrollPosition % indexMaxScroll ) / indexMaxScroll );			
		}
		
		protected function updateScrollBar( index:int, offset:Number ):void
		{
			var scroller:Scroller = getScroller();
			switch( scrollBarDirection )
			{
				case ScrollBarDirection.HORIZONTAL :
				{
					target.horizontalScrollPosition = ( index + offset ) * _unscaledWidth;
				}
				case ScrollBarDirection.VERTICAL :
				{
					target.verticalScrollPosition = (  index + offset ) * _unscaledHeight;
				}
			}
		}
		
		protected function updateSelectedIndex( index:int, offset:Number ):void
		{
			if( _selectedIndex == index && _selectedIndexOffset == offset ) return;
			
			_selectedIndex = index;
			_selectedIndexOffset = offset;
			
			invalidateTargetDisplayList();
		}
		
		protected function indicesInView( firstIndexinView:int, numIndicesInView:int ):void
		{
			if( firstIndexinView == _firstIndexInView && _numIndicesInView == numIndicesInView ) return;
			
			_firstIndexInView = firstIndexinView;
			_numIndicesInView = numIndicesInView;
			
			_lastIndexInView = _firstIndexInView + _numIndicesInView;
			
			invalidateTargetDisplayList();
		}
		
		override public function updateScrollRect( w:Number, h:Number ) : void
		{
			if( !target ) return;
			
//			target.scrollRect = ( clipAndEnableScrolling ) ? new Rectangle( 0, 0, w, h ) : null
		}
		
		protected function invalidateTargetDisplayList() : void
		{
			if( !target ) return;

			target.invalidateDisplayList();
		}
		
		protected function getScroller() : Scroller
		{
			return target.parent.parent as Scroller;
		}
		
		
		override public function elementAdded( index:int ):void
		{
			if( selectedIndex == -1 ) selectedIndex = 0;
		}
		
		override public function elementRemoved(index:int):void
		{
			if( target.numElements == 0 ) selectedIndex = -1;
		}
		
		override public function getHorizontalScrollPositionDelta( navigationUnit:uint ):Number
		{
			if( _useScrollBarForNavigation )
			{
				switch( navigationUnit )
				{
					case NavigationUnit.PAGE_RIGHT :
					case NavigationUnit.RIGHT :
					{
						return unscaledWidth;
					}
					case NavigationUnit.END :
					{
						return ( unscaledWidth * ( target.numElements - 1 ) ) - horizontalScrollPosition;
					}
					case NavigationUnit.HOME :
					{
						return -horizontalScrollPosition;
					}
					case NavigationUnit.PAGE_LEFT :
					case NavigationUnit.LEFT :
					{
						return -unscaledWidth;
					}
					default :
					{
						return 0;
					}
				}
			}
			else
			{
				return super.getHorizontalScrollPositionDelta( navigationUnit );
			}
		}
		
		override public function getVerticalScrollPositionDelta( navigationUnit:uint ):Number
		{
			if( _useScrollBarForNavigation )
			{
				switch( navigationUnit )
				{
					case NavigationUnit.PAGE_DOWN :
					case NavigationUnit.DOWN :
					{
						return unscaledHeight;
					}
					case NavigationUnit.END :
					{
						return ( unscaledHeight * ( target.numElements - 1 ) ) - verticalScrollPosition;
					}
					case NavigationUnit.HOME :
					{
						return -verticalScrollPosition;
					}
					case NavigationUnit.PAGE_UP :
					case NavigationUnit.UP :
					{
						return -unscaledHeight;
					}
					default :
					{
						return 0;
					}
				}
			}
			else
			{
				return super.getVerticalScrollPositionDelta( navigationUnit );
			}
		}
		
	}
}