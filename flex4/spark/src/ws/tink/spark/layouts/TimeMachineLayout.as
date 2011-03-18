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

package ws.tink.spark.layouts
{
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	
	import mx.core.IVisualElement;
	
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	
	import ws.tink.spark.layouts.supportClasses.PerspectiveNavigatorLayoutBase;

	/**
	 *  The NavigatorGroup class is the base navigator container class for visual elements.
	 *  The NavigatorGroup container takes as children any components that implement 
	 *  the IUIComponent interface, and any components that implement 
	 *  the IGraphicElement interface giving one focus by way of the layout which must
	 *  implement INavigatorLayout.
	 *  Use this container when you want to manage visual children, 
	 *  both visual components and graphical components that you want to switch between. 
	 *
	 *  <p>To improve performance and minimize application size, 
	 *  the NavigatorGroup container cannot be skinned. 
	 *  If you want to apply a skin, use the Navigator instead. </p>
	 *  
	 *  <p>The NavigatorGroup container has the following default characteristics:</p>
	 *  <table class="innertable">
	 *     <tr><th>Characteristic</th><th>Description</th></tr>
	 *     <tr><td>Default size</td><td>Large enough to display its children</td></tr>
	 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
	 *     <tr><td>Maximum size</td><td>10000 pixels wide and 10000 pixels high</td></tr>
	 *  </table>
	 * 
	 *  @mxml
	 *
	 *  <p>The <code>&lt;s:NavigatorGroup&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:TimeMachineLayout
	 *    <strong>Properties</strong>
	 *    numVisibleElements="3"
	 *    depthColor="-1"
	 *    verticalAlign="middle"
	 *    horizontalAlign="center"
	 *    horizontalOffset="0"
	 *    verticalOffset="0"
	 *    maximumZ="300"
	 *    horizontalDisplacement="0"
	 *    verticalDisplacement="0"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see ws.tink.spark.containers.Navigator
	 *  @see ws.tink.spark.containers.NavigatorGroup
	 *  @see ws.tink.spark.controls.DataNavigator
	 *  @see ws.tink.spark.controls.DataNavigatorGroup
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class TimeMachineLayout extends PerspectiveNavigatorLayoutBase
	{

		
		
		private var _zDelta : Number;
		private var _colorDelta : Number;
		
		private var _zChanged			: Boolean;
		
		
		private var _visibleElements	: Vector.<IVisualElement>;
		private var _colorTransform	: ColorTransform;
		
		
		
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
		public function TimeMachineLayout()
		{
			super();
			
			_zChanged = true;
			useVirtualLayout = true
			_numVisibleElements = 3;
			_colorTransform = new ColorTransform();
			_depthColor = -1;
		}
		
		
//		public function get numIndicesInView():int
//		{
//			return _numIndicesInView;
//		}
//		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  numVisibleElements
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for numVisibleElements.
		 */
		private var _numVisibleElements		: int;
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */ 
		public function get numVisibleElements():int
		{
			return _numVisibleElements;
		}
		/**
		 *  @private
		 */
		public function set numVisibleElements( value:int ) : void
		{
			if( _numVisibleElements == value ) return;
			
			_numVisibleElements = value;
			invalidateTargetDisplayList();
		}
		
		
		
		//----------------------------------
		//  depthColor
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for depthColor.
		 */
		private var _depthColor		: int = -1;
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */ 
		public function get depthColor():int
		{
			return _depthColor;
		}
		/**
		 *  @private
		 */
		public function set depthColor( value:int ) : void
		{
			if( _depthColor == value ) return;
			
			_depthColor = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  verticalAlign
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for verticalAlign.
		 */
		private var _verticalAlign:String = VerticalAlign.MIDDLE;
		
		[Inspectable(category="General", enumeration="top,bottom,middle", defaultValue="middle")]
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */ 
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		/**
		 *  @private
		 */
		public function set verticalAlign(value:String):void
		{
			if( value == _verticalAlign ) return;
			
			_verticalAlign = value;
			
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  horizontalAlign
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for horizontalAlign.
		 */
		private var _horizontalAlign:String = HorizontalAlign.CENTER;
		
		[Inspectable(category="General", enumeration="left,right,center", defaultValue="center")]
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		/**
		 *  @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if( value == _horizontalAlign ) return;
			
			_horizontalAlign = value;
			
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  horizontalOffset
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for horizontalOffset.
		 */
		private var _horizontalAlignOffset:Number = 0;
		
		[Inspectable(category="General", defaultValue="0")]
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get horizontalOffset():Number
		{
			return _horizontalAlignOffset;
		}
		/**
		 *  @private
		 */
		public function set horizontalOffset(value:Number):void
		{
			if( _horizontalAlignOffset == value ) return;
			
			_horizontalAlignOffset = value;
			invalidateTargetDisplayList();
		}    
		
		
		//----------------------------------
		//  verticalOffset
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for verticalOffset.
		 */
		private var _verticalAlignOffset:Number = 0;
		
		[Inspectable(category="General", defaultValue="0")]
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get verticalOffset():Number
		{
			return _verticalAlignOffset;
		}
		/**
		 *  @private
		 */
		public function set verticalOffset(value:Number):void
		{
			if( _verticalAlignOffset == value ) return;
			
			_verticalAlignOffset = value;
			invalidateTargetDisplayList();
		}    

		
		//----------------------------------
		//  maximumZ
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for maximumZ.
		 */
		private var _maximumZ 		: Number = 300;
		
		/**
		 * Distance between each item
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		[Inspectable(category="General", defaultValue="300")]
		public function get maximumZ() : Number
		{
			return _maximumZ;
		}
		/**
		 *  @private
		 */
		public function set maximumZ( value : Number ) : void
		{
			if( _maximumZ == value ) return;
			
			_zChanged = true;
			_maximumZ = value;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  horizontalDisplacement
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for horizontalDisplacement.
		 */
		private var _horizontalDisplacement:Number = 0;
		
		[Inspectable(category="General")]
		/**
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get horizontalDisplacement() : Number
		{
			return _horizontalDisplacement;
		}
		/**
		 *  @private
		 */
		public function set horizontalDisplacement( value : Number ) : void
		{
			if ( _horizontalDisplacement != value )
			{
				_horizontalDisplacement = value;
				invalidateTargetDisplayList();
			}
		}

		
		//----------------------------------
		//  verticalDisplacement
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for verticalDisplacement.
		 */
		private var _verticalDisplacement:Number = 0;
		
		[Inspectable(category="General")]
		/**
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get verticalDisplacement() : Number
		{
			return _verticalDisplacement;
		}
		/**
		 *  @private
		 */
		public function set verticalDisplacement( value : Number ) : void
		{
			if ( _verticalDisplacement != value )
			{
				_verticalDisplacement = value;
				invalidateTargetDisplayList();
			}
		}

		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		protected function updateFirstElementInView( element:IVisualElement, firstIndexInViewOffsetPercent:Number ):void
		{
			setElementLayoutBoundsSize( element, false );
			element.depth = numIndicesInView - 1;
			
			_colorTransform.redMultiplier = _colorTransform.greenMultiplier = _colorTransform.blueMultiplier = 1;
			_colorTransform.alphaMultiplier = 1 - firstIndexInViewOffsetPercent;
			_colorTransform.redOffset = _colorTransform.greenOffset = _colorTransform.blueOffset = _colorTransform.alphaOffset = 0;
			applyColorTransformToElement( element, _colorTransform );
			
			var matrix:Matrix3D = new Matrix3D();
			matrix.appendTranslation( 
				getTimeMachineElementX( unscaledWidth, element.getLayoutBoundsWidth( false ), 0 , firstIndexInViewOffsetPercent ),
				getTimeMachineElementY( unscaledHeight, element.getLayoutBoundsHeight( false ), 0 , firstIndexInViewOffsetPercent ),
				-_zDelta * firstIndexInViewOffsetPercent
			);
			element.setLayoutMatrix3D( matrix, false );
			element.visible = true;
		}
		
		protected function updateElementInView( element:IVisualElement, viewIndex:int, firstIndexInViewOffsetPercent:Number, alphaDeltaOffset:Number, zDeltaOffset:Number ):void
		{
			var colorValue:Number = ( ( _colorDelta * viewIndex ) - alphaDeltaOffset );
			setElementLayoutBoundsSize( element, false );
			element.depth = numIndicesInView - ( viewIndex + 1 );
			
			if( _depthColor > -1 )
			{
				_colorTransform.color = _depthColor;
				_colorTransform.redOffset *= colorValue;
				_colorTransform.greenOffset *= colorValue;
				_colorTransform.blueOffset *= colorValue;
				_colorTransform.alphaMultiplier = ( colorValue == 1 ) ? 0 : 1;
				_colorTransform.redMultiplier = _colorTransform.greenMultiplier = _colorTransform.blueMultiplier = 1 - colorValue;
			}
			else
			{
				_colorTransform.alphaMultiplier = _colorTransform.redMultiplier = _colorTransform.greenMultiplier = _colorTransform.blueMultiplier = 1;
				_colorTransform.redOffset = _colorTransform.greenOffset = _colorTransform.blueOffset = _colorTransform.alphaOffset = 0;
			}
			
			applyColorTransformToElement( element, _colorTransform );
			
			var matrix:Matrix3D = new Matrix3D();
			matrix.appendTranslation( getTimeMachineElementX( unscaledWidth, element.getLayoutBoundsWidth( false ), viewIndex, firstIndexInViewOffsetPercent ),
				getTimeMachineElementY( unscaledHeight, element.getLayoutBoundsHeight( false ), viewIndex, firstIndexInViewOffsetPercent ),
				( _zDelta * viewIndex ) - zDeltaOffset );
			element.setLayoutMatrix3D( matrix, false );
			element.visible = true;
		}
		
		private function updateVisibleElements( element:IVisualElement, prevElements:Vector.<IVisualElement> ):void
		{
			_visibleElements.push( element );
			var prevIndex:int = prevElements.indexOf( element );
			if( prevIndex >= 0 ) prevElements.splice( prevIndex, 1 );
		}
		
		protected function getElementX( unscaledWidth:Number, elementWidth:Number ):Number
		{
			switch( horizontalAlign )
			{
				case HorizontalAlign.LEFT :
				{
					return Math.round( horizontalOffset );
				}
				case HorizontalAlign.RIGHT :
				{
					return Math.round( unscaledWidth - elementWidth + horizontalOffset );
				}
				default :
				{
					return Math.round( ( ( unscaledWidth - elementWidth ) / 2 )  + horizontalOffset );
				}
			}
			return 1;
		}
		
		protected function getElementY( unscaledHeight:Number, elementHeight:Number ):Number
		{
			switch( verticalAlign )
			{
				case VerticalAlign.TOP :
				{
					return Math.round( verticalOffset );
				}
				case VerticalAlign.BOTTOM :
				{
					return Math.round( unscaledHeight - elementHeight + verticalOffset );
				}
				default :
				{
					return Math.round( ( ( unscaledHeight - elementHeight ) / 2 )  + verticalOffset );
				}
			}
		}
		
		protected function getTimeMachineElementX( unscaledWidth:Number, elementWidth:Number, i:int, offset:Number ):Number
		{
			return getElementX( unscaledWidth, elementWidth ) + ( ( _horizontalDisplacement * i ) - ( _horizontalDisplacement * offset ) );
		}
		
		protected function getTimeMachineElementY( unscaledHeight:Number, elementHeight:Number, i:int, offset:Number ):Number
		{
			return getElementY( unscaledHeight, elementHeight ) + ( ( _verticalDisplacement * i ) - ( _verticalDisplacement * offset ) );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		override public function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			if( _zChanged )
			{
				_zChanged = false;
				
				_zDelta = _maximumZ / ( _numVisibleElements + 1 );
				_colorDelta = 1 / ( _numVisibleElements );
			}
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
		}
		
		override protected function updateDisplayListVirtual():void
		{
			super.updateDisplayListVirtual();
			
			var prevVirtualElements:Vector.<IVisualElement> = ( _visibleElements ) ? _visibleElements.concat() : new Vector.<IVisualElement>();
			_visibleElements = new Vector.<IVisualElement>();
			
			const firstIndexInViewOffsetPercent:Number = ( selectedIndexOffset < 0 ) ? 1 + selectedIndexOffset : selectedIndexOffset;
			const zDeltaOffset:Number = _zDelta * firstIndexInViewOffsetPercent;
			const alphaDeltaOffset:Number = _colorDelta * firstIndexInViewOffsetPercent;
			
			var i:int;
			var element:IVisualElement;
			
			// Manage first item outside the loop as its slightly different
			element = target.getVirtualElementAt( indicesInLayout[ firstIndexInView ] );
			if( element )
			{
				updateFirstElementInView( element, firstIndexInViewOffsetPercent );
				updateVisibleElements( element, prevVirtualElements );
			}
			
			for( i = 1; i < numIndicesInView; i++ )
			{
				element = target.getVirtualElementAt( indicesInLayout[ firstIndexInView + i ] );
				if( !element ) continue;
				updateElementInView( element, i, firstIndexInViewOffsetPercent, alphaDeltaOffset, zDeltaOffset );
				updateVisibleElements( element, prevVirtualElements );
			}
			
			var numPrev:int = prevVirtualElements.length;
			for( i = 0; i < numPrev; i++ )
			{
				IVisualElement( prevVirtualElements[ i ] ).visible = false;
			}
			
		}
		
		override protected function updateDisplayListReal():void
		{
			super.updateDisplayListReal();
 			
			var prevVirtualElements:Vector.<IVisualElement> = ( _visibleElements ) ? _visibleElements.concat() : new Vector.<IVisualElement>();
			_visibleElements = new Vector.<IVisualElement>();
			
			const firstIndexInViewOffsetPercent:Number = ( selectedIndexOffset < 0 ) ? 1 + selectedIndexOffset : selectedIndexOffset;
			const zDeltaOffset:Number = _zDelta * firstIndexInViewOffsetPercent;
			const alphaDeltaOffset:Number = _colorDelta * firstIndexInViewOffsetPercent;
			
			var element:IVisualElement;
			for( var i:int = 0; i < numElementsInLayout; i++ )
			{
				if( i < firstIndexInView || i > lastIndexInView )
				{
					element = target.getElementAt( indicesInLayout[ i ] );
					element.visible = false;
				}
				else if( i == firstIndexInView )
				{
					element = target.getElementAt( indicesInLayout[ i ] );
					updateFirstElementInView( element, firstIndexInViewOffsetPercent );
					updateVisibleElements( element, prevVirtualElements );
				}
				else
				{
					element = target.getElementAt( indicesInLayout[ i ] );
					updateElementInView( element, i - firstIndexInView, firstIndexInViewOffsetPercent, alphaDeltaOffset, zDeltaOffset );
					updateVisibleElements( element, prevVirtualElements );
				}
			}
		}
		
		
		override protected function selectedIndexChange():void
		{
			super.selectedIndexChange();
			
			var firstIndexInView:int;
			
			if( selectedIndexOffset < 0 )
			{
				firstIndexInView = selectedIndex - 1;
			}
			else
			{
				firstIndexInView = selectedIndex;
			}
			
			indicesInView( firstIndexInView, Math.min( _numVisibleElements, numElementsInLayout - firstIndexInView ) );
		}

	}
}