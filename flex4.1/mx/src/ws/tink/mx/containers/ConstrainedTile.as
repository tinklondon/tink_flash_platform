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

package ws.tink.mx.containers
{
	import flash.events.Event;
	
	import mx.core.Container;
	import mx.core.ScrollPolicy;
	
	import ws.tink.mx.containers.utilityClasses.ConstrainedTileLayout;

	[Style(name="verticalGap", type="Number", format="Length", inherit="no", defaultValue="8")]
	[Style(name="horizontalGap", type="Number", format="Length", inherit="no", defaultValue="8")]
	[Style(name="heightRatio", type="Number", format="Length", inherit="no", defaultValue="1")]
	
	[Style(name="optimumLayout", type="Boolean", enumeration="true,false", inherit="no", defaultValue="true")]
	
	[Style(name="horizontalAlign", type="String", enumeration="left,center,right", inherit="no")]
	[Style(name="verticalAlign", type="String", enumeration="bottom,middle,top", inherit="no")]
	
	[Style(name="fillContainer", type="Boolean", enumeration="true,false", inherit="no", defaultValue="true")]
	
	public class ConstrainedTile extends Container
	{
		
		protected var _layoutChanged			: Boolean;
		
		private var _unscaledWidth			: Number;
		private var _unscaledHeight			: Number;
		
		
		private var _layoutObject		: ConstrainedTileLayout = new ConstrainedTileLayout();
		
		
		public function ConstrainedTile()
		{
			super();
			
			_layoutObject.target = this;
			verticalScrollPolicy = ScrollPolicy.OFF;
			horizontalScrollPolicy = ScrollPolicy.OFF;
		}
		
		[Bindable("directionChanged")]
		[Inspectable(category="General", enumeration="vertical,horizontal", defaultValue="vertical")]
		public function get direction():String
		{
			return _layoutObject.direction;
		}
		public function set direction( value:String ):void
		{
			if( _layoutObject.direction == value ) return;
			
			_layoutObject.direction = value;
			
			_layoutChanged = true;
			
			invalidateSize();
			invalidateDisplayList();
			
			dispatchEvent( new Event( "directionChanged" ) );
		}
		
		override public function styleChanged( styleProp:String ):void
		{
			super.styleChanged( styleProp );
			
			var anyStyle:Boolean = styleProp == null || styleProp == "styleName";
			
			if( anyStyle )
			{
				_layoutChanged = true;
				invalidateDisplayList();
			}
			
			if(	styleProp == "heightRatio" || styleProp == "optimumLayout" || styleProp == "forceGaps" )
			{
				_layoutChanged = true;
				invalidateDisplayList();
			}
			
			if(	styleProp == "horizontalGap" || styleProp == "verticalGap" )
			{
				_layoutChanged = true;
				invalidateDisplayList();
			}
			
			if(	( styleProp == "horizontalAlign" || styleProp == "verticalAlign" ) && !getStyle( "fillContainer" ) )
			{
				_layoutChanged = true;
				invalidateDisplayList();
			}
		}
		
		
//		override public function setActualSize( w:Number, h:Number ):void
//		{
//			super.setActualSize( w, h );
//			
//			trace( "setActualSize", w, h );
//		}
		
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
//			trace( "setActualSize", unscaledWidth, unscaledHeight );
			if( _unscaledWidth != unscaledWidth || _unscaledHeight != unscaledHeight )
			{
				_unscaledWidth = unscaledWidth;
				_unscaledHeight = unscaledHeight;
				
				_layoutChanged = true;
			}
			
			if( _layoutChanged )
			{
				_layoutChanged = false;
				
				_layoutObject.updateDisplayList( _unscaledWidth, _unscaledHeight );
			}
		}
		
	}
}