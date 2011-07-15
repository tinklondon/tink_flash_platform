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
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.ISelectableList;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	
	import spark.components.ButtonBar;
	import spark.components.DropDownList;
	import spark.components.IItemRenderer;
	import spark.components.List;
	import spark.components.supportClasses.DropDownController;
	import spark.components.supportClasses.ListBase;
	import spark.components.supportClasses.ToggleButtonBase;
	import spark.events.DropDownEvent;
	import spark.events.IndexChangeEvent;
	import spark.events.RendererExistenceEvent;
	
	import ws.tink.spark.itemRenderers.MenuBarItemRenderer;
	
	use namespace mx_internal;
	
	public class MenuBar extends ButtonBar
	{
		public function MenuBar()
		{
			super();
		}
		
		
		
		private var _renderersInvalid:Boolean;
		
		
		//----------------------------------
		//  closeOnSelection
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the closeOnSelection property. 
		 */
		private var _closeOnSelection:Boolean;
		
		/**
		 *  @copy ws.tink.spark.controls.MenuBar#closeOnSelection
		 * 
		 *  @default true
		 */
		public function get closeOnSelection():Boolean
		{
			return _closeOnSelection;
		}
		/**
		 *  @private
		 */
		public function set closeOnSelection(value:Boolean):void
		{
			if( _closeOnSelection == value ) return;
			
			_closeOnSelection = value;
			_renderersInvalid = true;
			invalidateProperties();
		}
		
		
		//----------------------------------
		//  allowBranchSelection
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the allowBranchSelection property. 
		 */
		private var _allowBranchSelection:Boolean = true;
		
		/**
		 *  Whether or not a branch in the tree can be selected.
		 *  If set to false, only leaves can be selected.
		 *  
		 *  @default true
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get allowBranchSelection():Boolean
		{
			return _allowBranchSelection;
		}
		/**
		 *  @private
		 */		
		public function set allowBranchSelection( value:Boolean ):void
		{ 
			if( _allowBranchSelection == value ) return;
			
			_allowBranchSelection = value;
			_renderersInvalid = true;
			invalidateProperties();
		}
		
		
		
		//----------------------------------
		//  selectedIndices
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the selectedIndices property before they are commited. 
		 */
		private var _proposedSelectedIndices:Vector.<int>;
		
		/**
		 *  @private
		 *  Storage for the selectedIndices property. 
		 */
		private var _selectedIndices:Vector.<int>;
		
		[Bindable("change")]
		[Bindable("valueCommit")]
		/**
		 *  A Vector of ints representing the indices of the currently selected  
		 *  item or items. 
		 *
		 *  <p>The first int represents the selectedIndex of this DropDownList and each further
		 *  int represents the selectedIndex of the selectedItem.</p>
		 *  
		 *  @default []
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get selectedIndices():Vector.<int>
		{
			return _proposedSelectedIndices ? _proposedSelectedIndices : _selectedIndices;
		}
		/**
		 *  @private
		 */		
		public function set selectedIndices(value:Vector.<int>):void
		{
			if( _selectedIndices == value ) return;
			
			_selectedIndices = value;
			
			selectedIndex = _selectedIndices && _selectedIndices.length ? _selectedIndices[ 0 ] : -1;
		}
		
		
		[Bindable("change")]
		[Bindable("valueCommit")]
		/**
		 *  A Vector of strings representing the labels of the currently selected  
		 *  item or items. 
		 *
		 *  <p>The first string represents the selectedIndex of this DropDownList and each further
		 *  string represents the selectedIndex of the selectedItem.</p>
		 *  
		 *  @default []
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get selectedLabels():Vector.<String>
		{
			if( selectedIndices && selectedIndices.length )
			{
				var item:Object;
				var dp:IList = dataProvider;
				var labels:Vector.<String> = new Vector.<String>();
				const indices:Vector.<int> = selectedIndices;
				const numItems:int = indices.length;
				for( var i:int = 0; i < numItems; i++ )
				{
					item = dp.getItemAt( indices[ i ] )
					labels.push( itemToLabel( item ) );
					if( i < numItems - 1 ) dp = IList( item );
				}
				
				return labels;
			}
			
			return null;
		}
		
		
		
		
		
		
		private var _itemMouseDowns:Boolean;
		
		
//		/**
//		 *  @private
//		 */
//		override protected function item_mouseDownHandler(event:MouseEvent):void
//		{
//			const renderer:List = List( event.currentTarget );
//			if( renderer.dataProvider && renderer.dataProvider.length > 1 && !allowBranchSelection ) return;
//			
//			var newIndex:int
//			if (event.currentTarget is IItemRenderer)
//				newIndex = IItemRenderer(event.currentTarget).itemIndex;
//			else
//				newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
//			
//			
//			
//			_proposedSelectedIndices = renderer.selectedIndices ? Vector.<int>( [ newIndex ] ).concat( renderer.selectedIndices ) : Vector.<int>( [ newIndex ] );
//			
//			_itemMouseDowns = true;
//			//			_itemMouseDowns = true;
//			super.item_mouseDownHandler(event);
//			_itemMouseDowns = false;
//			//dispatchEvent( event );
//		}
		
		/**
		 *  @private
		 */
		protected function onRendererClick(event:MouseEvent):void
		{
			const renderer:List = List( event.currentTarget );
			if( renderer.dataProvider && renderer.dataProvider.length > 1 && !allowBranchSelection ) return;
			
			var newIndex:int
			if (event.currentTarget is IItemRenderer)
				newIndex = IItemRenderer(event.currentTarget).itemIndex;
			else
				newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
			
			
			
//			_proposedSelectedIndices = renderer.selectedIndices ? Vector.<int>( [ newIndex ] ).concat( renderer.selectedIndices ) : Vector.<int>( [ newIndex ] );
			
//			_itemMouseDowns = true;
			//			_itemMouseDowns = true;
//			super.item_mouseDownHandler(event);
//			_itemMouseDowns = false;
			//dispatchEvent( event );
		}
		
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if( _renderersInvalid )
			{
				_renderersInvalid = false;
				if( dataGroup )
				{
					var renderer:IVisualElement;
					for( var i:int = 0; i < dataGroup.numElements; i++ )
					{
						renderer = dataGroup.getElementAt( i )
						if( renderer ) updateRenderer( renderer, i, dataProvider.getItemAt( i ) );
					}
				}
			}
		}
		
		private function recurseDataProviderSelectedIndices( dp:IList, indices:Vector.<int> = null ):Vector.<int>
		{
			if( dp is ISelectableList )
			{
				const index:int = ISelectableList( dp ).selectedIndex;
				const item:Object = dp.getItemAt( index );
				if( !indices ) indices = new Vector.<int>();
				indices.push( index );
				if( item is IList ) return recurseDataProviderSelectedIndices( IList( item ), indices );
			}
			else if( selectedIndex != -1 )
			{
				if( !indices ) indices = new Vector.<int>();
				indices.push( selectedIndex );
			}
			return indices;
		}
		
		
		/**
		 *  @private
		 *  Used internally to specify whether the selectedIndex changed programmatically or due to 
		 *  user interaction. 
		 * 
		 *  @param dispatchChangeEvent if true, the component will dispatch a "change" event if the
		 *  value has changed. Otherwise, it will dispatch a "valueCommit" event. 
		 */
		override mx_internal function setSelectedIndex(value:int, dispatchChangeEvent:Boolean = false):void
		{
			var changed:Boolean;
			if( !_proposedSelectedIndices && !_selectedIndices && value > -1 )
			{
				_proposedSelectedIndices = recurseDataProviderSelectedIndices( dataProvider );
				changed = true;
			}
			else if( _selectedIndices && _proposedSelectedIndices )
			{
				changed = _selectedIndices.join() != _proposedSelectedIndices.join()
			}
			else if( !_selectedIndices && _proposedSelectedIndices ||
				_selectedIndices && !_proposedSelectedIndices )
			{
				changed = true;
			}
			
			if( changed )
			{
				if( !_proposedSelectedIndices ) _proposedSelectedIndices = recurseDataProviderSelectedIndices( dataProvider );
				
				_selectedIndices = _proposedSelectedIndices;
				_proposedSelectedIndices = null;
				
				if( _selectedIndices )
				{
					var item:Object;
					var dp:IList = dataProvider;
					const indices:Vector.<int> = _selectedIndices;
					const numItems:int = _selectedIndices.length;
					for( var i:int = 0; i < numItems; i++ )
					{
						if( dp is ISelectableList ) ISelectableList( dp ).selectedIndex = indices[ i ];
						if( i < numItems - 1 ) dp = IList( dp.getItemAt( indices[ i ] ) );
					}
				}
			}
			
			if( value == selectedIndex )
			{
				if( changed )
				{
					if( dispatchChangeEvent )
					{
						
						dispatchEvent(new IndexChangeEvent(IndexChangeEvent.CHANGE, false, false, selectedIndex, selectedIndex));
					}
					else
					{
						dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
					}
				}
			}
			else
			{
				super.setSelectedIndex( value, dispatchChangeEvent );
			}
		}
		
		
		
