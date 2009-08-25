/*
Copyright (c) 2009 Tink Ltd - http://www.tink.ws

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

package ws.tink.flex.collections
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.CursorBookmark;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.IViewCursor;
	import mx.collections.ListCollectionView;
	import mx.collections.XMLListCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;

	public class CollectionClone extends EventDispatcher
	{
		
		private var _iterator			: IViewCursor;
		private var _collection			: ICollectionView;
		private var _outputCollection	: ArrayCollection;
		
		public function CollectionClone()
		{
			initialize();
		}
		
		public function set dataProvider( value:Object ):void
		{
			if( value is Array )
			{
				_collection = new ArrayCollection( value as Array );
			}
			else if( value is ICollectionView )
			{
				_collection = ICollectionView( value );
			}
			else if( value is IList )
			{
				_collection = new ListCollectionView( IList( value ) );
			}
			else if( value is XMLList )
			{
				_collection = new XMLListCollection( value as XMLList );
			}
			else
			{
				// convert it to an array containing this one item
				var tmp:Array = [ value ];
				_collection = new ArrayCollection( tmp );
			}
			
			_iterator = _collection.createCursor();
			
			_collection.addEventListener( CollectionEvent.COLLECTION_CHANGE, onCollectionChange, false, 0, true );
			
			applyOutput( CollectionEventKind.RESET );
		}
		
		[Bindable(event="collectionChange")]
		public function get output():ArrayCollection
		{
			return _outputCollection;
		}
		
		private function onCollectionChange( event:CollectionEvent ):void
		{
			var i:int;
			var numItems:int;
			var item:Object;
			var propertyChangeEvent:PropertyChangeEvent;
			
			switch( event.kind )
			{
				case CollectionEventKind.ADD :
				{
					numItems = event.items.length;
					for( i = 0; i < numItems; i++ )
					{
						_outputCollection.addItemAt( event.items[ i ], event.location + i );
					}
					break;
				}
				case CollectionEventKind.MOVE :
				{
					numItems = event.items.length;
					for( i = 0; i < numItems; i++ )
					{
						item = _outputCollection.removeItemAt( event.oldLocation + i );
						_outputCollection.addItemAt( item, event.location + i );
					}
					break;
				}
				case CollectionEventKind.REFRESH :
				case CollectionEventKind.RESET :
				{
					applyOutput( event.kind );
					break;
				}
				case CollectionEventKind.REMOVE :
				{
					numItems = event.items.length;
					for( i = 0; i < numItems; i++ )
					{
						_outputCollection.removeItemAt( event.location + i );
					}
					break;
				}
				case CollectionEventKind.REPLACE :
				{
					numItems = event.items.length;
					for( i = 0; i < numItems; i++ )
					{
						propertyChangeEvent = PropertyChangeEvent( event.items[ i ] );
						_outputCollection.setItemAt( propertyChangeEvent.source, event.location + i );
					}
					break;
				}
				case CollectionEventKind.UPDATE :
				{
					numItems = event.items.length;
					for( i = 0; i < numItems; i++ )
					{
						propertyChangeEvent = PropertyChangeEvent( event.items[ i ] );
						_outputCollection.itemUpdated( propertyChangeEvent.source, propertyChangeEvent.property, propertyChangeEvent.oldValue, propertyChangeEvent.newValue ); 
					}
					break;
				}
			}
		}
		
		private function applyOutput( kind:String ):void
		{
			_outputCollection = new ArrayCollection();
			var numItems:int = _collection.length;
			for( var i:int = 0; i < numItems; i++ )
			{
				_iterator.seek( CursorBookmark.FIRST, i, 0 );
				_outputCollection.addItem( _iterator.current );
			}
			
			dispatchEvent( new CollectionEvent( CollectionEvent.COLLECTION_CHANGE, false, false, kind ) );
		}
		
		
		private function initialize():void
		{
			_outputCollection = new ArrayCollection();
		}
	}
}