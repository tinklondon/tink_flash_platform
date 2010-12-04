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

package ws.tink.spark.modules
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	import mx.modules.IModule;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	
	import spark.components.Group;
	
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the ModuleLoader starts to load a URL.
	 *
	 *  @eventType mx.events.FlexEvent.LOADING
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="loading", type="flash.events.Event")]
	
	/**
	 *  Dispatched when the ModuleLoader is given a new URL.
	 *
	 *  @eventType mx.events.FlexEvent.URL_CHANGED
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="urlChanged", type="flash.events.Event")]
	
	/**
	 *  Dispatched when information about the module is 
	 *  available (with the <code>info()</code> method), 
	 *  but the module is not yet ready.
	 *
	 *  @eventType mx.events.ModuleEvent.SETUP
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="setup", type="mx.events.ModuleEvent")]
	
	/**
	 *  Dispatched when the module is finished loading.
	 *
	 *  @eventType mx.events.ModuleEvent.READY
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="ready", type="mx.events.ModuleEvent")]
	
	/**
	 *  Dispatched when the module throws an error.
	 *
	 *  @eventType mx.events.ModuleEvent.ERROR
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="error", type="mx.events.ModuleEvent")]
	
	/**
	 *  Dispatched at regular intervals as the module loads.
	 *
	 *  @eventType mx.events.ModuleEvent.PROGRESS
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="progress", type="mx.events.ModuleEvent")]
	
	/**
	 *  Dispatched when the module data is unloaded.
	 *
	 *  @eventType mx.events.ModuleEvent.UNLOAD
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="unload", type="mx.events.ModuleEvent")]
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	/*   NOTE: This class does not use the "containers" resource bundle. This 
	*   metadata is here to add the "containers" resource bundle to an 
	*   application loading a module. We do this because we know a Module will
	*   pull in the "containers" resource bundle and if the Module uses a resource
	*   bundle that is not already in use it will cause the module to be leaked.
	*
	*   This is only an issue for Spark applications because they do not link in
	*   the CanvasLayout class, which has the "containers" resource bundle. Halo
	*   applications always use the CanvasLayout class. This can be removed
	*   after the module leak caused by the ResourceManager has been fixed.
	*   
	*/
	
	// Resource bundles used by this class.
	[ResourceBundle("modules")]
	
	public class ModuleLoader extends Group
	{
		
		public function ModuleLoader()
		{
			super();
			
			addEventListener( Event.ADDED, onAdded, false, 0, true );
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );
		}
		
		private function onAdded( event:Event ):void
		{
			load();
		}
		
		private function onAddedToStage( event:Event ):void
		{
			load();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var _moduleInfo:IModuleInfo;
		
		/**
		 *  @private
		 */
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  applicationDomain
		//----------------------------------
		
		/**
		 *  The application domain to load your _moduleInfo into.
		 *  Application domains are used to partition classes that are in the same 
		 *  security domain. They allow multiple definitions of the same class to 
		 *  exist and allow children to reuse parent definitions.
		 *  
		 *  @see flash.system.ApplicationDomain
		 *  @see flash.system.SecurityDomain
		 */
		public var applicationDomain:ApplicationDomain;
		
//		//----------------------------------
//		//  child
//		//----------------------------------
//		
//		/**
//		 *  The DisplayObject created from the _moduleInfo factory.
//		 */
//		public var child:DisplayObject;
		
		//----------------------------------
		//  url
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the url property.
		 */
		private var _url:String = null;
		
		/**
		 *  The location of the _moduleInfo, expressed as a URL.
		 */
		public function get url():String
		{
			return _url;
		}
		
		/**
		 *  @private
		 */
		public function set url(value:String):void
		{
			if( value == _url ) return;
			
			_urlChanged = true;
			
			if( _moduleInfo )
			{
				_moduleInfo.removeEventListener( ModuleEvent.PROGRESS, moduleProgressHandler );
				_moduleInfo.removeEventListener( ModuleEvent.SETUP, moduleSetupHandler );
				_moduleInfo.removeEventListener( ModuleEvent.READY, moduleReadyHandler );
				_moduleInfo.removeEventListener( ModuleEvent.ERROR, moduleErrorHandler );
				_moduleInfo.removeEventListener( ModuleEvent.UNLOAD, moduleUnloadHandler );
				
				_moduleInfo.release();
				_moduleInfo = null;
				
				if( _module )
				{
					removeElement( IVisualElement( _module ) );
					_module = null;
				}
			}
			
			_url = value;
			
			dispatchEvent( new FlexEvent( FlexEvent.URL_CHANGED ) );
			
			if( _url != null ) load();
		}
		
		
		//----------------------------------
		//  loadPolicy
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the loadPolicy property.
		 */
		private var _loadPolicy	: String = ModuleLoadPolicy.ADDED_TO_STAGE;
		
		[Inspectable(enumeration="added,addedToStage,immediate,none", defaultValue="addedToStage")]
		
		/**
		 *  Delay loading the _moduleInfo until it is needed.
		 * 
		 * 	<p><code>ModuleLoadPolicy.AUTO</code> will load the content when the _moduleInfo
		 * 	is added to the stage, <code>ModuleLoadPolicy.IMMEDIATE</code> will load
		 * 	the _moduleInfo as soon as the Module is passed a URL or <code>ModuleLoadPolicy.INVOKED</code>
		 * 	will only load the _moduleInfo when the loadModule method is invoked.</p>
		 *
		 *  @default auto
		 * 
		 * 	@see ws.tink.spark.modules.ModuleLoadPolicy
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get loadPolicy():String
		{
			return _loadPolicy;
		}
		
		/**
		 *  @private
		 */
		public function set loadPolicy( value:String ):void
		{
			if( _loadPolicy == value ) return;
			
			_loadPolicy = value;
			load();
		}
		
		
		//----------------------------------
		//  status
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the status property.
		 */
		private var _status	: String = ModuleLoaderStatus.UNLOADED;
		
		/**
		 *  The status of the <code>ModuleLoader</code>. The status values can be 
		 *  <code>ModuleLoaderStatus.UNLOADED</code>, <code>ModuleLoaderStatus.LOADING</code>
		 *  and <code>ModuleLoaderStatus.LOADED</code>
		 * 
		 * 	@see ws.tink.spark.modules.ModuleLoaderStatus
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get status():String
		{
			return _status;
		}
		
		/**
		 *  @private
		 */
		private var _module	: IModule;
		
		/**
		 *  The loaded module.
		 *  Storage for the module property.
		 */
		public function get module():IModule
		{
			switch( _status )
			{
				case ModuleLoaderStatus.LOADING :
				case ModuleLoaderStatus.UNLOADED :
				{
					return null;
				}
				default :
				{
					return _module;
				}
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Loads the _moduleInfo. When the _moduleInfo is finished loading, the ModuleLoader adds
		 *  it as a child with the <code>addChild()</code> method. This is normally 
		 *  triggered with deferred instantiation.
		 *  
		 *  <p>If the _moduleInfo has already been loaded, this method does nothing. It does
		 *  not load the _moduleInfo a second time.</p>
		 * 
		 *  @param url The location of the _moduleInfo, expressed as a URL. This is an  
		 *  optional parameter. If this parameter is null the value of the
		 *  <code>url</code> property will be used. If the url parameter is provided
		 *  the <code>url</code> property will be updated to the value of the url.
		 * 
		 *  @param bytes A ByteArray object. The ByteArray is expected to contain 
		 *  the bytes of a SWF file that represents a compiled Module. The ByteArray
		 *  object can be obtained by using the URLLoader class. If this parameter
		 *  is specified the _moduleInfo will be loaded from the ByteArray and the url 
		 *  parameter will be used to identify the _moduleInfo in the 
		 *  <code>ModuleManager.getModule()</code> method and must be non-null. If
		 *  this parameter is null the _moduleInfo will be load from the url, either 
		 *  the url parameter if it is non-null, or the url property as a fallback.
		 */
		public function loadModule( url:String = null, bytes:ByteArray = null ):void
		{
			_urlChanged = false;
			
			if( url != null )
			{
				if( url != _url )
				{
					unloadModule();
					_url = url;
				}
				else
				{
					if( _status != ModuleLoaderStatus.UNLOADED ) return;
				}
			}
			else
			{
				if( _status != ModuleLoaderStatus.UNLOADED ) return;
			}
			
			if( _url == null ) return;
			
			_status = ModuleLoaderStatus.LOADING;
			dispatchEvent( new FlexEvent( FlexEvent.LOADING ) );
			
			_moduleInfo = ModuleManager.getModule( _url );
			
			_moduleInfo.addEventListener( ModuleEvent.PROGRESS, moduleProgressHandler );
			_moduleInfo.addEventListener( ModuleEvent.SETUP, moduleSetupHandler );
			_moduleInfo.addEventListener( ModuleEvent.READY, moduleReadyHandler );
			_moduleInfo.addEventListener( ModuleEvent.ERROR, moduleErrorHandler );
			_moduleInfo.addEventListener( ModuleEvent.UNLOAD, moduleUnloadHandler );
			
			_moduleInfo.load( applicationDomain, null, bytes );
		}
		
		protected function load():void
		{
			if( !_urlChanged ) return;
			
			switch( _loadPolicy )
			{
				case ModuleLoadPolicy.NONE :
				{
					return;
				}
				case ModuleLoadPolicy.ADDED :
				{
					if( !parent ) return;
					break;
				}
				case ModuleLoadPolicy.ADDED_TO_STAGE :
				{
					if( !stage ) return;
					break;
				}
				case ModuleLoadPolicy.IMMEDIATE :
				{
					// Do nothing
				}
			}
			
			loadModule();
		}
		
		
		/**
		 *  Unloads the _moduleInfo and sets it to <code>null</code>.
		 *  If an instance of the _moduleInfo was previously added as a child,
		 *  this method calls the <code>removeChild()</code> method on the child. 
		 *  <p>If the _moduleInfo does not exist or has already been unloaded, this method does
		 *  nothing.</p>
		 */
		public function unloadModule():void
		{
			_status = ModuleLoaderStatus.UNLOADED;
			
			if( _module )
			{
				removeElement( IVisualElement( _module ) );
				_module = null;
			}
			
			if( _moduleInfo )
			{
				_moduleInfo.removeEventListener( ModuleEvent.PROGRESS, moduleProgressHandler );
				_moduleInfo.removeEventListener( ModuleEvent.SETUP, moduleSetupHandler );
				_moduleInfo.removeEventListener( ModuleEvent.READY, moduleReadyHandler );
				_moduleInfo.removeEventListener( ModuleEvent.ERROR, moduleErrorHandler );
				
				_moduleInfo.unload();
				_moduleInfo.removeEventListener( ModuleEvent.UNLOAD, moduleUnloadHandler );
				_moduleInfo = null;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function moduleProgressHandler( event:ModuleEvent ):void
		{
			dispatchEvent(event);
		}
		
		/**
		 *  @private
		 */
		private function moduleSetupHandler( event:ModuleEvent ):void
		{
			// Not ready for creation yet, but can call factory.info().
			dispatchEvent(event);
		}
		
		/**
		 *  @private
		 */
		private function moduleReadyHandler( event:ModuleEvent ):void
		{
			_module = _moduleInfo.factory.create() as IModule;
			
			if( _module ) addElement( IVisualElement( _module ) );
			
			_status = ModuleLoaderStatus.READY;
			
			dispatchEvent( event );
		}
		
		/**
		 *  @private
		 */
		private function moduleErrorHandler( event:ModuleEvent ):void
		{
			unloadModule();
			dispatchEvent( event );
		}
		
		/**
		 *  @private
		 */
		private function moduleUnloadHandler(event:ModuleEvent):void
		{
			dispatchEvent( event );
		}
		
		
		private var _urlChanged				: Boolean;
		
	}
}