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

/**
 *  The EllipticalPolygonUtil class is an all-static class with utility methods
 *  related to elliptical polygons.
 *  You do not create instances of EllipticalPolygonUtil;
 *  instead you simply call methods such as the
 *  <code>EllipticalPolygonUtil.drawPolygon()</code> method.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
package ws.tink.graphics.utils
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import ws.tink.graphics.IGraphicsCreator;

	public class EllipticalPolygonUtil
	{

		
		
		//--------------------------------------------------------------------------
		//
		//  Class Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Draws a polygon plotted around an ellipse. 
		 *  You must set the line style, fill, or both 
		 *  on the Graphics object before 
		 *  you call the <code>drawPolygon()</code> method 
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
		 *  @param numSides The number of sides of the polygon. This must be
		 *  3 or more else an ArgumentError is thrown.
		 * 
		 *  @param width The width of the polygon, in pixels.
		 * 
		 *  @param height The height of the polygon, in pixels.
		 * 
		 *  @param angle The rotation of the polygon.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function drawPolygon( graphics:Graphics, x:Number, y:Number, numSides:uint,
											width:Number, height:Number, angle:Number = 0 ):void
		{
			if( numSides < 3 )
			{
				throw ArgumentError( "RegularPolygonUtil.drawPolygon() - parameter 'numSides' needs to be at least 3" ); 
				return;
			}
			
			draw( x, y, numSides, width, height, angle, graphics );
		}
		
		/**
		 *  Draws a polygon plotted around an ellipse. 
		 *  You must set the line style, fill, or both 
		 *  on the IGraphicsCreator object before 
		 *  you call the <code>drawGraphicsCreatorPolygon()</code> method 
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
		 *  @param numSides The number of sides of the polygon. This must be
		 *  3 or more else an ArgumentError is thrown.
		 * 
		 *  @param width The width of the polygon, in pixels.
		 * 
		 *  @param height The height of the polygon, in pixels.
		 * 
		 *  @param angle The rotation of the polygon.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function drawGraphicsCreatorPolygon( graphics:IGraphicsCreator, x:Number, y:Number, numSides:uint,
														   width:Number, height:Number, angle:Number = 0 ):void
		{
			if( numSides < 3 )
			{
				throw ArgumentError( "RegularPolygonUtil.drawGraphicsCreatorPolygon() - parameter 'numSides' needs to be at least 3" ); 
				return;
			}
			
			draw( x, y, numSides, width, height, angle, null, graphics );
		}
		
		/**
		 *  @private
		 */
		private static function draw( x:Number, y:Number, numSides:uint,
									  width:Number, height:Number, angle:Number = 0,
									  graphics:Graphics = null, graphicsCreator:IGraphicsCreator = null ):void
		{
			const numLoops:int = numSides;
			const degreeStep:Number = ( 360 / numSides );
			const point:Point = new Point();
			
			const radiusX:Number = width / 2;
			const radiusY:Number = height / 2;
			var degrees:Number;
			var radians:Number;
			for( var i:int = 0; i <= numLoops; i++ )
			{
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