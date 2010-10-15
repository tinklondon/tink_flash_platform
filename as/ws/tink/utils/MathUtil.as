package ws.tink.utils
{
	public class MathUtil
	{
		public static function isEven( value : int ):Boolean
		{
			return ( value % 2 == 0 );
		}
		
		public static function degreesToRadians( value : Number ):Number
		{
			return value * ( Math.PI / 180 );
		}
	}
}