package ws.tink.graphics
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.geom.Point;
	
	public class GraphicsCreator implements IGraphicsCreator
	{
		private var _pen:Point;
		private var _graphics	: Graphics;
		private var _overflow:Number = 0;
		private var _isLine:Boolean = true;
		
		private var _totalLength		: Number;
		private var _lineLength			: Number;
		private var _gapLength				: Number;
		
		
		
		/**
		 * A value representing the accuracy used in determining the length
		 * of curveTo curves.
		 */
		public var _curveAccuracy:int;
		public var _drawOverFlow:Boolean;
		
		
		protected function get lineLength():Number
		{
			return _lineLength;
		}
		
		protected function get gapLength():Number
		{
			return _gapLength;
		}
		
		public function setupLenghts( line:Number, gap:Number ):void
		{
			_lineLength = line;
			_gapLength = gap;
			_totalLength = _lineLength + _gapLength;
		}
		
		
		
		public function GraphicsCreator( graphics:Graphics, drawOverFlow:Boolean = false, curveAccuracy:int = 6 )
		{
			_graphics = graphics;
			_pen = new Point();
			_isLine = true;
			_overflow = 0;
			_drawOverFlow = drawOverFlow;
			_curveAccuracy = curveAccuracy;
		}
		
		
		public function get drawOverFlow():Boolean
		{
			return _drawOverFlow;
		}
		public function set drawOverFlow( value:Boolean ):void
		{
			_drawOverFlow = value;
		}
		
		
		
		public function get graphics():Graphics
		{
			return _graphics;
		}
		public function set graphics( value:Graphics ):void
		{
			_graphics = value;
		}
		
		public function get curveAccuracy():int
		{
			return _curveAccuracy;
		}
		public function set curveAccuracy( value:int ):void
		{
			_curveAccuracy = value;
		}
		
		public function lineStyle(thickness:Number=NaN, color:uint=0, alpha:Number=1.0, pixelHinting:Boolean=false, scaleMode:String="normal", caps:String=null, joints:String=null, miterLimit:Number=3):void
		{
			_graphics.lineStyle( thickness, color, alpha, pixelHinting, scaleMode,
				caps, joints, miterLimit );
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
			updatePen( x, y );
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
			var segLength:Number = getLineLength( dx, dy );
			if( _overflow )
			{
				if( _overflow > segLength )
				{
					if( _isLine )
					{
						targetLineTo( x, y );
						updatePen( x, y );
					}
					else
					{
						targetMoveTo( x, y );
						updatePen( x, y );
					}
					_overflow -= segLength;
					return;
				}
				if( _isLine )
				{
					targetLineTo( _pen.x + ca * _overflow, _pen.y + sa * _overflow );
					updatePen(  _pen.x + ca * _overflow, _pen.y + sa * _overflow );
				}
				else
				{
					targetMoveTo( _pen.x + ca * _overflow, _pen.y + sa * _overflow );
					updatePen( _pen.x + ca * _overflow, _pen.y + sa * _overflow );
				}
				segLength -= _overflow;
				_overflow = 0;
				_isLine = !_isLine;
				if( !segLength )
					return;
			}
			var fullDashCount:int = Math.floor( segLength / _totalLength );
			if( fullDashCount )
			{
				var onx:Number = ca * _lineLength;
				var ony:Number = sa * _lineLength;
				var offx:Number = ca * _gapLength
				var offy:Number = sa * _gapLength;
				for( var i:int = 0; i < fullDashCount; i++ )
				{
					if( _isLine )
					{
						targetLineTo( _pen.x + onx, _pen.y + ony );
						updatePen( _pen.x + onx, _pen.y + ony );
						targetMoveTo( _pen.x + offx, _pen.y + offy );
						updatePen( _pen.x + offx, _pen.y + offy );
					}
					else
					{
						targetMoveTo( _pen.x + offx, _pen.y + offy );
						updatePen( _pen.x + offx, _pen.y + offy );
						targetLineTo( _pen.x + onx, _pen.y + ony );
						updatePen( _pen.x + onx, _pen.y + ony );
					}
				}
				segLength -= _totalLength * fullDashCount;
			}
			if( _isLine )
			{
				if( segLength > _lineLength )
				{
					targetLineTo( _pen.x + ca * _lineLength, _pen.y + sa * _lineLength );
					updatePen( _pen.x + ca * _lineLength, _pen.y + sa * _lineLength );
					targetMoveTo( x, y );
					updatePen( x, y );
					_overflow = _gapLength - ( segLength - _lineLength );
					_isLine = false;
				}
				else
				{
					targetLineTo( x, y );
					updatePen( x, y );
					if( segLength == _lineLength )
					{
						_overflow = 0;
						_isLine = !_isLine;
					}
					else
					{
						_overflow = _lineLength - segLength;
						targetMoveTo( x, y );
						updatePen( x, y );
					}
				}
			}
			else
			{
				if( segLength > _gapLength )
				{
					targetMoveTo( _pen.x + ca * _gapLength, _pen.y + sa * _gapLength );
					updatePen( _pen.x + ca * _gapLength, _pen.y + sa * _gapLength );
					targetLineTo( x, y );
					updatePen( x, y );
					_overflow = _lineLength - ( segLength - _gapLength );
					_isLine = true;
				}
				else
				{
					targetMoveTo( x, y );
					updatePen( x, y );
					if( segLength == _gapLength )
					{
						_overflow = 0;
						_isLine = !_isLine;
					}
					else
						_overflow = _gapLength - segLength;
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
					{
						targetCurveTo( cx, cy, x, y );
						updatePen( x, y );
					}
					else
					{
						targetMoveTo( x, y );
						updatePen( x, y );
					}
					_overflow -= segLength;
					return;
				}
				t = _overflow / segLength;
				c = curveSliceUpTo( sx, sy, cx, cy, x, y, t );
				if( _isLine )
				{
					targetCurveTo( c[ 2 ], c[ 3 ], c[ 4 ], c[ 5 ] );
					updatePen( c[ 4 ], c[ 5 ] );
				}
				else
				{
					targetMoveTo( c[ 4 ], c[ 5 ] );
					updatePen( c[ 4 ], c[ 5 ] );
				}
				_overflow = 0;
				_isLine = !_isLine;
				if( !segLength )
					return;
			}
			var remainLength:Number = segLength - segLength * t;
			var fullDashCount:int = Math.floor( remainLength / _totalLength );
			var ont:Number = _lineLength / segLength;
			var offt:Number = _gapLength / segLength;
			if( fullDashCount )
			{
				for( var i:int = 0; i < fullDashCount; i++ )
				{
					if( _isLine )
					{
						t2 = t + ont;
						c = curveSlice( sx, sy, cx, cy, x, y, t, t2 );
						targetCurveTo( c[ 2 ], c[ 3 ], c[ 4 ], c[ 5 ] );
						updatePen( c[ 4 ], c[ 5 ] );
						t = t2;
						t2 = t + offt;
						c = curveSlice( sx, sy, cx, cy, x, y, t, t2 );
						targetMoveTo( c[ 4 ], c[ 5 ] );
						updatePen( c[ 4 ], c[ 5 ] );
					}
					else
					{
						t2 = t + offt;
						c = curveSlice( sx, sy, cx, cy, x, y, t, t2 );
						targetMoveTo( c[ 4 ], c[ 5 ] );
						updatePen( c[ 4 ], c[ 5 ] );
						t = t2;
						t2 = t + ont;
						c = curveSlice( sx, sy, cx, cy, x, y, t, t2 );
						targetCurveTo( c[ 2 ], c[ 3 ], c[ 4 ], c[ 5 ] );
						updatePen( c[ 4 ], c[ 5 ] );
					}
					t = t2;
				}
			}
			remainLength = segLength - segLength * t;
			if( _isLine )
			{
				if( remainLength > _lineLength )
				{
					t2 = t + ont;
					c = curveSlice( sx, sy, cx, cy, x, y, t, t2 );
					targetCurveTo( c[ 2 ], c[ 3 ], c[ 4 ], c[ 5 ] );
					updatePen( c[ 4 ], c[ 5 ] );
					targetMoveTo( x, y );
					updatePen( x, y );
					_overflow = _gapLength - ( remainLength - _lineLength );
					_isLine = false;
				}
				else
				{
					if( _drawOverFlow )
					{
						c = curveSliceFrom( sx, sy, cx, cy, x, y, t );
						targetCurveTo( c[ 2 ], c[ 3 ], c[ 4 ], c[ 5 ] );
						updatePen( c[ 4 ], c[ 5 ] );
						if( segLength == _lineLength )
						{
							_overflow = 0;
							_isLine = !_isLine;
						}
						else
						{
							_overflow = _lineLength - remainLength;
							targetMoveTo( x, y );
							updatePen( x, y );
						}
					}
				}
			}
			else
			{
				if( _drawOverFlow )
				{
					if( remainLength > _gapLength )
					{
						t2 = t + offt;
						c = curveSlice( sx, sy, cx, cy, x, y, t, t2 );
						targetMoveTo( c[ 4 ], c[ 5 ] );
						updatePen( c[ 4 ], c[ 5 ] );
						c = curveSliceFrom( sx, sy, cx, cy, x, y, t2 );
						targetCurveTo( c[ 2 ], c[ 3 ], c[ 4 ], c[ 5 ] );
						updatePen( c[ 4 ], c[ 5 ] );
						_overflow = _lineLength - ( remainLength - _gapLength );
						_isLine = true;
					}
					else
					{
						targetMoveTo( x, y );
						updatePen( x, y );
						if( remainLength == _gapLength )
						{
							_overflow = 0;
							_isLine = !_isLine;
						}
						else
							_overflow = _gapLength - remainLength;
					}
				}
			}
		}
		
		public function drawPath(commands:Vector.<int>, data:Vector.<Number>, winding:String="evenOdd"):void
		{
			var index:int = 0;
			for each( var command:int in commands )
			{
				switch( command )
				{
					case GraphicsPathCommand.CURVE_TO :
					{
						curveTo( data[ index ], data[ index + 1 ], data[ index + 2 ], data[ index + 3 ] );
						index += 4;
						break;
					}
					case GraphicsPathCommand.LINE_TO :
					{
						lineTo( data[ index ], data[ index + 1 ] );
						index += 2;
						break;
					}
					case GraphicsPathCommand.MOVE_TO :
					{
						moveTo( data[ index ], data[ index + 1 ] );
						index += 2;
						break;
					}
					case GraphicsPathCommand.WIDE_LINE_TO :
					{
						lineTo( data[ index ], data[ index + 1 ] );
						index += 4;
						break;
					}
					case GraphicsPathCommand.WIDE_MOVE_TO :
					{
						moveTo( data[ index ], data[ index + 1 ] );
						index += 4;
						break;
					}
				}
			}
		}
		
		/**
		 * Clears the drawing in target
		 * @return nothing
		 */
		public function clear():void
		{
			_graphics.clear();
		}
		
		
		
		private function getLineLength( sx:Number, sy:Number, ex:Number=NaN, ey:Number=NaN ):Number
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
			var n:Number = ( accuracy ) ? accuracy : _curveAccuracy;
			
			for( var i:int = 1; i <= n; i++ )
			{
				t = i / n;
				it = 1 - t;
				a = it * it;
				b = 2 * t * it;
				c = t * t;
				px = a * sx + b * cx + c * ex;
				py = a * sy + b * cy + c * ey;
				total += getLineLength( tx, ty, px, py );
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
			return curveSliceFrom( c[ 0 ], c[ 1 ], c[ 2 ], c[ 3 ], c[ 4 ], c[ 5 ], t1 / t2 );
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
			return Vector.<Number>( [ sx, sy, cx, cy, ex, ey ] );
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
			return Vector.<Number>( [ sx, sy, cx, cy, ex, ey ] );
		}
		
		
		
		
		protected function targetMoveTo( x:Number, y:Number ):void
		{
			_graphics.moveTo( x, y );
		}
		
		private function updatePen( x:Number, y:Number ):void
		{
			_pen.x = x;
			_pen.y = y;
		}
		
		protected function targetLineTo( x:Number, y:Number ):void
		{
			if( x == penX && y == penY ) return;
			graphics.lineTo( x, y );
		}
		
		
		protected function targetCurveTo( cx:Number, cy:Number, x:Number, y:Number ):void
		{
			if( cx == x && cy == y && x == penX && y == penY ) return;
			graphics.curveTo( cx, cy, x, y );
		}
		
		
		public function get penX():Number
		{
			return _pen.x;
		}
		
		public function get penY():Number
		{
			return _pen.y;
		}
	}
}