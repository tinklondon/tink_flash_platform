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
	import flash.sampler.getInvocationCount;
	
	import mx.core.DragSource;
	import mx.core.mx_internal;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.DataGroup;
	import spark.components.List;
	import spark.layouts.supportClasses.DropLocation;
	
	import ws.tink.spark.controls.partitionSupportClasses.IPartitionable;
	import ws.tink.spark.controls.partitionSupportClasses.PartitionDropLocation;
	
	use namespace mx_internal;
	
	public class PartitionList extends List implements IPartitionable
	{
		public function PartitionList()
		{
			super();
		}
		
		private var _partitions	: Vector.<int>;
		
		public function get partitions():Vector.<int>
		{
			return _partitions;
		}
		public function set partitions( value:Vector.<int> ):void
		{
			if( _partitions == value ) return;
			
			if( dataGroup )
			{
				if( dataGroup is IPartitionable )
				{
					IPartitionable( dataGroup ).partitions = value;
				}
			}
			
			_partitions = value;
			
			invalidateDisplayList();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if( instance == dataGroup )
			{
				if( dataGroup is IPartitionable )
				{
					IPartitionable( dataGroup ).partitions = _partitions;
				}
			}
			
			super.partAdded( partName, instance );
		}
		
		
		
		
		override protected function dragEnterHandler( event:DragEvent ):void
		{
			if( event.isDefaultPrevented() ) return;
			
			var dropLocation:DropLocation = calculateDropLocation( event ); 
			if( dropLocation )
			{
				DragManager.acceptDragDrop( this );
				
				// Create the dropIndicator instance. The layout will take care of
				// parenting, sizing, positioning and validating the dropIndicator.
				createDropIndicator();
				
				// Show focus
				drawFocusAnyway = true;
				drawFocus(true);
				
				// Notify manager we can drop
				DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
				
				// Show drop indicator
				layout.showDropIndicator(dropLocation);
			}
			else
			{
				DragManager.showFeedback(DragManager.NONE);
			}
		}
		
		
		/**
		 *  @private
		 *  Handles <code>DragEvent.DRAG_OVER</code> events. This method
		 *  determines if the DragSource object contains valid elements and uses
		 *  the <code>showDropFeedback()</code> method to set up the UI feedback 
		 *  as well as the layout's <code>showDropIndicator()</code> method
		 *  to display the drop indicator and initiate drag scrolling.
		 *
		 *  @param event The DragEvent object.
		 *  
		 *  @see spark.layouts.LayoutBase#showDropIndicator
		 *  @see spark.layouts.LayoutBase#hideDropIndicator
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function dragOverHandler( event:DragEvent ):void
		{
			if( event.isDefaultPrevented() ) return;
			
			var dropLocation:DropLocation = calculateDropLocation(event);
			
			moveData( event, dropLocation );
			
			if( dropLocation )
			{
				// Show focus
				drawFocusAnyway = true;
				drawFocus(true);
				
				// Notify manager we can drop
				DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
				
				// Show drop indicator
				layout.showDropIndicator(dropLocation);
			}
			else
			{
				// Hide if previously showing
				layout.hideDropIndicator();
				
				// Hide focus
				drawFocus(false);
				drawFocusAnyway = false;
				
				// Notify manager we can't drop
				DragManager.showFeedback(DragManager.NONE);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Drop methods
		//
		//--------------------------------------------------------------------------
		
		private function calculateDropLocation(event:DragEvent):DropLocation
		{
			// Verify data format
			if (!enabled || !event.dragSource.hasFormat("data"))
				return null;
			
			// Calculate the drop location
			return layout.calculateDropLocation(event);
		}
		
		private var _prevDropIndex:int;
		private var _prevPartitionDropIndex:int;
		
		private function moveData( event:DragEvent, dropLocation:DropLocation ):void
		{
			var item:Object = event.dragSource.dataForFormat("data");
			
			if( item == null ) return;
			
			var dragIndex:int = -1;
			var partitionDragIndex:int = -1;
			
			// If the item was dragged from this component
			// find the index of the item that is being dragged
			// and the index of the partition it was dragged from
			if( event.dragInitiator == this )
			{
				dragIndex = dataProvider.getItemIndex( item );
					
				// If there are no partitions the partition index must be 0
				partitionDragIndex = 0;
				var itemCount:int = 0;
				
				// Find the partition index
				if( _partitions != null && dragIndex != -1 )
				{
					for each( var numItemsInPartition:int in _partitions )
					{
						if( itemCount + numItemsInPartition > dragIndex )
						{
							break;
						}
						else
						{
							itemCount += numItemsInPartition;
							partitionDragIndex++;
						}
					}
				}
				
				if( dropLocation )
				{
					if( dropLocation is PartitionDropLocation )
					{
						var partitionDropIndex:int = PartitionDropLocation( dropLocation ).partitionDropIndex;
							
						// If we are dropping an item into the same partition
						// it was dragged from
						if( event.dragInitiator == this )// && partitionDragIndex == partitionDropIndex ) 
						{
							if( partitionDropIndex == partitions.length )
							{
								if( dropLocation.dropIndex >= dataProvider.length ||
									partitionDragIndex != partitionDropIndex )
								{
									dropLocation.dropIndex--;
								}
							}
							else if( dropLocation.dropIndex > dragIndex )
							{
								if( partitionDragIndex != partitionDropIndex )
								{
									dropLocation.dropIndex--;
								}
								else
								{
									itemCount = 0;
									
									// Find the max index for this column
									for( var i:int = 0; i <= partitionDropIndex; i++ )
									{
										itemCount += partitions[ i ];
									}
									
									// If the dropIndex is bigger than the max index
									// for this column decrease the dropIndex.
									if( dropLocation.dropIndex >= itemCount )
									{
										dropLocation.dropIndex--;
									}
								}
							}
						}
					}
				}
				
				if( _prevDropIndex != dropLocation.dropIndex )
				{
					_prevDropIndex = dropLocation.dropIndex;
					
					if( event.dragInitiator == this )
					{
						if( dropLocation.dropIndex != dragIndex )
						{
							dataProvider.removeItemAt( dragIndex );
							if( dropLocation.dropIndex != -1 )
							{
								dataProvider.addItemAt( item, dropLocation.dropIndex );
							}
						}
					}
					else
					{
						if( dropLocation.dropIndex != -1 )
						{
							dataProvider.addItemAt( item, _prevDropIndex );
						}
					}
				}
				
				if( _prevPartitionDropIndex != partitionDropIndex )
				{
					var change:Boolean = false;
					_prevPartitionDropIndex = partitionDropIndex;
					if( partitionDragIndex < partitions.length )
					{
						partitions[ partitionDragIndex ]--;
						change = true;
					}
					if( partitionDropIndex < partitions.length )
					{
						partitions[ partitionDropIndex ]++;
						change = true;
					}
					
					if( dataGroup && change ) dataGroup.invalidateDisplayList();
				}
			}
		}
		
		private var _flexibleBreaks:Boolean = true;
		
		
		override public function set allowMultipleSelection( value:Boolean ):void
		{
			
		}
		
		
		override public function addDragData(dragSource:DragSource):void
		{
			dragSource.addData( dataProvider.getItemAt( selectedIndex ), "data");
		}
		
	}
}