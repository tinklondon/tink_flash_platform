package ws.tink.spark.controls
{
	
	import flash.events.KeyboardEvent;
	
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	import spark.components.List;
	import spark.core.NavigationUnit;
	import spark.events.IndexChangeEvent;
	
	use namespace mx_internal;
	
	public class ExcludeSelectionList extends List
	{
		
		private var _excludeChanged:Boolean;
		
		public function ExcludeSelectionList()
		{
			super();
		}
		
		private var _excludeType : Class;
		public function get excludeType():Class
		{
			return _excludeType;
		}
		public function set excludeType( value:Class ):void
		{
			if( _excludeType == value ) return;
			
			_excludeTypes = null;
			_excludeType = value;
			_excludeChanged = true;
			invalidateProperties();
		}
		
		private var _excludeTypes : Vector.<Class>;
		public function get excludeTypes():Vector.<Class>
		{
			return _excludeTypes;
		}
		public function set excludeTypes( value:Vector.<Class> ):void
		{
			if( _excludeTypes == value ) return;
			
			_excludeType = null;
			_excludeTypes = value;
			_excludeChanged = true;
			invalidateProperties();
		}
		
		private var _excludeIndex	: int;
		public function get excludeIndex():int
		{
			return _excludeIndex;
		}
		public function set excludeIndex( value:int ):void
		{
			if( _excludeIndex == value ) return;
			
			_excludeIndices = null;
			_excludeIndex = value;
			_excludeChanged = true;
			invalidateProperties();
		}
		
		private var _excludeIndices	: Vector.<int>;
		public function get excludeIndices():Vector.<int>
		{
			return _excludeIndices;
		}
		public function set excludeIndices( value:Vector.<int> ):void
		{
			if( _excludeIndices == value ) return;
			
			_excludeIndex = NaN;
			_excludeIndices = value;
			_excludeChanged = true;
			invalidateProperties();
		}
		
		private var _excludeFunction : Function;
		public function get excludeFunction():Function
		{
			return _excludeFunction;
		}
		public function set excludeFunction( value:Function ):void
		{
			if( _excludeFunction == value ) return;
			
			_excludeFunction = value;
			_excludeChanged = true;
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if( _excludeChanged )
			{
				_excludeChanged = false;
				
				if( selectedIndices )
				{
					var excluded:Boolean;
					var newValue:Vector.<int> = new Vector.<int>();
					for each( var i:int in selectedIndices )
					{
						if( indexSelectable( i ) )
						{
							newValue.push( i );
						}
						else
						{
							excluded = true;
						}
					}
					
					if( excluded ) selectedIndices = newValue;
				}
			}
		}
		
		override mx_internal function setSelectedIndex( value:int, dispatchChangeEvent:Boolean = false ):void
		{
			if( value == selectedIndex || !indexSelectable( value ) ) return;

			super.setSelectedIndex( value, dispatchChangeEvent );
		}
		
		override mx_internal function setSelectedIndices( value:Vector.<int>, dispatchChangeEvent:Boolean = false ):void
		{
			if( value == selectedIndices ) return;
			
			var newValue:Vector.<int> = new Vector.<int>();
			for each( var i:int in value )
			{
				if( indexSelectable( i ) ) newValue.push( i );
			}
			
			super.setSelectedIndices( newValue, dispatchChangeEvent );
		}
		
		public function itemSelectable( value:Object ):Boolean
		{
			if( !dataProvider ) return true;
			
			return indexSelectable( dataProvider.getItemIndex( value ) );
		}
		
		public function indexSelectable( value:int ):Boolean
		{
			if( !dataProvider ) return true;
			
			if( value > -1 && value < dataProvider.length - 1 )
			{
				// Check for excluded indices
				if( _excludeIndex )
				{
					if( value == _excludeIndex ) return false;
				}
				else if( _excludeIndices )
				{
					for each( var i:int in _excludeIndices )
					{
						if( value == i ) return false;
					}
				}
				
				// Check for excluded data types
				if( _excludeType )
				{
					if( dataProvider.getItemAt( value ) is _excludeType ) return false;
				}
				else if( _excludeTypes )
				{
					var item:Object = dataProvider.getItemAt( value );
					for each( var c:Class in _excludeTypes )
					{
						if( item is c ) return false;
					}
				}
				
				if( _excludeFunction != null ) return !_excludeFunction( value, dataProvider.getItemAt( value ) );
			}
			
			return true;
		}
		
		protected function getNextSelectableIndex( value:int ):int
		{
			if( !dataProvider ) return -1;
			
			for( var i:int = value + 1; i < dataProvider.length; i++ )
			{
				if( indexSelectable( i ) ) return i;
			}
			
			return -1;
		}
		
		protected function getPrevSelectableIndex( value:int ):int
		{
			if( !dataProvider ) return -1;
			
			for( var i:int = value - 1; i > -1; i-- )
			{
				if( indexSelectable( i ) ) return i;
			}
			
			return -1;
		}
		
		/**
		 * @inherit
		 */
		override protected function commitSelection( dispatchChangedEvents:Boolean = true ):Boolean
		{
			if( requireSelection ) _proposedSelectedIndex = getNextSelectableIndex( _proposedSelectedIndex );
			
			return super.commitSelection( dispatchChangedEvents );
		}
		
		/**
		 * @inherit
		 */
		override protected function adjustSelection(index:int, add:Boolean=false):void
		{
			var i:int; 
			var curr:Number; 
			var newInterval:Vector.<int> = new Vector.<int>(); 
			var e:IndexChangeEvent; 
			
			if( selectedIndex == NO_SELECTION || doingWholesaleChanges )
			{
				// The case where one item has been newly added and it needs to be 
				// selected and careted because requireSelection is true. 
				if( dataProvider && dataProvider.length == 1 && requireSelection && indexSelectable( 0 ) )
				{
					newInterval.push( 0 );
					selectedIndices = newInterval;   
					selectedIndex = 0; 
					itemShowingCaret( 0, true ); 
					// If the selection properties have been adjusted to account for items that
					// have been added or removed, send out a "valueCommit" event and 
					// "caretChange" event so any bindings to them are updated correctly.
					
					dispatchEvent( new FlexEvent( FlexEvent.VALUE_COMMIT ) );
					
					e = new IndexChangeEvent( IndexChangeEvent.CARET_CHANGE ); 
					e.oldIndex = -1; 
					e.newIndex = _caretIndex;
					dispatchEvent( e ); 
				}
				return; 
			}
			
			// Ensure multiple and single selection are in-sync before adjusting  
			// selection. Sometimes if selection has been changed before adding/removing
			// an item, we may not have handled selection via invalidation, so in those 
			// cases, force a call to commitSelection() to validate and commit the selection. 
			if( ( !selectedIndices && selectedIndex > NO_SELECTION ) ||
				( selectedIndex > NO_SELECTION && selectedIndices.indexOf( selectedIndex ) == -1 ) )
			{
				commitSelection(); 
			}
			
			// Handle the add or remove and adjust selection accordingly. 
			if( add )
			{
				for( i = 0; i < selectedIndices.length; i++ )
				{
					curr = selectedIndices[ i ];
					
					// Adding an item above one of the selected items,
					// bump the selected item up. 
					if( curr >= index )
					{
						newInterval.push( curr + 1 );
					}
					else 
					{
						newInterval.push( curr );
					}
				}
			}
			else
			{
				// Quick check to see if we're removing the only selected item
				// in which case we need to honor requireSelection. 
				if( !isEmpty( selectedIndices ) && selectedIndices.length == 1 
					&& index == selectedIndex && requireSelection )
				{
					//Removing the last item 
					if( dataProvider.length == 0 )
					{
						newInterval = new Vector.<int>(); 
					}
					else if( index == 0 )
					{
						// We can't just set selectedIndex to 0 directly
						// since the previous value was 0 and the new value is
						// 0, so the setter will return early.
						_proposedSelectedIndex = getNextSelectableIndex( 0 ); 
						invalidateProperties();
						return;
					}    
					else
					{
						newInterval.push( getNextSelectableIndex( 0 ) );  
					}
				}
				else
				{    
					for( i = 0; i < selectedIndices.length; i++ )
					{
						curr = selectedIndices[ i ]; 
						// Removing an item above one of the selected items,
						// bump the selected item down. 
						if( curr > index )
						{
							newInterval.push( curr - 1 );
						}
						else if( curr < index ) 
						{
							newInterval.push( curr );
						}
					}
				}
			}
			
			if (caretIndex == selectedIndex)
			{
				// caretIndex is not changing, so we just need to dispatch
				// an "caretChange" event to update any bindings and update the 
				// caretIndex backing variable. 
				var oldIndex:Number = caretIndex; 
				_caretIndex = getFirstItemValue( newInterval );
				e = new IndexChangeEvent(IndexChangeEvent.CARET_CHANGE); 
				e.oldIndex = oldIndex; 
				e.newIndex = caretIndex; 
				dispatchEvent(e); 
			}
			else 
			{
				// De-caret the previous caretIndex renderer and set the 
				// caretIndexAdjusted flag to true. This will mean in 
				// commitProperties, the caretIndex will be adjusted to 
				// match the selectedIndex; 
				
				// TODO (dsubrama): We should revisit the synchronous nature of the 
				// de-careting/re-careting behavior.
				itemShowingCaret( caretIndex, false ); 
				caretIndexAdjusted = true; 
				invalidateProperties(); 
			}
			
			selectedIndices = newInterval;
			selectedIndex = getFirstItemValue( newInterval );
		}
		
		/**
		 *  @inherit
		 */
		override protected function adjustSelectionAndCaretUponNavigation( event:KeyboardEvent ):void
		{
			// Some unrecognized key stroke was entered, return. 
			var navigationUnit:uint = event.keyCode;    
			if( !NavigationUnit.isNavigationUnit( event.keyCode ) ) return; 
			
			// Delegate to the layout to tell us what the next item is we should select or focus into.
			// TODO (dsubrama): At some point we should refactor this so we don't depend on layout
			// for keyboard handling. If layout doesn't exist, then use some other keyboard handler
			var proposedNewIndex:int = layout.getNavigationDestinationIndex( caretIndex, navigationUnit, arrowKeysWrapFocus );
			
			if( !indexSelectable( proposedNewIndex ) )
			{
				if( caretIndex < proposedNewIndex )
				{
					proposedNewIndex = getNextSelectableIndex( proposedNewIndex );
				}
				else
				{
					proposedNewIndex = getPrevSelectableIndex( proposedNewIndex );
				}
			}
					
			// Note that the KeyboardEvent is canceled even if the current selected or in focus index
			// doesn't change because we don't want another component to start handling these
			// events when the index reaches a limit.
			if( proposedNewIndex == -1 ) return;
			
			event.preventDefault(); 
			
			// Contiguous multi-selection action. Create the new selection
			// interval.   
			if( allowMultipleSelection && event.shiftKey && selectedIndices )
			{
				var startIndex:Number = getLastSelectedIndex(); 
				var newInterval:Vector.<int> = new Vector.<int>();
				var i:int; 
				if( startIndex <= proposedNewIndex )
				{
					for( i = startIndex; i <= proposedNewIndex; i++ )
					{
						newInterval.splice( 0, 0, i ); 
					}
				}
				else 
				{
					for( i = startIndex; i >= proposedNewIndex; i-- )
					{
						newInterval.splice( 0, 0, i ); 
					}
				}
				setSelectedIndices( newInterval, true );  
				ensureIndexIsVisible( proposedNewIndex ); 
			}
			// Entering the caret state with the Ctrl key down 
			else if( event.ctrlKey )
			{
				var oldCaretIndex:Number = caretIndex; 
				setCurrentCaretIndex( proposedNewIndex );
				var e:IndexChangeEvent = new IndexChangeEvent( IndexChangeEvent.CARET_CHANGE ); 
				e.oldIndex = oldCaretIndex; 
				e.newIndex = caretIndex; 
				dispatchEvent( e );    
				ensureIndexIsVisible( proposedNewIndex ); 
			}
				// Its just a new selection action, select the new index.
			else
			{
				setSelectedIndex( proposedNewIndex, true );
				ensureIndexIsVisible( proposedNewIndex );
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
			if ( selectedIndices && selectedIndices.length > 0 )
			{
				return selectedIndices[ selectedIndices.length - 1 ]; 
			}
			else 
			{
				return 0; 
			}
		}
		
		/**
		 *  @private
		 *  Returns true if v is null or an empty Vector.
		 */
		private function isEmpty( v:Vector.<int> ):Boolean
		{
			return v == null || v.length == 0;
		}
		
		/**
		 *  @private
		 *  Given a Vector, returns the value of the first item, 
		 *  or -1 if there are no items in the Vector; 
		 */
		private function getFirstItemValue(v:Vector.<int>):int
		{
			if( v && v.length > 0 )
			{
				return v[ 0 ];
			}
			else 
			{
				return -1;
			}
		}
	}
	
	
}