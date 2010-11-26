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
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import spark.components.List;
	
	import ws.tink.spark.itemRenderers.IPropertyItemRenderer;
	
	public class PropertiesList extends List
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
		public function PropertiesList()
		{
			super();
			
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private const UI_COMPONENT_EVENTS:Array = [ 
			FlexEvent.CREATION_COMPLETE,
			FlexEvent.VALUE_COMMIT,
			FlexEvent.UPDATE_COMPLETE,
			FlexEvent.SHOW,
			FlexEvent.HIDE ]
		
		private const DISPLAY_OBJECT_EVENTS:Array = [
			Event.ADDED,
			Event.ADDED_TO_STAGE,
			Event.REMOVED,
			Event.REMOVED_FROM_STAGE ];
		
		private var _propertiesChanged:Boolean;
		private var _valuesChanged:Boolean;
		/**
		 *  @private
		 */
		private var _eventsChanged:Boolean;
		
		/**
		 *  @private
		 */
		private var _sourceChanged:Boolean;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  events
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _events:Array;
		
		/**
		 *  @private
		 */
		private var _proposedEvents:Array;
		
		/**
		 *  The name of the field in the data provider items to display 
		 *  as the label. 
		 *  The <code>labelFunction</code> property overrides this property.
		 *
		 *  @default "label" 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get events():Array
		{
			return _proposedEvents ? _proposedEvents : _events;
		}
		/**
		 *  @private
		 */
		public function set events(value:Array):void
		{
			if( _events == value ) return 
				
			_proposedEvents = value;
			_eventsChanged = true;
			invalidateProperties();
		}
		
		
		//----------------------------------
		//  source
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _source:Object;
		
		/**
		 *  @private
		 */
		private var _proposedSource:Object;
		
		public function get source():Object
		{
			return _proposedSource ? _proposedSource : _source;
		}
		/**
		 *  @private
		 */
		public function set source( value:Object ):void
		{
			if( _source == value ) return;
			
			_proposedSource = value;
			_sourceChanged = true;
			invalidateProperties();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  dataProvider
		//----------------------------------
		
		private var _superProvider:ArrayList;
		override public function get dataProvider():IList
		{
			return _dataProvider;
		}
		private var _dataProvider:IList;
		override public function set dataProvider(value:IList):void
		{
			if( _dataProvider == value ) return;
			
			_dataProvider = value;
			_propertiesChanged = true;
			invalidateProperties();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function updateRendererProperty(itemIndex:int):void
		{
			// grab the renderer at that index and re-compute it's label property
			var renderer:IPropertyItemRenderer = dataGroup.getElementAt( itemIndex ) as IPropertyItemRenderer; 
			if( renderer )
			{
				renderer.property = LabelProperty( renderer.data ).property; 
				renderer.value = LabelProperty( renderer.data ).value; 
			}
		}
		
		private function addListeners( s:IEventDispatcher, e:Array ):void
		{
			for each( var event:String in e )
			{
				s.addEventListener( event, onSourcePropertiesChange, false, 0, true );
			}
		}
		
		private function removeListeners( s:IEventDispatcher, e:Array ):void
		{
			for each( var event:String in e )
			{
				s.removeEventListener( event, onSourcePropertiesChange, false );
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		override public function itemToLabel(item:Object):String
		{
			return item.label;
		}
		
		override public function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void
		{
			if( renderer is IPropertyItemRenderer )
			{
				var pRenderer:IPropertyItemRenderer = IPropertyItemRenderer( renderer ); 
				pRenderer.property = LabelProperty( data ).property; 
				pRenderer.value = LabelProperty( data ).value; 
			}
			
			super.updateRenderer( renderer, itemIndex, data );
		}
		
		override protected function commitProperties():void
		{
			var numItems:int;
			var i:int;
			var labelProperty:LabelProperty;
			
			if( _sourceChanged )
			{
				_propertiesChanged = true;
				_sourceChanged = false;
				
				var eventDispatcher:IEventDispatcher;

				if( _source is IEventDispatcher )
				{
					eventDispatcher = IEventDispatcher( _source );
					removeListeners( IEventDispatcher( _source ), _events );
					if( _source is IUIComponent ) removeListeners( IEventDispatcher( _source ), UI_COMPONENT_EVENTS );
					if( _source is DisplayObject ) removeListeners( IEventDispatcher( _source ), DISPLAY_OBJECT_EVENTS );
				}
				
				if( _eventsChanged )
				{
					_eventsChanged = false;
					_events = _proposedEvents;
					_proposedEvents = null;
				}
				
				_source = _proposedSource;
				_proposedSource = null;
				
				if( _source is IEventDispatcher )
				{
					eventDispatcher = IEventDispatcher( _source );
					addListeners( IEventDispatcher( _source ), _events );
					if( _source is IUIComponent ) addListeners( IEventDispatcher( _source ), UI_COMPONENT_EVENTS );
					if( _source is DisplayObject ) addListeners( IEventDispatcher( _source ), DISPLAY_OBJECT_EVENTS );
				}
			}
			
			if( _eventsChanged )
			{
				_eventsChanged = false;
				
				if( _source is IEventDispatcher )
				{
					eventDispatcher = IEventDispatcher( _source );
					removeListeners( IEventDispatcher( _source ), _events );
				}
				
				_events = _proposedEvents;
				_proposedEvents = null;
				
				if( _source is IEventDispatcher )
				{
					eventDispatcher = IEventDispatcher( _source );
					addListeners( IEventDispatcher( _source ), _events );
				}
			}
			
			if( _propertiesChanged )
			{
				_valuesChanged = true;
				_superProvider = new ArrayList();
				
				if( _source )
				{
					if( _dataProvider == null )
					{
						var d:XML = describeType( _source );
						var x:XMLList
						var p:XML;

						x = d.variable;
						for each( p in x )
						{
							if( p.@uri.toString() == "" ) _superProvider.addItem( createLabelProperty( p.@name, p.@name ) );
						}
						
						x = d.accessor.( @access != "writeonly" );
						for each( p in x )
						{
							if( p.@uri.toString() == "" ) _superProvider.addItem( createLabelProperty( p.@name, p.@name ) );
						}
						
						_superProvider.source.sortOn( "label" );
					}
					else
					{
						var item:Object;
						numItems = _dataProvider.length;
						for( i = 0; i < numItems; i++ )
						{
							item = _dataProvider.getItemAt( i );
							try
							{
								labelProperty = createLabelProperty( item.label, item.property );
							}
							catch( e:Error )
							{
								labelProperty = null;
							}
							if( labelProperty ) _superProvider.addItem( labelProperty );
						}
					}
				}
			}

			if( _valuesChanged )
			{
				_valuesChanged = false;
				
				numItems = _superProvider.length;
				for( i = 0; i < numItems; i++ )
				{
					
					labelProperty = LabelProperty( _superProvider.getItemAt( i ) );
					try
					{
						labelProperty.value = _source[ labelProperty.property ];
					}
					catch( e:Error )
					{
						labelProperty.value = "null";
					}
					
				}
				
				// Cycle through all instantiated renderers to push the correct text 
				// in to the renderer by setting its label property
				if (dataGroup)
				{
					var itemIndex:int;
					
					// if virtual layout, only loop through the indices in view
					// otherwise, loop through all of the item renderers
					if (layout && layout.useVirtualLayout)
					{
						for each (itemIndex in dataGroup.getItemIndicesInView())
						{
							updateRendererProperty(itemIndex);
						}
					}
					else
					{
						var n:int = dataGroup.numElements;
						for (itemIndex = 0; itemIndex < n; itemIndex++)
						{
							updateRendererProperty(itemIndex);
						}
					}
				}
			}
				
			if( _propertiesChanged )
			{
				_propertiesChanged = false;
				super.dataProvider = _superProvider;
			}
			
			super.commitProperties();
		}
		
		
		private function createLabelProperty( l:String, p:String ):LabelProperty
		{
			try
			{
				return new LabelProperty( l, p ? p : "null" );
			}
			catch( e:Error )
			{
				
			}
			
			return new LabelProperty( l, "null" );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Listeners
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function onSourcePropertiesChange( event:Event ):void
		{
			trace( "onSourcePropertiesChange" );
			_valuesChanged = true;
			invalidateProperties();
		}
		
	}
}



internal class LabelProperty
{
	
	private var _property:String;
	private var _label:String;
	private var _value:String;
	
	public function LabelProperty( label:String, property:String ):void
	{
		_label = label;
		_property = property;
	}
	
	public function get label():String
	{
		return _label;
	}
	
	public function get property():String
	{
		return _property;
	}
	
	public function get value():String
	{
		return _value;
	}
	public function set value( v:String ):void
	{
		_value = v;
	}
}