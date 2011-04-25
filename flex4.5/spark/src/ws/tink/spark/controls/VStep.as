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

package ws.tink.spark.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.VScrollBar;
	import spark.core.IViewport;
	import spark.core.NavigationUnit;
	import spark.effects.animation.Animation;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.IEaser;
	import spark.effects.easing.Linear;
	import spark.events.TrackBaseEvent;
	
	import ws.tink.spark.controls.supportClasses.AnimationTarget;
	
	use namespace mx_internal;
	
	public class VStep extends VScrollBar
	{
		
		private var selectedPage:int = 0;
		public function VStep()
		{
			super();
		}
		
		private var _easer:IEaser = new Linear();
		
		private var _numPages:int;
		public function get numPages():int
		{
			return _numPages;
		}
		
		override protected function button_buttonDownHandler(event:Event):void
		{
		}
		
		
		override protected function button_buttonUpHandler(event:Event):void
		{
		}
		
		override public function set viewport( newViewport:IViewport ):void
		{
			super.viewport = newViewport;
			
			updateNumPages();
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if( instance == decrementButton )
			{
				decrementButton.addEventListener(MouseEvent.CLICK, onClick, false, 0, true );
				decrementButton.addEventListener(MouseEvent.ROLL_OVER, button_rollOverHandler, false, 1);
				decrementButton.addEventListener(MouseEvent.ROLL_OUT, button_rollOutHandler, false, 1);
				decrementButton.autoRepeat = false;
			}
			else if ( instance == incrementButton )
			{
				incrementButton.addEventListener(MouseEvent.CLICK, onClick, false, 0, true );
				incrementButton.addEventListener(MouseEvent.ROLL_OVER, button_rollOverHandler, false, 1);
				incrementButton.addEventListener(MouseEvent.ROLL_OUT, button_rollOutHandler, false, 1);
				incrementButton.autoRepeat = false;
			}
		}
		
		private function button_rollOverHandler( event:MouseEvent ):void
		{
			event.stopImmediatePropagation();
		}
		
		private function button_rollOutHandler( event:MouseEvent ):void
		{
			event.stopImmediatePropagation();
		}
		
		
		private var trackPosition:Point = new Point();
		
		/**
		 *  @private
		 *  Handle mouse-down events for the scroll track. In our handler,
		 *  we figure out where the event occurred on the track and begin
		 *  paging the scroll position toward that location. We start a 
		 *  timer to handle repeating events if the user keeps the button
		 *  pressed on the track.
		 */
		override protected function track_mouseDownHandler( event:MouseEvent ):void
		{
			if ( !enabled ) return;
			
			trackPosition = track.globalToLocal(new Point(event.stageX, event.stageY));
			var newScrollValue:Number = pointToValue(trackPosition.x, trackPosition.y);
			
			var newPage:int = Math.floor( newScrollValue / pageSize );
			if( selectedPage != newPage )
			{
//				selectedPage = newPage;
//				animatePaging( pageSize * newPage, pageSize );
				setSelectedPage( newPage );
			}
		}
		
		
		/**
		 * @private
		 * this one animator is used by both paging and stepping animations. It
		 * is responsible for running the repeated operation (animating from the beginning
		 * of the repeat to whenever it ends or the user stops the repeating action).
		 */
		private var _animator:Animation = null;
		private function get animator():Animation
		{
			if (_animator)
				return _animator;
			_animator = new Animation();
			var animTarget:AnimationTarget = new AnimationTarget(animationUpdateHandler);
			animTarget.endFunction = animationEndHandler;
			_animator.animationTarget = animTarget;
			return _animator;
		}
		
		/**
		 * @private
		 * Handles events from the Animation that runs the page, step,
		 * and shift-click smooth-scrolling operations.
		 * Just call setValue() with the current animated value.
		 */
		private function animationUpdateHandler(animation:Animation):void
		{
			// TODO (klin): Add support to send change events at the right intervals.
			setValue(animation.currentValue["value"]);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * @private
		 * Handles end event from the Animation that runs the page, step,
		 * and shift-click animations.
		 * We dispatch the "change" event at this time, after the animation
		 * is done.
		 */
		private function animationEndHandler(animation:Animation):void
		{
			// End paging or shift-click animation.
			setValue(animation.currentValue["value"]);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * @private
		 */
		override protected function animatePaging(newValue:Number, duration:Number):void
		{
			dispatchEvent( new FlexEvent( FlexEvent.CHANGE_START) );
			
			trace( "animatePaging", duration );
			animator.stop();
			animator.duration = duration;
			animator.easer = _easer;
			animator.motionPaths = new <MotionPath>[ new SimpleMotionPath( "value", value, newValue ) ];
			animator.startDelay = 0;
			animator.play();
		}
		
		
		public function setSelectedPage( pageNum:int ):void
		{
			pageNum = Math.max( 0, Math.min( pageNum, _numPages - 1 ) );
				
			if( selectedPage != pageNum )
			{
				selectedPage = pageNum;
				var slideDuration:Number = getStyle("slideDuration");
				if (getStyle("smoothScrolling")&& slideDuration!=0)
				{
					animatePaging( pageSize * selectedPage, slideDuration );
				}
				else
				{
					setValue( pageSize * selectedPage );
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
		}
		
		
		
		/**
		 *  @private
		 *  Capture mouse-move events anywhere on or off the stage.
		 *  First, we calculate the new value based on the new position
		 *  using calculateNewValue(). Then, we move the thumb to 
		 *  the new value's position. Last, we set the value and
		 *  dispatch a "change" event if the value changes. 
		 */
		override protected function system_mouseMoveHandler(event:MouseEvent):void
		{
			if (!track) return;
			
			trackPosition = track.globalToLocal(new Point(event.stageX, event.stageY));
			var newScrollValue:Number = pointToValue(trackPosition.x, trackPosition.y);
			
			var newPage:int = Math.floor( newScrollValue / pageSize );
			
			if (newPage != selectedPage)
			{
				setSelectedPage( newPage );
				dispatchEvent(new TrackBaseEvent(TrackBaseEvent.THUMB_DRAG));
			}
			
			event.updateAfterEvent();
		}
		
		
		
		private function onClick( event:MouseEvent ):void
		{
			if( event.currentTarget == decrementButton )
			{
				if( selectedPage != 0 )
				{
					setSelectedPage( selectedPage - 1 );
				}
			}
			else if ( event.currentTarget == incrementButton )
			{
				if( selectedPage != 2 )
				{
					setSelectedPage( selectedPage + 1 );
				}
			}
			
			
		}
		
		private function updateNumPages():void
		{
			var viewportHeight:Number = isNaN(viewport.height) ? 0 : viewport.height;
			var viewportContentHeight:Number = isNaN(viewport.contentHeight) ? 0 : viewport.contentHeight;
			
			trace( "viewport", viewportContentHeight, viewportHeight );
			_numPages = Math.ceil( viewportContentHeight / viewportHeight );
		}
		
		/**
		 *  @private
		 *  Set this scrollbar's maximum to the viewport's contentHeight 
		 *  less the viewport height and its pageSize to the viewport's height. 
		 */
		override mx_internal function viewportResizeHandler(event:ResizeEvent):void
		{
			super.viewportResizeHandler(event)
			if( viewport ) updateNumPages();
		}
		
		/**
		 *  @private
		 *  Set this scrollbar's maximum to the viewport's contentHeight 
		 *  less the viewport height. 
		 */
		override mx_internal function viewportContentHeightChangeHandler(event:PropertyChangeEvent):void
		{
			super.viewportContentHeightChangeHandler(event)
			if( viewport ) updateNumPages();
		}
		
		
		/**
		*  @private
		*  Scroll vertically by event.delta "steps".  This listener is added to both the scrollbar 
		*  and the viewport so we short-ciruit if the viewport doesn't exist or isn't visible. 
		* 
		*  Note also: the HScrollBar class redispatches mouse wheel events that target the HSB 
		*  to its viewport.  If a vertical scrollbar exists, this listener will handle those
		*  events by scrolling vertically.   This is done so that if a VSB exists, the mouse
		*  wheel always scrolls vertically, even if it's over the HSB.
		*/
//		override mx_internal function mouseWheelHandler(event:MouseEvent):void
//		{
////			const vp:IViewport = viewport;
////			if (event.isDefaultPrevented() || !vp || !vp.visible)
////				return;
////			
////			var nSteps:uint = Math.abs(event.delta);
////			var navigationUnit:uint;
////			
////			// Scroll event.delta "steps".  
////			
////			navigationUnit = (event.delta < 0) ? NavigationUnit.DOWN : NavigationUnit.UP;
////			for (var vStep:int = 0; vStep < nSteps; vStep++)
////			{
////				var vspDelta:Number = vp.getVerticalScrollPositionDelta(navigationUnit);
////				if (!isNaN(vspDelta))
////					vp.verticalScrollPosition += vspDelta;
////			}
////			
////			event.preventDefault();
//		}
		
	}
}