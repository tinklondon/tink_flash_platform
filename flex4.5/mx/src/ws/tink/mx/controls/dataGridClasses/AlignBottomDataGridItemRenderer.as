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

package ws.tink.mx.controls.dataGridClasses
{
	import mx.controls.dataGridClasses.DataGridItemRenderer;

	public class AlignBottomDataGridItemRenderer extends DataGridItemRenderer
	{
		public function AlignBottomDataGridItemRenderer()
		{
			super();
		}
		
		override public function setActualSize( w:Number, h:Number ):void
		{
			super.setActualSize( w, h );
			
			if( listData )
    		{
	    		var lineHeight:int = int( textHeight / numLines );
	    		var numPossibleLines:int = int( h / lineHeight );
	    		if( numLines < numPossibleLines )
	    		{
	    			var pad:String = "";
	    			for( var i:int = numLines; i < numPossibleLines; i++ )
	    			{
	    				pad += "\n";
	    			}
	    			text = pad + listData.label;
	    		}
	    	}
		}
		
	}
}