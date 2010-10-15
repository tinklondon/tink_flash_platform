////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2008 Tink Ltd | http://www.tink.ws
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

package ws.tink.mx.skins
{
	
	import mx.core.EdgeMetrics;
	import mx.core.UIComponent;
	import mx.skins.Border;
	
	public class BlankSkin extends Border
	{

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  Constructor.
		 */
		public function BlankSkin()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
	
		//----------------------------------
		//  borderMetrics
		//----------------------------------
	
		/**
		 *  @private
		 *  Storage for the borderMetrics property.
		 */
		private var _borderMetrics:EdgeMetrics = new EdgeMetrics(1, 1, 1, 1);
	
		/**
		 *  @private
		 */
		override public function get borderMetrics():EdgeMetrics
		{
			return _borderMetrics;
		}
	
		//----------------------------------
		//  measuredWidth
		//----------------------------------
		
		/**
		 *  @private
		 */
		override public function get measuredWidth():Number
		{
			return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
		}
		
		//----------------------------------
		//  measuredHeight
		//----------------------------------
	
		/**
		 *  @private
		 */
		override public function get measuredHeight():Number
		{
			return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
		}
		
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			var cornerRadius:Number = getStyle( "cornerRadius" );
			cornerRadius = Math.max( 0, cornerRadius );
			
			graphics.clear();
			graphics.beginFill( 0x000000, 0 );
			graphics.drawRoundRect( 0, 0, unscaledWidth, unscaledHeight, cornerRadius, cornerRadius );
			graphics.endFill();
		}
	}

}
