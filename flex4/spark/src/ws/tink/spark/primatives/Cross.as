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
	 *  and <code>IGraphicsCreator.lineTo() methods.</p>
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