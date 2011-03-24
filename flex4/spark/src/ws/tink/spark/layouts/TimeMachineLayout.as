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
	
	import ws.tink.spark.layouts.supportClasses.PerspectiveAnimationNavigatorLayoutBase;

	/**
	 *  The TimeMachineLayout class arranges the layout elements in a depth sequence,
	 *  front to back, with optional depths between the elements and optional aligment
	 *  the sequence of elements.
	 *
	 *  <p>The vertical position of the elements is determined by a combination
	 *  of the <code>verticalAlign</code>, <code>verticalOffset</code>,
	 *  <code>verticalDisplacement</code> and the number of indices the element
	 *  is from the <code>selectedIndex</code> property.
	 *  First the element is aligned using the <code>verticalAlign</code> property
	 *  and then the <code>verticalOffset</code> is applied. The value of
	 *  <code>verticalDisplacement</code> is then multiplied of the number of
	 *  elements the element is from the selected element.</p>
	 *
	  *  <p>The horizontal position of the elements is determined by a combination
	 *  of the <code>horizontalAlign</code>, <code>horizontalOffset</code>,
	 *  <code>horizontalDisplacement</code> and the number of indices the element
	 *  is from the <code>selectedIndex</code> property.
	 *  First the element is aligned using the <code>horizontalAlign</code> property
	 *  and then the <code>determined</code> is applied. The value of
	 *  <code>horizontalDisplacement</code> is then multiplied of the number of
	 *  elements the element is from the selected element.</p>
	 * 
	 *  @mxml
	 *
	 *  <p>The <code>&lt;st:TimeMachineLayout&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;st:TimeMachineLayout
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
	public class TimeMachineLayout extends PerspectiveAnimationNavigatorLayoutBase
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
		public function TimeMachineLayout()
		{
			super( INDIRECT );
			
			_maximumZChanged = true;
			useVirtualLayout = true
			_numVisibleElements = 3;
			_colorTransform = new ColorTransform();
			_depthColor = -1;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  The difference between the z property of displayed elements.
		 */
		private var _zDelta : Number;
		
		/**
		 *  @private
		 *  The difference in color of displayed elements express as a Numer from 0 - 1.
		 */
		private var _colorDelta : Number;
		
		/**
		 *  @private
		 *  A list of the elements in view.
		 */
		private var _visibleElements	: Vector.<IVisualElement>;
		
		/**
		 *  @private
		 *  The colorTransform used to apply the depthColor.
		 */
		private var _colorTransform	: ColorTransform;
		
		
		
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
		private var _horizontalOffset:Number = 0;
		
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
			return _horizontalOffset;
		}
		/**
		 *  @private
		 */
		public function set horizontalOffset(value:Number):void
		{
			if( _horizontalOffset == value ) return;
			
			_horizontalOffset = value;
			invalidateTargetDisplayList();
		}    
		
		
		//----------------------------------
		//  verticalOffset
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for verticalOffset.
		 */
		private var _verticalOffset:Number = 0;
		
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
			return _verticalOffset;
		}
		/**
		 *  @private
		 */
		public function set verticalOffset(value:Number):void
		{
			if( _verticalOffset == value ) return;
			
			_verticalOffset = value;
			invalidateTargetDisplayList();
		}    

		
		//----------------------------------
		//  maximumZ
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for maximumZ.
		 */
		private var _maximumZ : Number = 300;
		
		/**
		 *  @private
		 *  Flag to indicate whether maximumZ has changed.
		 */
		private var _maximumZChanged : Boolean;
		
		/**
		 *  The z difference between the first and last element in view.
		 *  
		 *  @default 300
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
			
			_maximumZChanged = true;
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
		 *  The amount to offset elements on the horizontal axis
		 *  depending on their z property.
		 *  
		 *  @depth 0
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
		 *  The amount to offset elements on the vertical axis
		 *  depending on their z property.
		 *  
		 *  @depth 0
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
		
		/**
		 *  @private
		 *  Util function for setting the color and depth of the first element in the layout.
		 */
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
		
		/**
		 *  @private
		 *  Util function for setting the color and depth of all elements in view
		 *  other than the first element.
		 */
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
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override public function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			if( _maximumZChanged )
			{
				_maximumZChanged = false;
				
				_zDelta = _maximumZ / ( _numVisibleElements + 1 );
				_colorDelta = 1 / ( _numVisibleElements );
			}
			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
		}
		
		/**
		 *  @private
		 */
		override protected function updateDisplayListVirtual():void
		{
			super.updateDisplayListVirtual();
			
			// Hack to force indices in view to be updated.
			if( numIndicesInView == -1 && numElementsInLayout ) updateIndicesInView();
			
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
		
		/**
		 *  @private
		 */
		override protected function updateDisplayListReal():void
		{
			super.updateDisplayListReal();
 			
			// Hack to force indices in view to be updated.
			if( numIndicesInView == -1 && numElementsInLayout ) updateIndicesInView();
			
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
		
//		override protected function updateSelectedIndex( index:int, offset:Number ):void
//		{
//			super.updateSelectedIndex( index, offset );
//			
//		}
		
		override protected function updateIndicesInView():void
		{
			
			super.updateIndicesInView();
			var firstIndexInView:int = selectedIndexOffset < 0 ? selectedIndex - 1 : selectedIndex;
			indicesInView( firstIndexInView, Math.min( _numVisibleElements, numElementsInLayout - firstIndexInView ) );
		}
//		override protected function selectedIndexChange():void
//		{
//			super.selectedIndexChange();
//			
//			var firstIndexInView:int;
//			
//			if( selectedIndexOffset < 0 )
//			{
//				firstIndexInView = selectedIndex - 1;
//			}
//			else
//			{
//				firstIndexInView = selectedIndex;
//			}
//			
//			trace( "selectedIndexChange", firstIndexInView, _numVisibleElements, numElementsInLayout, indicesInLayout );
//			indicesInView( firstIndexInView, Math.min( _numVisibleElements, numElementsInLayout - firstIndexInView ) );
//		}

	}
}