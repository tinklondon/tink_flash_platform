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

package ws.tink.spark.primitives
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ws.tink.graphics.IGraphicsCreator;
	import ws.tink.graphics.utils.EllipseUtil;
	import ws.tink.spark.graphics.IGraphicsDefiner;
	import ws.tink.spark.primitives.Ellipse;
	
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
		private var _holeWidth:Number = 0;
		
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
		public function get holeWidth():Number
		{
			return _holeWidth;
		}
		/**
		 *  @private
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
		private var _holeHeight:Number = 0;
		
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
		public function get holeHeight():Number
		{
			return _holeHeight;
		}
		/**
		 *  @private
		 */
		public function set holeHeight( value:Number ):void
		{
			_holeHeight =  value;
			invalidateDisplayList();
		}
		
		
		//----------------------------------
		//  holeOffsetX
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for holeOffsetX.
		 */
		private var _holeOffsetX:Number = 0;
		
		/**
		 *  The amount to offset the x position of the hole to punch out of the filled shape.
		 * 
		 *  @default 0
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get holeOffsetX():Number
		{
			return _holeOffsetX;
		}
		/**
		 *  @private
		 */
		public function set holeOffsetX( value:Number ):void
		{
			_holeOffsetX =  value;
			invalidateDisplayList();
		}
		
		
		//----------------------------------
		//  holeOffsetY
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for holeOffsetY.
		 */
		private var _holeOffsetY:Number = 0;
		
		/**
		 *  The amount to offset the y position of the hole to punch out of the filled shape.
		 * 
		 *  @default 0
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get holeOffsetY():Number
		{
			return _holeOffsetY;
		}
		/**
		 *  @private
		 */
		public function set holeOffsetY( value:Number ):void
		{
			_holeOffsetY =  value;
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
			const strokeCreator:IGraphicsCreator = ( stroke is IGraphicsDefiner ) ? IGraphicsDefiner( stroke ).graphicsCreator : null;
			const fillCreator:IGraphicsCreator = ( fill is IGraphicsDefiner ) ? IGraphicsDefiner( fill ).graphicsCreator : null;
			const strokeAndFillCreators:Boolean = strokeCreator && fillCreator;
			
			const holeW:Number = holeWidth > width ? width : holeWidth;
			const holeH:Number = holeHeight > height ? height : holeHeight;
			
			if( !strokeAndFillCreators )
			{
				g.drawEllipse( drawX, drawY, width, height );
				g.drawEllipse( drawX + holeOffsetX + ( ( width - holeW ) / 2 ), drawY + holeOffsetY + ( ( height - holeH ) / 2 ), holeW, holeH );
			}
			
			const radiusX:Number = width / 2;
			const radiusY:Number = height / 2;
			const holeRadiusX:Number = holeW / 2;
			const holeRadiusY:Number = holeH / 2;
			
			if( fillCreator )
			{
				setupFill( g );
				EllipseUtil.drawEllipse( strokeCreator, drawX + radiusX, drawY + radiusY, radiusX, radiusY );
				EllipseUtil.drawEllipse( strokeCreator, drawX + holeOffsetX + radiusX, drawY + holeOffsetY + radiusY, holeRadiusX, holeRadiusY );
			}
			
			if( strokeCreator )
			{
				setupStroke( g );
				EllipseUtil.drawEllipse( strokeCreator, drawX + radiusX, drawY + radiusY, radiusX, radiusY );
				EllipseUtil.drawEllipse( strokeCreator, drawX + holeOffsetX + radiusX, drawY + holeOffsetY + radiusY, holeRadiusX, holeRadiusY );
			}

		}
	}
}