//		/**
//		 *  @private
//		 *  Called whenever we need to update the text passed to the labelDisplay skin part
//		 */
//		// Stops the openButton displaying the label of the selectedItem 
//		override mx_internal function updateLabelDisplay( displayItem:* = undefined ):void
//		{
//		}
		
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function updateRenderer( renderer:IVisualElement, itemIndex:int, data:Object ):void
		{
			super.updateRenderer( renderer, itemIndex, data );
			
			var listBase:ListBase = renderer as ListBase; 
			if( listBase ) 
			{
//				prompt = itemToLabel( dataProvider );
				if( dataProvider && dataProvider.getItemAt( itemIndex ) is IList )
				{
					listBase.labelField = labelField;
					listBase.labelFunction = labelFunction;
					
					if( renderer is List && selectedIndex == itemIndex && selectedIndices && selectedIndices.length > 1 )
					{
						List( renderer ).selectedIndices = selectedIndices.slice( 1 );
					}
					
					if( renderer is MenuBarItemRenderer )
					{
						MenuBarItemRenderer( renderer ).allowBranchSelection = allowBranchSelection;
						MenuBarItemRenderer( renderer ).closeOnSelection = closeOnSelection;
					}
				}
			}
		}
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			switch( instance )
			{
				case dataGroup :
				{
					dataGroup.addEventListener( RendererExistenceEvent.RENDERER_ADD, onDataGroupRendererAdd, false, 0, true );
					dataGroup.addEventListener( RendererExistenceEvent.RENDERER_REMOVE, onDataGroupRendererRemove, false, 0, true );
					break;
				}
//				case openButton :
//				{
//					openButton.addEventListener( Event.CHANGE, onOpenButtonChange, false, 0, true );
//					openButton.label = prompt;
//					break;
//				}
			}
		}
		
		/**
		 *  @private
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if( instance == dataGroup )
			{
				dataGroup.removeEventListener( RendererExistenceEvent.RENDERER_ADD, onDataGroupRendererAdd, false );
				dataGroup.removeEventListener( RendererExistenceEvent.RENDERER_REMOVE, onDataGroupRendererRemove, false );
			}
			
			super.partRemoved( partName, instance );
		}
		
//		/**
//		 *  @private
//		 *  Hack to make sure the ToggleButtonBase stays selected
//		 *  after it has been clicked on. Due to <code>selected</code>
//		 *  getting set to true, when it is clicked on it's <code>selected</code>
//		 *  is then set to not <code>selected</code>
//		 * 
//		 *  <code>selected = !selected</code>
//		 * 
//		 *  @see spark.components.supportClasses.ToggleButtonBase#buttonReleased
//		 */
//		private function onOpenButtonChange( event:Event ):void
//		{
//			if( openButton is ToggleButtonBase ) ToggleButtonBase( openButton ).selected = selected;
//		}
		
		
		
		/**
		 *  @private
		 */
		private function onDataGroupRendererAdd( event:RendererExistenceEvent ):void
		{
			
			const renderer:IVisualElement = event.renderer; 
			
			if( renderer )
			{
//				renderer.addEventListener( DropDownEvent.OPEN, onRendererOpen, false, 0, true );
//				renderer.addEventListener( DropDownEvent.CLOSE, onRendererClose, false, 0, true );
				renderer.addEventListener( IndexChangeEvent.CHANGE, onRendererChange, false, 0, true );
				renderer.addEventListener( MouseEvent.CLICK, onRendererClick, false, 1, true );
				//				if( renderer is List && selectedIndices && selectedIndices.length > 1 )
				//				{
				//					List( renderer ).selectedIndices = selectedIndices.slice( 1 );
				//				}
			}
		}
		
		/**
		 *  @private
		 */
		private function onDataGroupRendererRemove( event:RendererExistenceEvent ):void
		{
			const renderer:IVisualElement = event.renderer; 
			if( renderer )
			{
//				renderer.removeEventListener( DropDownEvent.OPEN, onRendererOpen, false );
//				renderer.removeEventListener( DropDownEvent.CLOSE, onRendererClose, false );
				renderer.removeEventListener( IndexChangeEvent.CHANGE, onRendererChange, false );
				renderer.removeEventListener( MouseEvent.CLICK, onRendererClick, false );
			}
		}
		
