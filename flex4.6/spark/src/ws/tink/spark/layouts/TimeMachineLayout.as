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
	
	import ws.tink.spark.layouts.supportClasses.AnimationNavigatorLayoutBase;
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
			super( AnimationNavigatorLayoutBase.INDIRECT );
			
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
		public function set numVisibleElements( value:int ):void
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
		public function set depthColor( value:int ):void
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
		
		[Inspectable(category="General", defaultValue="300")]
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
		public function get maximumZ() : Number
		{
			return _maximumZ;
		}
		/**
		 *  @private
		 */
		public function set maximumZ( value:Number ):void
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
		public function get horizontalDisplacement():Number
		{
			return _horizontalDisplacement;
		}
		/**
		 *  @private
		 */
		public function set horizontalDisplacement( value:Number ):void
		{
			if( _horizontalDisplacement != value )
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
		public function get verticalDisplacement():Number
		{
			return _verticalDisplacement;
		}
		/**
		 *  @private
		 */
		public function set verticalDisplacement( value:Number ):void
		{
			if( _verticalDisplacement == value ) return;

			_verticalDisplacement = value;
			invalidateTargetDisplayList();
		}

		//----------------------------------
		//  alphaOutStart
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for alphaOutStart.
		 */
		private var _alphaOutStart:Number = 0;
		
		[Inspectable(category="General")]
		/**
		 *  The amount to offset elements on the vertical axis
		 *  depending on their z property.
		 *  
		 *  @alphaOutStart 0
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get alphaOutStart():Number
		{
			return _alphaOutStart;
		}
		/**
		 *  @private
		 */
		public function set alphaOutStart( value:Number ):void
		{
			if( _alphaOutStart == value ) return
			
			_alphaOutStart = value < 0 ? 0 : value;
			if( _alphaOutStart > _alphaOutEnd ) _alphaOutEnd = _alphaOutStart;
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  alphaOutEnd
		//---------------------------------- 
		
		/**
		 *  @private
		 *  Storage property for alphaOutEnd.
		 */
		private var _alphaOutEnd:Number = 1;
		
		[Inspectable(category="General")]
		/**
		 *  The amount to offset elements on the vertical axis
		 *  depending on their z property.
		 *  
		 *  @alphaOutStart 0
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get alphaOutEnd():Number
		{
			return _alphaOutEnd;
		}
		/**
		 *  @private
		 */
		public function set alphaOutEnd( value:Number ):void
		{
			if( _alphaOutEnd == value ) return
				
			_alphaOutEnd = value > 1 ? 1 : value;
			if( _alphaOutStart > _alphaOutEnd ) _alphaOutStart = _alphaOutEnd;
			invalidateTargetDisplayList();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Util function for setting the color and depth of all elements in view
		 *  other than the first element.
		 * 
		 *  @param element The element to transform.
		 *  @param viewIndex The index of this element in the layout.
		 *  @param indexOffset The decimal value of <code>animationValue</code>.
		 *  @para The alpha offset taking into account <code>alphaOutStart</code> and <code>alphaOutEnd/code>.
		 *  @para The alpha offset taking into account <code>alphaOutStart</code> and <code>alphaOutEnd/code>.
		 *  @param The percentage value of an elements z delta taking into account <code>maximumZ</code>
		 *  @param isFirst Whether this is the first index in the layout.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		protected function transformElement( element:IVisualElement, viewIndex:int, indexOffset:Number, alphaDeltaOffset:Number, zDeltaOffset:Number, isFirst:Boolean ):void
		{
			var colorValue:Number = ( ( _colorDelta * viewIndex ) - alphaDeltaOffset );
			setElementLayoutBoundsSize( element, false );
			element.depth = numIndicesInView - ( viewIndex + 1 );
			
			if( isFirst )
			{
				_colorTransform.redMultiplier = _colorTransform.greenMultiplier = _colorTransform.blueMultiplier = 1;
				
				if( indexOffset < _alphaOutStart )
				{
					_colorTransform.alphaMultiplier = 1;
				}
				else if( indexOffset > _alphaOutEnd )
				{
					_colorTransform.alphaMultiplier = 0;
				}
				else
				{
					var zeroed:Number = indexOffset - _alphaOutStart;
					var diff:Number = _alphaOutEnd - _alphaOutStart;
					
					_colorTransform.alphaMultiplier = 1 - ( 1 * ( zeroed / diff ) );
				}
				
				_colorTransform.redOffset = _colorTransform.greenOffset = _colorTransform.blueOffset = _colorTransform.alphaOffset = 0;
			}
			else if( _depthColor > -1 )
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
			matrix.appendTranslation( getTimeMachineElementX( unscaledWidth, element.getLayoutBoundsWidth( false ), viewIndex, indexOffset ),
				getTimeMachineElementY( unscaledHeight, element.getLayoutBoundsHeight( false ), viewIndex, indexOffset ),
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
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateDisplayListVirtual():void
		{
			super.updateDisplayListVirtual();
			
			var prevVirtualElements:Vector.<IVisualElement> = ( _visibleElements ) ? _visibleElements.concat() : new Vector.<IVisualElement>();
			_visibleElements = new Vector.<IVisualElement>();
			
			// The first index that this layout is showing
			// This may not be an element at all if the index is less than
			// the firstIndexInView or more than lastIndexInView.
			const firstIndexInLayout:Number = Math.floor( animationValue );
			
			// This decimal value of animationValue.
			const indexOffset:Number = animationValue - firstIndexInLayout;
			
			const zDeltaOffset:Number = _zDelta * indexOffset;
			const alphaDeltaOffset:Number = _colorDelta * indexOffset;
			
			var element:IVisualElement;
			for( var i:int = firstIndexInView; i < lastIndexInView; i++ )
			{
				element = target.getVirtualElementAt( indicesInLayout[ i ] );
				if( !element ) continue;
				transformElement( element, Math.abs( i - firstIndexInLayout ), indexOffset, alphaDeltaOffset, zDeltaOffset, i == firstIndexInLayout );
				updateVisibleElements( element, prevVirtualElements );
			}
			
			var numPrev:int = prevVirtualElements.length;
			for( i = 0; i < numPrev; i++ )
			{
				IVisualElement( prevVirtualElements[ i ] ).visible = false;
			}
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateDisplayListReal():void
		{
			super.updateDisplayListReal();
 			
//			var prevVirtualElements:Vector.<IVisualElement> = ( _visibleElements ) ? _visibleElements.concat() : new Vector.<IVisualElement>();
//			_visibleElements = new Vector.<IVisualElement>();
			
			// The first index that this layout is showing
			// This may not be an element at all if the index is less than
			// the firstIndexInView or more than lastIndexInView.
			const firstIndexInLayout:Number = Math.floor( animationValue );
			
			// This decimal value of animationValue.
			const indexOffset:Number = animationValue - firstIndexInLayout;
			
			const zDeltaOffset:Number = _zDelta * indexOffset;
			const alphaDeltaOffset:Number = _colorDelta * indexOffset;
			
			var element:IVisualElement;
			for( var i:int = 0; i < numElementsInLayout; i++ )
			{
				if( i < firstIndexInView || i > lastIndexInView )
				{
					element = target.getElementAt( indicesInLayout[ i ] );
					element.visible = false;
				}
				else
				{
					element = target.getVirtualElementAt( indicesInLayout[ i ] );
					transformElement( element, Math.abs( i - firstIndexInLayout ), indexOffset, alphaDeltaOffset, zDeltaOffset, i == firstIndexInLayout );
//					updateVisibleElements( element, prevVirtualElements );
				}
			}
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateIndicesInView():void
		{
			super.updateIndicesInView();
			
			const firstIndexInView:int = Math.max( Math.min( Math.floor( animationValue ), numElementsInLayout - 1 ), 0 );
			indicesInView( firstIndexInView, Math.min( _numVisibleElements, numElementsInLayout - firstIndexInView ) );
		}

	}
}