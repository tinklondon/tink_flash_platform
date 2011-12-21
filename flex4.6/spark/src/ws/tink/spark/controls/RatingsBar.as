/*

Copyright (c) 2011 Tink Ltd - http://www.tink.ws

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

package ws.tink.spark.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.core.mx_internal;
	import mx.events.SandboxMouseEvent;
	import mx.managers.IFocusManagerComponent;
	
	import spark.components.IItemRenderer;
	import spark.components.supportClasses.ListBase;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
	 *  The alpha of the border for this component.
	 *
	 *  @default 1.0
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="borderAlpha", type="Number", inherit="no", theme="spark, mobile", minValue="0.0", maxValue="1.0")]
	
	/**
	 *  The color of the border for this component.
	 *
	 *   @default #696969
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="borderColor", type="uint", format="Color", inherit="no", theme="spark, mobile")]
	
	/**
	 *  Controls the visibility of the border for this component.
	 *
	 *  @default true
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	[Style(name="borderVisible", type="Boolean", inherit="no", theme="spark, mobile")]
	
	
	
	public class RatingsBar extends ListBase implements IFocusManagerComponent
	{
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function RatingsBar()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  numRatings
		//----------------------------------
		
		/**
		 *  If <code>true</code> multiple selection is enabled. 
		 *  When switched at run time, the current selection
		 *  is cleared. 
		 * 
		 *  This should not be turned on when <code>interactionMode</code> 
		 *  is <code>touch</code>.
		 *
		 *  @default 5
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get numRatings():int
		{
			return dataProvider ? dataProvider.length : -1;
		}
		/**
		 *  @private
		 */
		public function set numRatings( value:int ):void
		{
			const ratings:Array = new Array();
			for( var i:int = 0; i < value; i++ )
			{
				ratings.push( i );
			}
			dataProvider = new ArrayList( ratings );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private function updateSelection():void
		{
			if( !dataGroup || !dataGroup.dataProvider || !dataGroup.dataProvider.length ) return;
			
			var value:Number;
			var min:Number;
			var max:Number;
			var gap:Number;
			var divisibleSize:Number;
			const numItems:int = dataProvider.length - 1;
			if( layout is HorizontalLayout )
			{
				const hl:HorizontalLayout = HorizontalLayout( layout );
				gap = hl.gap;
				value = dataGroup.mouseX;
				min = hl.paddingLeft;
				max = unscaledWidth - hl.paddingRight;
				divisibleSize = unscaledWidth - hl.paddingLeft - hl.paddingRight;
			}
			else if( layout is VerticalLayout )
			{
				const vl:VerticalLayout = VerticalLayout( layout );
				gap = vl.gap;
				value = dataGroup.mouseY;
				min = vl.paddingTop;
				max = unscaledHeight - vl.paddingBottom;
				divisibleSize = unscaledHeight - vl.paddingTop - vl.paddingBottom;
			}
			
			
			if( value < min )
			{
				setSelectedIndex( -1, true );
			}
			else if( value > max )
			{
				setSelectedIndex( numItems, true );
			}
			else
			{
				const d:Number = value - min;
				setSelectedIndex( Math.floor( ( d / divisibleSize ) * ( numItems + 1 ) ), true );
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function commitSelection(dispatchChangedEvents:Boolean=true):Boolean
		{
			const commit:Boolean = super.commitSelection( dispatchChangedEvents );
			if( selectedIndex < 0 ) itemSelected( selectedIndex, true );
			return commit;
		}
		
		/**
		 *  @private
		 */
		override protected function itemSelected(index:int, selected:Boolean):void
		{
			if( !selected || !dataProvider || !dataGroup ) return;
			
			var element:IItemRenderer;
			const numElements:int = dataProvider.length;
			for( var i:int = 0; i < numElements; i++ )
			{
				element = dataGroup.getElementAt( i ) as IItemRenderer;
				if( element ) element.selected = i <= index;
			}
		}
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if( instance == dataGroup ) dataGroup.addEventListener( MouseEvent.MOUSE_DOWN, onDataGroupMouseDown, false, 0, true );
		}
		
		/**
		 *  @private
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if( instance == dataGroup ) dataGroup.removeEventListener( MouseEvent.MOUSE_DOWN, onDataGroupMouseDown, false );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		protected function onDataGroupMouseDown(event:MouseEvent):void
		{
			const sm:DisplayObject = systemManager.getSandboxRoot();
			sm.addEventListener(MouseEvent.MOUSE_MOVE, onSystemManagerMouseMove);
			sm.addEventListener(MouseEvent.MOUSE_UP, onSystemManagerMouseUp);
			sm.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, onSystemManagerMouseUp);
			updateSelection();
		}
		
		/**
		 *  @private
		 */
		protected function onSystemManagerMouseMove(event:MouseEvent):void
		{
			updateSelection();
		}
		
		/**
		 *  @private
		 */
		protected function onSystemManagerMouseUp(event:Event):void
		{
			const sm:DisplayObject = systemManager.getSandboxRoot();
			sm.removeEventListener(MouseEvent.MOUSE_MOVE, onSystemManagerMouseMove);
			sm.removeEventListener(MouseEvent.MOUSE_UP, onSystemManagerMouseUp);
			sm.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, onSystemManagerMouseUp);
		}		
		
	}
}