package ws.tink.spark.controls
{
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	import ws.tink.spark.controls.DataNavigator;

	public class BorderDataNavigator extends DataNavigator
	{
		public function BorderDataNavigator()
		{
		}
		
		private var _backgroundFill:IFill;
		
		/**
		 *  Defines the background of the BorderContainer. 
		 *  Setting this property override the <code>backgroundAlpha</code>, 
		 *  <code>backgroundColor</code>, <code>backgroundImage</code>, 
		 *  and <code>backgroundImageFillMode</code> styles.
		 * 
		 *  <p>The following example uses the <code>backgroundFill</code> property
		 *  to set the background color to red:</p>
		 *
		 *  <pre>
		 *  &lt;s:BorderContainer cornerRadius="10"&gt; 
		 *     &lt;s:backgroundFill&gt; 
		 *         &lt;s:SolidColor 
		 *             color="red" 
		 *             alpha="1"/&gt; 
		 *     &lt;/s:backgroundFill&gt; 
		 *  &lt;/s:BorderContainer&gt; </pre>
		 *
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */ 
		public function get backgroundFill():IFill
		{
			return _backgroundFill;
		}
		
		/**
		 *  @private
		 */ 
		public function set backgroundFill(value:IFill):void
		{
			if (value == _backgroundFill)
				return;
			
			_backgroundFill = value;
			
			if (skin)
				skin.invalidateDisplayList();
		}
		
		private var _borderStroke:IStroke;
		
		/**
		 *  Defines the stroke of the BorderContainer container. 
		 *  Setting this property override the <code>borderAlpha</code>, 
		 *  <code>borderColor</code>, <code>borderStyle</code>, <code>borderVisible</code>, 
		 *  and <code>borderWeight</code> styles.  
		 * 
		 *  <p>The following example sets the <code>borderStroke</code> property:</p>
		 *
		 *  <pre>
		 *  &lt;s:BorderContainer cornerRadius="10"&gt; 
		 *     &lt;s:borderStroke&gt; 
		 *         &lt;mx:SolidColorStroke 
		 *             color="black" 
		 *             weight="3"/&gt; 
		 *     &lt;/s:borderStroke&gt; 
		 *  &lt;/s:BorderContainer&gt; </pre>
		 *
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */ 
		public function get borderStroke():IStroke
		{
			return _borderStroke;
		}
		
		/**
		 *  @private
		 */ 
		public function set borderStroke(value:IStroke):void
		{
			if (value == _borderStroke)
				return;
			
			_borderStroke = value;
			
			if (skin)
				skin.invalidateDisplayList();
		}
		
	}
}