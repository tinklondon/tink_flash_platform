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

package ws.tink.spark.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.ISelectableList;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	
	import spark.components.ButtonBar;
	import spark.components.IItemRenderer;
	import spark.components.List;
	import spark.components.supportClasses.ListBase;
	import spark.events.IndexChangeEvent;
	import spark.events.RendererExistenceEvent;
	
	import ws.tink.spark.itemRenderers.MenuBarItemRenderer;
	
	use namespace mx_internal;
	
	public class MenuBar extends ButtonBar
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
		public function MenuBar()
		{
			super();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Flag to indicate that the renderers need updating.
		 */
		private var _renderersInvalid:Boolean;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  closeOnSelection
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the closeOnSelection property. 
		 */
		private var _closeOnSelection:Boolean = true;
		
		/**
		 *  Specifies whether the menu bar should close all its
		 *  dropdowns immediately after the user has selected an item.
		 *  
		 *  @default true
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
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
		 *  Whether or not a branch in the hierarchical data can be selected.
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
		public function set selectedIndices( value:Vector.<int> ):void
		{
			const indices:Vector.<int> = selectedIndices;
			
			if( !indices && !value )
			{
				return;
			}
			else if( !indices && value ||
					 indices && !value )
			{
				_selectedIndices = value ? value.concat() : null;
			}
			else if( indices.toString() != indices.toString() )
			{
				_selectedIndices = value.concat();
			}
			else
			{
				return;
			}
			
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
		/**
		 *  @private
		 */
		public function set selectedLabels( value:Vector.<String> ):void
		{
			if( value && dataProvider )
			{
				var dp:IList = dataProvider;
				var indices:Vector.<int> = new Vector.<int>();
				var index:int;
				var item:Object;
				var numLabels:int = value.length;
				var numDPItems:int;
				for( var i:int = 0; i < numLabels; i++ )
				{
					numDPItems = dp.length;
					for( var d:int = 0; d < numDPItems; d++ )
					{
						item = dp.getItemAt( d );
						if( itemToLabel( item ) == value[ i ] )
						{
							indices.push( d );
							if( i < numLabels - 1 && item is IList )
							{
								dp = IList( item ); 
							}
							break;
						}
					}
				}
				
				selectedIndices = indices;
			}
		}
		
		
		
		
		
//		private var _itemMouseDowns:Boolean;
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Util function to recurse through the hierarchical dataProvider
		 *  and find the selectedIndices if items implement ISelectableList.
		 */
		private function recurseDataProviderSelectedIndices( dp:IList, indices:Vector.<int> = null ):Vector.<int>
		{
			if( dp is ISelectableList )
			{
				const index:int = ISelectableList( dp ).selectedIndex;
				if( index != -1 )
				{
				const item:Object = dp.getItemAt( index );
				if( !indices ) indices = new Vector.<int>();
				indices.push( index );
				if( item is IList ) return recurseDataProviderSelectedIndices( IList( item ), indices );
				}
			}
			else if( selectedIndex != -1 )
			{
				if( !indices ) indices = new Vector.<int>();
				indices.push( selectedIndex );
			}
			return indices;
		}
		
		
		
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
		
		
//		/**
//		 *  @private
//		 */
//		protected function onRendererClick(event:MouseEvent):void
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
////			_proposedSelectedIndices = renderer.selectedIndices ? Vector.<int>( [ newIndex ] ).concat( renderer.selectedIndices ) : Vector.<int>( [ newIndex ] );
//			
////			_itemMouseDowns = true;
//			//			_itemMouseDowns = true;
////			super.item_mouseDownHandler(event);
////			_itemMouseDowns = false;
//			//dispatchEvent( event );
//		}
		
		
		
		
		
		
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
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Listeners
		//
		//--------------------------------------------------------------------------
		
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
			_renderersInvalid = true;
			super.dataProvider_collectionChangeHandler( event );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Event Listeners
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function dataGroup_rendererAddHandler( event:RendererExistenceEvent ):void
		{
			super.dataGroup_rendererAddHandler( event );
			
			const renderer:IVisualElement = event.renderer; 
			if( renderer )
			{
				renderer.addEventListener( IndexChangeEvent.CHANGE, onRendererChange, false, 0, true );
				renderer.addEventListener( MouseEvent.CLICK, onRendererClick, false, 1, true );
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
				renderer.removeEventListener( IndexChangeEvent.CHANGE, onRendererChange, false );
				renderer.removeEventListener( MouseEvent.CLICK, onRendererClick, false );
			}
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
			
			
//			_itemMouseDowns = true;
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
			
//			_itemMouseDowns = false;
		}
		
		/**
		 *  @private
		 */
		private function onRendererClick( event:MouseEvent ):void
		{
			const renderer:List = List( event.currentTarget );
			if( renderer.dataProvider && renderer.dataProvider.length > 1 && !allowBranchSelection ) event.stopImmediatePropagation();
		}
		
	}
}