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
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.IDataRenderer;
	import mx.core.IDeferredContentOwner;
	import mx.core.IFactory;
	import mx.core.ISelectableList;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.mx_internal;
	import mx.events.PropertyChangeEvent;
	import mx.utils.BitFlagUtil;
	
	import spark.components.IItemRenderer;
	import spark.components.IItemRendererOwner;
	import spark.components.supportClasses.SkinnableContainerBase;
	import spark.core.IViewport;
	import spark.events.RendererExistenceEvent;
	import spark.layouts.supportClasses.LayoutBase;
	
	import ws.tink.spark.controls.DataNavigator;
	import ws.tink.spark.layouts.supportClasses.INavigatorLayout;
	
	use namespace mx_internal;
	
	/**
	 *  Dispatched when a renderer is added to the container.
	 *  The <code>event.renderer</code> property contains 
	 *  the renderer that was added.
	 *
	 *  @eventType spark.events.RendererExistenceEvent.RENDERER_ADD
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="rendererAdd", type="spark.events.RendererExistenceEvent")]
	
	/**
	 *  Dispatched when a renderer is removed from the container.
	 *  The <code>event.renderer</code> property contains 
	 *  the renderer that was removed.
	 *
	 *  @eventType spark.events.RendererExistenceEvent.RENDERER_REMOVE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Event(name="rendererRemove", type="spark.events.RendererExistenceEvent")]
	
//	include "../styles/metadata/BasicInheritingTextStyles.as"
	
	/**
	 *  The alpha of the focus ring for this component.
	 *
	 *  @default 0.55
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="focusAlpha", type="Number", inherit="no", theme="spark", minValue="0.0", maxValue="1.0")]
	
	/**
	 *  Color of focus ring when the component is in focus.
	 *
	 *  @default 0x70B2EE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */ 
	[Style(name="focusColor", type="uint", format="Color", inherit="yes", theme="spark")]
	
	/**
	 *  Thickness, in pixels, of the focus rectangle outline.
	 *
	 *  @default 2
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Style(name="focusThickness", type="Number", format="Length", inherit="no", minValue="0.0")]
	
	[DefaultProperty("dataProvider")]
	
	//[IconFile("SkinnableDataContainer.png")]
	
	/**
	 *  The SkinnableDataContainer class is the base container class for
	 *  data items.  The SkinnableDataContainer class converts data 
	 *  items to visual elements for display.
	 *  While this container can hold visual elements, it is often used only 
	 *  to hold data items as children.
	 *
	 *  <p>The SkinnableDataContainer class takes as children data items 
	 *  or visual elements that implement the IVisualElement interface
	 *  and are Display Objects.
	 *  Data items can be simple data items such String and Number objects, 
	 *  and more complicated data items such as Object and XMLNode objects. 
	 *  While these containers can hold visual elements, 
	 *  they are often used only to hold data items as children.</p>
	 *
	 *  <p>An item renderer defines the visual representation of the 
	 *  data item in the container. 
	 *  The item renderer converts the data item into a format that can 
	 *  be displayed by the container. 
	 *  You must pass an item renderer to a SkinnableDataContainer to 
	 *  render data items appropriately.</p>
	 *
	 *  <p>If you want a container of data items and don't need a skin, then 
	 *  it is recommended to use a DataGroup (which cannot be skinned) to 
	 *  improve performance and application size.</p>
	 *
	 *  <p>The SkinnableDataContainer container has the following default characteristics:</p>
	 *  <table class="innertable">
	 *     <tr><th>Characteristic</th><th>Description</th></tr>
	 *     <tr><td>Default size</td><td>Large enough to display its children</td></tr>
	 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
	 *     <tr><td>Maximum size</td><td>10000 pixels wide and 10000 pixels high</td></tr>
	 *  </table>
	 * 
	 *  @mxml
	 *
	 *  <p>The <code>&lt;s:SkinnableDataContainer&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:SkinnableDataContainer
	 *    <strong>Properties</strong>
	 *    autoLayout="true"
	 *    dataProvider="null"
	 *    itemRenderer="null"
	 *    itemRendererFunction="null"
	 *    layout="VerticalLayout"
	 *    typicalItem="null"
	 *  
	 *    <strong>Styles</strong>
	 *    alignmentBaseline="useDominantBaseline"
	 *    baselineShift="0.0"
	 *    cffHinting="horizontal_stem"
	 *    color="0"
	 *    digitCase="default"
	 *    digitWidth="default"
	 *    direction="LTR"
	 *    dominantBaseline="auto"
	 *    focusAlpha="0.55"
	 *    focusColor=""
	 *    focusThickness="2"
	 *    fontFamily="Times New Roman"
	 *    fontLookup="device"
	 *    fontSize="12"
	 *    fontStyle="normal"
	 *    fontWeight="normal"
	 *    justificationRule="auto"
	 *    justificationStyle="auto"
	 *    kerning="auto"
	 *    ligatureLevel="common"
	 *    lineHeight="120%"
	 *    lineThrough="false"
	 *    locale="en"
	 *    renderingMode="CFF"
	 *    textAlign="start"
	 *    textAlignLast="start"
	 *    textAlpha="1"
	 *    textJustify="inter_word"
	 *    trackingLeft="0"
	 *    trackingRight="0"
	 *    typographicCase="default"
	 *  
	 *    <strong>Events</strong>
	 *    rendererAdd="<i>No default</i>"
	 *    rendererRemove="<i>No default</i>"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see SkinnableContainer
	 *  @see DataGroup
	 *  @see spark.skins.spark.SkinnableDataContainerSkin
	 *
	 *  @includeExample examples/SkinnableDataContainerExample.mxml
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class DataNavigator extends SkinnableContainerBase implements IItemRendererOwner, ISelectableList
	{
//			include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private static const AUTO_LAYOUT_PROPERTY_FLAG:uint = 1 << 0;
		
		/**
		 *  @private
		 */
		private static const DATA_PROVIDER_PROPERTY_FLAG:uint = 1 << 1;
		
		/**
		 *  @private
		 */
		private static const ITEM_RENDERER_PROPERTY_FLAG:uint = 1 << 2;
		
		/**
		 *  @private
		 */
		private static const ITEM_RENDERER_FUNCTION_PROPERTY_FLAG:uint = 1 << 3;
		
		/**
		 *  @private
		 */
		private static const LAYOUT_PROPERTY_FLAG:uint = 1 << 4;
		
		/**
		 *  @private
		 */
		private static const TYPICAL_ITEM_PROPERTY_FLAG:uint = 1 << 5;
		
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
		public function DataNavigator()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		
		[SkinPart(required="false")]
		
		/**
		 *  An optional skin part that defines the DataGroup in the skin class 
		 *  where data items get pushed into, rendered, and laid out.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var contentGroup:DataNavigatorGroup;
		
		/**
		 *  @private
		 *  Several properties are proxied to contentGroup.  However, when contentGroup
		 *  is not around, we need to store values set on SkinnableDataContainer.  This object 
		 *  stores those values.  If contentGroup is around, the values are stored 
		 *  on the contentGroup directly.  However, we need to know what values 
		 *  have been set by the developer on the SkinnableDataContainer (versus set on 
		 *  the contentGroup or defaults of the contentGroup) as those are values 
		 *  we want to carry around if the contentGroup changes (via a new skin). 
		 *  In order to store this info effeciently, dataGroupProperties becomes 
		 *  a uint to store a series of BitFlags.  These bits represent whether a 
		 *  property has been explicitly set on this SkinnableDataContainer.  When the 
		 *  contentGroup is not around, dataGroupProperties is a typeless 
		 *  object to store these proxied properties.  When contentGroup is around,
		 *  dataGroupProperties stores booleans as to whether these properties 
		 *  have been explicitly set or not.
		 */
		private var dataGroupProperties:Object = {};
		
		//--------------------------------------------------------------------------
		//
		//  Properties 
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties proxied to contentGroup
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  autoLayout
		//----------------------------------
		
		[Inspectable(defaultValue="true")]
		
		/**
		 *  @copy spark.components.supportClasses.GroupBase#autoLayout
		 *
		 *  @default true
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get autoLayout():Boolean
		{
			if (contentGroup)
				return contentGroup.autoLayout;
			else
			{
				// want the default to be true
				var v:* = dataGroupProperties.autoLayout;
				return (v === undefined) ? true : v;
			}
		}
		
		/**
		 *  @private
		 */
		public function set autoLayout(value:Boolean):void
		{
			if (contentGroup)
			{
				contentGroup.autoLayout = value;
				dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
					AUTO_LAYOUT_PROPERTY_FLAG, true);
			}
			else
				dataGroupProperties.autoLayout = value;
		}
		
		//----------------------------------
		//  dataProvider
		//----------------------------------    
		
		/**
		 *  @copy spark.components.DataGroup#dataProvider
		 *
		 *  @see #itemRenderer
		 *  @see #itemRendererFunction
		 *  @see mx.collections.IList
		 *  @see mx.collections.ArrayCollection
		 *  @see mx.collections.ArrayList
		 *  @see mx.collections.XMLListCollection
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		[Bindable("dataProviderChanged")]
		
		public function get dataProvider():IList
		{       
			return (contentGroup) 
			? contentGroup.dataProvider 
				: dataGroupProperties.dataProvider;
		}
		
		public function set dataProvider(value:IList):void
		{
			if (contentGroup)
			{
				contentGroup.dataProvider = value;
				dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
					DATA_PROVIDER_PROPERTY_FLAG, true);
			}
			else
				dataGroupProperties.dataProvider = value;
			dispatchEvent(new Event("dataProviderChanged"));
		}
		
		//----------------------------------
		//  itemRenderer
		//----------------------------------
		
		/**
		 *  @copy spark.components.DataGroup#itemRenderer
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get itemRenderer():IFactory
		{
			return (contentGroup) 
			? contentGroup.itemRenderer 
				: dataGroupProperties.itemRenderer;
		}
		
		/**
		 *  @private
		 */
		public function set itemRenderer(value:IFactory):void
		{
			if (contentGroup)
			{
				contentGroup.itemRenderer = value;
				dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
					ITEM_RENDERER_PROPERTY_FLAG, true);
			}
			else
				dataGroupProperties.itemRenderer = value;
		}
		
		//----------------------------------
		//  itemRendererFunction
		//----------------------------------
		
		/**
		 *  @copy spark.components.DataGroup#itemRendererFunction
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get itemRendererFunction():Function
		{
			return (contentGroup) 
			? contentGroup.itemRendererFunction 
				: dataGroupProperties.itemRendererFunction;
		}
		
		/**
		 *  @private
		 */
		public function set itemRendererFunction(value:Function):void
		{
			if (contentGroup)
			{
				contentGroup.itemRendererFunction = value;
				dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
					ITEM_RENDERER_FUNCTION_PROPERTY_FLAG, true);
			}
			else
				dataGroupProperties.itemRendererFunction = value;
		}
		
		//----------------------------------
		//  layout
		//----------------------------------
		
		/**
		 *  @copy spark.components.supportClasses.GroupBase#layout
		 *
		 *  @default VerticalLayout
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */     
		public function get layout():LayoutBase
		{
			return (contentGroup) 
			? contentGroup.layout 
				: dataGroupProperties.layout;
		}
		
		/**
		 *  @private
		 */
		public function set layout(value:LayoutBase):void
		{
			if( value is INavigatorLayout )
			{
				if (contentGroup)
				{
					contentGroup.layout = value;
					dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
						LAYOUT_PROPERTY_FLAG, true);
				}
				else
					dataGroupProperties.layout = value;
			}
			else
			{
				throw new Error( "Layout must implement INavigatorLayout" );
			}
		}
		
		//----------------------------------
		//  typicalItem
		//----------------------------------
		
		/**
		 *  @copy spark.components.DataGroup#typicalItem
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get typicalItem():Object
		{
			return (contentGroup) 
			? contentGroup.typicalItem 
				: dataGroupProperties.typicalItem;
		}
		
		/**
		 *  @private
		 */
		public function set typicalItem(value:Object):void
		{
			if (contentGroup)
			{
				contentGroup.typicalItem = value;
				dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
					TYPICAL_ITEM_PROPERTY_FLAG, true);
			}
			else
				dataGroupProperties.typicalItem = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  From the specified data item, return the String representation 
		 *  of the data item for an item renderer to display.
		 *  This method uses the <code>toString()</code> method of 
		 *  the data item to convert it to a String representation.
		 *  A Null data item returns an empty string.
		 *
		 *  @param item The data item.
		 *
		 *  @return The String representation of the data item.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function itemToLabel(item:Object):String
		{
			if (item !== null)
				return item.toString();
			else return " ";
		}
		
		/**
		 *  Updates an item renderer for use or reuse. 
		 *  When an item renderer is first created,
		 *  or when it is recycled because of virtualization, this 
		 *  SkinnableDataContainer instance can set the 
		 *  item renderer's <code>label</code> property and 
		 *  <code>owner</code> property. 
		 *  
		 *  @param renderer The renderer being updated 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 * 
		 */
		public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
		{
			// set the owner
			renderer.owner = this;
			
			// Set the index
			if (renderer is IItemRenderer)
				IItemRenderer(renderer).itemIndex = itemIndex;
			
			// set the label to the toString() of the data 
			if (renderer is IItemRenderer)
				IItemRenderer(renderer).label = itemToLabel(data);
			
			// always set the data last
			if ((renderer is IDataRenderer) && (renderer !== data))
				IDataRenderer(renderer).data = data;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == contentGroup)
			{
				// copy proxied values from dataGroupProperties (if set) to contentGroup
				
				var newDataGroupProperties:uint = 0;
				
				if (dataGroupProperties.layout !== undefined)
				{
					contentGroup.layout = dataGroupProperties.layout;
					newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
						LAYOUT_PROPERTY_FLAG, true);;
				}
				
				if (dataGroupProperties.autoLayout !== undefined)
				{
					contentGroup.autoLayout = dataGroupProperties.autoLayout;
					newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
						AUTO_LAYOUT_PROPERTY_FLAG, true);
				}
				
				if (dataGroupProperties.dataProvider !== undefined)
				{
					contentGroup.dataProvider = dataGroupProperties.dataProvider;
					newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
						DATA_PROVIDER_PROPERTY_FLAG, true);
				}
				
				if (dataGroupProperties.itemRenderer !== undefined)
				{
					contentGroup.itemRenderer = dataGroupProperties.itemRenderer;
					newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
						ITEM_RENDERER_PROPERTY_FLAG, true);
				}
				
				if (dataGroupProperties.itemRendererFunction !== undefined)
				{
					contentGroup.itemRendererFunction = dataGroupProperties.itemRendererFunction;
					newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
						ITEM_RENDERER_FUNCTION_PROPERTY_FLAG, true);
				}
				
				if (dataGroupProperties.typicalItem !== undefined)
				{
					contentGroup.typicalItem = dataGroupProperties.typicalItem;
					newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
						TYPICAL_ITEM_PROPERTY_FLAG, true);
				}
				
				dataGroupProperties = newDataGroupProperties;
				
				// Register our instance as the contentGroup's item renderer update delegate.
				contentGroup.rendererUpdateDelegate = this;
				
				// The only reason we have these listeners is to re-dispatch events.  
				// We only add as necessary.
				
				if (hasEventListener(RendererExistenceEvent.RENDERER_ADD))
				{
					contentGroup.addEventListener(
						RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
				}
				
				if (hasEventListener(RendererExistenceEvent.RENDERER_REMOVE))
				{
					contentGroup.addEventListener(
						RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
				}
			}
		}
		
		/**
		 * @private
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == contentGroup)
			{
				contentGroup.removeEventListener(
					RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
				contentGroup.removeEventListener(
					RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
				
				// copy proxied values from contentGroup (if explicitly set) to dataGroupProperties
				
				var newDataGroupProperties:Object = {};
				
				if (BitFlagUtil.isSet(dataGroupProperties as uint, LAYOUT_PROPERTY_FLAG))
					newDataGroupProperties.layout = contentGroup.layout;
				
				if (BitFlagUtil.isSet(dataGroupProperties as uint, AUTO_LAYOUT_PROPERTY_FLAG))
					newDataGroupProperties.autoLayout = contentGroup.autoLayout;
				
				if (BitFlagUtil.isSet(dataGroupProperties as uint, DATA_PROVIDER_PROPERTY_FLAG))
					newDataGroupProperties.dataProvider = contentGroup.dataProvider;
				
				if (BitFlagUtil.isSet(dataGroupProperties as uint, ITEM_RENDERER_PROPERTY_FLAG))
					newDataGroupProperties.itemRenderer = contentGroup.itemRenderer;
				
				if (BitFlagUtil.isSet(dataGroupProperties as uint, ITEM_RENDERER_FUNCTION_PROPERTY_FLAG))
					newDataGroupProperties.itemRendererFunction = contentGroup.itemRendererFunction;
				
				if (BitFlagUtil.isSet(dataGroupProperties as uint, TYPICAL_ITEM_PROPERTY_FLAG))
					newDataGroupProperties.typicalItem = contentGroup.typicalItem;
				
				dataGroupProperties = newDataGroupProperties;
				
				contentGroup.dataProvider = null;
				contentGroup.layout = null;
				contentGroup.rendererUpdateDelegate = null;
			}
		}
		
		/**
		 *  @private
		 * 
		 *  This method is overridden so we can figure out when someone starts listening
		 *  for property change events.  If no one's listening for them, then we don't 
		 *  listen for them on our contentGroup.
		 */
		override public function addEventListener(
			type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false) : void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			// TODO (rfrishbe): this isn't ideal as we should deal with the useCapture, 
			// priority, and useWeakReference parameters.
			
			// if it's a different type of event or the contentGroup doesn't
			// exist, don't worry about it.  When the contentGroup, 
			// gets created up, we'll check to see whether we need to add this 
			// event listener to the contentGroup.
			
			if (type == RendererExistenceEvent.RENDERER_ADD && contentGroup)
			{
				contentGroup.addEventListener(
					RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
			}
			
			if (type == RendererExistenceEvent.RENDERER_REMOVE && contentGroup)
			{
				contentGroup.addEventListener(
					RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
			}
		}
		
		/**
		 *  @private
		 * 
		 *  This method is overridden so we can figure out when someone stops listening
		 *  for property change events.  If no one's listening for them, then we don't 
		 *  listen for them on our contentGroup.
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false) : void
		{
			super.removeEventListener(type, listener, useCapture);
			
			// if no one's listening to us for this event any more, let's 
			// remove our underlying event listener from the contentGroup.
			if (type == RendererExistenceEvent.RENDERER_ADD && contentGroup)
			{
				if (!hasEventListener(RendererExistenceEvent.RENDERER_ADD))
				{
					contentGroup.removeEventListener(
						RendererExistenceEvent.RENDERER_ADD, dispatchEvent);
				}
			}
			
			if (type == RendererExistenceEvent.RENDERER_REMOVE && contentGroup)
			{
				if (!hasEventListener(RendererExistenceEvent.RENDERER_REMOVE))
				{
					contentGroup.removeEventListener(
						RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
				}
			}
		}
		
		
		
		
		/**
		 *  @private
		 *  IList implementation of selectedIndex sets
		 *  StackLayout( layout ).focusedIndex
		 */
		public function set selectedIndex( value:int ):void
		{
			INavigatorLayout( layout ).selectedIndex = value;
		}
		
		/**
		 *  @private
		 *  IList implementation of selectedIndex returns
		 *  StackLayout( layout ).focusedIndex
		 */
		public function get selectedIndex():int
		{
			return INavigatorLayout( layout ).selectedIndex;
		}
		
		/**
		 *  @private
		 *  IList implementation of length returns numChildren
		 */
		public function get length():int
		{
			return ( dataProvider ) ? dataProvider.length : 0;
		}
		
		/**
		 *  @private
		 *  IList implementation of addItem calls addChild
		 */
		public function addItem( item:Object ):void
		{
			addItemAt( item, length );
		}
		
		/**
		 *  @private
		 *  IList implementation of addItemAt calls addChildAt
		 */
		public function addItemAt( item:Object, index:int ):void
		{
			var dp:IList = ( !dataProvider ) ? new ArrayList() : dataProvider;
			dp.addItemAt( item, index );
		}
		
		/**
		 *  @private
		 *  IList implementation of getItemAt calls getVirtualElementAt
		 */
		public function getItemAt( index:int, prefetch:int = 0 ):Object
		{
			if( length <= index ) return null;
			return  dataProvider.getItemAt( index );
		}
		
		/**
		 *  @private
		 *  IList implementation of getItemIndex calls getElementIndex
		 */
		public function getItemIndex( item:Object ):int
		{
			if( !dataProvider ) return -1;
			return dataProvider.getItemIndex( item );
		}
		
		/**
		 *  @private
		 *  IList implementation of itemUpdated doesn't do anything
		 */
		public function itemUpdated( item:Object, property:Object=null, oldValue:Object=null, newValue:Object=null ):void
		{
		}
		
		/**
		 *  @private
		 *  IList implementation of removeAll calls removeAllElements
		 */
		public function removeAll():void
		{
			if( !dataProvider ) return;
			dataProvider.removeAll();
		}
		
		/**
		 *  @private
		 *  IList implementation of removeItemAt calls removeElementAt
		 */
		public function removeItemAt( index:int ):Object
		{
			if( !dataProvider || index >= length ) return null;
			return dataProvider.removeItemAt( index );
		}
		
		/**
		 *  @private
		 *  IList implementation of setItemAt calls removeElementAt
		 *  to remove the old child and removeElementAt to add the
		 *  new one.
		 */
		public function setItemAt(item:Object, index:int):Object
		{
			if( !dataProvider || index > length ) return null;
			return dataProvider.setItemAt( item, index );
		}
		
		/**
		 *  @private
		 *  IList implementation of toArray returns array of children
		 */
		public function toArray():Array
		{
			return ( !dataProvider ) ? null : dataProvider.toArray();
		}
	}
}