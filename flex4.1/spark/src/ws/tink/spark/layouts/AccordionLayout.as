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
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import mx.containers.TileDirection;
	import mx.core.ISelectableList;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	
	import spark.components.supportClasses.ButtonBarBase;
	import spark.components.supportClasses.GroupBase;
	import spark.effects.animation.Animation;
	
	import ws.tink.spark.layouts.supportClasses.AnimationNavigatorLayoutBase;

	use namespace mx_internal;
	
	/**
	 * Flex 4 Accordion Layout
	 */
	public class AccordionLayout extends AnimationNavigatorLayoutBase
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
		public function AccordionLayout()
		{
			trace( "AccordionLayout", DIRECT );
			super( AnimationNavigatorLayoutBase.DIRECT );
			_buttonLayout = new ButtonLayout( this );
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var _proposedSelectedIndexOffset	: Number = 0;
		
		/**
		 *  @private
		 */
		private var _buttonLayout:ButtonLayout;
		
		/**
		 *  @private
		 */
		private var _elementSizes:Vector.<ElementSize> = new Vector.<ElementSize>();
		
		/**
		 *  @private
		 */
		private var _animator:Animation;
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  buttonRotation
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for buttonRotation.
		 */
		private var _buttonRotation:String = "none";
		
		[Inspectable(category="General", enumeration="none,left,right", defaultValue="none")]
		
		/** 
		 *  rotateButtonBar.
		 * 
		 *  @default "vertical"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get buttonRotation():String
		{
			return _buttonRotation;
		}
		/**
		 *  @private
		 */
		public function set buttonRotation( value:String ):void
		{
			if( value == _buttonRotation ) return;
			
			_buttonRotation = value;
			
			_elementSizesInvalid = true;
			_buttonLayout.invalidateTargetDisplayList();
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  direction
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for direction.
		 */
		private var _direction:String = TileDirection.VERTICAL;
		
		[Inspectable(category="General", enumeration="vertical,horizontal", defaultValue="vertical")]
		
		/** 
		 *  direction.
		 * 
		 *  @default "vertical"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get direction():String
		{
			return _direction;
		}
		/**
		 *  @private
		 */
		public function set direction( value:String ):void
		{
			if( value == _direction ) return;
			
			_direction = value;
			
			_elementSizesInvalid = true;
			_buttonLayout.invalidateTargetDisplayList();
			invalidateTargetDisplayList();
		}
		
		
		//----------------------------------
		//  minElementSize
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for minElementSize.
		 */
		private var _minElementSize:Number = 0;
		
		/** 
		 *  The minumm size of an element when it's element index isn't the
		 *  selectedIndex of the layout.
		 * 
		 *  @default 0
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get minElementSize():Number
		{
			return _minElementSize;
		}
		/**
		 *  @private
		 */
		public function set minElementSize( value:Number ):void
		{
			if( value == _minElementSize ) return;
			
			_minElementSize = value;
			
			_elementSizesInvalid = true;
			invalidateTargetDisplayList();
		}
		
		
//		//----------------------------------
//		//  verticalAlign
//		//----------------------------------    
//		
//		/**
//		 *  @private
//		 *  Storage property for verticalAlign.
//		 */
//		private var _verticalAlign:String = VerticalAlign.JUSTIFY;
//		
//		[Inspectable(category="General", enumeration="top,bottom,middle,justify,contentJustify", defaultValue="justify")]
//		
//		/** 
//		 *  The vertical alignment of layout elements.
//		 * 
//		 *  <p>If the value is <code>"bottom"</code>, <code>"middle"</code>, 
//		 *  or <code>"top"</code> then the layout elements are aligned relative 
//		 *  to the container's <code>contentHeight</code> property.</p>
//		 * 
//		 *  <p>If the value is <code>"contentJustify"</code> then the actual
//		 *  height of the layout element is set to 
//		 *  the container's <code>contentHeight</code> property. 
//		 *  The content height of the container is the height of the largest layout element. 
//		 *  If all layout elements are smaller than the height of the container, 
//		 *  then set the height of all the layout elements to the height of the container.</p>
//		 * 
//		 *  <p>If the value is <code>"justify"</code> then the actual height
//		 *  of the layout elements is set to the container's height.</p>
//		 *
//		 *  <p>This property does not affect the layout's measured size.</p>
//		 *  
//		 *  @default "justify"
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get verticalAlign():String
//		{
//			return _verticalAlign;
//		}
//		/**
//		 *  @private
//		 */
//		public function set verticalAlign( value:String ):void
//		{
//			if( value == _verticalAlign ) return;
//			
//			_verticalAlign = value;
//			
//			invalidateTargetDisplayList();
//		}
//		
//		
//		//----------------------------------
//		//  horizontalAlign
//		//----------------------------------  
//		
//		/**
//		 *  @private
//		 *  Storage property for horizontalAlign.
//		 */
//		private var _horizontalAlign:String = HorizontalAlign.JUSTIFY;
//		
//		[Inspectable(category="General", enumeration="left,right,center,justify,contentJustify", defaultValue="justify")]
//		
//		/** 
//		 *  The horizontal alignment of layout elements.
//		 *  If the value is <code>"left"</code>, <code>"right"</code>, or <code>"center"</code> then the 
//		 *  layout element is aligned relative to the container's <code>contentWidth</code> property.
//		 * 
//		 *  <p>If the value is <code>"contentJustify"</code>, then the layout element's actual
//		 *  width is set to the <code>contentWidth</code> of the container.
//		 *  The <code>contentWidth</code> of the container is the width of the largest layout element. 
//		 *  If all layout elements are smaller than the width of the container, 
//		 *  then set the width of all layout elements to the width of the container.</p>
//		 * 
//		 *  <p>If the value is <code>"justify"</code> then the layout element's actual width
//		 *  is set to the container's width.</p>
//		 *
//		 *  <p>This property does not affect the layout's measured size.</p>
//		 *  
//		 *  @default "justify"
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion Flex 4
//		 */
//		public function get horizontalAlign():String
//		{
//			return _horizontalAlign;
//		}
//		/**
//		 *  @private
//		 */
//		public function set horizontalAlign( value:String ):void
//		{
//			if( value == _horizontalAlign ) return;
//			
//			_horizontalAlign = value;
//			
//			invalidateTargetDisplayList();
//		}
		
		
		//----------------------------------
		//  buttonBar
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for buttonBar.
		 */
		private var _buttonBar:ButtonBarBase;
		
		/**
		 *  useScrollRect
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get buttonBar():ButtonBarBase
		{
			return _buttonBar;
		}
		/**
		 *  @private
		 */
		public function set buttonBar( value:ButtonBarBase ):void
		{
			if( _buttonBar == value ) return;
			_buttonBar = value;
			
			if( _buttonBar )
			{
				_buttonBar.layout = _buttonLayout;
				_buttonBar.setActualSize( unscaledWidth, unscaledHeight );
				
				if( _buttonBar && target is ISelectableList ) _buttonBar.dataProvider = ISelectableList( target );
			}
		}
		
		
		//----------------------------------
		//  useScrollRect
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for useScrollRect.
		 */
		private var _useScrollRect:Boolean = false;
		
		/**
		 *  useScrollRect
		 * 
		 *  @default true
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get useScrollRect():Boolean
		{
			return _useScrollRect;
		}
		/**
		 *  @private
		 */
		public function set useScrollRect( value:Boolean ):void
		{
			if( _useScrollRect == value ) return;
			
			_useScrollRect = value;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  target
		//----------------------------------    
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override public function set target(value:GroupBase):void
		{
			if( target == value ) return;

			super.target = value;
			
			if( _buttonBar && target is ISelectableList ) _buttonBar.dataProvider = ISelectableList( target );
		}
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		private var _elementSizesInvalid:Boolean;
		
		public function invalidateElementSizes():void
		{
			_elementSizesInvalid = true;
			invalidateTargetDisplayList();
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if( this.unscaledWidth != unscaledWidth || this.unscaledHeight != unscaledHeight )
			{
				_elementSizesInvalid = true;
				_buttonLayout.invalidateTargetDisplayList();
				if( _buttonBar )
				{
//					_buttonBar.measuredWidth = _buttonBar.measuredMinWidth = unscaledWidth;
//					_buttonBar.measuredHeight = _buttonBar.measuredMinHeight = unscaledHeight;
					_buttonBar.width = unscaledWidth;
					_buttonBar.height = unscaledHeight;
				}
			}
//			if( _buttonBar )//&& ( this.unscaledWidth != unscaledWidth || this.unscaledHeight != unscaledHeight ) ) _buttonBar.invalidateSize();
//			{
////				_buttonBar.setLayoutBoundsSize( unscaledWidth, unscaledHeight );
////				_buttonBar.setActualSize( unscaledWidth, unscaledHeight );
//				_buttonBar.width = unscaledWidth;
//				_buttonBar.height = unscaledHeight;
//			}
			super.updateDisplayList( unscaledWidth, unscaledHeight );
		}
		
		
		private function updateDisplayListElements():void
		{
			var prevSize:Number;
			var elementSize:ElementSize;
			var element:IVisualElement;
			var elementPos:Number = 0;
			const offsetMultiplier:Number = 1 - animationValue;
			const numElements:int = _elementSizes.length;
			for( var i:int = 0; i < numElements; i++ )
			{
				if( _buttonLayout._buttonSizes.length > i )
				{
					element = _buttonLayout.target.getElementAt( i );
					if( direction == TileDirection.VERTICAL )
					{
						element.setLayoutBoundsPosition( 0, elementPos );
					}
					else
					{
						element.setLayoutBoundsPosition( elementPos, 0 );
					}
					elementPos += _buttonLayout._buttonSizes[ i ];
				}
				
				elementSize = _elementSizes[ i ];
				prevSize = elementSize.size;
				elementSize.size = elementSize.start + ( elementSize.diff * offsetMultiplier );
				
				// Get every element if we are not virtual
				if( !useVirtualLayout )
				{
					elementSize.element = target.getElementAt( elementSize.index );
				}
				else if( minElementSize > 0 || elementSize.size > 0 )
				{
					elementSize.element = target.getVirtualElementAt( elementSize.index );
				}
				
				// Only apply to items with a height bigger than 0 to support virtualization.
				if( ( elementSize.size > 0 || prevSize > 0 ) && elementSize.element )
				{
					if( direction == TileDirection.VERTICAL )
					{
						if( _useScrollRect && elementSize.element is DisplayObject )
						{
							DisplayObject( elementSize.element ).scrollRect = new Rectangle( 0, 0, unscaledWidth, elementSize.size );
							elementSize.element.setLayoutBoundsSize( unscaledWidth, unscaledHeight - _buttonLayout._totalSize );
						}
						else
						{
							elementSize.element.setLayoutBoundsSize( unscaledWidth, elementSize.size );
						}
						
						elementSize.element.setLayoutBoundsPosition( 0, elementPos );
					}
					else
					{
						if( _useScrollRect && elementSize.element is DisplayObject )
						{
							DisplayObject( elementSize.element ).scrollRect = new Rectangle( 0, 0, elementSize.size, unscaledHeight );
							elementSize.element.setLayoutBoundsSize( unscaledWidth - _buttonLayout._totalSize, unscaledHeight );
						}
						else
						{
							elementSize.element.setLayoutBoundsSize( elementSize.size, unscaledHeight );
						}
						
						elementSize.element.setLayoutBoundsPosition( elementPos, 0 );
					}
					
					
					elementPos += elementSize.size;
				}
			}
		}
		
		/**
		 *  @inheritDoc
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateDisplayListVirtual():void
		{
			super.updateDisplayListVirtual();		
			
			if( _elementSizesInvalid ) 
			{
				_elementSizesInvalid = false;
				updateElementSizes( target.getVirtualElementAt( indicesInLayout[ selectedIndex ] ) );
			}
			
			updateDisplayListElements();
		}
		
		
		/**
		 *  @inheritDoc
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function updateDisplayListReal():void
		{
			super.updateDisplayListReal();

			if( _elementSizesInvalid ) 
			{
				_elementSizesInvalid = false;
				updateElementSizes( target.getElementAt( indicesInLayout[ selectedIndex ] ) );
			}
			
			updateDisplayListElements();
		}
		
		private function updateElementSizes( selectedElement:IVisualElement ):void
		{
			var size:Number = direction == TileDirection.VERTICAL ? unscaledHeight : unscaledWidth;
			var availableSpace:Number = size - _buttonLayout._totalSize - ( minElementSize * ( numElementsInLayout - 1 ) );
			var numElementSizes:int = _elementSizes.length;
			
			var i:int
			
			var index:int;
			var elementSize:ElementSize;
			
			var indicesFound:Vector.<int> = new Vector.<int>();
			
			// Remove ElementSize items that are not in the layout.
			for( i = numElementSizes - 1; i >= 0; i-- )
			{
				elementSize = _elementSizes[ i ];
				index = indicesInLayout.indexOf( elementSize.index );
				if( index == -1 )
				{
					_elementSizes.splice( i, 1 );
				}
				else
				{
					if( elementSize.index == selectedIndex ) elementSize.element = selectedElement;
					updateElementSize( elementSize, index, availableSpace );
					indicesFound.push( elementSize.index );
				}
			}
			
			// If we need to create some ElementSize items.
			var numRequired:uint = numElementsInLayout - numElementSizes;
			if( numRequired > 0 )
			{
				for( i = 0; i < numElementsInLayout; i++ )
				{
					index = indicesInLayout[ i ];
					if( indicesFound.indexOf( index ) == -1 )
					{
						elementSize = new ElementSize();
						elementSize.start = minElementSize;
						elementSize.diff = 0;
						elementSize.size = 0;
						elementSize.index = index;
						if( i == selectedIndex ) elementSize.element = selectedElement;
						updateElementSize( elementSize, index, availableSpace );
						_elementSizes.push( elementSize );
					}
				}
				
				 // If we've added items we now need to do a sort
				_elementSizes.sort( sortElementSizes );
			}
		}
			
		private function sortElementSizes( a:ElementSize, b:ElementSize ):int
		{
			if( a.index < b.index ) return -1;
			if( a.index > b.index ) return 1;
			return 0;
		}
		
		private function updateElementSize( elementSize:ElementSize, i:int, availableSpace:Number ):void
		{
			if( !useVirtualLayout ) elementSize.element = target.getElementAt( indicesInLayout[ i ] );
			
			if( elementSize.element && ( elementSize.start != 0 || elementSize.diff != 0 || i == selectedIndex ) )
			{
				elementSize.start = elementSize.size;
				elementSize.diff = ( i == selectedIndex ) ? availableSpace - elementSize.start : minElementSize - elementSize.start;
			}
		}
		
		
		override protected function invalidateSelectedIndex(index:int, offset:Number):void
		{
			super.invalidateSelectedIndex( index, offset );
			invalidateElementSizes();
		}
		
		override protected function updateIndicesInView():void
		{
			super.updateIndicesInView();
			indicesInView( 0, numElementsInLayout );
		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override protected function restoreElement( element:IVisualElement ):void
		{
			super.restoreElement( element );
			
			if( element is DisplayObject ) DisplayObject( element ).scrollRect = null;
		}
		

        
    }
}
import flash.geom.Matrix;

import mx.containers.TileDirection;
import mx.core.IVisualElement;

import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;

import ws.tink.spark.layouts.AccordionLayout;


internal class ElementSize
{
	public var start:Number;
	public var diff:Number;
	public var size:Number;
	public var element:IVisualElement;
	public var index:uint;
}

internal class ButtonLayout extends LayoutBase
{
	
	private var _parentLayout:AccordionLayout;
	public var _buttonSizes:Vector.<int> = new Vector.<int>();
	public var _totalSize:int = 0;
	public var _rotation:Number;
	
	public function ButtonLayout( parentLayout:AccordionLayout ):void
	{
		_parentLayout = parentLayout;
	}
	
//	override public function measure():void
//	{
//		target.measuredWidth = target.measuredMinWidth = _parentLayout.unscaledWidth;
//		target.measuredHeight = target.measuredMinHeight = _parentLayout.unscaledHeight;
//	}
	
	public function invalidateTargetDisplayList() : void
	{
		if( !target ) return;
		target.invalidateDisplayList();
	}
	
	override public function set target( value:GroupBase ):void
	{
		_totalSize = 0;
		_buttonSizes.splice( 0, _buttonSizes.length );
		super.target = value;
	}
	override public function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
	{
		super.updateDisplayList( unscaledWidth, unscaledHeight );
		
		if( !target ) return;
		
		var matrix:Matrix;
		var rotation:Number = _parentLayout.buttonRotation == "none" ? 0 : _parentLayout.buttonRotation == "left" ? -90 : 90;
		if( rotation != _rotation )
		{
			_rotation = rotation;
			matrix = new Matrix();
			matrix.rotate( _rotation * ( Math.PI / 180 ) );
		}
			
		_totalSize = 0;
		var element:IVisualElement;
		var size:Number;
		const numElements:int = target.numElements;
		for( var i:int = 0; i < numElements; i++ )
		{
			element = target.getElementAt( i );
			
			if( matrix ) element.setLayoutMatrix( matrix, true );
			
			if( _parentLayout.direction == TileDirection.VERTICAL  )
			{
				size = element.getPreferredBoundsHeight();
				element.setLayoutBoundsSize( unscaledWidth, size );
			}
			else
			{
				
				size = element.getPreferredBoundsWidth();
				element.setLayoutBoundsSize( size, unscaledHeight );
			}

			
			if( i < numElements - 1 ) size--;
			_totalSize += size;
			_buttonSizes[ i ] = size;
		}
		
		_parentLayout.invalidateElementSizes();
	}
	
}
