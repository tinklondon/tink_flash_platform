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