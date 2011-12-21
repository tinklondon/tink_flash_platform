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

package ws.tink.mx.containers.utilityClasses
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import mx.core.Container;
	import mx.core.EdgeMetrics;
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.core.mx_internal;
	import mx.styles.IStyleClient;
	
	import ws.tink.mx.core.IDockedComponent;

	use namespace mx_internal;
	
	public class DockerLayout
	{
		private var _viewMetrics	: EdgeMetrics;
		private var _children		: Array = new Array();
		private var _container		: Container;
		
		public function DockerLayout( container:Container )
		{
			_container = container;
		}
		
		private function getChildIndex( child:IUIComponent ):int
		{
			var numItems:int = _children.length;
			for( var i:int = 0; i < numItems; i++ )
			{
				if( _children[ i ] == child ) return i;
			}
			
			return -1;
		}
		
		public function set enabled(value:Boolean):void
		{
			var numItems:int = _children.length;
			for( var i:int = 0; i < numItems; i++ )
			{
				IUIComponent( _children[ i ] ).enabled = value;
			}
		}
		
		public function contains( child:IUIComponent ):Boolean
		{
			return getChildIndex( child ) >= 0;
		}
		
		public function get children():Array
		{
			return _children.concat();
		}
		
		public function getEdgeMetrics( unscaledWidth:Number, unscaledHeight:Number ):Rectangle
		{
			var controlRect:Rectangle = new Rectangle( 0, 0, unscaledWidth, unscaledHeight );
			
			if( _children.length )
			{
				var child:IUIComponent;
				var numItems:int = _children.length;
				for( var i:int = 0; i < numItems; i++ )
				{
					child = IUIComponent( _children[ i ] );
					if( child.includeInLayout )
					{
						if( child is IDockedComponent )
						{
							
							switch( IDockedComponent( child ).dockPosition )
							{
								case DockPosition.BOTTOM :
								{
									controlRect.bottom -= child.getExplicitOrMeasuredHeight();
									break;
								}
								case DockPosition.LEFT :
								{
									controlRect.left += child.getExplicitOrMeasuredWidth();
									break;
								}
								case DockPosition.RIGHT :
								{
									controlRect.right -= child.getExplicitOrMeasuredWidth();
									break;
								}
								case DockPosition.TOP :
								{
									controlRect.top += child.getExplicitOrMeasuredHeight();
									break;
								}
							}
						}
					}
				}
			}
			
			return controlRect;
		}
		
		private function setDocked( child:IDockedComponent, asControl:Boolean ):void
		{
			//			if (child == child)
			//				return;
			
			var isInArray:int = getChildIndex( child );
			
			if( !asControl )
			{
				if( child && child is IStyleClient )
				{
					IStyleClient(child).clearStyle( "cornerRadius" );
					IStyleClient(child).clearStyle( "docked" );
				}
				
				if( isInArray != -1 ) _children.splice( isInArray, 1 );
			}
			else
			{
				//			child = child;
				if( !child.visible ) child.visible = true;
				if( child && child is IStyleClient )
				{
					IStyleClient( child ).setStyle( "cornerRadius", 0 );
					IStyleClient( child ).setStyle( "docked", true );
				}
				
				if( isInArray == -1 ) _children.push( child );
			}
			
			_container.invalidateSize();
			_container.invalidateDisplayList();
			_container.invalidateViewMetricsAndPadding();
		}
		
		/**
		 *  @private
		 */
		public function dock( child:IDockedComponent, dock:Boolean):void
		{
			if( dock )
			{
				try
				{
					_container.removeChild( DisplayObject( child ) );
				}
				catch( e:Error )
				{
					return;
				}
				
				_container.rawChildren.addChildAt( DisplayObject( child ), _container.firstChildIndex );
				setDocked( child, true );
			}
			else // undock
			{
				try
				{
					_container.rawChildren.removeChild( DisplayObject( child ) );
				}
				catch(e:Error)
				{
					return;
				}
				
				setDocked( child, false );
				_container.addChildAt( DisplayObject( child ), 0 );
			}
		}
		
		public function layoutChrome( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			if( _children.length )
			{
				var r:Rectangle = new Rectangle( 0, 0, 0, 0 );
				
				var child:IDockedComponent;
				var numItems:int = _children.length;
				for( var i:int = 0; i < numItems; i++ )
				{
					child = IDockedComponent( _children[ i ] );
					
					if( child is IInvalidating ) IInvalidating( child ).invalidateDisplayList();
					
					switch( child.dockPosition )
					{
						case DockPosition.BOTTOM :
						{
							child.setActualSize(_container.width - (r.left + r.right),child.getExplicitOrMeasuredHeight() );
							child.move(r.left, unscaledHeight - r.bottom - child.getExplicitOrMeasuredHeight() );
							
							r.bottom += child.getExplicitOrMeasuredHeight();
							break;
						}
						case DockPosition.LEFT :
						{
							child.setActualSize(child.getExplicitOrMeasuredWidth(), _container.height - (r.top + r.bottom ) );
							child.move(r.left, r.top );
							
							r.left += child.getExplicitOrMeasuredWidth();
							break;
						}
						case DockPosition.RIGHT :
						{
							child.setActualSize(child.getExplicitOrMeasuredWidth(), _container.height - (r.top + r.bottom));
							child.move(unscaledWidth - r.right - child.getExplicitOrMeasuredWidth(), r.top );
							
							r.right += child.getExplicitOrMeasuredWidth();
							break;
						}
						case DockPosition.TOP :
						{
							child.setActualSize(_container.width - (r.left + r.right),child.getExplicitOrMeasuredHeight());
							child.move(r.left, r.top );
							
							r.top += child.getExplicitOrMeasuredHeight();
							break;
						}
					}
				}
			}
		}
	}
}