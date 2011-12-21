/*

Copyright (c) 2011 Tink Ltd - http://www.tink.ws

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

package ws.tink.spark.itemRenderers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.ISelectableList;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	
	import spark.components.DropDownList;
	import spark.components.IItemRenderer;
	import spark.components.List;
	import spark.components.supportClasses.DropDownController;
	import spark.components.supportClasses.ListBase;
	import spark.components.supportClasses.ToggleButtonBase;
	import spark.events.DropDownEvent;
	import spark.events.IndexChangeEvent;
	import spark.events.RendererExistenceEvent;
	
	use namespace mx_internal;
	
	public class MenuBarItemRenderer extends DropDownList implements IItemRenderer
	{

		/**
		 *  @private
		 */    
		override public function set dataProvider(value:IList):void
		{
			if (dataProvider is ISelectableList)
			{
				dataProvider.removeEventListener(FlexEvent.VALUE_COMMIT, dataProvider_changeHandler);
				dataProvider.removeEventListener(IndexChangedEvent.CHANGE, dataProvider_changeHandler);
			}
			
			if (value is ISelectableList)
			{
				value.addEventListener(FlexEvent.VALUE_COMMIT, dataProvider_changeHandler, false, 0, true);
				value.addEventListener(IndexChangedEvent.CHANGE, dataProvider_changeHandler, false, 0, true);
			}
			
			super.dataProvider = value;
			
			if (value is ISelectableList)
				selectedIndex = ISelectableList(dataProvider).selectedIndex;
		}  
		
		/**
		 *  @private
		 */
		private function dataProvider_changeHandler(event:Event):void
		{
			selectedIndex = ISelectableList(dataProvider).selectedIndex;
		}
		
		
		
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
		public function MenuBarItemRenderer()
		{
			super();
			
			allowMultipleSelection = false;
			dropDownController.rollOverOpenDelay = 5;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Flag to indicate that selection is taking place.
		 */
		private var _itemMouseDowns:Boolean;
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  data
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the data property. 
		 */
		private var _data:Object;
		
		/**
		 *  @inheritDoc
		 */
		public function get data():Object
		{
			return _data;
		}
		/**
		 *  @private
		 */
		public function set data(value:Object):void
		{
			if( _data == value ) return;
			
			_data = value;
			
			if( _data is IList ) dataProvider = _data as IList;
			invalidateSkinState();
		}
		
		
		//----------------------------------
		//  itemIndex
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the itemIndex property. 
		 */
		private var _itemIndex:int;
		
		/**
		 *  @inheritDoc
		 */
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		/**
		 *  @private
		 */
		public function set itemIndex(value:int):void
		{
			_itemIndex = value;
		}
		
		
		//----------------------------------
		//  label
		//----------------------------------
		
		/**
		 *  @inheritDoc
		 */
		public function get label():String
		{
			return prompt;
		}
		/**
		 *  @private
		 */
		public function set label( value:String ):void
		{
			if( prompt == value ) return;
			
			prompt = value;
		}
		
		
		//----------------------------------
		//  selected
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the selected property. 
		 */
		private var _selected:Boolean;
		
		/**
		 *  @inheritDoc
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		/**
		 *  @private
		 */
		public function set selected(value:Boolean):void
		{
			if( _selected == value ) return;
			
			_selected = value;

			if( openButton && openButton is ToggleButtonBase ) ToggleButtonBase( openButton ).selected = _selected;
			
			if( !_selected )
			{
				selectedIndices = null;
			}
		}
		
		
		//----------------------------------
		//  closeOnSelection
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the closeOnSelection property. 
		 */
		private var _closeOnSelection:Boolean = true;
		
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
		}
		
		
		//----------------------------------
		//  dragging
		//----------------------------------
		
		/**
		 *  Ths property cannot be set and will always remain false.
		 * 
		 *  @default false
		 */
		public function get dragging():Boolean
		{
			return false;
		}
		/**
		 *  @private
		 */
		public function set dragging(value:Boolean):void
		{
		}
		
		
		//----------------------------------
		//  showsCaret
		//----------------------------------
		
		/**
		 *  Ths property cannot be set and will always remain false.
		 * 
		 *  @default false
		 */
		public function get showsCaret():Boolean
		{
			return false;
		}
		/**
		 *  @private
		 */
		public function set showsCaret(value:Boolean):void
		{
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
		
		/**
		 *  A Vector of ints representing the indices of the currently selected  
		 *  item or items. 
		 *
		 *  <p>The first index represents the selectedItem of this DropDownList and each further
		 *  index represents the selectedItem of the selectedItem.</p>
		 *  
		 *  @default []
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override public function get selectedIndices():Vector.<int>
		{
			return _proposedSelectedIndices ? _proposedSelectedIndices : _selectedIndices;
		}
		/**
		 *  @private
		 */		
		override public function set selectedIndices(value:Vector.<int>):void
		{
			if( _selectedIndices == value ) return;
			
			_selectedIndices = value;
			
			selectedIndex = _selectedIndices && _selectedIndices.length ? _selectedIndices[ 0 ] : -1;
			if( dataGroup && _selectedIndices && _selectedIndices.length > 1 )
			{
				 const list:List = List( dataGroup.getElementAt( _selectedIndices[ 1 ] ) );
				 list.selectedIndices = _selectedIndices.slice( 1 );
			}
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
			invalidateSkinState();
		}

		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @inheritDoc
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override public function get isDropDownOpen():Boolean
		{
			if (dropDownController && dataProvider && dataProvider.length)
				return dropDownController.isOpen;
			else
				return false;
		}
		
		/**
		 *  @inheritDoc
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override public function closeDropDown(commit:Boolean):void
		{
			// If the mouse is down (our custom flag)
			// and _closeOnSelection is false, do not close.
			if( _itemMouseDowns && !_closeOnSelection ) return;
			dropDownController.closeDropDown(commit);
		}
		
		/**
		 *  @private
		 */
		override public function updateRenderer( renderer:IVisualElement, itemIndex:int, data:Object ):void
		{
			super.updateRenderer( renderer, itemIndex, data );
			
			var listBase:ListBase = renderer as ListBase; 
			if( listBase ) 
			{
				prompt = itemToLabel( dataProvider );
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
		override protected function partAdded( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );
			
			if( instance == openButton )
			{
				openButton.addEventListener( Event.CHANGE, onOpenButtonChange, false, 0, true );
				openButton.label = prompt;
			}
		}
		
		
		/**
		 *  @private
		 */
		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partRemoved( partName, instance );
		
			if( instance == openButton )
			{
				openButton.removeEventListener( Event.CHANGE, onOpenButtonChange, false );
			}
		}
		
		/**
		 *  @private
		 */ 
		override protected function getCurrentSkinState():String
		{
			var branch:String = "";
			if( !_allowBranchSelection && 
				dataProvider && 
				dataProvider.length )
			{
				branch = "Branch";
			}
			return super.getCurrentSkinState() + branch;
		} 
		
		/**
		 *  @private
		 *  Used internally to specify whether the selectedIndex changed programmatically or due to 
		 *  user interaction. 
		 * 
		 *  @param dispatchChangeEvent if true, the component will dispatch a "change" event if the
		 *  value has changed. Otherwise, it will dispatch a "valueCommit" event. 
		 */
		override mx_internal function setSelectedIndex( value:int, dispatchChangeEvent:Boolean = false, changeCaret:Boolean = true):void
		{
			var changed:Boolean;
			
			if( _itemMouseDowns )
			{
				if( _selectedIndices && _proposedSelectedIndices )
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
					_selectedIndices = _proposedSelectedIndices;
					_proposedSelectedIndices = null;
				}
			}
			
			if( value == selectedIndex )
			{
				if( changed )
				{
					if( dispatchChangeEvent )
					{
						dispatchEvent( new IndexChangeEvent( IndexChangeEvent.CHANGE, false, false, selectedIndex, selectedIndex ) );
					}
					else
					{
						dispatchEvent( new FlexEvent( FlexEvent.VALUE_COMMIT ) );
					}
				}
			}
			else
			{
				super.setSelectedIndex( value, dispatchChangeEvent, changeCaret );
			}
			
			_proposedSelectedIndices = null;
		}
		
		/**
		 *  @private
		 *  Called whenever we need to update the text passed to the labelDisplay skin part
		 */
		override mx_internal function updateLabelDisplay( displayItem:* = undefined ):void
		{
			// Stops the openButton displaying the label of the selectedItem.
			if( openButton ) openButton.label = prompt;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Listeners
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Hack to make sure the ToggleButtonBase stays selected
		 *  after it has been clicked on. Due to <code>selected</code>
		 *  getting set to true, when it is clicked on it's <code>selected</code>
		 *  is then set to not <code>selected</code>
		 * 
		 *  <code>selected = !selected</code>
		 * 
		 *  @see spark.components.supportClasses.ToggleButtonBase#buttonReleased
		 */
		private function onOpenButtonChange( event:Event ):void
		{
			if( openButton is ToggleButtonBase ) ToggleButtonBase( openButton ).selected = selected;
		}
		
		/**
		 *  @private
		 */
		protected function onRendererOpen( event:DropDownEvent ):void
		{
			var renderer:MenuBarItemRenderer = MenuBarItemRenderer( event.currentTarget );
			
			if( !renderer ) return;
			var controller:DropDownController = DropDownController( event.currentTarget[ "dropDownController" ]  );
			var dropDown:DisplayObject = DisplayObject( event.currentTarget[ "dropDown" ] );
			
			if( controller.hitAreaAdditions )
			{
				dropDownController.hitAreaAdditions = Vector.<DisplayObject>( [ dropDown ] ).concat( controller.hitAreaAdditions );
			}
			else
			{
				dropDownController.hitAreaAdditions = Vector.<DisplayObject>( [ dropDown ] );
			}
			
			dispatchEvent( event );
		}
		
		/**
		 *  @private
		 */
		protected function onRendererClose( event:DropDownEvent ):void
		{
			dropDownController.hitAreaAdditions = null;
		}
		
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
			
			setSelectedIndex( newIndex, true);
			
			userProposedSelectedIndex = selectedIndex;
			closeDropDown( true );
			
			_itemMouseDowns = false;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Event Listeners
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler( event );
			const renderer:IVisualElement = event.renderer; 
			if( renderer )
			{
				renderer.addEventListener( DropDownEvent.OPEN, onRendererOpen, false, 0, true );
				renderer.addEventListener( DropDownEvent.CLOSE, onRendererClose, false, 0, true );
				renderer.addEventListener( IndexChangeEvent.CHANGE, onRendererChange, false, 0, true );
			}
		}
		
		/**
		 *  @private
		 */
		override protected function dataGroup_rendererRemoveHandler( event:RendererExistenceEvent ):void
		{
			super.dataGroup_rendererRemoveHandler( event );
			const renderer:IVisualElement = event.renderer; 
			if( renderer )
			{
				renderer.removeEventListener( DropDownEvent.OPEN, onRendererOpen, false );
				renderer.removeEventListener( DropDownEvent.CLOSE, onRendererClose, false );
				renderer.removeEventListener( IndexChangeEvent.CHANGE, onRendererChange, false );
			}
		}
		
		/**
		 *  @private
		 */
		override protected function item_mouseDownHandler(event:MouseEvent):void
		{
			// Hack to get round that fact that ButtonBase now calls event.preventDefault()
			// on MouseEvent.MOUSE_DOWN (see spark.components.supportClasses.ButtnBase line 1345 )
			// and List checks event.isDefaultPrevented() and returns out of this method before
			// preforming any selection (see spark.components.List line 1745).
			// To get around this a clone of the event is dispatched from the currentTarget,
			// which will generate the required event without default preventDefault() being
			// invoked on it.
			if( event.isDefaultPrevented() )
			{
				IEventDispatcher( event.currentTarget ).dispatchEvent( MouseEvent( event.clone() ) );
				return;
			}
			
			const renderer:List = List( event.currentTarget );
			if( renderer.dataProvider && renderer.dataProvider.length > 1 && !allowBranchSelection ) return;
			
			var newIndex:int
			if (event.currentTarget is IItemRenderer)
				newIndex = IItemRenderer(event.currentTarget).itemIndex;
			else
				newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
			
			
			_proposedSelectedIndices = renderer.selectedIndices ? Vector.<int>( [ newIndex ] ).concat( renderer.selectedIndices ) : Vector.<int>( [ newIndex ] );
			
			_itemMouseDowns = true;
			//			_itemMouseDowns = true;
			super.item_mouseDownHandler(event);
			_itemMouseDowns = false;
			//dispatchEvent( event );
		}
		
		/**
		 *  @private
		 *  Hack to prevent setSelectedIndex being invoked when the dropdown is closed.
		 */
		override protected function dropDownController_closeHandler(event:DropDownEvent):void
		{
			event.preventDefault();
			super.dropDownController_closeHandler(event);
		}
		
		
		/**
		 *  @private
		 *  Called when contents within the dataProvider changes.  
		 *
		 *  @param event The collection change event
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function dataProvider_collectionChangeHandler(event:Event):void
		{
			invalidateSkinState();
			super.dataProvider_collectionChangeHandler( event );
		}
		
	}
}