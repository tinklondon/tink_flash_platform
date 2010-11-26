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
		
		/**
		 *  @private
		 *  List of events to automatically add to instances
		 *  that are IUIComponents.
		 */
		private const UI_COMPONENT_EVENTS:Array = [ 
			FlexEvent.CREATION_COMPLETE,
			FlexEvent.VALUE_COMMIT,
			FlexEvent.UPDATE_COMPLETE,
			FlexEvent.SHOW,
			FlexEvent.HIDE ]
		
		/**
		 *  @private
		 *  List of events to automatically add to instances
		 *  that are DisplayObject.
		 */
		private const DISPLAY_OBJECT_EVENTS:Array = [
			Event.ADDED,
			Event.ADDED_TO_STAGE,
			Event.REMOVED,
			Event.REMOVED_FROM_STAGE ];
		
		/**
		 *  @private
		 *  Flag to indicate the properties have changed.
		 */
		private var _propertiesChanged:Boolean;
		
		/**
		 *  @private
		 *  Flag to indicate the values of properties have changed.
		 */
		private var _valuesChanged:Boolean;
		
		/**
		 *  @private
		 *  Flag to indicate the events property has changed.
		 */
		private var _eventsChanged:Boolean;
		
		/**
		 *  @private
		 *  Flag to indicate the instance property has changed.
		 */
		private var _instanceChanged:Boolean;
		
		/**
		 *  @private
		 *  Storage for the list of label/property/value combinations.
		 */
		private var _superProvider:ArrayList;
		
		
		
		
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
		 *  Storage property for events.
		 */
		private var _events:Array;
		
		/**
		 *  @private
		 *  Storage property for events to commit on validation.
		 */
		private var _proposedEvents:Array;
		
		/**
		 *  An optional list of events that should be added to the instance
		 *  to inform the component that property values have changed.
		 *
		 *  @default [] 
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
		//  instance
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage property for instance.
		 */
		private var _instance:Object;
		
		/**
		 *  @private
		 *  Storage property for the instance to commit on validation.
		 */
		private var _proposedInstance:Object;
		
		/**
		 *  The object instance who's properties are to be listed.
		 *
		 *  @default null 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get instance():Object
		{
			return _proposedInstance ? _proposedInstance : _instance;
		}
		/**
		 *  @private
		 */
		public function set instance( value:Object ):void
		{
			if( _instance == value ) return;
			
			_proposedInstance = value;
			_instanceChanged = true;
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
		
		/**
		 *  @private
		 *  Storage property for dataProvider.
		 */
		private var _dataProvider:IList;
		
		/**
		 *  The list of label's and public properties to show in the component.
		 * 
		 *  <p>If this property is null, all the public properties of the <code>instance</code>
		 *  property will be shown.</p>
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
		override public function get dataProvider():IList
		{
			return _dataProvider;
		}
		/**
		 *  @private
		 */
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
		private function updateRendererPropertyValue( itemIndex:int ):void
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
			var i:int;
			var numItems:int;
			var labelProperty:LabelProperty;
			
			if( _instanceChanged )
			{
				_propertiesChanged = true;
				_instanceChanged = false;
				
				var eventDispatcher:IEventDispatcher;
				
				// Remove the added listeners.
				if( _instance is IEventDispatcher )
				{
					eventDispatcher = IEventDispatcher( _instance );
					removeListeners( IEventDispatcher( _instance ), _events );
					if( _instance is IUIComponent ) removeListeners( IEventDispatcher( _instance ), UI_COMPONENT_EVENTS );
					if( _instance is DisplayObject ) removeListeners( IEventDispatcher( _instance ), DISPLAY_OBJECT_EVENTS );
				}
				
				// Here we commit the events so the correct ones are added
				// directly below.
				if( _eventsChanged )
				{
					_eventsChanged = false;
					_events = _proposedEvents;
					_proposedEvents = null;
				}
				
				_instance = _proposedInstance;
				_proposedInstance = null;
				
				// Add the required listeners.
				if( _instance is IEventDispatcher )
				{
					eventDispatcher = IEventDispatcher( _instance );
					addListeners( IEventDispatcher( _instance ), _events );
					if( _instance is IUIComponent ) addListeners( IEventDispatcher( _instance ), UI_COMPONENT_EVENTS );
					if( _instance is DisplayObject ) addListeners( IEventDispatcher( _instance ), DISPLAY_OBJECT_EVENTS );
				}
			}
			
			if( _eventsChanged )
			{
				_eventsChanged = false;
				
				if( _instance is IEventDispatcher )
				{
					eventDispatcher = IEventDispatcher( _instance );
					removeListeners( IEventDispatcher( _instance ), _events );
				}
				
				_events = _proposedEvents;
				_proposedEvents = null;
				
				if( _instance is IEventDispatcher )
				{
					eventDispatcher = IEventDispatcher( _instance );
					addListeners( IEventDispatcher( _instance ), _events );
				}
			}
			
			if( _propertiesChanged )
			{
				_valuesChanged = true;
				_superProvider = new ArrayList();
				
				if( _instance )
				{
					// If there are no properties specified use describeType()
					// to output all public properties.
					if( _dataProvider == null )
					{
						var d:XML = describeType( _instance );
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
						
						// Sort the properties into alphabetical order.
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
						labelProperty.value = _instance[ labelProperty.property ];
					}
					catch( e:Error )
					{
						labelProperty.value = "null";
					}
					
				}
				
				// Cycle through all instantiated renderers to push the correct text 
				// in to the renderer by setting its label property
				if( dataGroup )
				{
					// if virtual layout, only loop through the indices in view
					// otherwise, loop through all of the item renderers
					if( layout && layout.useVirtualLayout )
					{
						for each( i in dataGroup.getItemIndicesInView() )
						{
							updateRendererPropertyValue( i );
						}
					}
					else
					{
						numItems = dataGroup.numElements;
						for( i = 0; i < numItems; i++ )
						{
							updateRendererPropertyValue( i );
						}
					}
				}
			}
				
			// Commit the new dataProvider of labels/properties/values
			// to the super class.
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