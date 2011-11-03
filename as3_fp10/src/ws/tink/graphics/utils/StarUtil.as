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

	public class StarUtil
	{
		public function StarUtil()
		{
		}
		
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