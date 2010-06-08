package ws.tink.spark.primatives
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.primitives.supportClasses.StrokedElement;
	
	import ws.tink.graphics.IGraphicsCreator;
	import ws.tink.spark.graphics.IGraphicsDefiner;
	
	public class Cross extends StrokedElement
	{
		public function Cross()
		{
			super();
		}
		
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
		
		
		private function setupStroke( g:Graphics ):void
		{
			var strokeBounds:Rectangle = getStrokeBounds();
			strokeBounds.offset(drawX, drawY);
			stroke.apply( g, strokeBounds, new Point( drawX, drawY ) );
		}
	}
}