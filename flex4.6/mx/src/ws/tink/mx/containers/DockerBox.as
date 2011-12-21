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
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import mx.containers.Box;
	import mx.core.EdgeMetrics;
	import mx.core.IUIComponent;
	import mx.core.mx_internal;
	
	import ws.tink.mx.containers.utilityClasses.DockerLayout;
	import ws.tink.mx.core.IDockedComponent;
	import ws.tink.mx.core.IDockerContainer;
	
	use namespace mx_internal;
	
	public class DockerBox extends Box implements IDockerContainer
	{
		
		private var _viewMetrics	: EdgeMetrics;
		private var _dockedLayout	: DockerLayout;
		
		public function DockerBox()
		{
			_dockedLayout = new DockerLayout( this );
			
			super();
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			_dockedLayout.enabled = value;
		}
		
		override public function get viewMetrics():EdgeMetrics
		{
			if( ! _viewMetrics ) _viewMetrics = new EdgeMetrics();
			
			var o:EdgeMetrics = super.viewMetrics;
			
			_viewMetrics.left = o.left;
			_viewMetrics.top = o.top;
			_viewMetrics.right = o.right;
			_viewMetrics.bottom = o.bottom;
			
			var thickness:Number = getStyle("borderThickness");
			var dockedRect:Rectangle = _dockedLayout.getEdgeMetrics( unscaledWidth, unscaledHeight );
			
			_viewMetrics.top -= thickness;
			_viewMetrics.top += Math.max(dockedRect.top, thickness);
			
			_viewMetrics.bottom -= thickness;
			_viewMetrics.bottom += Math.max(unscaledHeight - dockedRect.bottom, thickness);
			
			_viewMetrics.left -= thickness;
			_viewMetrics.left += Math.max(dockedRect.left, thickness);
			
			_viewMetrics.right -= thickness;
			_viewMetrics.right += Math.max(unscaledWidth - dockedRect.right, thickness);
			
			return _viewMetrics;
		}
		
		override public function getChildIndex( child:DisplayObject ):int
		{
			if( _dockedLayout.contains( IUIComponent( child ) ) ) return -1;
			return super.getChildIndex(child);
		}
		
		public function dock( child:IDockedComponent, dock:Boolean):void
		{
			_dockedLayout.dock( child, dock );
		}
		
		override protected function layoutChrome( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.layoutChrome( unscaledWidth, unscaledHeight );
			
			_dockedLayout.layoutChrome( unscaledWidth, unscaledHeight );
		}
	}
}