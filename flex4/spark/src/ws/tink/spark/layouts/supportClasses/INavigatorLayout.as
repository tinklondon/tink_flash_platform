package ws.tink.spark.layouts.supportClasses
{
	import mx.core.ISelectableList;

	/**
	 *  The INavigatorLayout interface indicates that the implementor
	 * 	is an LayoutBase that supports a <code>selectedIndex</code> property.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public interface INavigatorLayout
	{
		/**
		 *  The index of the selected INavigatorLayout item.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		function set selectedIndex( value:int ):void;
		function get selectedIndex():int;

	}
}