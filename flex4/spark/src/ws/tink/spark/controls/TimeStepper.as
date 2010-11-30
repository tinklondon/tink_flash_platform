package ws.tink.spark.controls
{
	import flash.events.Event;
	
	import spark.components.Label;
	import spark.components.NumericStepper;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class TimeStepper extends SkinnableComponent
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
		public function TimeStepper()
		{
			super();
			
			_date = new Date( 0 );
			trace( _date );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var _date : Date;
		
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		
		[SkinPart( required="false" )]
		public var hourStepper : NumericStepper;
		
		[SkinPart( required="false" )]
		public var minuteStepper : NumericStepper;
		
		[SkinPart( required="false" )]
		public var secondStepper : NumericStepper;
		
		[SkinPart( required="false" )]
		public var millisecondStepper : NumericStepper;
		
		[SkinPart( required="false" )]
		public var meridiemDisplay : Label;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  allowValueWrap
		//----------------------------------
		
		/**
		 *  @private
		 *  Internal storage for the allowValueWrap property.
		 */
		private var _allowValueWrap : Boolean = true;
		
		/**
		 *  Comment
		 * 
		 *  @default true
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get allowValueWrap():Boolean
		{
			return _allowValueWrap;
		}
		/**
		 *  @private
		 */
		public function set allowValueWrap( value:Boolean ):void
		{
			if( _twelveHourClock == value ) return;
			
			_allowValueWrap = value;
			if( hourStepper ) hourStepper.allowValueWrap = _allowValueWrap;
			if( minuteStepper ) minuteStepper.allowValueWrap = _allowValueWrap;
			if( secondStepper ) secondStepper.allowValueWrap = _allowValueWrap;
			if( millisecondStepper ) millisecondStepper.allowValueWrap = _allowValueWrap;
		}
		
		
		//----------------------------------
		//  twelveHourClock
		//----------------------------------
		
		/**
		 *  @private
		 *  Internal storage for the twelveHourClock property.
		 */
		private var _twelveHourClock : Boolean;
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get twelveHourClock():Boolean
		{
			return _twelveHourClock;
		}
		/**
		 *  @private
		 */
		public function set twelveHourClock( value:Boolean ):void
		{
			if( _twelveHourClock == value ) return;
			
			_twelveHourClock = value;
			updateHourStepper();
		}
		
		
		//----------------------------------
		//  meridiem
		//----------------------------------
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get meridiem():String
		{
			if( _date.hours > 12 ) return "PM"; 
			var sub:uint = _date.minutes = _date.seconds + _date.milliseconds;
			return ( _date.hours > 11 && sub > 0 ) ? "PM" : "AM"
		}
		
		
		//----------------------------------
		//  time
		//----------------------------------
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get time():uint
		{
			return _date.time;
		}
		/**
		 *  @private
		 */
		public function set time( value:uint ):void
		{
			if( _date.time == value ) return;
			
			_date.time = value % 24;
			updateHourStepper();
			updateMinuteStepper();
			updateSecondStepper();
			updateMillisecondStepper();
		}
		
		
		//----------------------------------
		//  hours
		//----------------------------------
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get hours():uint
		{
			return _date.hours;
		}
		/**
		 *  @private
		 */
		public function set hours( value:uint ):void
		{
			if( _date.hours == value ) return;
			
			_date.hours = value % 24;
			updateHourStepper();
			updateMeridiemDisplay();
		}
		
		
		//----------------------------------
		//  minutes
		//----------------------------------
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get minutes():uint
		{
			return _date.minutes;
		}
		/**
		 *  @private
		 */
		public function set minutes( value:uint ):void
		{
			if( _date.minutes == value ) return;
			
			_date.minutes = value % 60;
			updateMinuteStepper();
			updateMeridiemDisplay();
		}
		
		
		//----------------------------------
		//  seconds
		//----------------------------------
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get seconds():uint
		{
			return _date.seconds;
		}
		/**
		 *  @private
		 */
		public function set seconds( value:uint ):void
		{
			if( _date.seconds == value ) return;
			
			_date.seconds = value % 60;
			updateSecondStepper();
			updateMeridiemDisplay();
		}
		
		
		//----------------------------------
		//  milliseconds
		//----------------------------------
		
		/**
		 *  Comment
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get milliseconds():uint
		{
			return _date.milliseconds;
		}
		/**
		 *  @private
		 */
		public function set milliseconds( value:uint ):void
		{
			if( _date.milliseconds == value ) return;
			
			_date.milliseconds = value % 60;
			updateMillisecondStepper();
			updateMeridiemDisplay();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		protected function updateHourStepper():void
		{
			if( !hourStepper ) return;
			
			hourStepper.snapInterval = 1;
			
			if( _twelveHourClock )
			{
				hourStepper.value = _date.hours % 12;
				hourStepper.maximum = 11;
			}
			else
			{
				hourStepper.value = _date.hours;
				hourStepper.maximum = 23;
			}
		}
		
		/**
		 *  @private
		 */
		protected function updateMinuteStepper():void
		{
			if( !minuteStepper ) return;
			
			minuteStepper.snapInterval = 1;
			minuteStepper.value = _date.minutes;
		}
		
		/**
		 *  @private
		 */
		protected function updateSecondStepper():void
		{
			if( !secondStepper ) return;
			
			secondStepper.snapInterval = 1;
		}
		
		/**
		 *  @private
		 */
		protected function updateMillisecondStepper():void
		{
			if( !millisecondStepper ) return;
			
			millisecondStepper.snapInterval = 1;
		}
		
		/**
		 *  @private
		 */
		protected function updateMeridiemDisplay():void
		{
			if( !meridiemDisplay ) return;
			
			meridiemDisplay.text = meridiem;
		}
		
		private function twoCharsFormatFunction( value:Number ):String
		{
			if( value < 10 ) return "0" + value.toString();
			return value.toString();
		}
		
		private function fourCharsFormatFunction( value:Number ):String
		{
			var s:String = value.toString();
			var padding:String = "";
			var numPadding:int = 4 - s.length;
			for( var i:int = 0; i < numPadding; i++ )
			{
				padding += "0";
			}
			return padding + s;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function partAdded( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );
			
			switch( instance )
			{
				case hourStepper :
				{
					updateHourStepper();
					hourStepper.valueFormatFunction = twoCharsFormatFunction;
					hourStepper.allowValueWrap = _allowValueWrap;
					hourStepper.addEventListener( Event.CHANGE, onHourStepperChange, false, 0, true );
					break;
				}
				case minuteStepper :
				{
					updateMinuteStepper();
					minuteStepper.maximum = 59;
					minuteStepper.valueFormatFunction = twoCharsFormatFunction;
					minuteStepper.allowValueWrap = _allowValueWrap;
					minuteStepper.addEventListener( Event.CHANGE, onMinuteStepperChange, false, 0, true );
					break;
				}
				case secondStepper :
				{
					updateSecondStepper();
					secondStepper.maximum = 59;
					secondStepper.valueFormatFunction = twoCharsFormatFunction;
					secondStepper.allowValueWrap = _allowValueWrap;
					secondStepper.addEventListener( Event.CHANGE, onSecondStepperChange, false, 0, true );
					break;
				}
				case millisecondStepper :
				{
					updateMillisecondStepper();
					millisecondStepper.maximum = 999;
					millisecondStepper.valueFormatFunction = fourCharsFormatFunction;
					millisecondStepper.allowValueWrap = _allowValueWrap;
					millisecondStepper.addEventListener( Event.CHANGE, onMillisecondsStepperChange, false, 0, true );
					break;
				}
				case meridiemDisplay :
				{
					updateMeridiemDisplay();
					break;
				}
			}
		}
		
		
		/**
		 *  @private
		 */
		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partRemoved( partName, instance );
			
			switch( instance )
			{
				case hourStepper :
				{
					hourStepper.removeEventListener( Event.CHANGE, onHourStepperChange, false );
					break;
				}
				case minuteStepper :
				{
					minuteStepper.removeEventListener( Event.CHANGE, onMinuteStepperChange, false );
					break;
				}
				case secondStepper :
				{
					secondStepper.removeEventListener( Event.CHANGE, onSecondStepperChange, false );
					break;
				}
				case millisecondStepper :
				{
					millisecondStepper.removeEventListener( Event.CHANGE, onMillisecondsStepperChange, false );
					break;
				}
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Listeners
		//
		//--------------------------------------------------------------------------
			
		private function onHourStepperChange( event:Event ):void
		{
			_date.hours = hourStepper.value;
			updateMeridiemDisplay();
		}
		
		private function onMinuteStepperChange( event:Event ):void
		{
			if( _date.minutes == 59 && minuteStepper.value == 0 ) hours++;
			if( _date.minutes == 0 && minuteStepper.value == 59 ) hours = hours == 0 ? 23 : hours - 1;
			_date.minutes = minuteStepper.value;
			updateMeridiemDisplay();
		}
		
		private function onSecondStepperChange( event:Event ):void
		{
			if( _date.seconds == 59 && secondStepper.value == 0 ) minutes++;
			if( _date.seconds == 0 && secondStepper.value == 59 ) minutes = minutes == 0 ? 59 : minutes - 1;
			_date.seconds = secondStepper.value;
			updateMeridiemDisplay();
		}
		
		private function onMillisecondsStepperChange( event:Event ):void
		{
			if( _date.milliseconds == 999 && secondStepper.value == 0 ) seconds++;
			if( _date.milliseconds == 0 && secondStepper.value == 999 ) seconds = seconds == 0 ? 59 : seconds--;
			_date.milliseconds = millisecondStepper.value;
			updateMeridiemDisplay();
		}
	}
}