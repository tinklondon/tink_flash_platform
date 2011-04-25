////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2009 Tink Ltd | http://www.tink.ws
//	
//	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//	documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
//	the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//	to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//	
//	The above copyright notice and this permission notice shall be included in all copies or substantial portions
//	of the Software.
//	
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
//	THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
//	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

package ws.tink.mx.flash
{

	import flash.geom.ColorTransform;
	import mx.flash.UIMovieClip;

	public class UITintedMovieClip extends UIMovieClip
	{

		public function UITintedMovieClip()
		{
			super();
		}

			
		override public function initialize():void
    	{
			super.initialize();

			try
			{
				var color:Number = systemManager[ "application" ].getStyle( "skinTint" );

				if( !isNaN( color ) )
				{
					transform.colorTransform = new ColorTransform( 1, 1, 1, 1, ( color >> 16 ) & 0xFF, ( color >> 8 ) & 0xFF, color & 0xFF, 0 );
				}
			}
			catch( e:Error )
			{

			}
		}

	}
}