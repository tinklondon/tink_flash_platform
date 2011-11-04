package ws.tink.spark.itemRenderers
{
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Matrix;
	
	import mx.core.mx_internal;
	import mx.utils.ColorUtil;
	
	import spark.components.DataRenderer;
	import spark.components.IItemRenderer;
	import spark.components.ResizeMode;
	import spark.components.supportClasses.ItemRenderer;
	
	import ws.tink.graphics.utils.StarUtil;
	
	use namespace mx_internal;
	
	public class RatingsBarItemRenderer extends ItemRenderer
	{
		public function RatingsBarItemRenderer()
		{
			super();
			
			autoDrawBackground = true;
			width = 50;
			height = 50;
		}
		
		
		override mx_internal function drawBackground():void
		{
			autoDrawBackground = false;
			super.drawBackground();
			autoDrawBackground = true;
			
			// TODO (rfrishbe): Would be good to remove this duplicate code with the 
			// super.drawBackground() version
			var w:Number = (resizeMode == ResizeMode.SCALE) ? measuredWidth : unscaledWidth;
			var h:Number = (resizeMode == ResizeMode.SCALE) ? measuredHeight : unscaledHeight;
			
			if (isNaN(w) || isNaN(h))
				return;
			
			graphics.clear();
			
			var backgroundColor:uint;
			var drawBackground:Boolean = true;
			var colors:Array;
			
			if (selected)
				colors = getStyle("selectionColors");
				if( !colors || !colors.length ) colors = [ getStyle("selectionColor") ];
			else
			{
				colors = getStyle("colors");
				if( !colors || !colors.length ) colors = [ getStyle("color") ];
			}
			
//			graphics.beginFill( backgroundColor, 1 );
			const matrix:Matrix = new Matrix();
			matrix.createGradientBox( 50, 50, 0, 0, 0 );
			graphics.beginGradientFill( GradientType.RADIAL, [ backgroundColor, ColorUtil.adjustBrightness( backgroundColor, -100 ) ], [ 1, 1 ], [ 0, 255 ], matrix );//
//			graphics.lineStyle( 1, ColorUtil.adjustBrightness( backgroundColor, -150 ), 1, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER );
			//			graphics.drawRect( 0, 0, w, h );
			StarUtil.drawStar( graphics, 25, 25, 5, 50, 50, 50 * 0.38, 50 * 0.38 );
			graphics.endFill();
		}
	}
}