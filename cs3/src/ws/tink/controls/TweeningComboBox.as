/*
Copyright (c) 2008 Tink Ltd - http://www.tink.ws

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

package ws.tink.controls
{
	
	import fl.controls.ComboBox;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class TweeningComboBox extends ComboBox
	{
		
		public static var DEFAULT_TWEEN_DURATION	: Number = 0.5;
		
		public var _tweenValue						: Number = 0;
		
		private var _tween							: Tween;
		private var _tweenDuration					: Number = DEFAULT_TWEEN_DURATION;
		private var _tweenTarget					: Number = 0;
		
		private var _listMask						: Shape;				
				
		public function TweeningComboBox()
		{
			super();
		}

		public function get percentOpen():Number
		{
			return _tweenValue;
		}
		
		public function get tweenDuration():Number
		{
			return _tweenDuration;
		}
		public function set tweenDuration( value:Number ):void
		{
			if( value > 0 ) _tweenDuration = value;
		}
		
		override public function open():void
		{
			currentIndex = selectedIndex;
			if (isOpen || length == 0) { return; }

			dispatchEvent(new Event(Event.OPEN));
			isOpen = true;

			// Add a listener to the stage to close the combobox when something
			// else is clicked.  We need to wait a frame, otherwise the same click
			// that opens the comboBox will also close it.
			addEventListener( Event.ENTER_FRAME, addOverridingCloseListener, false, 0, true);			

			positionList();
			list.scrollToSelected();
			
			addChild( list );
			addChild( _listMask );
			
			tweenList( 1 );
		}

		override public function close():void
		{
			highlightCell();
			highlightedCell = -1;
			if (! isOpen) { return; }
			
			dispatchEvent(new Event(Event.CLOSE));
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageClick);
			isOpen = false;

			tweenList( 0 );
		}
		
		private function addOverridingCloseListener( event:Event ):void
		{
			removeEventListener( Event.ENTER_FRAME, addOverridingCloseListener );
			if( !isOpen ) return;
			stage.addEventListener( MouseEvent.MOUSE_DOWN, onStageClick, false, 0, true);
		}

		override protected function configUI():void
		{
			super.configUI();

			_listMask = new Shape();
			_listMask.graphics.beginFill( 0x000000, 1 );
			_listMask.graphics.drawRect( 0, 0, 100, 100 );
			_listMask.graphics.endFill();
			
			list.mask = _listMask;
		}
		
		override protected function positionList():void
		{
			var p:Point = localToGlobal( new Point( 0, 0 ) );
			list.x = p.x;
			list.y = p.y + height - list.height;

			_listMask.width = list.width;
			_listMask.height = list.height + 4;
			_listMask.y = height;
		}
		
		private function tweenList( target:int ):void
		{
			if( target != _tweenTarget )
			{
				_tweenTarget = target;
				
				if( _tween )
				{
					_tween.stop();
					_tween.removeEventListener( TweenEvent.MOTION_CHANGE, onTweenMotionChange );
					_tween.removeEventListener( TweenEvent.MOTION_FINISH, onTweenMotionChange );
				}

				_tween = new Tween( this, "_tweenValue", Regular.easeOut, _tweenValue, target, _tweenDuration, true );
				_tween.addEventListener( TweenEvent.MOTION_CHANGE, onTweenMotionChange, false, 0, true );
				_tween.addEventListener( TweenEvent.MOTION_FINISH, onTweenMotionFinish, false, 0, true );
			}
		}
		
		protected function onTweenMotionChange( event:TweenEvent ):void
		{
			var p:Point = localToGlobal( new Point( 0,0 ) );
			var startY:Number = p.y + height - list.height;
			
			list.y = startY + ( list.height * _tweenValue );
			
			dispatchEvent( event );
		}
		
		protected function onTweenMotionFinish( event:TweenEvent ):void
		{
			if( _tweenValue == 0 )
			{
				removeChild( list );
				removeChild( _listMask );
			}

			dispatchEvent( event );
		}
	}
}