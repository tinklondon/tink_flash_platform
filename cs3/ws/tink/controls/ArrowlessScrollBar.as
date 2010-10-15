/*
Copyright (c) 2008 Tink Ltd - http://www.tink.ws

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

package ws.tink.controls
{
	import fl.controls.ScrollBar;
	import fl.controls.ScrollBarDirection;
	import fl.core.InvalidationType;
	import fl.events.ComponentEvent;

	public class ArrowlessScrollBar extends ScrollBar
	{
		
		public function ArrowlessScrollBar()
		{
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			track.move( 0, 0 );
			
			upArrow.removeEventListener( ComponentEvent.BUTTON_DOWN, scrollPressHandler );
			downArrow.removeEventListener( ComponentEvent.BUTTON_DOWN, scrollPressHandler );
			removeChild( upArrow );
			removeChild( downArrow );
		}
		
		override protected function draw():void
		{	
			if( isInvalid( InvalidationType.SIZE ) )
			{
				var w:Number = super.width;
				var h:Number = super.height;
				downArrow.move(0,  Math.max(upArrow.height, h-downArrow.height));
				if( direction == ScrollBarDirection.VERTICAL )
				{
					track.setSize( ScrollBar.WIDTH, Math.max(0, h) );
				}
				else
				{
					track.setSize( ScrollBar.WIDTH, Math.max(0, w) );
				}
				updateThumb();
			}
			if( isInvalid(InvalidationType.STYLES,InvalidationType.STATE ) )
			{
				setStyles();
			}
			
			track.drawNow();
			thumb.drawNow();
			validate();
		}
		
		override protected function updateThumb():void
		{
			var per:Number = maxScrollPosition - minScrollPosition + pageSize;
			if (track.height <= 12 || maxScrollPosition <= minScrollPosition || (per == 0 || isNaN(per)))
			{
				thumb.height = 12;
				thumb.visible = false;
			}
			else
			{
				thumb.height = Math.max( 25, pageSize / per * track.height);
				thumb.y = track.y+(track.height-thumb.height)*((scrollPosition-minScrollPosition)/(maxScrollPosition-minScrollPosition));
				thumb.visible = enabled;
			}
		}
		
		
		
		
	}
}