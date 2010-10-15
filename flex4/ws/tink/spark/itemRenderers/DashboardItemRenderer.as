package ws.tink.spark.itemRenderers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;
	import mx.core.ClassFactory;
	import mx.core.DragSource;
	import mx.core.EventPriority;
	import mx.core.IFlexDisplayObject;
	import mx.core.IVisualElement;
	import mx.events.DragEvent;
	import mx.events.SandboxMouseEvent;
	import mx.managers.DragManager;
	
	import spark.components.DataGroup;
	import spark.components.IItemRenderer;
	import spark.events.RendererExistenceEvent;
	import spark.layouts.VerticalLayout;
	import spark.skins.spark.DefaultItemRenderer;
	
	public class DashboardItemRenderer extends DataGroup// implements IItemRenderer
	{
		public function DashboardItemRenderer()
		{
			super();
			
			itemRenderer = new ClassFactory( DefaultItemRenderer );
			layout = new VerticalLayout();
			
//			addEventListener( DragEvent.DRAG_START, dragStartHandler, false, EventPriority.DEFAULT_HANDLER );
//			addEventListener( DragEvent.DRAG_COMPLETE, dragCompleteHandler, false, EventPriority.DEFAULT_HANDLER );
			
			addEventListener( RendererExistenceEvent.RENDERER_ADD, onRendererAdd );
			addEventListener( RendererExistenceEvent.RENDERER_REMOVE, onRendererRemove );
		}
		
		private function onRendererAdd( event:RendererExistenceEvent ):void
		{
			if( !event.renderer) return;
			event.renderer.addEventListener( MouseEvent.MOUSE_DOWN, onRendererMouseDown );
		}
		
		private function onRendererRemove( event:RendererExistenceEvent ):void
		{
			if( !event.renderer) return;
			event.renderer.removeEventListener( MouseEvent.MOUSE_DOWN, onRendererMouseDown );
		}
		
		private var _mouseDownPoint	: Point;
		private var _mouseDownIndex	: int;
		
		private function onRendererMouseDown( event:MouseEvent ):void
		{
			var renderer:IVisualElement = IVisualElement( event.currentTarget );
			
			_mouseDownPoint = DisplayObject( renderer ).localToGlobal( new Point( event.localX, event.localY ) );
			_mouseDownIndex = getElementIndex( renderer );
			
			var r:DisplayObject = systemManager.getSandboxRoot();
			r.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			r.addEventListener( SandboxMouseEvent.MOUSE_UP_SOMEWHERE, onMouseUp, false, 0, true);
			r.addEventListener( MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		}
		
		private function onMouseMove( event:MouseEvent ):void
		{
			if( !_mouseDownPoint ) return;
			
			var pt:Point = new Point( event.localX, event.localY );
			pt = DisplayObject( event.target ).localToGlobal( pt );
			
			const DRAG_THRESHOLD:int = 5;
			
			if( Math.abs( _mouseDownPoint.x - pt.x ) > DRAG_THRESHOLD ||
				Math.abs( _mouseDownPoint.y - pt.y ) > DRAG_THRESHOLD )
			{
				var dragEvent:DragEvent = new DragEvent( DragEvent.DRAG_START );
				dragEvent.dragInitiator = this;
				
				var localMouseDownPoint:Point = this.globalToLocal( _mouseDownPoint );
				
				dragEvent.localX = localMouseDownPoint.x;
				dragEvent.localY = localMouseDownPoint.y;
				dragEvent.buttonDown = true;
				
				// We're starting a drag operation, remove the handlers
				// that are monitoring the mouse move, we don't need them anymore:
				dispatchEvent( dragEvent );
				
				// Finally, remove the mouse handlers
//				removeMouseHandlersForDragStart();
			}
		}
		
		private function onMouseUp( event:Event ):void
		{
			
		}
		
//		protected function dragStartHandler(event:DragEvent):void
//		{
//			if (event.isDefaultPrevented())
//				return;
//			
//			var dragSource:DragSource = new DragSource();
//			addDragData(dragSource);
//			DragManager.doDrag(this, 
//				dragSource, 
//				event, 
//				createDragIndicator(), 
//				0 /*xOffset*/, 
//				0 /*yOffset*/, 
//				0.5 /*imageAlpha*/,
//				true );
////				dragMoveEnabled);
//		}
//		
//		
//		/**
//		 *  Adds the selected items to the DragSource object as part of
//		 *  a drag-and-drop operation.
//		 *  Override this method to add other data to the drag source.
//		 * 
//		 *  @param ds The DragSource object to which to add the data.
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function addDragData( dragSource:DragSource ):void
//		{
//			dragSource.addHandler( copySelectedItemsForDragDrop, "itemsByIndex" );
//			
//			// Calculate the index of the focus item within the vector
//			// of ordered items returned for the "itemsByIndex" format.
//			var caretIndex:int = 0;
//			var draggedIndices:Vector.<int> = selectedIndices;
//			var count:int = draggedIndices.length;
//			for (var i:int = 0; i < count; i++)
//			{
//				if (mouseDownIndex > draggedIndices[i])
//					caretIndex++;
//			}
//			dragSource.addData(caretIndex, "caretIndex");
//		}
//		
//		
//		
//		
//		/**
//		 *  @private
//		 *  Handles <code>DragEvent.DRAG_COMPLETE</code> events.  This method
//		 *  removes the items from the data provider.
//		 *
//		 *  @param event The DragEvent object.
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		protected function dragCompleteHandler(event:DragEvent):void
//		{
//			if (event.isDefaultPrevented())
//				return;
//			
//			// Remove the dragged items only if they were drag moved to
//			// a different list. If the items were drag moved to this
//			// list, the reordering was already handles in the 
//			// DragEvent.DRAG_DROP listener.
//			if (!dragMoveEnabled ||
//				event.action != DragManager.MOVE || 
//				event.relatedObject == this)
//				return;
//			
//			// Clear the selection, but remember which items were moved
//			var movedIndices:Vector.<int> = selectedIndices;
//			setSelectedIndices(new Vector.<int>(), true);
//			validateProperties(); // To commit the selection
//			
//			// Remove the moved items
//			movedIndices.sort(compareValues);
//			var count:int = movedIndices.length;
//			for (var i:int = count - 1; i >= 0; i--)
//			{
//				dataProvider.removeItemAt(movedIndices[i]);
//			}
//		}
//		
//		
//		/**
//		 *  Creates an instance of a class that is used to display the visuals
//		 *  of the dragged items during a drag and drop operation.
//		 *  The default <code>DragEvent.DRAG_START</code> handler passes the
//		 *  instance to the <code>DragManager.doDrag()</code> method. 
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function createDragIndicator():IFlexDisplayObject
//		{
//			var dragIndicator:IFlexDisplayObject;
//			var dragIndicatorClass:Class = Class(getStyle("dragIndicatorClass"));
//			if (dragIndicatorClass)
//			{
//				dragIndicator = new dragIndicatorClass();
//				if( dragIndicator is IVisualElement ) IVisualElement( dragIndicator ).owner = this;
//			}
//			
//			return dragIndicator;
//		}
//		
//		
//		/**
//		 *  @private
//		 */
//		private function copySelectedItemsForDragDrop():Vector.<Object>
//		{
//			// Copy the vector so that we don't modify the original
//			// since selectedIndices returns a reference.
//			var draggedIndices:Vector.<int> = selectedIndices.slice(0, selectedIndices.length);
//			var result:Vector.<Object> = new Vector.<Object>(draggedIndices.length);
//			
//			// Sort in the order of the data source
//			draggedIndices.sort(compareValues);
//			
//			// Copy the items
//			var count:int = draggedIndices.length;
//			for (var i:int = 0; i < count; i++)
//				result[i] = dataProvider.getItemAt(draggedIndices[i]);  
//			return result;
//		}
		
		
		
		
//		public function get itemIndex():int
//		{
//			return 0;
//		}
//		
//		public function set itemIndex(value:int):void
//		{
//		}
//		
//		public function get dragging():Boolean
//		{
//			return false;
//		}
//		
//		public function set dragging(value:Boolean):void
//		{
//		}
//		
//		public function get label():String
//		{
//			return null;
//		}
//		
//		public function set label(value:String):void
//		{
//		}
//		
//		public function get selected():Boolean
//		{
//			return false;
//		}
//		
//		public function set selected(value:Boolean):void
//		{
//		}
//		
//		public function get showsCaret():Boolean
//		{
//			return false;
//		}
//		
//		public function set showsCaret(value:Boolean):void
//		{
//		}
//		
//		public function get data():Object
//		{
//			return null;
//		}
//		
//		public function set data(value:Object):void
//		{
//			dataProvider = value as ArrayList;
//		}
	}
}