/*
Copyright (c) 2008 Tink Ltd - http://www.tink.ws

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

package ws.tink.controls
{
	
	import fl.controls.Button;
	import fl.core.UIComponent;
	
	import flash.text.TextFieldAutoSize;

	[Style(name="horizontalPadding", type="Number", format="Length")]
	
	public class AutoSizeButton extends Button
	{

		private static var defaultStyles:Object = { horizontalPadding: 20 };
		
		public static function getStyleDefinition():Object
		{ 
			return UIComponent.mergeStyles( Button.getStyleDefinition(), defaultStyles );
		}
		
		public function AutoSizeButton()
		{
			super();
		}
				
		override protected function configUI():void
		{
			super.configUI();
			
			textField.autoSize = TextFieldAutoSize.LEFT;
		}
		
		override protected function drawLayout():void
		{
			width = textField.width + Number( getStyleValue( "horizontalPadding" ) ) + Number( getStyleValue( "textPadding" ) );

			super.drawLayout();
		}

	}
}