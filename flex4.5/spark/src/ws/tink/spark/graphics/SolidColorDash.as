package ws.tink.spark.graphics
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.graphics.SolidColorStroke;
	
	import ws.tink.graphics.Dash;
	import ws.tink.graphics.IGraphicsCreator;
	
	public class SolidColorDash extends SolidColorStroke implements IGraphicsDefiner
	{
		
		private var _dashedLine:Dash;
		
		public function SolidColorDash( dash:Number = 5, gap:Number = 5, color:uint=0, weight:Number=1, alpha:Number=1.0, pixelHinting:Boolean=false, scaleMode:String="normal", caps:String="round", joints:String="round", miterLimit:Number=3 )
		{
			super( color, weight, alpha, pixelHinting, scaleMode, caps, joints, miterLimit );
			
			_dash = dash;
			_gap = gap;
			_dashedLine = new Dash();
		}
		
		public function get graphicsCreator():IGraphicsCreator
		{
			return _dashedLine;
		}
		
		private var _dash:Number;
		public function get dash():Number
		{
			return _dash;
		}
		public function set dash( value:Number ):void
		{
			_dash = value;
		}
		
		private var _gap:Number;
		public function get gap():Number
		{
			return _gap;
		}
		public function set gap( value:Number ):void
		{
			_gap = value;
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function apply( graphics:Graphics, targetBounds:Rectangle, targetOrigin:Point ):void
		{
			super.apply( graphics, targetBounds, targetOrigin );
			
			_dashedLine.graphics = graphics;
			_dashedLine.dash = _dash;
			_dashedLine.gap = _gap;
		}
	}
}