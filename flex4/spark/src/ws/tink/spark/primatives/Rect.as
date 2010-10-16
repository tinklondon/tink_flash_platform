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

package ws.tink.spark.primatives
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.utils.GraphicsUtil;
	
	import spark.primitives.Graphic;
	import spark.primitives.Rect;
	
	import ws.tink.graphics.Dash;
	import ws.tink.graphics.IGraphicsCreator;
	import ws.tink.graphics.utils.RectUtil;
	import ws.tink.spark.graphics.IGraphicsDefiner;
	
	public class Rect extends spark.primitives.Rect
	{
		
		private var _origin	: Point;
		
		public function Rect()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function beginDraw(g:Graphics):void
		{
			_origin = new Point(drawX, drawY);
			
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
		
		
		private function setupStroke( g:Graphics ):void
		{
			g.endFill();
			
			var strokeBounds:Rectangle = getStrokeBounds();
			strokeBounds.offset(drawX, drawY);
			stroke.apply( g, strokeBounds, _origin );
		}
		
		private function setupFill( g:Graphics ):void
		{
			var fillBounds:Rectangle = new Rectangle(drawX, drawY, width, height);
			fill.begin( g, fillBounds, _origin );
		}
		
		
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function draw(g:Graphics):void
		{
			var strokeCreator:IGraphicsCreator = ( stroke is IGraphicsDefiner ) ? IGraphicsDefiner( stroke ).graphicsCreator : null;
			var fillCreator:IGraphicsCreator = ( fill is IGraphicsDefiner ) ? IGraphicsDefiner( fill ).graphicsCreator : null;
			var strokeAndFillCreators:Boolean = strokeCreator && fillCreator;
			
			// If any of the explicit radiusX values are specified, we have corner-specific rounding.
			if (!isNaN(topLeftRadiusX) || !isNaN(topRightRadiusX ) ||
				!isNaN(bottomLeftRadiusX) || !isNaN(bottomRightRadiusX))
			{     
				
				if( !strokeAndFillCreators )
				{
					// All of the fallback rules are implemented in drawRoundRectComplex2().
					GraphicsUtil.drawRoundRectComplex2(g, drawX, drawY, width, height, 
						radiusX, radiusY, 
						topLeftRadiusX, topLeftRadiusY,
						topRightRadiusX, topRightRadiusY,
						bottomLeftRadiusX, bottomLeftRadiusY,
						bottomRightRadiusX, bottomRightRadiusY);
				}
				
				if( fillCreator )
				{
					setupFill( g );
					RectUtil.drawRoundRectComplex2( fillCreator, drawX, drawY, width, height, 
						radiusX, radiusY, 
						topLeftRadiusX, topLeftRadiusY,
						topRightRadiusX, topRightRadiusY,
						bottomLeftRadiusX, bottomLeftRadiusY,
						bottomRightRadiusX, bottomRightRadiusY);
				}
				
				if( strokeCreator )
				{
					setupStroke( g );
					RectUtil.drawRoundRectComplex2( strokeCreator, drawX, drawY, width, height, 
						radiusX, radiusY, 
						topLeftRadiusX, topLeftRadiusY,
						topRightRadiusX, topRightRadiusY,
						bottomLeftRadiusX, bottomLeftRadiusY,
						bottomRightRadiusX, bottomRightRadiusY);
				}
			}
			else if (radiusX != 0)
			{
				var rX:Number = radiusX;
				var rY:Number =  radiusY == 0 ? radiusX : radiusY;
				
				if( !strokeAndFillCreators )
				{
					g.drawRoundRect(drawX, drawY, width, height, rX * 2, rY * 2);
				}
				
				if( fillCreator )
				{
					setupFill( g );
					RectUtil.drawRoundRect( IGraphicsDefiner( stroke ).graphicsCreator, drawX, drawY, width, height, rX * 2, rY * 2 );
				}
				
				if( strokeCreator )
				{
					setupStroke( g );
					RectUtil.drawRoundRect( IGraphicsDefiner( stroke ).graphicsCreator, drawX, drawY, width, height, rX * 2, rY * 2 );
				}
			}
			else
			{
				if( !strokeAndFillCreators )
				{
					g.drawRect(drawX, drawY, width, height);
				}
				
				if( fillCreator )
				{
					setupFill( g );
					RectUtil.drawRect( fillCreator, drawX, drawY, width, height );
				}
						
				if( strokeCreator )
				{
					setupStroke( g );
					RectUtil.drawRect( strokeCreator, drawX, drawY, width, height );
				}
			}
		}
	}
}