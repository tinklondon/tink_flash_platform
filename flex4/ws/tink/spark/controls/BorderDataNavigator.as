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