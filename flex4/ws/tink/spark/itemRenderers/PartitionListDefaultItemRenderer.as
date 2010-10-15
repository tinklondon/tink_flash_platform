package ws.tink.spark.itemRenderers
{
	import spark.skins.spark.DefaultItemRenderer;
	
	public class PartitionListDefaultItemRenderer extends DefaultItemRenderer
	{
		public function PartitionListDefaultItemRenderer()
		{
			super();
			
			height = 100;
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
//			label = data.label;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			graphics.clear();
			graphics.beginFill( 0xFF0000, 1 );
			graphics.drawRect( 0, 0, unscaledWidth, unscaledHeight );
			graphics.endFill();
		}
	}
}