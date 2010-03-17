////////////////////////////////////////////////////////////////////////////////
//
//      Copyright (c) 2010 Tink Ltd | http://www.tink.ws
//      
//      Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//      documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
//      the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//      to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//      
//      The above copyright notice and this permission notice shall be included in all copies or substantial portions
//      of the Software.
//      
//      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
//      THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//      AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
//      TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//      SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////

package ws.tink.spark.layouts
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.ILayoutElement;
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.effects.EffectInstance;
	import mx.effects.IEffect;
	import mx.effects.IEffectInstance;
	import mx.events.EffectEvent;
	
	import spark.components.Scroller;
	import spark.components.supportClasses.GroupBase;
	import spark.effects.Fade;
	import spark.effects.Move;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	import spark.layouts.supportClasses.LayoutBase;
	import spark.utils.BitmapUtil;
	
	import ws.tink.spark.layouts.supportClasses.NavigatorLayoutBase;

	use namespace mx_internal;
	
	/**
	 * Flex 4 Time Machine Layout
	 */
	[Event(name="change", type="flash.events.Event")]
	public class StackLayout extends NavigatorLayoutBase
	{
		
		private var _bitmapFrom		: BitmapData;
		private var _bitmapTo		: BitmapData
		
		private var _stackIndex		: int = -2;
		
		private var _numVirtualItems	: int = 1;
		
		public var effect			: IEffect;
		private var _effectInstance		: EffectInstance;
		private var _selectedElement		: IVisualElement;
		
		private var _elementMaxDimensions		: ElementMaxDimensions;
		

		private var _verticalAlign:String = VerticalAlign.TOP;
		[Inspectable(category="General", enumeration="top,bottom,middle,justify,contentJustify", defaultValue="top")]
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		public function set verticalAlign(value:String):void
		{
			if( value == _verticalAlign ) return;
			
			_verticalAlign = value;
			
			invalidateTargetDisplayList();
		}
		
		
		private var _horizontalAlign:String = HorizontalAlign.JUSTIFY;
		[Inspectable(category="General", enumeration="left,right,center,justify,contentJustify", defaultValue="left")]
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		public function set horizontalAlign(value:String):void
		{
			if( value == _horizontalAlign ) return;
			
			_horizontalAlign = value;
			
			invalidateTargetDisplayList();
		}
		
		override public function set target(value:GroupBase):void
		{
			if( target == value ) return;
			
			super.target = value;
			
			_elementMaxDimensions = new ElementMaxDimensions();
		}
		
		public function get numVirtualItems():int
		{
			return _numVirtualItems;
		}
		public function set numVirtualItems( value:int ) : void
		{
			if( _numVirtualItems == value ) return;
			
			_numVirtualItems = value;
			invalidateTargetDisplayList();
		}

		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if( _effectInstance ) _effectInstance.end();
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
//			target.setContentSize( _selectedElement.width, _selectedElement.height );
			
			if( _stackIndex != selectedIndex )
			{
				if( effect && _stackIndex >= 0 )
				{
					target.validateNow();
					
					_bitmapTo = BitmapUtil.getSnapshot(IUIComponent(target));
					
					Object( effect ).bitmapTo = _bitmapTo;
					Object( effect ).bitmapFrom = _bitmapFrom;
					_effectInstance = EffectInstance( effect.play( [ target ] )[ 0 ] );
					_effectInstance.addEventListener( EffectEvent.EFFECT_END, onEffectEnd, false, 0, true );
					
					Object( effect ).bitmapTo = null;
					Object( effect ).bitmapFrom = null;
				}
				
				_stackIndex = selectedIndex;
			}
		}
		
		override protected function updateDisplayListVirtual():void
		{
			super.updateDisplayListVirtual();
			
			if( _selectedElement ) _selectedElement.visible = false;
			
			var eltWidth:Number = ( horizontalAlign == HorizontalAlign.JUSTIFY ) ? Math.max( 0, unscaledWidth ) : NaN;
			var eltHeight:Number = ( verticalAlign == VerticalAlign.JUSTIFY ) ? Math.max( 0, unscaledHeight ) : NaN;; 
			
			_selectedElement = target.getVirtualElementAt( firstIndexInView, eltWidth, eltHeight );
			_selectedElement.visible = true;
		
			_elementMaxDimensions.update( _selectedElement );
				
			_selectedElement.setLayoutBoundsSize( 
				calculateElementWidth( _selectedElement, unscaledWidth, _elementMaxDimensions.width ),
				calculateElementHeight( _selectedElement, unscaledHeight, _elementMaxDimensions.height ) );
			
			dispatchEvent( new Event( "change" ) );
		}
		
		/**
		 *  @private
		 * 
		 *  Used only for virtual layout.
		 */
		private function calculateElementWidth( element:ILayoutElement, targetWidth:Number, containerWidth:Number ):Number
		{
			// If percentWidth is specified then the element's width is the percentage
			// of targetWidth clipped to min/maxWidth and to (upper limit) targetWidth.
			var percentWidth:Number = element.percentWidth;
			if( !isNaN( percentWidth ) )
			{
				var width:Number = percentWidth * 0.01 * targetWidth;
				return Math.min( targetWidth, Math.min( element.getMaxBoundsWidth(), Math.max( element.getMinBoundsWidth(), width ) ) );
			}
			switch( horizontalAlign )
			{
				case HorizontalAlign.JUSTIFY :
				{
					return targetWidth;
				}
				case HorizontalAlign.CONTENT_JUSTIFY : 
				{
					return Math.max( element.getPreferredBoundsWidth(), containerWidth );
				}
			}
			return NaN;  // not constrained
		}
		
		/**
		 *  @private
		 * 
		 *  Used only for virtual layout.
		 */
		private function calculateElementHeight( element:ILayoutElement, targetHeight:Number, containerHeight:Number):Number
		{
			// If percentWidth is specified then the element's width is the percentage
			// of targetWidth clipped to min/maxWidth and to (upper limit) targetWidth.
			var percentHeight:Number = element.percentHeight;
			if( !isNaN( percentHeight ) )
			{
				var height:Number = percentHeight * 0.01 * targetHeight;
				return Math.min( targetHeight, Math.min( element.getMaxBoundsHeight(), Math.max( element.getMinBoundsHeight(), height ) ) );
			}
			switch( verticalAlign )
			{
				case VerticalAlign.JUSTIFY :
				{
					return targetHeight;
				}
				case VerticalAlign.CONTENT_JUSTIFY : 
				{
					return Math.max( element.getPreferredBoundsHeight(), containerHeight );
				}
			}
			return NaN;  // not constrained
		}
		
		
		protected function onEffectEnd( event:EffectEvent ):void
		{
			_effectInstance.removeEventListener( EffectEvent.EFFECT_END, onEffectEnd, false );
			_effectInstance = null;
			
			_bitmapTo.dispose();
			_bitmapFrom.dispose();
		}
		
