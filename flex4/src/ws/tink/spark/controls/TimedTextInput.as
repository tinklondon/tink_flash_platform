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

package ws.tink.spark.controls
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	
	/**
	 *  TimedTextInput has all the functionality of TextInput 
	 *  but delays when the <code>spark.events.TextOperationEvent.CHANGE</code>
	 *  event is dispatched. This is useful if the text is being used as a filter.
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;s:TimedTextInput&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;st:TimedTextInput
	 *    <strong>Properties</strong>
	 *    delay="<i>1000</i>"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see spark.components.TextInput
	 *  @see spark.skins.spark.TextInputSkin
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class TimedTextInput extends TextInput
	{
		
		public var DEFAULT_DELAY	: Number = 1000;
		
		private var _timer			: Timer;
		private var _dispatchChange	: Boolean;
		private var _lastEvent		: TextOperationEvent;
		
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
		public function TimedTextInput()
		{
			super();
			
			addEventListener( TextOperationEvent.CHANGE, onChange, false, 0, true );
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 *  @private
		 *  Storage propwerty of delay
		 */
		private var _delay		: Number = DEFAULT_DELAY;
		
		//----------------------------------
		//  delay
		//----------------------------------
		
		/**
		 *  The time to wait after the last change has taken place before dispatching
		 *  the <code>spark.events.TextOperationEvent.CHANGE</code> event.
		 * 	
		 * 	@default 1000
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get delay():Number
		{
			return _delay;
		}
		public function set delay( value:Number ):void
		{
			if( _delay == value ) return;
			
			_delay = value;
			if( _timer ) _timer.delay = _delay;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  createChildren
		//----------------------------------
		/** 
		 * @private 
		 */ 
		override protected function createChildren():void
		{
			super.createChildren();
			
			_timer = new Timer( _delay, 0 );
			_timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true );
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 *  @private
		 *  Listener for the change event which checks to see if
		 *  the event should be dispatched or not.
		 */
		private function onChange( event:TextOperationEvent ):void
		{
			if( !_dispatchChange )
			{
				startTimer();
				_lastEvent = event;
				event.stopImmediatePropagation();
			}
		}
		
		/**
		 *  @private
		 *  Listener for the Timer. When complete the last
		 *  <code>spark.events.TextOperationEvent.CHANGE</code> event
		 *  is dispatched.
		 */
		private function onTimerComplete( event:TimerEvent ):void
		{
			_timer.reset();
			_dispatchChange = true;
			dispatchEvent( _lastEvent );
			_lastEvent = null;
			_dispatchChange = false;
		}
		
		/**
		 *  @private
		 */
		private function startTimer():void
		{
			_timer.stop();
			_timer.reset();
			_timer.delay = _delay;
			_timer.repeatCount = 1;
			_timer.start();
		}
	}
}