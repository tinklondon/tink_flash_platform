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

package ws.tink.spark.layouts.supportClasses
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Timer;
	
	import mx.controls.scrollClasses.ScrollBarDirection;
	import mx.core.ISelectableList;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.GroupBase;
	import spark.events.IndexChangeEvent;

	[Event(name="complete", type="flash.events.Event")]
	public class EasedNavigatorLayoutBase extends NavigatorLayoutBase
	{
		
		private var _easingSnap				: Number = 0.03;
		private var _stepEasing				: Number = 0.15;
		private var _isEasing				: Boolean;
		
		private var _visibleHorizontalScrollPosition: Number = 0;
		private var _visibleVerticalScrollPosition	: Number = 0;
		
		private var _stage			: Stage;
		
		private var _proposedSelectedIndex			: int = -1;
		private var _proposedSelectedIndexOffset	: Number = 0;
		
		
		public function EasedNavigatorLayoutBase()
		{
			super();
		}
		
		
		[Inspectable(category="General", defaultValue="0.5")]
		public function get easingSnap():Number
		{
			return _easingSnap;
		}
		public function set easingSnap( value:Number ):void
		{
			_easingSnap = value;
		}
		
		[Inspectable(category="General", defaultValue="0.3")]
		public function get stepEasing():Number
		{
			return _stepEasing;
		}
		public function set stepEasing(value:Number):void
		{
			_stepEasing = value;
		}
		
		override public function set target(value:GroupBase):void
		{
			if( target == value ) return;
			
			removeTargetListeners();
			onTargetRemovedFromStage( new Event( Event.REMOVED_FROM_STAGE ) );
			
			super.target = value;
			
			if( target )
			{
				addTargetListeners();
				
				_visibleHorizontalScrollPosition = target.verticalScrollPosition;
				_visibleVerticalScrollPosition = target.horizontalScrollPosition;
				
				if( target.stage ) onTargetAddedToStage( new Event( Event.ADDED_TO_STAGE ) );
			}
		}
		
//		override protected function scrollPositionChanged() : void
//		{
//			if( !target ) return;
//			
//			var targetScrollPosition:Number;
//			var scrollPosition:Number;
//			var indexMaxScroll:Number;
//			switch( scrollBarDirection )
//			{
//				case ScrollBarDirection.HORIZONTAL :
//				{
//					targetScrollPosition = horizontalScrollPosition;
//					scrollPosition = _visibleVerticalScrollPosition = getEasedScrollPosition( _visibleHorizontalScrollPosition, targetScrollPosition )
//					indexMaxScroll = ( unscaledWidth * target.numElements ) / target.numElements;
//					break;
//				}
//				case ScrollBarDirection.VERTICAL :
//				{
//					targetScrollPosition = verticalScrollPosition;
//					scrollPosition = _visibleVerticalScrollPosition = getEasedScrollPosition( _visibleVerticalScrollPosition, targetScrollPosition )
//					indexMaxScroll = ( unscaledHeight * target.numElements ) / target.numElements;
//					break;
//				}
//			}
//			
//			if( scrollPosition != targetScrollPosition )
//			{
//				if( !_isEasing )
//				{
//					_isEasing = true;
//					_stage.addEventListener( Event.ENTER_FRAME, onStageEnterFrame, false, 0, true );
//				}
//			}
//			else if( _isEasing )
//			{
//				_isEasing = false;
//				_stage.removeEventListener( Event.ENTER_FRAME, onStageEnterFrame, false );
//			}
//			
//			updateSelectedIndex( Math.round( scrollPosition / indexMaxScroll ),
//				( scrollPosition % indexMaxScroll > indexMaxScroll / 2 ) ? -( 1 - ( scrollPosition % indexMaxScroll ) / indexMaxScroll ) : ( scrollPosition % indexMaxScroll ) / indexMaxScroll );
//		}
		
		private function getEasedScrollPosition( currentPosition:Number, targetPosition:Number ):Number
		{
			var diff:Number = ( targetPosition - currentPosition );
			
			var ease:Number = ( _stage ) ? _stepEasing : 1;
			if( Math.abs( diff ) > _easingSnap )
			{
				return currentPosition + ( diff * ease );
			}
			else
			{
				return targetPosition;
			}
		}
		
		
		override protected function updateSelectedIndex( index:int, offset:Number ):void
		{
			if( index == _proposedSelectedIndex && _proposedSelectedIndexOffset == offset ) return;
			
			if( selectedIndex == -1 )
			{
				super.updateSelectedIndex( index, offset );
				selectedIndexChange();
			}
			else
			{
				_proposedSelectedIndex = index;
				_proposedSelectedIndexOffset = offset;
				
				easeSelectedIndex();
			}
		}
		
		
		protected function easeSelectedIndex():void
		{
			var currentValue:Number = selectedIndex + selectedIndexOffset;
			var targetValue:Number = _proposedSelectedIndex + _proposedSelectedIndexOffset;
			var diff:Number = targetValue - currentValue;
			
			var newValue:Number;
			
			var ease:Number = ( _stage ) ? _stepEasing : 1;
			if( Math.abs( diff ) > _easingSnap )
			{
				newValue = currentValue + ( diff * ease );
				
				// startEasing
				if( !_isEasing )
				{
					_isEasing = true;
					_stage.addEventListener( Event.ENTER_FRAME, onStageEnterFrame, false, 0, true );
					dispatchEvent( new IndexChangeEvent( IndexChangeEvent.CHANGING ) );
				}
			}
			else
			{
				newValue = targetValue;
				
				// stop the easing we have reached the target
				if( _isEasing )
				{
					_isEasing = false;
					_stage.removeEventListener( Event.ENTER_FRAME, onStageEnterFrame, false );
					dispatchEvent( new Event( Event.COMPLETE ) );
				}
			}
			
			var index:int = Math.round( newValue );
			var offset:Number;
			//now set the current value
			if( index > newValue )
			{
				// round up
				super.updateSelectedIndex( index, newValue - index );
			}
			else
			{
				// round down
				super.updateSelectedIndex( index, newValue - index );
			}
			
			selectedIndexChange();
		}
		
		protected function selectedIndexChange():void
		{
			
		}
		
		private function onTargetAddedToStage( event:Event ):void
		{
			_stage = target.stage;
		}
		
		private function onTargetRemovedFromStage( event:Event ):void
		{
			if( _stage && _isEasing )
			{
				if( _isEasing )
				{
					_isEasing = false;
					_stage.removeEventListener( Event.ENTER_FRAME, onStageEnterFrame, false );
					_visibleHorizontalScrollPosition = target.verticalScrollPosition;
					_visibleVerticalScrollPosition = target.horizontalScrollPosition;
					scrollPositionChanged();
				}
				
				_stage = null;
			}
		}
		
		private function onStageEnterFrame( event:Event ):void
		{
			easeSelectedIndex();
		}
		
		public function addTargetListeners():void
		{
			if( !target ) return;
			
			target.addEventListener( Event.ADDED_TO_STAGE, onTargetAddedToStage, false, 0, true );
			target.addEventListener( Event.REMOVED_FROM_STAGE, onTargetRemovedFromStage, false, 0, true );
		}
		
		public function removeTargetListeners():void
		{
			if( !target ) return;
			
			target.addEventListener( Event.ADDED_TO_STAGE, onTargetAddedToStage, false );
			target.addEventListener( Event.REMOVED_FROM_STAGE, onTargetRemovedFromStage, false );
		}
		
		
	}
}