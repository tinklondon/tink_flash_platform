package ws.tink.spark.layouts.supportClasses
{
	import spark.effects.animation.Animation;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.IEaser;
	import spark.effects.easing.Linear;
	
	import ws.tink.spark.controls.supportClasses.AnimationTarget;

	public class AnimationNavigatorLayoutBase extends NavigatorLayoutBase
	{
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Class Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  An animationType value passed to the constructor.
		 *  When the animation type is "direct", the selectedIndex is immediately set
		 *  to the proposedIndex and the selectedIndexOffset is animated from 1 to 0.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		protected static const DIRECT:String = "direct";
		
		/**
		 *  An animationType value passed to the constructor.
		 *  When the animation type is "indirect", the selectedIndex and selectedIndexOffset
		 *  are both animated. The selectedIndexOffset gets a value between -0.5 and 0.5.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		protected static const INDIRECT:String = "indirect";
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor. 
		 * 
		 *  @param animationType The type of animation.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */ 
		public function AnimationNavigatorLayoutBase( animationType:String )
		{
			super();
			
			_animationType = animationType;
			easer = new Linear( 0, 1 );
			duration = 700;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var _proposedSelectedIndex2			: int = -1;
		
		/**
		 *  @private
		 */
		private var _proposedSelectedIndex2Offset	: Number = 0;
		
		/**
		 *  @private
		 */
		private var _animationType:String = DIRECT;
		
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  duration
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for easer.
		 */
		private var _duration:Number;
		
		/**
		 *  duration
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get duration():Number
		{
			return _duration;
		}
		/**
		 *  @private
		 */
		public function set duration(value:Number):void
		{
			if( _duration == value ) return;
			
			_duration = value;
			animation.duration = _duration;
		}
		
		
		//----------------------------------
		//  easer
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for easer.
		 */
		private var _easer:IEaser;
		
		/**
		 *  easer
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get easer():IEaser
		{
			return _easer;
		}
		/**
		 *  @private
		 */
		public function set easer(value:IEaser):void
		{
			if( _easer == value ) return;
			
			_easer = value;
			animation.easer = _easer;
		}
		
		
		//----------------------------------
		//  animationValue
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage property for animationValue.
		 */
		private var _animationValue:Number = 0;
		
		/**
		 *  animationValue
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get animationValue():Number
		{
			return _animationValue;
			return animation.isPlaying ? _animationValue : 0;
		}
		
		
		//----------------------------------
		//  animation
		//----------------------------------   
		
		/**
		 *  @private
		 *  Storage property for animation.
		 */
		private var _animation:Animation;
		
		/**
		 *  @private
		 */
		private function get animation():Animation
		{
			if( _animation ) return _animation;
			_animation = new Animation();
			var animTarget:AnimationTarget = new AnimationTarget();
			animTarget.updateFunction = animationTargetUpdateFunction;
			animTarget.endFunction = animationTargetEndFunction;
//			switch( _animationType )
//			{
//				case DIRECT :
//				{
//					animTarget.updateFunction = animationTargetUpdateFunction;
//					animTarget.endFunction = animationTargetEndFunction;
//					break;
//				}
//				case INDIRECT :
//				{
//					animTarget.updateFunction = animationTargetUpdateFunctionIndirect;
//					animTarget.endFunction = animationTargetEndFunctionIndirect;
//				}
//			}
			
			_animation.animationTarget = animTarget;
			return _animation;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  To be overridden in subclasses. <code>indicesInView()</code> should be invoked
		 *  in this method updating the first and last index in view.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		protected function updateIndicesInView():void
		{
			
		}
		
		/**
		 *  @private
		 */
		private function startAnimation( from:Number, to:Number ):void
		{
			animation.stop();
			animation.motionPaths = new <MotionPath>[ new SimpleMotionPath( "animationIndex", from, to ) ];
			animation.play();
		}
		
		/**
		 *  @private
		 */
		private function animationTargetUpdateFunction( animation:Animation ):void
		{
//			super.invalidateSelectedIndex( selectedIndex, animation.currentValue[ "animationIndex" ] );
			_animationValue = animation.currentValue[ "animationIndex" ];
			
//			updateIndicesInView();
			invalidateTargetDisplayList();
		}
		
		/**
		 *  @private
		 */
		private function animationTargetEndFunction( animation:Animation ):void
		{
//			super.invalidateSelectedIndex( selectedIndex, animation.currentValue[ "animationIndex" ] );
			_animationValue = animation.currentValue[ "animationIndex" ];
//			updateIndicesInView();
			invalidateTargetDisplayList();
		}
		
		
		
//		/**
//		 *  @private
//		 */
//		private function animationTargetUpdateFunctionIndirect( animation:Animation ):void
//		{
//			var newValue:Number = animation.currentValue[ "animationIndex" ];
//			var index:int = Math.round( newValue );
//			super.invalidateSelectedIndex( index, newValue - index );
////			updateIndicesInView();
//		}
//		
//		/**
//		 *  @private
//		 */
//		private function animationTargetEndFunctionIndirect( animation:Animation ):void
//		{
//			var newValue:Number = animation.currentValue[ "animationIndex" ];
//			var index:int = Math.round( newValue );
//			super.invalidateSelectedIndex( index, newValue - index );
////			updateIndicesInView();
//		}
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
//		override protected function updateSelectedIndex(index:int, offset:Number):void
//		{
//			var animate:Boolean = selectedIndex != index;
//			
//			super.updateSelectedIndex( index, offset );
//			
//			if( animate )
//			{
//				switch( _animationType )
//				{
//					case DIRECT :
//					{
//						//						super.invalidateSelectedIndex( index, 1 );
//						startAnimation( 1, 0 );
//						break;
//					}
//					case INDIRECT :
//					{
//						//						startAnimation( selectedIndex + selectedIndexOffset, _proposedSelectedIndex2 + _proposedSelectedIndex2Offset );
//						startAnimation( index - selectedIndex, 0 );
//						break;
//					}
//				}
//			}
//			else
//			{
//				updateIndicesInView();
//			}
//		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */  
		override protected function invalidateSelectedIndex(index:int, offset:Number):void
		{
			var prevIndex:int = selectedIndex;
			
			super.invalidateSelectedIndex( index, 0 );
			
//			if( index == selectedIndex ) return;
			
//			if( index == _proposedSelectedIndex2 && _proposedSelectedIndex2Offset == offset ) return;
//			
//			_proposedSelectedIndex2 = index;
//			_proposedSelectedIndex2Offset = offset;
			
			if( prevIndex == -1 || !duration || isNaN( duration ) || index == -1 || prevIndex == index )
			{
//				super.invalidateSelectedIndex( index, 0 );
			}
			else
			{
//				super.invalidateSelectedIndex( index, 0 );
				
				switch( _animationType )
				{
					case DIRECT :
					{
//						super.invalidateSelectedIndex( index, 1 );
						startAnimation( 1, 0 );
						break;
					}
					case INDIRECT :
					{
						startAnimation( animation.isPlaying ? animationValue : prevIndex, index );
						break;
					}
				}
				
			}
		}
		
		override protected function updateDisplayListBetween():void
		{
			super.updateDisplayListBetween();
			
			updateIndicesInView();
		}
	}
}