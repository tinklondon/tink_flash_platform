////////////////////////////////////////////////////////////////////////////////
//
//	Copyright (c) 2009 Tink Ltd | http://www.tink.ws
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
	
	import mx.containers.TileDirection;
	import mx.containers.utilityClasses.Layout;
	import mx.core.Container;
	import mx.core.EdgeMetrics;
	import mx.core.IUIComponent;
	
	public class ConstrainedTileLayout extends Layout
	{
		
		public var direction:String = TileDirection.HORIZONTAL;
		
		private var _hTileLayout		: TileLayout;
		private var _vTileLayout		: TileLayout;
		
		public function ConstrainedTileLayout()
		{
			initialize();
		}
		
		private function initialize():void
		{
			_hTileLayout = new TileLayout( TileDirection.HORIZONTAL );
			_vTileLayout = new TileLayout( TileDirection.VERTICAL );
		}
		
		override public function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			var target:Container = Container( super.target );
			
			var n:int = target.numChildren;
			if( n == 0 ) return;
			
			var vm:EdgeMetrics = target.viewMetricsAndPadding;
			
			var horizontalGap:Number = target.getStyle( "horizontalGap" );
			var verticalGap:Number = target.getStyle( "verticalGap" );
			
//			var paddingLeft:Number = target.getStyle( "paddingLeft" );
//			var paddingRight:Number = target.getStyle( "paddingRight" );
//			var paddingTop:Number = target.getStyle( "paddingTop" );
//			var paddingBottom:Number = target.getStyle( "paddingBottom" );
			
			var optimumLayout:Boolean = target.getStyle( "optimumLayout" );
			
			var heightRatio:Number = target.getStyle( "heightRatio" );
			if( heightRatio <= 0 || isNaN( heightRatio ) ) heightRatio = 1;
			
			var fillContainer:Boolean = target.getStyle( "fillContainer" );
			
			var minWidth:Number = ( target.scaleX > 0 && target.scaleX != 1 ) ? target.minWidth / Math.abs(target.scaleX) : target.minWidth;
			var minHeight:Number = ( target.scaleY > 0 && target.scaleY != 1 ) ? target.minHeight / Math.abs(target.scaleY) : target.minHeight;
			
			var w:Number = Math.max( unscaledWidth, minWidth ) - vm.right - vm.left;
			var h:Number = Math.max( unscaledHeight, minHeight ) - vm.bottom - vm.top;
			
			var tileLayout:TileLayout;
			
			if( optimumLayout )
			{
				_hTileLayout.update( n, w, h, horizontalGap, verticalGap, heightRatio, fillContainer );
				_vTileLayout.update( n, w, h, horizontalGap, verticalGap, heightRatio, fillContainer );
				
				tileLayout = ( _hTileLayout.tileWidth > _vTileLayout.tileWidth ) ? _hTileLayout : _vTileLayout;
			}
			
			var r:int;
			var c:int;
			var i:int = 0;
			
			var child:IUIComponent;
			switch( direction )
			{
				case TileDirection.HORIZONTAL :
				{
					if( !tileLayout )
					{
						_hTileLayout.update(  n, w, h, horizontalGap, verticalGap, heightRatio, fillContainer );
						tileLayout = _hTileLayout;
					}
					
					for( r = 0; r < tileLayout.numRows; r++ )
					{
						for( c = 0; c < tileLayout.numColumns; c++ )
						{
							updateChild( i, c, r, tileLayout, vm );
							
							i++;
							if( i == n ) break;
						}
					}
					break;
				}
				case TileDirection.VERTICAL :
				{
					if( !tileLayout )
					{
						_vTileLayout.update(  n, w, h, horizontalGap, verticalGap, heightRatio, fillContainer );
						tileLayout = _vTileLayout;
					}
					
					for( c = 0; c < tileLayout.numColumns; c++ )
					{
						for( r = 0; r < tileLayout.numRows; r++ )
						{
							updateChild( i, c, r, tileLayout, vm );
							
							i++;
							if( i == n ) break;
						}
					}
					break;
				}
			}
		}
		
		private function updateChild( i:int, c:int, r:int, t:TileLayout, vm:EdgeMetrics ):void
		{
			var child:IUIComponent = IUIComponent( target.getChildAt( i ) );
			child.setActualSize( t.tileWidth, t.tileHeight );
			child.move( vm.left + ( t.tileIncrementX * c ), vm.top + ( t.tileIncrementY * r ) );
		}
	}
}
import mx.containers.TileDirection;


internal class TileLayout
{
	
	private var _numColumns		: int;
	private var _numRows			: int;
	private var _tileWidth		: Number;
	private var _tileHeight		: Number;
	private var _tileIncrementX	: Number;
	private var _tileIncrementY 	: Number;
	
	private var _responseRatio:Number;
	private var _calcGap:Number;
	private var _calcSize:Number;
//	private var _numCalcItems:int;
//	private var _numReponseItems:int;
	private var _responseGap:int;
	private var _responseSize:Number;
	
	private var _direction		: String;
	
	public function TileLayout( direction:String )
	{
		_direction = direction;
	}
	
	public function get numColumns():int
	{
		return _numColumns;
	}
	
	public function get numRows():int
	{
		return _numRows;
	}
	
	public function get tileWidth():Number
	{
		return _tileWidth;
	}
	
	public function get tileHeight():Number
	{
		return _tileHeight;
	}
	
	public function get tileIncrementX():Number
	{
		return _tileIncrementX;
	}
	
	public function get tileIncrementY():Number
	{
		return _tileIncrementY;
	}
	
	public function update( numChildren:int, width:Number, height:Number, horizontalGap:Number, verticalGap:Number, heightRatio:Number, fillContainer:Boolean ):void
	{
		_numColumns = 0;
		_numRows = 0;
		
		switch( _direction )
		{
			case TileDirection.HORIZONTAL :
			{
				_responseRatio = heightRatio;
				
				do
				{
					_numColumns++;
					_calcGap = horizontalGap * ( _numColumns - 1 );
					_calcSize = ( width - _calcGap ) / _numColumns;
					
					_numRows = Math.ceil( numChildren / _numColumns );
					_responseGap = verticalGap * ( _numRows - 1 );
					_responseSize = ( ( _calcSize * _responseRatio ) * _numRows ) + _responseGap;
				}
				while( _responseSize > height );
				
				_tileWidth = _calcSize;
				_tileHeight = _calcSize * _responseRatio;
				break;
			}
			case TileDirection.VERTICAL :
			{
				_responseRatio = 1 / heightRatio;
				
				do
				{
					_numRows++;
					_calcGap = verticalGap * ( _numRows - 1 );
					_calcSize = ( height - _calcGap ) / _numRows;
					
					_numColumns = Math.ceil( numChildren / _numRows );
					_responseGap = horizontalGap * ( _numColumns - 1 );
					_responseSize = ( ( _calcSize * _responseRatio ) * _numColumns ) + _responseGap;
				}
				while( _responseSize > width );
				
				_tileWidth = _calcSize * _responseRatio;
				_tileHeight = _calcSize;
				break;
			}
		}
		
		if( fillContainer )
		{
			_tileIncrementX = _tileWidth + ( ( width - ( _tileWidth * _numColumns ) ) / ( _numColumns - 1 ) );
			_tileIncrementY = _tileHeight + ( ( height - ( _tileHeight * _numRows ) ) / ( _numRows - 1 ) );
		}
		else
		{
			_tileIncrementX = _tileWidth + horizontalGap;
			_tileIncrementY = _tileHeight + verticalGap;
		}
	}
}