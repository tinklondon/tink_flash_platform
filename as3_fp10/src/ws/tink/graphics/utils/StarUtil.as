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

package ws.tink.graphics.utils
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import ws.tink.graphics.IGraphicsCreator;

	/**
	 *  The StarUtil class is an all-static class with utility methods
	 *  related to drawing star's or concave polygons.
	 *  You do not create instances of StarUtil;
	 *  instead you simply call methods such as the
	 *  <code>StarUtil.drawStar()</code> method.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class StarUtil
	{
		
		//--------------------------------------------------------------------------
		//
		//  Class Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Draws a star plotted around an ellipse. 
		 *  You must set the line style, fill, or both 
		 *  on the Graphics object before 
		 *  you call the <code>drawStar()</code> method 
		 *  by calling the <code>linestyle()</code>, 
		 *  <code>lineGradientStyle()</code>, <code>beginFill()</code>, 
		 *  <code>beginGradientFill()</code>, or 
		 *  <code>beginBitmapFill()</code> method.
		 * 
		 *  @param graphics The Graphics object that draws the polygon.
		 *
		 *  @param x The horizontal position relative to the 
		 *  registration point of the parent display object, in pixels.
		 * 
		 *  @param y The vertical position relative to the 
		 *  registration point of the parent display object, in pixels.
		 * 
		 *  @param numPoints The number of points of the star. This must be
		 *  3 or more else an ArgumentError is thrown.
		 * 
		 *  @param width The width of the polygon, in pixels.
		 * 
		 *  @param height The height of the polygon, in pixels.
		 * 
		 *  @param innerWidth The inner width of the star, in pixels.
		 * 
		 *  @param innerHeight The inner height of the star, in pixels.
		 * 
		 *  @param angle The rotation of the star.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function drawStar( graphics:Graphics, x:Number, y:Number, numPoints:uint,
										 width:Number, height:Number, innerWidth:Number, innerHeight:Number, angle:Number = 0 ):void
		{
			if( numPoints < 3 )
			{
				throw ArgumentError( "StarUtil.drawStar() - parameter 'numPoints' needs to be at least 3" ); 
				return;
			}
			
			draw( x, y, numPoints, width, height, innerWidth, innerHeight, angle, graphics );
		}
		
		/**
		 *  Draws a star plotted around an ellipse. 
		 *  You must set the line style, fill, or both 
		 *  on the IGraphicsCreator object before 
		 *  you call the <code>drawGraphicsCreatorStar()</code> method 
		 *  by calling the <code>linestyle()</code>, 
		 *  <code>lineGradientStyle()</code>, <code>beginFill()</code>, 
		 *  <code>beginGradientFill()</code>, or 
		 *  <code>beginBitmapFill()</code> method.
		 * 
		 *  @param graphics The IGraphicsCreator object that draws the polygon.
		 *
		 *  @param x The horizontal position relative to the 
		 *  registration point of the parent display object, in pixels.
		 * 
		 *  @param y The vertical position relative to the 
		 *  registration point of the parent display object, in pixels.
		 * 
		 *  @param numPoints The number of points of the star. This must be
		 *  3 or more else an ArgumentError is thrown.
		 * 
		 *  @param width The width of the polygon, in pixels.
		 * 
		 *  @param height The height of the polygon, in pixels.
		 * 
		 *  @param innerWidth The inner width of the star, in pixels.
		 * 
		 *  @param innerHeight The inner height of the star, in pixels.
		 * 
		 *  @param angle The rotation of the star.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function drawGraphicsCreatorStar( graphics:IGraphicsCreator, x:Number, y:Number, numPoints:uint,
														width:Number, height:Number, innerWidth:Number, innerHeight:Number, angle:Number = 0 ):void
		{
			if( numPoints < 3 )
			{
				throw ArgumentError( "StarUtil.drawStar() - parameter 'numPoints' needs to be at least 3" ); 
				return;
			}
			
			draw( x, y, numPoints, width, height, innerWidth, innerHeight, angle, null, graphics );
		}
		
		/**
		 *  @private
		 */
		private static function draw( x:Number, y:Number, numPoints:uint,
									  width:Number, height:Number, innerWidth:Number, innerHeight:Number, angle:Number = 0,
									  graphics:Graphics = null, graphicsCreator:IGraphicsCreator = null ):void
		{
			const numLoops:int = numPoints * 2;
			const degreeStep:Number = ( 360 / numLoops );
			const point:Point = new Point();
			
			var radiusX:Number;
			var radiusY:Number;
			var degrees:Number;
			var radians:Number;
			for( var i:int = 0; i <= numLoops; i++ )
			{
				if( i % 2 )
				{
					radiusX = width / 2;
					radiusY = height / 2;
				}
				else
				{
					radiusX = innerWidth / 2;
					radiusY = innerHeight / 2;
				}
				
				degrees = ( degreeStep * i ) + 90 + angle;
				radians = degrees * ( Math.PI / 180 );
				point.x = x + ( radiusX * Math.cos( radians ) );
				point.y = y + ( radiusY * Math.sin( radians ) );
				
				if( i == 0 )
				{
					if( graphics ) graphics.moveTo( point.x, point.y );
					if( graphicsCreator ) graphicsCreator.moveTo( point.x, point.y );
				}
				else
				{
					if( graphics ) graphics.lineTo( point.x, point.y );
					if( graphicsCreator ) graphicsCreator.lineTo( point.x, point.y );
				}
			}
		}
	}
}