package ws.tink.spark.skins.errors
{
	import ws.tink.spark.skins.supportClasses.TargetSkinBase;
	
	public class OutlineErrorSkin extends TargetSkinBase
	{
		public function OutlineErrorSkin()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			graphics.clear();
			graphics.lineStyle( 1, getStyle( "errorColor" ), 1 );
			graphics.drawRect( 0, 0, unscaledWidth, unscaledHeight );
			graphics.endFill();
		}
	}
}