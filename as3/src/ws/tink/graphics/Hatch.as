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
 
/**
 * The DashedLine class provides a means to draw with standard drawing
 * methods but allows you to draw using dashed lines. Dashed lines are continuous
 * between drawing commands so dashes won't be interrupted when new lines
 * are drawn in succession
 * <p>
 * Use a DashedLine instance just as you would use a movie clip to draw lines
 * and fills using Flash's drawing API on a movie clip.
 *
 * @usage
 * <pre><code>import com.senocular.drawing.DashedLine;
 * // create a DashedLine instance that draws in _root
 * // dashes will be 10px long, spaces between will be 5
 * var myDashedDrawing:DashedLine = new DashedLine(_root, 10, 5);
 * // draw a square with dashed lines
 * myDashedDrawing.moveTo(50, 50);
 * myDashedDrawing.lineTo(100, 50);
 * myDashedDrawing.lineTo(100, 100);
 * myDashedDrawing.lineTo(50, 100);
 * myDashedDrawing.lineTo(50, 50);
 *
 * @author Trevor McCauley, senocular.com
 * @version 1.0.2
 */
package ws.tink.graphics

{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class Hatch extends GraphicsCreator
	{
		private var _hatchLength:Number = 0;
		private var _angle:Number = 0;


		// constructor
		/**
		 * Class constructor; creates a ProgressiveDrawing instance.
		 * @param target The target movie clip to draw in.
		 * @param _gap Length of visible dash lines.
		 * @param _gap Length of space between dash lines.
		 */
		public function Hatch( hatchLength:Number = 5, gap:Number = 5, angle:Number = 45, graphics:Graphics = null, drawOverFlow:Boolean = false, curveAccuracy:int = 6 )
		{
			super( graphics, drawOverFlow, curveAccuracy );
			
			_hatchLength = hatchLength / 2;
			setupLenghts( gap, 0 );
			_angle = angle;
		}
		
		
		/**
		 * Gets the current lengths for dash sizes
		 * @return Array containing the _gap and _gap values
		 * respectively in that order
		 */
		public function get gap():Number
		{
			return lineLength;
		}
		public function set gap( value:Number ):void
		{
			setupLenghts( value, 0 );
		}
		
		/**
		 * Gets the current lengths for dash sizes
		 * @return Array containing the _gap and _gap values
		 * respectively in that order
		 */
		public function get angle():Number
		{
			return _angle;
		}
		public function set angle( value:Number ):void
		{
			_angle = value;
		}
		
		/**
		 * Gets the current lengths for dash sizes
		 * @return Array containing the _gap and _gap values
		 * respectively in that order
		 */
		public function get hatchLength():Number
		{
			return _hatchLength * 2;
		}
		public function set hatchLength( value:Number ):void
		{
			_hatchLength = value / 2;
		}


		override protected function targetLineTo( x:Number, y:Number ):void
		{
			if( x == penX && y == penY ) return;
			
			drawHatch( x, y );
		}


		override protected function targetCurveTo( cx:Number, cy:Number, x:Number, y:Number ):void
		{
			if( cx == x && cy == y && x == penX && y == penY ) return;
			
			drawHatch( x, y );
		}
		
		private function drawHatch( x:Number, y:Number ):void
		{
			var r:Number = Math.atan2( y - penY, x - penX ) + ( ( 90 + _angle ) / 180 ) * Math.PI;
			
			graphics.moveTo( penX + Math.cos( r )* _hatchLength, penY + Math.sin( r )* _hatchLength );
			graphics.lineTo( penX + Math.cos( r )* -_hatchLength, penY + Math.sin( r )* -_hatchLength );
			graphics.moveTo( penX, penY );
		}

	}
}
