package ws.tink.spark.layouts.supportClasses
{
	import spark.effects.animation.Animation;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	
	import ws.tink.spark.controls.supportClasses.AnimationTarget;

	public class AnimationNavigatorLayoutBase extends NavigatorLayoutBase
	{
		
		public static const DIRECT:String = "direct";
		public static const INDIRECT:String = "indirect";
		
		public function AnimationNavigatorLayoutBase( animationType:String )
		{
			super();
			
			_animationType = animationType;
		}
		
		
		private var _proposedSelectedIndex			: int = -1;
		private var _proposedSelectedIndexOffset	: Number = 0;
		
		private var _animationType:String = DIRECT;
		
		override protected function updateSelectedIndex( index:int, offset:Number ):void
		{
			if( index == _proposedSelectedIndex && _proposedSelectedIndexOffset == offset ) return;
			
			_proposedSelectedIndex = index;
			_proposedSelectedIndexOffset = offset;
			
			if( selectedIndex == -1 )
			{
				super.updateSelectedIndex( _proposedSelectedIndex, 0 );
			}
			else
			{
				switch( _animationType )
				{
					case DIRECT :
					{
						super.updateSelectedIndex( index, 1 );
						startAnimation( 1, 0 );
						break;
					}
					case INDIRECT :
					{
						startAnimation( selectedIndex + selectedIndexOffset, _proposedSelectedIndex + _proposedSelectedIndexOffset );
						break;
					}
				}
				
			}
			updateIndicesInView();
		}
		
		/**
		 *  @private
		 */
		private function startAnimation( from:Number, to:Number ):void
		{
			animator.stop();
			animator.motionPaths = new <MotionPath>[ new SimpleMotionPath( "animationIndex", from, to ) ];
			animator.play();
		}
		
		private var _animator:Animation;
		/**
		 *  @private
		 */
		protected function get animator():Animation
		{
			if( _animator ) return _animator;
			_animator = new Animation();
			var animTarget:AnimationTarget = new AnimationTarget();
			switch( _animationType )
			{
				case DIRECT :
				{
					animTarget.updateFunction = animationTargetUpdateFunctionDirect;
					animTarget.endFunction = animationTargetEndFunctionDirect;
					break;
				}
				case INDIRECT :
				{
					animTarget.updateFunction = animationTargetUpdateFunctionIndirect;
					animTarget.endFunction = animationTargetEndFunctionIndirect;
				}
			}
			
			_animator.animationTarget = animTarget;
			return _animator;
		}
		
		/**
		 *  @private
		 */
		private function animationTargetUpdateFunctionDirect( animation:Animation ):void
		{
			super.updateSelectedIndex( selectedIndex, animation.currentValue[ "animationIndex" ] );
			updateIndicesInView();
		}
		
		/**
		 *  @private
		 */
		private function animationTargetEndFunctionDirect( animation:Animation ):void
		{
			super.updateSelectedIndex( selectedIndex, animation.currentValue[ "animationIndex" ] );
			updateIndicesInView();
		}
		
		/**
		 *  @private
		 */
		private function animationTargetUpdateFunctionIndirect( animation:Animation ):void
		{
			var newValue:Number = animation.currentValue[ "animationIndex" ];
			var index:int = Math.round( newValue );
			super.updateSelectedIndex( index, newValue - index );
			updateIndicesInView();
//			super.updateSelectedIndex( selectedIndex, animation.currentValue[ "animationIndex" ] );
		}
		
		/**
		 *  @private
		 */
		private function animationTargetEndFunctionIndirect( animation:Animation ):void
		{
			var newValue:Number = animation.currentValue[ "animationIndex" ];
			var index:int = Math.round( newValue );
			trace( "animationTargetEndFunctionIndirect", newValue, index );
			super.updateSelectedIndex( index, newValue - index );
			updateIndicesInView();
		}
		
		protected function updateIndicesInView():void
		{
			
		}
	}
}