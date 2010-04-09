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
		private var module:IModuleInfo;
		
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
		 *  The application domain to load your module into.
		 *  Application domains are used to partition classes that are in the same 
		 *  security domain. They allow multiple definitions of the same class to 
		 *  exist and allow children to reuse parent definitions.
		 *  
		 *  @see flash.system.ApplicationDomain
		 *  @see flash.system.SecurityDomain
		 */
		public var applicationDomain:ApplicationDomain;
		
		//----------------------------------
		//  child
		//----------------------------------
		
		/**
		 *  The DisplayObject created from the module factory.
		 */
		public var child:DisplayObject;
		
		//----------------------------------
		//  url
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the url property.
		 */
		private var _url:String = null;
		
		/**
		 *  The location of the module, expressed as a URL.
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
			if (value == _url)
				return;
			
			_urlChanged = true;
			
			if (module)
			{
				module.removeEventListener( ModuleEvent.PROGRESS, moduleProgressHandler );
				module.removeEventListener( ModuleEvent.SETUP, moduleSetupHandler );
				module.removeEventListener( ModuleEvent.READY, moduleReadyHandler );
				module.removeEventListener( ModuleEvent.ERROR, moduleErrorHandler );
				module.removeEventListener( ModuleEvent.UNLOAD, moduleUnloadHandler );
				
				module.release();
				module = null;
				
				if (child)
				{
					removeChild(child);
					child = null;
				}
			}
			
			_url = value;
			
			dispatchEvent( new FlexEvent( FlexEvent.URL_CHANGED ) );
			
			if( _url != null ) load();
		}
		
		
		private var _loadPolicy	: String = ModuleLoadPolicy.ADDED_TO_STAGE;
		
		[Inspectable(enumeration="added,addedToStage,immediate,none", defaultValue="addedToStage")]
		
		/**
		 *  Delay loading the module until it is needed.
		 * 
		 * 	<p><code>ModuleLoadPolicy.AUTO</code> will load the content when the module
		 * 	is added to the stage, <code>ModuleLoadPolicy.IMMEDIATE</code> will load
		 * 	the module as soon as the Module is passed a URL or <code>ModuleLoadPolicy.INVOKED</code>
		 * 	will only load the module when the loadModule method is invoked.
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
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Loads the module. When the module is finished loading, the ModuleLoader adds
		 *  it as a child with the <code>addChild()</code> method. This is normally 
		 *  triggered with deferred instantiation.
		 *  
		 *  <p>If the module has already been loaded, this method does nothing. It does
		 *  not load the module a second time.</p>
		 * 
		 *  @param url The location of the module, expressed as a URL. This is an  
		 *  optional parameter. If this parameter is null the value of the
		 *  <code>url</code> property will be used. If the url parameter is provided
		 *  the <code>url</code> property will be updated to the value of the url.
		 * 
		 *  @param bytes A ByteArray object. The ByteArray is expected to contain 
		 *  the bytes of a SWF file that represents a compiled Module. The ByteArray
		 *  object can be obtained by using the URLLoader class. If this parameter
		 *  is specified the module will be loaded from the ByteArray and the url 
		 *  parameter will be used to identify the module in the 
		 *  <code>ModuleManager.getModule()</code> method and must be non-null. If
		 *  this parameter is null the module will be load from the url, either 
		 *  the url parameter if it is non-null, or the url property as a fallback.
		 */
		public function loadModule( url:String = null, bytes:ByteArray = null ):void
		{
			_urlChanged = false;
			
			if( url != null ) _url = url;
			
			if( _url == null ) return;
			
			if( child ) return;
			
			if( module )return;
			
			dispatchEvent( new FlexEvent( FlexEvent.LOADING ) );
			
			module = ModuleManager.getModule( _url );
			
			module.addEventListener( ModuleEvent.PROGRESS, moduleProgressHandler );
			module.addEventListener( ModuleEvent.SETUP, moduleSetupHandler );
			module.addEventListener( ModuleEvent.READY, moduleReadyHandler );
			module.addEventListener( ModuleEvent.ERROR, moduleErrorHandler );
			module.addEventListener( ModuleEvent.UNLOAD, moduleUnloadHandler );
			
			module.load( applicationDomain, null, bytes );
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
		 *  Unloads the module and sets it to <code>null</code>.
		 *  If an instance of the module was previously added as a child,
		 *  this method calls the <code>removeChild()</code> method on the child. 
		 *  <p>If the module does not exist or has already been unloaded, this method does
		 *  nothing.</p>
		 */
		public function unloadModule():void
		{
			if (child)
			{
				removeChild(child);
				child = null;
			}
			
			if (module)
			{
				module.removeEventListener( ModuleEvent.PROGRESS, moduleProgressHandler );
				module.removeEventListener( ModuleEvent.SETUP, moduleSetupHandler );
				module.removeEventListener( ModuleEvent.READY, moduleReadyHandler );
				module.removeEventListener( ModuleEvent.ERROR, moduleErrorHandler );
				
				module.unload();
				module.removeEventListener( ModuleEvent.UNLOAD, moduleUnloadHandler );
				module = null;
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
			_loadedModule = module.factory.create() as IModule;
			
			if( _loadedModule ) addElement( IVisualElement( _loadedModule ) );
			
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
		
		private var _loadedModule			: IModule;
		
		
	}
}