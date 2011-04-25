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
	
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.VScrollBar;
	import spark.core.IViewport;
	import spark.effects.animation.Animation;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.IEaser;
	import spark.effects.easing.Linear;
	
	import ws.tink.spark.controls.supportClasses.AnimationTarget;
	
	use namespace mx_internal;
	public class VPageStep extends VScrollBar
	{
		
		private static var linearEaser:IEaser = new Linear();
		
		private var _numPages	: uint;
		
		public function VPageStep()
		{
			super();
		}
		
		override public function set viewport(newViewport:IViewport):void
		{
			super.viewport = newViewport;
			updateMaximumAndPageSize();
		}
		
		public function get numPages():uint
		{
			return _numPages;
		}
		
		public function get currentPage():uint
		{
			return _currentPage;
		}
		
		/**
		 *  @private
		 *  Set this scrollbar's maximum to the viewport's contentHeight 
		 *  less the viewport height and its pageSize to the viewport's height. 
		 */
		override mx_internal function viewportResizeHandler(event:ResizeEvent):void
		{
			updateMaximumAndPageSize();
		}
		
		override mx_internal function viewportContentHeightChangeHandler(event:PropertyChangeEvent):void
		{
			updateMaximumAndPageSize();
		}
		
		private function updateMaximumAndPageSize():void
		{
			var viewportHeight:Number = 0;
			if( viewport )
			{
				viewportHeight = isNaN( viewport.height ) ? 0 : viewport.height;
				pageSize = viewportHeight;
				if( pageSize )
				{
					_numPages = Math.ceil( ( viewport.contentHeight - viewport.height ) / pageSize );
					maximum = _numPages * pageSize;
				}
				else
				{
					_numPages = 0;
					maximum = 0;
				}
				
			}
			else
			{
				pageSize = 0;
				maximum = 0;
				_numPages = 0;
			}
		}
		override protected function partAdded( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );
			
			if( instance == decrementButton )
			{
				decrementButton.addEventListener( MouseEvent.CLICK, onButtonClick, false, 0, true );
			}
			else if( instance == incrementButton )
			{
				incrementButton.addEventListener( MouseEvent.CLICK, onButtonClick, false, 0, true );
			}
		}
		
		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partRemoved( partName, instance );
			
			if( instance == decrementButton )
			{
				decrementButton.removeEventListener( MouseEvent.CLICK, onButtonClick, false );
			}
			else if( instance == incrementButton )
			{
				incrementButton.removeEventListener( MouseEvent.CLICK, onButtonClick, false );
			}
		}
		
		override protected function button_buttonDownHandler(event:Event):void
		{
		}
		
		private var _currentPage	: int = 0;
		protected function onButtonClick( event:Event ):void
		{
			var newPage:int = event.currentTarget == incrementButton ? 
				Math.min( _currentPage + 1, _numPages ) : Math.max( _currentPage - 1, 0 );
			
			if( _currentPage == newPage ) return;
			
			_currentPage = newPage;
			var val:Number = pageSize * _currentPage;
			if( getStyle( "smoothScrolling" ) )
			{
				startAnimation( getStyle( "slideDuration" ), val, linearEaser );
			}
			else
			{
				setValue( val );
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		
		/**
		 *  @private
		 */
		private function startAnimation(duration:Number, valueTo:Number, 
										easer:IEaser, startDelay:Number = 0):void
		{
			animator.stop();
			animator.duration = duration;
			animator.easer = easer;
			animator.motionPaths = new <MotionPath>[
				new SimpleMotionPath("value", value, valueTo)];
			animator.startDelay = startDelay;
			animator.play();
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
			trace( "animationUpdateHandler", animation.currentValue["value"] );
			// TODO (klin): Add support to send change events at the right intervals.
			setValue(animation.currentValue["value"]);
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
//			if (trackScrolling)
//				trackScrolling = false;
//			
//			// End stepping animation
//			if (steppingDown || steppingUp)
//			{
//				// If we're animating stepping, end on a final real step call in the
//				// appropriate direction, ensuring that we stop on a content 
//				// item boundary 
//				changeValueByStep(steppingDown);
//				
//				animator.startDelay = 0;
//				return;
//			}
			
			// End paging or shift-click animation.
			setValue(nearestValidValue(this.value, snapInterval));
			dispatchEvent(new Event(Event.CHANGE));
			
			// We only dispatch the changeEnd event in the endHandler
			// for paging when we are not repeating.
//			if (animatingOnce)
//			{
				dispatchEvent(new FlexEvent(FlexEvent.CHANGE_END));
//				animatingOnce = false;
//			}
		}
	}
}