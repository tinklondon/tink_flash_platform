package ws.tink.spark.layouts
{
	import mx.core.ILayoutElement;
	import mx.core.LayoutElementUIComponentUtils;
	import mx.core.UIComponent;
	import mx.resources.ResourceManager;
	
	import spark.components.supportClasses.GroupBase;
	import spark.layouts.BasicLayout;
	import spark.layouts.VerticalLayout;
	import spark.layouts.supportClasses.LayoutElementHelper;
	
	public class PositionLayout extends BasicLayout
	{
		VerticalLayout
		public function PositionLayout()
		{
			super();
		}
		
		private var _positons:Array;
		public function get positions():Array
		{
			return _positons;
		}
		public function set positions( value:Array ):void
		{
			if( _positons == value ) return;
			
			_positons = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private 
		 */
		private function checkUseVirtualLayout():void
		{
			if( useVirtualLayout ) throw new Error( ResourceManager.getInstance().getString( "layout", "basicLayoutNotVirtualized" ) );
		}
		
		protected function getPositionExtX( hCenter:Number, left:Number, right:Number, x:Number ):Number
		{
//			var hCenter:Number = LayoutElementHelper.parseConstraintValue(position.horizontalCenter);
//			var left:Number    = LayoutElementHelper.parseConstraintValue(position.left);
//			var right:Number   = LayoutElementHelper.parseConstraintValue(position.right);
//			var ext:Number;
//			
			if (!isNaN(left) && !isNaN(right))
			{
				// If both left & right are set, then the extents is always
				// left + right so that the element is resized to its preferred
				// size (if it's the one that pushes out the default size of the container).
				ext = left + right;                
			}
			else if (!isNaN(hCenter))
			{
				// If we have horizontalCenter, then we want to have at least enough space
				// so that the element is within the parent container.
				// If the element is aligned to the left/right edge of the container and the
				// distance between the centers is hCenter, then the container width will be
				// parentWidth = 2 * (abs(hCenter) + elementWidth / 2)
				// <=> parentWidth = 2 * abs(hCenter) + elementWidth
				// Since the extents is the additional space that the element needs
				// extX = parentWidth - elementWidth = 2 * abs(hCenter)
				ext = Math.abs(hCenter) * 2;
			}
			else if (!isNaN(left) || !isNaN(right))
			{
				ext = isNaN(left) ? 0 : left;
				ext += isNaN(right) ? 0 : right;
			}
			else
			{
				ext = LayoutElementHelper.parseConstraintValue(position.x);
			}
			
			return ext;
		}
		
		
		protected function getExtY( element:ILayoutElement, position:Position ):Number
		{
			var vCenter:Number = LayoutElementHelper.parseConstraintValue(position.verticalCenter);
			var baseline:Number = LayoutElementHelper.parseConstraintValue(position.baseline);
			var top:Number     = LayoutElementHelper.parseConstraintValue(position.top);
			var bottom:Number  = LayoutElementHelper.parseConstraintValue(position.bottom);
			var ext:Number;
			
			if (!isNaN(top) && !isNaN(bottom))
			{
				// If both top & bottom are set, then the extents is always
				// top + bottom so that the element is resized to its preferred
				// size (if it's the one that pushes out the default size of the container).
				ext = top + bottom;                
			}
			else if (!isNaN(vCenter))
			{
				// If we have verticalCenter, then we want to have at least enough space
				// so that the element is within the parent container.
				// If the element is aligned to the top/bottom edge of the container and the
				// distance between the centers is vCenter, then the container height will be
				// parentHeight = 2 * (abs(vCenter) + elementHeight / 2)
				// <=> parentHeight = 2 * abs(vCenter) + elementHeight
				// Since the extents is the additional space that the element needs
				// extY = parentHeight - elementHeight = 2 * abs(vCenter)
				ext = Math.abs(vCenter) * 2;
			}
			else if (!isNaN(baseline))
			{
				ext = Math.round(baseline - element.baselinePosition);
			}
			else if (!isNaN(top) || !isNaN(bottom))
			{
				ext = isNaN(top) ? 0 : top;
				ext += isNaN(bottom) ? 0 : bottom;
			}
			else
			{
				ext = LayoutElementHelper.parseConstraintValue(position.y);
			}
			
			if( !isNaN( ext ) ) return ext;
			
			
			return ext;
		}
		
		/**
		 *  @private 
		 */
		override public function measure():void
		{
			// Check for unsuported values here instead of in the useVirtualLayout setter, as
			// List may toggle the property several times before the actual layout pass.
			checkUseVirtualLayout();
			super.measure();
			
			var layoutTarget:GroupBase = target;
			if (!layoutTarget)
				return;
			
			var width:Number = 0;
			var height:Number = 0;
			var minWidth:Number = 0;
			var minHeight:Number = 0;
			
			var positionIndex:int = -1;
			var position:Position;
			
			var hCenter:Number;
			var vCenter:Number;
			var baseline:Number;
			var left:Number;
			var right:Number;
			var top:Number;
			var bottom:Number;
			
			var count:int = layoutTarget.numElements;
			for( var i:int = 0; i < count; i++ )
			{
				var layoutElement:ILayoutElement = layoutTarget.getElementAt( i );
				if ( !layoutElement || !layoutElement.includeInLayout ) continue;
				
				positionIndex++;
				
				var extX:Number ;
				var extY:Number;
				
				if( _positons.length > positionIndex )
				{
					position = Position( _positons[ positionIndex ] );
					
					hCenter = LayoutElementHelper.parseConstraintValue(position.horizontalCenter);
					left    = LayoutElementHelper.parseConstraintValue(position.left);
					right   = LayoutElementHelper.parseConstraintValue(position.right);
					
					
					extX = getPositionExtX( hCenter, left, right, position.x );
					
					
					vCenter = LayoutElementHelper.parseConstraintValue(position.verticalCenter);
					baseline = LayoutElementHelper.parseConstraintValue(position.baseline);
					top     = LayoutElementHelper.parseConstraintValue(position.top);
					bottom  = LayoutElementHelper.parseConstraintValue(position.bottom);
					
					
					extY = getPositionExtY( position );
					
					
					// Extents of the element - how much additional space (besides its own width/height)
					// the element needs based on its constraints.
					
					
					if (!isNaN(left) && !isNaN(right))
					{
						// If both left & right are set, then the extents is always
						// left + right so that the element is resized to its preferred
						// size (if it's the one that pushes out the default size of the container).
						extX = left + right;                
					}
					else if (!isNaN(hCenter))
					{
						// If we have horizontalCenter, then we want to have at least enough space
						// so that the element is within the parent container.
						// If the element is aligned to the left/right edge of the container and the
						// distance between the centers is hCenter, then the container width will be
						// parentWidth = 2 * (abs(hCenter) + elementWidth / 2)
						// <=> parentWidth = 2 * abs(hCenter) + elementWidth
						// Since the extents is the additional space that the element needs
						// extX = parentWidth - elementWidth = 2 * abs(hCenter)
						extX = Math.abs(hCenter) * 2;
					}
					else if (!isNaN(left) || !isNaN(right))
					{
						extX = isNaN(left) ? 0 : left;
						extX += isNaN(right) ? 0 : right;
					}
					else
					{
						extX = layoutElement.getBoundsXAtSize(NaN, NaN);
					}
					
					if (!isNaN(top) && !isNaN(bottom))
					{
						// If both top & bottom are set, then the extents is always
						// top + bottom so that the element is resized to its preferred
						// size (if it's the one that pushes out the default size of the container).
						extY = top + bottom;                
					}
					else if (!isNaN(vCenter))
					{
						// If we have verticalCenter, then we want to have at least enough space
						// so that the element is within the parent container.
						// If the element is aligned to the top/bottom edge of the container and the
						// distance between the centers is vCenter, then the container height will be
						// parentHeight = 2 * (abs(vCenter) + elementHeight / 2)
						// <=> parentHeight = 2 * abs(vCenter) + elementHeight
						// Since the extents is the additional space that the element needs
						// extY = parentHeight - elementHeight = 2 * abs(vCenter)
						extY = Math.abs(vCenter) * 2;
					}
					else if (!isNaN(baseline))
					{
						extY = Math.round(baseline - layoutElement.baselinePosition);
					}
					else if (!isNaN(top) || !isNaN(bottom))
					{
						extY = isNaN(top) ? 0 : top;
						extY += isNaN(bottom) ? 0 : bottom;
					}
					else
					{
						extY = layoutElement.getBoundsYAtSize(NaN, NaN);
					}
					
				}
				
				hCenter = LayoutElementHelper.parseConstraintValue(layoutElement.horizontalCenter);
				vCenter = LayoutElementHelper.parseConstraintValue(layoutElement.verticalCenter);
				baseline  = LayoutElementHelper.parseConstraintValue(layoutElement.baseline);
				left    = LayoutElementHelper.parseConstraintValue(layoutElement.left);
				right   = LayoutElementHelper.parseConstraintValue(layoutElement.right);
				top     = LayoutElementHelper.parseConstraintValue(layoutElement.top);
				bottom = LayoutElementHelper.parseConstraintValue(layoutElement.bottom);
				
				// Extents of the element - how much additional space (besides its own width/height)
				// the element needs based on its constraints.
				var extX:Number;
				var extY:Number;
				
				if (!isNaN(left) && !isNaN(right))
				{
					// If both left & right are set, then the extents is always
					// left + right so that the element is resized to its preferred
					// size (if it's the one that pushes out the default size of the container).
					extX = left + right;                
				}
				else if (!isNaN(hCenter))
				{
					// If we have horizontalCenter, then we want to have at least enough space
					// so that the element is within the parent container.
					// If the element is aligned to the left/right edge of the container and the
					// distance between the centers is hCenter, then the container width will be
					// parentWidth = 2 * (abs(hCenter) + elementWidth / 2)
					// <=> parentWidth = 2 * abs(hCenter) + elementWidth
					// Since the extents is the additional space that the element needs
					// extX = parentWidth - elementWidth = 2 * abs(hCenter)
					extX = Math.abs(hCenter) * 2;
				}
				else if (!isNaN(left) || !isNaN(right))
				{
					extX = isNaN(left) ? 0 : left;
					extX += isNaN(right) ? 0 : right;
				}
				else
				{
					extX = layoutElement.getBoundsXAtSize(NaN, NaN);
				}
				
				if (!isNaN(top) && !isNaN(bottom))
				{
					// If both top & bottom are set, then the extents is always
					// top + bottom so that the element is resized to its preferred
					// size (if it's the one that pushes out the default size of the container).
					extY = top + bottom;                
				}
				else if (!isNaN(vCenter))
				{
					// If we have verticalCenter, then we want to have at least enough space
					// so that the element is within the parent container.
					// If the element is aligned to the top/bottom edge of the container and the
					// distance between the centers is vCenter, then the container height will be
					// parentHeight = 2 * (abs(vCenter) + elementHeight / 2)
					// <=> parentHeight = 2 * abs(vCenter) + elementHeight
					// Since the extents is the additional space that the element needs
					// extY = parentHeight - elementHeight = 2 * abs(vCenter)
					extY = Math.abs(vCenter) * 2;
				}
				else if (!isNaN(baseline))
				{
					extY = Math.round(baseline - layoutElement.baselinePosition);
				}
				else if (!isNaN(top) || !isNaN(bottom))
				{
					extY = isNaN(top) ? 0 : top;
					extY += isNaN(bottom) ? 0 : bottom;
				}
				else
				{
					extY = layoutElement.getBoundsYAtSize(NaN, NaN);
				}
				
				var preferredWidth:Number = layoutElement.getPreferredBoundsWidth();
				var preferredHeight:Number = layoutElement.getPreferredBoundsHeight();
				
				width = Math.max(width, extX + preferredWidth);
				height = Math.max(height, extY + preferredHeight);
				
				// Find the minimum default extents, we take the minimum width/height only
				// when the element size is determined by the parent size
				var elementMinWidth:Number =
					constraintsDetermineWidth(layoutElement) ? layoutElement.getMinBoundsWidth() :
					preferredWidth;
				var elementMinHeight:Number =
					constraintsDetermineHeight(layoutElement) ? layoutElement.getMinBoundsHeight() : 
					preferredHeight;
				
				minWidth = Math.max(minWidth, extX + elementMinWidth);
				minHeight = Math.max(minHeight, extY + elementMinHeight);
			}
			
			// Use Math.ceil() to make sure that if the content partially occupies
			// the last pixel, we'll count it as if the whole pixel is occupied.
			layoutTarget.measuredWidth = Math.ceil(Math.max(width, minWidth));
			layoutTarget.measuredHeight = Math.ceil(Math.max(height, minHeight));
			layoutTarget.measuredMinWidth = Math.ceil(minWidth);
			layoutTarget.measuredMinHeight = Math.ceil(minHeight);
		}
		
		/**
		 *  @private 
		 *  Convenience function for subclasses that invalidates the
		 *  target's size and displayList so that both layout's <code>measure()</code>
		 *  and <code>updateDisplayList</code> methods get called.
		 * 
		 *  <p>Typically a layout invalidates the target's size and display list so that
		 *  it gets a chance to recalculate the target's default size and also size and
		 *  position the target's elements. For example changing the <code>gap</code>
		 *  property on a <code>VerticalLayout</code> will internally call this method
		 *  to ensure that the elements are re-arranged with the new setting and the
		 *  target's default size is recomputed.</p> 
		 */
		private function invalidateTargetSizeAndDisplayList():void
		{
			if ( !target ) return;
			
			target.invalidateSize();
			target.invalidateDisplayList();
		}
	}
}