package ws.tink.spark.itemRenderers
{
	import mx.events.FlexEvent;
	
	import spark.components.CheckBox;
	import spark.components.IItemRenderer;
	
	public class CheckBoxItemRenderer extends CheckBox implements IItemRenderer
	{
		
		
		
		public function CheckBoxItemRenderer()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public Properties 
		//
		//--------------------------------------------------------------------------
		
		
		//----------------------------------
		//  data
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the data property.
		 */
		private var _data : Object;
		
		[Bindable("dataChange")]
		
		/**
		 *  The implementation of the <code>data</code> property
		 *  as defined by the IDataRenderer interface.
		 *  When set, it stores the value and invalidates the component 
		 *  to trigger a relayout of the component.
		 *
		 *  @see mx.core.IDataRenderer
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get data():Object
		{
			return _data;
		}
		
		public function set data( value:Object ):void
		{
			_data = value;
			dispatchEvent( new FlexEvent( FlexEvent.DATA_CHANGE ) );
		}
		
		
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