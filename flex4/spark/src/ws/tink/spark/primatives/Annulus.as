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
	
	import ws.tink.graphics.IGraphicsCreator;
	import ws.tink.graphics.utils.EllipseUtil;
	import ws.tink.spark.graphics.IGraphicsDefiner;
	import ws.tink.spark.primatives.Ellipse;
	
	/**
	 *  The Annulus class is a filled graphic element that draws an annulus or ring.
	 *  
	 *  <p>If a standard stroke and fill is used this class calls the <code>Graphics.drawEllipse()</code> method.
	 *  If the stroke or fill implement IGraphicsDefiner, this class uses <code>EllipseUtil.drawEllipse()</code>.</p>
	 * 
	 *  @see flash.display.Graphics
	 *  @see ws.tink.graphics.IGraphicsCreator
	 *  @see ws.tink.graphics.utils.EllipseUtil
	 *  @see ws.tink.spark.graphics.IGraphicsDefiner
	 *  
	 *  @includeExample examples/AnnulusExample.mxml
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class Annulus extends Ellipse
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
		public function Annulus()
		{
			super();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  holeWidth
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for holeWidth.
		 */
		private var _holeWidth:Number;
		
		/**
		 *  The width of the hole to punch out of the filled shape.
		 * 
		 *  @default 0
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function set holeWidth( value:Number ):void
		{
			_holeWidth = value;
			invalidateDisplayList();
		}
		
		
		//----------------------------------
		//  holeHeight
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for holeHeight.
		 */
		private var _holeHeight:Number;
		
		/**
		 *  The height of the hole to punch out of the filled shape.
		 * 
		 *  @default 0
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function set holeHeight( value:Number ):void
		{
			_holeHeight =  value;
			invalidateDisplayList();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
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
		override protected function draw( g:Graphics ):void
		{
			var strokeCreator:IGraphicsCreator = ( stroke is IGraphicsDefiner ) ? IGraphicsDefiner( stroke ).graphicsCreator : null;
			var fillCreator:IGraphicsCreator = ( fill is IGraphicsDefiner ) ? IGraphicsDefiner( fill ).graphicsCreator : null;
			var strokeAndFillCreators:Boolean = strokeCreator && fillCreator;
			
			var w:Number = _holeWidth > width ? width : _holeWidth;
			var h:Number = _holeHeight > height ? height : _holeHeight;
			var w2:Number = w / 2;
			var h2:Number = h / 2;
			
			if( !strokeAndFillCreators )
			{
				g.drawEllipse( drawX, drawY, width, height );
				g.drawEllipse( drawX + ( ( width - w ) / 2 ), drawY + ( ( height - h ) / 2 ), w, h );
			}
			
			var radiusX:Number = width / 2;
			var radiusY:Number = height / 2;
			
			if( fillCreator )
			{
				setupFill( g );
				EllipseUtil.drawEllipse( fillCreator, drawX + radiusX, drawY + ( height / 2 ), radiusX, radiusY );
				EllipseUtil.drawEllipse( fillCreator, drawX + ( ( width - w ) / 2 ), drawY + ( ( height - h ) / 2 ), w2, h2 );
			}
			
			if( strokeCreator )
			{
				setupStroke( g );
				EllipseUtil.drawEllipse( strokeCreator, drawX + radiusX, drawY + radiusY, radiusX, radiusY );
				EllipseUtil.drawEllipse( strokeCreator, drawX + radiusX, drawY + radiusY, w2, h2 );
			}

		}
	}
}