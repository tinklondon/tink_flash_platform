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
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class Dash implements IGraphicsCreator
	{
		/**
		 * The target movie clip in which drawings are to be made
		 */
		public var _graphics:Graphics;
		/**
		 * A value representing the accuracy used in determining the length
		 * of curveTo curves.
		 */
		public var _curveaccuracy:Number = 6;

		private var _isLine:Boolean = true;
		private var _overflow:Number = 0;
		private var _gap:Number = 0;
		private var _dash:Number = 0;
		private var _dashLength:Number = 0;
		private var _pen:Point;


		// constructor
		/**
		 * Class constructor; creates a ProgressiveDrawing instance.
		 * @param target The target movie clip to draw in.
		 * @param _dash Length of visible dash lines.
		 * @param _gap Length of space between dash lines.
		 */
		function Dash( dash:Number = 5, gap:Number = 5, graphics:Graphics = null )
		{
			_graphics = graphics;
			_dash = dash;
			_gap = gap;
			_dashLength = _dash + _gap;
			_isLine = true;
			_overflow = 0;
			_pen = new Point();
		}


		public function get graphics():Graphics
		{
			return graphics;
		}
		public function set graphics( value:Graphics ):void
		{
			_graphics = value;
		}

		/**
		 * Gets the current lengths for dash sizes
		 * @return Array containing the _dash and _gap values
		 * respectively in that order
		 */
		public function get dash():Number
		{
			return _dash;
		}
		public function set dash( value:Number ):void
		{
			_dash = value;
			_dashLength = _dash + _gap;
		}
		
		/**
		 * Gets the current lengths for dash sizes
		 * @return Array containing the _dash and _gap values
		 * respectively in that order
		 */
		public function get gap():Number
		{
			return _gap;
		}
		public function set gap( value:Number ):void
		{
			_gap = value;
			_dashLength = _dash + _gap;
		}


		/**
		 * Moves the current drawing position in target to (x, y).
		 * @param x An integer indicating the horizontal position relative to the registration point of
		 * the parent movie clip.
		 * @param An integer indicating the vertical position relative to the registration point of the
		 * parent movie clip.
		 * @return nothing
		 */
		public function moveTo( x:Number, y:Number ):void
		{
			targetMoveTo( x, y );
		}


		/**
		 * Draws a dashed line in target using the current line style from the current drawing position
		 * to (x, y); the current drawing position is then set to (x, y).
		 * @param x An integer indicating the horizontal position relative to the registration point of
		 * the parent movie clip.
		 * @param An integer indicating the vertical position relative to the registration point of the
		 * parent movie clip.
		 * @return nothing
		 */
		public function lineTo( x:Number, y:Number ):void
		{
			var dx:Number = x - _pen.x
			var dy:Number = y - _pen.y;
			var a:Number = Math.atan2( dy, dx );
			var ca:Number = Math.cos( a );
			var sa:Number = Math.sin( a );
			var segLength:Number = lineLength( dx, dy );
			if( _overflow )
			{
				if( _overflow > segLength )
				{
					if( _isLine )
						targetLineTo( x, y );
					else
						targetMoveTo( x, y );
					_overflow -= segLength;
					return;
				}
				if( _isLine )
					targetLineTo( _pen.x + ca * _overflow, _pen.y + sa * _overflow );
				else
					targetMoveTo( _pen.x + ca * _overflow, _pen.y + sa * _overflow );
				segLength -= _overflow;
				_overflow = 0;
				_isLine = !_isLine;
				if( !segLength )
					return;
			}
			var fullDashCount:int = Math.floor( segLength / _dashLength );
			if( fullDashCount )
			{
				var onx:Number = ca * _dash;
				var ony:Number = sa * _dash;
				var offx:Number = ca * _gap
				var offy:Number = sa * _gap;
				for( var i:int = 0; i < fullDashCount; i++ )
				{
					if( _isLine )
					{
						targetLineTo( _pen.x + onx, _pen.y + ony );
						targetMoveTo( _pen.x + offx, _pen.y + offy );
					}
					else
					{
						targetMoveTo( _pen.x + offx, _pen.y + offy );
						targetLineTo( _pen.x + onx, _pen.y + ony );
					}
				}
				segLength -= _dashLength * fullDashCount;
			}
			if( _isLine )
			{
				if( segLength > _dash )
				{
					targetLineTo( _pen.x + ca * _dash, _pen.y + sa * _dash );
					targetMoveTo( x, y );
					_overflow = _gap - ( segLength - _dash );
					_isLine = false;
				}
				else
				{
					targetLineTo( x, y );
					if( segLength == _dash )
					{
						_overflow = 0;
						_isLine = !_isLine;
					}
					else
					{
						_overflow = _dash - segLength;
						targetMoveTo( x, y );
					}
				}
			}
			else
			{
				if( segLength > _gap )
				{
					targetMoveTo( _pen.x + ca * _gap, _pen.y + sa * _gap );
					targetLineTo( x, y );
					_overflow = _dash - ( segLength - _gap );
					_isLine = true;
				}
				else
				{
					targetMoveTo( x, y );
					if( segLength == _gap )
					{
						_overflow = 0;
						_isLine = !_isLine;
					}
					else
						_overflow = _gap - segLength;
				}
			}
		}


		/**
		 * Draws a dashed curve in target using the current line style from the current drawing position to
		 * (x, y) using the control point specified by (cx, cy). The current  drawing position is then set
		 * to (x, y).
		 * @param cx An integer that specifies the horizontal position of the control point relative to
		 * the registration point of the parent movie clip.
		 * @param cy An integer that specifies the vertical position of the control point relative to the
		 * registration point of the parent movie clip.
		 * @param x An integer that specifies the horizontal position of the next anchor point relative
		 * to the registration. point of the parent movie clip.
		 * @param y An integer that specifies the vertical position of the next anchor point relative to
		 * the registration point of the parent movie clip.
		 * @return nothing
		 */
		public function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void
		{
			var sx:Number = _pen.x;
			var sy:Number = _pen.y;
			var segLength:Number = curveLength( sx, sy, cx, cy, x, y );
			var t:Number = 0;
			var t2:Number = 0;
			var c:Vector.<Number>;
			if( _overflow )
			{
				if( _overflow > segLength )
				{
					if( _isLine )
						targetCurveTo( cx, cy, x, y );
					else
						targetMoveTo( x, y );
					_overflow -= segLength;
					return;
				}
				t = _overflow / segLength;
				c = curveSliceUpTo( sx, sy, cx, cy, x, y, t );
				if( _isLine )
					targetCurveTo( c[ 2 ], c[ 3 ], c[ 4 ], c[ 5 ] );
				else
					targetMoveTo( c[ 4 ], c[ 5 ] );
				_overflow = 0;
				_isLine = !_isLine;
				if( !segLength )
					return;
			}
			var remainLength:Number = segLength - segLength * t;
			var fullDashCount:int = Math.floor( remainLength / _dashLength );
			var ont:Number = _dash / segLength;
			var offt:Number = _gap / segLength;
			if( fullDashCount )
			{
				for( var i:int = 0; i < fullDashCount; i++ )
				{
					if( _isLine )
					{
						t2 = t + ont;
						c = curveSlice( sx, sy, cx, cy, x, y, t, t2 );
						targetCurveTo( c[ 2 ], c[ 3 ], c[ 4 ], c[ 5 ] );
						t = t2;
						t2 = t + offt;
						c = curveSlice( sx, sy, cx, cy, x, y, t, t2 );
						targetMoveTo( c[ 4 ], c[ 5 ] );
					}
					else
					{
						t2 = t + offt;
						c = curveSlice( sx, sy, cx, cy, x, y, t, t2 );
						targetMoveTo( c[ 4 ], c[ 5 ] );
						t = t2;
						t2 = t + ont;
						c = curveSlice( sx, sy, cx, cy, x, y, t, t2 );
						targetCurveTo( c[ 2 ], c[ 3 ], c[ 4 ], c[ 5 ] );
					}
					t = t2;
				}
			}
			remainLength = segLength - segLength * t;
			if( _isLine )
			{
				if( remainLength > _dash )
				{
					t2 = t + ont;
					c = curveSlice( sx, sy, cx, cy, x, y, t, t2 );
					targetCurveTo( c[ 2 ], c[ 3 ], c[ 4 ], c[ 5 ] );
					targetMoveTo( x, y );
					_overflow = _gap - ( remainLength - _dash );
					_isLine = false;
				}
				else
				{
					c = curveSliceFrom( sx, sy, cx, cy, x, y, t );
					targetCurveTo( c[ 2 ], c[ 3 ], c[ 4 ], c[ 5 ] );
					if( segLength == _dash )
					{
						_overflow = 0;
						_isLine = !_isLine;
					}
					else
					{
						_overflow = _dash - remainLength;
						targetMoveTo( x, y );
					}
				}
			}
			else
			{
				if( remainLength > _gap )
				{
					t2 = t + offt;
					c = curveSlice( sx, sy, cx, cy, x, y, t, t2 );
					targetMoveTo( c[ 4 ], c[ 5 ] );
					c = curveSliceFrom( sx, sy, cx, cy, x, y, t2 );
					targetCurveTo( c[ 2 ], c[ 3 ], c[ 4 ], c[ 5 ] );

					_overflow = _dash - ( remainLength - _gap );
					_isLine = true;
				}
				else
				{
					targetMoveTo( x, y );
					if( remainLength == _gap )
					{
						_overflow = 0;
						_isLine = !_isLine;
					}
					else
						_overflow = _gap - remainLength;
				}
			}
		}


		// direct translations
		/**
		 * Clears the drawing in target
		 * @return nothing
		 */
		public function clear():void
		{
			_graphics.clear();
		}


		/**
		 * Sets the lineStyle for target
		 * @param thickness An integer that indicates the thickness of the line in points; valid values
		 * are 0 to 255. If a number is not specified, or if the parameter is undefined, a line is not
		 * drawn. If a value of less than 0 is passed, Flash uses 0. The value 0 indicates hairline
		 * thickness; the maximum thickness is 255. If a value greater than 255 is passed, the Flash
		 * interpreter uses 255.
		 * @param rgb A hex color value (for example, red is 0xFF0000, blue is 0x0000FF, and so on) of
		 * the line. If a value isn’t indicated, Flash uses 0x000000 (black).
		 * @param alpha An integer that indicates the alpha value of the line’s color; valid values are
		 * 0–100. If a value isn’t indicated, Flash uses 100 (solid). If the value is less than 0, Flash
		 * uses 0; if the value is greater than 100, Flash uses 100.
		 * @return nothing
		 */
		public function lineStyle( thickness:Number, rgb:Number, alpha:Number ):void
		{
			_graphics.lineStyle( thickness, rgb, alpha );
		}


		/**
		 * Sets a basic fill style for target
		 * @param rgb A hex color value (for example, red is 0xFF0000, blue is 0x0000FF, and so on). If
		 * this value is not provided or is undefined, a fill is not created.
		 * @param alpha An integer between 0–100 that specifies the alpha value of the fill. If this value
		 * is not provided, 100 (solid) is used. If the value is less than 0, Flash uses 0. If the value is
		 * greater than 100, Flash uses 100.
		 * @return nothing
		 */
		public function beginFill( rgb:Number, alpha:Number ):void
		{
			_graphics.beginFill( rgb, alpha );
		}


		/**
		 * Sets a gradient fill style for target
		 * @param fillType Either the string "linear" or the string "radial".
		 * @param colors An array of RGB hex color values to be used in the gradient (for example, red is
		 * 0xFF0000, blue is 0x0000FF, and so on).
		 * @param alphas An array of alpha values for the corresponding colors in the colors array; valid
		 * values are 0–100. If the value is less than 0, Flash uses 0. If the value is greater than 100,
		 * Flash uses 100.
		 * @param ratios An array of color distribution ratios; valid values are 0–255. This value defines
		 * the percentage of the width where the color is sampled at 100 percent.
		 * @param matrix A transformation matrix that is an object with one of two sets of properties.
		 * @return nothing
		 */
		public function beginGradientFill( fillType:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix ):void
		{
			_graphics.beginGradientFill( fillType, colors, alphas, ratios, matrix );
		}


		/**
		 * Ends the fill style for target
		 * @return nothing
		 */
		public function endFill():void
		{
			_graphics.endFill();
		}


		// private methods
		private function lineLength( sx:Number, sy:Number, ex:Number=NaN, ey:Number=NaN ):Number
		{
			if( arguments.length == 2 ) return Math.sqrt( sx * sx + sy * sy );
			
			var dx:Number = ex - sx;
			var dy:Number = ey - sy;
			return Math.sqrt( dx * dx + dy * dy );
		}


		private function curveLength( sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, accuracy:Number=0 ):Number
		{
			var total:Number = 0;
			var tx:Number = sx;
			var ty:Number = sy;
			var px:Number, py:Number, t:Number, it:Number, a:Number, b:Number, c:Number;
			var n:Number = ( accuracy ) ? accuracy : _curveaccuracy;
			
			for( var i:int = 1; i <= n; i++ )
			{
				t = i / n;
				it = 1 - t;
				a = it * it;
				b = 2 * t * it;
				c = t * t;
				px = a * sx + b * cx + c * ex;
				py = a * sy + b * cy + c * ey;
				total += lineLength( tx, ty, px, py );
				tx = px;
				ty = py;
			}
			return total;
		}


		private function curveSlice( sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, t1:Number, t2:Number ):Vector.<Number>
		{
			if( t1 == 0 ) return curveSliceUpTo( sx, sy, cx, cy, ex, ey, t2 );
			if( t2 == 1 ) return curveSliceFrom( sx, sy, cx, cy, ex, ey, t1 );
			
			var c:Vector.<Number> = curveSliceUpTo( sx, sy, cx, cy, ex, ey, t2 );
			c.push( t1 / t2 );
			return curveSliceFrom.apply( this, c );
		}


		private function curveSliceUpTo( sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, t:Number ):Vector.<Number>
		{
			if( isNaN( t ) ) t = 1;
			
			if( t != 1 )
			{
				var midx:Number = cx + ( ex - cx ) * t;
				var midy:Number = cy + ( ey - cy ) * t;
				cx = sx + ( cx - sx ) * t;
				cy = sy + ( cy - sy ) * t;
				ex = cx + ( midx - cx ) * t;
				ey = cy + ( midy - cy ) * t;
			}
			return  new Vector.<Number>( [ sx, sy, cx, cy, ex, ey ] );
		}


		private function curveSliceFrom( sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, t:Number ):Vector.<Number>
		{
			if( isNaN( t ) ) t = 1;
			
			if( t != 1 )
			{
				var midx:Number = sx + ( cx - sx ) * t;
				var midy:Number = sy + ( cy - sy ) * t;
				cx = cx + ( ex - cx ) * t;
				cy = cy + ( ey - cy ) * t;
				sx = midx + ( cx - midx ) * t;
				sy = midy + ( cy - midy ) * t;
			}
			return new Vector.<Number>( [ sx, sy, cx, cy, ex, ey ] );
		}


		private function targetMoveTo( x:Number, y:Number ):void
		{
			_pen.x = x;
			_pen.y = y;
			_graphics.moveTo( x, y );
		}


		private function targetLineTo( x:Number, y:Number ):void
		{
			if( x == _pen.x && y == _pen.y )
				return;
			_pen.x = x;
			_pen.y = y;
			_graphics.lineTo( x, y );
		}


		private function targetCurveTo( cx:Number, cy:Number, x:Number, y:Number ):void
		{
			if( cx == x && cy == y && x == _pen.x && y == _pen.y )
				return;
			_pen.x = x;
			_pen.y = y;
			_graphics.curveTo( cx, cy, x, y );
		}

	}
}
