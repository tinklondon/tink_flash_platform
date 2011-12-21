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
	
	/**
	 *  The colors to use for the gradient fill of the items in the ratings bar. 
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="colors", type="Array", arrayType="uint", format="Color", inherit="yes", theme="spark, mobile")]
	
	/**
	 *  The alpha of the border for this component.
	 *
	 *  @default 1.0
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="padding", type="Number", inherit="no", theme="spark, mobile", minValue="0.0")]
	
	/**
	 *  The colors to use for the gradient fill of the selected items in the ratings bar. 
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="selectionColors", type="Array", arrayType="uint", format="Color", inherit="yes", theme="spark, mobile")]
	
	
	
	public class RatingsBarItemRenderer extends ItemRenderer
	{
		public function RatingsBarItemRenderer()
		{
			super();
			
			percentWidth = percentHeight = 100;
			autoDrawBackground = true;
		}
		
		override protected function measure():void
		{
			super.measure();
			measuredWidth = measuredHeight = 50;
			measuredMinWidth = measuredMinHeight = 10;
		}
		
		
		override mx_internal function drawBackground():void
		{
			// Stop super.drawBackground() from drawing.
			autoDrawBackground = false;
			super.drawBackground();
			
			autoDrawBackground = true;
			
			// TODO (rfrishbe): Would be good to remove this duplicate code with the 
			// super.drawBackground() version
			const w:Number = ( resizeMode == ResizeMode.SCALE ) ? measuredWidth : unscaledWidth;
			const h:Number = ( resizeMode == ResizeMode.SCALE ) ? measuredHeight : unscaledHeight;
			
			if( isNaN( w ) || isNaN( h ) ) return;
			
			var s:Number = w < h ? w : h;
			const padding:Number = getStyle( "padding" );
			if( !isNaN( padding ) && s - padding >= measuredMinWidth ) s -= padding;
			
			graphics.clear();
			
			var colors:Array;
			if( selected )
			{
				colors = getStyle("selectionColors");
			}
			else
			{
				colors = getStyle("colors");
			}
			
			if( colors.length )
			{
				const matrix:Matrix = new Matrix();
				matrix.createGradientBox( s, s, 0, ( w - s ) / 2, ( h - s ) / 2 );

				const alphas:Array = new Array();
				const ratios:Array = new Array();
				const numColors:int = colors.length;
				for( var i:int = 0; i < numColors; i++ )
				{
					alphas.push( 1 );
					ratios.push( i * ( 255 / ( numColors - 1 ) ) );
				}
				graphics.beginGradientFill( GradientType.RADIAL, colors, alphas, ratios, matrix );
			}
			
			graphics.lineStyle( 1, 0x666666, 1, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER );
			StarUtil.drawStar( graphics, w / 2, h / 2, 5, s, s, s * 0.38, s * 0.38 );
			graphics.endFill();
		}
	}
}