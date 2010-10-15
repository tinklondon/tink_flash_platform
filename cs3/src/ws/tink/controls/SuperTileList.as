package ws.tink.controls
{
	
	import fl.controls.ScrollBar;
	import fl.controls.ScrollBarDirection;
	import fl.controls.ScrollPolicy;
	import fl.controls.TileList;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.controls.listClasses.TileListData;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	[Style(name="horizontalGap", type="Number", format="Length")]
	[Style(name="verticalGap", type="Number", format="Length")]
	[Style(name="rendererDirection", type="String", enumeration="horizontal,vertical", defaultValue="horizontal")]
	[Style(name="scrollBarScale", type="Number", format="Length")]
	[Style(name="easing", type="Number", format="Length")]
	public class SuperTileList extends TileList
	{
		
		
		private static var defaultStyles:Object = { horizontalGap: 0, verticalGap: 0, rendererDirection: "horizontal", scrollBarScale: 1, easing: 0 };
																				
		public static function getStyleDefinition():Object
		{ 
			return mergeStyles( defaultStyles, TileList.getStyleDefinition() );
		}
		
		
		protected var _targetHorizontalScrollPosition	: Number = 0;
		protected var _targetVerticalScrollPosition		: Number = 0;
		
		protected var _horizontalEaseRunning			:Boolean = false;
		protected var _verticalEaseRunning				:Boolean = false;
		
		protected var _fireHorizontalScrollEvent		:Boolean = false;
		protected var _fireVerticalScrollEvent			:Boolean = false;
		
		public function SuperTileList()
		{
			super();
			
			_horizontalScrollPosition = 0;
		}
		
		protected function onHorizontalScrollEase( event:Event ):void
		{
			var delta : Number = _targetHorizontalScrollPosition - _horizontalScrollPosition;
			
			if( Math.abs( delta ) < 1 )
			{
				removeEventListener( Event.ENTER_FRAME, onHorizontalScrollEase );
				_horizontalEaseRunning = false;
				super.setHorizontalScrollPosition( _targetHorizontalScrollPosition, _fireHorizontalScrollEvent );
			}
			else
			{
				delta = delta * Number( getStyle( "easing" ) );
				super.setHorizontalScrollPosition( _horizontalScrollPosition + delta, _fireHorizontalScrollEvent );
			}
		}
		
		protected function onVerticalScrollEase( event:Event ):void
		{
			var delta : Number = _targetVerticalScrollPosition - _verticalScrollPosition;
			
			if( Math.abs( delta ) < 1 )
			{
				removeEventListener( Event.ENTER_FRAME, onVerticalScrollEase );
				_verticalEaseRunning = false;
				super.setVerticalScrollPosition( _targetVerticalScrollPosition, _fireVerticalScrollEvent );
			}
			else
			{
				delta = delta * Number( getStyle( "easing" ) );
				super.setVerticalScrollPosition( _verticalScrollPosition + delta, _fireVerticalScrollEvent );
			}
		}
		
		override protected function setHorizontalScrollPosition( scroll:Number, fireEvent:Boolean = false ):void
		{
			if( scroll == _horizontalScrollPosition ) return;
			
			_fireHorizontalScrollEvent = fireEvent;
			
			var easing:Number = Number( getStyle( "easing" ) );
			
			if( easing && easing != isNaN( easing ) )
			{
				_targetHorizontalScrollPosition = scroll;
				
				if( !_horizontalEaseRunning )
				{
					_horizontalEaseRunning = true;
					addEventListener( Event.ENTER_FRAME, onHorizontalScrollEase, false, 0, true );
				}
			}
			else
			{
				super.setHorizontalScrollPosition( scroll, true );
			}
		}
		
		override protected function setVerticalScrollPosition( scroll:Number, fireEvent:Boolean = false ):void
		{
			if( scroll == _verticalScrollPosition ) return;
			
			var easing:Number = Number( getStyle( "easing" ) );
			
			_fireVerticalScrollEvent = fireEvent;
			
			if( easing && easing != isNaN( easing ) )
			{
				_targetVerticalScrollPosition = scroll;
				
				if( !_verticalEaseRunning )
				{
					_verticalEaseRunning = true;
					addEventListener( Event.ENTER_FRAME, onVerticalScrollEase, false, 0, true );
				}
			}
			else
			{
				super.setVerticalScrollPosition( scroll, true );
			}
		}
		
		override protected function draw():void
		{
			if( vScrollBar && _verticalScrollBar.scaleY != getStyleValue( "scrollBarScale" ) )
			{
				invalidate( InvalidationType.SIZE, false );
			}
			
			if( hScrollBar && _horizontalScrollBar.scaleX != getStyleValue( "scrollBarScale" ) )
			{
				invalidate( InvalidationType.SIZE, false );
			}
			
			super.draw();
		}
		
		override protected function drawLayout():void
		{
			var horizontalGap:Number = Number( getStyleValue( "horizontalGap" ) );
			var verticalGap:Number = Number( getStyleValue( "verticalGap" ) );
			
			// figure out our scrolling situation:
			_horizontalScrollPolicy = ( _scrollDirection == ScrollBarDirection.HORIZONTAL ) ? _scrollPolicy : ScrollPolicy.OFF;
			_verticalScrollPolicy = ( _scrollDirection != ScrollBarDirection.HORIZONTAL ) ? _scrollPolicy : ScrollPolicy.OFF;
			if( _scrollDirection == ScrollBarDirection.HORIZONTAL )
			{
				var rows:uint = rowCount;
				contentHeight = ( rows * ( _rowHeight + verticalGap ) ) - verticalGap;
				contentWidth = ( ( _columnWidth + horizontalGap ) * Math.ceil( length / rows ) ) - horizontalGap;
			}
			else
			{
				var cols:uint = columnCount;
				contentWidth = ( cols * ( _columnWidth + horizontalGap ) ) - horizontalGap;
				contentHeight = ( ( _rowHeight + verticalGap ) * Math.ceil( length / cols ) ) - verticalGap;
			}
			
			calculateAvailableSize();
			calculateContentWidth();
			
			background.width = width;
			background.height = height;
			
			var scrollBarScale:Number = Number( getStyleValue( "scrollBarScale" ) );
			
			if( vScrollBar )
			{
				_verticalScrollBar.visible = true;
				_verticalScrollBar.x = width - ScrollBar.WIDTH - contentPadding;
				_verticalScrollBar.y = contentPadding + ( ( availableHeight - ( availableHeight * scrollBarScale )  ) / 2 );
				_verticalScrollBar.height = availableHeight * scrollBarScale;
			}
			else
			{
				_verticalScrollBar.visible = false;
			}
			
			_verticalScrollBar.setScrollProperties( availableHeight, 0, contentHeight - availableHeight, verticalPageScrollSize );
			setVerticalScrollPosition( _verticalScrollBar.scrollPosition, false);
			
			if( hScrollBar )
			{
				_horizontalScrollBar.visible = true;
				_horizontalScrollBar.x = contentPadding + ( ( availableWidth - ( availableWidth * scrollBarScale )  ) / 2 );
				_horizontalScrollBar.y = height - ScrollBar.WIDTH - contentPadding;
				_horizontalScrollBar.width = availableWidth * scrollBarScale;
			}
			else
			{
				_horizontalScrollBar.visible = false;
			}
			
			_horizontalScrollBar.setScrollProperties( availableWidth, 0, ( useFixedHorizontalScrolling ) ? _maxHorizontalScrollPosition : contentWidth - availableWidth, horizontalPageScrollSize );
			setHorizontalScrollPosition( _horizontalScrollBar.scrollPosition, false );
			
			drawDisabledOverlay();
			
			contentScrollRect = listHolder.scrollRect;
			contentScrollRect.width = availableWidth;
			contentScrollRect.height = availableHeight;
			listHolder.scrollRect = contentScrollRect;
		}
		
		
		
		
		
		
		
		override protected function drawList():void
		{
			// these vars get reused in different loops:
			var i:uint;
			var itemIndex:uint;
			var item:Object;
			var renderer:ICellRenderer;
			var startIndex:uint;
			var endIndex:uint;
			var rows:uint = rowCount;
			var cols:uint = columnCount;
			
			var baseCol:Number = 0;
			var baseRow:Number = 0;
			var col:uint;
			var row:uint;
			var horizontalGap:Number = Number( getStyleValue( "horizontalGap" ) );
			var verticalGap:Number = Number( getStyleValue( "verticalGap" ) );
			var rendererDirection:String = getStyleValue( "rendererDirection" ).toString();

			var colW:Number = columnWidth + horizontalGap;
			var rowH:Number = rowHeight + verticalGap;
			
			listHolder.x = listHolder.y = contentPadding;
			
			// set horizontal scroll:
			contentScrollRect = listHolder.scrollRect;
			contentScrollRect.x = Math.floor( _horizontalScrollPosition ) % colW;
			
			// set pixel scroll:
			contentScrollRect.y = Math.floor( _verticalScrollPosition ) % rowH;
			listHolder.scrollRect = contentScrollRect;
			
			listHolder.cacheAsBitmap = useBitmapScrolling;
			
			// figure out what we have to render, and where:
			var items:Array = [];
			if( _scrollDirection == ScrollBarDirection.HORIZONTAL )
			{
				// horizontal scrolling is trickier if we want to keep tiles going left to right, then top to bottom.
				// we can use availableWidth / availableHeight from BaseScrollPane here, because we've just called drawLayout, so we know they are accurate.
				var fullCols:uint = availableWidth / colW << 0;
				var rowLength:uint = Math.max( fullCols, Math.ceil( length / rows ) );
				baseCol = _horizontalScrollPosition / colW << 0;
				cols = Math.max( fullCols, Math.min( rowLength - baseCol, cols + 1 ) );//(horizontalScrollBar.visible ? 1 : -1))); // need to draw an extra two cols for scrolling.
				
				switch( rendererDirection )
				{
					case "vertical" :
					{
						startIndex = Math.floor( baseCol * rows );
						endIndex = Math.min( length, startIndex + rows * cols );
						for( i = startIndex; i < endIndex; i++ )
						{
							items.push( i );
						}
						break;
					}
					case "horizontal" :
					default :
					{
						rowLength = Math.max( cols-( horizontalScrollBar.visible ? -1 : 0 ), rowLength );
						for( row = 0; row < rows; row++ )
						{
							for( col=0; col < cols; col++ )
							{
								itemIndex = row * rowLength + baseCol+col;
								if( itemIndex >= length ) { break; }
								items.push( itemIndex );
							}
						}
						break;
					}
				}
			}
			else
			{
				var fullRows:uint = availableHeight / rowH << 0;
				var colWidth:uint = Math.max( fullRows, Math.ceil( length / cols ) );
				baseRow = _verticalScrollPosition / rowH << 0;
				rows = Math.max( fullRows, Math.min( colWidth - baseRow, rows + 1 ) );
					
				switch( rendererDirection )
				{
					case "vertical" :
					{
						colWidth = Math.max( rows - ( verticalScrollBar.visible ? -1 : 0 ), colWidth );
						for( col = 0; col < cols; col++ )
						{
							for( row = 0; row < rows; row++ )
							{
								itemIndex = col * colWidth + baseRow + row;
								if( itemIndex >= length ) { break; }
								items.push( itemIndex );
							}
						}
						break;
					}
					case "horizontal" :
					default :
					{
						rows++; // need to draw an extra row for scrolling.
						baseRow = _verticalScrollPosition / rowH << 0;
						startIndex = Math.floor( baseRow * cols );
						endIndex = Math.min( length, startIndex + rows * cols );
						for( i = startIndex; i < endIndex; i++ )
						{
							items.push( i );
						}
					}
				}
			}

			// create a dictionary for looking up the new "displayed" items:
			var itemHash:Dictionary = renderedItems = new Dictionary(true);
			for each( itemIndex in items )
			{
				itemHash[ _dataProvider.getItemAt( itemIndex ) ] = true;
			}

			// find cell renderers that are still active, and make those that aren't active available:
			var itemToRendererHash:Dictionary = new Dictionary( true );
			while( activeCellRenderers.length > 0 )
			{
				renderer = activeCellRenderers.pop();
				item = renderer.data;
				if( itemHash[ item ] == null || invalidItems[ item ] == true )
				{
					availableCellRenderers.push( renderer );
				}
				else
				{
					itemToRendererHash[ item ] = renderer;
					// prevent problems with duplicate objects:
					invalidItems[ item ] = true;
				}
				list.removeChild( renderer as DisplayObject );
			}
			invalidItems = new Dictionary( true );

			i = 0; // count of items placed.
			// draw cell renderers:
			for each( itemIndex in items )
			{
				if( rendererDirection == "horizontal" )
				{
					col = i % cols;
					row = i / cols << 0;
				}
				else
				{
					col = i / rows << 0;
					row = i % rows;
				}

				var reused:Boolean = false;
				item = _dataProvider.getItemAt( itemIndex );
				if( itemToRendererHash[ item ] != null )
				{
					// existing renderer for this item we can reuse:
					reused = true;
					renderer = itemToRendererHash[ item ];
					delete( itemToRendererHash[ item ] );
				}
				else if( availableCellRenderers.length > 0 )
				{
					// recycle an old renderer:
					renderer = availableCellRenderers.pop() as ICellRenderer;
				}
				else
				{
					// out of renderers, create a new one:
					renderer = getDisplayObjectInstance( getStyleValue( "cellRenderer" ) ) as ICellRenderer;
					var rendererSprite:Sprite = renderer as Sprite;
					if( rendererSprite != null )
					{
						rendererSprite.addEventListener( MouseEvent.CLICK, handleCellRendererClick, false, 0, true );
						rendererSprite.addEventListener( MouseEvent.ROLL_OVER, handleCellRendererMouseEvent, false, 0, true );
						rendererSprite.addEventListener( MouseEvent.ROLL_OUT, handleCellRendererMouseEvent, false, 0, true );
						rendererSprite.addEventListener( Event.CHANGE, handleCellRendererChange, false, 0, true );
						rendererSprite.doubleClickEnabled = true;
						rendererSprite.addEventListener( MouseEvent.DOUBLE_CLICK, handleCellRendererDoubleClick, false, 0, true );
						
						if( rendererSprite[ "setStyle" ] != null )
						{
							for( var n:String in rendererStyles )
							{
								rendererSprite[ "setStyle" ]( n, rendererStyles[ n ] );
							}
						}
					}
				}
				list.addChild( renderer as Sprite );
				activeCellRenderers.push( renderer );

				renderer.y = ( rowH ) * row;
				renderer.x = ( colW ) * col;
				renderer.setSize( columnWidth, rowHeight );
				

				var label:String = itemToLabel( item );
				
				var icon:Object = null;
				if( _iconFunction != null )
				{
					icon = _iconFunction( item );
				}
				else if( _iconField != null )
				{
					icon = item[ _iconField ];
				}
				
				var source:Object = null;
				if( _sourceFunction != null )
				{
					source = _sourceFunction( item );	
				}
				else if( _sourceField != null )
				{
					source = item[ _sourceField ];
				}

				if( !reused ) renderer.data = item;
				
				renderer.listData = new TileListData( label, icon, source, this, itemIndex, baseRow+row, baseCol + col ) as ListData;

				renderer.selected = ( _selectedIndices.indexOf( itemIndex ) != -1 );

				// force an immediate draw (because render event will not be called on the renderer):
				if( renderer is UIComponent )
				{
					var rendererUIC:UIComponent = renderer as UIComponent;
					rendererUIC.drawNow();
				}
				i++;
			}
		}
	}
}