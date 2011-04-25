package ws.tink.spark.skins.supportClasses
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 *  Base class for custom focus and error skins created in ActionScript.
	 *  Users need to override updateDisplayList
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class TargetSkinBase extends UIComponent
	{
		public function TargetSkinBase()
		{
			super();
		}
		
		/**
		 *  @private
		 */
		private var _target	: SkinnableComponent;
		
		/**
		 *  Object to target.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get target():SkinnableComponent
		{
			return _target;
		}
		public function set target( value:SkinnableComponent ):void
		{
			removeSkinListeners();
			_target = value;
			addSkinListeners();
		}
		
		/**
		 *  @private
		 */
		private function removeSkinListeners():void
		{
			if( !_target ) return;
			if( _target.skin ) _target.skin.removeEventListener( FlexEvent.UPDATE_COMPLETE, onSkinUpdateComplete, false );
		}
		
		/**
		 *  @private
		 */
		private function addSkinListeners():void
		{
			if( !_target ) return;
			if( _target.skin ) _target.skin.addEventListener(FlexEvent.UPDATE_COMPLETE, onSkinUpdateComplete, false, 0, true);
		}
		
		/**
		 *  @private
		 */
		private function onSkinUpdateComplete( event:FlexEvent ):void
		{
			if( _target ) setActualSize( _target.width, _target.height );
		}
	}
}