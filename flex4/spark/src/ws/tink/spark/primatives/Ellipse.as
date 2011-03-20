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
	
	import spark.primitives.Ellipse;
	import spark.primitives.Graphic;
	import spark.primitives.Rect;
	
	import ws.tink.graphics.Dash;
	import ws.tink.graphics.IGraphicsCreator;
	import ws.tink.graphics.utils.EllipseUtil;
	import ws.tink.graphics.utils.RectUtil;
	import ws.tink.spark.graphics.IGraphicsDefiner;
	
	/**
	 *  The Ellipse class is a filled graphic element that draws an ellipse.
	 *  The <code>st:Ellipse</code> differs from the <code>s:Ellipse</code> as it enables the use of custom
	 *  strokes and fills by using a IGraphicsCreator to implement the drawing.
	 *  
	 *  <p>If a standard stroke and fill is used this class calls the <code>Graphics.drawEllipse()</code> method.
	 *  If the stroke or fill implement IGraphicsDefiner, this class uses <code>EllipseUtil.drawEllipse()</code>.</p>
	 * 
	 *  @see flash.display.Graphics
	 *  @see ws.tink.graphics.IGraphicsCreator
	 *  @see ws.tink.graphics.utils.EllipseUtil
	 *  @see ws.tink.spark.graphics.IGraphicsDefiner
	 *  
	 *  @includeExample examples/EllipseExample.mxml
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class Ellipse extends spark.primitives.Ellipse
	{
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function Ellipse()
		{
			super();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var _origin	: Point;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Set up the stroke properties for this drawing element.
		 *  
		 *  @param g The graphic element to draw.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		protected function setupStroke( g:Graphics ):void
		{
			g.endFill();
			
			var strokeBounds:Rectangle = getStrokeBounds();
			strokeBounds.offset( drawX, drawY );
			stroke.apply( g, strokeBounds, _origin );
		}
		
		/**
		 *  Set up the fill properties for this drawing element.
		 *  
		 *  @param g The graphic element to draw.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		protected function setupFill( g:Graphics ):void
		{
			var fillBounds:Rectangle = new Rectangle(drawX, drawY, width, height);
			fill.begin( g, fillBounds, _origin );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function beginDraw( g:Graphics ):void
		{
			// Don't call super.beginDraw() as this won't let us use
			// our custom strokes and fills.
			
			_origin = new Point( drawX, drawY );
			
			
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
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function draw( g:Graphics ):void
		{
			var strokeCreator:IGraphicsCreator = ( stroke is IGraphicsDefiner ) ? IGraphicsDefiner( stroke ).graphicsCreator : null;
			var fillCreator:IGraphicsCreator = ( fill is IGraphicsDefiner ) ? IGraphicsDefiner( fill ).graphicsCreator : null;
			var strokeAndFillCreators:Boolean = strokeCreator && fillCreator;
			
			if( !strokeAndFillCreators )
			{
				g.drawEllipse( drawX, drawY, width, height );
			}
			
			var radiusX:Number = width / 2;
			var radiusY:Number = height / 2;
			
			if( fillCreator )
			{
				setupFill( g );
				EllipseUtil.drawEllipse( fillCreator, drawX + radiusX, drawY + ( height / 2 ), radiusX, radiusY );
			}
			
			if( strokeCreator )
			{
				setupStroke( g );
				EllipseUtil.drawEllipse( strokeCreator, drawX + radiusX, drawY + radiusY, radiusX, radiusY );
			}
		}
	}
}