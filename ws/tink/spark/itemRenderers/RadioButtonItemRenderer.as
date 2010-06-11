package ws.tink.spark.itemRenderers
{
	import spark.components.CheckBox;
	import spark.components.IItemRenderer;
	import spark.components.RadioButton;
	
	public class RadioButtonItemRenderer extends RadioButton implements IItemRenderer
	{
		
		public function RadioButtonItemRenderer()
		{
			super();
		}
		
		private var _itemIndex	: int;
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		public function set itemIndex( value:int ):void
		{
			_itemIndex = value;
		}
		
		private var _dragging	: Boolean;
		public function get dragging():Boolean
		{
			return _dragging;
		}
		public function set dragging(value:Boolean):void
		{
			_dragging = value;
		}
		
		private var _showsCaret	: Boolean;
		public function get showsCaret():Boolean
		{
			return _showsCaret;
		}
		public function set showsCaret( value:Boolean ):void
		{
			_showsCaret = value;
		}
		
		private var _data	: Object;
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
		}
		
//		override public function set selected(value:Boolean):void
//		{
////			super.selected = value;
//		}
		
		
		
	}
}