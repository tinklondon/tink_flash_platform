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

package ws.tink.spark.containers
{
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	
	[DefaultProperty("mxmlContentFactory")]
	
	public class Form extends SkinnableContainer
	{
		
		
		/**
		 *  @private
		 */
		private var measuredLabelWidth:Number;
		
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function Form()
		{
			super();
			
		}
		
		
		
		override public function set mxmlContent(value:Array):void
		{
			for each( var element:IVisualElement in value )
			{
				element.owner = this;
			}
			super.mxmlContent = value;
		}
		
		override public function addElement(element:IVisualElement):IVisualElement
		{
			element.owner = this;
			return super.addElement( element );
		}
		
		override public function addElementAt(element:IVisualElement, index:int):IVisualElement
		{
			element.owner = this;
			return super.addElementAt( element, index );
		}
		
		override protected function measure():void
		{
			super.measure();
			
			calculateLabelWidth();
		}
		
		/**
		 *  The maximum width, in pixels, of the labels of the FormItems containers in this Form.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
//		public function get maxLabelWidth():Number
//		{
//			var n:int = numChildren;
//			for (var i:int = 0; i < n; i++)
//			{
//				var element:IVisualElement = getElementAt(i);
//				if (element is FormItem)
//				{
//					var itemLabel:Label = FormItem(element).labelDisplay;
//					if (itemLabel)
//						return itemLabel.width;
//				}
//			}
//			
//			return 0;
//		}
		
		
		/**
		 *  @private
		 */
		internal function invalidateLabelWidth():void
		{
			// We only need to invalidate the label width
			// after we've been initialized.
			if (!isNaN(measuredLabelWidth) && initialized)
			{
				measuredLabelWidth = NaN;
				
				// Need to invalidate the size of all children
				// to make sure they respond to the label width change.
				var n:int = numElements;
				for (var i:int = 0; i < n; i++)
				{
					var child:IVisualElement = getElementAt(i);
					if (child is IInvalidating)
						IInvalidating(child).invalidateSize();
				}
			}
		}
		
		/**
		 *  @private
		 */
		internal function calculateLabelWidth():Number
		{
			// See if we've already calculated it.
			if (!isNaN(measuredLabelWidth))
				return measuredLabelWidth;
			
			var labelWidth:Number = 0;
			var labelWidthSet:Boolean = false;
			
			// Determine best label width.
			var n:int = numElements;
			for (var i:int = 0; i < n; i++)
			{
				var child:IVisualElement = getElementAt(i);
				
				if (child is FormItem && FormItem(child).includeInLayout)
				{
					labelWidth = Math.max(labelWidth,
						FormItem(child).getPreferredLabelWidth());
					// only set measuredLabelWidth yet if we have at least one FormItem child
					labelWidthSet = true;
				}
				
				IInvalidating( child ).invalidateDisplayList();
			}
			
			if (labelWidthSet)
				measuredLabelWidth = labelWidth;
			
			return labelWidth;
		}
	}
}