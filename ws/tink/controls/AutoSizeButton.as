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