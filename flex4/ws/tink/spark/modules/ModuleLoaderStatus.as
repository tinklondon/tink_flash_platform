package ws.tink.spark.modules
{
	public class ModuleLoaderStatus
	{
		
		/**
		 *  The module is currently loading.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public static const LOADING:String = "loading";
		
		/**
		 *  The module has loaded, startup has completed and the module is ready.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public static const READY:String = "ready";
		
		/**
		 *  The module is waiting to be loaded, or has been unloaded.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public static const UNLOADED:String = "unloaded";
	}
}