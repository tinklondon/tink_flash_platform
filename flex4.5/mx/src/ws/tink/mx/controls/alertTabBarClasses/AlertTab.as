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

package ws.tink.mx.controls.alertTabBarClasses
{
	import mx.controls.ButtonPhase;
	import mx.core.mx_internal;
	
	import ws.tink.mx.controls.positionedTabBarClasses.PositionedTab;
	
	use namespace mx_internal;

	[Style(name="alerted", type="Boolean", enumeration="true,false", inherit="no")]
	
	public class AlertTab extends PositionedTab
	{
		
		
		private var _color								: Number;
		private var _textRollOverColor					: Number;
		
		
		override public function styleChanged( styleProp:String ):void
		{
			super.styleChanged( styleProp );
			
			if( !styleProp || styleProp == "alerted" )
			{
				var alerted:Boolean = getStyle( "alerted" );
			
				if( selected && alerted ) setStyle( "alerted", false );
			}
		}
		
		override public function set selected(value:Boolean):void
	    {
	        super.selected = value;
	        
	        if( value ) setStyle( "alerted", false );
	    }
    
		override mx_internal function viewSkinForPhase( tempSkinName:String, stateName:String ):void
    	{
    		super.mx_internal::viewSkinForPhase( tempSkinName, stateName );
    		
			var labelColor:Number;
	
	        if( enabled )
	        {
	        	var alerted:Boolean = getStyle( "alerted" );
	        	
	            if( phase == ButtonPhase.OVER )
	            {
	                labelColor = ( alerted ) ? textField.getStyle( "alertedTextRollOverColor" ) : textField.getStyle( "textRollOverColor" );
	            }
	            else if( phase == ButtonPhase.DOWN )
	            {
	                labelColor = textField.getStyle( "textSelectedColor" );
	            }
	            else
	            {
	                labelColor = ( alerted ) ? textField.getStyle( "alertedColor" ) : textField.getStyle( "color" );
	            }
	
	            textField.setColor(labelColor);
	        }
	    }
	    
	}
}