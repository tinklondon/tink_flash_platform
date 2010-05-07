package ws.tink.spark.controls
{
	
	import flash.events.KeyboardEvent;
	
	import mx.core.mx_internal;
	
	import spark.components.List;
	import spark.core.NavigationUnit;
	import spark.events.IndexChangeEvent;
	
	use namespace mx_internal;
	
	public class SelectableExclusionList extends List
	{
		
		private var _excludeChanged:Boolean;
		
		public function SelectableExclusionList()
		{
			super();
		}
		
		private var _excludeTypes	: Array;
		public function get exludeTypes():Array
		{
			return _excludeTypes;
		}
		public function set exludeTypes( value:Array ):void
		{
			if( _excludeTypes == value ) return;
			
			_excludeType = null;
			_excludeTypes = value;
			if( _excludeTypes )
			{
				_excludeChanged = true;
				invalidateProperties();
			}
		}
		
		private var _excludeType	: Class;
		public function get exludeType():Class
		{
			return _excludeType;
		}
		public function set exludeType( value:Class ):void
		{
			if( _excludeType == value ) return;
			
			_excludeTypes = null;
			_excludeType = value;
			if( _excludeType )
			{
				_excludeChanged = true;
				invalidateProperties();
			}
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if( _excludeChanged )
			{
				if( _excludeType )
				{
					if( selectedIndex != -1 ) if( dataProvider.getItemAt( selectedIndex ) is _excludeType ) selectedIndex = -1;
				}
				else if( _excludeTypes )
				{
					if( selectedIndices )
					{
						if( selectedIndices.length ) setSelectedIndices( selectedIndices );
					}
				}
			}
		}
		
		
		/**
		 * Override the setSelectedIndex() mx_internal method to not select an item that
		 * has selectionEnabled=false.
		 */
		override mx_internal function setSelectedIndex(value:int, dispatchChangeEvent:Boolean = false):void
		{
			if( _excludeType )
			{
				if( value == selectedIndex ) return;
	
				if( value >= 0 && value < dataProvider.length )
				{
					if( dataProvider.getItemAt( value ) is _excludeType ) return;
				}
			}
			else if( _excludeTypes )
			{
				if( value >= 0 && value < dataProvider.length )
				{
					var item:Object = dataProvider.getItemAt( value );
					for each( var c:Class in _excludeTypes )
					{
						if( item is c ) return;
					}
					
				}
			}
			
			super.setSelectedIndex( value, dispatchChangeEvent );
		}
		
		/**
		 * Override the setSelectedIndex() mx_internal method to not select an item that
		 * has selectionEnabled=false.
		 */
		override mx_internal function setSelectedIndices( value:Vector.<int>, dispatchChangeEvent:Boolean = false ):void
		{
			var newValue:Vector.<int>;
			var item:Object;
			var i:int;
			if( _excludeType )
			{
				newValue = new Vector.<int>();
				
				for( i = 0; i < value.length; i++)
				{
					item = dataProvider.getItemAt( value[ i ] );
					if( item is _excludeType ) continue;
					
					newValue.push( item );
				}
			}
			else if( _excludeTypes )
			{
				newValue = new Vector.<int>();
				var excluded:Boolean;
				for( i = 0; i < value.length; i++)
				{
					excluded = false;
					item = dataProvider.getItemAt( value[ i ] );
					for each( var c:Class in _excludeTypes )
					{
						if( item is c ) excluded = true;
					}
					
					if( !excluded ) newValue.push( item );
				}
			}
			else
			{
				newValue = value;
			}
			
			super.setSelectedIndices( newValue, dispatchChangeEvent );
		}
		
		override protected function adjustSelectionAndCaretUponNavigation( event:KeyboardEvent ):void
		{
			// Some unrecognized key stroke was entered, return. 
			var navigationUnit:uint = event.keyCode;    
			if (!NavigationUnit.isNavigationUnit(event.keyCode))
				return; 
			
			var c:Number = caretIndex;
			// Delegate to the layout to tell us what the next item is we should select or focus into.
			// TODO (dsubrama): At some point we should refactor this so we don't depend on layout
			// for keyboard handling. If layout doesn't exist, then use some other keyboard handler
			var proposedNewIndex:int = layout.getNavigationDestinationIndex(caretIndex, navigationUnit, arrowKeysWrapFocus);
			
			if( _excludeType )
			{
				var i:int;
				var item:Object;
				if( proposedNewIndex < c )
				{
					for( i = proposedNewIndex; i >= 0; i-- )
					{
						item = dataProvider.getItemAt( i );
						if( !( item is _excludeType ) )
						{
							proposedNewIndex = i;
							break;
						}
					}
				}
				else
				{
					for( i = proposedNewIndex; i < dataProvider.length; i++ )
					{
						item = dataProvider.getItemAt( i );
						if( !( item is _excludeType ) )
						{
							proposedNewIndex = i;
							break;
						}
					}
				}
			}
			
			// Note that the KeyboardEvent is canceled even if the current selected or in focus index
			// doesn't change because we don't want another component to start handling these
			// events when the index reaches a limit.
			if (proposedNewIndex == -1)
				return;
			
			event.preventDefault(); 
			
			// Contiguous multi-selection action. Create the new selection
			// interval.   
			if (allowMultipleSelection && event.shiftKey && selectedIndices)
			{
				var startIndex:Number = getLastSelectedIndex(); 
				var newInterval:Vector.<int> = new Vector.<int>();  
				if (startIndex <= proposedNewIndex)
				{
					for (i = startIndex; i <= proposedNewIndex; i++)
					{
						newInterval.splice(0, 0, i); 
					}
				}
				else 
				{
					for (i = startIndex; i >= proposedNewIndex; i--)
					{
						newInterval.splice(0, 0, i); 
					}
				}
				setSelectedIndices(newInterval, true);  
				ensureIndexIsVisible(proposedNewIndex); 
			}
				// Entering the caret state with the Ctrl key down 
			else if (event.ctrlKey)
			{
				var oldCaretIndex:Number = caretIndex; 
				setCurrentCaretIndex(proposedNewIndex);
				var e:IndexChangeEvent = new IndexChangeEvent(IndexChangeEvent.CARET_CHANGE); 
				e.oldIndex = oldCaretIndex; 
				e.newIndex = caretIndex; 
				dispatchEvent(e);    
				ensureIndexIsVisible(proposedNewIndex); 
			}
				// Its just a new selection action, select the new index.
			else
			{
				setSelectedIndex(proposedNewIndex, true);
				ensureIndexIsVisible(proposedNewIndex);
			}
		}
		
		/**
		 *  @private
		 *  Returns the index of the last selected item. In single 
		 *  selection, this is just selectedIndex. In multiple 
		 *  selection, this is the index of the first selected item.  
		 */
		private function getLastSelectedIndex():int
		{
			if (selectedIndices && selectedIndices.length > 0)
				return selectedIndices[selectedIndices.length - 1]; 
			else 
				return 0; 
		}
	}
	
	
}