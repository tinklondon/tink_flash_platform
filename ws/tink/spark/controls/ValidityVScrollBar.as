/*

Copyright (c) 2010 Tink Ltd - http://www.tink.ws

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

package ws.tink.spark.controls
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.core.ILayoutElement;
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import spark.components.ButtonBar;
	import spark.components.IItemRenderer;
	import spark.components.List;
	import spark.components.VScrollBar;
	import spark.components.supportClasses.GroupBase;
	import spark.core.IViewport;
	import spark.events.IndexChangeEvent;
	import spark.layouts.VerticalLayout;
	
	public class ValidityVScrollBar extends VScrollBar
	{
		
		
		[SkinPart( required="true" )]
		public var errorsButtonBar		: ButtonBar;
		
		
		private var _numElements			: int = 0;
		private var _elements				: ArrayList = new ArrayList();
		private var _viewportHeight			: Number;
		private var _trackSize				: Number;
		
		public function ValidityVScrollBar()
		{
			super();
		}
		
		override protected function updateSkinDisplayList():void
		{
			super.updateSkinDisplayList();
			
			if( !errorsButtonBar || !track ) return;
			
			if( _trackSize != track.getLayoutBoundsHeight() )
			{
				_trackSize = track.getLayoutBoundsHeight();
				changed = true;
			}
			
			var changed:Boolean;
			var groupBase:GroupBase = GroupBase( viewport );
			
			if( _viewportHeight != groupBase.getPreferredBoundsHeight() )
			{
				_viewportHeight = groupBase.getPreferredBoundsHeight();
				changed = true;
			}
			
			if( _numElements != groupBase.numElements )
			{
				_numElements = groupBase.numElements;
				changed = true;	
			}
			
			if( changed )
			{
				var scale:Number = ( _viewportHeight ) ? _trackSize / _viewportHeight : 1;
				
				var elements:Array = new Array();;
				var element:ILayoutElement
				
				for( var i:int = 0; i < _numElements; i++ )
				{
					element = groupBase.getElementAt( i );
					elements.push( { element: element, scale: scale } );
				}

				_elements.source = elements;
				if( errorsButtonBar ) errorsButtonBar.dataProvider = _elements;
				
				VerticalLayout( errorsButtonBar.layout ).gap = ( groupBase.layout is VerticalLayout ) ? VerticalLayout( groupBase.layout ).gap * scale : 0;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == errorsButtonBar )
			{
				errorsButtonBar.addEventListener( IndexChangeEvent.CHANGE, onElementListChange, false, 0, true );
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved( partName, instance );
			
			if( instance == errorsButtonBar )
			{
				errorsButtonBar.removeEventListener( IndexChangeEvent.CHANGE, onElementListChange, false );
			}
		}
		
		private function onElementListChange(event:IndexChangeEvent):void
		{
			if( event.newIndex < 0 ) return;
			
			var renderer:IVisualElement = errorsButtonBar.dataGroup.getElementAt( event.newIndex );
			
			var mouseEvent:MouseEvent = new MouseEvent( MouseEvent.MOUSE_DOWN );
			mouseEvent.localX = 0;
			mouseEvent.localY = renderer.y + ( renderer.getLayoutBoundsHeight() / 2 );
			mouseEvent.shiftKey = getStyle( "smoothScrolling" );
			
			track.dispatchEvent( mouseEvent );
		}
		
	}
}


