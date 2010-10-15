package ws.tink.spark.layouts
{
	import flash.display.DisplayObject;
	import flash.geom.Vector3D;
	
	import mx.core.IVisualElement;

	public class RolodexLayout extends TimeMachineLayout
	{
		public function RolodexLayout()
		{
			super();
		}
		
		override protected function updateFirstElementInView( element:IVisualElement, firstIndexInViewOffsetPercent:Number ):void
		{
			if( !element ) return;
			
			setElementLayoutBoundsSize( element, false );
			
			element.visible = true;
			
//			DisplayObject( element ).rotationX = -270 * firstIndexInViewOffsetPercent;
			var rotation:int = 270 * firstIndexInViewOffsetPercent;
			var halfWidth:Number = ( element.width / 2 );
			var x:Number = getTimeMachineElementX( unscaledWidth, element.getLayoutBoundsWidth( false ), 0, 0 );
			var y:Number = getTimeMachineElementY( unscaledHeight, element.getLayoutBoundsHeight( false ), 0, 0 );
			
			element.depth = ( rotation > 180 ) ? -1 : numIndicesInView;
			
//			element.transformAround( new Vector3D( element.width / 2, element.height, 0 ) );
			
			element.transformAround( new Vector3D( element.width / 2, element.height, 0 ),
				null,
				new Vector3D( rotation, 0, 0 ),
				new Vector3D( x + halfWidth, y + element.height, 0 ),
				null, null,
				new Vector3D( x + halfWidth, y + element.height, 0 ),
				false );
		}
		
		override protected function updateElementInView( element:IVisualElement, viewIndex:int, firstIndexInViewOffsetPercent:Number, alphaDeltaOffset:Number, zDeltaOffset:Number ):void
		{
			super.updateElementInView( element, viewIndex, firstIndexInViewOffsetPercent, alphaDeltaOffset, zDeltaOffset );
			
			element.transformAround( null,
				null,
				null,
				null,
				null, null,
				null,
				false );
		}
		
//		/**
//		 *	@private
//		 * 
//		 *	A convenience method used to transform an element by applying
//		 *  the current values if the TransforCalulator instance.
//		 */
//		private function elementTransformAround( element:IVisualElement ):void
//		{
//			var halfWidth:Number = element.width / 2;
//			var halfHeight:Number = element.height / 2;
//			var offsetX:Number = halfWidth * ( _elementHorizontalCenterMultiplier - 0.5 ) * 2;
//			var offsetY:Number = halfHeight * ( _elementVerticalCenterMultiplier - 0.5 ) * 2;
//			
//			element.transformAround( new Vector3D( element.width / 2, element.height, 0 ),
//				null,
//				null,
//				null,
//				null, null,
//				null,
//				false );
//		}
		
	}
}