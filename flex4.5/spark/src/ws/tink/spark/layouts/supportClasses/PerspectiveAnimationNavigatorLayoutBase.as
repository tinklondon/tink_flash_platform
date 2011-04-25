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
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import spark.components.supportClasses.GroupBase;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;

	public class PerspectiveAnimationNavigatorLayoutBase extends AnimationNavigatorLayoutBase
	{
		
		
		
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
		public function PerspectiveAnimationNavigatorLayoutBase( animationType:String )
		{
			super( animationType );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var _projectionChanged	: Boolean;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  projectionCenterX
		//----------------------------------  
		
		/**
		 *  @private
		 *	Storage property for projectionCenterX.
		 */
		private var _projectionCenterX:Number = NaN;
		
		/**
		 *  @private
		 *	Flag to indicate that the projectCenterX property as been set to number
		 *  value other than NaN.
		 */
		private var _projectionCenterXSet:Boolean;
		
		[Inspectable(category="General", defaultValue="NaN")]
		/**
		 *  projectionCenterX
		 * 
		 *  @default 0
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get projectionCenterX():Number
		{
			return _projectionCenterX;
		}
		/**
		 *  @private
		 */
		public function set projectionCenterX(value:Number):void
		{
			if( _projectionCenterX == value ) return;
			
			_projectionCenterX = value;
			_projectionChanged = true;
			_projectionCenterXSet = true;
			invalidateTargetDisplayList();
		}    
		
		
		//----------------------------------
		//  projectionCenterY
		//----------------------------------  
		
		/**
		 *  @private
		 *	Storage property for projectionCenterY.
		 */
		private var _projectionCenterY:Number = NaN;
		
		/**
		 *  @private
		 *	Flag to indicate that the projectCenterY property as been set to number
		 *  value other than NaN.
		 */
		private var _projectionCenterYSet:Boolean;
		
		[Inspectable(category="General", defaultValue="NaN")]
		/**
		 *  projectionCenterY
		 * 
		 *  @default NaN
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get projectionCenterY():Number
		{
			return _projectionCenterY;
		}
		/**
		 *  @private
		 */
		public function set projectionCenterY(value:Number):void
		{
			if( _projectionCenterY == value ) return;
			
			_projectionCenterY = value;
			_projectionChanged = true;
			_projectionCenterYSet = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  fieldOfView
		//----------------------------------  
		
		/**
		 *  @private
		 *	Storage property for fieldOfView.
		 */
		private var _fieldOfView:Number = NaN;
		
		[Inspectable(category="General")]
		/**
		 *  fieldOfView
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get fieldOfView():Number
		{
			return ( perspectiveProjection ) ? perspectiveProjection.fieldOfView : _fieldOfView;
		}
		/**
		 *  @private
		 */
		public function set fieldOfView( value:Number ):void
		{
			if( _fieldOfView == value ) return;
			
			_fieldOfView = value;
			_focalLength = NaN;
			_projectionChanged = true;
			invalidateTargetDisplayList();
		}    
		
		
		//----------------------------------
		//  focalLength
		//----------------------------------  
		
		/**
		 *  @private
		 *	Storage property for focalLength.
		 */
		private var _focalLength:Number = NaN;
		
		[Inspectable(category="General")]
		/**
		 *  focalLength
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get focalLength():Number
		{
			return ( perspectiveProjection ) ? perspectiveProjection.focalLength : _focalLength;
		}
		/**
		 *  @private
		 */
		public function set focalLength( value:Number ):void
		{
			if( _focalLength == value ) return;
			
			_focalLength = value;
			_fieldOfView = NaN;
			_projectionChanged = true;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  perspectiveProjection
		//----------------------------------  
		
		/**
		 *  @private
		 */
		private function get perspectiveProjection():PerspectiveProjection
		{
			return target.transform.perspectiveProjection;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  target
		//----------------------------------    
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override public function set target(value:GroupBase):void
		{
			super.target = value;
			
			_projectionChanged = true;
			invalidateTargetDisplayList();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateDisplayListBetween():void
		{
			super.updateDisplayListBetween();
			
			if( target && _projectionChanged || ( sizeChangedInLayoutPass && !_projectionCenterXSet || !_projectionCenterYSet ) )
			{
				_projectionChanged = false;
				
				if( !perspectiveProjection ) target.transform.perspectiveProjection = new PerspectiveProjection();
				
				if( !_projectionCenterXSet || isNaN( _projectionCenterX ) ) _projectionCenterX = unscaledWidth / 2;
				if( !_projectionCenterYSet || isNaN( _projectionCenterY ) ) _projectionCenterY = unscaledHeight / 2;
				perspectiveProjection.projectionCenter = new Point( _projectionCenterX, _projectionCenterY );
				
				if( !isNaN( _fieldOfView ) ) perspectiveProjection.fieldOfView = _fieldOfView;
				if( !isNaN( _focalLength ) ) perspectiveProjection.focalLength = _focalLength;
			}
		}
	}
}