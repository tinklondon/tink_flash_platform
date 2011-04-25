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
	
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	import spark.components.IItemRenderer;
	import spark.components.supportClasses.ButtonBarBase;
	import spark.events.IndexChangeEvent;
	import spark.events.RendererExistenceEvent;
	
	use namespace mx_internal;
	
	public class MultipleSelectionButtonBar extends ButtonBarBase
	{
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function MultipleSelectionButtonBar()
		{
			super();
			
			_selectedIndices = new Vector.<int>()
		}
		
		//----------------------------------
		//  selectedIndices
		//----------------------------------
		
		/**
		 *  @private
		 *  Internal storage for the selectedIndices property.
		 */
		private var _selectedIndices:Vector.<int>;
		
		/**
		 *  @private
		 */
		private var _proposedSelectedIndices:Vector.<int> = new Vector.<int>(); 
		
		/**
		 *  @private
		 */
		private var multipleSelectionChanged:Boolean; 
		
		
		/**
		 *  A Vector of ints representing the indices of the currently selected  
		 *  item or items. 
		 *  If multiple selection is disabled by setting 
		 *  <code>allowMultipleSelection</code> to <code>false</code>, and this property  
		 *  is set, the data item corresponding to the first index in the Vector is selected.  
		 *
		 *  <p>If multiple selection is enabled by setting 
		 *  <code>allowMultipleSelection</code> to <code>true</code>, this property  
		 *  contains a list of the selected indices in the reverse order in which they were selected. 
		 *  That means the first element in the Vector corresponds to the last item selected.</p>
		 *  
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get selectedIndices():Vector.<int>
		{
			return _selectedIndices;
		}
		
		/**
		 *  @private
		 */
		public function set selectedIndices(value:Vector.<int>):void
		{
			setSelectedIndices(value, false);
		}
		
		
		/**
		 *  @private
		 *  Used internally to specify whether the selectedIndices changed programmatically or due to 
		 *  user interaction. 
		 * 
		 *  @param dispatchChangeEvent if true, the component will dispatch a "change" event if the
		 *  value has changed. Otherwise, it will dispatch a "valueCommit" event. 
		 */
		mx_internal function setSelectedIndices(value:Vector.<int>, dispatchChangeEvent:Boolean = false):void
		{
			// TODO (tink) Do a deep compare of the vectors
			if (_proposedSelectedIndices == value || 
				(value && value.length == 1 && 
					selectedIndices && selectedIndices.length == 1 &&    
					value[0] == selectedIndices[0]))
				return; 
			
			if (dispatchChangeEvent)
				dispatchChangeAfterSelection = dispatchChangeEvent;
			_proposedSelectedIndices = value;
			multipleSelectionChanged = true;  
			invalidateProperties();
		}
		
		
		//----------------------------------
		//  selectedItems
		//----------------------------------
		
		[Bindable("change")]
		[Bindable("valueCommit")]
		
		/**
		 *  A Vector of Objects representing the currently selected data items. 
		 *  If multiple selection is disabled by setting <code>allowMultipleSelection</code>
		 *  to <code>false</code>, and this property is set, the data item 
		 *  corresponding to the first item in the Vector is selected.  
		 *
		 *  <p>If multiple selection is enabled by setting 
		 *  <code>allowMultipleSelection</code> to <code>true</code>, this property  
		 *  contains a list of the selected items in the reverse order in which they were selected. 
		 *  That means the first element in the Vector corresponds to the last item selected.</p>
		 * 
		 *  @default null
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get selectedItems():Vector.<Object>
		{
			var result:Vector.<Object>;
			
			if (selectedIndices)
			{
				result = new Vector.<Object>();
				
				var count:int = selectedIndices.length;
				
				for (var i:int = 0; i < count; i++)
					result[i] = dataProvider.getItemAt(selectedIndices[i]);  
			}
			
			return result;
		}
		
		/**
		 *  @private
		 */
		public function set selectedItems(value:Vector.<Object>):void
		{
			var indices:Vector.<int>;
			
			if (value)
			{
				indices = new Vector.<int>();
				
				var count:int = value.length;
				
				for (var i:int = 0; i < count; i++)
				{
					var index:int = dataProvider.getItemIndex(value[i]);
					if (index != -1)
					{ 
						indices.splice(0, 0, index);   
					}
					// If an invalid item is in the selectedItems vector,
					// we set selectedItems to an empty vector, which 
					// essentially clears selection. 
					if (index == -1)
					{
						indices = new Vector.<int>();
						break;  
					}
				}
			}
			
			_proposedSelectedIndices = indices;
			multipleSelectionChanged = true;
			invalidateProperties(); 
		}
		override mx_internal function setSelectedIndex(value:int, dispatchChangeEvent:Boolean = false):void
		{
			// Overriden to stop the default ButtonBase behaviour
		}
	
		private function onRendererClick( event:MouseEvent ):void
		{
			var renderer:IItemRenderer = IItemRenderer( event.currentTarget );
			var indices:Vector.<int> = ( _proposedSelectedIndices.length ) ? _proposedSelectedIndices.concat() : _selectedIndices.concat();
			var index:int = indices.indexOf( renderer.itemIndex );
			if( renderer.selected )
			{
				if( index == -1 ) indices.push( renderer.itemIndex );
			}
			else
			{
				if( index != -1 ) indices.splice( index, 1 );
			}
			
			setSelectedIndices( indices, true);
		}
		
		
		
		
		
		/**
		 *  @private
		 */
		override mx_internal function isItemIndexSelected(index:int):Boolean
		{
			return selectedIndices.indexOf(index) != -1;
		}
		
		
		
		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{
			super.commitProperties(); 
			
			if( multipleSelectionChanged )
			{
				// multipleSelectionChanged flag is cleared in commitSelection();
				// this is so, because commitSelection() could be called from
				// super.commitProperties() as well and in that case we don't
				// want to commitSelection() twice, as that will actually wrongly 
				// clear the selection.
				commitSelection();
			}
		}
		
		
		/**
		 *  @private
		 *  Let ListBase handle single selection and afterwards come in and 
		 *  handle multiple selection via the commitMultipleSelection() 
		 *  helper method. 
		 */
		override protected function commitSelection(dispatchChangedEvents:Boolean = true):Boolean
		{
			// Clear the flag so that we don't commit the selection again.
			multipleSelectionChanged = false;
			
			var oldSelectedIndex:Number = _selectedIndex;
			var oldCaretIndex:Number = _caretIndex;  
			
			_proposedSelectedIndices = _proposedSelectedIndices.filter(isValidIndex);
			
			
			// Keep _proposedSelectedIndex in-sync with multiple selection properties. 
			if (!isEmpty(_proposedSelectedIndices))
				_proposedSelectedIndex = getFirstItemValue(_proposedSelectedIndices); 
			
			// Let ListBase handle the validating and commiting of the single-selection
			// properties.  
			var retVal:Boolean = super.commitSelection(false); 
			
			// If super.commitSelection returns a value of false, 
			// the selection was cancelled, so return false and exit. 
			if (!retVal)
				return false; 
			
			// Now keep _proposedSelectedIndices in-sync with single selection 
			// properties now that the single selection properties have been 
			// comitted.  
			if (selectedIndex > NO_SELECTION)
			{
				if (_proposedSelectedIndices && _proposedSelectedIndices.indexOf(selectedIndex) == -1)
					_proposedSelectedIndices.push(selectedIndex);
			}
			
			// Validate and commit the multiple selection related properties. 
			commitMultipleSelection(); 
			
			// Set the caretIndex based on the current selection 
			setCurrentCaretIndex(selectedIndex);
			
			// And dispatch change and caretChange events so that all of 
			// the bindings update correctly. 
			if (dispatchChangedEvents && retVal)
			{
				var e:IndexChangeEvent; 
				
				if (dispatchChangeAfterSelection)
				{
					e = new IndexChangeEvent(IndexChangeEvent.CHANGE);
					e.oldIndex = oldSelectedIndex;
					e.newIndex = _selectedIndex;
					dispatchEvent(e);
					dispatchChangeAfterSelection = false;
				}
				else
				{
					dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
				}
				
				e = new IndexChangeEvent(IndexChangeEvent.CARET_CHANGE); 
				e.oldIndex = oldCaretIndex; 
				e.newIndex = caretIndex;
				dispatchEvent(e);    
			}
			
			return retVal; 
		}
		
		/**
		 *  @private
		 *  Given a new selection interval, figure out which
		 *  items are newly added/removed from the selection interval and update
		 *  selection properties and view accordingly. 
		 */
		protected function commitMultipleSelection():void
		{
			var removedItems:Vector.<int> = new Vector.<int>();
			var addedItems:Vector.<int> = new Vector.<int>();
			var i:int;
			var count:int;
			
			if (!isEmpty(_selectedIndices) && !isEmpty(_proposedSelectedIndices))
			{
				// Changing selection, determine which items were added to the 
				// selection interval 
				count = _proposedSelectedIndices.length;
				for (i = 0; i < count; i++)
				{
					if (_selectedIndices.indexOf(_proposedSelectedIndices[i]) < 0)
						addedItems.push(_proposedSelectedIndices[i]);
				}
				// Then determine which items were removed from the selection 
				// interval 
				count = _selectedIndices.length; 
				for (i = 0; i < count; i++)
				{
					if (_proposedSelectedIndices.indexOf(_selectedIndices[i]) < 0)
						removedItems.push(_selectedIndices[i]);
				}
			}
			else if (!isEmpty(_selectedIndices))
			{
				// Going to a null selection, remove all
				removedItems = _selectedIndices;
			}
			else if (!isEmpty(_proposedSelectedIndices))
			{
				// Going from a null selection, add all
				addedItems = _proposedSelectedIndices;
			}
			
			// De-select the old items that were selected 
			if (removedItems.length > 0)
			{
				count = removedItems.length;
				for (i = 0; i < count; i++)
				{
					itemSelected(removedItems[i], false);
				}
			}
			
			// Select the new items in the new selection interval 
			if (!isEmpty(_proposedSelectedIndices))
			{
				count = _proposedSelectedIndices.length;
				for (i = 0; i < count; i++)
				{
					itemSelected(_proposedSelectedIndices[i], true);
				}
			}
			
			// Commit the selected indices and put _proposedSelectedIndices
			// back to its default value.  
			_selectedIndices = _proposedSelectedIndices;
			_proposedSelectedIndices = new Vector.<int>();
		}
		
		
		/**
		 *  @private
		 *  Returns true if v is null or an empty Vector.
		 */
		private function isEmpty(v:Vector.<int>):Boolean
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
			if (v && v.length > 0)
				return v[0]; 
			else 
				return -1; 
		}
		
		
		/**
		 *  @private
		 *  Used to filter _proposedSelectedIndices.
		 */
		private function isValidIndex(item:int, index:int, v:Vector.<int>):Boolean
		{
			return (dataProvider != null) && (item >= 0) && (item < dataProvider.length); 
		}
		
		
		
		private function onDataGroupRendererAdd( event:RendererExistenceEvent ):void
		{
			if( event.renderer ) event.renderer.addEventListener( MouseEvent.CLICK, onRendererClick, false, 0, true );
		}
		
		private function onDataGroupRendererRemove( event:RendererExistenceEvent ):void
		{
			if( event.renderer ) event.renderer.removeEventListener( MouseEvent.CLICK, onRendererClick, false );
		}
			
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == dataGroup)
			{
				dataGroup.addEventListener(RendererExistenceEvent.RENDERER_ADD, onDataGroupRendererAdd, false, 0, true );
				dataGroup.addEventListener(RendererExistenceEvent.RENDERER_REMOVE, onDataGroupRendererRemove, false, 0, true );
			}
		}
		
		/**
		 *  @private
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if (instance == dataGroup)
			{
				dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_ADD, onDataGroupRendererAdd, false );
				dataGroup.removeEventListener(RendererExistenceEvent.RENDERER_REMOVE, onDataGroupRendererRemove, false);
			}
			
			super.partRemoved(partName, instance);
		}
		
		
		
	}
}