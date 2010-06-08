package ws.tink.graphics
{
	public interface IGraphicsCreator
	{
		function moveTo( x:Number, y:Number ):void
		function lineTo( x:Number, y:Number ):void
		function curveTo( cx:Number, cy:Number, x:Number, y:Number ):void
		
	}
}