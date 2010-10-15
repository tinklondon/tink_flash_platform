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
	import mx.core.IBorder;
	
	/**
	 *  The Border class is an abstract base class for various classes that
	 *  draw borders, either rectangular or non-rectangular, around UIComponents.
	 *  This class does not do any actual drawing itself.
	 *
	 *  <p>If you create a new non-rectangular border class, you should extend
	 *  this class.
	 *  If you create a new rectangular border class, you should extend the
	 *  abstract subclass RectangularBorder.</p>
	 *
	 *  @tiptext
	 *  @helpid 3321
	 */
	public class SpriteBorder extends SpriteProgrammaticSkin implements IBorder
	{
	
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		/**
		 *  Constructor.
		 */
		public function SpriteBorder()
		{
			super();
		}
	
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
	
		//----------------------------------
		//  borderMetrics
		//----------------------------------
	
		/**
		 *  The thickness of the border edges.
		 *
		 *  @return EdgeMetrics with left, top, right, bottom thickness in pixels
		 */
		public function get borderMetrics():EdgeMetrics
		{
			return EdgeMetrics.EMPTY;
		}
	}

}
