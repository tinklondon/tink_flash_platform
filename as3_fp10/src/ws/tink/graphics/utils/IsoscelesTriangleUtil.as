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
	 *  The IsoscelesTriangleUtil class is an all-static class with utility methods
	 *  related to isosceles triangles.
	 *  You do not create instances of IsoscelesTriangleUtil;
	 *  instead you simply call methods such as the
	 *  <code>IsoscelesTriangleUtil.drawTriangle()</code> method.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class IsoscelesTriangleUtil
	{
		
		
		//--------------------------------------------------------------------------
		//
		//  Class Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Draws an isosceles triangle. 
		 *  You must set the line style, fill, or both 
		 *  on the Graphics object before 
		 *  you call the <code>drawTriangle()</code> method 
		 *  by calling the <code>linestyle()</code>, 
		 *  <code>lineGradientStyle()</code>, <code>beginFill()</code>, 
		 *  <code>beginGradientFill()</code>, or 
		 *  <code>beginBitmapFill()</code> method.
		 * 
		 *  @param graphics The Graphics object that draws the isosceles triangle.
		 *
		 *  @param x The horizontal position relative to the 
		 *  registration point of the parent display object, in pixels.
		 * 
		 *  @param y The vertical position relative to the 
		 *  registration point of the parent display object, in pixels.
		 * 
		 *  @param width The width of the polygon, in pixels.
		 * 
		 *  @param height The height of the polygon, in pixels.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function drawTriangle( graphics:Graphics, x:Number, y:Number, width:Number, height:Number ):void
		{
			draw( x, y, width, height, graphics );
		}
		
		/**
		 *  Draws an isosceles triangle. 
		 *  You must set the line style, fill, or both 
		 *  on the IGraphicsCreator object before 
		 *  you call the <code>drawGraphicsCreatorTriangle()</code> method 
		 *  by calling the <code>linestyle()</code>, 
		 *  <code>lineGradientStyle()</code>, <code>beginFill()</code>, 
		 *  <code>beginGradientFill()</code>, or 
		 *  <code>beginBitmapFill()</code> method.
		 * 
		 *  @param graphics The IGraphicsCreator object that draws the isosceles triangle.
		 *
		 *  @param x The horizontal position relative to the 
		 *  registration point of the parent display object, in pixels.
		 * 
		 *  @param y The vertical position relative to the 
		 *  registration point of the parent display object, in pixels.
		 * 
		 *  @param width The width of the polygon, in pixels.
		 * 
		 *  @param height The height of the polygon, in pixels.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function drawGraphicsCreatorTriangle( graphics:IGraphicsCreator, x:Number, y:Number, width:Number, height:Number ):void
		{
			draw( x, y, width, height, null, graphics );
		}
		
		/**
		 *  @private
		 */
		private static function draw( x:Number, y:Number, width:Number, height:Number,
									  graphics:Graphics = null, graphicsCreator:IGraphicsCreator = null ):void
		{
			const centerX:Number = width / 2;
			
			if( graphics )
			{
				graphics.moveTo( x + centerX, y );
				graphics.lineTo( x + width, y + height );
				graphics.lineTo( x, y + height );
				graphics.lineTo( x + centerX, y );
			}
			
			if( graphicsCreator )
			{
				graphicsCreator.moveTo( x + centerX, y );
				graphicsCreator.lineTo( x + width, y + height );
				graphicsCreator.lineTo( x, y + height );
				graphicsCreator.lineTo( x + centerX, y );
			}
		}
	}
}