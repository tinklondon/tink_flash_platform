package ws.tink.spark.itemRenderers
{
	import mx.controls.RadioButton;
	
	import spark.components.CheckBox;
	import spark.components.IItemRenderer;
	
	public class RadioButtonItemRenderer extends RadioButton implements IItemRenderer
	{
		
		
		
		public function RadioButtonItemRenderer()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Properties 
		//
		//--------------------------------------------------------------------------
		
		
		//----------------------------------
		//  itemIndex
		//----------------------------------
		
		/**
		 *  @private
		 *  storage for the itemIndex property 
		 */    
		private var _itemIndex:int;
		
		/**
		 *  @inheritDoc 
		 *
		 *  @default 0
		 */    
		public function get itemIndex():int
		{
			return _itemIndex;
		}
		
		/**
		 *  @private
		 */    
		public function set itemIndex(value:int):void
		{
			if (value == _itemIndex)
				return;
			
			_itemIndex = value;
			invalidateDisplayList();
		}
		
		
		//----------------------------------
		//  showsCaret
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the showsCaret property 
		 */
		private var _showsCaret:Boolean = false;
		
		/**
		 *  @inheritDoc 
		 *
		 *  @default false  
		 */    
		public function get showsCaret():Boolean
		{
			return _showsCaret;
		}
		
		/**
		 *  @private
		 */    
		public function set showsCaret(value:Boolean):void
		{
			if (value == _showsCaret)
				return;
			
			_showsCaret = value;
			invalidateDisplayList();
		}
		
		
		//----------------------------------
		//  dragging
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the dragging property. 
		 */
		private var _dragging:Boolean = false;
		
		/**
		 *  @inheritDoc  
		 */
		public function get dragging():Boolean
		{
			return _dragging;
		}
		
		/**
		 *  @private  
		 */
		public function set dragging(value:Boolean):void
		{
			if (value == _dragging)
				return;
			
			_dragging = value;
		}
		
	}
}