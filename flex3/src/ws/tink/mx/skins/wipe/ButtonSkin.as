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

package ws.tink.mx.skins.wipe
{

	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import mx.core.UIComponent;
	import mx.effects.Tween;
	import mx.events.FlexEvent;
	import mx.states.State;
	
	import ws.tink.utils.MathUtil;

	public class ButtonSkin extends UIComponent
	{
	
		public static var DEFAULT_TWEEN_DURATION	: int = 200;
		
		public static var UP			: String = "up";
		public static var DOWN			: String = "down";
		public static var LEFT			: String = "left";
		public static var RIGHT			: String = "right";
		
		public static var WIPE_ON		: String = "wipeOn";
		public static var WIPE_OFF		: String = "wipeOff";
		
		private var _background			: Sprite;
		private var _over				: Sprite;
		private var _mask				: Sprite;
		
		private var _tweenWipeTarget	: Number = 0;
		private var	_tweenWipe			: Tween;
		public var _tweenWipeValue		: Number = 0;
		
		private var _tweenAlphaTarget	: Number = 1;
		private var	_tweenAlpha			: Tween;
		public var _tweenAlphaValue		: Number = 1;
		
		private var _type				: String;
		private var _direction			: String;
		
		public function ButtonSkin()
		{
			super();
			
		}
		
		override public function get measuredWidth():Number
		{
			return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
		}
		
		override public function get measuredHeight():Number
		{
			return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
		}
	
		override protected function updateDisplayList( w:Number, h:Number ):void
		{
			super.updateDisplayList( w, h );
			
			var fillColors:Array = getStyle( "fillColors" );
			var fillAlphas:Array = getStyle( "fillAlphas" );
			var fillRatios:Array = getStyle( "fillRatios" );
			var topLeftCornerRadius:Number = getStyle( "topLeftCornerRadius" );
			var topRightCornerRadius:Number = getStyle( "topRightCornerRadius" );
			var bottomRightCornerRadius:Number = getStyle( "bottomRightCornerRadius" );
			var bottomLeftCornerRadius:Number = getStyle( "bottomLeftCornerRadius" );;
			
			_type = getStyle( "type" );
			_direction = getStyle( "direction" );
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( w, h, MathUtil.degreesToRadians( 90 ), 0, 0 );
			
			_background.graphics.clear();
			_background.graphics.beginGradientFill( GradientType.LINEAR, [ fillColors[ 0 ], fillColors[ 1 ] ], [ fillAlphas[ 0 ], fillAlphas[ 1 ] ], [ fillRatios[ 0 ], fillRatios[ 1 ] ], matrix );
			_background.graphics.drawRect( 0, 0, w, h );
			_background.graphics.endFill();
			
			_over.graphics.clear();
			_over.graphics.beginGradientFill( GradientType.LINEAR, [ fillColors[ 2 ], fillColors[ 3 ] ], [ fillAlphas[ 2 ], fillAlphas[ 3 ] ], [ fillRatios[ 2 ], fillRatios[ 3 ] ], matrix );
			_over.graphics.drawRect( 0, 0, w, h );
			_over.graphics.endFill();
			
			_mask.graphics.clear();
			_mask.graphics.beginFill( 0xFF0000 );
			_mask.graphics.drawRoundRectComplex( 0, 0, w, h, topLeftCornerRadius, topRightCornerRadius, bottomLeftCornerRadius, bottomRightCornerRadius );
			
			updateWipe( _tweenWipeValue );
		}
		
		override protected function createChildren():void
		{
			var state:State;

			_background = new Sprite();
			_over = new Sprite();
			_mask = new Sprite();
			mask = _mask;
			
			addChild( _background );
			addChild( _over );
			addChild( _mask );
			
			state = new State();
			state.addEventListener( FlexEvent.ENTER_STATE, onEnterState, false, 0, true );
			state.name = "up";
			states.push( state );
			
			state = new State();
			state.addEventListener( FlexEvent.ENTER_STATE, onEnterState, false, 0, true );
			state.name = "over";
			states.push( state );
			
			state = new State();
			state.addEventListener( FlexEvent.ENTER_STATE, onEnterState, false, 0, true );
			state.name = "down";
			states.push( state );
			
			state = new State();
			state.addEventListener( FlexEvent.ENTER_STATE, onEnterState, false, 0, true );
			state.name = "disabled";
			states.push( state );
			
			state = new State();
			state.addEventListener( FlexEvent.ENTER_STATE, onEnterState, false, 0, true );
			state.name = "selectedUp";
			states.push( state );
			
			state = new State();
			state.addEventListener( FlexEvent.ENTER_STATE, onEnterState, false, 0, true );
			state.name = "selectedOver";
			states.push( state );
			
			state = new State();
			state.addEventListener( FlexEvent.ENTER_STATE, onEnterState, false, 0, true );
			state.name = "selectedDown";
			states.push( state );
			
			state = new State();
			state.addEventListener( FlexEvent.ENTER_STATE, onEnterState, false, 0, true );
			state.name = "selectedDisabled";
			states.push( state );
			
			super.createChildren();
		}
		
		protected function onEnterState( event:FlexEvent ):void
		{
			switch( State( event.currentTarget ).name )
			{
				case "up" :
				{
					tweenAlpha( 1 );
					tweenWipe( 0 );
					break;
				}
				case "over" :
				{
					tweenAlpha( 1 );
					tweenWipe( 1 );
					break;
				}
				case "down" :
				{
					tweenAlpha( 1 );
					tweenWipe( 1 );
					break;
				}
				case "disabled" :
				{
					tweenAlpha( 0.5 );
					tweenWipe( 0 );
					break;
				}
				case "selectedUp" :
				{
					tweenAlpha( 1 );
					tweenWipe( 0.16 );
					break;
				}
				case "selectedOver" :
				{
					tweenAlpha( 1 );
					tweenWipe( 0.16 );
					break;
				}
				case "selectedDown" :
				{
					tweenAlpha( 1 );
					tweenWipe( 0.16 );
					break;
				}
				case "selectedDisabled" :
				{
					tweenAlpha( 0.5 );
					tweenWipe( 0.16 );
					break;
				}
				default :
				{
					tweenAlpha( 1 );
					tweenWipe( 0 );
				}
			}
		}
		
		private function tweenWipe( value:Number ):void
		{
			if( _tweenWipeTarget != value )
			{
				if( _tweenWipe ) _tweenWipe.pause();

				_tweenWipeTarget = value;
				
				_tweenWipe = new Tween( this, _tweenWipeValue, _tweenWipeTarget, ButtonSkin.DEFAULT_TWEEN_DURATION, -1, onTweenWipeUpdate, onTweenWipeEnd );
			}
		}
		
		public function onTweenWipeUpdate( value:Object ):void
		{
			var valueNum:Number = Number( value );
			
			if( !isNaN( valueNum ) ) updateWipe( valueNum );
		}
		
		public function onTweenWipeEnd( value:Object ):void
		{
			var valueNum:Number = Number( value );
			
			if( !isNaN( valueNum ) ) updateWipe( valueNum );
		}
		
		private function updateWipe( value:Number ):void
		{
			_tweenWipeValue = value;
			
			switch( _type )
			{
				case WIPE_ON :
				{
					wipeOn();
					break;
				}
				case WIPE_OFF :
				{
					wipeOff();
					break;
				}
			}
			
		}
		
		private function wipeOn():void
		{
			switch( _direction )
			{
				case UP :
				{
					_over.y = height * ( 1 - _tweenWipeValue );
					break;
				}
				case DOWN :
				{
					_over.y = -height * ( 1 - _tweenWipeValue );
					break;
				}
				case LEFT :
				{
					_over.x = width * ( 1 - _tweenWipeValue );
					break;
				}
				case RIGHT :
				{
					_over.x = -width * ( 1 - _tweenWipeValue );
					break;
				}
			}
		}
		
		private function wipeOff():void
		{
			switch( _direction )
			{
				case UP :
				{
					_over.y = -height * _tweenWipeValue;
					break;
				}
				case DOWN :
				{
					_over.y = height * _tweenWipeValue;
					break;
				}
				case LEFT :
				{
					_over.x = -width * _tweenWipeValue;
					break;
				}
				case RIGHT :
				{
					_over.x = width * _tweenWipeValue;
					break;
				}
			}
		}
		
		private function tweenAlpha( value:Number ):void
		{
			if( _tweenAlphaTarget != value )
			{
				if( _tweenAlpha ) _tweenAlpha.pause();
				
				_tweenAlphaTarget = value;
				
				_tweenAlpha = new Tween( this, _tweenAlphaValue, _tweenAlphaTarget, ButtonSkin.DEFAULT_TWEEN_DURATION, -1, onTweenAlphaUpdate, onTweenAlphaEnd );
			}
			
		}
		
		public function onTweenAlphaUpdate( value:Object ):void
		{
			_tweenAlphaValue = Number( value );
			
			_background.alpha = _over.alpha = _tweenAlphaValue;
		}
		
		public function onTweenAlphaEnd( value:Object ):void
		{
			_tweenAlphaValue = Number( value );
			
			_background.alpha = _over.alpha = _tweenAlphaValue;
		}
	}

}
