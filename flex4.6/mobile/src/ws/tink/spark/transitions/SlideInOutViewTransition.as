/*
Copyright (c) 2011 Tink Ltd - http://www.tink.ws

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

package ws.tink.spark.transitions
{
	import mx.effects.IEffect;
	
	import spark.effects.Animate;
	import spark.effects.Move;
	import spark.effects.animation.Keyframe;
	import spark.effects.animation.MotionPath;
	import spark.transitions.SlideViewTransition;
	import spark.transitions.ViewTransitionDirection;
	
	/**
	 *  The SlideInOutViewTransition class performs a simple slide transition for views.
	 *  The existing view slides out as the new view slides in, in the opposite direction.
	 *  The slide transition supports two modes (cover, and
	 *  uncover) as well as an optional direction (up, down, left, or right).
	 *
	 *  <p><strong>Note:</strong>Create and configure view transitions in ActionScript;
	 *  you cannot create them in MXML.</p>
	 *
	 *  @see SlideViewTransitionMode
	 *  @see ViewTransitionDirection
	 *  
	 *  @langversion 3.0
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	public class SlideInOutViewTransition extends SlideViewTransition
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
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function SlideInOutViewTransition()
		{
			super();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */ 
		private var _animate:Animate;
		
		/**
		 *  @private
		 *  The distance to animate.
		 */ 
		private var _distance:Number;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Used internally to position the views during animation.
		 */ 
		public function set animatedValue( value:Number ):void
		{
			if( direction == ViewTransitionDirection.UP ||
				direction == ViewTransitionDirection.DOWN )
			{
				startView.move( 0, value );
				endView.move( 0, _distance - value );
			}
			else
			{
				startView.move( value, 0 );
				endView.move( _distance - value, 0 );
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * 
		 *  @langversion 3.0
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		override protected function createViewEffect():IEffect
		{
			const move:Move = super.createViewEffect() as Move;
			if( !_animate )
			{
				_animate = new Animate();
				_animate.target = this;
				_animate.easer = move.easer;
				_animate.motionPaths = new <MotionPath>[ new MotionPath( "animatedValue" ) ];
			}
			
			_distance = move.yBy ? -move.yBy : -move.xBy;
			_animate.motionPaths[ 0 ].keyframes = new <Keyframe>[ new Keyframe( 0, 0 ), new Keyframe( duration, _distance ) ];
			return _animate;
		}
	}
}