//		/**
//		 *  @private
//		 */
//		protected function onRendererOpen( event:DropDownEvent ):void
//		{
//			var renderer:MenuBarItemRenderer = MenuBarItemRenderer( event.currentTarget );
//			
//			if( !renderer ) return;
//			var controller:DropDownController = DropDownController( event.currentTarget[ "dropDownController" ]  );
//			var dropDown:DisplayObject = DisplayObject( event.currentTarget[ "dropDown" ] );
//			
//			if( controller.hitAreaAdditions )
//			{
//				dropDownController.hitAreaAdditions = Vector.<DisplayObject>( [ dropDown ] ).concat( controller.hitAreaAdditions );
//			}
//			else
//			{
//				dropDownController.hitAreaAdditions = Vector.<DisplayObject>( [ dropDown ] );
//			}
//			
//			dispatchEvent( event );
//		}
		
//		/**
//		 *  @private
//		 */
//		protected function onRendererClose( event:DropDownEvent ):void
//		{
//			dropDownController.hitAreaAdditions = null;
//		}
		
		/**
		 *  @private
		 */
		protected function onRendererChange( event:IndexChangeEvent ):void
		{
			var renderer:List = List( event.currentTarget );
			
			var newIndex:int
			if (event.currentTarget is IItemRenderer)
				newIndex = IItemRenderer(event.currentTarget).itemIndex;
			else
				newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
			
			
			_itemMouseDowns = true;
			_proposedSelectedIndices = renderer.selectedIndices ? Vector.<int>( [ newIndex ] ).concat( renderer.selectedIndices ) : Vector.<int>( [ newIndex ] );
			
			// Single selection case, set the selectedIndex 
			var currentRenderer:IItemRenderer;
			if (caretIndex >= 0)
			{
				currentRenderer = dataGroup.getElementAt(caretIndex) as IItemRenderer;
				if (currentRenderer)
					currentRenderer.showsCaret = false;
			}
			
			//			// Check to see if we're deselecting the currently selected item 
			//			if (event.ctrlKey && selectedIndex == newIndex)
			//			{
			//				pendingSelectionOnMouseUp = true;
			//				pendingSelectionCtrlKey = true;
			//				pendingSelectionShiftKey = event.shiftKey;
			//			}
			//			else
			setSelectedIndex( newIndex, true);
			
			
//			userProposedSelectedIndex = selectedIndex;
			
			//			super.item_mouseDownHandler(event);
			_itemMouseDowns = false;
			
			//			dispatchEvent( event );
		}
		
		
	}
}