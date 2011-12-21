////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2008 Tink Ltd | http://www.tink.ws
//	
//	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//	documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
//	the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//	to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//	
//	The above copyright notice and this permission notice shall be included in all copies or substantial portions
//	of the Software.
//	
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
//	THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
//	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

package ws.tink.mx.containers.utilityClasses
{

import mx.containers.BoxDirection;
import mx.containers.utilityClasses.BoxLayout;
import mx.containers.utilityClasses.Flex;
import mx.controls.scrollClasses.ScrollBar;
import mx.core.Container;
import mx.core.EdgeMetrics;
import mx.core.IUIComponent;
import mx.core.ScrollPolicy;
import mx.core.mx_internal;

use namespace mx_internal;

[ExcludeClass]

/**
 *  @private
 *  The BoxLayout class is for internal use only.
 */
public class ReverseBoxLayout extends BoxLayout
{
	//include "../../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 */
	public function ReverseBoxLayout()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  direction
	//----------------------------------

	/**
	 *  @private
	 */
	//public var direction:String = BoxDirection.VERTICAL;

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Measure container as per Box layout rules.
	 */
	/*override public function measure():void
	{
		var target:Container = super.target;

		var isVertical:Boolean = overrideIsVertical();

		var minWidth:Number = 0;
		var minHeight:Number = 0;

		var preferredWidth:Number = 0;
		var preferredHeight:Number = 0;

		var n:int = target.numChildren;
		var numChildrenWithOwnSpace:int = n;
		for (var i:int = 0; i < n; i++)
		{
			var child:IUIComponent = IUIComponent(target.getChildAt(i));

			if (!child.includeInLayout)
			{
				numChildrenWithOwnSpace--;
				continue;
			}

			var wPref:Number = child.getExplicitOrMeasuredWidth();
			var hPref:Number = child.getExplicitOrMeasuredHeight();

			if (isVertical)
			{
				minWidth = Math.max(!isNaN(child.percentWidth) ?
					child.minWidth : wPref, minWidth);

				preferredWidth = Math.max(wPref, preferredWidth);

				minHeight += !isNaN(child.percentHeight) ?
					child.minHeight : hPref;

				preferredHeight += hPref;

			}
			else
			{
				minWidth += !isNaN(child.percentWidth) ?
					child.minWidth : wPref;

				preferredWidth += wPref;

				minHeight = Math.max(!isNaN(child.percentHeight) ?
					child.minHeight : hPref, minHeight);

				preferredHeight = Math.max(hPref, preferredHeight);

			}
		}

		var wPadding:Number = widthPadding(numChildrenWithOwnSpace);
		var hPadding:Number = heightPadding(numChildrenWithOwnSpace);

		target.measuredMinWidth = minWidth + wPadding;
		target.measuredMinHeight = minHeight + hPadding;

		target.measuredWidth = preferredWidth + wPadding;
		target.measuredHeight = preferredHeight + hPadding;
	}*/

	/**
	 *  @private
	 *  Lay out children as per Box layout rules.
	 */
	override public function updateDisplayList(unscaledWidth:Number,
											   unscaledHeight:Number):void
	{
		var target:Container = super.target;

		var n:int = target.numChildren;
		if (n == 0)
			return;

		var vm:EdgeMetrics = target.viewMetricsAndPadding;

		var paddingLeft:Number = target.getStyle("paddingLeft");
		var paddingTop:Number = target.getStyle("paddingTop");

		var horizontalAlign:Number = getHorizontalAlignValue();
		var verticalAlign:Number = getVerticalAlignValue();

		var mw:Number = target.scaleX > 0 && target.scaleX != 1 ?
						target.minWidth / Math.abs(target.scaleX) :
						target.minWidth;
		var mh:Number = target.scaleY > 0 && target.scaleY != 1 ?
						target.minHeight / Math.abs(target.scaleY) :
						target.minHeight;

		var w:Number = Math.max(unscaledWidth, mw) - vm.right - vm.left;
		var h:Number = Math.max(unscaledHeight, mh) - vm.bottom - vm.top;

		var horizontalScrollBar:ScrollBar = target.horizontalScrollBar;
		var verticalScrollBar:ScrollBar = target.verticalScrollBar;

		var gap:Number;
		var numChildrenWithOwnSpace:int;
		var excessSpace:Number;
		var top:Number;
		var left:Number;
		var i:int;
		var obj:IUIComponent;

		if (n == 1)
		{
			// This is an optimized code path for the case where there's one
			// child. This case is especially common when the Box is really
			// a GridItem. This code path works for both horizontal and
			// vertical layout.

			var child:IUIComponent = IUIComponent(target.getChildAt(0));

			var percentWidth:Number = child.percentWidth;
			var percentHeight:Number = child.percentHeight;

			var width:Number;
			if (percentWidth)
			{
				width = Math.max(child.minWidth,
					Math.min(child.maxWidth,
					((percentWidth >= 100) ? w : (w * percentWidth / 100))));
			}
			else
			{
				width = child.getExplicitOrMeasuredWidth();
			}

			var height:Number
			if (percentHeight)
			{
				height = Math.max(child.minHeight,
					Math.min(child.maxHeight,
					((percentHeight >= 100) ? h : (h * percentHeight / 100))));
			}
			else
			{
				height = child.getExplicitOrMeasuredHeight();
			}

			// if scaled and zoom is playing, best to let the sizes be non-integer
			if (child.scaleX == 1 && child.scaleY == 1)
				child.setActualSize(Math.floor(width), Math.floor(height));
			else
				child.setActualSize(width, height);

			// Ignore scrollbar sizes for child alignment purpose.
			if (verticalScrollBar != null &&
				target.verticalScrollPolicy == ScrollPolicy.AUTO)
			{
				w += verticalScrollBar.minWidth;
			}
			if (horizontalScrollBar != null &&
				target.horizontalScrollPolicy == ScrollPolicy.AUTO)
			{
				h += horizontalScrollBar.minHeight;
			}

			// Use the child's width and height because a Resize effect might
			// have changed the child's dimensions. Bug 146158.
			left = (w - child.width) * horizontalAlign + paddingLeft;
			top = (h - child.height) * verticalAlign + paddingTop;

			child.move(Math.floor(left), Math.floor(top));
		}

		else if (overrideIsVertical()) // VBOX
		{
			gap = target.getStyle("verticalGap");

			numChildrenWithOwnSpace = n;
			for (i = 0; i < n; i++)
			{
				if (!IUIComponent(target.getChildAt(i)).includeInLayout)
					numChildrenWithOwnSpace--;
			}

			// Stretch everything as needed, including widths.
			excessSpace = Flex.flexChildHeightsProportionally(
				target, h - (numChildrenWithOwnSpace - 1) * gap, w);

			// Ignore scrollbar sizes for child alignment purpose.
			if (horizontalScrollBar != null &&
				target.horizontalScrollPolicy == ScrollPolicy.AUTO)
			{
				excessSpace += horizontalScrollBar.minHeight;
			}
			if (verticalScrollBar != null &&
				target.verticalScrollPolicy == ScrollPolicy.AUTO)
			{
				w += verticalScrollBar.minWidth;
			}

			top = paddingTop + excessSpace * verticalAlign;

			for (i = n - 1; i >= 0; i--)
			{
				obj = IUIComponent(target.getChildAt(i));
				left = (w - obj.width) * horizontalAlign + paddingLeft;
				obj.move(Math.floor(left), Math.floor(top));
				if (obj.includeInLayout)
					top += obj.height + gap;
			}
		}

		else  // HBOX
		{
			gap = target.getStyle("horizontalGap");

			numChildrenWithOwnSpace = n;
			for (i = 0; i < n; i++)
			{
				if (!IUIComponent(target.getChildAt(i)).includeInLayout)
					numChildrenWithOwnSpace--;
			}

			// stretch everything as needed including heights
			excessSpace = Flex.flexChildWidthsProportionally(
				target, w - (numChildrenWithOwnSpace - 1) * gap, h);

			// Ignore scrollbar sizes for child alignment purpose.
			if (horizontalScrollBar != null &&
				target.horizontalScrollPolicy == ScrollPolicy.AUTO)
			{
				h += horizontalScrollBar.minHeight;
			}
			if (verticalScrollBar != null &&
				target.verticalScrollPolicy == ScrollPolicy.AUTO)
			{
				excessSpace += verticalScrollBar.minWidth;
			}

			left = paddingLeft + excessSpace * horizontalAlign;

			for (i = n - 1; i >= 0; i--)
			{
				obj = IUIComponent(target.getChildAt(i));
				top = (h - obj.height) * verticalAlign + paddingTop;
				obj.move(Math.floor(left), Math.floor(top));
				if (obj.includeInLayout)
					left += obj.width + gap;
			}
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	private function overrideIsVertical():Boolean
	{
		return direction != BoxDirection.HORIZONTAL;
	}
	

	
}

}
