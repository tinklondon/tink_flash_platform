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
	
	import spark.primitives.supportClasses.StrokedElement;
	
	import ws.tink.graphics.IGraphicsCreator;
	import ws.tink.spark.graphics.IGraphicsDefiner;
	
	/**
	 *  The Cross class is a graphic element that draws 2 lines creating a cross.
	 * 
	 *  <p>If a standard stroke used this class calls the <code>Graphics.moveTo()</code> and
	 *  <code>Graphics.lineTo()</code> methods.
	 *  If the stroke implements IGraphicsDefiner, this class uses <code>IGraphicsCreator.moveTo()</code>
	 *  and <code>IGraphicsCreator.lineTo()</code> methods.</p>
	 *  
	 *  @see flash.display.Graphics
	 *  @see ws.tink.graphics.IGraphicsCreator
	 *  @see ws.tink.spark.graphics.IGraphicsDefiner
	 *  
	 *  @includeExample examples/LineExample.mxml
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class Cross extends StrokedElement
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
		public function Cross()
		{
			super();
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
			var strokeBounds:Rectangle = getStrokeBounds();
			strokeBounds.offset(drawX, drawY);
			stroke.apply( g, strokeBounds, new Point( drawX, drawY ) );
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
		override protected function draw(g:Graphics):void
		{
			var strokeCreator:IGraphicsCreator = ( stroke is IGraphicsDefiner ) ? IGraphicsDefiner( stroke ).graphicsCreator : null;
			
			if( strokeCreator )
			{
				setupStroke( g );
				strokeCreator.moveTo( drawX, drawY );
				strokeCreator.lineTo( drawX + width, drawY + height );
				strokeCreator.moveTo( drawX + width, drawY );
				strokeCreator.lineTo( drawX, drawY + height );
			}
			else
			{
				g.moveTo( drawX, drawY );
				g.lineTo( drawX + width, drawY + height );
				g.moveTo( drawX + width, drawY );
				g.lineTo( drawX, drawY + height );
			}
		}
		
	}
}