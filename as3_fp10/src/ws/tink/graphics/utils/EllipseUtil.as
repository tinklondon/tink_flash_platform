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

package ws.tink.graphics.utils
{
	
	import flash.display.Graphics;
	
	import ws.tink.graphics.IGraphicsCreator;
	
	/**
	 *  The EllipseUtil class is an all-static class with utility methods
	 *  related to drawing ellipse's.
	 *  You do not create instances of EllipseUtil;
	 *  instead you simply call methods such as the
	 *  <code>EllipseUtil.drawEllipse()</code> method.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class EllipseUtil
	{

		
		
		//--------------------------------------------------------------------------
		//
		//  Class Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Draws a circle. 
		 *  You must set the line style, fill, or both 
		 *  on the IGraphicsCreator object before 
		 *  you call the <code>drawCircle()</code> method 
		 *  by calling the <code>linestyle()</code>, 
		 *  <code>lineGradientStyle()</code>, <code>beginFill()</code>, 
		 *  <code>beginGradientFill()</code>, or 
		 *  <code>beginBitmapFill()</code> method.
		 * 
		 *  @param graphics The IGraphicsCreator object that draws the circle.
		 *
		 *  @param x The horizontal position relative to the 
		 *  registration point of the parent display object, in pixels.
		 * 
		 *  @param y The vertical position relative to the 
		 *  registration point of the parent display object, in pixels.
		 * 
		 *  @param radius The radius of the circle, in pixels.
		 * 
		 *  @param accuracy The number of quadratic bezier curves used to create the circle.
		 *  The default is 10.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function drawCircle( graphics:IGraphicsCreator, x:Number, y:Number, 
										   radius:Number, accuracy:Number = 10 ):void
		{
			EllipseUtil.drawEllipse( graphics,x, y, radius, radius, accuracy );
		}
		
		/**
		 *  Draws an ellipse. 
		 *  You must set the line style, fill, or both 
		 *  on the IGraphicsCreator object before 
		 *  you call the <code>drawEllipse()</code> method 
		 *  by calling the <code>linestyle()</code>, 
		 *  <code>lineGradientStyle()</code>, <code>beginFill()</code>, 
		 *  <code>beginGradientFill()</code>, or 
		 *  <code>beginBitmapFill()</code> method.
		 * 
		 *  @param graphics The IGraphicsCreator object that draws the ellipse.
		 *
		 *  @param x The horizontal position relative to the 
		 *  registration point of the parent display object, in pixels.
		 * 
		 *  @param y The vertical position relative to the 
		 *  registration point of the parent display object, in pixels.
		 * 
		 *  @param radiusX The radius of the ellipse on the x axis, in pixels.
		 * 
		 *  @param radiusX The radius of the ellipse on the y axis, in pixels.
		 * 
		 *  @param accuracy The number of quadratic bezier curves used to create the circle.
		 *  The default is 10.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function drawEllipse( graphics:IGraphicsCreator, x:Number, y:Number,
										   radiusX:Number, radiusY:Number, accuracy:Number = 10 ):void
		{
			
			if( accuracy < 4 ) accuracy = 4;
			
			var span:Number = Math.PI / accuracy;
			
			var controlRadiusX:Number = radiusX / Math.cos( span );
			var controlRadiusY:Number = radiusY / Math.cos( span );
			var anchorAngle:Number = 0;
			var controlAngle:Number = 0;
			
			graphics.moveTo( x + Math.cos( anchorAngle ) * radiusX, y + Math.sin( anchorAngle ) * radiusY );
			
			for( var i:int = 0; i < accuracy; ++i )
			{
				controlAngle = anchorAngle+span;
				anchorAngle = controlAngle+span;
				graphics.curveTo( x + Math.cos(controlAngle)*controlRadiusX,
					y + Math.sin(controlAngle)*controlRadiusY,
					x + Math.cos(anchorAngle)*radiusX,
					y + Math.sin(anchorAngle)*radiusY );
			}
		}
	}
	
}
