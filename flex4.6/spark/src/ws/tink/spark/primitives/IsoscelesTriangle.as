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

package ws.tink.spark.primitives
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.primitives.supportClasses.FilledElement;
	
	import ws.tink.graphics.IGraphicsCreator;
	import ws.tink.graphics.utils.IsoscelesTriangleUtil;
	import ws.tink.spark.graphics.IGraphicsDefiner;

	public class IsoscelesTriangle extends FilledElement
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
		public function IsoscelesTriangle()
		{
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			
			if( width && !height ) height = width * 0.8660254037844386;
		}
		
		override public function set height( value:Number ):void
		{
			super.height = value;
			
			if( height && !width ) width = height * 1.1339745962155614;
		}
		
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
		private function setupStroke( g:Graphics ):void
		{
			g.endFill();
			
			var strokeBounds:Rectangle = getStrokeBounds();
			strokeBounds.offset(drawX, drawY);
			stroke.apply( g, strokeBounds, new Point() );
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
		private function setupFill( g:Graphics ):void
		{
			var fillBounds:Rectangle = new Rectangle(drawX, drawY, width, height);
			fill.begin( g, fillBounds, new Point() );
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
//		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
//		{
//			if( unscaledWidth > 0 && unscaledHeight == 0 )
//			{
//				height = unscaledHeight = unscaledWidth * ( Math.sqrt( 3 ) / 2 );
//			}
//			else if( unscaledHeight > 0 && unscaledWidth == 0 )
//			{
//				width = unscaledWidth = unscaledHeight * ( 2 - ( Math.sqrt( 3 ) / 2 ) );
//			}
//				
//			super.updateDisplayList( unscaledWidth, unscaledHeight );
//		}
		
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
			// Don't call super.beginDraw() since it will also set up an 
			// invisible fill.
			
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
			
			const halfWidth:Number = width / 2;
			const halfHeight:Number = height / 2;
			
			if( !strokeAndFillCreators )
			{
				IsoscelesTriangleUtil.drawTriangle( g, drawX, drawY, width, height );
			}
			
			if( fillCreator )
			{
				setupFill( g );
				IsoscelesTriangleUtil.drawGraphicsCreatorTriangle( fillCreator, drawX, drawY, width, height );
			}
			
			if( strokeCreator )
			{
				setupStroke( g );
				IsoscelesTriangleUtil.drawGraphicsCreatorTriangle( strokeCreator, drawX, drawY, width, height );
			}
		}
	}
}