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

package ws.tink.spark.primitives
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.primitives.Ellipse;
	import spark.primitives.supportClasses.FilledElement;
	
	import ws.tink.graphics.IGraphicsCreator;
	import ws.tink.graphics.utils.StarUtil;
	import ws.tink.spark.graphics.IGraphicsDefiner;
	
	public class Star extends Ellipse
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
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function Star()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  numPoints
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage property for numPoints.
		 */
		private var _numPoints:int = 5;
		
		/**
		 *
		 *  @default 5
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get numPoints():int
		{
			return _numPoints;
		}
		/**
		 *  @private
		 */
		public function set numPoints(value:int):void
		{
			if( _numPoints == value ) return;
			
			_numPoints = value;
			invalidateSize();
			invalidateDisplayList();
			invalidateParentSizeAndDisplayList();
		}
		
		
		//----------------------------------
		//  innerWidth
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage property for innerWidth.
		 */
		private var _innerWidth:Number;
		
		/**
		 *
		 *  @default width * 0.38;
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get innerWidth():Number
		{
			return isNaN( _innerWidth ) ? width * 0.38 : _innerWidth;
		}
		/**
		 *  @private
		 */
		public function set innerWidth(value:Number):void
		{
			if( _innerWidth == value ) return;
			
			_innerWidth = value;
			invalidateSize();
			invalidateDisplayList();
			invalidateParentSizeAndDisplayList();
		}
		
		
		//----------------------------------
		//  innerHeight
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage property for innerHeight.
		 */
		private var _innerHeight:Number;
		
		/**
		 *
		 *  @default height * 0.38;
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get innerHeight():Number
		{
			return isNaN( _innerHeight ) ? height * 0.38 : _innerHeight;
		}
		public function set innerHeight(value:Number):void
		{
			if( _innerHeight == value ) return;
			
			_innerHeight = value;
			invalidateSize();
			invalidateDisplayList();
			invalidateParentSizeAndDisplayList();
		}

		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  Set up the stroke properties for this drawing element.
		 *  
		 *  @param g The graphic element to draw.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		private function setupStroke( g:Graphics ):void
		{
			g.endFill();
			
			var strokeBounds:Rectangle = getStrokeBounds();
			strokeBounds.offset(drawX, drawY);
			stroke.apply( g, strokeBounds, new Point() );
		}
		
		/**
		 *  Set up the fill properties for this drawing element.
		 *  
		 *  @param g The graphic element to draw.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		private function setupFill( g:Graphics ):void
		{
			var fillBounds:Rectangle = new Rectangle(drawX, drawY, width, height);
			fill.begin( g, fillBounds, new Point() );
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
		override protected function beginDraw( g:Graphics ):void
		{
			// Don't call super.beginDraw() since it will also set up an 
			// invisible fill.
			
			if( stroke )
			{
				if( stroke is IGraphicsDefiner )
				{
					g.lineStyle();
				}
				else
				{
					setupStroke( g );
				}
			}
			else
			{
				g.lineStyle();
			}
			
			if( fill )
			{
				if( fill is IGraphicsDefiner )
				{
					
				}
				else
				{
					setupFill( g );
				}
			}
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function draw( g:Graphics ):void
		{
			const strokeCreator:IGraphicsCreator = ( stroke is IGraphicsDefiner ) ? IGraphicsDefiner( stroke ).graphicsCreator : null;
			const fillCreator:IGraphicsCreator = ( fill is IGraphicsDefiner ) ? IGraphicsDefiner( fill ).graphicsCreator : null;
			const strokeAndFillCreators:Boolean = strokeCreator && fillCreator;
			
			const halfWidth:Number = width / 2;
			const halfHeight:Number = height / 2;
			
			if( !strokeAndFillCreators )
			{
				StarUtil.drawStar( g, drawX + halfWidth, drawY + halfHeight, numPoints, width, height, innerWidth, innerHeight );
			}
			
			if( fillCreator )
			{
				setupFill( g );
				StarUtil.drawGraphicsCreatorStar( fillCreator, drawX + halfWidth, drawY + halfHeight, numPoints, width, height, innerWidth, innerHeight )
			}
			
			if( strokeCreator )
			{
				setupStroke( g );
				StarUtil.drawGraphicsCreatorStar( strokeCreator, drawX + halfWidth, drawY + halfHeight, numPoints, width, height, innerWidth, innerHeight )
			}
		}
		
		
		
	}
}