package ws.tink.spark.modules
{
	public class ModuleLoadPolicy
	{
		public function ModuleLoadPolicy()
		{
		}
		
		
		/**
		 *  Delay loading the module until the item is added to a displayList.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public static const ADDED:String = "added";
		
		/**
		 *  Delay loading the module until the item is added to the stage.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public static const ADDED_TO_STAGE:String = "addedToStage";
		
		/**
		 *  Load the module as soon as it is passed a URL.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public static const IMMEDIATE:String = "immediate";
		
		/**
		 *  Only load the module if the user invokes the <code>loadModule</code> method.
		 * 	
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public static const NONE:String = "none";
	}
}