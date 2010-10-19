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

package ws.tink.graphics
{
	import flash.display.Graphics;

	public interface IGraphicsCreator
	{
		function get graphics():Graphics
		function lineStyle( thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0,
								   pixelHinting:Boolean = false, scaleMode:String = "normal",
								   caps:String = null, joints:String = null, miterLimit:Number = 3 ):void
		function moveTo( x:Number, y:Number ):void
		function lineTo( x:Number, y:Number ):void
		function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void
		function drawPath( commands:Vector.<int>, data:Vector.<Number>, winding:String = "evenOdd" ):void
		
	}
}