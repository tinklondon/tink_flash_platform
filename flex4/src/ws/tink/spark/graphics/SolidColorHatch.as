package ws.tink.spark.graphics
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.graphics.SolidColorStroke;
	
	import ws.tink.graphics.Dash;
	import ws.tink.graphics.Hatch;
	import ws.tink.graphics.IGraphicsCreator;
	
	public class SolidColorHatch extends SolidColorStroke implements IGraphicsDefiner
	{
		
		private var _hatchedLine:Hatch;
		
		public function SolidColorHatch( hatchLength:Number = 5, gap:Number = 5, angle:Number = 45, color:uint=0, weight:Number=1, alpha:Number=1.0, pixelHinting:Boolean=false, scaleMode:String="normal", caps:String="round", joints:String="round", miterLimit:Number=3, drawOverFlow:Boolean = false )
		{
			super( color, weight, alpha, pixelHinting, scaleMode, caps, joints, miterLimit );
			
			_hatchLength = hatchLength;
			_gap = gap;
			_angle = angle;
			_drawOverFlow = drawOverFlow
			_hatchedLine = new Hatch();
		}
		
		public function get graphicsCreator():IGraphicsCreator
		{
			return _hatchedLine;
		}
		
		private var _hatchLength:Number;
		public function get hatchLength():Number
		{
			return _hatchLength;
		}
		public function set hatchLength( value:Number ):void
		{
			_hatchLength = value;
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
		
		private var _angle:Number;
		public function get angle():Number
		{
			return _angle;
		}
		public function set angle( value:Number ):void
		{
			_angle = value;
		}
		
		private var _drawOverFlow:Boolean;
		public function get drawOverFlow():Boolean
		{
			return _drawOverFlow;
		}
		public function set drawOverFlow( value:Boolean ):void
		{
			_drawOverFlow = value;
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
			
			_hatchedLine.graphics = graphics;
			_hatchedLine.hatchLength = _hatchLength;
			_hatchedLine.gap = _gap;
			_hatchedLine.angle = _angle;
			_hatchedLine.drawOverFlow = _drawOverFlow;
		}
	}
}