//		override protected function scrollPositionChanged() : void
//		{
//			super.scrollPositionChanged();
//			
//			if( !target ) return;
//			
//			
//		}
		
		override protected function updateSelectedIndex( index:int, offset:Number ):void
		{
			if( selectedIndex == index ) return;
			
			if( effect && selectedIndex >= 0 )
			{
				try
				{
					_bitmapFrom = BitmapUtil.getSnapshot(IUIComponent(target));
				}
				catch( e:Error )
				{
					_bitmapFrom = new BitmapData( 30, 30, false, 0x000000 );
					
				}
			}
			
			super.updateSelectedIndex( index, offset );
			
			var firstIndexInView:int;
			
			if( selectedIndexOffset < 0 )
			{
				firstIndexInView = selectedIndex - 1;
			}
			else
			{
				firstIndexInView = selectedIndex;
			}
			
			indicesInView( firstIndexInView, 1 );
		}
		
	}
}
import mx.core.ILayoutElement;

class ElementMaxDimensions
{
	
	private var _width	: Number;
	private var _height	: Number;
	
	public function ElementMaxDimensions()
	{
		
	}
	
	public function update( element:ILayoutElement ):void
	{
		var w:Number = Math.min( element.getPreferredBoundsWidth(), element.getLayoutBoundsWidth() );
		var h:Number = Math.min( element.getPreferredBoundsHeight(), element.getLayoutBoundsHeight() );
		if( w > _width ) w = _width;
		if( h > _height ) w = _height;
	}
	
	public function get width():Number
	{
		return _width;
	}
	
	public function get height():Number
	{
		return _height;
	}
	

}