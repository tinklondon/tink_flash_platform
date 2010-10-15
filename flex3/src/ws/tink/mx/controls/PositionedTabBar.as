////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2007 Tink Ltd | http://www.tink.ws
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

package ws.tink.mx.controls
{
	
	import mx.controls.TabBar;
	import mx.core.ClassFactory;
	import mx.core.IUIComponent;
	import mx.core.mx_internal;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	import ws.tink.mx.controls.positionedTabBarClasses.PositionedTab;
	
	use namespace mx_internal;
	
	
	[Style(name="position", type="String", enumeration="top,bottom,left,right", inherit="no")]
	
	[IconFile("PositionedTabBar.png")]
	
	public class PositionedTabBar extends TabBar
	{
		
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  Constructor.
	     */
		public function PositionedTabBar()
		{
			super();
			
			navItemFactory = new ClassFactory( PositionedTab );
		}
		
		
		override public function styleChanged( styleProp:String ):void
		{
			super.styleChanged( styleProp );
			
			if( !styleProp || styleProp == "position" )
			{
				var position:String = getStyle( "position" );
				direction = ( position == "left" || position == "right" ) ? "vertical" : "horizontal";
				
				var b:PositionedTab;
				for( var i:int = 0; i < numChildren; i++ )
				{
					b = PositionedTab( getChildAt( i ) );
					b.setStyle( "position", position );
				}
			}
		}
		
		
		//--------------------------------------------------------------------------
	    //
	    //  Setup default styles.
	    //
	    //--------------------------------------------------------------------------
	    
		private static var defaultStylesSet				: Boolean = setDefaultStyles();
		
		/**
	     *  @private
	     */
		private static function setDefaultStyles():Boolean
		{
			var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration( "PositionedTabBar" );

		    if( !style )
		    {
		        style = new CSSStyleDeclaration();
		        StyleManager.setStyleDeclaration( "PositionedTabBar", style, true );
		    }
		    
		    if( style.defaultFactory == null )
	        {
	        	style.defaultFactory = function():void
	            {
	            	this.position = "top";	
	            };
	        }

		    return true;
		}
	}
}