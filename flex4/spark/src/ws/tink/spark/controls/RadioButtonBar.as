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
	import spark.components.ButtonBar;
	
	/**
	 *  The RadioButtonBar component allows the user make a single choice
	 *  within a set of mutually exclusive choices.
	 *
	 *  <p>The RadioButtonBar control has the following default characteristics:</p>
	 *  <table class="innertable">
	 *     <tr><th>Characteristic</th><th>Description</th></tr>
	 *     <tr><td>Default size</td><td>Large enough to display all buttons</td></tr>
	 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
	 *     <tr><td>Maximum size</td><td>No limit</td></tr>
	 *     <tr><td>Default skin class</td><td>ws.tink.spark.skins.controls.RadioButtonBarSkin</td></tr>
	 *  </table>
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;st:RadioButtonBar&gt;</code> tag inherits all of the tag
	 *  attributes of its superclass, and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;st:RadioButtonBar
	 * 
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see ws.tink.spark.itemRenderers.RadioButtonItemRenderer
	 *  @see ws.tink.spark.skins.controls.RadioButtonBarSkin
	 *  @includeExample ../examples/Examples/src/RadioButtonBarExample.mxml
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class RadioButtonBar extends ButtonBar
	{
		public function RadioButtonBar()
		{
			super();
			requireSelection = true;
		}
	}
}